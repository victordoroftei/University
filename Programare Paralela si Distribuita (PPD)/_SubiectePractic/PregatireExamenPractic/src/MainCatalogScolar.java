import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class MainCatalogScolar {
    public static void main(String[] args) throws InterruptedException {
        int nrSecretare = 5;
        int nrCursanti = 100;

        Random random = new Random();
        Catalog catalog = new Catalog();
        List<Cursant> cursanti = new ArrayList<>();

        for (int i = 0; i < nrCursanti; i++) {
            cursanti.add(new Cursant(i + 1, random.nextInt(10) + 1));
        }

        Manager manager = new Manager(catalog);
        manager.start();

        int interval = nrCursanti / nrSecretare;
        int rest = nrCursanti % nrSecretare;
        int startIndex = 0;
        int endIndex = interval;

        Secretara[] secretare = new Secretara[nrSecretare];
        for (int i = 0; i < nrSecretare; i++) {
            if (rest > 0) {
                endIndex++;
                rest--;
            }

            secretare[i] = new Secretara(cursanti.subList(startIndex, endIndex), catalog);

            startIndex = endIndex;
            endIndex = endIndex + interval;
        }

        for (int i = 0; i < nrSecretare; i++) {
            secretare[i].start();
        }

        for (int i = 0; i < nrSecretare; i++) {
            secretare[i].join();
        }

        catalog.secretareOver();
        manager.join();
    }


    static class Secretara extends Thread {
        public List<Cursant> cursanti;
        public Catalog catalog;

        public Secretara(List<Cursant> cursantiDeProcesat, Catalog catalog) {
            this.cursanti = cursantiDeProcesat;
            this.catalog = catalog;
        }

        @Override
        public void run() {
            cursanti.forEach(cursant -> {
                catalog.add(cursant);

                try {
                    Thread.sleep(20);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            });
        }
    }

    static class Manager extends Thread {
        public Catalog catalog;

        public Manager(Catalog catalog) {
            this.catalog = catalog;
        }

        @Override
        public void run() {
            while (true) {
                try {
                    if (!catalog.supervise()) break;
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }


    static class Catalog {
        public List<Cursant> catalog = new ArrayList<>();
        public boolean secretareOver = false;

        public synchronized void secretareOver() {
            this.secretareOver = true;
            this.notify();
        }

        public synchronized void add(Cursant cursant) {
            catalog.add(cursant);

            if (cursant.medie < 5) {
                this.notify();
            }
        }

        public synchronized boolean supervise() throws InterruptedException {
            this.wait();


            if (!secretareOver) {
                System.out.println("==========================================================");
                catalog.stream().filter(elem -> elem.medie < 5).forEach(System.out::println);
                return true;
            }

            System.out.println("=========================FINAL=================================");
            catalog.forEach(System.out::println);
            return false;
        }

    }


    public static class Cursant {
        public int ID;
        public int medie;

        public Cursant(int ID, int medie) {
            this.ID = ID;
            this.medie = medie;
        }

        @Override
        public String toString() {
            return "Cursant{" +
                    "ID=" + ID +
                    ", medie=" + medie +
                    '}';
        }
    }
}
