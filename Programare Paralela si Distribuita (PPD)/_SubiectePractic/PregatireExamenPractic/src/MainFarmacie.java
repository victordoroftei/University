import java.io.*;
import java.util.*;

public class MainFarmacie {
    public static void main(String[] args) throws InterruptedException {
        Integer N = 100;
        Integer M = 4;
        Integer nrRetetePerPacient = 2;

        RetetaQueue retetaQueue = new RetetaQueue(N);
        RetetetePregatiteQueue retetetePregatiteQueue = new RetetetePregatiteQueue(M);

        Thread[] pacienti = new Pacient[N];
        Integer idInitial = 0;
        for (int i = 0; i < N; i++) {
            pacienti[i] = new Pacient(retetaQueue, nrRetetePerPacient, idInitial);
            idInitial += nrRetetePerPacient;

            pacienti[i].start();
        }

        Thread[] farmacisti = new Farmacist[M];
        for (int i = 0; i < M; i++) {
            farmacisti[i] = new Farmacist(retetaQueue, retetetePregatiteQueue, i);
            farmacisti[i].start();
        }

        Thread casier = new Casier(retetetePregatiteQueue);
        casier.start();

        for (int i = 0; i < N; i++) {
            pacienti[i].join();
        }

        for (int i = 0; i < M; i++) {
            farmacisti[i].join();
        }

        casier.join();
    }

    static class Reteta {
        public int codReteta;
        public int nrMedicamente;
        public List<Integer> medicamente;

        public Reteta(int codReteta, int nrMedicamente, List<Integer> medicamente) {
            this.codReteta = codReteta;
            this.nrMedicamente = nrMedicamente;
            this.medicamente = medicamente;
        }

        @Override
        public String toString() {
            return "Reteta{" +
                    "codReteta=" + codReteta +
                    ", nrMedicamente=" + nrMedicamente +
                    ", medicamente=" + medicamente +
                    '}';
        }
    }

    static class RetetaFinala {
        public int codReteta;
        public int pret;

        public RetetaFinala(int codReteta, int pret) {
            this.codReteta = codReteta;
            this.pret = pret;
        }
    }

    static class Pacient extends Thread {
        public RetetaQueue retetaQueue;
        public int nrRetete;
        public int idRetetaInitial;
        public Random random = new Random();

        public Pacient(RetetaQueue retetaQueue, int nrRetete, int idRetetaInitial) {
            this.retetaQueue = retetaQueue;
            this.nrRetete = nrRetete;
            this.idRetetaInitial = idRetetaInitial;
        }

        private Reteta getReteta() {
            int nrMedicamente = random.nextInt(5) + 1;

            List<Integer> idMedicamente = new ArrayList<>();
            for (int i = 0; i < nrMedicamente; i++) {
                int idMed = random.nextInt(30) + 1;
                idMedicamente.add(idMed);
            }

            return new Reteta(idRetetaInitial, nrMedicamente, idMedicamente);
        }

        @Override
        public void run() {
            for (int i = 0; i < nrRetete; i++) {
                Reteta reteta = getReteta();
                idRetetaInitial++;
                retetaQueue.enqueue(reteta);
            }
            retetaQueue.terminaPacient();
        }
    }

    static class RetetaQueue {
        public Queue<Reteta> retetaQueue;
        public Integer expPacienti;
        public Integer actPacienti;
        public boolean doneReading;

        public RetetaQueue(Integer expPacienti) {
            this.retetaQueue = new LinkedList<>();
            this.expPacienti = expPacienti;
            this.actPacienti = 0;
            this.doneReading = false;
        }

        public synchronized void terminaPacient() {
            actPacienti++;
            if (actPacienti.equals(expPacienti)) {
                doneReading = true;
                this.notifyAll();
            }
        }

        public synchronized boolean getDoneReading() {
            return this.doneReading;
        }

        public synchronized void enqueue(Reteta reteta) {
            this.retetaQueue.add(reteta);
            this.notifyAll();
        }

        public synchronized Reteta dequeue() {
            return this.retetaQueue.remove();
        }

        public synchronized boolean isEmpty() {
            return this.retetaQueue.size() == 0;
        }
    }

    static class RetetetePregatiteQueue {
        public Queue<RetetaFinala> retetePregatiteQueue;
        public Integer expFarmacisti;
        public Integer actFarmacisti;
        public boolean doneProcessing;

        public RetetetePregatiteQueue(Integer expFarmacisti) {
            this.retetePregatiteQueue = new LinkedList<>();
            this.expFarmacisti = expFarmacisti;
            this.actFarmacisti = 0;
            this.doneProcessing = false;
        }

        public synchronized void terminaFarmacist() {
            actFarmacisti++;
            if (actFarmacisti.equals(expFarmacisti)) {
                doneProcessing = true;
                this.notify();
            }
        }

        public synchronized boolean getDoneProcessing() {
            return this.doneProcessing;
        }

        public synchronized void enqueue(RetetaFinala reteta) {
            this.retetePregatiteQueue.add(reteta);
            this.notify();
        }

        public synchronized RetetaFinala dequeue() {
            return this.retetePregatiteQueue.remove();
        }

        public synchronized boolean isEmpty() {
            return this.retetePregatiteQueue.size() == 0;
        }
    }

    static class Farmacist extends Thread {
        public final RetetaQueue retetaQueue;
        public RetetetePregatiteQueue retetePregatiteQueue;
        public Integer idFarmacist;

        public Farmacist(RetetaQueue retetaQueue, RetetetePregatiteQueue retetePregatiteQueue, Integer idFarmacist) {
            this.retetaQueue = retetaQueue;
            this.retetePregatiteQueue = retetePregatiteQueue;
            this.idFarmacist = idFarmacist;
        }

        private RetetaFinala proceseazaReteta(Reteta reteta) {
            Integer pret = reteta.medicamente.stream().map(x -> {
                try {
                    BufferedReader reader = new BufferedReader(new FileReader("subiecte/input/Medicamente.txt"));
                    String line = reader.readLine();
                    while (!Integer.valueOf(line.split(" ")[0]).equals(x)) {
                        line = reader.readLine();
                    }

                    return Integer.valueOf(line.split(" ")[1]);
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }).reduce(0, Integer::sum);

            return new RetetaFinala(reteta.codReteta, pret);
        }

        @Override
        public void run() {
            while (true) {
                synchronized (this.retetaQueue) {
                    if (this.retetaQueue.isEmpty()) {
                        if (!this.retetaQueue.getDoneReading()) {
                            try {
                                this.retetaQueue.wait();
                            } catch (InterruptedException e) {
                                throw new RuntimeException(e);
                            }
                        } else {
                            this.retetePregatiteQueue.terminaFarmacist();
                            return;
                        }
                    } else {
                        Reteta reteta = retetaQueue.dequeue();
                        System.out.println("Reteta nr " + reteta.codReteta +
                                " a fost preluata de catre farmacistul " + idFarmacist
                        );

                        RetetaFinala retetaFinala = proceseazaReteta(reteta);
                        System.out.println("Reteta nr " + reteta.codReteta +
                                " a fost pregatita si pretul este de " + retetaFinala.pret
                        );

                        retetePregatiteQueue.enqueue(retetaFinala);
                        System.out.println("Reteta nr " + reteta.codReteta +
                                " a fost adaugata in coada de la casierie"
                        );
                    }
                }
            }
        }
    }

    static class Casier extends Thread {
        public final RetetetePregatiteQueue retetetePregatiteQueue;
        public Integer nrFactura;
        public boolean firstTime;

        public Casier(RetetetePregatiteQueue retetetePregatiteQueue) {
            this.retetetePregatiteQueue = retetetePregatiteQueue;
            this.nrFactura = 0;
            this.firstTime = true;
        }

        private void printReteta(RetetaFinala retetaFinala) throws IOException {
            FileWriter fileWriter;
            String path = "subiecte/input/MedicamenteOut.txt";

            if (firstTime) { // write mode
                firstTime = false;
                fileWriter = new FileWriter(path);
            } else { // append mode
                fileWriter = new FileWriter(path, true);
            }

            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
            bufferedWriter.write("Nr_factura = " + nrFactura + " | " +
                    "Valoare = " + retetaFinala.pret + " | " +
                    "Cod Reteta = " + retetaFinala.codReteta + "\n"
            );

            nrFactura++;

            bufferedWriter.close();
        }

        @Override
        public void run() {
            while (true) {
                synchronized (this.retetetePregatiteQueue) {
                    if (this.retetetePregatiteQueue.isEmpty()) {
                        if (!this.retetetePregatiteQueue.getDoneProcessing()) {
                            try {
                                this.retetetePregatiteQueue.wait();
                            } catch (InterruptedException e) {
                                throw new RuntimeException(e);
                            }
                        } else {
                            return;
                        }
                    } else {
                        RetetaFinala retetaFinala = retetetePregatiteQueue.dequeue();
                        try {
                            printReteta(retetaFinala);
                            System.out.println("Reteta nr " + retetaFinala.codReteta +
                                    " a fost platita si preluata"
                            );
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
            }
        }
    }
}
