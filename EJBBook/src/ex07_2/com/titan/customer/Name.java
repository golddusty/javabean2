package com.titan.customer;

public class Name implements java.io.Serializable {

	private String lastName;
    private String firstName;
    
    public Name(String lname, String fname){
        lastName = lname;
        firstName = fname;
    }
    public String getLastName() {
        return lastName;
    }
    public String getFirstName() {
        return firstName;
    }
}
