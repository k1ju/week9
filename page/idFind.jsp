<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/idFind.css">

</head>
<body>
    <div id="container">
        <h1 id="title">Time Tree</h1>
        <form action="../action/idFindAction.jsp" onsubmit="return idFindEvent()">
            <input id="name_value" class="input" type="text" placeholder="이름" name="name_value">
            <input id="phonenumber_value" class="input" type="text" placeholder="연락처" name="phonenumber_value">
            <input id="idFind_btn" class="Btn" type="submit" value="아이디찾기">
        </form>
    </div>
</body>

<script>
function idFindEvent(){
    var nameValue = document.getElementById("name_value").value.replace(/ /g,"")
    var phonenumberValue = document.getElementById("phonenumber_value").value.replace(/[^0-9]/g,"")
    console.log(nameValue)
    console.log(phonenumberValue)

    if(nameValue==="" || phonenumberValue===""){
        alert("값을 입력하세요")
        return false
    } else if(nameValue.length>10){
        alert("이름 최대 10글자 제한")
        return false
    } else if(phonenumberValue.length>13 || phonenumberValue <10){
        alert("연락처 글자 제한 10~13글자")
        return false
    }
}
    
</script>
</body>
</html>