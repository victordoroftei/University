package org.ppd.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class PaymentDTO implements Serializable {
    private Integer bookingPk;
    private LocalDateTime paymentDate;
    private String clientCnp;
    private Integer sum;

    public PaymentDTO() {}

    public PaymentDTO(Integer bookingPk, LocalDateTime paymentDate, String clientCnp, Integer sum) {
        this.bookingPk = bookingPk;
        this.paymentDate = paymentDate;
        this.clientCnp = clientCnp;
        this.sum = sum;
    }

    public Integer getBookingPk() {
        return bookingPk;
    }

    public void setBookingPk(Integer bookingPk) {
        this.bookingPk = bookingPk;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getClientCnp() {
        return clientCnp;
    }

    public void setClientCnp(String clientCnp) {
        this.clientCnp = clientCnp;
    }

    public Integer getSum() {
        return sum;
    }

    public void setSum(Integer sum) {
        this.sum = sum;
    }
}
