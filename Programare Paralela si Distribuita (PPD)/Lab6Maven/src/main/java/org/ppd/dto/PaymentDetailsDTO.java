package org.ppd.dto;

import java.io.Serializable;

public class PaymentDetailsDTO implements Serializable {
    private Integer bookingPk;
    private ResponseStatus responseStatus;
    private int price;

    public PaymentDetailsDTO(ResponseStatus responseStatus, Integer bookingPk, int price) {
        this.responseStatus = responseStatus;
        this.bookingPk = bookingPk;
        this.price = price;
    }

    public Integer getBookingPk() {
        return bookingPk;
    }

    public void setBookingPk(Integer bookingPk) {
        this.bookingPk = bookingPk;
    }

    public ResponseStatus getResponseStatus() {
        return responseStatus;
    }

    public void setResponseStatus(ResponseStatus responseStatus) {
        this.responseStatus = responseStatus;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }
}
