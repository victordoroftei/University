import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class ContBancar {
    public static void main(String[] args) throws InterruptedException {
        Integer n = 3;

        ContFamilie contFamilie = new ContFamilie();

        Thread check = new VerificaTran(contFamilie);
        check.start();

        Thread[] threads = new Thread[n];
        for(int i = 0; i < n; i++) {
            threads[i] = new MembruFamilie(i, contFamilie);
            threads[i].start();
        }

        for(int i = 0; i < n; i++) {
            threads[i].join();
        }

        contFamilie.shouldStop = true;
        synchronized (contFamilie.list) {
            contFamilie.list.notify();
        }

        check.join();
    }

    enum TipValuta {
        RON, EUR
    }

    enum TipTranzactie {
        DEPUNERE, RETRAGERE
    }

    static class Nod {
        public Integer indexUser;
        public TipValuta tipValuta;
        public TipTranzactie tipTranzactie;
        public Integer suma;
        public Integer soldCurent;

        public Nod(Integer indexUser, TipValuta tipValuta, TipTranzactie tipTranzactie, Integer suma, Integer soldCurent) {
            this.indexUser = indexUser;
            this.tipValuta = tipValuta;
            this.tipTranzactie = tipTranzactie;
            this.suma = suma;
            this.soldCurent = soldCurent;
        }

        @Override
        public String toString() {
            return "Nod{" +
                    "indexUser=" + indexUser +
                    ", tipValuta=" + tipValuta +
                    ", tipTranzactie=" + tipTranzactie +
                    ", suma=" + suma +
                    ", soldCurent=" + soldCurent +
                    '}';
        }
    }

    static class ContFamilie {
        private final  Object lockRon = new Object();
        public Integer ron = 0;
        private final Object lockEur = new Object();
        public Integer eur = 0;
        public final List<Nod> list = new ArrayList<>();
        public Boolean shouldStop = false;

        public void depuneLei(Integer userId, Integer suma) {
            synchronized (lockRon) {
                ron += suma;
                synchronized (list) {
                    list.add(new Nod(userId, TipValuta.RON, TipTranzactie.DEPUNERE, suma, ron));
                    if (list.size() % 5 == 0) {
                        list.notify();
                    }
                }
            }
        }

        public void retrageLei(Integer userId, Integer suma) {
            synchronized (lockRon) {
                if (suma > ron) {
                    System.out.println("Thread-ul " + userId + " nu a putut extrage din contul RON " + suma + "!");
                } else {
                    ron -= suma;
                    synchronized (list) {
                        list.add(new Nod(userId, TipValuta.RON, TipTranzactie.RETRAGERE, suma, ron));
                        if (list.size() % 5 == 0) {
                            list.notify();
                        }
                    }
                }
            }
        }

        public void depuneEur(Integer userId, Integer suma) {
            synchronized (lockEur) {
                eur += suma;
                synchronized (list) {
                    list.add(new Nod(userId, TipValuta.EUR, TipTranzactie.DEPUNERE, suma, eur));
                    if (list.size() % 5 == 0) {
                        list.notify();
                    }
                }
            }
        }

        public void retrageEur(Integer userId, Integer suma) {
            synchronized (lockEur) {
                if (suma > eur) {
                    System.out.println("Thread-ul " + userId + " nu a putut extrage din contul EUR " + suma + "!");
                } else {
                    eur -= suma;
                    synchronized (list) {
                        list.add(new Nod(userId, TipValuta.EUR, TipTranzactie.RETRAGERE, suma, eur));
                        if (list.size() % 5 == 0) {
                            list.notify();
                        }
                    }
                }
            }
        }
    }

    static class VerificaTran extends Thread {
        private ContFamilie contFamilie;

        public VerificaTran(ContFamilie contFamilie) {
            this.contFamilie = contFamilie;
        }

        @Override
        public void run() {
            int position = 0;

            try {
                synchronized (contFamilie.list) {
                    while (!contFamilie.shouldStop) {
                        contFamilie.list.wait();

                        if (position + 5 <= contFamilie.list.size()) {
                            contFamilie.list.subList(position, position + 5).forEach(System.out::println);
                            position += 5;
                        } else if (contFamilie.shouldStop) {
                            contFamilie.list.subList(position, contFamilie.list.size()).forEach(System.out::println);
                        }
                    }

                    System.out.println("RON " + contFamilie.ron);
                    System.out.println("EUR " + contFamilie.eur);
                }
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }

    static class MembruFamilie extends Thread {
        private ContFamilie contFamilie;
        private Integer userId;
        private Random random = new Random();

        public MembruFamilie(Integer userId, ContFamilie contFamilie) {
            this.userId = userId;
            this.contFamilie = contFamilie;
        }

        @Override
        public void run() {
            for (int i = 0; i < 20; i++) {
                TipValuta tipValuta;
                TipTranzactie tipTranzactie;
                Integer suma;

                Integer randomValue = random.nextInt() % 2;
                if (randomValue.equals(0)) {
                    tipValuta = TipValuta.RON;
                } else {
                    tipValuta = TipValuta.EUR;
                }

                randomValue = random.nextInt() % 2;
                if (randomValue.equals(0)) {
                    tipTranzactie = TipTranzactie.DEPUNERE;
                } else {
                    tipTranzactie = TipTranzactie.RETRAGERE;
                }

                suma = random.nextInt(1000) + 1;

                if (TipValuta.RON.equals(tipValuta)) {
                    if (TipTranzactie.DEPUNERE.equals(tipTranzactie)) {
                        contFamilie.depuneLei(userId, suma);
                    } else {
                        contFamilie.retrageLei(userId, suma);
                    }
                } else {
                    if (TipTranzactie.DEPUNERE.equals(tipTranzactie)) {
                        contFamilie.depuneEur(userId, suma);
                    } else {
                        contFamilie.retrageEur(userId, suma);
                    }
                }

                try {
                    Thread.sleep(10);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }
}