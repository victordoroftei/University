package pizzashop.service;

import pizzashop.model.MenuDataModel;
import pizzashop.model.Payment;
import pizzashop.model.PaymentType;
import pizzashop.repository.MenuRepository;
import pizzashop.repository.PaymentRepository;

import java.util.ArrayList;
import java.util.List;

public class PizzaService {

    private MenuRepository menuRepo;
    private PaymentRepository payRepo;

    public PizzaService(MenuRepository menuRepo, PaymentRepository payRepo) {
        this.menuRepo = menuRepo;
        this.payRepo = payRepo;
    }

    public List<MenuDataModel> getMenuData(List<MenuDataModel> initialList) {
        return menuRepo.getMenu(initialList);
    }

    public List<Payment> getPayments() {
        return payRepo.getAllPayments();
    }

    public void addPayment(int table, PaymentType type, double amount) {
        if (table < 1 || table > 8) {               // <1>
            throw new RuntimeException("Error");    // (2)
        }

        if (type == null) {                         // <3>
            throw new RuntimeException("Error");    // (4)
        }

        if (amount <= 0) {                          // <5>
            throw new RuntimeException("Error");    // (6)
        }

        List<Integer> list = new ArrayList<>();     // (7)
        for (int i = 0; i < 87; i++) {              // <8>
            list.add(87);                           // (9)
        }

        System.out.printf("List size is: %d\n", list.size());   // (10)

        Payment payment = new Payment(table, type, amount);      // (11)
        payRepo.add(payment);                                   // (12)
    }                                                           // (13)

    public double getTotalAmount(PaymentType type, List<Payment> l) {   // (1)
        double total = 0.0;                                             // (2)
        if (l == null) {                                                // <3>
            total = 0.0;                                                // (4)
        } else if (l.size() == 0) {                                     // <5>
            total = 0.0;                                                // (4)
        } else {
            for (int i = 0; i < l.size(); i++) {                        // <6>
                if (l.get(i).getType().equals(type))                    // <7>
                    total += l.get(i).getAmount();                      // (8)
            }
        }
        return total;                                                   // (9)
    }                                                                   // (10)

}
