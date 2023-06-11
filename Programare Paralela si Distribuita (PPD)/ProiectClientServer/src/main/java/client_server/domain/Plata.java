package client_server.domain;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Plata implements Serializable {
    private Integer idProgramare;
    private LocalDateTime dataPlata;
    private String cnp;
    private Integer suma;

    public Plata(Integer idProgramare, LocalDateTime dataPlata, String cnp, Integer suma) {
        this.idProgramare = idProgramare;
        this.dataPlata = dataPlata;
        this.cnp = cnp;
        this.suma = suma;
    }

    public Integer getIdProgramare() {
        return idProgramare;
    }

    public void setIdProgramare(Integer idProgramare) {
        this.idProgramare = idProgramare;
    }

    public LocalDateTime getDataPlata() {
        return dataPlata;
    }

    public void setDataPlata(LocalDateTime dataPlata) {
        this.dataPlata = dataPlata;
    }

    public String getCnp() {
        return cnp;
    }

    public void setCnp(String cnp) {
        this.cnp = cnp;
    }

    public Integer getSuma() {
        return suma;
    }

    public void setSuma(Integer suma) {
        this.suma = suma;
    }
}
