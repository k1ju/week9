<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import = "java.util.regex.Pattern"%>

<%
Connection connect = null;
PreparedStatement query = null;
ResultSet rs = null;

String userID = null;
String userName = null;
String userPhonenumber = null;
String userPw = null;

try{
    userID = request.getParameter("id_value");
    String userIDRegex = "^[a-zA-Z가-힣][a-zA-Z가-힣0-9]{0,19}$";

    userName = request.getParameter("name_value");
    String userNameRegex = "^[가-힣]{2,4}$";

    userPhonenumber = request.getParameter("phonenumber_value");
    String userPhonenumberRegex = "^[0-9]{10,11}$";

    if(!Pattern.matches(userIDRegex,userID)){
        throw new Exception();
    }else if(!Pattern.matches(userName,userName)){
        throw new Exception();
    }else if(!Pattern.matches(userPhonenumber,userPhonenumber)){
        throw new Exception();
    }

    String dbURL = "jdbc:mysql://localhost/week9";
    String dbID = "stageus";
    String dbPassword = "1234";
    String sql = "SELECT pw FROM account WHERE id = ? AND name = ? AND phonenumber = ? ";
    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    query = connect.prepareStatement(sql);

    query.setString(1,userID);
    query.setString(2,userName);
    query.setString(3,userPhonenumber);
    rs = query.executeQuery();
    
    if(rs.next()){
        userPw = rs.getString(1);
    }

}catch(Exception e){
    //response.sendRedirect("../page/pwFind.jsp");
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
        console.log("<%=userPw%>")

        if("<%=userPw%>" == "null"){
            alert("일치하는 회원정보없음")
            location.href="../page/pwFind.jsp"
        }else{
            alert("회원님의 비밀번호는"+ "<%=userPw%>")
            location.href="../page/index.jsp"
        }


    </script>
</body>
</html>