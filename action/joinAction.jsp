<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import = "java.util.regex.Pattern"%>

<%
String userID = null;
String userPw = null;
String userName = null;
String userPhonenumber = null;

Connection connect = null;
PreparedStatement query = null;

try{
    userID = request.getParameter("id_value");
    String userIDRegex = "^[a-zA-Z가-힣][a-zA-Z가-힣0-9]{0,19}$""

    userPw = request.getParameter("name_value");
    String userPwRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{1,20})$"

    userName = request.getParameter("name_value");
    String userNameRegex = "^[가-힣]{2,4}$";

    userPhonenumber = request.getParameter("phonenumber_value").replaceAll("[^0-9]","");
    String userPhonenumberRegex = "^[0-9]{10,11}$";


    if(!Pattern.matches(userIDRegex,userID)){
        throw new Exception();
    }else if(!Pattern.matches(userPwRegex,userPw)){
        throw new Exception();
    }else if(!Pattern.matches(userNameRegex,userName)){
        throw new Exception();
    }else if(!Pattern.matches(userPhonenumberRegex,userPhonenumber)){
        throw new Exception();
    }

    String dbURL = "jdbc:mysql://localhost/week9";
    String dbID = "stageus";
    String dbPassword = "1234";

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    String sql = "INSERT INTO account(id,pw,name,phonenumber,team,position) VALUES(?,?,?,?,?,?) ";
    query = connect.prepareStatement(sql);
    query.setString(1,userID);
    query.setString(2,userPw);
    query.setString(3,userName);
    query.setString(4,userPhonenumber);
    query.setString(5,userTeam);
    query.setString(6,userPosition);

    query.executeUpdate();
}catch(Exception e){
    response.sendRedirect(../page/join.jsp)
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

alert("회원가입완료")
location.href = "../page/index.jsp"

</script>
    
</body>
</html>