import java.util.ArrayList;
import java.util.List;

public class MainParcare {
    public static void main(String[] args) throws InterruptedException {

        Integer n = 100;
        Integer p = 25;
        Integer producerNum = 3;
        Integer consumerNum = 2;

        Parcare parcare = new Parcare(n, p);

        Thread[] producers = new Thread[producerNum];
        Thread[] consumers = new Thread[consumerNum];

        ThreadAfisare threadAfisare = new ThreadAfisare(parcare);
        threadAfisare.start();

        for (int i = 0; i < producerNum; i++) {
            producers[i] = new Producer(i, parcare);
            producers[i].start();
        }

        for (int i = 0; i < consumerNum; i++) {
            consumers[i] = new Consumer(i + producerNum, parcare);
            consumers[i].start();
        }

        for (int i = 0; i < producerNum; i++) {
            producers[i].join();
        }

        for (int i = 0; i < consumerNum; i++) {
            consumers[i].join();
        }

        synchronized (parcare) {
            parcare.finished = true;
        }

        threadAfisare.join();
    }

    private enum TipTranzactie {

        INTRARE, IESIRE
    }

    private static class Nod {

        public Integer id;

        public TipTranzactie tipTranzactie;

        public Nod(Integer id, TipTranzactie tipTranzactie) {
            this.id = id;
            this.tipTranzactie = tipTranzactie;
        }

        @Override
        public String toString() {
            return "Nod{" +
                    "id=" + id +
                    ", tipTranzactie=" + tipTranzactie +
                    '}';
        }
    }

    private static class Parcare {

        public Integer n;

        public Integer p;

        public List<Nod> list = new ArrayList<>();

        public boolean finished = false;

        public Parcare(Integer n, Integer p) {
            this.n = n;
            this.p = p;
        }

        public synchronized boolean print() {
            if (finished) {
                return false;
            }

            if (!list.isEmpty()) {
                list.forEach(System.out::println);
                System.out.println("Locuri libere: " + p);
                System.out.println("==============================================================================");
            }
            return true;
        }

        public synchronized void intrare(Integer id) throws InterruptedException {
            while (p + 1 > n) {
                this.wait();
            }

            list.add(new Nod(id, TipTranzactie.INTRARE));
            p++;
            this.notifyAll();
        }

        public synchronized void iesire(Integer id) throws InterruptedException {
            while (p.equals(0)) {
                this.wait();
            }

            list.add(new Nod(id, TipTranzactie.IESIRE));
            p--;
            this.notifyAll();
        }
    }

    private static class Producer extends Thread {

        public Integer id;

        public Parcare parcare;

        public Producer(Integer id, Parcare parcare) {
            this.id = id;
            this.parcare = parcare;
        }

        @Override
        public void run() {
            for (int i = 0; i < 200; i++) {
                try {
                    parcare.intrare(id);
                    Thread.sleep(20);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }

    private static class Consumer extends Thread {

        public Integer id;

        public Parcare parcare;

        public Consumer(Integer id, Parcare parcare) {
            this.id = id;
            this.parcare = parcare;
        }

        @Override
        public void run() {
            for (int i = 0; i < 275; i++) {
                try {
                    parcare.iesire(id);
                    Thread.sleep(15);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }

    private static class ThreadAfisare extends Thread {

        public Parcare parcare;

        public ThreadAfisare(Parcare parcare) {
            this.parcare = parcare;
        }

        @Override
        public void run() {
            while (parcare.print()) {
                try {
                    Thread.sleep(5);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }
}
