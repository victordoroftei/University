package org.ppd.future;

import org.ppd.dto.PaymentDetailsDTO;

import java.net.Socket;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Future;

public class OngoingPaymentDetailsList {
    private Boolean serverStopped = false;
    private Map<Socket, Future<PaymentDetailsDTO>> futureMap = new HashMap<>();

    public synchronized void serverStopped() {
        this.serverStopped = true;
        this.notifyAll();
    }

    public synchronized void addFuture(Socket clientSocket, Future<PaymentDetailsDTO> paymentDetailsDTOFuture) {
        futureMap.put(clientSocket, paymentDetailsDTOFuture);
        this.notify(); //or notifyAll, we'll see
    }

    public synchronized Map.Entry<Socket, Future<PaymentDetailsDTO>> getDoneFuturePaymentDetailsDTO() {
        while(true) {
            while(futureMap.size() == 0) {
                if(serverStopped) {
                    return null;
                }
                try {
                    this.wait();
                } catch (InterruptedException e) {
                    return null;
                }
            }
            for(Map.Entry<Socket, Future<PaymentDetailsDTO>> entry: futureMap.entrySet()) {
                if(entry.getValue().isDone()) {
                    futureMap.remove(entry.getKey());
                    return entry;
                }
            }
        }
    }
}
