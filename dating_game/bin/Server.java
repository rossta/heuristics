import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Server 
{

	static ServerSocket sSocket = null;
	static int port = 20000;	

	public static void main(String[] args) 
	{
		try 
		{
			sSocket = new ServerSocket(port);
			System.out.println("Waiting for client ...");
		}
		catch(IOException e) 
		{
			System.out.println("Could not listen on port: 20000");
			System.exit(-1);
		}

		

		while(true) 
		{
			Socket socket = null;
			try 
			{  
				socket = sSocket.accept();
				DatGame dg = new DatGame(socket);
				Thread  thread = new Thread(dg);
				thread.start();
			} 
			catch (IOException e) 
			{
				System.out.println("Accept failed: 20000");
				System.exit(-1);
			} 
		}  

		
	}
	
	public static void forceClose() 
	{
		System.exit(-1);
	}
	

}

