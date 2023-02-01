package client_server.logic;

import client_server.domain.CererePlata;

import java.net.Socket;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Future;

public class CereriActiveMap {
    private Boolean serverOprit = false;
    private Map<Socket, Future<CererePlata>> futureMap = new HashMap<>();

    public synchronized void opresteServer() {
        this.serverOprit = true;
        this.notify();
    }

    public synchronized void addFuture(Socket clientSocket, Future<CererePlata> cererePlataFuture) {
        futureMap.put(clientSocket, cererePlataFuture);
        this.notify();
    }

    public synchronized Map.Entry<Socket, Future<CererePlata>> getCereriPlataTerminate() {
        while (true) {
            // Daca nu sunt clienti conectati asteptam
            while (futureMap.size() == 0) {
                if (serverOprit) {
                    return null;
                }

                try {
                    this.wait();
                } catch (InterruptedException e) {
                    return null;
                }
            }

            for (Map.Entry<Socket, Future<CererePlata>> entry : futureMap.entrySet()) {
                // Daca a fost finalizata cererea
                if (entry.getValue().isDone()) {
                    futureMap.remove(entry.getKey());
                    return entry;
                }
            }
        }
    }
}
