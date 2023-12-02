<!-- 데이터베이스 탐색라이브러리 -->
<%@ page import="java.sql.DriverManager" %>
<!-- db연결 라이브러리 -->
<%@ page import="java.sql.Connection" %>
<!-- sql전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement" %>
<!-- 데이터받아오기 라이브러리 -->
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>


<!-- 세션없이 접근하는 경우 처리 -->
<!-- 처음부터 일정의 개수만 가져오기 -->

<%
request.setCharacterEncoding("utf-8");

String userIdx = (String)session.getAttribute("userIdx");
String userName = (String)session.getAttribute("userName");
String userPhonenumber = (String)session.getAttribute("userPhonenumber");
String userPosition = (String)session.getAttribute("userPosition");
String userTeam = (String)session.getAttribute("userTeam");
String member = null;
String ownerName = request.getParameter("ownerName");
if(ownerName==null){
    ownerName = userName;
}

ResultSet rs = null;
PreparedStatement query = null;
ResultSet rs2 = null;
PreparedStatement query2 = null;
Connection connect = null;

Calendar calendar = Calendar.getInstance();
String year = request.getParameter("selectYear");
if(year==null){
    year = Integer.toString(calendar.get(Calendar.YEAR));
}
String month = request.getParameter("selectMonth");
if(month==null){
    month = Integer.toString(calendar.get(Calendar.MONTH) + 1);
}
String day = request.getParameter("selectDay");
if(day==null){
    day = Integer.toString(calendar.get(Calendar.DAY_OF_MONTH));
}

ArrayList<ArrayList<String>> scheduleList = new ArrayList<ArrayList<String>>();
ArrayList<String> memberList = new ArrayList<String>();

try{
    if(session.getAttribute("userIdx") == null){
        throw new Exception();
    }
    userIdx = (String)session.getAttribute("userIdx");

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
    // 팀원명단 가져오기sql
    String sql = "SELECT * FROM user WHERE team = (SELECT team FROM user WHERE idx = ?)";
    query = connect.prepareStatement(sql);
    query.setString(1,userIdx);
    rs = query.executeQuery();
    
    while(rs.next()){
        member = rs.getString("name");
        memberList.add("\"" + member + "\"");
    }

    //스케쥴 개수가져오기sql
    String sql2 = "SELECT date FROM schedule s ";
    sql2 += " JOIN user u ON user_idx = u.idx WHERE u.name = ? AND YEAR(date) = ? AND MONTH(date) = ? ";
    
    query2 = connect.prepareStatement(sql2);
    query2.setString(1,ownerName);
    query2.setString(2,year);
    query2.setString(3,month);
    rs2 = query2.executeQuery();
    
    while(rs2.next()){
        ArrayList<String> schedule = new ArrayList<String>();  
        String date = rs2.getString(1);
        schedule.add("\"" + date + "\"");
        scheduleList.add(schedule);
    }

}catch(Exception e){
    response.sendRedirect("index.jsp");
}finally{
    if (rs != null) {
        rs.close();
    }
    if (query != null) {
        query.close();
    }
    if (rs2 != null) {
        rs2.close();
    }
    if (query2 != null) {
        query2.close();
    }
    if (connect != null) {
        connect.close();
    }
}
%>