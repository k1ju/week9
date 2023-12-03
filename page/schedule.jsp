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
<%@ page import="java.util.Calendar" %>

//unique로 검색하기
<%
request.setCharacterEncoding("utf-8");

ResultSet rs = null;
PreparedStatement query = null;
Connection connect = null;

Calendar calendar = Calendar.getInstance();
String userIdx = null;
String userName = null;
String userPhonenumber = null;
String userPosition = null;
String userTeam = null;
String year = null;
String month = null;
String day = null;

ArrayList<ArrayList<String>> scheduleList = new ArrayList<ArrayList<String>>();

try{
    userIdx = (String)session.getAttribute("userIdx");
    userName = (String)session.getAttribute("userName");
    userPhonenumber = (String)session.getAttribute("userPhonenumber");
    userPosition = (String)session.getAttribute("userPosition");
    userTeam = (String)session.getAttribute("userTeam");

    year = request.getParameter("selectYear");
    if(year==null){
        year = Integer.toString(calendar.get(Calendar.YEAR));
    }
    month = request.getParameter("selectMonth");
    if(month==null){
        month = Integer.toString(calendar.get(Calendar.MONTH) + 1);
    }
    day = request.getParameter("selectDay");
    if(day==null){
        day = Integer.toString(calendar.get(Calendar.DAY_OF_MONTH));
    }

    //if문 userIdx사용, if문으로 캐치보내면 else노필요
    if(userIdx == null){ 
        throw new Exception();
    }

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
    String sql = "SELECT date FROM schedule s WHERE idx = ? AND YEAR(date) = ? AND MONTH(date) = ?  ";

    query = connect.prepareStatement(sql);
    query.setString(1,userName);
    query.setString(2,year);
    query.setString(3,month);
    rs = query.executeQuery();
    
    while(rs.next()){
        ArrayList<String> schedule = new ArrayList<String>();
        String date = rs.getString(1);
        schedule.add("\"" + date + "\"");
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
//전역 코드 모아놓기
var scheduleList=<%=scheduleList%> 
var date = new Date()
var selectYear = <%=year%>
var selectMonth = <%=month%>
var selectDay = <%=day%>
var ownerName = "<%=userName%>"
var nav = document.getElementById("navigation")
var menuBtn = document.getElementById("icon_menu")
var arrowLeft = document.getElementById("arrow_left_btn")
var arrowRight = document.getElementById("arrow_right_btn")
var ownerCalender = document.getElementById("owner_calender")
var calender = document.getElementById("calender")
var dayBtnList = document.getElementsByClassName("dayBtn")

console.log(selectYear)
console.log(selectMonth)
console.log(<%=scheduleList%>)


//현재날짜 표시  
document.getElementById("current_date").innerHTML = date.getFullYear() + "-" +  (date.getMonth() + 1) + "-" + date.getDate();

//함수선언

makeCalenderName(ownerName,selectYear,selectMonth)
makeCalender(selectMonth)

// 월 버튼 생성
for(var i=0;i<12;i++){
    let monthBtn = document.createElement("button")
    let monthName = document.createElement("div")
    let monthChecked = document.createElement("div")

    monthBtn.classList.add("month_btn")
    monthBtn.id ='month_btn' + (i+1)

    monthName.classList.add("name_month")
    monthName.innerHTML = (i+1) + "월"

    monthChecked.innerHTML = "V"
    monthChecked.style.display = "none"
    monthChecked.id='month_checked' + (i+1)

    monthBtn.appendChild(monthName)
    monthBtn.appendChild(monthChecked)
    document.getElementById("month_btn_box").appendChild(monthBtn)

    monthBtn.addEventListener('click',function(){
        selectMonth= parseInt(monthBtn.id.replace(/[^0-9]/g,""))
        
        for(var i=0; i<12; i++){
            document.getElementById("month_checked"+(i+1)).style.display="none"
        }
        monthChecked.style.display="block"

        ownerCalender.innerHTML = ownerName + "팀원의 " + selectYear + "년" + selectMonth + "월 일정"

        makeCalenderName(ownerName,selectYear,selectMonth)
        makeCalender(selectMonth)

        let url = "leaderSchedule.jsp?ownerName=" + ownerName + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
        window.open(url,"_self")
    })
}
document.getElementById("month_checked" + (selectMonth)).style.display="block"

//함수정의

function moveToDest(e){
    location.href=e
}
function makeCalenderName(ownerName,selectYear,selectMonth){
    ownerCalender.innerHTML = ownerName + "팀원의 " + selectYear + "년 " + selectMonth + "월 일정"
}
//날짜 생성함수
function makeCalender(selectMonth){
    scheduleList=<%=scheduleList%> //날짜, 일정,수행여부 순서
    console.log("현재월의 스케쥴리스트는 "+scheduleList)
    console.log("달력생성, 현재 월은" + selectMonth + "월")
    var maxDay = 0
    if (selectMonth ==2){
        maxDay=28
    } else if(selectMonth== 1 || selectMonth== 3 || selectMonth== 5 || selectMonth== 5 ||
    selectMonth== 7 || selectMonth== 8 || selectMonth== 10 || selectMonth== 12 ){
        maxDay = 31
    } else {
        maxDay=30
    }

    calender.innerHTML=""
    for(let i=0;i<5;i++){
        var trTag = document.createElement("tr")
        calender.appendChild(trTag)
        trTag.classList.add("tr_tag")
        for(let j=0; j<7;j++){
            let tdTag = document.createElement("td")
            let dayBtn = document.createElement("button")
            let scheduleCount = 0
            let scheduleLine = document.createElement("div")
            
            for(let k=0; k<scheduleList.length; k++){
                if(scheduleList[k][0].substring(8,10) == (i*7)+(j+1)){
                    scheduleCount++
                }
            }

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
            //반복문으로 만든 여러개의 개체에 동시에 이벤트부여하는 것은 addevent가 더 낫다
            dayBtn.addEventListener('click',function(){
                var dayNum = parseInt(j+1) + parseInt(i*7)
                url= "modal.jsp?ownerName=" + ownerName + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
                url+= "&selectDay=" + dayNum
                window.open(url,"_blank","width=700,height=400") // 모달 새창으로 열기
            })
        }
    }
}
// 모달열기, 함수명에 이벤트쓰기
function getModal(){
    url= "scheduleShowAction.jsp?ownerName=" + ownerName + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
    url+= "&selectDay=" + 
    window.open("modal.jsp","_blank","width=700,height=400")
}
// 다음연도, 이전연도 버튼 이벤트
function beforeYearEvent(){
    selectYear -= 1
    url = "leaderSchedule.jsp?ownerName=" + ownerName + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
    window.open(url,"_self")
}
function afterYearEvent(){
    selectYear += 1
    url = "leaderSchedule.jsp?ownerName=" + ownerName + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
    window.open(url,"_self")
}
//슬라이드바 토글
function menuBarEvent(){
    var navStyleRight = window.getComputedStyle(nav).getPropertyValue("right")

    if(navStyleRight == "-300px"){
        nav.style.right = "0"
    }else {
        nav.style.right="-300px"
    }
}
//엘리먼트생성 js로빼기

</script>

</body>
</html>