package com.titan.clients;					

import com.titan.cabin.CabinHomeRemote;	
import com.titan.cabin.CabinRemote;	

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.ejb.Handle;
import javax.ejb.HomeHandle;
import javax.ejb.EJBMetaData;
import javax.ejb.FinderException;
import javax.rmi.PortableRemoteObject;		
import java.rmi.RemoteException;
import java.util.Properties;
import java.io.*;

/**
 * Example showing use of handles.
 * 
 */
public class Client_55 {

    public static void main(String [] args) {
		try {

			Context jndiContext = getInitialContext();  

			Object ref = jndiContext.lookup("CabinHome");
			CabinHomeRemote home = (CabinHomeRemote)
				PortableRemoteObject.narrow(ref,CabinHomeRemote.class);

			System.out.println("Testing serialization of EJBObject handle");

			Integer pk_1 = new Integer(100);
			CabinRemote cabin_1 = home.findByPrimaryKey(pk_1);

			// Serialize the Handle for cabin 100 to a file.
			Handle handle = cabin_1.getHandle();
			FileOutputStream fos = new FileOutputStream("handle100.ser");
			ObjectOutputStream outStream = new ObjectOutputStream(fos);
			System.out.println("Writing handle to file...");
			outStream.writeObject(handle);
			outStream.flush();
			fos.close();
			handle = null;

			// Deserialize the Handle for cabin 100.
			FileInputStream fis = new FileInputStream("handle100.ser");
			ObjectInputStream inStream = new ObjectInputStream(fis);
			System.out.println("Reading handle from file...");
			handle = (Handle)inStream.readObject();
			fis.close();

			// Reobtain a remote reference to cabin 100 and read its name.
			System.out.println("Acquiring reference using deserialized handle...");
			ref = handle.getEJBObject();
			CabinRemote cabin_2 = (CabinRemote)
				PortableRemoteObject.narrow(ref, CabinRemote.class);

			if(cabin_1.isIdentical(cabin_2)) {
				System.out.println("cabin_1.isIdentical(cabin_2) returns true - This is correct");
			} else {
				System.out.println("cabin_1.isIdentical(cabin_2) returns false - This is wrong!");
			}

			System.out.println("Testing serialization of Home handle");

			// Serialize the HomeHandle for the cabin bean.
			HomeHandle homeHandle = home.getHomeHandle();
			fos = new FileOutputStream("handle.ser");
			outStream = new ObjectOutputStream(fos);
			System.out.println("Writing Home handle to file...");
			outStream.writeObject(homeHandle);
			outStream.flush();
			fos.close();
			homeHandle = null;

			// Deserialize the HomeHandle for the cabin bean.
			fis = new FileInputStream("handle.ser");
			inStream = new ObjectInputStream(fis);
			System.out.println("Reading Home handle from file...");
			homeHandle = (HomeHandle)inStream.readObject();
			fis.close();

			System.out.println("Acquiring reference using deserialized Home handle...");
			Object hometemp = homeHandle.getEJBHome();
			CabinHomeRemote home2 = (CabinHomeRemote)
				PortableRemoteObject.narrow(hometemp,CabinHomeRemote.class);


			System.out.println("Acquiring reference to bean using new Home interface...");
			CabinRemote cabin_3 = home2.findByPrimaryKey(pk_1);

			// Test that we end up with the same bean after finding it through this home
			if(cabin_1.isIdentical(cabin_3)) {
				System.out.println("cabin_1.isIdentical(cabin_3) returns true - This is correct");
			} else {
				System.out.println("cabin_1.isIdentical(cabin_3) returns false - This is wrong!");
			}
                        


        } catch (java.rmi.RemoteException re){re.printStackTrace();}
          catch (Throwable t){t.printStackTrace();}
          System.exit(0);
	}


	static public Context getInitialContext() throws Exception {
		return new InitialContext();
	}
}


