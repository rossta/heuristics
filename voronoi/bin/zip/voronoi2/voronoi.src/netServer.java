import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class netServer {

	Semaphore turnSemaphore = new Semaphore(1);
	int NextPlayerNumber = 1;
	Voronize v;
	VPanel vp;
	String sPort;
	int MaxPlayers;
	Socket PlayerSockets[];

	public netServer(String sPort, Voronize v, VPanel vp, int MaxPlayers) {
		this.v = v;
		this.vp = vp;
		this.sPort = sPort;
		this.MaxPlayers = MaxPlayers;
		this.PlayerSockets = new Socket[MaxPlayers];
	}

	public void go() {

		int port;
		ServerSocket server_socket;

		try {
			port = Integer.parseInt(sPort);
		} catch (Exception e) {
			port = 20000;
		}

		try {

			server_socket = new ServerSocket(port);
			System.out.println("Voronoi Server running on port "
					+ server_socket.getLocalPort());

			// server infinite loop
			while (true) {
				Socket socket = server_socket.accept();
				System.out.println("connection " + vp.gs.check());

				if ((vp.gs.check() == false)
						&& (NextPlayerNumber < MaxPlayers + 1)) {
					System.out.println("New connection accepted "
							+ socket.getInetAddress() + ":" + socket.getPort());

					// Construct handler to process the request message.
					try {

						PlayerSockets[NextPlayerNumber - 1] = socket;
						netRequestHandler request = new netRequestHandler(
								socket, this);

						vp.setNumPlayers(NextPlayerNumber);

						NextPlayerNumber++;

						// Create a new thread to process the request.
						Thread thread = new Thread(request);

						// Start the thread.
						thread.start();
					}

					catch (Exception e) {
						System.out.println(e);
					}
				} else
					socket.close();
			}
		}

		catch (IOException e) {
			System.out.println(e);
		}
	}
}