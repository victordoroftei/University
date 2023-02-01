package org.ppd;

import org.ppd.dto.BookingDTO;
import org.ppd.dto.Hour;
import org.ppd.dto.PaymentDTO;
import org.ppd.dto.PaymentDetailsDTO;
import org.ppd.dto.ResponseStatus;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ConnectException;
import java.net.Socket;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Random;

public class BookingsClient {
    private static final int port = 54321, numberLocations = 5, numberTreatments = 5;
    private static final String name = "George", cnp = "5112233445566";
    private static final LocalDate treatmentDate = LocalDate.now(); // for simplicity, we assume each client makes their
    // appointments in the same day
    private static final Random random = new Random();

    private static Hour generateHour() {
        int hour = random.nextInt(10, 18);
        int minute = random.nextInt(0, 60);
        return new Hour(hour, minute);
    }

    private static BookingDTO generateAppointmentDto() {
        int location = random.nextInt(numberLocations);
        int treatment = random.nextInt(numberTreatments);
        return new BookingDTO(null, name, cnp, LocalDateTime.now(), treatmentDate, location, treatment, generateHour());
    }

    public static void main(String[] args) throws IOException, InterruptedException, ClassNotFoundException {
//        System.out.println("Client started");

        while(true) {
            BookingDTO bookingDto = generateAppointmentDto();
            try {
                Socket clientSocket = new Socket("localhost", port);
//                System.out.println("Connected to the server");
                ObjectOutputStream outputStream = new ObjectOutputStream(clientSocket.getOutputStream());
//                System.out.println("before writing");
                outputStream.writeObject(bookingDto);
//                System.out.println("after writing");
                ObjectInputStream inputStream = new ObjectInputStream(clientSocket.getInputStream());
                Object response = inputStream.readObject();
                outputStream.close();
                inputStream.close();
                clientSocket.close();
//                System.out.println("Received a response from server after booking");
                if(response instanceof ResponseStatus responseStatus) {
                    if(responseStatus.equals(ResponseStatus.SERVER_STOPPED)) {
                        break;
                    }
                }
                if(response instanceof PaymentDetailsDTO paymentDetailsDTO) {
                    if (paymentDetailsDTO.getResponseStatus() == ResponseStatus.BOOKING_SUCCESSFUL) {
                        PaymentDTO paymentDTO = new PaymentDTO(paymentDetailsDTO.getBookingPk(), null, cnp, paymentDetailsDTO.getPrice());
                        Socket clientSocket2 = new Socket("localhost", port);
                        ObjectOutputStream outputStream2 = new ObjectOutputStream(clientSocket2.getOutputStream());
                        outputStream2.writeObject(paymentDTO);
                        outputStream2.close();
                        clientSocket2.close();
                        boolean cancelPayment = random.nextInt(1, 6) == 1;
                        if(cancelPayment) {
//                            Thread.sleep(700);
                            Socket clientSocket3 = new Socket("localhost", port);
                            ObjectOutputStream outputStream3 = new ObjectOutputStream(clientSocket3.getOutputStream());
                            paymentDTO.setSum((-1) * paymentDTO.getSum());
                            outputStream3.writeObject(paymentDTO);
                            outputStream3.close();
                            clientSocket3.close();
                        }
                    }
                }
                Thread.sleep(2000);
            } catch (ConnectException ignored) {
                //the server closed, bad luck :(
                break;
            }
        }
    }

}
