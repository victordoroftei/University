package pizzashop.service;

import org.junit.jupiter.api.Test;
import pizzashop.model.MenuDataModel;
import pizzashop.repository.MenuRepository;
import pizzashop.repository.PaymentRepository;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class Step2Test {

    // Step 2. integrare R (se testează S cu R; pentru E se folosesc obiecte mock);

    @Test
    public void test1() {
        MenuRepository menuRepository = new MenuRepository(Optional.of("data/testmenunotempty.txt"));
        PaymentRepository paymentRepository = new PaymentRepository();
        PizzaService pizzaService = new PizzaService(menuRepository, paymentRepository);

        String menuItem = "Quattro Stagioni Speciala George";
        int quantity = 87;
        double price = 8.7;

        MenuDataModel menuDataModel = mock(MenuDataModel.class);
        when(menuDataModel.getMenuItem()).thenReturn(menuItem);
        when(menuDataModel.getQuantity()).thenReturn(quantity);
        when(menuDataModel.getPrice()).thenReturn(price);

        List<MenuDataModel> mockList = new ArrayList<>();
        mockList.add(menuDataModel);

        List<MenuDataModel> list = pizzaService.getMenuData(mockList);
        assertEquals(2, list.size());

        assertEquals(menuItem, list.get(0).getMenuItem());
        assertEquals(quantity, list.get(0).getQuantity());
        assertEquals(price, list.get(0).getPrice());
    }

    @Test
    public void test2() {
        MenuRepository menuRepository = new MenuRepository(Optional.of("data/testmenuempty.txt"));
        PaymentRepository paymentRepository = new PaymentRepository();
        PizzaService pizzaService = new PizzaService(menuRepository, paymentRepository);

        String menuItem = "Quattro Stagioni Speciala George";
        int quantity = 87;
        double price = 8.7;

        MenuDataModel menuDataModel = mock(MenuDataModel.class);
        when(menuDataModel.getMenuItem()).thenReturn(menuItem);
        when(menuDataModel.getQuantity()).thenReturn(quantity);
        when(menuDataModel.getPrice()).thenReturn(price);

        List<MenuDataModel> mockList = new ArrayList<>();
        mockList.add(menuDataModel);

        List<MenuDataModel> list = pizzaService.getMenuData(mockList);
        assertEquals(1, list.size());

        assertEquals(menuItem, list.get(0).getMenuItem());
        assertEquals(quantity, list.get(0).getQuantity());
        assertEquals(price, list.get(0).getPrice());
    }
}
