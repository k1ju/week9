<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>


<!-- 추가해야할부분

// 클로저란 
// IIFE란 무엇인가?

// 시간 다이얼 수정하기


-->

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
                <td class="2c">김기주</td>
            </tr>
            <tr class="row">
                <td class="c1">연락처:</td>
                <td class="2c">010-0000-0000</td>
            </tr>
            <tr class="row">
                <td class="c1">직급:</td>
                <td class="2c">팀원</td>
            </tr>
            <tr class="row">
                <td class="c1">부서:</td>
                <td class="2c">스테이지어스</td>
            </tr>
        </table>
        <button id="btn_update" onclick="moveToDest('infoUpdate.jsp')">정보수정</button>
        <div class="nav_section">팀원목록확인</div>
        <div id="team_member">
            <!-- 팀원 추가 -->
        </div>
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
var memberList=['김기주','지원']
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