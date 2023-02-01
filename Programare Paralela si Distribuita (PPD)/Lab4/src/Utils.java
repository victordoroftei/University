import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

public class Utils {

    private static int generateAvailableRank(int maxRank, List<Integer> usedRanks) {
        Random random = new Random();
        int generatedRank = random.nextInt(maxRank);

        while (usedRanks.contains(generatedRank)) {
            generatedRank = random.nextInt(maxRank);
        }

        return generatedRank;
    }

    public static void generatePoly(int maxRank, int noMonomials, String fileName) {
        Random random = new Random();
        List<Integer> usedRanks = new ArrayList<>();

        List<Integer> listCo = new ArrayList<>();
        List<Integer> listEx = new ArrayList<>();
        int actualNoMonomials = 0;

        for (int i = 0; i < noMonomials; i++) {
            int generatedCo = random.nextInt(201) - 100;  // generates numbers in the (-100, 100) interval

            if (generatedCo != 0) {
                int generatedRank = generateAvailableRank(maxRank, usedRanks);
                usedRanks.add(generatedRank);

                listCo.add(generatedCo);
                listEx.add(generatedRank);

                actualNoMonomials++;
            }
        }

        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(fileName));
            writer.write(String.valueOf(actualNoMonomials) + "\n");

            for (int i = 0; i < actualNoMonomials; i++) {
                writer.write(String.format("%s %s\n", listCo.get(i), listEx.get(i)));
            }

            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void generateAllPoly(int maxRank, int noMonomials, int polyIndex, int noPoly) {
        String fileTemplate = "E:\\__Teme\\Programare Paralela si Distribuita (PPD)\\Lab4\\files\\p{0}\\{1}.txt";

        for (int i = 1; i <= noPoly; i++) {
            String fileTemplateReplaced;
            fileTemplateReplaced = fileTemplate.replace("{0}", String.valueOf(polyIndex));
            fileTemplateReplaced = fileTemplateReplaced.replace("{1}", String.valueOf(i));
            generatePoly(maxRank, noMonomials, fileTemplateReplaced);
        }
    }

    public static void main(String[] args) {
        //generateAllPoly(10000, 100, 2, 5);
    }
}
