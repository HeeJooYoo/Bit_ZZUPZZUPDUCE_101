package com.zzupzzup.service.member;

import java.util.List;

import com.zzupzzup.common.Search;
import com.zzupzzup.service.domain.Member;

public interface MemberDAO {

	public void addMember(Member member) throws Exception;
	
	public void login() throws Exception;
	
	public void kakaoLogin() throws Exception;
	
	public void naverLogin() throws Exception;
	
	public Member getMember(String memberId) throws Exception;
	
	public List<Member> listMember(Search search) throws Exception;
	
	public void updateMember() throws Exception;
}
