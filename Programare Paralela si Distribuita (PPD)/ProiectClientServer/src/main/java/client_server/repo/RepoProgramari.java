package client_server.repo;

import client_server.domain.Programare;
import client_server.utils.Utils;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class RepoProgramari {
    private static final String DB_URL = "jdbc:sqlite:E:/__Teme/Programare Paralela si Distribuita (PPD)/ProiectClientServer/ProiectClientServer.db";
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public Programare add(Programare programare) {
        String query = """
                INSERT INTO Programare(nume, cnp, data_programare, data_tratament,
                locatie_tratament, tip_tratament, ora_tratament) VALUES (?, ?, ?, ?, ?, ?, ?);
                """;

        try (Connection connection = DriverManager.getConnection(DB_URL);
             PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setString(1, programare.getNume());
            statement.setString(2, programare.getCnp());
            statement.setString(3, programare.getDataProgramare().toString());
            statement.setString(4, DATE_TIME_FORMATTER.format(programare.getDataTratament()));
            statement.setInt(5, programare.getLocatieTratament());
            statement.setInt(6, programare.getTipTratament());
            statement.setString(7, programare.getOra().toString());

            statement.executeUpdate();
            ResultSet resultSet = statement.getGeneratedKeys();
            programare.setIdProgramare(resultSet.getInt(1));
            return programare;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Programare> getProgramariByLocatieAndTip(Integer locatie, Integer tip) {
        String query = """
                SELECT * FROM Programare WHERE locatie_tratament = ? AND tip_tratament = ?;
                """;

        try (Connection connection = DriverManager.getConnection(DB_URL);
             PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, locatie);
            statement.setInt(2, tip);

            return getProgramariFromResultSet(statement);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(Integer id) {
        String query = "DELETE FROM Programare WHERE id = ?;";

        try (Connection connection = DriverManager.getConnection(DB_URL);
             PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Integer getSumaForLocatie(Integer locatie) {
        String query = """
                SELECT SUM(Pl.suma)
                FROM Programare Pr
                INNER JOIN Plata Pl ON Pr.id = Pl.id_programare
                WHERE Pr.locatie_tratament = ?;
                """;

        try (Connection connection = DriverManager.getConnection(DB_URL);
             PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, locatie);

            ResultSet resultSet = statement.executeQuery();
            return resultSet.next() ?
                    resultSet.getInt(1)
                    :
                    null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Programare> getProgramariNeplatiteByLocatie(Integer locatie) {
        String query = """
                SELECT * FROM Programare
                WHERE locatie_tratament = ? AND id NOT IN
                (
                 SELECT id_programare FROM Plata
                 WHERE suma > 0 AND id_programare NOT IN
                 (
                  SELECT id_programare
                  FROM Plata
                  WHERE suma < 0
                 )
                );
                """;

        try (Connection connection = DriverManager.getConnection(DB_URL);
             PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, locatie);
            return getProgramariFromResultSet(statement);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private List<Programare> getProgramariFromResultSet(PreparedStatement statement) throws SQLException {
        ResultSet resultSet = statement.executeQuery();
        List<Programare> programari = new ArrayList<>();

        while (resultSet.next()) {
            programari.add(new Programare(
                    resultSet.getInt("id"),
                    resultSet.getString("nume"),
                    resultSet.getString("cnp"),
                    LocalDateTime.parse(resultSet.getString("data_programare")),
                    LocalDate.parse(resultSet.getString("data_tratament")),
                    resultSet.getInt("locatie_tratament"),
                    resultSet.getInt("tip_tratament"),
                    Utils.stringToOra(resultSet.getString("ora_tratament"))
            ));
        }
        return programari;
    }
}
