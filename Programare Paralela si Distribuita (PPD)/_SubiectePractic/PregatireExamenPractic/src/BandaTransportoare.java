import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class BandaTransportoare {
    public static void main(String[] args) throws IOException, InterruptedException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("n = ");
        int n = Integer.parseInt(reader.readLine());

        System.out.println("p = ");
        int p = Integer.parseInt(reader.readLine());

        System.out.println("c = ");
        int c = Integer.parseInt(reader.readLine());

        Banda banda = new Banda(n);

        Thread check = new CheckThread(banda);
        check.start();

        Thread[] producers = new Thread[p];
        for (int i = 0; i < p; i++) {
            producers[i] = new Producer(i, banda);
            producers[i].start();
        }

        Thread[] consumers = new Thread[c];
        for (int i = 0; i < c; i++) {
            consumers[i] = new Consumer(i + p, banda);
            consumers[i].start();
        }

        for (int i = 0; i < p; i++) {
            producers[i].join();
        }

        banda.markFinishedProducers();

        for (int i = 0; i < c; i++) {
            consumers[i].join();
        }

        check.join();
    }


    static class Banda {
        public Integer n;
        public Integer currentSize = 0;
        public List<Nod> list = new ArrayList<>();
        public boolean finishedProducers = false;

        public Banda(Integer n) {
            this.n = n;
        }

        public synchronized void markFinishedProducers() {
            this.finishedProducers = true;
            this.notifyAll();
        }

        public synchronized boolean print() {
            if (finishedProducers) {
                return false;
            }

            list.forEach(System.out::println);
            System.out.println("=============================================");
            return true;
        }

        public synchronized void pune(int idThread) throws InterruptedException {
            while (currentSize + 4 > n) {
                this.wait();
            }

            currentSize += 4;
            list.add(new Nod(idThread, TipOperatie.DEPUNE, currentSize));
            this.notifyAll();
        }

        public synchronized int preia(int idThread) throws InterruptedException {
            while (currentSize - 3 < 0) {
                if (!finishedProducers) {
                    this.wait();
                } else {
                    return -1;
                }
            }

            currentSize -= 3;
            list.add(new Nod(idThread, TipOperatie.PREIA, currentSize));
            this.notifyAll();
            return currentSize;
        }
    }

    enum TipOperatie {
        DEPUNE, PREIA
    }

    static class Nod {
        public int id;
        public TipOperatie tipOperatie;
        public int nrObiecteBanda;

        public Nod(int id, TipOperatie tipOperatie, int nrObiecteBanda) {
            this.id = id;
            this.tipOperatie = tipOperatie;
            this.nrObiecteBanda = nrObiecteBanda;
        }

        @Override
        public String toString() {
            return "Nod{" +
                    "id=" + id +
                    ", tipOperatie=" + tipOperatie +
                    ", nrObiecteBanda=" + nrObiecteBanda +
                    '}';
        }
    }

    static class Producer extends Thread {
        public int id;
        public Banda banda;

        public Producer(int id, Banda banda) {
            this.id = id;
            this.banda = banda;
        }

        @Override
        public void run() {
            for (int i = 0; i < 100; i++) {
                try {
                    banda.pune(id);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
                try {
                    Thread.sleep(10);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }

    static class Consumer extends Thread {
        public int id;
        public Banda banda;

        public Consumer(int id, Banda banda) {
            this.id = id;
            this.banda = banda;
        }

        @Override
        public void run() {
            try {
                while (banda.preia(id) >= 0) {
                    Thread.sleep(8);
                }
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }

    static class CheckThread extends Thread {
        public final Banda banda;

        public CheckThread(Banda banda) {
            this.banda = banda;
        }

        @Override
        public void run() {
            try {
                while (banda.print()) {
                    Thread.sleep(20);
                }
            } catch (InterruptedException err) {
                throw new RuntimeException(err);
            }
        }
    }
}
