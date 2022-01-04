<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML>

<html>
<head>
<title>ZZUPZZUP-getMember</title>

<jsp:include page="/layout/toolbar.jsp" />

<!--  ///////////////////////// CSS ////////////////////////// -->
<style>
</style>

<!--  ///////////////////////// JavaScript ////////////////////////// -->
<script type="text/javascript">
	$(function() {
		console.log("getMember.jsp");
		
		$("#updateMember").on("click", function() {
			location.href = "/member/updateMember";
		})
	});
</script>
</head>

<body class="is-preload">

	<!-- S:Wrapper -->
	<div id="wrapper">

		<!-- S:Main -->
		<div id="main">
			<div class="inner">

				<!-- Header -->
				<jsp:include page="/layout/header.jsp" />

				<section id="getMember">
					<div class="container">
						<div class="row justify-content-center">
							<div class="col-12 col-lg-10 col-xl-8 mx-auto">
								<h2 class="h3 mb-4 page-title">내 정보 조회</h2>
								<div class="my-4">
									<form id="getMember">
										<div class="row mt-5 align-items-center">
											<div class="col-md-3 mb-5">
												<div class="col-md" align="center">
													<img
														src="/resources/images/uploadImages/${member.profileImage}"
														class="avatar-img rounded-circle" width="150" /> <br />
													<c:if test="${sessionScope.member.memberRole == 'user'}">
														<span
															id="mannerScore" style="font-weight: bold">
															<svg
																xmlns="http://www.w3.org/2000/svg" width="10" height="10"
																fill="#b01025" class="bi bi-heart-fill"
																viewBox="0 0 16 16">
															  <path fill-rule="evenodd"
																	d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"
																	/>
															</svg> ${member.mannerScore}
														</span>
													</c:if>
												</div>
											</div>
											<!-- memberRole user일 때 프로필 이미지 옆 공간 -->
											<c:if test="${sessionScope.member.memberRole == 'user'}">
												<div class="col-md-9">
													<div class="row align-items-right">
														<div class="col-md-7">
															<h4 class="mb-1">
																	<span class="badge badge-pill badge-dark" style="background-color: #f56a6a;">${member.memberRank}</span>&nbsp;&nbsp;
																${member.nickname}
															</h4>
														</div>
													</div>
													<div class="row mb-4">
														<div class="col-md-7">
															<p class="text-muted">${member.statusMessage}</p>
														</div>
													</div>
												</div>
											</c:if>
											<!-- memberRole owner일 때 프로필 이미지 옆 공간 -->
											<c:if test="${sessionScope.member.memberRole == 'owner'}">
												<div class="col-md-9" style="vertical-align:middle;margin-bottom: 55px;">
													<div class="col-md-7">
														<h4 class="mb-1">
															이름
														</h4>
														${member.memberName}
													</div>
													<br/>
													<div class="col-md-7">
														<h4 class="mb-1">
															아이디
														</h4>
														${member.memberId}
													</div>
													<br/>
													<div class="col-md-7">
														<h4 class="mb-1">
															전화번호
														</h4>
														${member.memberPhone}
													</div>
												</div>
												
												<%-- <div class="form-row">
													<div class="col-12">
														<h4>이름<span>${member.memberName}</span></h4>
													</div>
												</div>
												<div class="form-row">
													<div class="col-12">
														<h4>아이디<span>${member.memberId}</span></h4>
													</div>
												</div>
												<div class="form-row">
													<div class="col-12">
														<h4>전화번호<span>${member.memberPhone}</span></h4>
													</div>
												</div> --%>
											</c:if>
										</div>
										<a href="#" style="float:right;color:#bfbfbf">회원탈퇴</a>
										<br>
										<hr class="my-4" />
										<c:if test="${sessionScope.member.memberRole == 'user'}">
											<div class="form-row">
												<div class="col-6">
													<label for="memberName">이름</label> <span id="memberName"
														style="font-weight: bold">${member.memberName}</span>
												</div>
												<div class="col-6">
													<label for="email">이메일</label> <span id="email"
														style="font-weight: bold">${member.memberId}</span>
												</div>
											</div>
											<br />
											<div class="form-row">
												<div class="col-6">
													<label for="memberPhone">전화번호</label> <span id="memberPhone"
														style="font-weight: bold">${member.memberPhone}</span>
												</div>
											</div>
											<br />
											<div class="form-row">
												<div class="col-6">
													<label for="ageRange">연령대</label> <span id="ageRange"
														style="font-weight: bold">${member.ageRange}</span>
												</div>
												<div class="col-6">
													<label for="gender">성별</label> <span id="gender"
														style="font-weight: bold"> <c:if
															test="${member.gender == 'male'}">
													남자
													</c:if> <c:if test="${member.gender == 'female'}">
													여자
													</c:if>
													</span>
												</div>
											</div>
										</c:if>
										<c:if test="${sessionScope.member.memberRole == 'owner'}">
											<div class="form-row">
												<div class="col-6">
													<h4 align="left"><strong>등록된 음식점 목록</strong></h4>
												</div>
												<div class="col-6">
													<a href="/restaurant/addRestaurant?memberId=${member.memberId}">
														<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-lg" viewBox="0 0 16 16" id="addRestaurant-ownerPage" style="float:right;">
														  <path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2Z"/>
														</svg>
													</a>
												</div>
												<!-- 등록된 음식점 수 띄우기 -->
												<%-- <c:if test="${restaurant.member.memberId == member.memberId}">
													<c:set var="i" value="0" />
													<c:forEach var="restaurant" items="${list}">
														<div class="col-12">
															<div class="no-gutters border rounded overflow-hidden flex-md-row mb-4 shadow-sm h-md-250 position-relative">
																<div class="col p-4 d-flex flex-column position-static">
																	<c:if test="${restaurant.reservationStatus = true}">
																		<div style="text-align: right;"><span class="badge badge-info">예약 및 결제 가능</span></div>
																	</c:if>
																	<!-- <a style="text-align: right;"><strong class="d-inline-block mb-2 text-primary">불량음식점</strong></a> -->
																	<h2 class="mb-0">${restaurant.restaurantName}&nbsp;<small style="color:gray;">${restaurant.returnMenuType}</small></h2><hr>
																	<div class="mb-1 text-muted"><strong>대표자명</strong> | ${restaurant.member.memberName}</div>
																	<div class="mb-1 text-muted"><strong>주소</strong> | ${restaurant.streetAddress}</div>
																	<div class="mb-1 text-muted"><strong>전화번호</strong> | ${restaurant.restaurantTel}</div>
																	<a href="/restaurant/getRestaurant?restaurantNo=${restaurant.restaurantNo}" style="text-align: right;" class="stretched-link" id="restinfo">상세보기</a>
																</div>
															</div>
														</div>
													</c:forEach>
												</c:if> --%>
												<br/>
											</div>
										</c:if>
										<c:if test="${sessionScope.member.memberRole == 'admin'}">
											<hr class="my-4"/>
											<div class="form-row">
												<div class="col-6">
													<label for="regDate">가입일</label> <span id="regDate"
														style="font-weight: bold">${member.regDate}</span>
												</div>
												<div class="col-6">
													<label for="reportCount">신고 당한 횟수</label> <span
														id="reportCount" style="font-weight: bold">${member.reportCount}</span>
												</div>
											</div>
											<br/>
											<div class="form-row">
												<c:if test="${! empty member.deleteDate}">
													<div class="col-6">
														<label for="deleteDate">탈퇴일</label> <span id="deleteDate"
															style="font-weight: bold">${member.deleteDate}</span>
													</div>
												</c:if>
												<c:if test="${! empty member.blacklistDate}">
													<div class="col-6">
														<label for="blacklistDate">블랙리스트</label> <span id="blacklistDate"
															style="font-weight: bold">${member.blacklistDate}</span>
													</div>
												</c:if>
											</div>
										</c:if>
										<hr class="my-4" />
										<input type="button" style="float: right" id="updateMember"
											class="btn btn-primary" value="수정하기" />
									</form>
								</div>
							</div>
						</div>
					</div>
				</section>
			</div>
		</div>
		<!-- E:Main -->

		<!-- Sidebar -->
		<jsp:include page="/layout/sidebar.jsp" />
	</div>
	<!-- E:Wrapper -->
</body>
</html>