package pizzashop.repository;

import pizzashop.model.MenuDataModel;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.StringTokenizer;

public class MenuRepository {
    private String filename = "data/menu.txt";
    private List<MenuDataModel> listMenu;

    public MenuRepository(Optional<String> filenameOptional) {
        filenameOptional.ifPresent(s -> this.filename = s);
    }

    private void readMenu(){
        //ClassLoader classLoader = MenuRepository.class.getClassLoader();
        File file = new File(filename);
        BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader(file));
            String line = null;
            while((line=br.readLine())!=null){
                MenuDataModel menuItem=getMenuItem(line);
                listMenu.add(menuItem);
            }
            br.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private MenuDataModel getMenuItem(String line){
        MenuDataModel item=null;
        if (line==null|| line.equals("")) return null;
        StringTokenizer st=new StringTokenizer(line, ",");
        String name= st.nextToken();
        double price = Double.parseDouble(st.nextToken());
        item = new MenuDataModel(name, 0, price);
        return item;
    }

    public List<MenuDataModel> getMenu(List<MenuDataModel> menuList) {
        this.listMenu = menuList;
        readMenu();//create a new menu for each table, on request
        return listMenu;
    }

    public void setListMenu(List<MenuDataModel> listMenu) {
        this.listMenu = listMenu;
    }
}