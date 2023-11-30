<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!-- 데이터베이스 탐색라이브러리 -->
<%@ page import="java.sql.DriverManager" %>
<!-- db연결 라이브러리 -->
<%@ page import="java.sql.Connection" %>
<!-- sql전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement" %>
<!-- 데이터받아오기 라이브러리 -->
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>

<!-- 세션없이 접근하는 경우 처리 -->

<%
request.setCharacterEncoding("utf-8");

String userIdx = null;
ResultSet rs = null;
PreparedStatement query = null;
ResultSet rs2 = null;
PreparedStatement query2 = null;
Connection connect = null;
String userName = null;
String userPhonenumber = null;
String userPosition = null;
String userTeam = null;

ArrayList<ArrayList<String>> scheduleList = new ArrayList<ArrayList<String>>();
ArrayList<String> memberList = new ArrayList<String>();
try{
    if(session.getAttribute("userIdx") != null){
        userIdx = (String)session.getAttribute("userIdx");
    }else{
        throw new Exception();
    }
    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
    String sql =  "SELECT * FROM user WHERE team = (SELECT team FROM user WHERE idx = ?)"; // 팀원명단 가져오기
    query = connect.prepareStatement(sql);
    query.setString(1,userIdx);
    rs = query.executeQuery();
    
    while(rs.next()){
        userName = rs.getString("name");
        memberList.add("\"" + userName + "\"");
    }

    String sql2 = "SELECT s.*,u.name,u.phonenumber,u.position,u.team FROM schedule s ";  //  내정보와 내일정 가져오기
    sql2 += " LEFT JOIN user u ON s.user_idx = u.idx WHERE s.user_idx = ? ";
    query2 = connect.prepareStatement(sql2);
    query2.setString(1,userIdx);
    rs2 = query2.executeQuery();
    
    while(rs2.next()){
        ArrayList<String> schedule = new ArrayList<String>();
        String date = rs2.getString("date");
        String content = rs2.getString("content");
        String executionStatus = rs2.getString("execution_status");
        userName = rs2.getString("name");
        userPhonenumber = rs2.getString("phonenumber");
        userPosition = rs2.getString("position");
        userTeam = rs2.getString("team");

        schedule.add("\"" + date + "\"");
        schedule.add("\"" + content + "\"");
        schedule.add("\"" + executionStatus + "\"");
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
    <link rel="stylesheet" type="text/CSS" href="../css/schedule.css">
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
<!-- 메인 -->
    <main>
        <div id="arrow_box">
            <Img class="icon_arrow" onclick="beforeYearEvent()" src="../image/arrow_left_icon.png">
            <p id="owner_calender"></p>
            <Img class="icon_arrow" onclick="afterYearEvent()" src="../image/arrow_right_icon.png">
        </div>
        <div id="month_btn_box">
        </div>
        <table id="calender">
        </table>
    </main>

</body>
<script>
var memberList=<%=memberList%>
console.log(memberList)

date = new Date();
var selectYear = date.getFullYear();
var selectMonth = date.getMonth() + 1;
var selectDay = date.getDate();
var maxDay = 0
var nav = document.getElementById("navigation")
var menuBtn = document.getElementById("icon_menu")
var arrowLeft = document.getElementById("arrow_left_btn")
var arrowRight = document.getElementById("arrow_right_btn")
var ownerCalender = document.getElementById("owner_calender")
var ownerName = "기주"
var calender = document.getElementById("calender")
var dayBtnList = document.getElementsByClassName("dayBtn")

//현재날짜 표시  
document.getElementById("current_date").innerHTML = selectYear + "-" +  selectMonth + "-" + selectDay;

// 월 버튼 생성
for(var i=0;i<12;i++){
    var monthBtn = document.createElement("button")
    var monthName = document.createElement("div")
    var monthChecked = document.createElement("div")

    monthBtn.classList.add("month_btn")
    monthBtn.id ='month_btn' + i

    monthName.classList.add("name_month")
    monthName.innerHTML = (i+1) + "월"

    monthChecked.innerHTML = "V"
    monthChecked.style.display = "none"
    monthChecked.id='month_checked' + i

    monthBtn.appendChild(monthName)
    monthBtn.appendChild(monthChecked)
    document.getElementById("month_btn_box").appendChild(monthBtn)
}
document.getElementById("month_checked" + (selectMonth-1)).style.display="block"

//함수선언

makeCalenderName(ownerName,selectYear,selectMonth)
makeCalender(selectMonth)
teamMember(memberList)

//함수정의
function moveToDest(e){
    location.href=e
}
function makeCalenderName(ownerName,selectYear,selectMonth){
    ownerCalender.innerHTML = ownerName + "팀원의 " + selectYear + "년 " + selectMonth + "월 일정"
}
function teamMember(memberList){
    for(var i=0;i<memberList.length;i++){
        var member = document.createElement("a")
        member.innerHTML=memberList[i]
        member.classList.add("member")
        member.href= "memberSchedule.jsp"
        document.getElementById("team_member").appendChild(member)
    }
}
//날짜 생성함수
function makeCalender(selectMonth){

    if (selectMonth ==2){
        maxDay=28
    } else if(selectMonth== 1 || selectMonth== 3 || selectMonth== 5 || selectMonth== 5 ||
    selectMonth== 7 || selectMonth== 8 || selectMonth== 10 || selectMonth== 12 ){
        maxDay = 31
    } else {
        maxDay=30
    }

    calender.innerHTML=""
    for(var i=0;i<5;i++){
        var trTag = document.createElement("tr")
        calender.appendChild(trTag)
        for(var j=0; j<7;j++){
            var tdTag = document.createElement("td")
            var dayBtn = document.createElement("button")
            var scheduleCount = 1
            var scheduleLine = document.createElement("div")

            tdTag.className="tdTag"
            dayBtn.className="dayBtn"
            scheduleLine.className="scheduleLine"
            tdTag.appendChild(dayBtn)
            if ((j+1)+(i*7) > maxDay){
                break
            }
            dayBtn.innerHTML = (j+1)+(i*7)
            
            trTag.appendChild(tdTag)
            dayBtn.appendChild(scheduleLine)

            if(scheduleCount!=0){
                scheduleLine.innerHTML = scheduleCount
            }else{
                scheduleLine.style.display="none"
            }
            dayBtn.addEventListener('click',getModal)
        }
    }
}
// 선택날짜 일정확인
function getModal(){

    window.open("modal.jsp","_blank","width=700,height=400")
}

//이벤트설정
// 다음연도, 이전연도 버튼 이벤트
function beforeYearEvent(){
    selectYear -= 1
    makeCalenderName(ownerName,selectYear,selectMonth)
}

function afterYearEvent(){
    selectYear += 1
    makeCalenderName(ownerName,selectYear,selectMonth)
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

// 월버튼 이벤트
for(var i=0;i<12;i++){
    (function(index){
        var thisMonthBtn = document.getElementById("month_btn"+i)
        var thisChecked = document.getElementById("month_checked"+i)
        thisMonthBtn.addEventListener('click',function(){
            for(var j=0;j<12;j++){
                document.getElementById("month_checked"+j).style.display="none"
            }
            thisChecked.style.display="block"
            selectMonth= parseInt(thisMonthBtn.id.replace(/[^0-9]/g,"")) + 1
            ownerCalender.innerHTML = ownerName + "팀원의 " + selectYear + "년" + selectMonth + "월 일정"

            makeCalenderName(ownerName,selectYear,selectMonth)
            makeCalender(selectMonth)
        }
    )}(i)
)}











</script>

</body>
</html>