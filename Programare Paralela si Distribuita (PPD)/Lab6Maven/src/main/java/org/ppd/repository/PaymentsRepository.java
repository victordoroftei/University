package org.ppd.repository;

import org.ppd.dto.PaymentDTO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class PaymentsRepository {
    private static final String URL = "jdbc:sqlite:C:/Users/giosa/IdeaProjects/PPD/Home Labs/Lab6Maven/bookings.db";

    public void insert(PaymentDTO paymentDTO) {
        String sql = """
                insert into Payments(payment_date, client_cnp, sum, booking_pk)
                values (?, ?, ?, ?)
                """;
        try(Connection connection = DriverManager.getConnection(URL)) {
            PreparedStatement statement = connection.prepareStatement(sql);
            bindParametersToPreparedStatement(statement, paymentDTO);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void bindParametersToPreparedStatement(PreparedStatement statement, PaymentDTO paymentDTO) throws SQLException {
        statement.setString(1, paymentDTO.getPaymentDate().toString());
        statement.setString(2, paymentDTO.getClientCnp());
        statement.setInt(3, paymentDTO.getSum());
        statement.setInt(4, paymentDTO.getBookingPk());
    }

}
