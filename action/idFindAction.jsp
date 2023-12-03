<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import = "java.util.regex.Pattern"%>

<%
String userName = null;
String userPhonenumber = null;
String userID = null;

String userNameRegex = null;
String userPhonenumberRegex = null;
ResultSet rs = null;
PreparedStatement query = null;
Connection connect = null;

try{
    userNameRegex = "^[가-힣]{2,4}$";
    userName = request.getParameter("name_value");

    userPhonenumberRegex = "^[0-9]{10,11}$";
    userPhonenumber = request.getParameter("phonenumber_value").replaceAll("[^0-9]","");

    if(!Pattern.matches(userNameRegex,userName)){
        throw new Exception();
    }else if(!Pattern.matches(userPhonenumberRegex,userPhonenumber)){
        throw new Exception();
    }

    String dbURL = "jdbc:mysql://localhost/week9";
    String dbID = "stageus";
    String dbPassword = "1234";
    String sql = "SELECT id FROM account WHERE name = ? AND phonenumber = ? ";

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    query = connect.prepareStatement(sql);
    query.setString(1,userName);
    query.setString(2,userPhonenumber);
    rs = query.executeQuery();

    if(rs.next()){
        userID = rs.getString(1);
    }

    
}catch(Exception e){
    response.sendRedirect("../page/idFind.jsp");
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

        if("<%=userID%>" == "null"){
            alert("일치하는 회원정보없음")
            location.href="../page/idFind.jsp"

        }else{
            alert("회원님의 아이디는" + "<%=userID%>")
            location.href="../page/index.jsp"
        }
    </script>
</body>
</html>