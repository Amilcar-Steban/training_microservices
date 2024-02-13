package com.aforo.model;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name="invoice")
@Data
public class Invoice implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    private Integer idInvoice;
    private double amount;
    private Integer state ;

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }
}
