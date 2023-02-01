package org.ppd.dto;

import java.io.Serializable;

public class Hour implements Serializable, Comparable<Hour> {
    private int hour, minute;

    public Hour(int hour, int minute) {
        this.hour = hour;
        this.minute = minute;
    }

    public int getHour() {
        return hour;
    }

    public void setHour(int hour) {
        this.hour = hour;
    }

    public int getMinute() {
        return minute;
    }

    public void setMinute(int minute) {
        this.minute = minute;
    }

    @Override
    public String toString() {
        return hour + ":" + minute;
    }

    public Hour plusMinutes(int minutes) {
        int newMinute = this.minute + minutes;
        int newHour = this.hour + (newMinute / 60);
        newMinute = newMinute % 60;
        return new Hour(newHour, newMinute);
    }

    /**
     * method that checks if the intervals (hour1, hour2) and (hour3, hour4) are overlapping
     */
    public static boolean isOverlappingInterval(Hour hour1, Hour hour2, Hour hour3, Hour hour4) {
        if(hour1.compareTo(hour3) > 0 && hour1.compareTo(hour4) < 0) {
            return true;
        }
        if(hour2.compareTo(hour3) > 0 && hour2.compareTo(hour4) < 0) {
            return true;
        }
        if(hour3.compareTo(hour1) >= 0 && hour4.compareTo(hour2) <= 0) {
            return true;
        }
        return false;
    }

    public static Hour parse(String hourString) {
        String[] tokens = hourString.split(":");
        if(tokens.length == 2) {
            int hour = Integer.parseInt(tokens[0]);
            int minute = Integer.parseInt(tokens[1]);
            return new Hour(hour, minute);
        }
        return null;
    }

    @Override
    public int compareTo(Hour other) {
        if(this.hour != other.hour) {
            return this.hour - other.hour;
        }
        return this.minute - other.minute;
    }
}
