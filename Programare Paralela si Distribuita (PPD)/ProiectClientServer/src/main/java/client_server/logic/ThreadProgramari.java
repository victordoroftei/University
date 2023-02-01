package client_server.logic;

import client_server.domain.CererePlata;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

public class ThreadProgramari extends Thread {
    private final CereriActiveMap cereriActiveMap;

    public ThreadProgramari(CereriActiveMap cereriActiveMap) {
        this.cereriActiveMap = cereriActiveMap;
    }

    @Override
    public void run() {
        while (true) {
            Map.Entry<Socket, Future<CererePlata>> entry = cereriActiveMap.getCereriPlataTerminate();

            if (entry == null) {
                return;
            }

            Socket clientSocket = entry.getKey();
            CererePlata cererePlata;

            try {
                cererePlata = entry.getValue().get();
            } catch (InterruptedException | ExecutionException e) {
                throw new RuntimeException(e);
            }

            try {
                // Trimite mai departe rezultatul Future-ului pentru cererea de plata
                ObjectOutputStream outputStream = new ObjectOutputStream(clientSocket.getOutputStream());
                outputStream.writeObject(cererePlata);
                clientSocket.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
