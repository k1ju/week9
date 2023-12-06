<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import = "java.util.regex.Pattern"%>

<%
String userID = null;
String userPw = null;
String userPwCheck = null;
String userName = null;
String userPhonenumber = null;
String userTeam = null;
String userPosition = null;
String sql = null;
String err =null;
Connection connect = null;
PreparedStatement query = null;

try{
    userID = request.getParameter("id_value");
    String userIDRegex = "^[a-zA-Z가-힣][a-zA-Z가-힣0-9]{0,19}$";

    userPw = request.getParameter("pw_value");
    userPwCheck = request.getParameter("pw_check_value");
    String userPwRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{1,20}$";

    userName = request.getParameter("name_value");
    String userNameRegex = "^[가-힣]{2,4}$";

    userPhonenumber = request.getParameter("phonenumber_value").replaceAll("[^0-9]","");
    String userPhonenumberRegex = "^[0-9]{10,11}$";

    userTeam = request.getParameter("team_value");
    userPosition = request.getParameter("position_value");

    if(userTeam.equals("스테이지어스")){
        userTeam = "1";
    }else{
        userTeam = "2";
    }
    if(userPosition.equals("팀장")){
        userPosition = "1";
    }else{
        userPosition = "2";
    }

    if(!Pattern.matches(userIDRegex,userID)){
        err="id안맞음";
        throw new Exception();
    }else if(!Pattern.matches(userPwRegex,userPw)){
        err="pw안맞음";
        throw new Exception();
    }else if(!Pattern.matches(userNameRegex,userName)){
        err="name안맞음";
        throw new Exception();
    }else if(!Pattern.matches(userPhonenumberRegex,userPhonenumber)){
        err="phonenumber안맞음";
        throw new Exception();
    }

    String dbURL = "jdbc:mysql://localhost/week9";
    String dbID = "stageus";
    String dbPassword = "1234";

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    sql = "INSERT INTO account(id,pw,name,phonenumber,team,position) VALUES(?,?,?,?,?,?) ";
    query = connect.prepareStatement(sql);
    query.setString(1,userID);
    query.setString(2,userPw);
    query.setString(3,userName);
    query.setString(4,userPhonenumber);
    query.setString(5,userTeam);
    query.setString(6,userPosition);

    query.executeUpdate();
}catch(Exception e){
    response.sendRedirect("../page/join.jsp");
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

alert("회원가입완료")
console.log("<%=userID%>")
console.log("<%=userPw%>")
console.log("<%=userPwCheck%>")
console.log("<%=userName%>")
console.log("<%=userPhonenumber%>")
console.log("<%=userTeam%>")
console.log("<%=userPosition%>")

console.log("<%=err%>")
console.log("<%=sql%>")

location.href = "../page/index.jsp"

</script>
    
</body>
</html>