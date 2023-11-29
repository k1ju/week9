<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%

String userID = request.getParameter("id_value");
String userPw = request.getParameter("pw_value");

try{
    if(userName.equals("") || userPhonenumber.equals("")){
        throw new NullPointerException();
    }else{
        userName = userName.trim();
        userPhonenumber = userPhonenumber.replaceAll("[^0-9]","");
    }
    if(userName.length() > 10){
        throw new Exception();
    }else if(userPhonenumber.length() > 13 || userPhonenumber.length() < 10){
        throw new Exception();
    }

    String dbURL = "jdbc:mysql://localhost/week9";
    String dbID = "stageus";
    String dbPassword = "1234";
    String sql = "SELECT id FROM user WHERE name = ? AND phonenumber = ? ";

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    Connection connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1,userName);
    query.setString(2,userPhonenumber);
    ResultSet rs = query.executeQuery();

    if(rs.next()){
        userID = rs.getString(1);
    }

    rs.close();
    query.close();
    connect.close();

}catch(NullPointerException e){ // 널포인터에러 발생시
    response.sendRedirect("../page/idFind.jsp");
    rs.close();
    query.close();
    connect.close();
}catch(Exception e){
    response.sendRedirect("../page/idFind.jsp");
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


    </script>
</body>
</html>