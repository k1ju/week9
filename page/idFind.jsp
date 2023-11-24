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
        <form action="../action/idFindAction.jsp">
            <div>
                <input id = "name_value" class="input" type="text" placeholder="이름" name="name_value">
            </div>

            <div>
                <input class="input" type="password" placeholder="연락처" name="phonenumber_value">
            </div>
      
                <input id="idFind_btn" class="Btn" type="submit" value="아이디찾기">
        </form>
      
       
        
    </div>

    <script>
        document.getElementById("idFind_btn").addEventListener('click',function(event){

            var nameValue = document.getElementsByName("name_value")[0].value  
            var phonenumberValue = document.getElementsByName("phonenumber_value")[0].value

            if(nameValue.trim()==='' || phonenumberValue.trim()===''){
                event.preventDefault()
                alert("값을 입력하세요")
            } else if(nameValue.length>10){
                event.preventDefault()
                alert("이름 최대 10글자 제한")
            } else if(phonenumberValue.length>13 || phonenumberValue <10){
                event.preventDefault()
                alert("연락처 글자 제한 10~13글자")
            }
        })

        
    </script>
</body>
</html>