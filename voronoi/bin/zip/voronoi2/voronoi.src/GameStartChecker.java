public class GameStartChecker {
	private boolean start = false;

	synchronized public void waitForGameReset() throws InterruptedException {
		while (start != false)
			wait();
	}

	synchronized public void waitForGameStart() throws InterruptedException {
		while (start != true)
			wait();
	}

	synchronized public void update(boolean t) {
		start = t;
		notifyAll();
	}

	synchronized public boolean check() {
		return start;
	}
}