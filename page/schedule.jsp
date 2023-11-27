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

<!-- 모달 -->
<!-- 제목: 선택날짜
내용: 선택날짜 일정 -->
    <section id="modal">
        <div id="modal_body">
            <button id="close_modal">X</button>
            <h2>모달창 제목</h2> 
            <div id="modal_content">
                <!-- 일정추가 -->
            </div>
            <form id="insert_plan">
                <input id="plan_time" type="time">
                <!-- 시간 다이얼식으로 변경 -->
                <input id = "input_plan" type="text">
                <button id="btn_insert">확인</button>
            </form>
        </div>
    </section>

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

//모달 변수
var modal = document.getElementById("modal")
var closeModalBtn = document.getElementById("close_modal")
var modalContent = document.getElementById("modal_content")
var scheduleStatusList = document.getElementsByClassName("schedule_status")
var schedulePlanList = document.getElementsByClassName("schedule_plan")
var modalDeleteBtnList = document.getElementsByClassName("modal__btn_delete")
var modalUpdateBtnList = document.getElementsByClassName("modal__btn_update")
var modalConfirmBtnList = document.getElementsByClassName("modal__btn_confirm")
var schedulePlanUpdate = document.getElementById("schedule_plan_update")
var scheduleTimeUpdate = document.getElementById("schedule_time_update")

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
MakeArticle(5)
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
    console.log("클릭")
    modal.style.display = "block"
    document.getElementsByTagName("body")[0].style.overflow="hidden"
    if(document.getElementsByTagName("article").length>4){
        console.log(document.getElementById("modal_content"))
        document.getElementById("modal_content").style.overflow="scroll"
    }
}

// 리스트준비해서 받아오기
//모달내 일정생성하기
function MakeArticle(e){
    for(var i=0;i< e;i++){
        var article = document.createElement("article")
        var checkbox = document.createElement("input")
        var scheduleTime = document.createElement("div")
        var schedulePlan = document.createElement("div")
        var updateBtn = document.createElement("button")
        var deleteBtn = document.createElement("button")
        var scheduleTimeUpdate = document.createElement("input")
        var schedulePlanUpdate = document.createElement("input")
        var confirmBtn = document.createElement("button")

        checkbox.classList.add("schedule_status")
        checkbox.type="checkbox"
        checkbox.id= "checkbox" + i

        scheduleTime.innerHTML="12:00" // 일정시간
        scheduleTime.id = "schedule_time" + i

        schedulePlan.classList.add("schedule_plan")
        schedulePlan.innerHTML="스테이지어스가기"+i //일정
        schedulePlan.id="plan" + i

        updateBtn.classList.add("schedule_btn")
        updateBtn.classList.add("modal__btn_update")
        updateBtn.innerHTML="수정"
        updateBtn.id = "update_btn"+i

        deleteBtn.classList.add("schedule_btn")
        deleteBtn.classList.add("modal__btn_delete") 
        deleteBtn.innerHTML="삭제"
        deleteBtn.id = "delete_btn"+i

        scheduleTimeUpdate.type="time"
        scheduleTimeUpdate.id = "schedule_time_update"+i

        schedulePlanUpdate.type="text"
        schedulePlanUpdate.value="스테이지어스"
        schedulePlanUpdate.id = "schedule_plan_update"+i

        confirmBtn.classList.add("schedule_btn")
        confirmBtn.classList.add("modal__btn_confirm")
        confirmBtn.innerHTML="확인"
        confirmBtn.id="confirm_btn"+i

        scheduleTimeUpdate.style.display="none"
        schedulePlanUpdate.style.display="none"
        confirmBtn.style.display="none"

        article.appendChild(checkbox)
        article.appendChild(scheduleTime)
        article.appendChild(schedulePlan)
        article.appendChild(scheduleTimeUpdate)
        article.appendChild(schedulePlanUpdate)
        article.appendChild(updateBtn)
        article.appendChild(deleteBtn)
        article.appendChild(confirmBtn)
        modalContent.appendChild(article)
    }
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
//모달 닫기 이벤트
closeModalBtn.addEventListener('click',function(){
    modal.style.display = "none"
    document.getElementsByTagName("body")[0].style.overflow="auto"
})
function closeModalEvent(e){
    
}


//모든 버튼 모달안에서 생성시 이벤트넣어주기
//onclick으로 바꿔서 쓰기. addevent X
// 취소선 이벤트
for(var i=0;i<scheduleStatusList.length;i++){
    (function(index) {
        scheduleStatusList[index].addEventListener('change',function(){ // 정리
            if(scheduleStatusList[index].checked == true){
                schedulePlanList[index].classList.add("schedule_cancel")
                console.log(schedulePlanList[index])
                console.log("취소선표시")

            }else{
                schedulePlanList[index].classList.remove("schedule_cancel")
                console.log(schedulePlanList[index])
                console.log("취소선해제")
            }
        })
    })(i)
}
//삭제버튼 이벤트
for(var i=0;i< modalDeleteBtnList.length;i++){
    (function(index){
        modalDeleteBtnList[index].addEventListener('click',function(){
            if (confirm('일정을 삭제하시겠습니까?') == true){
                alert("삭제되었습니다")
                // location.href = "scheduleDeleteAction.jsp"
            }else{
                return
            }
        })
    })(i)
}
//수정버튼 이벤트
for(var i=0;i< modalUpdateBtnList.length;i++){
    (function (index) {
        modalUpdateBtnList[index].addEventListener('click',function(){

            document.getElementById("schedule_time_update"+index).style.display="inline"
            document.getElementById("schedule_plan_update"+index).style.display="inline"
            document.getElementById("confirm_btn"+index).style.display="inline"
            document.getElementById('checkbox'+index).style.display="none"
            document.getElementById('schedule_time'+index).style.display="none"
            document.getElementById('plan'+index).style.display="none"
            document.getElementById('update_btn'+index).style.display="none"
            document.getElementById('delete_btn'+index).style.display="none"
        
        })
    })(i)
}
//확인버튼 이벤트
for(var i=0;i<modalConfirmBtnList.length;i++){
    (function(index){
        modalConfirmBtnList[index].addEventListener('click',function(){
            console.log("클릭")
            document.getElementById("schedule_time_update"+index).style.display="none"
            document.getElementById("schedule_plan_update"+index).style.display="none"
            document.getElementById("confirm_btn"+index).style.display="none"

            document.getElementById('checkbox'+index).style.display="inline"
            document.getElementById('schedule_time'+index).style.display="inline"
            document.getElementById('plan'+index).style.display="inline"
            document.getElementById('update_btn'+index).style.display="inline"
            document.getElementById('delete_btn'+index).style.display="inline"

            // location.href = "scheduleUpdateAction.jsp"
        })
    })(i)
}








</script>

</body>
</html>