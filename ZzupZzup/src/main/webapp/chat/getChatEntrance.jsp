<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML>

<html>
<head>
<title>ZZUPZZUP-채팅방</title>

<jsp:include page="/layout/toolbar.jsp" />
<link rel="stylesheet" href="/resources/css/chat.css" />

<!--  ///////////////////////// CSS ////////////////////////// -->

<!--  ///////////////////////// JavaScript ////////////////////////// -->
<script src="http://localhost:1000/socket.io/socket.io.js"></script>
<script type="text/javascript">
	$(function() {
		console.log("getChatEntrance.jsp");
		
		let MY_USER_ID = "";
		
		//페이지 접속시 socket.io 접속
		const socket = io.connect('http://localhost:1000', {
			cors: { origin: '*' }
		});
		
		//페이지 접속시 현재 아이디 node 서버로 보내거나 로그인 안했으면 guest라고 보냄
		socket.emit({
			"name":"${member.nickname}",
			"profileImg":"${member.profileImage}",
			"age":"${memner.ageRange}",
			"gender":"${member.gender}"
		});
		
		//서버로 보낸 내 아이디 다시 받아옴
		socket.on("send_user_id", (data) => {
			MY_USER_ID = data.user_id;
			sendMyName(data.user_name);
			//alert(MY_USER_ID);
		});
		
		//전체 사용자 정보 가져옴
		socket.on("all_users", (data) => {				
			var All_USER = data;
			console.log(All_USER);
			console.log(All_USER.length);
			$(".user-list").html("");
			All_USER.forEach(function(element, index){
				$(".user-list").append("<li>"+element.user_name+"</li>");
	        });
			
		});
		
		function sendMyName(send_user_name){
			let data = {"name":send_user_name, "user_id":MY_USER_ID};
			socket.emit("connect_name", data);
		}
		
		const nickname = $("#nickname");
		const chatList = $(".chatting-list");
		const chatInput = $(".chatting-input");
		const sendButton = $(".send-button");
		const displayContainer = $(".display-container");
		
		chatInput.on("keypress", (e) => {
			if(e.keyCode === 13){
				send()
			}
		});
		
		function send(){
			const param = {
				room: 1,
				name: nickname.val(),
				msg: chatInput.val(),
				time: new Date(),
			}
			
			socket.emit("send_msg", param);
			$(".chatting-input").val("");
		}
		
		sendButton.on("click", function(){
			send()
		});
		
		socket.on("send_msg", (data) => {
			console.log(data);
			const { name, msg, time } = data;
			const item = new LiModel(name, msg, time);
			item.makeLi();
			console.log("con scroll" + chatList.height());
			displayContainer.scrollTop(chatList.height());
		});

		function LiModel(name, msg, time) {
			
			this.makeLi = () => {
				console.log(name);
				const $li = $("<li></li>");
				$li.addClass(nickname.val() === name ? "sent" : "received");
				const dom = "<span class='profile'><span class='user'>"+name+"</span><img class='image' src='https://placeimg.com/50/50/any' alt='any'></span><span class='message'>"+msg+"</span><span class='time'>"+time+"</span>";
				$li.html(dom).appendTo(chatList);
			}
		}
		
		showCollections();
		
		function showCollections(){
			$.ajax({
				url:"/mongo/json/getChatCon/"+1,
				type:"GET",
				dataType: "json",
				headers: {
					"Accept": "application/json",
					"Content-Type": "application/json"
				},
				success:function(JSONData, status){
					//console.log(JSONData);
					let dom = "";
					
					$.each(JSONData, function(key, value){
						console.log(value.name);
						let className = nickname.val() === value.name ? "sent" : "received";
						let timeStemp = new Date(value.createdAt);
						var newTime = timeFormatter(timeStemp);
						dom += "<li class="+ className +"><span class='profile'><span class='user'>"+value.name+"</span><img class='image' src='https://placeimg.com/50/50/any' alt='any'></span><span class='message'>"+value.msg+"</span><span class='time'>"+newTime+"</span></li>";
					});
					//console.log(dom);
					chatList.html(dom);
					displayContainer.scrollTop(chatList.height());
					
					console.log("success");
				},
				error:function(e){
					console.log("err : " + e);
				}
			});
		}
		
		//채팅방 시간 포멧 함수
		function timeFormatter(dateTime){
			var date = new Date(dateTime);
			if (date.getHours()>=12){
			    var hour = parseInt(date.getHours()) - 12;
			    var amPm = "PM";
			} else {
			    var hour = date.getHours();
			    var amPm = "AM";
			}
			if (date.getMinutes() <10){
				var minutes = "0"+date.getMinutes();
			}else{
				var minutes = date.getMinutes();
			}
			var time = hour + ":" + minutes + " " + amPm;
			console.log(time);
			return time;
		}
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

				<section id="getChatEntrance">
					<div class="container">

						<!-- S:chatting -->
						<div class="d-flex flex-row chat-container">
							<input type="hidden" id="memberId" value=""/>
							<input type="hidden" id="nickname" value=""/>
							<input type="hidden" id="chatNo" value=""/>
							<input type="hidden" id="restaurantNo" value=""/>
							
						
						
							<div class="chat-contents d-flex flex-column">
								<div class="chat-header d-flex flex-row align-items-center">
									<h3 class="flex-fill">채팅방 제목</h3>
									<div class="chat-header-util flex-fill">
										<span>2021-01-01</span>
										<span><a href="" class="svg-btn" title="채팅방 신고"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-exclamation-triangle-fill" viewBox="0 0 16 16"><path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/></svg></a></span>
										<span class="badge badge-success chat-state">모집중</span>
									</div>
								</div>
								<div class="chat-body">
									<div class="display-container">
										<ul class="chatting-list">
	                 						<li class="sent">
	                 							<div class="chatProfile">
	                 								<img src="/resources/images/common/defaultImage.jpg"/>
	                 								<b>닉네임</b>
	                 								<small>2021-10-10</small>
	                 							</div>
	                 							<div class="chat-message">
	                 								채팅 메세지 메세지
	                 							</div>
	                 						</li>
	                 						<li class="received">
	                 							<div class="chatProfile">
	                 								<img src="/resources/images/common/defaultImage.jpg"/>
	                 								<b>닉네임</b>
	                 								<small>2021-10-10</small>
	                 							</div>
	                 							<div class="chat-message">
	                 								채팅 메세지 메세지
	                 							</div>
	                 						</li>
	             						</ul>
									</div>
								</div>
								<div class="chat-footer">	
	             					<div class="input-container">
	             						<textarea rows="2" placeholder="보낼 메세지 입력"></textarea>
	             						<input type="button" class="send-button warning" value="보내기" />
	             					</div>
								</div>
							</div>
							
							<div class="chat-user d-flex flex-column">
								<div class="chat-header d-flex flex-row align-items-center">
									<h3 class="flex-fill">참여자 목록<small>(<b>3</b>/10)</small></h3>
									<div class="chat-header-util">
										<input type="button" class="button small secondary" value="나가기" />
										<div class="dropdown-parent">
											<a href="" class="svg-btn chat-info-button dropdown-parent" title="채팅방,음식점 정보보기"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-three-dots-vertical" viewBox="0 0 16 16"><path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/></svg></a>
											<div class="dropdown-box">
												<a href="">음식점 정보</a>
												<a href="">채팅방 정보</a>
											</div>
										</div>
									</div>
								</div>
								<div class="chat-body">
									<ul class="user-list">
										<li class="chatProfile d-flex flex-row align-items-center">
											<img src="/resources/images/common/defaultImage.jpg"/>
											<div class="dropdown-parent">
												<a href="" >닉네임</a>
												<div class="dropdown-box">
													<a href="">프로필 보기</a>
													<a href="">참여자 신고</a>
												</div>
											</div>
											<span class="badge badge-info gender">남</span>
											<span class="badge badge-warning age">30대</span>
										</li>
									</ul>
								</div>
								<div class="chat-footer">
									<input type="button" class="button small" value='모임참여 체크하기'/>
									<input type="button" class="button primary small" value="예약하기"/>
								</div>
							</div>
							
						</div>
						<!-- E:chatting -->

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