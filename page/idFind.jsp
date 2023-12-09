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
        <form class="form"action="../action/idFindAction.jsp" onsubmit="return idFindEvent()">
            <input id="input_name" class="input" type="text" placeholder="이름" name="name_value">
            <input id="input_phonenumber" class="input" type="text" placeholder="연락처" name="phonenumber_value">
            <input  class="Btn" type="submit" value="아이디찾기">
        </form>
    </div>
</body>

<script>
    function idFindEvent(){
        var nameRegex = /^[가-힣]{2,4}$/
        var name = document.getElementById("input_name").value

        var phonenumberRegex = /^[0-9]{10,11}$/
        var phonenumber = document.getElementById("input_phonenumber").value

        if(!name || !phonenumber){
            alert("값을 입력하세요")
            return false
        } else if( !nameRegex.test(name) ){
            console.log("이름 한글 2~4글자")
            return false
        }else if(!phonenumberRegex.test(phonenumber)){
            console.log("전화번호 숫자 10,11글자")
            return false
        }
    }
    
</script>
</body>
</html>