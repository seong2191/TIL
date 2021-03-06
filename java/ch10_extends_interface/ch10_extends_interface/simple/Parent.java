package ch10_extends_interface.simple;

public class Parent {
	private String name;
	private int age;
	
	public Parent(String name, int age) {
		// 보이지는 않지만 모든 클래스는
		// 기본적으로 Object 클래스를 상속받고 있다.
		super();
		this.name = name;
		this.age = age;
	}
	
	public void sayHello() {
		System.out.println("어른이");
	}
	
	// 부모가 가진 메소드를 자식 클래스에서 재정의(Override) 해서 사용할 수 있다.
	@Override
	public String toString() {
		return "Parent [name=" + name + ", age=" + age + "]";
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}
	
	
	
	
	

}
