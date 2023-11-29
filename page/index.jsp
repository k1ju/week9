<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/login.css">

</head>
<body>
    <div id="container">
        <h1 id="title">Time Tree</h1>
        <form action="schedule.jsp" onsubmit="return checkEvent()">
            <input class="input" id="input_id" type="text" placeholder="ID" name="id_value">
            <input class="input" id="input_pw" type="password" placeholder="PASSWORD" name="pw_value">
            <input id="login_btn" class="Btn" type="submit" value="로그인">
        </form>
        <button id="join_btn" class="Btn" onclick="moveToDest('join.jsp')" >회원가입</button>
        <div id="find_btn_box">
            <button id="id_button" onclick="moveToDest('idFind.jsp')">아이디찾기</button>
            <button id="pw_button" onclick="moveToDest('pwFind.jsp')">비밀번호찾기</button>
        </div>
    </div>

<script>
    function moveToDest(e){
        console.log("클릭")
        location.href=e
    }

    function checkEvent(){
        id = document.getElementById("input_id").value
        pw = document.getElementById("input_pw").value

        console.log("로그인 검사시작")

        if(!id || !pw){ //
            console.log("하나라도 빈값이라면")
            alert("값을 입력해주세요")
            return false
        }
        else if(id.length>20){
            alert("아이디 글자수제한 20글자")
            return false
        }else if(pw.length>20){
            alert("비밀번호 글자수제한 20글자")
            return false
        }
    }
</script>
</body>
</html>