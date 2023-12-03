<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import = "java.util.regex.Pattern"%>

<%
// 자바에서 문자열은 큰따옴표만"", 문자열 비교는 equals()

String userID = null;
String userPw = null;
String sql = null;

ResultSet rs = null;
PreparedStatement query = null;
Connection connect = null;
try{

    //정규표현식
    userID = request.getParameter("id_value");
    String userIDRegex = "^[a-zA-Z가-힣][a-zA-Z가-힣0-9]{0,19}$";

    userPw = request.getParameter("pw_value");
    //String userPwRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{1,20})$";

    if(!Pattern.matches(userIDRegex,userID)){
        throw new Exception();
    }
    //else if(!Pattern.matches(userName,userName)){
        //throw new Exception();
    //}

    String dbURL = "jdbc:mysql://localhost/week9";
    String dbID = "stageus";
    String dbPassword = "1234";
    sql = "SELECT a.idx,name,phonenumber, t.team as team , p.position as position FROM account a ";
    sql+= " JOIN team_list t ON a.team = t.idx ";
    sql+= " JOIN position_list p ON a.position = p.idx ";
    sql+= " WHERE id = ? AND pw = ? ";

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    query = connect.prepareStatement(sql);
    query.setString(1,userID);
    query.setString(2,userPw);
    rs = query.executeQuery();

    if(rs.next()){
        //필요한건 세션저장 ㄱㄱ
        String userIdx = rs.getString(1);
        String userName = rs.getString(2);
        String userPhonenumber = rs.getString(3);
        String userTeam = rs.getString(4);
        String userPosition = rs.getString(5);

        session.setAttribute("userIdx",userIdx);
        session.setAttribute("userName",userName);
        session.setAttribute("userPhonenumber",userPhonenumber);
        session.setAttribute("userTeam",userTeam);
        session.setAttribute("userPosition",userPosition);

        response.sendRedirect("../page/schedule.jsp");
    }
}catch(Exception e){
    //response.sendRedirect("../page/index.jsp");
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
    console.log("<%=userID%>")
    console.log("<%=userPw%>")


    console.log("<%=sql%>")
    console.log('<%=session.getAttribute("userIdx")%>')
    console.log('<%=session.getAttribute("userName")%>')
    console.log('<%=session.getAttribute("userPhonenumber")%>')
    console.log('<%=session.getAttribute("userPosition")%>')
    console.log('<%=session.getAttribute("userTeam")%>')


    alert("일치하는 회원정보 없음")
    location.href="../page/index.jsp"

</script>
</body>