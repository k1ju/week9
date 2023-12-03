<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/pwFind.css">
</head>
<body>
    <div id="container">
        <h1 id="title">Time Tree</h1>
        <form class="form"action="../action/pwFindAction.jsp" onsubmit="return pwFindEvent()">
            <input id="input_id" class="input" type="text" placeholder="아이디" name="id_value">
            <input id="input_name" class="input" type="text" placeholder="이름" name="name_value">
            <input id="input_phonenumber" class="input" type="tel" placeholder="연락처" name="phonenumber_value">
            <input id="pwFind_btn" class="Btn" type="submit" value="비밀번호찾기">
        </form>
    </div>
</body>

<script>

function pwFindEvent(){

    var idValue = document.getElementById("input_id").value
    var idRegex = /^[a-zA-Z가-힣][a-zA-Z가-힣0-9]{0,19}$/

    var nameValue = document.getElementById("input_name").value
    var nameRegex = /^[가-힣]{2,4}$/

    var phonenumberValue = document.getElementById("input_phonenumber").value.trim()
    var phonenumberRegex = /^[0-9]{10,11}$/

    if(!idValue || !nameValue || !phonenumberValue ){
        alert("값을 입력하세요")
        return false
    }else if(!(pwRegex.test(pw))){
        console.log("비밀번호 문자,숫자,특수문자 포함 20글자이하")
        return false
    }else if( !nameRegex.test(name) ){
        console.log("이름 한글 2~4글자")
        return false
    }else if(!phonenumberRegex.test(phonenumber)){
        console.log("전화번호 숫자10,11글자")
        return false
    }
}

</script>
</body>
</html>