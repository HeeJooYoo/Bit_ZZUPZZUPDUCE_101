package com.zzupzzup.web.member;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.zzupzzup.common.Page;
import com.zzupzzup.common.Search;
import com.zzupzzup.service.domain.Member;
import com.zzupzzup.service.member.MemberService;

@Controller
@RequestMapping("/member/*")
public class MemberController {
	
	//*Field
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	@Autowired
	@Qualifier("memberServiceImpl")
	private MemberService memberService;

	//*Constructor
	public MemberController() {
		// TODO Auto-generated constructor stub
		System.out.println(this.getClass());
	}

	//*Method
//	@RequestMapping( value="login", method=RequestMethod.GET )
//	public String login() throws Exception{
//		
//		System.out.println("/member/login : GET");
//
//		return "redirect:/member/loginView.jsp";
//	}
	
//	@RequestMapping( value="login", method=RequestMethod.POST )
//	public String login(@ModelAttribute("member") Member member , HttpSession session) throws Exception{
//		
//		System.out.println("/member/login : POST");
//		//Business Logic
//		Member mb = new Member();
//		mb.setMemberId(member.getMemberId());
//		memberService.getMember(mb);
//		
//		if( member.getPassword().equals(mb.getPassword())){
//			session.setAttribute("mb", mb);
//		}
//		
//		return "redirect:/main.jsp";
//	}
	
	@RequestMapping( value="logout", method=RequestMethod.GET )
	public String logout(HttpSession session) {
		
		System.out.println("/member/logout : GET");
		
		session.invalidate();
		
		return "redirect:/";
		
	}
	
	@RequestMapping(value="addMember/{memberRole}/{loginType}", method=RequestMethod.GET)
	public String addMember(@PathVariable String memberRole, @PathVariable String loginType) throws Exception {
		
		System.out.println("/member/addMember/"+memberRole+"/"+loginType+" : GET");
		
		return "forward:/member/addMemberView.jsp?memberRole="+memberRole+"&loginType="+loginType;
//		return "redirect:/member/addMember/"+memberRole+"/"+loginType;
		
	}
	
	@RequestMapping(value="addMember/{memberRole}/{loginType}", method=RequestMethod.POST)
	public String addMember(@PathVariable String memberRole, @PathVariable int loginType,
				@ModelAttribute("member") Member member, HttpServletRequest request,
				@RequestParam(value="fileInput", required = false) MultipartFile uploadfile) throws Exception {
		
		System.out.println("/member/addMember/"+memberRole+"/"+loginType+" : POST");
		
		String temp = request.getServletContext().getRealPath("/resources/images/uploadImages");
		String profileImage = uploadFile(uploadfile, temp, member.getProfileImage());
		
		member.setMemberRole(memberRole);
		member.setProfileImage(profileImage);
		member.setLoginType(loginType);
		memberService.addMember(member);
		
		Member pushMem = new Member();
		pushMem.setNickname(member.getPushNickname());
		Member push = memberService.getMember(pushMem);
		
		if(push != null) {
			//활동점수 추가하기
			memberService.addActivityScore(push.getMemberId(), 1, 10);
			memberService.calculateActivityScore(push.getMemberId());
		}
		
		if(member.getMemberRole().equals("owner")) {
			//member domain과 같이 음식점 등록으로 페이지 넘기기
			request.setAttribute("member", member);
			//return "redirect:/restaurant/addRestaurant?memberId="+member.getMemberId()+"&memberName="+member.getMemberName();
			
			return "forward:/restaurant/addRestaurantView.jsp";
		} else {
			return "redirect:/";
		}
		
	}
	
	@RequestMapping(value="getMember", method=RequestMethod.GET)
	public String getMember(@RequestParam("memberId") String memberId, HttpServletRequest request) throws Exception {
		
		System.out.println("/member/getMember : GET");
		
		Member memberIdSet = new Member();
		memberIdSet.setMemberId(memberId);
		Member member = memberService.getMember(memberIdSet);
		System.out.println("getMember - "+member);
		
		request.setAttribute("member", member);
		
		return "forward:/member/getMember.jsp";
	}

	@RequestMapping(value="listUser")
	public String listUser(@ModelAttribute("search") Search search,
			HttpServletRequest request) throws Exception {
		
		System.out.println("/member/listUser : GET / POST");
		
		if(search.getCurrentPage() == 0){
			search.setCurrentPage(1);
		}
		
		if(request.getParameter("page") != null) {
			search.setCurrentPage(Integer.parseInt(request.getParameter("page")));
		}
		
		search.setPageSize(pageSize);
		
		Map<String, Object> map = memberService.listUser(search);
		
		Page resultPage = new Page(search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		
		request.setAttribute("listUser", map.get("listUser"));
		request.setAttribute("search", search);
		request.setAttribute("totalCount", map.get("totalCount"));
		request.setAttribute("resultPage", resultPage);
		
		return "forward:/member/listUser.jsp";
	}
	
	@RequestMapping(value="listOwner")
	public String listOwner(@ModelAttribute("search") Search search,
			HttpServletRequest request) throws Exception {

		System.out.println("/member/listOwner : GET / POST");
		
		if(search.getCurrentPage() == 0){
			search.setCurrentPage(1);
		}
		
		if(request.getParameter("page") != null) {
			search.setCurrentPage(Integer.parseInt(request.getParameter("page")));
		}
		
		search.setPageSize(pageSize);
		
		Map<String, Object> map = memberService.listUser(search);
		
		Page resultPage = new Page(search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		
		request.setAttribute("listOwner", map.get("listOwner"));
		request.setAttribute("search", search);
		request.setAttribute("totalCount", map.get("totalCount"));
		request.setAttribute("resultPage", resultPage);
		
		return "forward:/member/listOwner.jsp";
		
	}
	
	public void blacklistUser() {
		
	}
	
	@RequestMapping(value="updateMember", method=RequestMethod.GET)
	public String updateMember(@RequestParam("memberId") String memberId, HttpServletRequest request) throws Exception {
		
		System.out.println("/member/updateMember : GET");
		
		Member memberIdSet = new Member();
		memberIdSet.setMemberId(memberId);
		Member member = memberService.getMember(memberIdSet);
		
		request.setAttribute("member", member);
		
		return "forward:/member/updateMemberView.jsp";
	}
	
	@RequestMapping(value="updateMember/{memberRole}", method=RequestMethod.POST)
	public String updateMember(@PathVariable String memberRole, @ModelAttribute("member") Member member, HttpServletRequest request, HttpSession session,
			@RequestParam(value="fileInput", required = false) MultipartFile uploadfile) throws Exception {
		
		System.out.println("/member/updateMember : POST");
		
		System.out.println("1111 :: " + member);
		System.out.println("2222 :: " + uploadfile.getOriginalFilename());
		
		String temp = request.getServletContext().getRealPath("/resources/images/uploadImages");
		String profileImage = uploadFile(uploadfile, temp, member.getProfileImage());
		
		
		member.setProfileImage(profileImage);
		
		memberService.updateMember(member);
		
		String sessionId = ((Member)session.getAttribute("member")).getMemberId();
		if(sessionId.equals(member.getMemberId())){
			session.setAttribute("member", member);
			System.out.println("session value = "+session.getAttribute("member"));
		}
		
		return "redirect:/member/getMember?memberId="+member.getMemberId();
	}
	
	public void deleteMember() {
		
	}
	
//	public void calculateActivityScore() {
//		
//	}
	
	public void calculateMannerScore() {
		
	}
	
	private String uploadFile(MultipartFile uploadfile, String temp, String originImg) throws Exception {
		
		System.out.println(":: uploadfile.getOriginalFilename() => " + uploadfile.getOriginalFilename());
		System.out.println(":: uploadfile.getSize() => " + uploadfile.getSize());
			
		String saveName = uploadfile.getOriginalFilename();
		
		System.out.println(":: saveName => " + saveName);
		
		Path copy = Paths.get(temp, File.separator + StringUtils.cleanPath(saveName));
		
		try {
			Files.copy(uploadfile.getInputStream(), copy, StandardCopyOption.REPLACE_EXISTING);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();

			if(originImg.equals("defaultImage.png")) {
				saveName = "defaultImage.png";
			} else {
				saveName = originImg;
			}
		}
		
		return saveName;
	}

}
