<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!-- 데이터베이스 탐색라이브러리 -->
<%@ page import="java.sql.DriverManager" %>
<!-- db연결 라이브러리 -->
<%@ page import="java.sql.Connection" %>
<!-- sql전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement" %>

<%
request.setCharacterEncoding("utf-8");


String userIdx = null;
String date = null;
String time = null;
String dateTime =null;
String content = null;

String sql = null;

PreparedStatement query = null;
Connection connect = null;

try{
    userIdx = (String)session.getAttribute("userIdx");
    time = request.getParameter("time_value");
    content = request.getParameter("content_value");
    date = request.getParameter("date_value");
    dateTime = date + " " + time;

    if(userIdx == null){
        throw new Exception();
    }

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
    sql = "INSERT INTO schedule(date,content,user_idx) VALUES(?,?,?) ";
    query = connect.prepareStatement(sql);
    query.setString(1,dateTime);
    query.setString(2,content);
    query.setString(3,userIdx);
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

    console.log("<%=userIdx%>")
    console.log("<%=dateTime%>" )
    console.log("<%=content%>")

    console.log("<%=sql%>")

    location.href = document.referrer // 이전페이지의 url*

</script>
</body>
</html>