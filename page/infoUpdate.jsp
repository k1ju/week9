<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!-- db탐색라이브러리 -->
<%@ page import="java.sql.DriverManager"%>
<!-- db연결 라이브러리 -->
<%@ page import="java.sql.Connection"%>
<!-- sql전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement"%>
<!-- 데이터받아오기 라이브러리 -->
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList" %>


<%
request.setCharacterEncoding("utf-8");

String userIdx = null;
ResultSet rs = null;
PreparedStatement query = null;
Connection connect = null;
String userName = null;
String userPhonenumber = null;
String userPosition = null;
String userTeam = null;

ArrayList<ArrayList<String>> scheduleList = new ArrayList<ArrayList<String>>();

try{
    if(session.getAttribute("userIdx") != null){
        userIdx = (String)session.getAttribute("userIdx");
    }else{
        throw new Exception();
    }
    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
    String sql = "SELECT s.*,u.name,u.phonenumber,u.position,u.team FROM schedule s ";
    sql += " LEFT JOIN user u ON s.user_idx = u.idx WHERE s.user_idx = ? ";
    query = connect.prepareStatement(sql);
    query.setString(1,userIdx);
    rs = query.executeQuery();
    
    while(rs.next()){
        ArrayList<String> schedule = new ArrayList<String>();
        String date = rs.getString("date");
        String content = rs.getString("content");
        String executionStatus = rs.getString("execution_status");
        userName = rs.getString("name");
        userPhonenumber = rs.getString("phonenumber");
        userPosition = rs.getString("position");
        userTeam = rs.getString("team");

        schedule.add(date);
        schedule.add(content);
        schedule.add(executionStatus);
        scheduleList.add(schedule);
    }

}catch(Exception e){
    response.sendRedirect("index.jsp");
}finally{
    if (rs != null) {
        rs.close();
    }
    if (query != null) {
        query.close();
    }
    if (connect != null) {
        connect.close();
    }
}
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/CSS" href="../css/infoUpdate.css">
    <link rel="stylesheet" type="text/CSS" href="../css/common.css">

</head>
<body>

    <!-- 헤더 -->
    <header>
        <h1 onclick="moveToDest('schedule.jsp')">Time Tree</h1>
        <div id="current_date"></div>
        <button id="btn_menu" onclick="menuBarEvent()">
            <Img id="icon_menu" src="../image/icon_menu2.png">
        </button>
    </header>
<!-- 슬라이드바 -->
    <nav id="navigation">
        <div id="nav_header">메뉴</div>
        <div class="nav_section">내정보확인</div>
        <table id="nav_info">
            <tr class="row">
                <td class="c1">이름:</td>
                <td class="2c"><%=userName%></td>
            </tr>
            <tr class="row">
                <td class="c1">연락처:</td>
                <td class="2c"><%=userPhonenumber.substring(0,3)%>-<%=userPhonenumber.substring(3,7)%>-<%=userPhonenumber.substring(7,11) %></td>
            </tr>
            <tr class="row">
                <td class="c1">직급:</td>
                <td class="2c"><%=userPosition%></td>
            </tr>
            <tr class="row">
                <td class="c1">부서:</td>
                <td class="2c"><%=userTeam%></td>
            </tr>
        </table>
        <button id="btn_update" onclick="moveToDest('infoUpdate.jsp')">정보수정</button>
        <div class="nav_section">팀원목록확인</div>
        <div id="team_member">
            <!-- 팀원 추가 -->
        </div>
        <button class="logout_btn" onclick="moveToDest('../action/logoutAction.jsp')">로그아웃</button>
    </nav>

    <main>
        <h1 class="page_title">정보수정</h1>

        <form id="info_box" action="../action/infoUpdateAction.jsp" onsubmit="return formEvent()">
            <table id="info_table">
                <tr class="row">
                    <td class="c1">이름:</td>
                    <td>
                        <input id = "input_name" class="input" type="text" value="<%=userName%>" name="name_value">
                    </td>
                </tr>
                <tr class="row">
                    <td class="c1">
                        연락처:
                    </td>
                    <td>
                        <input id = "input_phonenumber" class="input" type="text" name="phonenumber_value" value="<%=userPhonenumber.substring(0,3)%>-<%=userPhonenumber.substring(3,7)%>-<%=userPhonenumber.substring(7,11) %>">
                    </td>
                </tr>
                <tr class="row">
                    <td class="c1">
                        직급:
                    </td>
                    <td>
                        <input type="radio" value="팀원" name="position_value">팀원
                        <input type="radio" value="팀장" name="position_value">팀장
                    </td>
                </tr>
                <tr class="row">
                    <td class="c1">
                        부서:
                    </td>
                    <td>
                        <input type="radio" value="스테이지어스" name="team_value">스테이지어스
                        <input type="radio" value="네이버" name="team_value">네이버
                    </td>
                </tr>
            </table>
            <input type="submit" class="updateBtn" value="수정확인">

        </form>
    </main>
</body>

<script>

var nav = document.getElementById("navigation")
var menuBtn = document.getElementById("icon_menu")
date = new Date();
var currentYear = date.getFullYear();
var currentMonth = date.getMonth() + 1;
var currentDay = date.getDate();

// 날짜표시
document.getElementById("current_date").innerHTML = currentYear + "-" +  currentMonth + "-" + currentDay

function moveToDest(e){
    location.href=e
}
//슬라이드바 토글이벤트
function menuBarEvent(){
    var navStyleRight = window.getComputedStyle(nav).getPropertyValue("right")

    if(navStyleRight == "-300px"){
        console.log("네비게이션 펼치기")
        nav.style.right = "0"
    }else {
        console.log("네비게이션 숨기기")
        nav.style.right="-300px"
    }
}
function formEvent(){
    var userName = document.getElementById("input_name").value
    var userPhonenumber = document.getElementById("input_phonenumber").value
    var userTeam = null
    var userPosition = null
    var userTeamList = document.getElementsByName("team_value")
    var userPositionList = document.getElementsByName("position_value")

    for(var i=0;i<userTeamList.length;i++){
        if(userTeamList[i].checked == true){
            userTeam = userTeamList[i].value
        }
    }
    for(var i=0;i<userPositionList.length;i++){
        if(userPositionList[i].checked == true){
            userPosition = userPositionList[i].value
        }
    }
    // if(!userName?.trim() || !userPhonenumber?.trim() || !userTeam?.trim() || !userPosition?.trim() ){
    //     alert("값을 입력해주세요")
    //     return false
    // }

}

</script>
</body>
</html>