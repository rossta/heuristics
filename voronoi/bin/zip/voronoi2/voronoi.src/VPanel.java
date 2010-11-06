import java.awt.Color;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.InputEvent;
import java.io.OutputStream;
import java.util.Vector;

/**
 * Simple component to display a voronoi diagram maintained by an instance of
 * Voronize.
 * 
 * left button adds a point to the diagram right button shows area of poly
 * containing point and area of poly that would be added by clicking middle
 * button shows sequence of moves so far
 * 
 * 'l' toggles display of all polys / one poly 'k' and 'j' increment and
 * decrement index of shown poly
 */
public class VPanel extends java.awt.Panel {
	private static final long serialVersionUID = 5186209748151090460L;
	public double Scores[];
	public double Times[];

	public int NumPlayers;
	public int NumTurns;
	public TurnChecker tc = new TurnChecker();
	public GameStartChecker gs = new GameStartChecker();
	public ReadyChecker rc;
	public int Winner;
	public int StartTurns = 7;
	public int PlayerTimeLimit = 0;
	public int HumanPlayers = 0;

	private Voronize v;
	private boolean singlePoly;
	private int showPoly;
	private Color[] colors = { Color.red, Color.blue };
	private Dimension pref;

	public VPanel(Voronize v) {
		super();
		this.v = v;
		pref = new Dimension(400, 400);
		singlePoly = false;
		showPoly = 0;

		class VPanelKey extends java.awt.event.KeyAdapter {
			private VPanel vp;

			public VPanelKey(VPanel vp) {
				this.vp = vp;
			}

			public void keyPressed(java.awt.event.KeyEvent e) {
				switch (e.getKeyChar()) {
				case 'l':
					vp.setSinglePoly(!vp.getSinglePoly());
					break;
				case 'j':
					vp.setShowPoly(vp.getShowPoly() - 1);
					break;
				case 'k':
					vp.setShowPoly(vp.getShowPoly() + 1);
					break;
				}
			}
		}

		this.addKeyListener(new VPanelKey(this));

		class VPanelMouse extends java.awt.event.MouseAdapter {
			private VPanel vp;
			private Voronize vo;

			public VPanelMouse(VPanel vp, Voronize vo) {
				this.vp = vp;
				this.vo = vo;
			}

			public void mouseReleased(java.awt.event.MouseEvent e) {
				Point p = e.getPoint();
				if ((e.getModifiers() & InputEvent.BUTTON1_MASK) != 0) {

					int PlayerNumber = tc.whosTurn();
					try {
						String status = p.x + " " + p.y + " " + PlayerNumber
								+ "\n";
						for (int i = 0; i < NumPlayers; i++) {
							System.out.println("Sending move to player "
									+ (i + 1));
							if (i != PlayerNumber - 1) {
								try {
									OutputStream o = Voronize.ns.PlayerSockets[i]
											.getOutputStream();
									o.write(status.getBytes());
								} catch (Exception ex) {
									System.out.println("Error writing socket");
									System.out.println(ex);
								}
							}
						}

						makeMove(p, vo, vp);
					}

					catch (Exception ex) {
						System.out.println("Invalid move?");
						System.out.println(ex);
					}

				} else if ((e.getModifiers() & InputEvent.BUTTON3_MASK) != 0) {
					Vector<PolarPoly> ppolys = vo.getPPolys();
					for (int i = 0; i < ppolys.size(); i++) {
						PolarPoly pp = (PolarPoly) ppolys.elementAt(i);
						if (pp.getPolygon().contains(p)) {
							System.out.println("poly: " + i + ", area: "
									+ pp.area());
							break;
						}
					}
					PolarPoly pp = vo.testPoint(p);
					System.out.println("area: " + pp.area());
				} else if ((e.getModifiers() & InputEvent.BUTTON2_MASK) != 0) {
					Vector<Point> points = vo.getPoints();
					for (int i = 0; i < points.size(); i++) {
						Point plp = (Point) points.elementAt(i);
						System.out.println(plp.x + " " + plp.y);
					}
				}
			}
		}

		this.addMouseListener(new VPanelMouse(this, v));
	}

	public void clear() {
		resetGame();
		v.clear();
		repaint();
	}

	public void setColors(Color[] c) {
		colors = c;
	}

	public void paint(java.awt.Graphics g) {
		update(g);
	}

	public void update(java.awt.Graphics g) {
		Vector<Point> points = v.getPoints();
		Vector<PolarPoly> ppolys = v.getPPolys();
		g.clearRect(0, 0, getSize().width, getSize().height);
		g.setColor(getForeground());
		if (showPoly >= ppolys.size())
			showPoly -= ppolys.size();
		else if (showPoly < 0)
			showPoly += ppolys.size();
		if (singlePoly)
			System.out.println("displaying: " + showPoly);

		for (int i = 0; i < NumPlayers; i++)
			Scores[i] = 0;

		int start = singlePoly ? showPoly : 0;
		int end = singlePoly ? showPoly + 1 : ppolys.size();
		double area = 0;
		for (int i = start; i < end; i++) {
			System.out.println("Updating poly " + i);

			Point pnt = (Point) points.elementAt(i);

			System.out.println("Point " + pnt.x + " " + pnt.y);

			PolarPoly pp = (PolarPoly) ppolys.elementAt(i);
			area += pp.area();
			java.awt.Polygon poly = pp.getPolygon();

			java.awt.Rectangle r = poly.getBounds();
			System.out.println("x:" + r.x + " y:" + r.y + " w:" + r.width
					+ " h:" + r.height);

			g.setColor(colors[i % NumPlayers]);
			g.fillPolygon(poly);
			g.setColor(Color.black);
			g.drawPolygon(poly);
			g.setColor(Color.black);
			g.fillOval(pnt.x - 3, pnt.y - 3, 7, 7);

			Scores[i % NumPlayers] += pp.area();
		}

		//System.out.println("Stones left: " + NumTurns);

		double maxScore = 0;
		java.text.DecimalFormat dFormat = new java.text.DecimalFormat("###.###");

		for (int i = 0; i < NumPlayers; i++) {
			Voronize.ScoreLabels[i].setText("Player " + (i + 1) + ":  "
					+ dFormat.format(Scores[i]));
			Voronize.TimeLabels[i].setText("TIME:  " + dFormat.format(Times[i]));

			System.out.println("player " + (i + 1) + ": " + Scores[i]);

			if (Scores[i] > maxScore) {
				maxScore = Scores[i];
				Winner = i + 1;
			}
		}

		System.out.println();

		//if (NumTurns == 0 )
		//	System.out.println("player " + (Winner) + " wins");

	}

	public Dimension getPreferredSize() {
		return pref;
	}

	public void setPreferredSize(Dimension d) {
		pref = d;
	}

	public boolean getSinglePoly() {
		return singlePoly;
	}

	public void setSinglePoly(boolean b) {
		singlePoly = b;
		repaint();
	}

	public int getShowPoly() {
		return showPoly;
	}

	public void setShowPoly(int p) {
		showPoly = p;
		repaint();
	}

	public void resetGame() {
		Voronize.ns.NextPlayerNumber = 1;

		tc.changeTurn(0);

		for (int i = 0; i < NumPlayers; i++) {
			try {
				if (Voronize.ns.PlayerSockets[i] != null)
					Voronize.ns.PlayerSockets[i].close();
			} catch (Exception e) {
			}
		}

		Scores = new double[Voronize.MaxPlayers];
		Times = new double[Voronize.MaxPlayers];

		for (int i = 0; i < Voronize.MaxPlayers; i++) {
			Scores[i] = 0;
			Times[i] = PlayerTimeLimit;
		}

		setNumPlayers(0);
		Winner = 0;

		gs.update(false);
	}

	public void setNumPlayers(int n) {
		NumPlayers = n;
		NumTurns = StartTurns * NumPlayers;
	}

	public void makeMove(Point p, Voronize vo, VPanel vp) {
		boolean InvalidMove = false;

		int WhosTurn = tc.whosTurn();

		if (NumTurns != 0) {
			NumTurns--;

			if (p.x >= 0 && p.x < vo.W && p.y >= 0 && p.y < vo.H) {
				Vector<Point> points = vo.getPoints();
				System.out.println("makeMove " + "p.x:" + p.x + " p.y:" + p.y);

				p.x++;
				p.y++;

				if (!points.contains(p)) {

					vo.points.addElement(p);
					vo.ppolys = new Vector<PolarPoly>();

					for (int k = 0; k < vo.points.size(); k++)
						vo.ppolys.addElement(new PolarPoly());

					for (int k = 0; k < vo.points.size(); k++) {
						VLine[] bis = vo.getBisectors((Point) vo.points
								.elementAt(k));
						vo.addPoint(k, bis, false);
					}

					vp.repaint();
				}

				else {
					System.out.println("Player " + WhosTurn
							+ " made a duplicate move! " + --p.x + " " + --p.y);
					InvalidMove = true;
				}
			}

		}

		if (InvalidMove) {
			tc.changeTurn(0);
		}

		else {
			if (WhosTurn < NumPlayers)
				WhosTurn++;
			else
				WhosTurn = 1;

			tc.changeTurn(WhosTurn);
		}
	}
}