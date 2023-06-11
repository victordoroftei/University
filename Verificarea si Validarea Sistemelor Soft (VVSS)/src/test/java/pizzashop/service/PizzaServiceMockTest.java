package pizzashop.service;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import pizzashop.model.MenuDataModel;
import pizzashop.model.Payment;
import pizzashop.model.PaymentType;
import pizzashop.repository.MenuRepository;
import pizzashop.repository.PaymentRepository;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class PizzaServiceMockTest {

    @Mock
    MenuRepository menuRepository;

    @Mock
    PaymentRepository paymentRepository;

    @InjectMocks
    PizzaService pizzaService;

    @Test
    public void test1() {
        MenuDataModel menuDataModel = new MenuDataModel("Quattro Stagioni Speciala George", 87, 8.7);
        List<MenuDataModel> menuItems = Collections.singletonList(menuDataModel);
        when(menuRepository.getMenu(any())).thenReturn(menuItems);

        List<MenuDataModel> actualMenuItems = pizzaService.getMenuData(new ArrayList<>());
        assertEquals(menuItems.size(), actualMenuItems.size());

        MenuDataModel firstMenuDataModel = actualMenuItems.get(0);
        assertEquals(menuDataModel.getMenuItem(), firstMenuDataModel.getMenuItem());
        assertEquals(menuDataModel.getQuantity(), firstMenuDataModel.getQuantity());
        assertEquals(menuDataModel.getPrice(), firstMenuDataModel.getPrice());
    }

    @Test
    public void test2() {
        Payment payment = new Payment(1, PaymentType.Cash, 8.7);
        List<Payment> payments = Collections.singletonList(payment);
        when(paymentRepository.getAllPayments()).thenReturn(payments);

        List<Payment> actualPayments = pizzaService.getPayments();
        assertEquals(payments.size(), actualPayments.size());

        Payment firstPayment = actualPayments.get(0);
        assertEquals(payment.getTableNumber(), firstPayment.getTableNumber());
        assertEquals(payment.getAmount(), firstPayment.getAmount());
        assertEquals(payment.getType(), firstPayment.getType());
    }
}
