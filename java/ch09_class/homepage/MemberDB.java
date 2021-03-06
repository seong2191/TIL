package ch09_class.homepage;

import java.util.ArrayList;

public class MemberDB {
	private ArrayList<Member> memberList = new ArrayList<>();
	
	// 싱글톤 패턴 적용
	// 객체를 딱 한번만 소환할거임
	// 1. 기본 생성자를 private로 막는다.
	private MemberDB() {
		
	}
	
	// 2. 필드에 MemberDB를 new를 이용해서 객체로 만들어 둔다.
	private static MemberDB instance = new MemberDB();
	
	// 3. 객체로 만든 instance를 제공하는 함수(Getter) 만들기
	public static MemberDB getInstance() {
		return instance;
	}
	
	// 회원가입
	public void regist(String id, String pw) {
		// id 중복체크
		for(int i = 0; i < memberList.size(); i++) {
			if(memberList.get(i).getId().equals(id)){
				System.out.println("아이디가 중복됩니다.");
				return; // void에 return을 쓰면 메소드 중지
			}
		}
		
		memberList.add(new Member(id, pw));
		System.out.println("회원가입 성공!");
	}
	
	// 회원목록조회
	public void printMembers() {
		for(int i = 0 ; i < memberList.size(); i++) {
			System.out.println(memberList.get(i));
		}
	}
	
	// 입력받은 아이디에 일치하는 Member 리턴
	public Member getMember(String id) {
		for(int i = 0; i < memberList.size(); i++) {
			if(memberList.get(i).getId().equals(id)){
				return memberList.get(i);
			}
		}
		// 입력받은 id에 대한 Member가 존재하지 않으면
		// 텅 빈 Member 객체를 리턴
		// id = null, pw = null
		return new Member(); // new Member() 대신에 null 가능
	}
	
	

}
