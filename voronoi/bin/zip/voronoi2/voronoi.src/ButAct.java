import javax.swing.JButton;

public class ButAct implements java.awt.event.ActionListener {
	private VPanel vp;

	public ButAct(VPanel vp) {
		this.vp = vp;
	}

	public void actionPerformed(java.awt.event.ActionEvent e) {
		JButton b = (JButton) e.getSource();

		if (b.getActionCommand().equals("Reset")) {
			vp.clear();

			for (int i = 0; i < Voronize.MaxPlayers; i++) {
				Voronize.ScoreLabels[i].setText("Player " + (i + 1) + ":  ");
				Voronize.TimeLabels[i].setText("TIME:  ");
			}
		}

		if (b.getActionCommand().equals("Start")) {
			vp.rc = new ReadyChecker(vp.NumPlayers);
			vp.setNumPlayers(vp.NumPlayers + vp.HumanPlayers);
			vp.gs.update(true);
			vp.tc.changeTurn(1);
		}
	}
}