<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!-- 데이터베이스 탐색라이브러리 -->
<%@ page import="java.sql.DriverManager" %>
<!-- db연결 라이브러리 -->
<%@ page import="java.sql.Connection" %>
<!-- sql전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement" %>

<%
request.setCharacterEncoding("utf-8");

PreparedStatement query = null;
Connection connect = null;
String userIdx = null;
String userName = request.getParameter("name_value");
String userPhonenumber = request.getParameter("phonenumber_value");
String userPosition = request.getParameter("position_value");
String userTeam = request.getParameter("team_value");
try{
//if문 널이면 이동,else노필요
    if(session.getAttribute("userIdx") == null){
        throw new Exception();
    }
    userIdx = (String)session.getAttribute("userIdx");

    if( userName.trim().isEmpty() || userPhonenumber.trim().isEmpty() || userTeam.isEmpty() || userPosition.isEmpty()){
        throw new Exception();
    }
    userName = userName.trim();
    userPhonenumber = userPhonenumber.replaceAll("[^0-9]","");

    if(userName.length() > 10){
        throw new Exception();
    }else if(userPhonenumber.length() > 13 || userPhonenumber.length() < 10 ){
        throw new Exception();
    }

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
    String sql = "UPDATE user SET name=?, phonenumber=?, team=?, position=? WHERE idx = ? ";
    query = connect.prepareStatement(sql);
    query.setString(1,userName);
    query.setString(2,userPhonenumber);
    query.setString(3,userTeam);
    query.setString(4,userPosition);
    query.setString(5,userIdx);
    query.executeUpdate();
}catch(Exception e){ // 세션없으면 로그인페이지로 이동
    response.sendRedirect("../page/index.jsp");
}finally{
    if (query != null) {
        query.close();
    }
    if (connect != null) {
        connect.close();
    }
}
%>


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
    <script>

        alert("수정완료")
        location.href="../page/infoUpdate.jsp"
    </script>
</body>
</html>