package parallel;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Scanner;
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class Node {
    private Integer co;
    private Integer ex;

    private Node next;

    private Lock lock = new ReentrantLock();

    public Node(Integer co, Integer ex) {
        this.co = co;
        this.ex = ex;
        this.next = null;
    }

    public Integer getCo() {
        return co;
    }

    public void setCo(Integer co) {
        this.co = co;
    }

    public Integer getEx() {
        return ex;
    }

    public void setEx(Integer ex) {
        this.ex = ex;
    }

    public Node getNext() {
        return next;
    }

    public void setNext(Node next) {
        this.next = next;
    }

    public void lock() {
        lock.lock();
    }

    public void unlock() {
        lock.unlock();
    }

    @Override
    public String toString() {
        return String.format("%sx^%s", co, ex);
    }
}

class MyList {

    private Integer length;

    private Node head;

    public MyList() {
        Node minNode = new Node(0, Integer.MIN_VALUE);
        Node maxNode = new Node(0, Integer.MAX_VALUE);
        minNode.setNext(maxNode);

        head = minNode;
        length = 0;
    }

    public void insertNode(Node node) {
        Node previous = head;
        Node current;

        previous.lock();
        current = previous.getNext();
        current.lock();

        try {
            while (current.getEx() < node.getEx()) {
                previous.unlock();
                previous = current;
                current = current.getNext();
                current.lock();
            }

            // after the while, the current exponent is either equal (so we need to add the coefficient),
            // or greater (so we need to insert it)
            if (Objects.equals(current.getEx(), node.getEx())) {
                int newCo = current.getCo() + node.getCo();
                current.setCo(newCo);

                if (current.getCo() == 0) {
                    previous.setNext(current.getNext());
                }
            } else {
                node.setNext(current);
                previous.setNext(node);
                length++;
            }
        } finally {
            current.unlock();
            previous.unlock();
        }
    }

    @Override
    public String toString() {
        if (head == null) {
            return "NULL";
        }

        String string = "";
        Node current = head;

        for (int i = 0; i <= length; i++) {
            string += String.format("(%s, %s) -> ", current.getCo(), current.getEx());
            current = current.getNext();
        }

        string += "NULL";

        return string;
    }

    public void writeToFile(int polyIndex) {
        String fileTemplate = "E:\\__Teme\\Programare Paralela si Distribuita (PPD)\\Lab4\\files\\p{0}\\result.txt";
        fileTemplate = fileTemplate.replace("{0}", String.valueOf(polyIndex));

        String result = "";
        Node current = head;
        while (current.getNext() != null) {
            if (current.getCo() != 0) {
                result += String.format("%sx^%s + ", current.getCo(), current.getEx());
            }
            current = current.getNext();
        }
        result = result.substring(0, result.length() - 2);  // removes trailing '+'

        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(fileTemplate));
            writer.write(result);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

class MyQueue {

    private List<Node> nodes;

    private boolean readingDoneFlag;

    private Integer maxSize;

    private Integer size;

    private Integer finishedProducers;

    private Integer noProducers;

    public MyQueue(Integer maxSize, Integer noProducers) {
        nodes = new ArrayList<>();
        readingDoneFlag = false;

        this.maxSize = maxSize;
        size = 0;

        finishedProducers = 0;
        this.noProducers = noProducers;
    }

    public Node firstElement() {
        if (nodes.isEmpty())
            return null;
        else {
            return nodes.get(0);
        }
    }

    public synchronized void enqueue(Node node) {
        try {
            if (Objects.equals(size, maxSize)) {
                this.wait();
            }
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        }

        nodes.add(node);
        size++;
        this.notifyAll();
    }

    public synchronized Node dequeue() {
        while (nodes.isEmpty()) {
            if (readingDoneFlag) {
                return null;
            }

            try {
                this.wait();
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }

        this.notifyAll();
        size--;
        return nodes.remove(0);
    }

    public boolean isEmpty() {
        return nodes.isEmpty();
    }

    public synchronized boolean isReadingDoneFlag() {
        return readingDoneFlag;
    }

    public void setReadingDoneFlagTrue() {
        this.readingDoneFlag = true;
        this.notifyAll();
    }

    public synchronized void incrementThreadNumber() {
        finishedProducers++;
        if (finishedProducers.equals(noProducers)) {
            setReadingDoneFlagTrue();
        }
    }
}

public class MainParallel {

    private synchronized static void readPoly(int polyIndex, MyQueue nodeQueue, int start, int end) {
        String fileTemplate = "E:\\__Teme\\Programare Paralela si Distribuita (PPD)\\Lab4\\files\\p{0}\\{1}.txt";

        try {
            File file;
            Scanner scanner;

            for (int i = start; i < end; i++) {
                String fileName;
                fileName = fileTemplate.replace("{0}", String.valueOf(polyIndex));
                fileName = fileName.replace("{1}", String.valueOf(i + 1));

                file = new File(fileName);
                scanner = new Scanner(file);

                int noMonomials = Integer.parseInt(scanner.nextLine());

                while (scanner.hasNextLine()) {
                    String data = scanner.nextLine();
                    String[] splitArr = data.split(" ");

                    int co = Integer.parseInt(splitArr[0]);
                    int ex = Integer.parseInt(splitArr[1]);

                    Node node = new Node(co, ex);
                    nodeQueue.enqueue(node);
                }
            }

            nodeQueue.incrementThreadNumber();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    private static boolean checkCorrectness(int polyIndex) {
        String expectedFileTemplate = "E:\\__Teme\\Programare Paralela si Distribuita (PPD)\\Lab4\\files\\p{0}\\expected.txt";
        expectedFileTemplate = expectedFileTemplate.replace("{0}", String.valueOf(polyIndex));

        String actualFileTemplate = "E:\\__Teme\\Programare Paralela si Distribuita (PPD)\\Lab4\\files\\p{0}\\result.txt";
        actualFileTemplate = actualFileTemplate.replace("{0}", String.valueOf(polyIndex));

        try {
            File file = new File(expectedFileTemplate);
            Scanner scanner = new Scanner(file);

            String expected = scanner.nextLine();

            file = new File(actualFileTemplate);
            scanner = new Scanner(file);

            String actual = scanner.nextLine();

            expected = expected.strip();
            actual = actual.strip();

            if (!expected.equals(actual)) {
                System.out.println("INCORRECT RESULT!");
                return false;
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        return true;
    }

    public static void producerFn(int polyIndex, MyQueue nodeQueue, int start, int end) {
        readPoly(polyIndex, nodeQueue, start, end);
    }

    public static void consumerFn(MyQueue nodeQueue, MyList resultPoly) {
        while (true) {
            Node node = nodeQueue.dequeue();
            if (node != null) {
                resultPoly.insertNode(node);
            } else {
                return;
            }
        }
    }

    public static void main(String[] args) throws InterruptedException {
        // args[0] = number of consumer threads
        // args[1] = the index of the polynomial folder
        // args[2] = the number of polynomials in the folder
        // args[3] = number of producer threads
        // args[4] = the size of the node queue

        int p1 = Integer.parseInt(args[3]);
        int p2 = Integer.parseInt(args[0]);
        int p = p1 + p2;

        int polyIndex = Integer.parseInt(args[1]);
        int noPoly = Integer.parseInt(args[2]);
        int queueSize = Integer.parseInt(args[4]);

        CyclicBarrier barrier = new CyclicBarrier(p);

        Thread[] threads = new Thread[p];
        MyList resultPoly = new MyList();
        MyQueue nodeQueue = new MyQueue(queueSize, p1);

        int start, end = 0;
        int size = noPoly / p1;
        int rest = noPoly % p1;
        for (int i = 0; i < p1; i++) {
            start = end;
            end = start + size;
            if (rest > 0) {
                end++;
                rest--;
            }

            int finalStart = start;
            int finalEnd = end;
            threads[i] = new Thread(() -> producerFn(polyIndex, nodeQueue, finalStart, finalEnd));
        }

        for (int i = p1; i < p; i++) {
            threads[i] = new Thread(() -> consumerFn(nodeQueue, resultPoly));
        }

        long startTime = System.nanoTime();
        for (Thread thread : threads) {
            thread.start();
        }

        for (Thread thread : threads) {
            thread.join();
        }
        
        long endTime = System.nanoTime();

        if (checkCorrectness(polyIndex)) {
            resultPoly.writeToFile(polyIndex);
        }

        System.out.println((double) (endTime - startTime) / 1E6);
    }
}
