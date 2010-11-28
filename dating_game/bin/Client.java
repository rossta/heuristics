import java.io.*;
import java.net.*;
import java.util.*;


public class Client 
{

	public static void main(String[] args) throws Exception 
	{
		Socket socket = null;
		PrintWriter out = null;
		BufferedReader in = null;
		Vector<Double> candidate = new Vector<Double>();
		String ID = args[0];

		try 
		{
			socket = new Socket("localhost", 20000);
			out = new PrintWriter(socket.getOutputStream(), true);
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		} 
		catch (UnknownHostException e) 
		{
			System.out.println("Unknown host");
			System.exit(-1);
		} 
		catch (IOException e) 
		{
			System.out.println("No I/O");
			System.exit(-1);
		}

		String inputLine;
		String[]  parse;
		int N = 0;
		
		out.println(ID);

		
		while ((inputLine = in.readLine()) != null && ID.equals("Person")) 
		{
			System.out.println("" + inputLine);
			if (inputLine.startsWith("N:")) 
			{
				parse = inputLine.split(":");
				N = Integer.parseInt(parse[1]);
				out.println("Person.txt"); 
			}

			if(inputLine.equals("VALID ATTRIBUTES") || inputLine.equals("INVALID ATTRIBUTES")) 
			{
				inputLine = in.readLine();
				if(inputLine.equals("DISCONNECT"))
					break;
			}

		}

		while ((inputLine = in.readLine()) != null && ID.equals("Matchmaker")) 
		{
			System.out.println("" + inputLine);
			if (inputLine.startsWith("N:")) 
			{
				parse = inputLine.split(":");
				N = Integer.parseInt(parse[1]);
				
				for(int i = 0; i < 20; i++) 
				{
					inputLine = in.readLine();
					System.out.println("" + inputLine); 
				}
			}

			if(inputLine.startsWith("SCORE:")) 
			{
				
				Random generator = new Random();
				int temp;
				String candVector;
				
				for(int k = 0; k < N; k++) 
				{
					temp = (int)(generator.nextDouble() * 100);
					candidate.add(k,((double)temp)/100);
						
				}
				candVector = Double.toString(candidate.get(0));
				
				for(int k = 1; k < N; k++) 
				{
						candVector = candVector.concat(":" + (Double.toString(candidate.get(k))));

				}

				out.println("" + candVector);

			}
			if(inputLine.equals("DISCONNECT"))
				break;
	
			if(inputLine.equals("IDEAL CANDIDATE FOUND") || inputLine.equals("NO MORE CANDIDATES")) 
			{
				inputLine = in.readLine(); 
				System.out.println("" + inputLine);
				break;
			}
			
		}

		out.close();
		in.close();
		socket.close();
	}


}

