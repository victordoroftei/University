package org.ppd.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class BookingDTO implements Serializable {
    private Integer bookingPk;
    private String name, cnp;
    private LocalDateTime date;
    private LocalDate treatmentDate;
    private int treatmentLocation, treatmentType;
    private Hour hour;

    public BookingDTO() {}

    public BookingDTO(Integer bookingPk, String name, String cnp, LocalDateTime date, LocalDate treatmentDate, int treatmentLocation, int treatmentType, Hour hour) {
        this.bookingPk = bookingPk;
        this.name = name;
        this.cnp = cnp;
        this.date = date;
        this.treatmentDate = treatmentDate;
        this.treatmentLocation = treatmentLocation;
        this.treatmentType = treatmentType;
        this.hour = hour;
    }

    public Integer getBookingPk() {
        return bookingPk;
    }

    public void setBookingPk(Integer bookingPk) {
        this.bookingPk = bookingPk;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCnp() {
        return cnp;
    }

    public void setCnp(String cnp) {
        this.cnp = cnp;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public LocalDate getTreatmentDate() {
        return treatmentDate;
    }

    public void setTreatmentDate(LocalDate treatmentDate) {
        this.treatmentDate = treatmentDate;
    }

    public int getTreatmentLocation() {
        return treatmentLocation;
    }

    public void setTreatmentLocation(int treatmentLocation) {
        this.treatmentLocation = treatmentLocation;
    }

    public int getTreatmentType() {
        return treatmentType;
    }

    public void setTreatmentType(int treatmentType) {
        this.treatmentType = treatmentType;
    }

    public Hour getHour() {
        return hour;
    }

    public void setHour(Hour hour) {
        this.hour = hour;
    }
}
