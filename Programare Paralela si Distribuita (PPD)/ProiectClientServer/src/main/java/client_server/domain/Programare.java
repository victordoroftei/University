package client_server.domain;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Programare implements Serializable {
    private Integer idProgramare;
    private String nume;
    private String cnp;
    private LocalDateTime dataProgramare;
    private LocalDate dataTratament;
    private Integer locatieTratament;
    private Integer tipTratament;
    private Ora ora;

    public Programare(Integer idProgramare, String nume, String cnp, LocalDateTime dataProgramare, LocalDate dataTratament, Integer locatieTratament, Integer tipTratament, Ora ora) {
        this.idProgramare = idProgramare;
        this.nume = nume;
        this.cnp = cnp;
        this.dataProgramare = dataProgramare;
        this.dataTratament = dataTratament;
        this.locatieTratament = locatieTratament;
        this.tipTratament = tipTratament;
        this.ora = ora;
    }

    public Integer getIdProgramare() {
        return idProgramare;
    }

    public void setIdProgramare(Integer idProgramare) {
        this.idProgramare = idProgramare;
    }

    public String getNume() {
        return nume;
    }

    public void setNume(String nume) {
        this.nume = nume;
    }

    public String getCnp() {
        return cnp;
    }

    public void setCnp(String cnp) {
        this.cnp = cnp;
    }

    public LocalDateTime getDataProgramare() {
        return dataProgramare;
    }

    public void setDataProgramare(LocalDateTime dataProgramare) {
        this.dataProgramare = dataProgramare;
    }

    public LocalDate getDataTratament() {
        return dataTratament;
    }

    public void setDataTratament(LocalDate dataTratament) {
        this.dataTratament = dataTratament;
    }

    public Integer getLocatieTratament() {
        return locatieTratament;
    }

    public void setLocatieTratament(Integer locatieTratament) {
        this.locatieTratament = locatieTratament;
    }

    public Integer getTipTratament() {
        return tipTratament;
    }

    public void setTipTratament(Integer tipTratament) {
        this.tipTratament = tipTratament;
    }

    public Ora getOra() {
        return ora;
    }

    public void setOra(Ora ora) {
        this.ora = ora;
    }
}
