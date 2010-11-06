import java.awt.Polygon;
import java.util.Vector;

/**
 * Wrapper for java.awt.Polygon Assumes that poly is convex, and keeps all
 * points in CCW order
 */

public class PolarPoly {

	private Vector<PointDouble> points;

	public PolarPoly() {
		points = new Vector<PointDouble>();
	}

	public void addPoint(PointDouble p) {
		addPoint(p.x, p.y);
	}

	public void addPoint(double x, double y) {
		points.addElement(new PointDouble(x, y));
		sort(points);
	}

	public int getSize() {
		return points.size();
	}

	public PointDouble getPoint(int i) {
		return (PointDouble) points.elementAt(i);
	}

	public void removePoint(int i) {
		points.removeElementAt(i);
	}

	public Polygon getPolygon() {
		Polygon p = new Polygon();
		for (int i = 0; i < points.size(); i++) {
			PointDouble pd = (PointDouble) points.elementAt(i);
			p.addPoint((int) Math.round(pd.x), (int) Math.round(pd.y));
		}
		return p;
	}

	public double area() {
		double a = 0;
		for (int i = 2; i < points.size(); i++)
			a += triarea((PointDouble) points.elementAt(0),
					(PointDouble) points.elementAt(i - 1),
					(PointDouble) points.elementAt(i));
		return a;
	}

	public String toString() {
		String s = "(" + points.size() + "/" + area() + "):";
		for (int i = 0; i < points.size(); i++)
			s += " " + ((PointDouble) points.elementAt(i));
		return s;
	}

	private double triarea(PointDouble A, PointDouble B, PointDouble C) {
		double ax = B.x - A.x;
		double ay = B.y - A.y;
		double bx = C.x - A.x;
		double by = C.y - A.y;
		return ((Math.abs(ax * by - ay * bx)) / 2);
	}

	private void sort(Vector<PointDouble> v) {
		int N = v.size();
		Vector<Double> ths = new Vector<Double>();
		PointDouble[] pts = new PointDouble[N];
		PointDouble center = getCenter();
		for (int i = 0; i < N; i++)
			ths.addElement(new Double(getTheta((PointDouble) v.elementAt(i),
					center)));
		for (int j = 0; j < N; j++) {
			double lt = 2 * Math.PI;
			int ind = 0;
			for (int i = 0; i < v.size(); i++) {
				double t = ((Double) ths.elementAt(i)).doubleValue();
				if (t < lt) {
					lt = t;
					ind = i;
				}
			}
			pts[j] = (PointDouble) v.elementAt(ind);
			v.removeElementAt(ind);
			ths.removeElementAt(ind);
		}
		for (int i = 0; i < N; i++)
			v.addElement(pts[i]);
	}

	private PointDouble getCenter() {
		double xsum = 0.0, ysum = 0.0;
		for (int i = 0; i < points.size(); i++) {
			xsum += ((PointDouble) points.elementAt(i)).x;
			ysum += ((PointDouble) points.elementAt(i)).y;
		}
		return new PointDouble(xsum / points.size(), ysum / points.size());
	}

	private double getTheta(PointDouble p, PointDouble center) {
		double x = p.x - center.x;
		double y = p.y - center.y;
		double r = Math.sqrt(x * x + y * y);
		double t = Math.acos(x / r);
		return y < 0 ? 2 * Math.PI - t : t;
	}
}