<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!-- 데이터베이스 탐색라이브러리 -->
<%@ page import="java.sql.DriverManager" %>
<!-- db연결 라이브러리 -->
<%@ page import="java.sql.Connection" %>
<!-- sql전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.List"%>

<%
request.setCharacterEncoding("utf-8");

String userIdx = null;
String writerIdx = null;
String articleIdx = null;
String sql = null;


PreparedStatement query = null;
Connection connect = null;

try{
    userIdx = (String)session.getAttribute("userIdx");
    writerIdx = request.getParameter("writer_idx_value");
    articleIdx = request.getParameter("article_idx_value");
    if(userIdx == null){
        throw new Exception();
    }

    if(userIdx.equals(writerIdx)){
        Class.forName("com.mysql.jdbc.Driver"); //db연결
        connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
        sql = "DELETE FROM schedule WHERE user_idx = ? AND idx = ? ";
        query = connect.prepareStatement(sql);
        query.setString(1,userIdx);
        query.setString(2,articleIdx);

        query.executeUpdate();
    }
  
}catch(Exception e){ // 세션없으면 로그인페이지로 이동
    //response.sendRedirect("../page/index.jsp");
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

    console.log("유저의 idx","<%=userIdx%>")
    console.log("글쓴이의 idx","<%=writerIdx%>")
    console.log("일정의 idx","<%=articleIdx%>")
    console.log("<%=sql%>")

    location.href = document.referrer // 이전페이지의 url*

</script>
</body>
</html>