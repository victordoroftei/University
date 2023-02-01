package client_server;

import client_server.domain.*;
import client_server.logic.CereriActiveMap;
import client_server.repo.RepoPlati;
import client_server.repo.RepoProgramari;
import client_server.utils.Utils;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Future;
import java.util.concurrent.RejectedExecutionException;

public class MyJob implements Runnable {
    private final Socket client;

    private final ExecutorService executorService;

    private final CereriActiveMap cereriActiveMap;

    private final RepoProgramari repoProgramari;
    private final RepoPlati repoPlati;

    private final int[] costTratamente;
    private final int[] timpTratamente;

    private final int[][] nrClientiMax;

    public MyJob(
            Socket client,
            ExecutorService executorService,
            CereriActiveMap cereriActiveMap,
            RepoProgramari repoProgramari,
            RepoPlati repoPlati,
            int[] costTratamente,
            int[] timpTratamente,
            int[][] nrClientiMax
    ) {
        this.client = client;
        this.executorService = executorService;
        this.cereriActiveMap = cereriActiveMap;
        this.repoProgramari = repoProgramari;
        this.repoPlati = repoPlati;
        this.costTratamente = costTratamente;
        this.timpTratamente = timpTratamente;
        this.nrClientiMax = nrClientiMax;
    }

    @Override
    public void run() {
        ObjectInputStream inputStream;
        Object request;

        try {
            inputStream = new ObjectInputStream(client.getInputStream());
            request = inputStream.readObject();
        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        if (request instanceof Programare programare) {
            try {
                Future<CererePlata> cererePlataFuture = plaseazaProgramare(programare);
                cereriActiveMap.addFuture(client, cererePlataFuture);
            } catch (RejectedExecutionException exception) {
                try {
                    ObjectOutputStream outputStream = new ObjectOutputStream(client.getOutputStream());
                    outputStream.writeObject(RaspunsServer.SERVER_OPRIT);
                    outputStream.close();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }

        } else if (request instanceof Plata plata) {
            plata.setDataPlata(LocalDateTime.now());

            if (plata.getSuma() > 0) {  // Daca este vorba de o plata normala
                synchronized (repoPlati) {
                    repoPlati.add(plata);
                }
            }

            else {  // Daca avem o anulare
                synchronized (repoProgramari) {
                    repoProgramari.delete(plata.getIdProgramare()); // Stergem programarea
                    synchronized (repoPlati) {
                        repoPlati.add(plata);   // Adaugam plata cu suma negativa
                    }
                }
            }

        } else {
            throw new RuntimeException("Obiect invalid primit la request!");
        }
    }

    private Future<CererePlata> plaseazaProgramare(Programare programare) {
        return executorService.submit(() -> {
            Ora ora1 = programare.getOra();
            Ora ora2 = ora1.adaugaMinute(timpTratamente[programare.getTipTratament()]);

            RaspunsServer raspunsServer;
            Integer idProgramare = null;
            synchronized (repoProgramari) {
                // Luam programarile in aceeasi locatie, si cu acelasi tip
                List<Programare> programariFiltrate = repoProgramari.getProgramariByLocatieAndTip(
                        programare.getLocatieTratament(),
                        programare.getTipTratament()
                );

                int suprapuneri = 0;

                // Verificam cate programari se afla la aceeasi ora
                for (Programare programareFiltrata : programariFiltrate) {
                    Ora oraFiltrata1 = programareFiltrata.getOra();
                    Ora oraFiltrata2 = oraFiltrata1.adaugaMinute(timpTratamente[programare.getTipTratament()]);

                    if (Utils.existaSuprapunereIntreOre(ora1, ora2, oraFiltrata1, oraFiltrata2)) {
                        suprapuneri++;
                    }
                }

                // Verificam daca nu se depaseste nr. maxim de programari admise pentru un tratament
                if (suprapuneri < nrClientiMax[programare.getLocatieTratament()][programare.getTipTratament()]) {
                    idProgramare = repoProgramari.add(programare).getIdProgramare();    // adaugam programarea
                    raspunsServer = RaspunsServer.PROGRAMARE_REUSITA;
                } else {
                    raspunsServer = RaspunsServer.PROGRAMARE_ESUATA;
                }
            }

            int treatmentPrice = costTratamente[programare.getTipTratament()];
            return new CererePlata(idProgramare, raspunsServer, treatmentPrice);    // facem o cerere de plata cu pretul tratamentului
        });
    }
}
