package com.titan.customer;

public class AddressDO implements java.io.Serializable {

	private String street;
    private String city;
    private String state;
    private String zip;
    private Integer id;
    
    public AddressDO(Integer id, String street, String city,
                   String state, String zip ) 
    {
        this.id = id;
        this.street = street;
        this.city = city;
        this.state = state;
        this.zip = zip;
    }
    public String getStreet(){
        return street;
    }
    public String getCity(){
        return city;
    }
    public String getState(){
        return state;
    }
    public String getZip(){
        return zip;
    }
    public Integer getId()
    {
        return id;
    }
}
