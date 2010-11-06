public class TurnChecker {
	private int turn;

	synchronized public void waitTurn(int PlayerNumber)
			throws InterruptedException {

		while (turn != PlayerNumber)
			wait();
	}

	synchronized public void changeTurn(int t) {
		turn = t;
		notifyAll();
	}

	synchronized public int whosTurn() {
		return turn;
	}
}