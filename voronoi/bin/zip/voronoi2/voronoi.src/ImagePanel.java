import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;

public class ImagePanel extends java.awt.Panel {
	private static final long serialVersionUID = -8266076949214573175L;

	private Image im;
	private Dimension pref;

	public ImagePanel(Image im) {
		super();
		this.im = im;
		pref = new Dimension(im.getWidth(this), im.getHeight(this));
	}

	public Dimension getPreferredSize() {
		return pref;
	}

	public void paint(Graphics g) {
		update(g);
	}

	public void update(Graphics g) {
		g.drawImage(im, 0, 0, null);
	}
}
