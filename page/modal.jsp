<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!-- 데이터베이스 탐색라이브러리 -->
<%@ page import="java.sql.DriverManager" %>
<!-- db연결 라이브러리 -->
<%@ page import="java.sql.Connection" %>
<!-- sql전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement" %>
<!-- 데이터받아오기 라이브러리 -->
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.SQLException" %>;
<%

ResultSet rs = null;
PreparedStatement query = null;
ResultSet rs2 = null;
PreparedStatement query2 = null;
Connection connect = null;
String sql = null;
String sql2 = null;
String userIdx = null;
String userName = null;
String ownerIdx = null;
String ownerName = null;
String ownerPhonenumber = null;
String year = null;
String month = null;
String day = null;
ArrayList<ArrayList<String>> scheduleList = new ArrayList<ArrayList<String>>();

try{
    userIdx = (String)session.getAttribute("userIdx");
    userName = (String)session.getAttribute("userName");
    ownerName = request.getParameter("ownerName");
    ownerPhonenumber = request.getParameter("ownerPhonenumber");
    year = request.getParameter("selectYear");
    month = request.getParameter("selectMonth");
    day = request.getParameter("selectDay");

    if(userIdx == null){
        throw new Exception();
    }

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");

    if(ownerName != null){
        sql2 = "SELECT idx FROM account WHERE name = ? AND phonenumber = ?";
        query2 = connect.prepareStatement(sql2);
        query2.setString(1,ownerName);
        query2.setString(2,ownerPhonenumber);
        rs2 = query2.executeQuery();
        rs2.next();
        ownerIdx = rs2.getString(1);
    }else{
        ownerIdx = userIdx;
    }
    
    sql = "SELECT date,content,execution_status,s.idx,s.user_idx FROM schedule s ";
    sql += " JOIN account a ON user_idx = a.idx WHERE a.idx = ? AND YEAR(date) = ? AND MONTH(date) = ? AND DAY(date) = ? ";
    sql += " ORDER BY date";
    query = connect.prepareStatement(sql);

    query.setString(1,ownerIdx);
    query.setString(2,year);
    query.setString(3,month);
    query.setString(4,day);
    rs = query.executeQuery();

    while(rs.next()){
        ArrayList<String> schedule = new ArrayList<String>();
        String date = rs.getString(1).substring(11,16);
        String content = rs.getString(2); 
        String executionStatus = rs.getString(3);
        String articleIdx = rs.getString(4);
               ownerIdx = rs.getString(5);

        schedule.add("\"" + date + "\"");
        schedule.add("\"" + content + "\"");
        schedule.add("\"" + executionStatus + "\"");
        schedule.add("\"" + articleIdx + "\"");
        schedule.add("\"" + ownerIdx + "\"");

        scheduleList.add(schedule);
    }

}catch(Exception e){
    e.printStackTrace();
    response.sendRedirect("index.jsp");
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/modal.css">
    <link rel="stylesheet" type="text/CSS" href="../css/common.css">

</head>
<body>
    
<!-- 모달 -->
    <section id="modal">
        <h2 id="today_date">모달창 제목</h2> 
        <div id="modal_content">
            <!-- 일정추가 -->
        </div>
        <form id="insert_plan" action="../action/scheduleInsertAction.jsp" onsubmit="return scheduleInsertEvent() ">
            <input id="plan_time" type="time" name="new_time_value">
            <!-- 시간 다이얼식으로 변경 -->
            <input id = "input_plan" type="text" name="new_content_value">
            <input type="submit" id="btn_insert" value="확인">
            <input type="hidden" name="new_date_value">
            <input type="hidden" name="new_owner_idx_value">
        </form>
    </section>

</body>
<script>

    // [날짜,일정,수행여부]
    var scheduleList = <%=scheduleList%>
    var year = <%=year%>
    var month = <%=month%>
    var day = <%=day%>

    console.log("userIdx","<%=userIdx%>")
    console.log("ownerIdx","<%=ownerIdx%>")


    //모든 버튼 모달안에서 생성시 이벤트넣어주기
    //onclick으로 바꿔서 쓰기. addevent X
    //onclick으로 작성시 : e.target.id로 숫자 받아와서 id+index
    //addevent작성시 : 반복문안에서 변수그대로써서 이벤트 걸어주기

    //수정모드 이벤트
    function updateModeEvent(e){
        var id = e.target.id
        var index = id.split("_")[2]
        console.log(index)

        document.getElementById("time_update_"+index).classList.remove("display_none")
        document.getElementById("todo_update_"+index).classList.remove("display_none")
        document.getElementById("confirm_btn_"+index).classList.remove("display_none")

        document.getElementById("checkbox_"+index).classList.add("display_none")
        document.getElementById("time_"+index).classList.add("display_none")
        document.getElementById("todo_"+index).classList.add("display_none")
        document.getElementById("update_btn_"+index).classList.add("display_none")
        document.getElementById("delete_btn_"+index).classList.add("display_none")
    }
    //수정확인버튼 이벤트
    function updateEvent(e){
        var id = e.target.id
        var index = id.split("_")[2]
        var form = document.getElementById("form_"+index)
        var date = '<%=year + "-" + month + "-" + day%>'
        console.log(date)
        form.action = "../action/scheduleUpdateAction.jsp?date=" + date

        document.getElementById("time_update_"+index).classList.add("display_none")
        document.getElementById("todo_update_"+index).classList.add("display_none")
        document.getElementById("confirm_btn_"+index).classList.add("display_none")

        document.getElementById("checkbox_"+index).classList.remove("display_none")
        document.getElementById("time_"+index).classList.remove("display_none")
        document.getElementById("todo_"+index).classList.remove("display_none")
        document.getElementById("update_btn_"+index).classList.remove("display_none")
        document.getElementById("delete_btn_"+index).classList.remove("display_none")

        if(!document.getElementById("time_update_"+index).value || !document.getElementById("todo_update_"+index).value ){
            alert("값을 입력해주세요")
            return false
        }else{
            form.submit()
        }
    }
    // 일정완료 이벤트
    function scheduleCompleteEvent(e){
        var index = e.target.id.split("_")[1];
        var form = document.getElementById("form_"+index)
        form.action = "../action/scheduleUpdateAction.jsp"
        var url;

        var executionStatus = document.getElementById("executionStatus_"+index)
            executionStatus.name = "executionStatus_value"

        var todo = document.getElementById("todo_"+index)
        var articleIdx 
        if(e.target.checked == true){
            executionStatus.value = 1;
        }else{
            executionStatus.value = 0;
        }
        if(executionStatus.value == 1){
            todo.classList.add("text_line_through")
        }else{
            todo.classList.remove("text_line_through")
        }
        
        form.submit()
        
    }
    //삭제버튼 이벤트
    function scheduleDeleteEvent(e){
        var id= e.target.id
        var index = id.split("_")[2]
        var form = document.getElementById("form_"+index)
        form.action = "../action/scheduleDeleteAction.jsp"
        console.log(form)
        
        if (confirm('일정을 삭제하시겠습니까?') == true){
            form.submit()
        }else{
            return false
        }
    }
    //일정 입력 이벤트
    function scheduleInsertEvent(){
        var time =  document.getElementById("plan_time").value
        var content =  document.getElementById("input_plan").value
        if(!time || !content){
            alert("값을 입력해주세요")
            return false
        }
        document.getElementsByName("new_date_value")[0].value = '<%=year%>'+"-"+"<%=month%>"+"-"+"<%=day%>"
        document.getElementsByName("new_owner_idx_value")[0].value = '<%=ownerIdx%>'
        console.log(document.getElementsByName("new_date_value")[0].value)
    }
    window.addEventListener("beforeunload",function(){
        window.opener.location.reload()
    })
</script>
<script src="../js/modal.js"></script>

</body>