package org.ppd.repository;

import org.ppd.dto.BookingDTO;
import org.ppd.dto.Hour;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class BookingsRepository {
    private static final String URL = "jdbc:sqlite:C:/Users/giosa/IdeaProjects/PPD/Home Labs/Lab6Maven/bookings.db";
    private static final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public BookingDTO insert(BookingDTO bookingDTO) {
        String sql = """
                insert into Bookings(client_name, client_cnp, submission_date, treatment_location, treatment_type, treatment_date, treatment_time)
                values(?, ?, ?, ?, ?, ?, ?);
                """;
        try(Connection connection = DriverManager.getConnection(URL)) {
            PreparedStatement statement = connection.prepareStatement(sql);
            bindParametersToPreparedStatement(statement, bookingDTO);
            statement.executeUpdate();

            ResultSet rs = statement.getGeneratedKeys();
            bookingDTO.setBookingPk(rs.getInt(1));
            return bookingDTO;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<BookingDTO> getByTreatmentLocationAndType(int treatmentLocation, int treatmentType) {
        String sql = "select * from Bookings where treatment_location = ? and treatment_type = ?";
        try(Connection connection = DriverManager.getConnection(URL)) {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, treatmentLocation);
            statement.setInt(2, treatmentType);
            ResultSet resultSet = statement.executeQuery();
            List<BookingDTO> bookingDTOList = new ArrayList<>();
            while (resultSet.next()) {
                bookingDTOList.add(getBookingFromResultSet(resultSet));
            }
            return bookingDTOList;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(Integer bookingPk) {
        String sql = "delete from Bookings where booking_pk = ?";
        try(Connection connection = DriverManager.getConnection(URL)) {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, bookingPk);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Integer getTotalSumForLocation(int treatmentLocation) {
        String sql = """
                select sum(P.sum)
                from Bookings B
                inner join Payments P
                    on B.booking_pk = P.booking_pk
                where treatment_location = ?
                """;
        try(Connection connection = DriverManager.getConnection(URL);
        PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, treatmentLocation);
            ResultSet resultSet = statement.executeQuery();
            if(resultSet.next()) {
                return resultSet.getInt(1);
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<BookingDTO> getUnpaidBookingsForLocation(Integer location) {
        String sql = """
                select *
                from Bookings
                where treatment_location = ? and booking_pk not in
                    (
                        select booking_pk
                        from Payments
                        where sum > 0 and booking_pk not in
                        (
                            select booking_pk
                            from Payments
                            where sum < 0
                        )
                    )
                """;
        try(Connection connection = DriverManager.getConnection(URL);
        PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, location);
            ResultSet resultSet = statement.executeQuery();
            List<BookingDTO> bookingDTOList = new ArrayList<>();
            while (resultSet.next()) {
                bookingDTOList.add(getBookingFromResultSet(resultSet));
            }
            return bookingDTOList;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void bindParametersToPreparedStatement(PreparedStatement statement, BookingDTO bookingDTO) throws SQLException {
        statement.setString(1, bookingDTO.getName());
        statement.setString(2, bookingDTO.getCnp());
        statement.setString(3, bookingDTO.getDate().toString());
        statement.setInt(4, bookingDTO.getTreatmentLocation());
        statement.setInt(5, bookingDTO.getTreatmentType());
        statement.setString(6, bookingDTO.getTreatmentDate().format(dateFormatter));
        statement.setString(7, bookingDTO.getHour().toString());
    }

    private BookingDTO getBookingFromResultSet(ResultSet resultSet) throws SQLException {
        BookingDTO bookingDTO = new BookingDTO();
        bookingDTO.setBookingPk(resultSet.getInt("booking_pk"));
        bookingDTO.setName(resultSet.getString("client_name"));
        bookingDTO.setCnp(resultSet.getString("client_cnp"));
        bookingDTO.setDate(LocalDateTime.parse(resultSet.getString("submission_date")));
        bookingDTO.setTreatmentLocation(resultSet.getInt("treatment_location"));
        bookingDTO.setTreatmentType(resultSet.getInt("treatment_type"));
        bookingDTO.setTreatmentDate(LocalDate.parse(resultSet.getString("treatment_date")));
        bookingDTO.setHour(Hour.parse(resultSet.getString("treatment_time")));

        return bookingDTO;
    }
}
