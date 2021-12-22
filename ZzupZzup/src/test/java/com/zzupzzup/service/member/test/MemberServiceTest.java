package com.zzupzzup.service.member.test;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.zzupzzup.common.Search;
import com.zzupzzup.service.domain.Member;
import com.zzupzzup.service.member.MemberDAO;
import com.zzupzzup.service.member.MemberService;
import com.zzupzzup.service.restaurant.RestaurantService;


@RunWith(SpringJUnit4ClassRunner.class)

//@ContextConfiguration(locations = { "classpath:config/context-*.xml" })
@ContextConfiguration	(locations = {	"classpath:config/context-common.xml",
										"classpath:config/context-aspect.xml",
										"classpath:config/context-mybatis.xml",
										"classpath:config/context-transaction.xml" })
//@ContextConfiguration(locations = { "classpath:config/context-common.xml" })
public class MemberServiceTest {

	@Autowired
	@Qualifier("memberServiceImpl")
	private MemberService memberService;
	
	@Autowired
	@Qualifier("restaurantServiceImpl")
	private RestaurantService restaurantService;
	
	@Value("#{commonProperties['pageUnit']?: 3}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']?: 2}")
	int pageSize;

	//@Test
	public void testAddMember() throws Exception {
		
		Member member = new Member();
		///*
		//유저(일반)
		member.setMemberId("test@test.com");
		member.setMemberRole("user");
		member.setPassword("testPasswd");
		member.setMemberName("abc");
		member.setMemberPhone("111-2222-3333");
		member.setLoginType(1);
		member.setAgeRange("10대");
		member.setGender("female");
		member.setProfileImage("test.png");
		member.setNickname("test");
		member.setStatusMessage("let me go home");
		//*/
		/*
		//유저(카카오)
		member.setMemberId("test2@test.com");
		member.setMemberRole("user");
		//member.setPassword("testPasswd");
		member.setMemberName("ghi");
		member.setMemberPhone("111-2222-3333");
		member.setLoginType(2);
		member.setAgeRange("10대");
		member.setGender("female");
		member.setProfileImage("test.png");
		member.setNickname("test");
		member.setStatusMessage("let me go home"); 
		*/
		/*
		//유저(네이버)
		member.setMemberId("test3@test.com");
		member.setMemberRole("user");
		//member.setPassword("testPasswd");
		member.setMemberName("jkl");
		member.setMemberPhone("111-2222-3333");
		member.setLoginType(3);
		member.setAgeRange("10대");
		member.setGender("female");
		member.setProfileImage("test.png");
		member.setNickname("test");
		member.setStatusMessage("let me go home");
		*/
		/*
		//업주
		member.setMemberId("testest@test.com");
		member.setMemberRole("owner");
		member.setPassword("testPasswd");
		member.setMemberName("def");
		member.setMemberPhone("111-2222-3333");
		member.setLoginType(1);
		member.setProfileImage("test.png");
		*/
		memberService.addMember(member);

		//System.out.println(member);
	}	//complete addMember !
	
	//@Test
	public void testGetMember() throws Exception {
		
		Member member = new Member();
		member.setMemberId("hihi@a.com");
		member.setNickname("");
		memberService.getMember(member);
		//Member member = memberService.getOwner("testest@test.com");	//오류 왜 뜨는데?
		//System.out.println(member);
	}
	
	//@Test
	public void testListMember() throws Exception {
		
		Search search = new Search();
		search.setCurrentPage(1);
		search.setPageSize(pageSize);
		
		Member member = new Member();
		member.setMemberRole("user");
		if(member.getMemberRole() != null) {
			Map<String, Object> map = memberService.listMember(search, member);
			List<Member> list = (List<Member>)map.get("listMember");
			
			for (Member mem : list) {
				
				System.out.println(mem);
			}
		
		}
		
		//List<Member> list = memberService.listOwner(search);

		
	}
	
	//@Test
	public void testUpdateMember() throws Exception {
		/*
		Member member = memberService.getUser("y409813@gmail.com");
		//관리자
		member.setRegBlacklist(false);
		memberService.updateUser(member);
		*/
		/*
		//유저(일반)
		//member.setMemberId("test@test.com");
		//member.setMemberRole("user");
		member.setPassword("testPWDd");
		//member.setMemberName("abc");
		member.setMemberPhone("010-2222-3333");
		//member.setLoginType(1);
		//member.setAgeRange("10대");
		//member.setGender("female");
		member.setProfileImage("testFile.png");
		//member.setNickname("test");
		member.setStatusMessage("hihi");
		*/
		/*
		//유저(카카오)
		//member.setMemberId("test2@test.com");
		//member.setMemberRole("user");
		//member.setPassword("testPasswd");
		//member.setMemberName("ghi");
		member.setMemberPhone("010-3333-3333");
		//member.setLoginType(2);
		//member.setAgeRange("10대");
		//member.setGender("female");
		member.setProfileImage("testImg.png");
		//member.setNickname("test");
		member.setStatusMessage("please"); 
		*/
		/*
		//유저(네이버)
		//member.setMemberId("test3@test.com");
		//member.setMemberRole("user");
		//member.setPassword("testPasswd");
		//member.setMemberName("jkl");
		member.setMemberPhone("010-2222-2222");
		//member.setLoginType(3);
		//member.setAgeRange("10대");
		//member.setGender("female");
		member.setProfileImage("testImg.jpg");
		//member.setNickname("test");
		member.setStatusMessage("no");
		*/
		//memberService.updateUser(member);
		///*
		Member member = new Member();
		member.setMemberId("testest@test.com");
		memberService.getMember(member);
		//업주
		//member.setMemberId("testest@test.com");
		//member.setMemberRole("owner");
		member.setPassword("testPwd");
		//member.setMemberName("def");
		member.setMemberPhone("111-1111-1111");
		//member.setLoginType(1);
		member.setProfileImage("testFile.png");
		
		memberService.updateMember(member);
		//*/
		//System.out.println(member);
	}	//complete updateMember !
	
	//@Test
	public void testAddActivityScore() throws Exception {
		
		String memberId = "hihi@a.com";
		int accumulType = 1;
		int accumulScore = 10;
		
		memberService.addActivityScore(memberId, accumulType, accumulScore);

	}
	
	@Test
	public void testListActivityScore() throws Exception {
		
		String memberId = "test@test.com";
		memberService.listActivityScore(memberId).get("listMyActivityScore");

	}
	
	//@Test
	public void test() throws Exception {
		
		String password = "";
		String memberId = "hihi@a.com";
		String nickname = "user1";
		String certificatedNum = "123456";
		
		//비밀번호 일치 여부
		if(memberService.confirmPwd(password)) {
			System.out.println("비밀번호가 일치합니다.");
		} else {
			System.out.println("비밀번호가 일치하지 않습니다.");
		}
		System.out.println("\n==========================\n");
		
		//중복확인(아이디)
		if(! memberService.checkIdDuplication(memberId)) {
			System.out.println("이미 사용 중인 아이디입니다.");
		} else {
			System.out.println("사용 가능한 아이디입니다.");
		}
		System.out.println("\n==========================\n");
		
		//중복확인(닉네임)
		if(! memberService.checkNicknameDuplication(nickname)) {
			System.out.println("이미 사용 중인 닉네임입니다.");
		} else {
			System.out.println("사용 가능한 닉네임입니다.");
		}
		System.out.println("\n==========================\n");
		
		//인증번호 전송, 확인
		System.out.println("인증번호 :: "+memberService.sendCertificatedNum());
		System.out.println("인증번호 일치 여부 :: "+memberService.checkCertificatedNum(certificatedNum));
		System.out.println("\n==========================\n");
		
		//활동점수 추가 및 계산
		
	}
}