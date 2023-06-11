package pizzashop.service;

import org.junit.jupiter.api.*;
import org.mockito.Mockito;
import pizzashop.model.MenuDataModel;
import pizzashop.model.Payment;
import pizzashop.model.PaymentType;
import pizzashop.repository.MenuRepository;
import pizzashop.repository.PaymentRepository;

import java.io.*;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

public class PizzaServiceTest {

    private PizzaService pizzaService = new PizzaService(new MenuRepository(Optional.empty()), new PaymentRepository());

    // void addPayment(int table, PaymentType type, double amount)

    @AfterEach
    public void beforeEach() throws IOException {
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter("data/payments.txt"));
        bufferedWriter.close();
    }

    @Test
    @Order(1)
    @Timeout(5)
    @Tag("disabled")
    @DisplayName("disabledTest")
    @Disabled
    public void addPayment_disabled() {
        fail();
    }

    @Test
    @Order(1)
    @Timeout(5)
    @Tag("ECP")
    @DisplayName("TC1_ECP")
    public void addPayment_TC1_ECP() throws IOException {
        int table = 5;
        PaymentType type = PaymentType.Cash;
        double amount = 400;

        runTestRegular(table, type, amount);
    }

    @Test
    @Order(2)
    @Timeout(5)
    @Tag("ECP")
    @DisplayName("TC2_ECP")
    public void addPayment_TC2_ECP() {
        int table = -3;
        PaymentType type = PaymentType.Card;
        double amount = 7;

        runTestException(table, type, amount);
    }

    @Test
    @Order(3)
    @Timeout(5)
    @Tag("ECP")
    @DisplayName("TC3_ECP")
    public void addPayment_TC3_ECP() {
        int table = 2;
        PaymentType type = null;
        double amount = 8.787;

        runTestException(table, type, amount);
    }

    @Test
    @Order(4)
    @Timeout(5)
    @Tag("ECP")
    @DisplayName("TC4_ECP")
    public void addPayment_TC4_ECP() {
        int table = 1;
        PaymentType type = PaymentType.Cash;
        double amount = -87;

        runTestException(table, type, amount);
    }

    @Test
    @Order(5)
    @Timeout(5)
    @Tag("BVA")
    @DisplayName("TC1_BVA")
    public void addPayment_TC1_BVA() throws IOException {
        int table = 1;
        PaymentType type = PaymentType.Cash;
        double amount = 87;

        runTestRegular(table, type, amount);
    }

    @Test
    @Order(6)
    @Timeout(5)
    @Tag("BVA")
    @DisplayName("TC2_BVA")
    public void addPayment_TC2_BVA() {
        int table = 0;
        PaymentType type = PaymentType.Card;
        double amount = 187;

        runTestException(table, type, amount);
    }

    @Test
    @Order(7)
    @Timeout(5)
    @Tag("BVA")
    @DisplayName("TC3_BVA")
    public void addPayment_TC3_BVA() throws IOException {
        int table = 2;
        PaymentType type = PaymentType.Cash;
        double amount = 87;

        runTestRegular(table, type, amount);
    }

    @Test
    @Order(8)
    @Timeout(5)
    @Tag("BVA")
    @DisplayName("TC4_BVA")
    public void addPayment_TC4_BVA() throws IOException {
        int table = 8;
        PaymentType type = PaymentType.Card;
        double amount = 87;

        runTestRegular(table, type, amount);
    }

    @Test
    @Order(9)
    @Timeout(5)
    @Tag("BVA")
    @DisplayName("TC5_BVA")
    public void addPayment_TC5_BVA() throws IOException {
        int table = 7;
        PaymentType type = PaymentType.Cash;
        double amount = 8;

        runTestRegular(table, type, amount);
    }

    @Test
    @Order(10)
    @Timeout(5)
    @Tag("BVA")
    @DisplayName("TC6_BVA")
    public void addPayment_TC6_BVA() {
        int table = 9;
        PaymentType type = PaymentType.Cash;
        double amount = 7;

        runTestException(table, type, amount);
    }

    @Test
    @Order(11)
    @Timeout(5)
    @Tag("BVA")
    @DisplayName("TC7_BVA")
    public void addPayment_TC7_BVA() {
        int table = 8;
        PaymentType type = PaymentType.Cash;
        double amount = 0;

        runTestException(table, type, amount);
    }

    @Test
    @Order(12)
    @Timeout(5)
    @Tag("BVA")
    @DisplayName("TC8_BVA")
    public void addPayment_TC8_BVA() throws IOException {
        int table = 7;
        PaymentType type = PaymentType.Card;
        double amount = 87;

        runTestRegular(table, type, amount);
    }

    private void runTestException(int table, PaymentType type, double amount) {
        assertThrows(Exception.class, () -> pizzaService.addPayment(table, type, amount));
    }

    private void runTestRegular(int table, PaymentType type, double amount) throws IOException {
        pizzaService.addPayment(table, type, amount);

        List<Payment> payments = readFromFile();
        assertEquals(1, payments.size());

        Payment payment = payments.get(0);
        assertEquals(table, payment.getTableNumber());
        assertEquals(type, payment.getType());
        assertEquals(amount, payment.getAmount());
    }

    @Test
    @Order(13)
    @DisplayName("FC02_TC01")
    public void getTotalAmount_FC02_TC01() {
        double result = pizzaService.getTotalAmount(PaymentType.Card, null);
        assertEquals(0, result);
    }

    @Test
    @Order(14)
    @DisplayName("FC02_TC02")
    public void getTotalAmount_FC02_TC02() {
        double result = pizzaService.getTotalAmount(PaymentType.Card, new ArrayList<>());
        assertEquals(0, result);
    }

    @Test
    @Order(15)
    @DisplayName("FC02_TC03")
    public void getTotalAmount_FC02_TC03() {
        Payment object1 = new Payment(5, PaymentType.Cash, 87);
        double result = pizzaService.getTotalAmount(PaymentType.Card, List.of(object1));
        assertEquals(0, result);
    }

    @Test
    @Order(16)
    @DisplayName("FC02_TC04")
    public void getTotalAmount_FC02_TC04() {
        Payment object1 = new Payment(5, PaymentType.Cash, 87);
        double result = pizzaService.getTotalAmount(PaymentType.Cash, List.of(object1));
        assertEquals(87, result);
    }

    @Test
    @Order(17)
    @DisplayName("FC02_Invalid")
    public void getTotalAmount_FC02_Invalid() {
        Payment object1 = null;
        assertThrows(NullPointerException.class, () -> pizzaService.getTotalAmount(PaymentType.Cash, List.of(object1)));
    }


    private List<Payment> readFromFile() throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader("data/payments.txt"));
        String line;
        List<Payment> payments = new ArrayList<>();
        while ((line = bufferedReader.readLine()) != null) {
            String[] split = line.split(",");

            payments.add(new Payment(Integer.parseInt(split[0]),
                    split[1].equals("Cash") ? PaymentType.Cash : PaymentType.Card,
                    Double.parseDouble(split[2]))
            );
        }

        bufferedReader.close();
        return payments;
    }

}