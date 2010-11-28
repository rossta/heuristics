import java.io.*;
import java.net.Socket;
import java.util.*;
import java.net.*;
import java.lang.Math;
import java.lang.String;

public class DatGame implements Runnable
{
	Socket socket = null;
	PrintWriter out = null;
	BufferedReader in = null;
	private static Vector<Double> person = new Vector<Double>();
	private Vector<Double> randomCandidate = new Vector<Double>();
	private Vector<Double> clientCandidate = new Vector<Double>();
	private int N = 5;
	private boolean ready = false;

	public DatGame(Socket socket)
	{
		this.socket = socket;

		try
		{
			out = new PrintWriter(socket.getOutputStream(), true);
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		}
		catch (IOException e)
		{
			System.err.println("No I/O");
			System.exit(-1);
		}
	}

	public void run()
	{
		try
		{
			processRequest();
		}

		catch (Exception e)
		{
			System.out.println("Error in run method");
		}

	}

	public void processRequest()
	{

		String inputLine = null;
		try
		{
			inputLine = in.readLine();//read client ID

			if(inputLine.equals("Person"))
			{
				System.out.println("Interacting with Person");

				out.println("N:" + N);
				inputLine = in.readLine();
				System.out.println("" + inputLine);

				InputStream is = new FileInputStream(inputLine);
				BufferedReader fileinput = new BufferedReader(new InputStreamReader(is));

				String fileText;
				int index = 0;
				while (( fileText = fileinput.readLine()) != null)
				{
					Double wt = Double.parseDouble(fileText);
					person.add(index,wt);
					index++;
				}

				//verify person's attributes
				double sumPositive = 0;
				double sumNegative = 0;
				for(int i = 0; i < index; i++)
				{
				  System.out.println("person["+i+"]: " + person.get(i));
					if(person.get(i) < 0)
					{
						sumNegative += person.get(i);
					}
					else
						sumPositive += person.get(i);
				}
        System.out.println("pos: " + sumPositive);
        System.out.println("neg: " + sumNegative);

				if(sumPositive == 1 && sumNegative == -1)
				{
					out.println("VALID ATTRIBUTES");
					out.println("DISCONNECT");
					ready = true;
				}

				else
				{
					out.println("INVALID ATTRIBUTES");
					out.println("DISCONNECT");
				}


			}


					if(inputLine.equals("Matchmaker")) {

						System.out.println("Interacting with Matchmaker");
						out.println("");
						out.println("N:" + N);

						//generate 20 random candidates
						Random generator = new Random();
						double score = 0;
						int temp;
						String randCandidate;


						for(int i = 0; i < 20; i++)
						{
							for(int k = 0; k < person.size(); k++)
							{
								temp = (int)(generator.nextDouble() * 100);//round off to two decimal places
								randomCandidate.add(k,((double)temp)/100);

							}

							randCandidate = Double.toString(randomCandidate.get(0));
							score = 0;
							for(int k = 0; k < person.size(); k++)
							{
								score = score + (randomCandidate.get(k) * person.get(k));
								if(k > 0)
									randCandidate = randCandidate.concat(":" + (Double.toString(randomCandidate.get(k))));

							}
							temp = (int) (score * 100);
							score = ((double)temp)/100;
							randCandidate = (Double.toString(score)).concat(":" + randCandidate);
							out.println("" + randCandidate);
						}

						int cCount = 0;
						double[] cScore = new double[20];
						double totalScore = 0;
						String parse[];

						out.println("SCORE:0:0:0");
						while ((inputLine = in.readLine()) != null)
						{
							System.out.println("" + inputLine);

							parse = inputLine.split(":");
							for(int i = 0; i < N; i++)
							{
								clientCandidate.add(i,Double.parseDouble(parse[i]));
							}


							cScore[cCount] = 0;
							for(int i = 0; i < person.size(); i++)
							{
								cScore[cCount] += (clientCandidate.get(i) * person.get(i));
							}

							temp = (int) (cScore[cCount] * 100);
							cScore[cCount] = ((double)temp)/100;

							totalScore += cScore[cCount];

							temp = (int) (totalScore * 100);
							totalScore = ((double)temp)/100;


							if(cScore[cCount] == 1)
							{
								out.println("IDEAL CANDIDATE FOUND");
								out.println("FINAL SCORE:" + cScore[cCount] + ":"+ totalScore + ":" + (cCount + 1));
								break;
							}

							if(cCount == 19)
							{
								out.println("NO MORE CANDIDATES");
								out.println("FINAL SCORE:" + cScore[cCount] + ":" + totalScore + ":" + (cCount + 1));
								break;
							}

							out.println("SCORE:" + cScore[cCount] + ":" + totalScore + ":" + (cCount + 1));
							cCount++;

						}

						out.println("DISCONNECT");
				}
		}
		catch (IOException e) {
			System.out.println("IO Exception: " + e);
			System.exit(-1);
		}
		finally {
			try	{
				out.close();
				in.close();
				socket.close();
			}
			catch(IOException e) {
				System.out.println("IO Exception: " + e);
				System.exit(-1);
			}
		}
	}
}

