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
String userName = null;
String userPhonenumber = null; 
String userPosition = null;
String userTeam = null;
String sql = null;

ResultSet rs = null;
PreparedStatement query = null;
Connection connect = null;

ArrayList<ArrayList<String>> memberList = new ArrayList<ArrayList<String>>();

try{
    userIdx = (String)session.getAttribute("userIdx");
    userName = (String)session.getAttribute("userName");
    userPhonenumber = (String)session.getAttribute("userPhonenumber");
    userPosition = (String)session.getAttribute("userPosition");
    userTeam = (String)session.getAttribute("userTeam");

    if(userIdx == null){
        throw new Exception();
    }
   

    // 팀원명단 가져오기sql
    if(userPosition.equals("팀장")){ // 문자열 비교는 equals
        Class.forName("com.mysql.jdbc.Driver"); //db연결
        connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
        sql = "SELECT name,phonenumber FROM account WHERE team = (SELECT team FROM account WHERE idx = ?)";
        query = connect.prepareStatement(sql);
        query.setString(1,userIdx);
        rs = query.executeQuery();
        
        while(rs.next()){
            ArrayList<String> member = new ArrayList<String>();
            String name = rs.getString(1);
            String phonenumber = rs.getString(2);

            member.add("\"" + name + "\"");
            member.add("\"" + phonenumber + "\"");
            memberList.add(member);
        }
    }


    
}catch(Exception e){
    response.sendRedirect("index.jsp");
    return;
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
        <h1 onclick="moveToDestEvent('schedule.jsp')">Time Tree</h1>
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
        <button id="btn_update" onclick="moveToDestEvent('infoUpdate.jsp')">정보수정</button>
        <div class="nav_section">팀원목록확인</div>
        <div id="team_member">
            <!-- 팀원 추가 -->
        </div>
        <button class="logout_btn" onclick="moveToDestEvent('../action/logoutAction.jsp')">로그아웃</button>
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
//본파일에 전역변수 선언해주고, js연결은 맨밑에 해주기!


    var userTeam = "<%=userTeam%>"
    var userPosition = "<%=userPosition%>"
    var memberList = <%=memberList%>

    function moveToDestEvent(e){
        location.href=e
    }
    //슬라이드바 토글이벤트
    function menuBarEvent(){
        var nav = document.getElementById("navigation")
        var navStyleRight = window.getComputedStyle(nav).getPropertyValue("right") //조회는 getComputedby

        if(navStyleRight == "-300px"){
            nav.style.right = "0"
        }else {
            nav.style.right="-300px"
        }
    }
    function formEvent(){
        var userName = document.getElementById("input_name").value
        var userPhonenumber = document.getElementById("input_phonenumber").value
        var userTeam = null
        var userPosition = null
        userTeamList = document.getElementsByName("team_value")
        userPositionList = document.getElementsByName("position_value")

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
        if(!userName?.trim() || !userPhonenumber?.trim() || !userTeam?.trim() || !userPosition?.trim() ){
            alert("값을 입력해주세요")
            return false
        }
    }

</script>
<script src="../js/infoUpdate.js"></script>

</body>
</html>


