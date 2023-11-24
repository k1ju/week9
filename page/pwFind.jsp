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
        <form action="../action/pwFindAction.jsp">
            <div>
                <input id = "input_id" class="input" type="text" placeholder="아이디" name="id_value">
            </div>
            <div>
                <input id = "input_name" class="input" type="text" placeholder="이름" name="name_value">
            </div>

            <div>
                <input id = "input_phonenumber" class="input" type="tel" placeholder="연락처" name="phonenumber_value">
            </div>
      
            <input id="pwFind_btn" class="Btn" type="submit" value="비밀번호찾기">
        </form>
      
    </div>

    <script>
        document.getElementById("pwFind_btn").addEventListener('click',function(event){
            var idValue = document.getElementsByName("id_value")[0].value
            var nameValue = document.getElementsByName("name_value")[0].value  
            var phonenumberValue = document.getElementsByName("phonenumber_value")[0].value
            


            if(idValue.trim()==='' || nameValue.trim()==='' || phonenumberValue.trim()===''){
                event.preventDefault()
                alert("값을 입력하세요")
            }else if(nameValue.length>10){
                event.preventDefault()
                alert("이름 최대 10글자 제한")
            }else if(phonenumberValue.length>13 || phonenumberValue.length <10){
                event.preventDefault()
                alert("연락처 글자 제한 10~13글자")
                // 특수문자제거
            }
        })

    </script>
</body>
</html>