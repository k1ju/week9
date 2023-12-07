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
String date = null;
String time = null;
String dateTime =null;
String content = null;
String executionStatus = null;
String articleIdx = null;
String ownerIdx = null;
String sql = null;

String[] array = {"2023-12-02 18:00", "스테이지어스 12월 마지막수업", "0", "9", "13"};
//날짜,내용,수행여부,일정idx,글쓴이idx
List<String> myList = Arrays.asList(array);

PreparedStatement query = null;
Connection connect = null;

try{
    userIdx = (String)session.getAttribute("userIdx");
    ownerIdx = request.getParameter("owner_idx_value");
    articleIdx = request.getParameter("article_idx_value");
    date = request.getParameter("date_value");
    time = request.getParameter("time_value");
    dateTime = date + " " + time;
    content = request.getParameter("content_value");
    executionStatus = 

    if(userIdx == null){
        throw new Exception();
    }

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
    sql = "UPDATE schedule SET date = ?, content = ?, execution_status = ? WHERE idx = ? AND user_idx = ?  ";
    query = connect.prepareStatement(sql);
    query.setString(1,dateTime);
    //날짜 형식에 맞게 잘 입력하기
    query.setString(2,content);
    query.setString(3,executionStatus);
    query.setString(4,articleIdx);
    query.setString(5,userIdx);

    query.executeUpdate();
  
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
    console.log("글쓴이의 idx","<%=ownerIdx%>")
    console.log("일정의 idx","<%=articleIdx%>")
    console.log("날짜","<%=date%>")
    console.log("시간","<%=time%>")

    console.log("<%=dateTime%>" )
    console.log("내용:","<%=content%>")


    console.log("<%=sql%>")

    location.href = document.referrer // 이전페이지의 url*

</script>
</body>
</html>