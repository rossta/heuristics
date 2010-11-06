public class ReadyChecker {
	private int ready = 0;
	private int readyCount = 0;

	public ReadyChecker(int r) {
		ready = r;
		readyCount = 0;
	}

	synchronized public void waitReady() throws InterruptedException {
		while (ready != readyCount)
			wait();
	}

	synchronized public void inc() {
		readyCount += 1;
		notifyAll();
	}
}