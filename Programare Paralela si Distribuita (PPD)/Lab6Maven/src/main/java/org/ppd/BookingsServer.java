package org.ppd;

import org.ppd.dto.BookingDTO;
import org.ppd.dto.Hour;
import org.ppd.future.BookingReadyThread;
import org.ppd.future.OngoingPaymentDetailsList;
import org.ppd.repository.BookingsRepository;
import org.ppd.repository.PaymentsRepository;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class BookingsServer {
    private static final long secondsRunning = 300;
    private static final int timeInterval = 15;
    private static int currentCheck = 1;
    private static int numberLocations, numberTreatments;
    private static int[] treatmentsCost, treatmentsTime;
    private static int[][] maxClients;
    private static ExecutorService executor;
    private static final ScheduledExecutorService systemCheckerExecutor = Executors.newSingleThreadScheduledExecutor();
    private static final int port = 54321;
    private static final BookingsRepository bookingsRepository = new BookingsRepository();
    private static final PaymentsRepository paymentsRepository = new PaymentsRepository();
    private static final OngoingPaymentDetailsList ongoingPaymentDetailsList = new OngoingPaymentDetailsList();
    public static void main(String[] args) throws IOException, InterruptedException {
        initialiseServer();
        ServerSocket serverSocket = new ServerSocket(port);
//        System.out.println("Server started");
        //we initialise the thread that will check if the bookings are ready and communicates back with the clients
        BookingReadyThread bookingReadyThread = new BookingReadyThread(ongoingPaymentDetailsList);
        bookingReadyThread.start();
        //we start the system checker
        startSystemChecker();
        var startTime = System.currentTimeMillis();
        while(true) {
            if(System.currentTimeMillis() - startTime > secondsRunning * 1000) {
//                System.out.println("Entered shutdown methods");
                systemCheckerExecutor.shutdown();
                ongoingPaymentDetailsList.serverStopped();
                shutdownAndAwaitTermination(executor);
                break;
            }
            Socket client = serverSocket.accept();
//            System.out.println("Server received a request");
            MyTask task = new MyTask(client, executor, ongoingPaymentDetailsList, bookingsRepository, paymentsRepository, treatmentsCost, treatmentsTime, maxClients);
            executor.execute(task);
//            System.out.println("Passed the task");
        }
//        System.out.println("Server exits while loop");
        serverSocket.close();
        bookingReadyThread.join();
    }

    private static void startSystemChecker() {
        systemCheckerExecutor.scheduleAtFixedRate(() -> {
            BufferedWriter bufferedWriter;
            try {
                if(currentCheck == 1) {
                    bufferedWriter = new BufferedWriter(new FileWriter("output.txt"));
                }
                else {
                    bufferedWriter = new BufferedWriter(new FileWriter("output.txt", true));
                }
                bufferedWriter.write("Check number " + currentCheck + "\nTime: " + LocalDateTime.now() + "\n");
                synchronized (bookingsRepository) {
                    synchronized (paymentsRepository) {
                        for(int currentLocation = 0; currentLocation < numberLocations; currentLocation++) {
                            Integer totalSum = bookingsRepository.getTotalSumForLocation(currentLocation);
                            bufferedWriter.write("Location " + currentLocation + " -> totalSum=" + totalSum + "\n");
                            List<BookingDTO> unpaidBookings = bookingsRepository.getUnpaidBookingsForLocation(currentLocation);
                            String unpaidBookingsIds = unpaidBookings.stream().map(bookingDTO -> bookingDTO.getBookingPk().toString()).reduce("", (a, b) -> a + b + " ");
                            if("".equals(unpaidBookingsIds)) {
                                unpaidBookingsIds = "none";
                            }
                            bufferedWriter.write("\tUnpaid reservations ids: " + unpaidBookingsIds + "\n");

                            for(int currentTreatmentType = 0; currentTreatmentType < numberTreatments; currentTreatmentType++) {
                                List<BookingDTO> filteredBookingDTOs = bookingsRepository.getByTreatmentLocationAndType(currentLocation, currentTreatmentType);
                                int treatmentTime = treatmentsTime[currentTreatmentType];
                                List<Integer> maxClientsAtCertainIntervals = new ArrayList<>();
                                Hour currentHour = new Hour(10, 0);
                                Hour finalHour = new Hour(18, 0);
                                while(currentHour.compareTo(finalHour) <= 0) {
                                    int partialResult = 0;
                                    for(BookingDTO bookingDTO: filteredBookingDTOs) {
                                        Hour startHour = bookingDTO.getHour();
                                        Hour endHour = bookingDTO.getHour().plusMinutes(treatmentTime);
                                        if(currentHour.compareTo(startHour) > 0 && currentHour.compareTo(endHour) < 0) {
                                            partialResult++;
                                        }
                                    }
                                    maxClientsAtCertainIntervals.add(partialResult);
                                    currentHour = currentHour.plusMinutes(timeInterval);
                                }

                                int maxClientsCurrentTreatment = maxClients[currentLocation][currentTreatmentType];
                                String stringMaxClientsAtCertainIntervals = maxClientsAtCertainIntervals.stream()
                                        .peek(noClients -> {
                                            assert noClients <= maxClientsCurrentTreatment;
                                        })
                                        .map(Object::toString)
                                        .reduce("", (a, b) -> a + b + " ");
                                bufferedWriter.write("treatment type=" + currentTreatmentType + " with max clients=" + maxClientsCurrentTreatment + " has the following clients(every " + timeInterval + " minutes measurements): " + stringMaxClientsAtCertainIntervals + "\n");
                            }
                        }
                    }
                }
                bufferedWriter.write("\n\n");
                bufferedWriter.close();
                currentCheck++;
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }, 5, 5, TimeUnit.SECONDS);
    }

    private static void shutdownAndAwaitTermination(ExecutorService pool) {
        pool.shutdown(); // Disable new tasks from being submitted
        try {
            // Wait a while for existing tasks to terminate
            if (!pool.awaitTermination(60, TimeUnit.SECONDS)) {
                pool.shutdownNow(); // Cancel currently executing tasks
                // Wait a while for tasks to respond to being cancelled
                if (!pool.awaitTermination(60, TimeUnit.SECONDS))
                    System.err.println("Pool did not terminate");
            }
        } catch (InterruptedException ie) {
            // (Re-)Cancel if current thread also interrupted
            pool.shutdownNow();
            // Preserve interrupt status
            Thread.currentThread().interrupt();
        }
    }

    private static void initialiseServer() throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("server.txt"));
        int p = scanner.nextInt(); //number of threads from the ExecutorService
        executor = Executors.newFixedThreadPool(p);
        numberLocations = scanner.nextInt();
        numberTreatments = scanner.nextInt();
        treatmentsCost = new int[numberTreatments];
        treatmentsTime = new int[numberTreatments];
        maxClients = new int[numberLocations][numberTreatments];
        for(int i = 0; i < numberTreatments; i++) {
            treatmentsCost[i] = scanner.nextInt();
        }
        for(int i = 0; i < numberTreatments; i++) {
            treatmentsTime[i] = scanner.nextInt();
        }
        for(int j = 0; j < numberTreatments; j++) {
            maxClients[0][j] = scanner.nextInt();
        }
        for(int i = 1; i < numberLocations; i++) {
            for(int j = 0; j < numberTreatments; j++) {
                maxClients[i][j] = maxClients[0][j] * i;
            }
        }
    }
}
