import java.util.*;
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

public class MainReteaSocializare {

    public static void main(String[] args) throws InterruptedException, BrokenBarrierException {

        int numThreads = 3;
        int numMesaje = 20;
        int N = 5;

        CyclicBarrier barrier1 = new CyclicBarrier(2);
        CyclicBarrier barrier2 = new CyclicBarrier(2);

        Dictionar dictionar = new Dictionar(N, barrier1, barrier2);
        ThreadAfisare threadAfisare = new ThreadAfisare(dictionar);
        threadAfisare.start();

        List<String> names = Arrays.asList("Marian", "Gogu", "Geani", "Virginia", "Popel");
        Random random = new Random();
        List<Mesaj> mesaje = new ArrayList<>();

        for (int i = 0; i < numMesaje; i++) {
            Integer randomKey = random.nextInt(names.size());
            Integer randomValue = random.nextInt(names.size());

            while (randomValue.equals(randomKey)) {
                randomValue = random.nextInt(names.size());
            }

            mesaje.add(new Mesaj(names.get(randomKey), names.get(randomValue)));
        }

        int cat = numMesaje / (numThreads - 1);
        int rest = numMesaje % (numThreads - 1);
        int startIndex = 0;
        int endIndex = cat;

        Thread[] threads = new Thread[numThreads - 1];
        for (int i = 0; i < numThreads - 1; i++) {

            if (rest > 0) {
                rest--;
                endIndex++;
            }

            threads[i] = new MyThread(i, dictionar, mesaje.subList(startIndex, endIndex));

            startIndex = endIndex;
            endIndex += cat;
        }

        for (int i = 0; i < numThreads - 1; i++) {
            threads[i].start();
        }

        for (int i = 0; i < numThreads - 1; i++) {
            threads[i].join();
        }

        dictionar.setFinished();    // susta lu Qata

        threadAfisare.join();
    }

    private static class MyThread extends Thread {

        private Integer id;

        public List<Mesaj> mesaje;

        public Dictionar dictionar;

        public MyThread(Integer id, Dictionar dictionar, List<Mesaj> mesaje) {
            this.id = id;
            this.dictionar = dictionar;
            this.mesaje = mesaje;
        }

        @Override
        public void run() {
            mesaje.forEach(mesaj -> {
                try {
                    dictionar.inserare(id, mesaj); // merge si cu Thread.sleep(10); - dar nu stim daca e ok :(
                } catch (BrokenBarrierException | InterruptedException e) {
                    throw new RuntimeException(e);
                }
            });
        }
    }

    private static class Dictionar {

        public Map<String, List<String>> dictionar = new TreeMap<>();

        public boolean finished = false;

        public Integer counter = 0;

        public Integer N;
        public CyclicBarrier cyclicBarrier1;
        public CyclicBarrier cyclicBarrier2;

        public Dictionar(Integer n, CyclicBarrier cyclicBarrier1, CyclicBarrier cyclicBarrier2) {
            this.N = n;
            this.cyclicBarrier1 = cyclicBarrier1;
            this.cyclicBarrier2 = cyclicBarrier2;
        }

        public synchronized void setFinished() throws BrokenBarrierException, InterruptedException {    // susta lu Qata
            finished = true;
            cyclicBarrier1.await();
            cyclicBarrier2.await();
        }

        public synchronized void inserare(Integer id, Mesaj mesaj) throws BrokenBarrierException, InterruptedException {
            counter++;
            System.out.printf("Thread %d a inserat: %s\n", id, mesaj.toString());
            if (dictionar.containsKey(mesaj.numePersoana)) {
                List<String> stringList = dictionar.get(mesaj.numePersoana);
                stringList.add(mesaj.numePrieten);

                dictionar.put(mesaj.numePersoana, stringList);
            } else {
                List<String> list = new ArrayList<>();
                list.add(mesaj.numePrieten);

                dictionar.put(mesaj.numePersoana, list);
            }

            if (counter % N == 0) {
                cyclicBarrier1.await();
                cyclicBarrier2.await();
            }
        }

        public boolean iterare() throws InterruptedException, BrokenBarrierException {
            cyclicBarrier1.await();

            if (!finished) {
                System.out.println("================================ITERARE====================================");
                for (String key : dictionar.keySet()) {
                    System.out.print(key + ": ");
                    System.out.println(dictionar.get(key));
                }
                System.out.println("===========================================================================");
                cyclicBarrier2.await();
                return true;
            }

            cyclicBarrier2.await();
            return false;
        }
    }

    private static class Mesaj {
        public String numePersoana;
        public String numePrieten;

        public Mesaj(String numePersoana, String numePrieten) {
            this.numePersoana = numePersoana;
            this.numePrieten = numePrieten;
        }

        @Override
        public String toString() {
            return "Mesaj{" +
                    "numePersoana='" + numePersoana + '\'' +
                    ", numePrieten='" + numePrieten + '\'' +
                    '}';
        }
    }

    private static class ThreadAfisare extends Thread {

        public Dictionar dictionar;

        public ThreadAfisare(Dictionar dictionar) {
            this.dictionar = dictionar;
        }

        @Override
        public void run() {
            try {
                while (dictionar.iterare()) {}
            } catch (InterruptedException | BrokenBarrierException e) {
                throw new RuntimeException(e);
            }

        }
    }
}
