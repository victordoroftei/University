package client_server.domain;

import java.io.Serializable;

public class CererePlata implements Serializable {
    private Integer idProgramare;
    private RaspunsServer raspunsServer;
    private Integer suma;

    public CererePlata(Integer idProgramare, RaspunsServer raspunsServer, Integer suma) {
        this.idProgramare = idProgramare;
        this.raspunsServer = raspunsServer;
        this.suma = suma;
    }

    public Integer getIdProgramare() {
        return idProgramare;
    }

    public void setIdProgramare(Integer idProgramare) {
        this.idProgramare = idProgramare;
    }

    public RaspunsServer getRaspunsServer() {
        return raspunsServer;
    }

    public void setRaspunsServer(RaspunsServer raspunsServer) {
        this.raspunsServer = raspunsServer;
    }

    public Integer getSuma() {
        return suma;
    }

    public void setSuma(Integer suma) {
        this.suma = suma;
    }
}
