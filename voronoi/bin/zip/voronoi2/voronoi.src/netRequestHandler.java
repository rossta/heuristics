import java.awt.Point;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.Socket;
import java.util.StringTokenizer;

public class netRequestHandler implements Runnable {
	final static String CRLF = "\r\n";
	Socket socket;
	InputStream input;
	OutputStream output;
	BufferedReader br;
	netServer parent;
	int PlayerNumber;

	// Constructor
	public netRequestHandler(Socket socket, netServer parent) throws Exception {
		this.socket = socket;
		this.input = socket.getInputStream();
		this.output = socket.getOutputStream();
		this.br = new BufferedReader(new InputStreamReader(
				socket.getInputStream()));
		this.parent = parent;
		this.PlayerNumber = parent.NextPlayerNumber;
	}

	// Implement the run() method of the Runnable interface.
	public void run() {
		try {
			processRequest();
			return;
		}

		catch (Exception e) {
			System.out.println(e);
		}
	}

	private void processRequest() throws Exception {

		parent.vp.gs.waitForGameStart();

		String status = (Voronize.BoardSize) + " " + parent.vp.NumTurns
				/ parent.vp.NumPlayers + " " + parent.vp.NumPlayers + " "
				+ PlayerNumber + "\n";

		output.write(status.getBytes());

		parent.vp.rc.inc();
		parent.vp.rc.waitReady();

		while (true) {
			System.out.println(PlayerNumber + ": Waiting for turn");
			parent.vp.tc.waitTurn(PlayerNumber);
			// parent.turnSemaphore.down();

			int x = 0;
			int y = 0;

			if (parent.vp.NumTurns != 0) {
				System.out.println(PlayerNumber + " - My Turn");

				while (br.ready())
					br.readLine();

				status = "YOURTURN\n";
				System.out.println(PlayerNumber + " - Sending " + status);
				output.write(status.getBytes());

				try {

					String line = br.readLine();
					StringTokenizer s = new StringTokenizer(line);
					x = Integer.parseInt(s.nextToken());
					y = Integer.parseInt(s.nextToken());

					Point p = new Point(x, y);

					for (int i = 0; i < parent.vp.NumPlayers; i++) {
						if (i != PlayerNumber - 1) {
							try {
								OutputStream o = parent.PlayerSockets[i]
										.getOutputStream();
								status = p.x + " " + p.y + " " + PlayerNumber
										+ "\n";
								o.write(status.getBytes());
							} catch (Exception ex) {
								System.out
										.println("Error writing move to player!");
								System.out.println("Probably a human error.");
								System.out.println(ex);
							}

						}
					}

					if (x < 0 || x >= Voronize.BoardSize || y < 0
							|| y >= Voronize.BoardSize)
						System.out.println("Invalid move! " + x + " " + y);
					else {
						parent.vp.makeMove(p, parent.v, parent.vp);
					}
				}

				catch (Exception e) {
					System.out.println("Invalid move?");
					System.out.println(e);
				}
			}

			else {
				Point p = new Point(0, 0);
				parent.vp.makeMove(p, parent.v, parent.vp);

				if (PlayerNumber == parent.vp.Winner)
					status = "WIN\n";
				else
					status = "LOSE\n";

				output.write(status.getBytes());

				try {
					output.close();
					br.close();
					socket.close();
				} catch (Exception e) {
				}

				return;
			}
		}
	}
}