import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CitesteFisiere {

    static class Problema {
        int idConcurent;
        int idProblema;
        int punctaj;
        LocalDateTime timpIncarcare;

        public Problema(int idConcurent, int idProblema, int punctaj, LocalDateTime timpIncarcare) {
            this.idConcurent = idConcurent;
            this.idProblema = idProblema;
            this.punctaj = punctaj;
            this.timpIncarcare = timpIncarcare;
        }
    }

    static class Probleme {
        List<Problema> listaProbleme;

        public Probleme() {
            listaProbleme = new ArrayList<>();
        }

        public synchronized void add(Problema problema) {
            this.listaProbleme.add(problema);
        }
    }

    static class PrintThread extends Thread {
        Probleme probleme;

        public PrintThread(Probleme probleme) {
            this.probleme = probleme;
        }

        @Override
        public void run() {
            
        }
    }

    static class MyThread extends Thread {
        Probleme probleme;
        int startFisier;
        int endFisier;

        public MyThread(Probleme probleme, int startFisier, int endFisier) {
            this.probleme = probleme;
            this.startFisier = startFisier;
            this.endFisier = endFisier;
        }

        private List<Problema> getProblemeFromFisier(int fisierIndex) throws IOException {
            String path = "inp/" + fisierIndex + ".txt";
            FileReader fileReader = new FileReader(path);
            BufferedReader bufferedReader = new BufferedReader(fileReader);

            List<Problema> prob = new ArrayList<>();

            String line = bufferedReader.readLine();
            while (!line.isEmpty()) {
                String[] elems = line.strip().split(",");
                prob.add(new Problema(
                        Integer.parseInt(elems[0]),
                        Integer.parseInt(elems[1]),
                        Integer.parseInt(elems[2]),
                        LocalDateTime.parse(elems[3])
                ));
                line = bufferedReader.readLine();
            }

            return prob;
        }

        @Override
        public void run() {
            for (int i = startFisier; i < endFisier; i++) {
                try {
                    List<Problema> prob = getProblemeFromFisier(i);
                    prob.forEach(x -> probleme.add(x));
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }
}
