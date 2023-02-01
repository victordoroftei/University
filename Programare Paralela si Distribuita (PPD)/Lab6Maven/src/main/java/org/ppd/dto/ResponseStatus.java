package org.ppd.dto;

import java.io.Serializable;

public enum ResponseStatus implements Serializable {
    BOOKING_SUCCESSFUL, BOOKING_UNSUCCESSFUL, PAYMENT_SUCCESSFUL, PAYMENT_UNSUCCESSFUL, SERVER_STOPPED
}
