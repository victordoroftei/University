import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

public class AdapostAnimale {

    public static void main(String[] args) throws InterruptedException {
        int C = 10; // nr animale
        List<String> listaNumeAnimale = Arrays.asList("A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10");
        Collections.shuffle(listaNumeAnimale);

        int I = 3; // nr ingrijitori
        List<String> listaNumeIngrijitori = Arrays.asList("I1", "I2", "I3");
        Collections.shuffle(listaNumeIngrijitori);

        // interval ms
        int X = 10;
        int Y = 30;

        int Ct = 7;
        int N = 5;

//        int T = 6;
//        int Pt = 20;
        int At = 12;
        int H = 0;

        Curte curte = new Curte(H, I, C);

        Thread admin = new Administrator(curte, At);
        admin.start();

        Thread[] ingrijitori = new Ingrijitor[I];
        for (int i = 0; i < I; i++) {
            ingrijitori[i] = new Ingrijitor(i, listaNumeIngrijitori.get(i), curte, X, Y, N);
            ingrijitori[i].start();
        }

        Thread[] animale = new Animal[C];
        for (int i = 0; i < C; i++) {
            animale[i] = new Animal(i + I, listaNumeAnimale.get(i), curte, Ct);
            animale[i].start();
        }

        for (int i = 0; i < I; i++) {
            ingrijitori[i].join();
        }

        for (int i = 0; i < C; i++) {
            animale[i].join();
        }

        admin.join();
    }

    enum Tip {
        OFERIT, CONSUMAT
    }

    static class EntitateRegistru {
        public int id;
        public int nrPortii;
        LocalDateTime localDateTime;
        public Tip tip;

        public EntitateRegistru(int id, int nrPortii, LocalDateTime localDateTime, Tip tip) {
            this.id = id;
            this.nrPortii = nrPortii;
            this.localDateTime = localDateTime;
            this.tip = tip;
        }

        @Override
        public String toString() {
            return "EntitateRegistru{" +
                    "id=" + id +
                    ", nrPortii=" + nrPortii +
                    ", localDateTime=" + localDateTime +
                    ", tip=" + tip +
                    '}';
        }
    }

    static class Curte {
        List<EntitateRegistru> listaRegistru;
        public int currentFood;
        public int initialFood;
        public boolean firstCheck = true;
        public int noFinishedIngrijitori = 0;
        public int expFinishedIngrijitori;
        public int noFinishedAnimale = 0;
        public int expFinishedAnimale;

        public Curte(int initialFood, int expFinishedIngrijitori, int expFinishedAnimale) {
            this.listaRegistru = new ArrayList<>();
            this.initialFood = initialFood;
            this.currentFood = initialFood;
            this.expFinishedIngrijitori = expFinishedIngrijitori;
            this.expFinishedAnimale = expFinishedAnimale;
        }

        public synchronized void terminaIngrijitor() {
            noFinishedIngrijitori++;
            if (noFinishedIngrijitori == expFinishedIngrijitori) {
                this.notifyAll();
            }
        }

        public synchronized void terminaAnimal() {
            noFinishedAnimale++;
        }

        public synchronized void ofera(int idIngrijitor, int nrPortii) throws InterruptedException {
            while (currentFood != 0) {
                this.wait();
            }

            currentFood += nrPortii;

            LocalDateTime dateTime = LocalDateTime.now();

            listaRegistru.add(new EntitateRegistru(
                    idIngrijitor,
                    nrPortii,
                    dateTime,
                    Tip.OFERIT
            ));

            this.notifyAll();
        }

        public synchronized boolean consuma(int idAnimal) throws InterruptedException {
            while (currentFood == 0) {
                if (noFinishedIngrijitori == expFinishedIngrijitori) {
                    return false;
                }
                this.wait();
            }

            currentFood -= 1;

            LocalDateTime dateTime = LocalDateTime.now();

            listaRegistru.add(new EntitateRegistru(
                    idAnimal,
                    1,
                    dateTime,
                    Tip.CONSUMAT
            ));

            this.notifyAll();
            return true;
        }

        public synchronized boolean itereaza() throws IOException {
            String lista = listaRegistru.stream().map(Object::toString).reduce("", (a, b) -> a + "\n" + b);
            String verif = lista + "\nVERIFICAT: nr portii oferite: ";

            Integer nrPortiiOferite = listaRegistru.stream()
                    .filter(x -> x.tip == Tip.OFERIT)
                    .map(x -> x.nrPortii)
                    .reduce(0, Integer::sum);

            Integer nrPortiiConsumate = listaRegistru.stream()
                    .filter(x -> x.tip == Tip.CONSUMAT)
                    .map(x -> x.nrPortii)
                    .reduce(0, Integer::sum);

            verif = verif + nrPortiiOferite + " nr portii consumate: " + nrPortiiConsumate + "\n";

            String path = "subiecte/input/outputAnimale.txt";

            FileWriter fileWriter;
            if (firstCheck) {
                firstCheck = false;
                fileWriter = new FileWriter(path);
            } else {
                fileWriter = new FileWriter(path, true);
            }

            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);

            bufferedWriter.write(verif);
            bufferedWriter.close();

            if (noFinishedAnimale == expFinishedAnimale) {
                int totalOferit = initialFood + nrPortiiOferite;
                int totalConsumate = currentFood + nrPortiiConsumate;

                System.out.println("A terminat administratorul si a gasit " +
                        "total oferit = " + totalOferit +
                        " total consumat " + totalConsumate +
                        " sunt egale " + (totalOferit == totalConsumate) + "\n"
                );

                return false;
            } else {
                return true;
            }
        }
    }

    static class Animal extends Thread {
        int id;
        String nume;
        Curte curte;
        int ct;

        public Animal(int id, String nume, Curte curte, int ct) {
            this.id = id;
            this.nume = nume;
            this.curte = curte;
            this.ct = ct;
        }

        @Override
        public void run() {
            while (true) {
                try {
                    if (!curte.consuma(id)) {
                        break;
                    }

                    Thread.sleep(ct);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
            curte.terminaAnimal();
        }
    }

    static class Ingrijitor extends Thread {
        int id;
        String nume;
        Curte curte;
        int ct;
        Random random = new Random();
        int N;

        public Ingrijitor(int id, String nume, Curte curte, int x, int y, int N) {
            this.id = id;
            this.nume = nume;
            this.curte = curte;
            this.ct = random.nextInt(x, y + 1);
            this.N = N;
        }

        @Override
        public void run() {
            for (int i = 0; i < 100; i++) {
                try {
                    curte.ofera(id, random.nextInt(N) + 1);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
            curte.terminaIngrijitor();
        }
    }

    static class Administrator extends Thread {
        Curte curte;
        int at;

        public Administrator(Curte curte, int at) {
            this.curte = curte;
            this.at = at;
        }

        @Override
        public void run() {
            while (true) {
                try {
                    if (!curte.itereaza()) {
                        break;
                    }
                    Thread.sleep(at);
                } catch (IOException | InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }
}
