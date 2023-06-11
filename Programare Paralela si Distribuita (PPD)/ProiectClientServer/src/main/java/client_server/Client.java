package client_server;

import client_server.domain.*;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ConnectException;
import java.net.Socket;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Random;

public class Client {
    private static final Integer PORT = 42069;
    private static final Integer NR_LOCATII = 5;
    private static final Integer NR_TRATAMENTE = 5;

    private static final String NUME = "Geani";
    private static final String CNP = "5123456789012";

    private static final LocalDate DATA_TRATAMENT = LocalDate.now();

    private static final Random random = new Random();

    private static Ora genereazaOra() {
        int ora = random.nextInt(10, 18);
        int minut = random.nextInt(0, 60);
        return new Ora(ora, minut);
    }

    private static Programare generareProgramare() {
        int locatie = random.nextInt(NR_LOCATII);
        int tratament = random.nextInt(NR_TRATAMENTE);
        return new Programare(
                null,
                NUME,
                CNP,
                LocalDateTime.now(),
                DATA_TRATAMENT,
                locatie,
                tratament,
                genereazaOra()
        );
    }

    public static void main(String[] args) throws IOException, InterruptedException, ClassNotFoundException {

        while (true) {
            Programare bookingDto = generareProgramare();

            try {
                Socket clientSocket = new Socket("localhost", PORT);
                System.out.println("Client conectat la server (programare), localhost:" + PORT + "\n");

                ObjectOutputStream outputStream = new ObjectOutputStream(clientSocket.getOutputStream());
                outputStream.writeObject(bookingDto);

                ObjectInputStream inputStream = new ObjectInputStream(clientSocket.getInputStream());
                Object response = inputStream.readObject();

                outputStream.close();
                inputStream.close();
                clientSocket.close();

                if (response instanceof RaspunsServer raspunsServer) {
                    if (raspunsServer.equals(RaspunsServer.SERVER_OPRIT)) {
                        break;
                    }
                }

                if (response instanceof CererePlata cererePlata) {
                    if (cererePlata.getRaspunsServer() == RaspunsServer.PROGRAMARE_REUSITA) {
                        Plata plata = new Plata(
                                cererePlata.getIdProgramare(),
                                null,
                                CNP,
                                cererePlata.getSuma()
                        );

                        Socket clientSocket2 = new Socket("localhost", PORT);
                        System.out.println("Client conectat la server (plata), localhost:" + PORT + "\n");

                        ObjectOutputStream outputStream2 = new ObjectOutputStream(clientSocket2.getOutputStream());
                        outputStream2.writeObject(plata);
                        outputStream2.close();
                        clientSocket2.close();

                        boolean cancelPayment = random.nextInt(1, 10) == 1;
                        if (cancelPayment) {
                            Socket clientSocket3 = new Socket("localhost", PORT);
                            System.out.println("Client conectat la server (anulare), localhost:" + PORT + "\n");

                            ObjectOutputStream outputStream3 = new ObjectOutputStream(clientSocket3.getOutputStream());

                            plata.setSuma((-1) * plata.getSuma());
                            outputStream3.writeObject(plata);

                            outputStream3.close();
                            clientSocket3.close();
                        }
                    }
                }
                Thread.sleep(2000);
            } catch (ConnectException ignored) {
                break;
            }
        }
    }
}
