package com.titan.clients;					

import com.titan.cabin.CabinHomeRemote;	
import com.titan.cabin.CabinRemote;	

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.ejb.EJBMetaData;
import javax.ejb.FinderException;
import javax.rmi.PortableRemoteObject;		
import java.rmi.RemoteException;
import java.util.Properties;
import java.io.*;

/**
 * Example showing use of primary keys.
 * 
 */
public class Client_54 {

    public static void main(String [] args) {
		try {

			Context jndiContext = getInitialContext();  

			Object ref = jndiContext.lookup("CabinHome");
			CabinHomeRemote home = (CabinHomeRemote)
				PortableRemoteObject.narrow(ref,CabinHomeRemote.class);

			testReferences(home);
			testSerialization(home);

			System.out.println("Removing Cabin from database to clean up..");
			// Make this client class re-entrant by cleaning up the bean we created
			Integer pk = new Integer(101);
			home.remove(pk);

        } catch (java.rmi.RemoteException re){re.printStackTrace();}
          catch (Throwable t){t.printStackTrace();}
	}

	/**
	 * Test the equivalence of two remote references to the same bean
	 */
	public static void testReferences(CabinHomeRemote home)		
		throws Exception {

		System.out.println("Creating Cabin 101 and retrieving additional reference by pk");
		CabinRemote cabin_1 = home.create(new Integer(101));
		Integer pk = (Integer)cabin_1.getPrimaryKey();
		CabinRemote cabin_2 = home.findByPrimaryKey(pk);

		System.out.println("Testing reference equivalence");
		// We now have two remote references to the same bean -- Prove it!
		cabin_1.setName("Keel Korner");
		if (cabin_2.getName().equals("Keel Korner")) {
			System.out.println("Names match!");
		}

		// Test the isIdentical() function
		if (cabin_1.isIdentical(cabin_2)) {
			System.out.println("cabin_1.isIdentical(cabin_2) returns true - This is correct");
		} else {
			System.out.println("cabin_1.isIdentical(cabin_2) returns false - This is wrong!");
		}

	}

	/**
	 * Test the serialization/deserialization of a primary key.
	 */
	public static void testSerialization(CabinHomeRemote home)		
		throws Exception {

		System.out.println("Testing serialization of primary key");
		Integer pk_1 = new Integer(101);
		CabinRemote cabin_1 = home.findByPrimaryKey(pk_1);
		System.out.println("Setting cabin name to Presidential Suite");

		cabin_1.setName("Presidential Suite");

		// Serialize the primary key for cabin 101 to a file.
		FileOutputStream fos = new FileOutputStream("pk101.ser");
		ObjectOutputStream outStream = new ObjectOutputStream(fos);
		System.out.println("Writing primary key object to file...");
		outStream.writeObject(pk_1);
		outStream.flush();
		outStream.close();
		pk_1 = null;

		// Deserialize the primary key for cabin 101.
		FileInputStream fis = new FileInputStream("pk101.ser");
		ObjectInputStream inStream = new ObjectInputStream(fis);
		System.out.println("Reading primary key object from file...");
		Integer pk_2 = (Integer)inStream.readObject();
		inStream.close();

		// Re-obtain a remote reference to cabin 101 and read its name.
		System.out.println("Acquiring reference using deserialized primary key...");
		CabinRemote cabin_2 = home.findByPrimaryKey(pk_2);
		System.out.println("Retrieving name of Cabin using new remote reference...");
		System.out.println(cabin_2.getName());
                System.exit(0);

	}

	static public Context getInitialContext() throws Exception {
		return new InitialContext();
	}
}


