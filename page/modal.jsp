<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
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
        <form id="insert_plan" action="scheduleInsertAction.jsp">
            <input id="plan_time" type="time">
            <!-- 시간 다이얼식으로 변경 -->
            <input id = "input_plan" type="text">
            <!-- <button id="btn_insert">확인 -->
            <input type="submit" id="btn_insert" value="확인">
        </form>
    </section>

<script>
//모달 변수
// [날짜,일정,수행여부]
var dummyList = [['2023-11-27 12:34:56','등산가기','false'],['2023-11-27 12:34:56','물마시기','false']]

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

makeArticle(dummyList)


function makeArticle(list){

    for(var i=0;i< list.length;i++){
        var article = document.createElement("article")
        var form = document.createElement("form")
        var checkbox = document.createElement("input")
        var scheduleTime = document.createElement("div")
        var schedulePlan = document.createElement("div")
        var updateBtn = document.createElement("button")
        var deleteBtn = document.createElement("button")
        var scheduleTimeUpdate = document.createElement("input")
        var schedulePlanUpdate = document.createElement("input")
        var confirmBtn = document.createElement("input")

        form.action = "scheduleUpdateAction.jsp"
        form.onsubmit = scheduleUpdateEvent

        checkbox.classList.add("schedule_status")
        checkbox.type="checkbox"
        checkbox.id= "checkbox" + i
        checkbox.classList = "checkbox"

        scheduleTime.innerHTML=list[i][0].substring(11,16) // 일정시간
        schedulePlan.classList.add("schedule_time")
        scheduleTime.id = "schedule_time" + i

        schedulePlan.classList.add("schedule_plan")
        schedulePlan.innerHTML=list[i][1]
        schedulePlan.id="plan" + i

        updateBtn.classList.add("schedule_btn")
        updateBtn.classList.add("modal__btn_update")
        updateBtn.innerHTML="수정"
        updateBtn.id = "update_btn"+i
        updateBtn.onclick = scheduleUpdateEvent

        // 위와 같은 형태인데, 이벤트함수에 매개변수를 주고 싶을 때 사용할 수 있는 방법 ( 익명 함수 )
        // updateBtn.onclick = function() {
        //     scheduleUpdateEvent()
        // }

        deleteBtn.classList.add("schedule_btn")
        deleteBtn.classList.add("modal__btn_delete") 
        deleteBtn.innerHTML="삭제"
        deleteBtn.id = "delete_btn"+i

        scheduleTimeUpdate.type="time"
        scheduleTimeUpdate.id = "schedule_time_update"+i
        scheduleTimeUpdate.classList.add("schedule_time_update")

        schedulePlanUpdate.type="text"
        schedulePlanUpdate.value="스테이지어스"
        schedulePlanUpdate.id = "schedule_plan_update"+i
        schedulePlanUpdate.classList.add("schedule_plan_update")

        confirmBtn.classList.add("schedule_btn")
        confirmBtn.classList.add("modal__btn_confirm")
        confirmBtn.value="확인"
        confirmBtn.type="submit"
        confirmBtn.id="confirm_btn"+i

        scheduleTimeUpdate.style.display="none"
        schedulePlanUpdate.style.display="none"
        confirmBtn.style.display="none"

        article.appendChild(form)
        form.appendChild(scheduleTimeUpdate)
        form.appendChild(schedulePlanUpdate)
        form.appendChild(confirmBtn)

        article.appendChild(checkbox)
        article.appendChild(scheduleTime)
        article.appendChild(schedulePlan)
        article.appendChild(updateBtn)
        article.appendChild(deleteBtn)
        modalContent.appendChild(article)

        // 수정전환 이벤트
        // TODO: 이런 문법은 존재하지 않음 ( 문제 발생해도 해결 못함 ) -> 아예 이벤트 함수 쓰듯이 작성하고, 매개변수로 처리할 것
        function scheduleUpdateEvent(){
            console.log("클릭")
            // document.getElementById('schedule_time_update'+e).style.display="inline"
            // document.getElementById('schedule_plan_update'+e).style.display="inline"
            // document.getElementById('confirm_btn'+e).style.display="inline"

            scheduleTimeUpdate.style.display="inline"
            schedulePlanUpdate.style.display="inline"
            confirmBtn.style.display="inline"

            checkbox.style.display="none"
            scheduleTime.style.display="none"
            schedulePlan.style.display="none"
            updateBtn.style.display="none"
            deleteBtn.style.display="none"
        }

        //수정확인버튼 이벤트
        confirmBtn.addEventListener('click',function(){
            console.log("클릭")
            scheduleTimeUpdate.style.display="none"
            schedulePlanUpdate.style.display="none"
            confirmBtn.style.display="none"

            checkbox.style.display="inline"
            scheduleTime.style.display="inline"
            schedulePlan.style.display="inline"
            updateBtn.style.display="inline"
            deleteBtn.style.display="inline"

            // location.href = "scheduleUpdateAction.jsp"
        })
    }
}


//모든 버튼 모달안에서 생성시 이벤트넣어주기
//onclick으로 바꿔서 쓰기. addevent X
// 취소선 이벤트
// for(var i=0;i<scheduleStatusList.length;i++){
//     (function(index) {
//         scheduleStatusList[index].addEventListener('change',function(){ // 정리
//             if(scheduleStatusList[index].checked == true){
//                 schedulePlanList[index].classList.add("schedule_cancel")
//                 console.log(schedulePlanList[index])
//                 console.log("취소선표시")

//             }else{
//                 schedulePlanList[index].classList.remove("schedule_cancel")
//                 console.log(schedulePlanList[index])
//                 console.log("취소선해제")
//             }
//         })
//     })(i)
// }
//삭제버튼 이벤트
function scheduleDeleteEvent(){
    if (confirm('일정을 삭제하시겠습니까?') == true){
        alert("삭제되었습니다")
        // location.href = "scheduleDeleteAction.jsp"
    }else{
        return
    }
}
//수정버튼 이벤트
// function scheduleUpdateEvent(i){
//         console.log("클릭")
//         document.getElementById("schedule_time_update"+i).style.display="inline"
//         document.getElementById("schedule_plan_update"+i).style.display="inline"
//         document.getElementById("confirm_btn"+i).style.display="inline"
//         document.getElementById('checkbox'+i).style.display="none"
//         document.getElementById('schedule_time'+i).style.display="none"
//         document.getElementById('plan'+i).style.display="none"
//         document.getElementById('update_btn'+i).style.display="none"
//         document.getElementById('delete_btn'+i).style.display="none"
// }


</script>
</body>