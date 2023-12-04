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
<%

ResultSet rs = null;
PreparedStatement query = null;
Connection connect = null;
String sql=null;
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
    sql = "SELECT date,content,execution_status FROM schedule s ";
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
        schedule.add("\"" + date + "\"");
        schedule.add("\"" + content + "\"");
        schedule.add("\"" + executionStatus + "\"");
        scheduleList.add(schedule);
    }

}catch(Exception e){
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
            <input type="hidden"  name="date_value">
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


var modal = document.getElementById("modal")
var modalContent = document.getElementById("modal_content")
var scheduleStatusList = document.getElementsByClassName("schedule_status")
var schedulePlanList = document.getElementsByClassName("schedule_plan")
var modalDeleteBtnList = document.getElementsByClassName("modal__btn_delete")
var modalUpdateBtnList = document.getElementsByClassName("modal__btn_update")
var modalConfirmBtnList = document.getElementsByClassName("modal__btn_confirm")
var schedulePlanUpdate = document.getElementById("schedule_plan_update")
var scheduleTimeUpdate = document.getElementById("schedule_time_update")

// 리스트준비해서 받아오기
//모달내 일정생성하기

makeArticle(scheduleList)

function makeArticle(list){

    for(var i=0;i< list.length;i++){
        let article = document.createElement("article") // 변수를 let으로 선언하여 블럭안에서 변수값유지
        let form = document.createElement("div")
        let checkbox = document.createElement("input")
        let time = document.createElement("div")
        let todo = document.createElement("div")
        let timeUpdate = document.createElement("input")
        let todoUpdate = document.createElement("input")
        
        let confirmBtn = document.createElement("input")
        let updateBtn = document.createElement("button")
        let deleteBtn = document.createElement("button")

        form.action = "scheduleUpdateAction.jsp"
        form.classList.add("article_form")
        
        checkbox.type="checkbox"
        checkbox.id= "checkbox" + i
        checkbox.classList.add("article_checkbox")
        checkbox.classList.add("article_update")

        time.innerHTML=list[i][0] // 일정시간
        time.id = "time" + i
        time.classList.add("article_normal")

        todo.innerHTML=list[i][1]
        todo.id="todo" + i
        todo.classList.add("article_normal")

        updateBtn.innerHTML="수정"
        updateBtn.id = "update_btn"+i
        updateBtn.type = "button" // 타입을 button으로 하여, 폼태그전송 막기
        updateBtn.classList.add("article_btn")
        updateBtn.classList.add("article_normal")
        // updateBtn.onclick = updateModeEvent(i)

        // 위와 같은 형태인데, 이벤트함수에 매개변수를 주고 싶을 때 사용할 수 있는 방법 ( 익명 함수 )
        updateBtn.onclick = (function(event) {
            console.log("클릭")
            updateModeEvent(i)
            event.stopPropagation()
        })
        deleteBtn.innerHTML="삭제"
        deleteBtn.id = "delete_btn"+i
        deleteBtn.type = "button" // 타입을 button으로 하여, 폼태그전송 막기
        deleteBtn.classList.add("article_btn")
        deleteBtn.classList.add("article_normal")
        deleteBtn.onclick = (function(index) {
            return function(){
                console.log("클릭")
                scheduleDeleteEvent(index)
            }
        })(i);

        timeUpdate.type="time"
        timeUpdate.id = "time_update"+i
        timeUpdate.classList.add("article_timeUpdate")
        timeUpdate.classList.add("article_update")

        todoUpdate.type="text"
        todoUpdate.id = "todo_update"+i
        todoUpdate.classList.add("article_todoUpdate")
        todoUpdate.classList.add("article_update")

        confirmBtn.value="확인"
        confirmBtn.type="submit"
        confirmBtn.id="confirm_btn"+i
        confirmBtn.classList.add("article_btn")
        confirmBtn.classList.add("article_update")

        confirmBtn.onclick = (function(index) {
            return function(){
                console.log("클릭")
                updateModeEvent(index);
            };
        })(i);

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

        modalContent.appendChild(article)

        // 수정전환 이벤트
        // TODO: 이런 문법은 존재하지 않음 ( 문제 발생해도 해결 못함 ) -> 아예 이벤트 함수 쓰듯이 작성하고, 매개변수로 처리할 것

    }
}


//모든 버튼 모달안에서 생성시 이벤트넣어주기
//onclick으로 바꿔서 쓰기. addevent X
//onclick으로 매개변수를 이용하여 함수로 접근하려면 클로저 개념필요함 클로저 공부해서 적용하기

//수정모드 이벤트
function updateModeEvent(i){
    console.log(document.getElementById("checkbox"+i))
    document.getElementById("checkbox"+i).classList.remove("article_update")
    document.getElementById("time_update"+i).classList.remove("article_update")
    document.getElementById("todo_update"+i).classList.remove("article_update")
    document.getElementById("confirm_btn"+i).classList.remove("article_update")

    document.getElementById("time"+i).classList.add("article_update")
    document.getElementById("todo"+i).classList.add("article_update")
    document.getElementById("update_btn"+i).classList.add("article_update")
    document.getElementById("delete_btn"+i).classList.add("article_update")
}
//수정확인버튼 이벤트
// confirmBtn.addEventListener('click',function(){
function updateEvent(i){
    console.log("클릭")
    document.getElementById("checkbox"+i).classList.add("article_update")
    document.getElementById("time_update"+i).classList.add("article_update")
    document.getElementById("todo_update"+i).classList.add("article_update")
    document.getElementById("confirm_btn"+i).classList.add("article_update")

    document.getElementById("time"+i).classList.remove("article_update")
    document.getElementById("todo"+i).classList.remove("article_update")
    document.getElementById("update_btn"+i).classList.remove("article_update")
    document.getElementById("delete_btn"+i).classList.remove("article_update")

    if(!document.getElementById("time_update"+i).value || !document.getElementById("todo_update"+i).value ){
        alert("값을 입력해주세요")
    }else{
        var url = "scheduleUpdateAction.jsp?"
        window.open(url,"_self")

    location.href = "scheduleUpdateAction.jsp"

    }
}
//삭제버튼 이벤트
function scheduleDeleteEvent(i){
    
    if (confirm('일정을 삭제하시겠습니까?') == true){
        alert("삭제되었습니다")
        // location.href = "scheduleDeleteAction.jsp"
    }else{
        return
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