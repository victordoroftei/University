package client_server;

import client_server.domain.Ora;
import client_server.domain.Programare;
import client_server.logic.CereriActiveMap;
import client_server.logic.ThreadProgramari;
import client_server.repo.RepoPlati;
import client_server.repo.RepoProgramari;
import client_server.utils.Utils;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class Server {
    private static final Integer PORT = 42069;
    private static final Long TIMP_RULARE = 60L;
    private static final Integer INTEVAL_TIMP = 15;

    private static int verificareCurenta = 1;
    private static int nrLocatii;
    private static int nrTratamente;

    private static int[] costTratamente;
    private static int[] timpTratamente;
    private static int[][] nrClientiMaxPerTratament;

    private static ExecutorService executor;
    private static final ScheduledExecutorService SCHEDULED_EXECUTOR_SERVICE = Executors.newSingleThreadScheduledExecutor();

    private static final RepoProgramari REPO_PROGRAMARI = new RepoProgramari();
    private static final RepoPlati REPO_PLATI = new RepoPlati();

    private static final CereriActiveMap CERERI_ACTIVE_MAP = new CereriActiveMap();

    private static final Integer INITIAL_DELAY = 10;
    private static final Integer PERIOD = 10;
    private static final String OUTPUT_FILE = "output10.txt";

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public static void main(String[] args) throws IOException, InterruptedException {
        initializeazaServer();

        ServerSocket serverSocket = new ServerSocket(PORT);
        System.out.println("Server pornit\n");

        // Initializam thread-ul ce se ocupa cu cererile active
        ThreadProgramari threadProgramari = new ThreadProgramari(CERERI_ACTIVE_MAP);
        threadProgramari.start();

        // Pornim sistemul de verificare
        pornireSistemVerificare();
        var startTime = System.currentTimeMillis();

        while (true) {
            if (System.currentTimeMillis() - startTime > TIMP_RULARE * 1000) {
                System.out.println("Inceput shutdown\n");
                SCHEDULED_EXECUTOR_SERVICE.shutdown();
                CERERI_ACTIVE_MAP.opresteServer();
                oprireServer(executor);
                break;
            }

            Socket client = serverSocket.accept();
            System.out.println("Server: Request Primit!\n");
            MyJob job = new MyJob(
                    client,
                    executor,
                    CERERI_ACTIVE_MAP,
                    REPO_PROGRAMARI,
                    REPO_PLATI,
                    costTratamente,
                    timpTratamente,
                    nrClientiMaxPerTratament
            );

            executor.execute(job);
        }

        serverSocket.close();
        threadProgramari.join();
    }

    private static void pornireSistemVerificare() {
        SCHEDULED_EXECUTOR_SERVICE.scheduleAtFixedRate(() -> {
            BufferedWriter bufferedWriter;
            try {
                if (verificareCurenta == 1) {
                    bufferedWriter = new BufferedWriter(new FileWriter(OUTPUT_FILE));
                } else {
                    bufferedWriter = new BufferedWriter(new FileWriter(OUTPUT_FILE, true));
                }

                bufferedWriter.write("Verificarea nr. " + verificareCurenta + "\nData si ora: " + LocalDateTime.now().format(DATE_TIME_FORMATTER) + "\n");
                synchronized (REPO_PROGRAMARI) {
                    synchronized (REPO_PLATI) {
                        for (int locatieCurenta = 0; locatieCurenta < nrLocatii; locatieCurenta++) {
                            Integer sumaTotala = REPO_PROGRAMARI.getSumaForLocatie(locatieCurenta);

                            bufferedWriter.write("\nLocatia: " + locatieCurenta + "\nSuma totala pentru locatia " + locatieCurenta + " = " + sumaTotala + "\n");

                            List<Programare> programariNeplatite = REPO_PROGRAMARI.getProgramariNeplatiteByLocatie(locatieCurenta);

                            String idProgramariNeplatiteString = "";
                            for (Programare programare : programariNeplatite) {
                                idProgramariNeplatiteString += programare.getIdProgramare().toString() + " ";
                            }

                            if ("".equals(idProgramariNeplatiteString)) {
                                idProgramariNeplatiteString = "none";
                            }

                            bufferedWriter.write("\tId-urile pentru programarile neplatite: " + idProgramariNeplatiteString + "\n");

                            for (int tratamentCurent = 0; tratamentCurent < nrTratamente; tratamentCurent++) {
                                List<Programare> programari = REPO_PROGRAMARI.getProgramariByLocatieAndTip(locatieCurenta, tratamentCurent);
                                int timpTratament = timpTratamente[tratamentCurent];

                                List<Integer> nrClientiMaxLaAnumiteIntervale = new ArrayList<>();
                                Ora oraStart = new Ora(10, 0);
                                Ora oraFinal = new Ora(18, 0);

                                while (Utils.comparaOre(oraStart, oraFinal) <= 0) {
                                    int rezultat = 0;
                                    for (Programare programare : programari) {
                                        Ora oraStartCurenta = programare.getOra();
                                        Ora oraFinalCurenta = programare.getOra().adaugaMinute(timpTratament);

                                        if (Utils.comparaOre(oraStart, oraStartCurenta) > 0 &&
                                                Utils.comparaOre(oraStart, oraFinalCurenta) < 0
                                        ) {
                                            rezultat++;
                                        }
                                    }

                                    nrClientiMaxLaAnumiteIntervale.add(rezultat);
                                    oraStart = oraStart.adaugaMinute(INTEVAL_TIMP);
                                }

                                int nrClientiMaxTratamentCurent = nrClientiMaxPerTratament[locatieCurenta][tratamentCurent];
                                nrClientiMaxLaAnumiteIntervale.forEach(nrClienti -> {assert nrClienti <= nrClientiMaxTratamentCurent;});

                                String stringNrClientiMaxLaAnumiteIntervale = "";
                                for (Integer i : nrClientiMaxLaAnumiteIntervale) {
                                    stringNrClientiMaxLaAnumiteIntervale += i.toString() + " ";
                                }

                                bufferedWriter.write("\nTipul de tratament: " + tratamentCurent +
                                        "\nNr. max de clienti: " + nrClientiMaxTratamentCurent +
                                        "\nTratamentul are urmatorii clienti (la fiecare " + INTEVAL_TIMP + " minute): " +
                                        stringNrClientiMaxLaAnumiteIntervale + "\n");
                            }
                        }
                    }
                }

                bufferedWriter.write("\n\n");
                bufferedWriter.close();
                verificareCurenta++;
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }, INITIAL_DELAY, PERIOD, TimeUnit.SECONDS);
    }

    private static void oprireServer(ExecutorService pool) {
        pool.shutdown(); // Oprire pool
        try {
            // Perioada de asteptare pt. a se termina toate task-urile
            if (!pool.awaitTermination(60, TimeUnit.SECONDS)) {
                pool.shutdownNow(); // Anulare task-uri care ruleaza

                // Perioada de asteptare pt. ca task-urile anulate sa raspunda la asteptare
                if (!pool.awaitTermination(60, TimeUnit.SECONDS))
                    System.err.println("Thread pool-ul nu s-a oprit");
            }
        } catch (InterruptedException ie) {
            // Reanulare in caz de intrerupere
            pool.shutdownNow();
            Thread.currentThread().interrupt();
        }
    }

    private static void initializeazaServer() throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("server.txt"));
        scanner.nextLine();

        int p = Integer.parseInt(scanner.nextLine()); // Nr. de thread-uri dat pool-ului
        scanner.nextLine();

        executor = Executors.newFixedThreadPool(p);
        nrLocatii = Integer.parseInt(scanner.nextLine());
        scanner.nextLine();

        nrTratamente = Integer.parseInt(scanner.nextLine());
        scanner.nextLine();

        costTratamente = new int[nrTratamente];
        timpTratamente = new int[nrTratamente];
        nrClientiMaxPerTratament = new int[nrLocatii][nrTratamente];

        List<Integer> currentLine = Arrays.stream(
                scanner.nextLine().strip().split(" ")
        ).map(Integer::parseInt).toList();

        for (int i = 0; i < nrTratamente; i++) {
            costTratamente[i] = currentLine.get(i);
        }

        scanner.nextLine();
        currentLine = Arrays.stream(
                scanner.nextLine().strip().split(" ")
        ).map(Integer::parseInt).toList();

        for (int i = 0; i < nrTratamente; i++) {
            timpTratamente[i] = currentLine.get(i);
        }

        scanner.nextLine();
        currentLine = Arrays.stream(
                scanner.nextLine().strip().split(" ")
        ).map(Integer::parseInt).toList();
        for (int i = 0; i < nrTratamente; i++) {
            nrClientiMaxPerTratament[0][i] = currentLine.get(i);
        }

        for (int i = 1; i < nrLocatii; i++) {
            for (int j = 0; j < nrTratamente; j++) {
                nrClientiMaxPerTratament[i][j] = nrClientiMaxPerTratament[0][j] * i;
            }
        }
    }
}
