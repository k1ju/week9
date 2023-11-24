<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/CSS" href="../css/infoUpdate.css">

</head>
<body>

    <header>
        <h1 onclick="moveToDest('schedule.jsp')">Time Tree</h1>
        <div id="current_date"></div>
        <button id="btn_menu">
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
            <div class="member">김기주</div>
            <div class="member">김기주</div>

        </div>
    </nav>

    <main>
        <div id="main_title">정보수정</div>

        <div id="info_box">
            <table id="info_table">
                <tr class="row">
                    <td class="c1">
                        이름: 
                    </td>
                    <td>
                        <input class="input" type="text" value="김기주">
                    </td>
                </tr>
                <tr class="row">
                    <td class="c1">
                        연락처:
                    </td>
                    <td>
                        <input class="input" type="text" value="010-0000-0000">
                    </td>
                </tr>
                <tr class="row">
                    <td class="c1">
                        직급:
                    </td>
                    <td>
                        <input type="radio" name="position_value" checked>팀원
                        <input type="radio" name="position_value">팀장
                    </td>
                </tr>
                <tr class="row">
                    <td class="c1">
                        부서:
                    </td>
                    <td>
                        <input type="radio" name="team_value" checked>스테이지어스
                        <input type="radio" name="team_value">네이버
                    </td>
                </tr>
            </table>
            <button id="updateBtn" onclick="moveToDest()">수정확인</button>

        </div>
    </main>

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

// 슬라이드바 토글
menuBtn.addEventListener('click',function(){
if(nav.style.right == "-304px"){
    nav.style.right = "0"
}else{
    nav.style.right="-304px"
}
})

</script>
</body>
</html>