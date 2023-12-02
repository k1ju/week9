<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%

String userName = request.getParameter("name_value");
String userPhonenumber = request.getParameter("phonenumber_value");
String userID = null;
ResultSet rs = null;
PreparedStatement query = null;
Connection connect = null;

try{
    if(userName.equals("") || userPhonenumber.equals("")){
        throw new Exception();
    }
    userName = userName.trim();
    userPhonenumber = userPhonenumber.replaceAll("[^0-9]","");
    
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

        var userID = "<%=userID%>"

        if("<%=userID%>" != ""){
            alert("회원님의 아이디는"+ userID)
            location.href="../page/idFind.jsp"
        }else{
            alert("일치하는 회원정보없음")
            location.href="../page/idFind.jsp"
        }
    </script>
</body>
</html>