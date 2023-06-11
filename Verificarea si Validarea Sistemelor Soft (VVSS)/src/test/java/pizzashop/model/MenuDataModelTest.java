package pizzashop.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class MenuDataModelTest {

    @Test
    public void quantityTest() {
        MenuDataModel menuDataModel = new MenuDataModel("Pizza Quattro Stagioni Speciala George", 87, 8.7);
        assertEquals(87, menuDataModel.getQuantity());
    }

    @Test
    public void priceTest() {
        MenuDataModel menuDataModel = new MenuDataModel("Pizza Quattro Stagioni Speciala George", 87, 8.7);
        menuDataModel.setPrice(100D);
        assertEquals(100D, menuDataModel.getPrice());
    }
}
