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
        <form action="schedule.jsp">
            <div>
                <input class="input" type="text" placeholder="ID" name="id_value">
            </div>

            <div>
                <input class="input" type="password" placeholder="PASSWORD" name="pw_value">
            </div>
      
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
    </script>
</body>
</html>