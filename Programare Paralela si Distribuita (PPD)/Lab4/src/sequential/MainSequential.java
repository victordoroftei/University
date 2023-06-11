package sequential;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Scanner;

class Node {
    private Integer co;
    private Integer ex;

    private Node next;

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

    @Override
    public String toString() {
        return String.format("%sx^%s", co, ex);
    }
}

class MyList {

    private Integer length;

    private Node head;

    public MyList() {
        this.head = null;
        this.length = 0;
    }

    public void insertNode(Node node) {
        if (head == null) {
            head = node;
            return;
        }

        Node current = head;
        if (node.getEx() > current.getEx()) {   // if we need to add the node in the first position in the list
            node.setNext(head);
            head = node;
            length++;
            return;
        }

        while (current.getNext() != null && current.getNext().getEx() > node.getEx()) { // while there still are nodes in the list,
            current = current.getNext();                                                // and the exponent of the new node is smaller than the exponent of the next node
        }

        node.setNext(current.getNext());
        current.setNext(node);

        length++;
    }

    public Node getNodeByEx(Integer ex) {
        if (head == null) {
            return null;
        }

        Node current = head;
        while (current != null && !Objects.equals(current.getEx(), ex)) { // while there still are nodes in the list, and we haven't found the exponent yet
            current = current.getNext();
        }

        return current;
    }

    public void addNodeCoefficient(Node node) {
        if (getNodeByEx(node.getEx()) == null) {    // this covers the case when an exponent is not present in the list
            insertNode(node);                       // so it's inserted here
            return;
        }

        Node current = head;
        while (current.getNext() != null && !Objects.equals(current.getEx(), node.getEx())) {
            current = current.getNext();
        }

        Integer oldCo = current.getCo();
        current.setCo(oldCo + node.getCo());
    }

    public Integer getLength() {
        return length;
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

public class MainSequential {

    private static List<Node> nodeList = new ArrayList<>();

    private static MyList result;

    private static void readPoly(int polyIndex, int noPoly) {
        String fileTemplate = "E:\\__Teme\\Programare Paralela si Distribuita (PPD)\\Lab4\\files\\p{0}\\{1}.txt";

        try {
            File file;
            Scanner scanner;

            for (int i = 1; i <= noPoly; i++) {
                String fileName;
                fileName = fileTemplate.replace("{0}", String.valueOf(polyIndex));
                fileName = fileName.replace("{1}", String.valueOf(i));

                file = new File(fileName);
                scanner = new Scanner(file);

                int noMonomials = Integer.parseInt(scanner.nextLine());

                while (scanner.hasNextLine()) {
                    String data = scanner.nextLine();
                    String[] splitArr = data.split(" ");

                    int co = Integer.parseInt(splitArr[0]);
                    int ex = Integer.parseInt(splitArr[1]);

                    Node node = new Node(co, ex);
                    nodeList.add(node);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    private static void addPoly() {
        result = new MyList();

        for (Node n : nodeList) {
            result.addNodeCoefficient(n);
        }
    }

    public static void main(String[] args) {
        int polyIndex = Integer.parseInt(args[0]);
        int noPoly = Integer.parseInt(args[1]);

        long startTime = System.nanoTime();

        readPoly(polyIndex, noPoly);
        addPoly();

        long endTime = System.nanoTime();
        System.out.println((double)(endTime - startTime) / 1E6);

        //System.out.println(result);
        result.writeToFile(polyIndex);
    }
}
