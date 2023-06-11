package pizzashop.service;

import org.junit.jupiter.api.Test;
import pizzashop.model.MenuDataModel;
import pizzashop.repository.MenuRepository;
import pizzashop.repository.PaymentRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class Step3Test {

    @Test
    public void testMenuNotEmpty() {
        MenuRepository menuRepository = new MenuRepository(Optional.of("data/testmenunotempty.txt"));
        PaymentRepository paymentRepository = new PaymentRepository();
        PizzaService pizzaService = new PizzaService(menuRepository, paymentRepository);

        List<MenuDataModel> list = pizzaService.getMenuData(new ArrayList<>());
        assertEquals(1, list.size());

        assertEquals("Quattro Stagioni Speciala George", list.get(0).getMenuItem());
        assertEquals(0, list.get(0).getQuantity());
        assertEquals(8.7, list.get(0).getPrice());
    }

    @Test
    public void testMenuEmpty() {
        MenuRepository menuRepository = new MenuRepository(Optional.of("data/testmenuempty.txt"));
        PaymentRepository paymentRepository = new PaymentRepository();
        PizzaService pizzaService = new PizzaService(menuRepository, paymentRepository);

        List<MenuDataModel> list = pizzaService.getMenuData(new ArrayList<>());
        assertEquals(0, list.size());
    }
}
