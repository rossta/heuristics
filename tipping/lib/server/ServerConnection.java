
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.Hashtable;

public class ServerConnection implements Runnable {

	ServerSocket serverSocket = null;
	Socket socket = null;
	public String tag="";
	
	//store all the avalaible weights in a hashtable. The key is the weight (1-10) and the value indicates if the weight is 
	//available. Once a client uses a weight, the value changes to false.
	Hashtable<String, Boolean> weights = new Hashtable<String, Boolean>();
	int weights_used = 0;
	
	public ServerConnection(Socket socket) {		
		super();
		
		for (int i = 1; i<=10; i++) {
			weights.put(Integer.toString(i), true);
		}
		
		this.socket = socket;
		try {
			//tcp_no_delay = socket.getTcpNoDelay()?"no":"yes";
			socket.setTcpNoDelay(true);
		} catch (SocketException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void run() {
		processClient();
	}
	
	PrintWriter out;
	BufferedReader in;	
	
	private boolean processClient() {
		out = null;
		in  = null;
		try {
			out = new PrintWriter(socket.getOutputStream(), true);
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

			String inputLine;	
			inputLine = in.readLine() ;
			
			//if the client connects without a tag or a blank tag then the connection is refused. 
			if (inputLine == null) {
				System.out.println("Error:No request received");
				return false;
			} else if (inputLine.trim().length() == 0) {
				System.out.println("Error:Zero length request");
				return false;
			} 
			inputLine = inputLine.trim();
			setTag(inputLine);
			System.out.println("Connected with client " + getTag());
			out.println("Connected accpeted for " + getTag());
			
			interactWithClient();
		} catch (Exception e) {
			System.out.println("Error processing thread " + ", " +  e.getMessage());
			return false;
		} finally {
			try {
				if (out != null ) out.close();
				if (in  != null ) in.close();
				socket.close();
			} catch(Exception e) {}

		}
		return true;
			
	}
	
	public void interactWithClient() {
		String inputline="";
		try {
			
			
			while ((inputline = in.readLine()) != null) {
				
				if (inputline.trim().equals(""))
					continue;
				
				System.out.println(getTag() + ": " + inputline);
				if (inputline.equals("Bye")) {
					System.out.println("Client " + getTag() + " terminated connection");
					out.println("Bye");
					break;
				} 
				
				String[] res = inputline.split(",");
				if (weights.containsKey(res[0])) {
					if (weights.get(res[0])) {
						weights.put(res[0], false);
						weights_used++;
						out.println("ACCEPT");
					} else {
						out.println("REJECT [Weight Aready used]");
					}
						
				} else {
					out.println("REJECT [Invalid Weight]");
				}
				
				inputline = "";
				//out.println(inputline);
				
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

}