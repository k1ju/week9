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
<script>
//전역 코드 모아놓기
var date = new Date()
var selectYear = <%=year%>
var selectMonth = <%=month%>
var selectDay = <%=day%>
var ownerName = "<%=ownerName%>"
var ownerPhonenumber = "<%=ownerPhonenumber%>" 
var memberList = <%=memberList%>
var scheduleList = <%=scheduleList%>

console.log("멤버리스트:",memberList)
console.log("유저idx",<%=userIdx%>)
console.log("ownerName","<%=ownerName%>")
console.log("ownerPhonenumber","<%=ownerPhonenumber%>")
console.log("ownerIdx",<%=ownerIdx%>)

var ownerCalender = document.getElementById("owner_calender")
var calender = document.getElementById("calender")
var dayBtnList = document.getElementsByClassName("dayBtn")


//현재날짜 표시  
document.getElementById("current_date").innerHTML = date.getFullYear() + "-" +  (date.getMonth() + 1) + "-" + date.getDate();

//함수선언

makeCalenderName(ownerName,selectYear,selectMonth)
makeCalender(selectMonth)
teamMember(memberList)

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
        let url = "schedule.jsp?ownerName=" + ownerName + "&ownerPhonenumber=" + ownerPhonenumber + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
        window.open(url,"_self")
    })
}

document.getElementById("month_checked" + (selectMonth)).style.display="block"


//함수정의

function moveToDestEvent(e){
    location.href=e
}
function makeCalenderName(ownerName,selectYear,selectMonth){
    ownerCalender.innerHTML = ownerName + "팀원의 " + selectYear + "년 " + selectMonth + "월 일정"
}
function teamMember(memberList){//2차원리스트, 이름,전화번호순
    for(var i=0;i<memberList.length;i++){
        var member = document.createElement("a")
        member.innerHTML=memberList[i][0] + " : " + memberList[i][1].substring(0,3) + "-" + memberList[i][1].substring(3,7) + "-" + memberList[i][1].substring(7,11)             
        member.classList.add("member")
        member.href= "schedule.jsp?ownerName=" + memberList[i][0] + "&ownerPhonenumber=" + memberList[i][1] 
        //이름,전화번호 전달
        document.getElementById("team_member").appendChild(member)
    }
}
//날짜 생성함수
function makeCalender(selectMonth){
    scheduleList=<%=scheduleList%> //날짜, 일정,수행여부 순서
    console.log("스케쥴리스트:",scheduleList)
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
                url= "modal.jsp?ownerName=" + ownerName + "&ownerPhonenumber=" + ownerPhonenumber + "&selectYear=" + selectYear + "&selectMonth=" + selectMonth
                url+= "&selectDay=" + dayNum
                window.open(url,"_blank","width=700,height=400") // 모달 새창으로 열기
            })
        }
    }
}
// 모달열기, 함수명에 이벤트쓰기
// function getModalEvent(){
//     url= "scheduleShowAction.jsp?selectYear=" + selectYear + "&selectMonth=" + selectMonth
//     url+= "&selectDay=" + selectDay
//     window.open("modal.jsp","_blank","width=700,height=400")
// }
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
//createElement같은 이벤트함수 아닌건 js로빼기

</script>

</body>
</html>