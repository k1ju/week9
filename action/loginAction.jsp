<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%

String userID = request.getParameter("id_value");
String userPw = request.getParameter("pw_value");
String errMessage = null;
try{
    if(userID.equals("") || userPw.equals("")){
        throw new NullPointerException();
    }else{
        userID = userName.trim();
        userPw = userPhonenumber.trim();
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
    Connection connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1,userID);
    query.setString(2,userPw);
    ResultSet rs = query.executeQuery();

    if(rs.next()){
        userIdx = rs.getstring(1);
        session.setAttribute("userIdx",userIdx)
        response.sendRedirect("../page/schedule.jsp")

    }else{
        throw new Exception();
    }

    rs.close();
    query.close();
    connect.close();

}catch(NullPointerException e){ // 널포인터에러 발생시
    response.sendRedirect("../page/index.jsp");
    rs.close();
    query.close();
    connect.close();
}catch(Exception e){
    response.sendRedirect("../page/index.jsp");
    rs.close();
    query.close();
    connect.close();
}
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
<script>
    alert("로그인실패")
    location.href="../page/login.jsp"


</script>
</body>
</html>