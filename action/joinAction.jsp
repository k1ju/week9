<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
    String userID = request.getParameter("id_value");
    String userPw = request.getParameter("pw_value");
    String userPwCheck = request.getParameter("pw_check_value");
    String userName = request.getParameter("name_value");
    String userPhonenumber = request.getParameter("phonenumber_value").replaceAll("[^0-9]","");
    String userTeam = request.getParameter("team_value");
    String userPosition = request.getParameter("position_value");
    int errorCode = 1;
//캐치문으로 해결. 매개변수전달로 얼러트로 가능
    if(userID.isEmpty() || userPw.isEmpty() || userPwCheck.isEmpty() || userName.isEmpty() || userPhonenumber.isEmpty() || userTeam.isEmpty() || userPosition.isEmpty()){
        errorCode = 2;
    }else if(userID.trim().length() > 20){
        errorCode = 3;
    }else if(userPw.length() > 20){
        errorCode = 4;
    }else if(userName.length() > 10){
        errorCode = 5;
    }else if(userPhonenumber.length() < 10 || userPhonenumber.length() > 14){
        errorCode = 6;
    }else if(!(userPw.equals(userPwCheck))){
        errorCode = 7;
    }else{

    String dbURL = "jdbc:mysql://localhost/week9";
    String dbID = "stageus";
    String dbPassword = "1234";

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    Connection connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    String sql = "INSERT INTO user(id,pw,name,phonenumber,team,position) VALUES(?,?,?,?,?,?) ";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1,userID);
    query.setString(2,userPw);
    query.setString(3,userName);
    query.setString(4,userPhonenumber);
    query.setString(5,userTeam);
    query.setString(6,userPosition);

    query.executeUpdate();
    }

%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>


<script>
var errorCode = <%=errorCode%>

if(errorCode==1){
    alert("회원가입완료")
    location.href="../page/index.jsp"
}else if(errorCode==2){
    alert("값을 입력해주세요")
}else if(errorCode==3){
    alert("아이디 글자수제한 20글자")
}else if(errorCode==4){
    alert("비밀번호 글자수제한 20글자")
}else if(errorCode==5){
    alert("이름 글자수제한 10글자")
}else if(errorCode==6){
    alert("연락처 글자수제한 10~13글자")
}else if(errorCode==7){
    alert("비밀번호 불일치")
}
location.href = "../page/join.jsp"

</script>
    
</body>
</html>