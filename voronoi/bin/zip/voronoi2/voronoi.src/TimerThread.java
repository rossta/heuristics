public class TimerThread implements Runnable {

	Voronize v;
	VPanel vp;

	TimerThread(Voronize v, VPanel vp) {
		this.v = v;
		this.vp = vp;
	}

	public void run() {
		long ltime;
		double csecs;

		try {
			java.text.DecimalFormat dFormat = new java.text.DecimalFormat(
					"###.#");

			while (true) {
				ltime = System.currentTimeMillis();
				Thread.sleep(100);
				int turn = vp.tc.whosTurn();
				if (turn != 0 && vp.NumTurns != 0) {
					csecs = (int) (System.currentTimeMillis() - ltime) / 1000.0;

					if (vp.Times[turn - 1] < 1) {
						System.out.print(vp.Times[turn - 1]);
						Voronize.TimeLabels[turn - 1].setText("TIME UP!");
					}

					else if (vp.Times[turn - 1] - csecs >= 0) {
						vp.Times[turn - 1] -= csecs;
						Voronize.TimeLabels[turn - 1]
								.setText("          Time:  "
										+ dFormat.format(vp.Times[turn - 1]));
					}
				}
			}
		}

		catch (Exception e) {
			System.out.println(e);
		}
	}
}