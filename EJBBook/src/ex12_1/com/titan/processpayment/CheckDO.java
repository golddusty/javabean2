package com.titan.processpayment;

public class CheckDO implements java.io.Serializable {

    public String checkBarCode;
    public int checkNumber;

    public CheckDO(String barCode, int number) {
        checkBarCode = barCode;
        checkNumber = number;
    }
}
