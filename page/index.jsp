<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%
//세션갖고 로그인창 접근금지
String userIdx = (String)session.getAttribute("userIdx");

if(userIdx != null){
    response.sendRedirect("schedule.jsp");
}
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/index.css">

</head>
<body>
    <div id="container">
        <h1 id="title">Time Tree</h1>
        <form action="../action/loginAction.jsp" onsubmit="return checkEvent()">
            <input class="input" id="input_id" type="text" placeholder="ID" name="id_value">
            <input class="input" id="input_pw" type="password" placeholder="PASSWORD" name="pw_value">
            <input id="login_btn"  type="submit" value="로그인">
        </form>
        <button id="join_btn" class="Btn" onclick="moveToDestEvent('join.jsp')" >회원가입</button>
        <div id="find_btn_box">
            <button id="id_button" onclick="moveToDestEvent('idFind.jsp')">아이디찾기</button>
            <button id="pw_button" onclick="moveToDestEvent('pwFind.jsp')">비밀번호찾기</button>
        </div>
    </div>
</body>

<script>
    function moveToDestEvent(e){ //함수"이벤트"쓰기, 매개변수이름변경
        location.href=e
    }

    function checkEvent(){
        var idRegex = /^[a-zA-Z가-힣][a-zA-Z가-힣0-9]{0,19}$/
        var id = document.getElementById("input_id").value

        var pwRegex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{1,20}$/
        var pw = document.getElementById("input_pw").value

        if(!id || !pw){ 
            alert("값을 입력해주세요")
            return false
        }else if(!idRegex.test(id)){
            alert("아이디 글자수제한 20글자")
            return false
        }
        //else if(!pwRegex.test(pw)){
            //alert("비밀번호 문자,숫자,특수문자포함 20글자이하")
            //return false
        //}

        console.log(id)
        console.log(pw)
    }
</script>
</body>
</html>