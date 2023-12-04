<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!-- 데이터베이스 탐색라이브러리 -->
<%@ page import="java.sql.DriverManager" %>
<!-- db연결 라이브러리 -->
<%@ page import="java.sql.Connection" %>
<!-- sql전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement" %>
<!-- 데이터받아오기 라이브러리 -->
<%@ page import="java.sql.ResultSet" %>
<%@ page import = "java.util.regex.Pattern"%>

<%
request.setCharacterEncoding("utf-8");


String userIdx = null;
String userName = null;
String userPhonenumber = null; 
String userPosition = null;
String userTeam = null;
String teamNum = null;
String positionNum = null;
String sql = null;

ResultSet rs = null;
PreparedStatement query = null;
PreparedStatement selectQuery = null;
Connection connect = null;

try{
    userIdx = (String)session.getAttribute("userIdx");
    userName = request.getParameter("name_value");
    userPhonenumber = request.getParameter("phonenumber_value").replaceAll("[^0-9]","");
    userPosition = request.getParameter("position_value");
    userTeam = request.getParameter("team_value");

    String userNameRegex = "^[가-힣]{2,4}$";
    String userPhonenumberRegex = "^[0-9]{10,11}$";

    if(!Pattern.matches(userNameRegex,userName)){
        throw new Exception();
    }else if(!Pattern.matches(userPhonenumberRegex,userPhonenumber)){
        throw new Exception();
    }

    if(userPosition.equals("팀장")){
        positionNum = "1";
    }else{
        positionNum = "2";

    }
    if(userTeam.equals("스테이지어스")){
        teamNum = "1";
    }else{
        teamNum = "2";
    }

    if(userIdx == null){
        throw new Exception();
    }

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
    sql = "UPDATE account SET name=?, phonenumber=?, team=?, position=? WHERE idx = ? ";
    query = connect.prepareStatement(sql);
    query.setString(1,userName);
    query.setString(2,userPhonenumber);
    query.setString(3,teamNum);
    query.setString(4,positionNum);
    query.setString(5,userIdx);
    query.executeUpdate();

    //세션초기화
    String selectSql = "SELECT a.idx,name,phonenumber, t.team as team , p.position as position FROM account a ";
    selectSql+= " JOIN team_list t ON a.team = t.idx ";
    selectSql+= " JOIN position_list p ON a.position = p.idx ";
    selectSql+= " WHERE a.idx = ? ";
    selectQuery = connect.prepareStatement(selectSql);

    selectQuery.setString(1,userIdx);
    rs = selectQuery.executeQuery();

    if(rs.next()){
        String idx = rs.getString(1);
        String name = rs.getString(2);
        String phonenumber = rs.getString(3);
        String team = rs.getString(4);
        String position = rs.getString(5);

        session.setAttribute("userIdx",idx);   // 세션은 변수처럼 다른 값으로 초기화할수있다*
        session.setAttribute("userName",name);
        session.setAttribute("userPhonenumber",phonenumber);
        session.setAttribute("userTeam",team);
        session.setAttribute("userPosition",position);
    }

}catch(Exception e){ // 세션없으면 로그인페이지로 이동
    response.sendRedirect("../page/index.jsp");
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
    console.log("<%=userIdx%>")
    console.log("<%=userName%>")
    console.log("<%=userPhonenumber%>")
    console.log("<%=userTeam%>")
    console.log("<%=userPosition%>")


    console.log('<%=session.getAttribute("userIdx")%>')
    console.log('<%=session.getAttribute("userName")%>')
    console.log('<%=session.getAttribute("userPhonenumber")%>')
    console.log('<%=session.getAttribute("userTeam")%>')
    console.log('<%=session.getAttribute("userPosition")%>')
    console.log("<%=sql%>")

    location.href="../page/infoUpdate.jsp"
</script>
</body>
</html>