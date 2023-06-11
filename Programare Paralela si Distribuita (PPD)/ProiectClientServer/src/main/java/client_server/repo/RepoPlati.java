package client_server.repo;

import client_server.domain.Plata;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RepoPlati {
    private static final String DB_URL = "jdbc:sqlite:E:/__Teme/Programare Paralela si Distribuita (PPD)/ProiectClientServer/ProiectClientServer.db";

    public void add(Plata plata) {
        String query = """
                INSERT INTO Plata(cnp, suma, data_plata, id_programare)
                values (?, ?, ?, ?);
                """;
        try (Connection connection = DriverManager.getConnection(DB_URL);
             PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setString(1, plata.getCnp());
            statement.setInt(2, plata.getSuma());
            statement.setString(3, plata.getDataPlata().toString());
            statement.setInt(4, plata.getIdProgramare());

            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
