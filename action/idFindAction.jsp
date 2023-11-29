<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%


String userName = request.getParameter("name_value");
String userPhonenumber = request.getParameter("phonenumber_value");
String userID = null;

String err = "";
String sql = "SELECT id FROM user WHERE name = ? AND phonenumber = ? ";
String dbURL = "jdbc:mysql://localhost/week9";
String dbID = "stageus";
String dbPassword = "1234";

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
    //err = "빈문자열입니다";
}catch(Exception e){
    response.sendRedirect("../page/idFind.jsp");
}finally{

    //이부분 수정하기,리소스닫기
    //rs.close();
    //query.close();
    //connect.close();
}

%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
    <script>
        if(<%=userID%> == true){
            alert("회원님의 아이디는"+ "<%=userID%>")
        location.href="../page/idFind.jsp"
        }else{
            alert("일치하는 회원정보없음")
            location.href="../page/idFind.jsp"
        }
    </script>
</body>
</html>