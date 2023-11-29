<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%

String userID = request.getParameter("id_value");
String userPw = request.getParameter("pw_value");
ResultSet rs = null;
PreparedStatement query = null;
Connection connect = null;

try{
    if(userID.equals("") || userPw.equals("")){
        throw new NullPointerException();
    }else{
        userID = userID.trim();
        userPw = userPw.trim();
    }
    if(userID.length()>20){
        throw new Exception();
    }else if(userPw.length()>20){
        throw new Exception();
    }

    String dbURL = "jdbc:mysql://localhost/week9";
    String dbID = "stageus";
    String dbPassword = "1234";
    String sql = "SELECT * FROM user WHERE id = ? AND pw = ? ";

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    query = connect.prepareStatement(sql);
    query.setString(1,userID);
    query.setString(2,userPw);
    rs = query.executeQuery();

    if(rs.next()){
        String userIdx = rs.getString(1);
        session.setAttribute("userIdx",userIdx);
        response.sendRedirect("../page/schedule.jsp");
    }

}catch(NullPointerException e){ // 널포인터에러 발생시
    response.sendRedirect("../page/index.jsp");
}catch(Exception e){
    response.sendRedirect("../page/index.jsp");
}finally{
    if (rs != null) {
        rs.close();
    }
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
    var session = "<%=session.getAttribute('userIdx')%>"
    console.log(session)

    alert("일치하는 회원정보 없음")
    // location.href="../page/index.jsp"


</script>
</body>
</html>