package client_server.domain;

import java.io.Serializable;

public class Ora implements Serializable {
    private Integer ora;
    private Integer minut;

    public Ora(Integer ora, Integer minut) {
        this.ora = ora;
        this.minut = minut;
    }

    public Integer getOra() {
        return ora;
    }

    public void setOra(Integer ora) {
        this.ora = ora;
    }

    public Integer getMinut() {
        return minut;
    }

    public void setMinut(Integer minut) {
        this.minut = minut;
    }

    @Override
    public String toString() {
        return ora + ":" + minut;
    }

    public Ora adaugaMinute(Integer minute) {
        int minuteNoi = minut + minute;
        int oraNoua = ora + minuteNoi / 60;
        minuteNoi = minuteNoi % 60;

        return new Ora(oraNoua, minuteNoi);
    }
}
