package org.ppd;

import org.ppd.dto.BookingDTO;
import org.ppd.dto.Hour;
import org.ppd.dto.PaymentDTO;
import org.ppd.dto.PaymentDetailsDTO;
import org.ppd.dto.ResponseStatus;
import org.ppd.future.OngoingPaymentDetailsList;
import org.ppd.repository.BookingsRepository;
import org.ppd.repository.PaymentsRepository;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Future;
import java.util.concurrent.RejectedExecutionException;

public class MyTask implements Runnable{
    private final Socket client;
    private final ExecutorService executorService;
    private final OngoingPaymentDetailsList ongoingPaymentDetailsList;
    private final BookingsRepository bookingsRepository;
    private final PaymentsRepository paymentsRepository;
    private final int[] treatmentsCost, treatmentsTime;
    private final int[][] maxClients;

    public MyTask(Socket client, ExecutorService executorService, OngoingPaymentDetailsList ongoingPaymentDetailsList, BookingsRepository bookingsRepository, PaymentsRepository paymentsRepository, int[] treatmentsCost, int[] treatmentsTime, int[][] maxClients) {
        this.client = client;
        this.executorService = executorService;
        this.ongoingPaymentDetailsList = ongoingPaymentDetailsList;
        this.bookingsRepository = bookingsRepository;
        this.paymentsRepository = paymentsRepository;
        this.treatmentsCost = treatmentsCost;
        this.treatmentsTime = treatmentsTime;
        this.maxClients = maxClients;
    }

    @Override
    public void run() {
        ObjectInputStream inputStream;
        Object request;
        try {
//            System.out.println("before waiting to receive object");
            inputStream = new ObjectInputStream(client.getInputStream());
            request = inputStream.readObject();
//            System.out.println("after receiving the object");
        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        if(request instanceof BookingDTO bookingDTO) {
//            System.out.println("Got the booking");
            try {
                Future<PaymentDetailsDTO> paymentDetailsDTOFuture = reserveBooking(bookingDTO);
                ongoingPaymentDetailsList.addFuture(client, paymentDetailsDTOFuture);
            }catch (RejectedExecutionException exception) {
                try {
                    ObjectOutputStream outputStream = new ObjectOutputStream(client.getOutputStream());
                    outputStream.writeObject(ResponseStatus.SERVER_STOPPED);
                    outputStream.close();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        }

        else if(request instanceof PaymentDTO paymentDTO) {
            paymentDTO.setPaymentDate(LocalDateTime.now());
            //we register the payment
            if(paymentDTO.getSum() > 0) {
                synchronized (paymentsRepository) {
                    paymentsRepository.insert(paymentDTO);
                }
            }
            //cancel payment +  remove the correspondent booking
            else {
                synchronized (bookingsRepository) {
                    bookingsRepository.delete(paymentDTO.getBookingPk());
                    synchronized (paymentsRepository) {
                        paymentsRepository.insert(paymentDTO);
                    }
                }
            }
        }

        else {
            throw new RuntimeException("Error during deserialization!");
        }

    }

    private Future<PaymentDetailsDTO> reserveBooking(BookingDTO bookingDTO) {
        return executorService.submit(() -> {
            Hour bookingHour1 = bookingDTO.getHour();
            Hour bookingHour2 = bookingHour1.plusMinutes(treatmentsTime[bookingDTO.getTreatmentType()]);
            ResponseStatus bookingResponse;
            Integer bookingPk = null;
            synchronized (bookingsRepository) {
                List<BookingDTO> filteredBookings = bookingsRepository.getByTreatmentLocationAndType(bookingDTO.getTreatmentLocation(), bookingDTO.getTreatmentType());
                int overlappingBookings = 0;
                for (BookingDTO filteredBooking : filteredBookings) {
                    Hour filteredBookingHour1 = filteredBooking.getHour();
                    Hour filteredBookingHour2 = filteredBookingHour1.plusMinutes(treatmentsTime[bookingDTO.getTreatmentType()]);
                    if (Hour.isOverlappingInterval(bookingHour1, bookingHour2, filteredBookingHour1, filteredBookingHour2)) {
                        overlappingBookings++;
                    }
                }

                if (overlappingBookings < maxClients[bookingDTO.getTreatmentLocation()][bookingDTO.getTreatmentType()]) {
                    bookingPk = bookingsRepository.insert(bookingDTO).getBookingPk();
                    bookingResponse = ResponseStatus.BOOKING_SUCCESSFUL;
                } else {
                    bookingResponse = ResponseStatus.BOOKING_UNSUCCESSFUL;
                }
            }
            int treatmentPrice = treatmentsCost[bookingDTO.getTreatmentType()];
//          System.out.println("Finished computing the booking reservation");
            return new PaymentDetailsDTO(bookingResponse, bookingPk, treatmentPrice);
        });
    }
}
