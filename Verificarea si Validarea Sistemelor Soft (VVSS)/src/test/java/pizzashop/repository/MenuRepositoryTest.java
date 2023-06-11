package pizzashop.repository;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import pizzashop.model.MenuDataModel;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;

public class MenuRepositoryTest {

    private List<MenuDataModel> list;

    @BeforeEach
    public void setUp() {
        this.list = new ArrayList<>();
    }

    @Test
    public void testFileEmpty() {
        MenuRepository menuRepository = new MenuRepository(Optional.of("data/testmenuempty.txt"));

        List<MenuDataModel> spyList = Mockito.spy(new ArrayList<>());

        List<MenuDataModel> menu = menuRepository.getMenu(spyList);
        assertEquals(0, menu.size());

        Mockito.verify(spyList, Mockito.times(0)).add(any());
    }

    @Test
    public void testFileNotEmpty() {
        MenuRepository menuRepository = new MenuRepository(Optional.of("data/testmenunotempty.txt"));

        List<MenuDataModel> mockList = Mockito.mock(ArrayList.class);
        menuRepository.getMenu(mockList);

        Mockito.verify(mockList, Mockito.times(1)).add(any());
    }
}
