package question;

public class Question6 {

	public static void main(String[] args) {
		System.out.println(factorial(5)); // 120이 출력되도록 factorial메소드를 작성하세요
	}

	static int factorial(int n) {

		if (n <= 1) {
			return n;
		} else {
			return factorial(n - 1) * n;
		}
	}
}
