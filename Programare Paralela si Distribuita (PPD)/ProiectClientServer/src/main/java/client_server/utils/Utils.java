package client_server.utils;

import client_server.domain.Ora;

public class Utils {
    public static Boolean existaSuprapunereIntreOre(Ora ora1, Ora ora2, Ora ora3, Ora ora4) {
        if (comparaOre(ora1, ora3) > 0 && comparaOre(ora1, ora4) < 0) {
            return true;
        }
        if (comparaOre(ora2, ora3) > 0 && comparaOre(ora2, ora4) < 0) {
            return true;
        }
        if (comparaOre(ora3, ora1) > 0 && comparaOre(ora3, ora2) < 0) {
            return true;
        }
        if (comparaOre(ora4, ora1) > 0 && comparaOre(ora4, ora2) < 0) {
            return true;
        }
        if (comparaOre(ora1, ora3) == 0 && comparaOre(ora2, ora4) == 0) {
            return true;
        }

        return false;
    }

    public static Integer comparaOre(Ora ora1, Ora ora2) {
        return !ora1.getOra().equals(ora2.getOra()) ?
                ora1.getOra() - ora2.getOra()
                :
                ora1.getMinut() - ora2.getMinut();
    }

    public static Ora stringToOra(String oraString) {
        String[] arr = oraString.split(":");
        return new Ora(Integer.parseInt(arr[0]), Integer.parseInt(arr[1]));
    }
}
