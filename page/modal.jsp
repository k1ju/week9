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
Connection connect = null;
String sql = null;
String userIdx = null;
String userName = null;
String year = null;
String month = null;
String day = null;
ArrayList<ArrayList<String>> scheduleList = new ArrayList<ArrayList<String>>();

try{
    userIdx = (String)session.getAttribute("userIdx");
    userName = (String)session.getAttribute("userName");
    year = request.getParameter("selectYear");
    month = request.getParameter("selectMonth");
    day = request.getParameter("selectDay");

    if(userIdx == null){
        throw new Exception();
    }

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week9","stageus","1234");
    sql = "SELECT date,content,execution_status,s.idx,s.user_idx FROM schedule s ";
    sql += " JOIN account a ON user_idx = a.idx WHERE a.idx = ? AND YEAR(date) = ? AND MONTH(date) = ? AND DAY(date) = ? ";
    sql += " ORDER BY date";
    query = connect.prepareStatement(sql);

    query.setString(1,userIdx);
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
        String writerIdx = rs.getString(5);

        schedule.add("\"" + date + "\"");
        schedule.add("\"" + content + "\"");
        schedule.add("\"" + executionStatus + "\"");
        schedule.add("\"" + articleIdx + "\"");
        schedule.add("\"" + writerIdx + "\"");

        scheduleList.add(schedule);
    }

}catch(Exception e){
    e.printStackTrace();
    //response.sendRedirect("index.jsp");
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
<!-- 제목: 선택날짜
내용: 선택날짜 일정 -->
    <section id="modal">
        <h2>모달창 제목</h2> 
        <div id="modal_content">
            <!-- 일정추가 -->
        </div>
        <form id="insert_plan" action="../action/scheduleInsertAction.jsp" onsubmit="return scheduleInsertEvent() ">
            <input id="plan_time" type="time" name="time_value">
            <!-- 시간 다이얼식으로 변경 -->
            <input id = "input_plan" type="text" name="content_value">
            <!-- <button id="btn_insert">확인 -->
            <input type="submit" id="btn_insert" value="확인">
            <input type="hidden" name="date_value">

        </form>
    </section>

</body>
<script>

// [날짜,일정,수행여부]
var scheduleList = <%=scheduleList%>
console.log(scheduleList)
console.log("<%=sql%>")
console.log("<%=userIdx%>")
console.log("<%=year%>")
console.log("<%=month%>")
console.log("<%=day%>")
console.log("<%=year%>" + "-" + "<%=month%>" + "-" +"<%=day%>")



// 리스트준비해서 받아오기
//모달내 일정생성하기

makeArticle(scheduleList)

function makeArticle(list){
    var modal = document.getElementById("modal")
    var modalContent = document.getElementById("modal_content")

    for(var i=0;i< list.length;i++){
        var article = document.createElement("article") // 변수를 let으로 선언하여 블럭안에서 변수값유지
        var form = document.createElement("form")
        var checkbox = document.createElement("input")
        var time = document.createElement("div")
        var todo = document.createElement("div")
        var timeUpdate = document.createElement("input")
        var todoUpdate = document.createElement("input")
        var confirmBtn = document.createElement("input")
        var updateBtn = document.createElement("button")
        var deleteBtn = document.createElement("button")
        var articleIdx = document.createElement("input")
        var writerIdx = document.createElement("input")

        // form.action = "scheduleUpdateAction.jsp"
        form.classList.add("article_form")
        form.id = "form_"+i
        
        checkbox.type="checkbox"
        checkbox.id= "checkbox_" + i
        checkbox.classList.add("article_checkbox")
        checkbox.classList.add("article_update")

        time.innerHTML=list[i][0] // 일정시간
        time.id = "time_" + i
        time.classList.add("article_normal")

        todo.innerHTML=list[i][1]
        todo.id="todo_" + i
        todo.classList.add("article_normal")

        updateBtn.innerHTML="수정"
        updateBtn.id = "update_btn_"+i
        updateBtn.type = "button" // 타입을 button으로 하여, 폼태그전송 막기
        updateBtn.classList.add("article_btn")
        updateBtn.classList.add("article_normal")


        // 안되는 이유 : 이벤트 등록을 html이 아닌 js에서 할경우, 이벤트 등록을 해주는 함수가 "비동기 함수"
        // 비동기 함수의 의미는, 오래걸리는 작업을 나중에 처리하도록 하는 함수
        // 코드 블럭 ( 중괄호 내용 ) 이 끝난 다음에 처리가 됨
        updateBtn.onclick = updateModeEvent

        deleteBtn.innerHTML="삭제"
        deleteBtn.id = "delete_btn_"+i
        deleteBtn.type = "button" // 타입을 button으로 하여, 폼태그전송 막기
        deleteBtn.classList.add("article_btn")
        deleteBtn.classList.add("article_normal")
        deleteBtn.onclick = scheduleDeleteEvent

        timeUpdate.type="time"
        timeUpdate.id = "time_update_"+i
        timeUpdate.classList.add("article_timeUpdate")
        timeUpdate.classList.add("article_update")

        todoUpdate.type="text"
        todoUpdate.id = "todo_update_"+i
        todoUpdate.classList.add("article_todoUpdate")
        todoUpdate.classList.add("article_update")

        confirmBtn.value="확인"
        confirmBtn.type="submit"
        confirmBtn.id="confirm_btn_"+i
        confirmBtn.classList.add("article_btn")
        confirmBtn.classList.add("article_update")

        confirmBtn.onclick = updateEvent

        articleIdx.type = "hidden"
        articleIdx.value = list[i][3]
        articleIdx.name = "article_idx_value"

        writerIdx.type = "hidden"
        writerIdx.value = list[i][4]
        writerIdx.name = "writer_idx_value"

        // checkbox.style.display = "none"
        // timeUpdate.style.display="none"
        // todoUpdate.style.display="none"
        // confirmBtn.style.display="none"

        article.appendChild(form)
        form.appendChild(checkbox)
        form.appendChild(time)
        form.appendChild(timeUpdate)
        form.appendChild(todo)
        form.appendChild(todoUpdate)
        form.appendChild(confirmBtn)
        form.appendChild(updateBtn)
        form.appendChild(deleteBtn)
        form.appendChild(articleIdx)
        form.appendChild(writerIdx)
        modalContent.appendChild(article)
        // 수정전환 이벤트
        // TODO: 이런 문법은 존재하지 않음 ( 문제 발생해도 해결 못함 ) -> 아예 이벤트 함수 쓰듯이 작성하고, 매개변수로 처리할 것

    }
}


//모든 버튼 모달안에서 생성시 이벤트넣어주기
//onclick으로 바꿔서 쓰기. addevent X
//onclick으로 매개변수를 이용하여 함수로 접근하려면 클로저 개념필요함 클로저 공부해서 적용하기

//수정모드 이벤트
function updateModeEvent(e){
    var id = e.target.id
    var index = id.split("_")[2]
    console.log(index)

    document.getElementById("checkbox_"+index).classList.remove("article_update")
    document.getElementById("time_update_"+index).classList.remove("article_update")
    document.getElementById("todo_update_"+index).classList.remove("article_update")
    document.getElementById("confirm_btn_"+index).classList.remove("article_update")

    document.getElementById("time_"+index).classList.add("article_update")
    document.getElementById("todo_"+index).classList.add("article_update")
    document.getElementById("update_btn_"+index).classList.add("article_update")
    document.getElementById("delete_btn_"+index).classList.add("article_update")
}
//수정확인버튼 이벤트
// confirmBtn.addEventListener('click',function(){
function updateEvent(e){
    var id = e.target.id
    var index = id.split("_")[2]
    form.action = "../action/scheduleUpdateAction.jsp"

    document.getElementById("checkbox_"+index).classList.add("article_update")
    document.getElementById("time_update_"+index).classList.add("article_update")
    document.getElementById("todo_update_"+index).classList.add("article_update")
    document.getElementById("confirm_btn_"+index).classList.add("article_update")

    document.getElementById("time_"+index).classList.remove("article_update")
    document.getElementById("todo_"+index).classList.remove("article_update")
    document.getElementById("update_btn_"+index).classList.remove("article_update")
    document.getElementById("delete_btn_"+index).classList.remove("article_update")

    if(!document.getElementById("time_update_"+index).value || !document.getElementById("todo_update_"+index).value ){
        alert("값을 입력해주세요")
        return false
    }else{
        form.submit()
    }
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
    document.getElementsByName("date_value")[0].value = '<%=year%>'+"-"+"<%=month%>"+"-"+"<%=day%>"

    console.log(document.getElementsByName("date_value")[0].value)
    
}


</script>
</body>