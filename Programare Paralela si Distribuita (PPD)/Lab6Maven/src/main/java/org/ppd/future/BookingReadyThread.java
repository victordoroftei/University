package org.ppd.future;

import org.ppd.dto.PaymentDetailsDTO;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

public class BookingReadyThread extends Thread{
    private final OngoingPaymentDetailsList ongoingPaymentDetailsList;

    public BookingReadyThread(OngoingPaymentDetailsList ongoingPaymentDetailsList) {
        this.ongoingPaymentDetailsList = ongoingPaymentDetailsList;
    }

    @Override
    public void run() {
        while(true) {
            Map.Entry<Socket, Future<PaymentDetailsDTO>> entry = ongoingPaymentDetailsList.getDoneFuturePaymentDetailsDTO();
            if(entry == null) {
                return;
            }
//            System.out.println("Got a ready booking");
            Socket clientSocket = entry.getKey();
            PaymentDetailsDTO paymentDetailsDTO;
            try {
                paymentDetailsDTO = entry.getValue().get();
            } catch (InterruptedException | ExecutionException e) {
                throw new RuntimeException(e);
            }

            try {
                ObjectOutputStream outputStream = new ObjectOutputStream(clientSocket.getOutputStream());
                outputStream.writeObject(paymentDetailsDTO);
                clientSocket.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
