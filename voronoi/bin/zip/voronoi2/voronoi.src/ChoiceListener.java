import java.awt.event.ItemEvent;

public class ChoiceListener implements java.awt.event.ItemListener {
	private VPanel vp;

	public ChoiceListener(VPanel vp) {
		this.vp = vp;
	}

	public void itemStateChanged(ItemEvent ie) {
		Object source = ie.getItemSelectable();

		if (ie.getStateChange() == ItemEvent.SELECTED) {

			if (source == Voronize.turnsChoice) {
				int i = Integer.parseInt((Voronize.turnsChoice
						.getSelectedItem()).toString());
				vp.StartTurns = i;
				vp.clear();
			}

			if (source == Voronize.timeChoice) {

				int i = Integer
						.parseInt((Voronize.timeChoice.getSelectedItem())
								.toString());
				vp.PlayerTimeLimit = i;
				vp.clear();
			}

			if (source == Voronize.humansChoice) {
				int i = Integer.parseInt((Voronize.humansChoice
						.getSelectedItem()).toString());
				vp.HumanPlayers = i;
				vp.clear();
			}
		}
	}
}