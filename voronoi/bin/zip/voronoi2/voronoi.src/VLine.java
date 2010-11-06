import java.awt.Point;

/**
 * A partial implementation of the Java2 class Line2D.Double. Used to retain
 * Java1.1 compatibility.
 */
public class VLine {
	private double A, B, C;

	public VLine() {
		set(0.0, 0.0, 1.0, 1.0);
	}

	public VLine(double x1, double y1, double x2, double y2) {
		set(x1, y1, x2, y2);
	}

	public VLine(Point p1, Point p2) {
		set(p1.x, p1.y, p2.x, p2.y);
	}

	public VLine(PointDouble p1, PointDouble p2) {
		set(p1.x, p1.y, p2.x, p2.y);
	}

	public PointDouble getIntersection(VLine l) {
		PointDouble q;
		double temp = A * l.B - B * l.A;
		if (temp != 0) {
			double y = (C * l.A - A * l.C) / temp;
			double x;
			if (A != 0) {
				x = ((-B * y - C) / A);
			} else {
				x = ((-l.B * y - l.C) / l.A);
			}
			q = new PointDouble(x, y);
		} else if (C == l.C) {
			q = null; // what case?????
		} else {
			q = null;
		}
		return q;
	}

	public double eval(double x, double y) {
		return A * x + B * y + C;
	}

	public double eval(PointDouble p) {
		return eval(p.x, p.y);
	}

	public double eval(Point p) {
		return eval(p.x, p.y);
	}

	private void set(double x1, double y1, double x2, double y2) {
		A = -(y2 - y1);
		B = (x2 - x1);
		C = -A * x1 - B * y1;
		double s = Math.abs(A) > Math.abs(B) ? A : B;
		if (s != 0) {
			A /= s;
			B /= s;
			C /= s;
		}
	}
}