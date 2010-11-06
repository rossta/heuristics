import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.Frame;
import java.awt.GridLayout;
import java.awt.Point;
import java.io.IOException;
import java.util.Vector;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

/**
 * Maintains a voronoi diagram as a list of points and their associated polys.
 * Supports testing and adding points plus some utility operations. See alg.html
 * for algorithm specifics.
 * 
 * Main method constructs a default interface, and can initialize from a file of
 * points representing the moves of two players.
 */
// ============================================================================

public class Voronize {
	final double FUDGE = .0000001;

	public final int W;
	public final int H;
	public final PointDouble UL;
	public final PointDouble UR;
	public final PointDouble LL;
	public final PointDouble LR;
	public Vector<Point> points;
	public Vector<PolarPoly> ppolys;

	public static int MaxPlayers = 4;
	public static int BoardSize = 400;
	public static netServer ns;
	public static VPanel vp;

	public static JComboBox turnsChoice = new JComboBox();
	public static JComboBox timeChoice = new JComboBox();
	public static JComboBox humansChoice = new JComboBox();

	public static JFrame ScoreBoardFrame = new JFrame("Score Board");
	public static JPanel ScoreBoard = new JPanel();
	public static JLabel ScoreLabels[];
	public static JLabel TimeLabels[];

	public Voronize(int w, int h) {
		W = w;
		H = h;
		UL = new PointDouble(0, 0);
		UR = new PointDouble(W - 1, 0);
		LL = new PointDouble(0, H - 1);
		LR = new PointDouble(W - 1, H - 1);
		clear();
	}

	public static void main(String[] args) {
		if (args.length > 1) {
			System.err.println("usage: Voronize [port]");
			System.exit(1);
		}

		Voronize v = new Voronize(BoardSize + 2, BoardSize + 2);
		Frame f = new Frame("Voronoi Gameboard");

		f.addWindowListener(new java.awt.event.WindowAdapter() {
			public void windowClosing(java.awt.event.WindowEvent e) {
				System.exit(0);
			}
		});

		f.setLayout(new BorderLayout());
		vp = new VPanel(v);
		vp.setPreferredSize(new java.awt.Dimension(v.W, v.H));

		Color[] colors = { new Color(250, 0, 0), new Color(0, 0, 250),
				new Color(0, 250, 0), new Color(125, 125, 125) };

		MaxPlayers = colors.length;
		vp.setColors(colors);

		f.add(vp, BorderLayout.CENTER);
		java.awt.Panel p = new java.awt.Panel();

		p.setBackground(Color.lightGray);
		p.setLayout(new GridLayout(8, 3));

		ButAct ba = new ButAct(vp);

		JButton clearBut;
		p.add(clearBut = new JButton("Reset"));
		clearBut.addActionListener(ba);

		JButton startBut;
		p.add(startBut = new JButton("Start"));
		startBut.addActionListener(ba);

		ChoiceListener ChoiceL = new ChoiceListener(vp);

		JLabel hcl = new JLabel("Humans:");
		p.add(hcl);

		p.add(humansChoice);
		for (int i = 0; i <= 4; i++)
			humansChoice.addItem(Integer.toString(i));
		humansChoice.setSelectedIndex(0);
		humansChoice.addItemListener(ChoiceL);

		JLabel tcl = new JLabel("Stones:");
		p.add(tcl);

		p.add(turnsChoice);
		for (int i = 1; i <= 25; i++)
			turnsChoice.addItem(Integer.toString(i));
		turnsChoice.setSelectedIndex(6);
		turnsChoice.addItemListener(ChoiceL);
		vp.StartTurns = 7;

		JLabel rcl = new JLabel("Player Time:");
		p.add(rcl);

		p.add(timeChoice);
		for (int i = 0; i <= 1800; i += 30)
			timeChoice.addItem(Integer.toString(i));
		timeChoice.setSelectedIndex(4);
		timeChoice.addItemListener(ChoiceL);

		f.add(p, BorderLayout.WEST);
		f.pack();
		f.setVisible(true);

		GridLayout gl = new GridLayout(4, 2);
		gl.setVgap(10);
		ScoreBoard.setLayout(gl);
		ScoreBoard.setBackground(Color.LIGHT_GRAY);

		ScoreLabels = new JLabel[colors.length];
		TimeLabels = new JLabel[colors.length];

		Font font1 = new Font(Font.SANS_SERIF, Font.HANGING_BASELINE, 17);
		Font font2 = new Font(Font.SANS_SERIF, Font.CENTER_BASELINE, 18);

		for (int i = 0; i < colors.length; i++) {
			JLabel l = new JLabel("Player " + (i + 1) + ":  ");
			JLabel tl = new JLabel("TIME:  ");

			l.setFont(font2);
			l.setForeground(colors[i]);
			ScoreBoard.add(l);
			ScoreLabels[i] = l;

			tl.setFont(font1);
			tl.setForeground(Color.black);
			ScoreBoard.add(tl);
			TimeLabels[i] = tl;
		}

		ScoreBoardFrame.setSize(500, 150);
		ScoreBoardFrame.add(ScoreBoard);
		ScoreBoardFrame.setVisible(true);

		TimerThread PTimer = new TimerThread(v, vp);
		Thread thread = new Thread(PTimer);
		thread.start();

		String port = new String();
		if (args.length == 1)
			port = args[0];

		ns = new netServer(port, v, vp, colors.length);
		vp.resetGame();
		ns.go();
	}

	public void clear() {
		points = new Vector<Point>();
		ppolys = new Vector<PolarPoly>();
	}

	public Vector<Point> getPoints() {
		return points;
	}

	public Vector<PolarPoly> getPPolys() {
		return ppolys;
	}

	int count;

	public void set(Vector<Point> p) {
		count = 0;
		points = p;
		ppolys = new Vector<PolarPoly>();
		for (int k = 0; k < p.size(); k++)
			ppolys.addElement(new PolarPoly());
		for (int k = 0; k < p.size(); k++) {
			VLine[] bis = getBisectors(k);
			addPoint(k, bis, false);
		}
	}

	public double[] getHeatMap() {
		Point p = new Point(0, 0);
		double[] map = new double[W * H];
		for (int y = 0; y < H; y++) {
			System.out.println("y: " + y);
			for (int x = 0; x < W; x++) {
				p.x = x;
				p.y = y;
				map[y * W + x] = points.contains(p) ? 0.0 : testPoint(p).area();
			}
		}
		return map;
	}

	public PolarPoly testPoint(Point p) {
		PolarPoly pp = new PolarPoly();
		VLine[] bis = getBisectors(p);
		getPoly(-1, pp, p, 0, bis, true);
		return pp;
	}

	public void addPoint(Point p) {
		points.addElement(p);
		ppolys.addElement(new PolarPoly());
		VLine[] bis = getBisectors(points.size() - 1);
		addPoint(points.size() - 1, bis, true);
	}

	public void addPoint(int k, VLine[] bis, boolean incremental) {
		if (incremental)
			for (int i = 0; i < bis.length - 4; i++)
				prune(i, bis[i]);
		int start = incremental ? 0 : k + 1;
		getPoly(k, (PolarPoly) ppolys.elementAt(k),
				(Point) points.elementAt(k), start, bis, false);
	}

	private void getPoly(int k, PolarPoly pp, Point newpt, int start,
			VLine[] bis, boolean testing) {
		for (int i = start; i < bis.length - 1; i++) {
			for (int j = i + 1; j < bis.length; j++) {
				PointDouble intpt = bis[i].getIntersection(bis[j]);
				if (intpt != null) {
					VLine testint = new VLine(newpt.x, newpt.y, intpt.x,
							intpt.y);
					// System.out.println(" int: " + intpt.x + "," + intpt.y);
					if (isGood(k, i, j, testint, intpt, bis, newpt)) {
						pp.addPoint(intpt);
						if (!testing) {
							count++;
							if (i < bis.length - 4)
								((PolarPoly) ppolys.elementAt(i))
										.addPoint(intpt);
							if (j < bis.length - 4)
								((PolarPoly) ppolys.elementAt(j))
										.addPoint(intpt);
						}
					}
				}
			}
		}
	}

	private boolean isGood(int k, int i, int j, VLine testint,
			PointDouble intpt, VLine[] bis, Point ctr) {
		boolean OK = true;
		int m = 0;
		do {
			if ((m != i && m != j && m != k) || m >= bis.length - 4) {
				PointDouble xp = testint.getIntersection(bis[m]);
				if (xp != null
						&& Math.min(ctr.x, intpt.x) <= xp.x
						&& xp.x <= Math.max(ctr.x, intpt.x)
						&& Math.min(ctr.y, intpt.y) <= xp.y
						&& xp.y <= Math.max(ctr.y, intpt.y)
						&& (Math.abs(ctr.x - xp.x) > FUDGE || Math.abs(ctr.y
								- xp.y) > FUDGE)
						&& (Math.abs(intpt.x - xp.x) > FUDGE || Math
								.abs(intpt.y - xp.y) > FUDGE)) {
					OK = false;
				}
			}
			m++;
		} while (OK && m < bis.length);
		return OK;
	}

	private void prune(int index, VLine line) {
		PolarPoly pp = (PolarPoly) ppolys.elementAt(index);
		Point pt = (Point) points.elementAt(index);
		double goodside = line.eval(pt);
		int N = pp.getSize();
		for (int i = N - 1; i >= 0; i--) {
			PointDouble p = pp.getPoint(i);
			double e = line.eval(p);
			if (Math.abs(e) < .01)
				e = 0;
			if (e * goodside < 0)
				pp.removePoint(i);
		}
	}

	// find perpendicular bisectors of points[index]
	// add screen edge bisectors
	private VLine[] getBisectors(int ind) {
		VLine[] lines = new VLine[points.size() + 3];
		Point p = (Point) points.elementAt(ind);
		int cnt = 0;
		for (int i = 0; i < points.size(); i++)
			if (i != ind)
				lines[cnt++] = getPerpBisect(p, (Point) points.elementAt(i));
		lines[cnt++] = new VLine(UL, UR);
		lines[cnt++] = new VLine(UR, LR);
		lines[cnt++] = new VLine(LR, LL);
		lines[cnt++] = new VLine(LL, UL);
		return lines;
	}

	public VLine[] getBisectors(Point p) {
		VLine[] lines = new VLine[points.size() + 4];
		int i;
		for (i = 0; i < points.size(); i++)
			lines[i] = getPerpBisect(p, (Point) points.elementAt(i));
		lines[i++] = new VLine(UL, UR);
		lines[i++] = new VLine(UR, LR);
		lines[i++] = new VLine(LR, LL);
		lines[i++] = new VLine(LL, UL);
		return lines;
	}

	// get the perpendicular bisector of the line between p1 and p2
	private VLine getPerpBisect(PointDouble p1, PointDouble p2) {
		PointDouble center = new PointDouble((p1.x + p2.x) / 2.0,
				(p1.y + p2.y) / 2.0);
		PointDouble newp1 = new PointDouble(-(p1.y - center.y) + center.x, p1.x
				- center.x + center.y);
		PointDouble newp2 = new PointDouble(-(p2.y - center.y) + center.x, p2.x
				- center.x + center.y);
		return new VLine(newp1, newp2);
	}

	private VLine getPerpBisect(Point p1, Point p2) {
		return getPerpBisect(new PointDouble(p1.x, p1.y), new PointDouble(p2.x,
				p2.y));
	}

	@SuppressWarnings("unused")
	private static Vector<Point> readPoints(String filename) throws IOException {
		java.io.BufferedReader in = new java.io.BufferedReader(
				new java.io.FileReader(filename));
		Vector<Point> v = new Vector<Point>();
		String line;
		while ((line = in.readLine()) != null) {
			java.util.StringTokenizer t = new java.util.StringTokenizer(line);
			int x = Integer.parseInt(t.nextToken());
			int y = Integer.parseInt(t.nextToken());
			v.addElement(new Point(x, y));
		}
		return v;
	}
}