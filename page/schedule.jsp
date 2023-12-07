<!-- <%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!-- 데이터베이스 탐색라이브러리 -->
<%@ page import="java.sql.DriverManager" %>
<!-- db연결 라이브러리 -->
<%@ page import="java.sql.Connection" %>
<!-- sql전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement" %>
<!-- 데이터받아오기 라이브러리 -->
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>

<%
request.setCharacterEncoding("utf-8");


String sql=null;
ResultSet rs = null;
PreparedStatement query = null;

String sql2=null;
ResultSet rs2 = null;
PreparedStatement query2 = null;

String sql3=null;
ResultSet rs3 = null;
PreparedStatement query3 = null;
Connection connect = null;

Calendar calendar = Calendar.getInstance();
String userIdx = null;
String userName = null;
String userPhonenumber = null;
String userPosition = null;
String userTeam = null;
String ownerName = null;
String ownerPhonenumber = null;
String ownerIdx = null;
String year = null;
String month = null;
String day = null;

ArrayList<ArrayList<String>> scheduleList = new ArrayList<ArrayList<String>>();
ArrayList<ArrayList<String>> memberList = new ArrayList<ArrayList<String>>();

try{
    userIdx = (String)session.getAttribute("userIdx");
    userName = (String)session.getAttribute("userName");
    userPhonenumber = (String)session.getAttribute("userPhonenumber");
    userPosition = (String)session.getAttribute("userPosition");
    userTeam = (String)session.getAttribute("userTeam");
    ownerName = request.getParameter("ownerName");
    ownerPhonenumber = request.getParameter("ownerPhonenumber");

    year = request.getParameter("selectYear");
    month = request.getParameter("selectMonth");
    day = request.getParameter("selectDay");

    if(year==null){
        year = Integer.toString(calendar.get(Calendar.YEAR));
    }
    if(month==null){
        month = Integer.toString(calendar.get(Calendar.MONTH) + 1);
    }
    if(day==null){
        day = Integer.toString(calendar.get(Calendar.DAY_OF_MONTH));
    }

    if(userIdx == null){ 
        throw new Exception();
    }

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");

    if(ownerName == null ){ // 오너이름이 따로 없다면
        ownerName= userName;
        ownerPhonenumber = userPhonenumber;
        ownerIdx = userIdx;
    }else{ // 오너이름있을때, 다른 사람스케쥴 볼때
        sql3 = "SELECT idx FROM account WHERE name = ? AND phonenumber = ?";
        query3 =  connect.prepareStatement(sql3);
        query3.setString(1,ownerName);
        query3.setString(2,ownerPhonenumber);
        rs3 = query3.executeQuery();
        rs3.next();
        ownerIdx = rs3.getString(1);
    }

    sql = "SELECT date FROM schedule WHERE user_idx = ? AND YEAR(date) = ? AND MONTH(date) = ?  ";
    query = connect.prepareStatement(sql);

    query.setString(1,ownerIdx);
    query.setString(2,year);
    query.setString(3,month);


    rs = query.executeQuery();
    
    while(rs.next()){
        ArrayList<String> schedule = new ArrayList<String>();
        String date = rs.getString(1);
        schedule.add("\"" + date + "\"");
        scheduleList.add(schedule);
    }

    // 팀원명단 가져오기sql
    if(userPosition.equals("팀장")){ // 문자열 비교는 equals

        sql2 = "SELECT name,phonenumber FROM account WHERE team = (SELECT team FROM account WHERE idx = ?)";
        query2 = connect.prepareStatement(sql2);
        query2.setString(1,userIdx);
        rs2 = query2.executeQuery();
        
        while(rs2.next()){
            ArrayList<String> member = new ArrayList<String>();
            String name = rs2.getString(1);
            String phonenumber = rs2.getString(2);

            member.add("\"" + name + "\"");
            member.add("\"" + phonenumber + "\"");
            memberList.add(member);
        }
    }

}catch(Exception e){
    //response.sendRedirect("index.jsp");
}finally{
    if (rs != null) {
        rs.close();
    }
    if (query != null) {
        query.close();
    }
    if (rs2 != null) {
        rs2.close();
    }
    if (query2 != null) {
        query2.close();
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
    <link rel="stylesheet" type="text/CSS" href="../css/schedule.css">
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
        <div class="nav_section">
            팀원목록확인
        </div>
        <div id="team_member">
            <!-- 팀원 추가 -->
        </div>
        <button class="logout_btn" onclick="moveToDestEvent('../action/logoutAction.jsp')">로그아웃</button>
    </nav>
<!-- 메인 -->
    <main>
        <div id="arrow_box">
            <Img class="icon_arrow" onclick="beforeYearEvent()" src="../image/arrow_left_icon.png">
            <p id="owner_calender"></p>
            <Img class="icon_arrow" onclick="afterYearEvent()" src="../image/arrow_right_icon.png">
        </div>
        <div id="month_btn_box">
            <!-- 월버튼추가 -->
        </div>
        <table id="calender">
            <!-- 달력추가 -->
        </table>
    </main>

</body>

<!-- 에러발생 -->
<script >

    // //전역 코드 모아놓기
    var date = new Date()
    var selectYear = <%=year%>
    var selectMonth = <%=month%>
    var selectDay = <%=day%>
    var userIdx = "<%=userIdx%>"
    var ownerIdx = "<%=ownerIdx%>"
    var ownerName = "<%=ownerName%>"
    var ownerPhonenumber = "<%=ownerPhonenumber%>" 
    var memberList = <%=memberList%>
    var scheduleList=<%=scheduleList%> //날짜, 일정,수행여부 순서

    console.log("선택월",selectMonth)

    function moveToDestEvent(e){
        location.href=e
    }

    function monthBtnEvent(e){
        var id = e.target.id
        var index = id.split("_")[2] //인덱스는 현재월
        var ownerCalender = document.getElementById("owner_calender")
        var monthChecked = document.getElementById("month_checked_"+index)
        var monthBtn = document.getElementById("month_btn_"+index)

        console.log("선택 id",id)
        console.log("선택 index",index)
        console.log("선택월",selectMonth)
                
        document.getElementById("month_checked_"+(selectMonth)).style.display="none"
        selectMonth = index 
        var url = "schedule.jsp?ownerName=" + ownerName + "&ownerPhonenumber=" + ownerPhonenumber + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
        monthChecked.style.display="block"

        makeCalenderName(ownerName,selectYear,selectMonth)
        makeCalender(selectMonth)
        window.open(url,"_self")
    }
    function dayBtnEvent(e){
        var id = e.target.id
        var index = id.split("_")[2]
        console.log("id",id)
        console.log("index",index)

        url= "modal.jsp?ownerName=" + ownerName + "&ownerPhonenumber=" + ownerPhonenumber + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
        url+= "&selectDay=" + index
        window.open(url,"_blank","width=700,height=400") // 모달 새창으로 열기
    }

    // 다음연도, 이전연도 버튼 이벤트
    function beforeYearEvent(){
        selectYear -= 1
        url = "schedule.jsp?ownerName=" + ownerName + "&ownerPhonenumber=" + ownerPhonenumber + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
        window.open(url,"_self")
    }
    function afterYearEvent(){
        selectYear += 1
        url = "schedule.jsp?ownerName=" + ownerName + "&ownerPhonenumber=" + ownerPhonenumber + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
        window.open(url,"_self")
    }
    //슬라이드바 토글
    function menuBarEvent(){
        var nav = document.getElementById("navigation")
        var navStyleRight = window.getComputedStyle(nav).getPropertyValue("right")
        if(navStyleRight == "-300px"){
            nav.style.right = "0"
        }else {
            nav.style.right="-300px"
        }
    }

</script>
<script src="../js/schedule.js"></script>

</body>
</html>