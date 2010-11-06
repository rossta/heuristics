/**
 * A partial implementation of the Java2 class Point2D.Double. Used to retain
 * Java1.1 compatibility.
 */
public class PointDouble {
	public double x;
	public double y;

	public PointDouble() {
		x = 0.;
		y = 0.;
	}

	public PointDouble(double x, double y) {
		this.x = x;
		this.y = y;
	}

	/**
	 * Converts this point to its nearest integer point.
	 * 
	 * @return the integer Point
	 */
	public java.awt.Point getPoint() {
		return new java.awt.Point((int) Math.round(x), (int) Math.round(y));
	}

	public String toString() {
		return new String("(" + x + "," + y + ")");
	}
}