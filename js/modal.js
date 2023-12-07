// 별도의 파일에 분리되어있는경우 <script src="~~">
// 전역변수만 공유된다
var scheduleList = scheduleList
var year = year
var month = month
var  day = day
    

console.log("스케쥴리스트",scheduleList)
document.getElementById("today_date").innerHTML = year + "-" + month + "-" + day + "일정"
makeArticle(scheduleList)

//모달내 일정생성하기
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
        var date = document.createElement("input")
        var articleIdx = document.createElement("input")
        var ownerIdx = document.createElement("input")
        var executionStatus = document.createElement("input")

        executionStatus.value = list[i][2]
        executionStatus.id = "executionStatus_"+i
        executionStatus.classList.add("display_none")

        form.classList.add("article_form")
        form.id = "form_"+i
        
        checkbox.type="checkbox"
        checkbox.id= "checkbox_" + i
        checkbox.classList.add("article_checkbox")
        checkbox.onclick = scheduleCompleteEvent
        if(executionStatus.value == 1){
            checkbox.checked = true;
        }

        time.innerHTML=list[i][0] // 일정시간
        time.id = "time_" + i

        todo.innerHTML=list[i][1]
        todo.id="todo_" + i
        if(executionStatus.value == 1){
            todo.classList.add("text_line_through");
        }else{
            todo.classList.remove("text_line_through");
        }

        updateBtn.innerHTML="수정"
        updateBtn.id = "update_btn_"+i
        updateBtn.type = "button" // 타입을 button으로 하여, 폼태그전송 막기
        updateBtn.classList.add("article_btn")
        updateBtn.onclick = updateModeEvent

        // 안되는 이유 : 이벤트 등록을 html이 아닌 js에서 할경우, 이벤트 등록을 해주는 함수가 "비동기 함수"
        // 비동기 함수의 의미는, 오래걸리는 작업을 나중에 처리하도록 하는 함수
        // 코드 블럭 ( 중괄호 내용 ) 이 끝난 다음에 처리가 됨

        deleteBtn.innerHTML="삭제"
        deleteBtn.id = "delete_btn_"+i
        deleteBtn.type = "button" // 타입을 button으로 하여, 폼태그전송 막기
        deleteBtn.classList.add("article_btn")
        deleteBtn.onclick = scheduleDeleteEvent

        timeUpdate.type="time"
        timeUpdate.id = "time_update_"+i
        timeUpdate.classList.add("article_timeUpdate")
        timeUpdate.classList.add("display_none")
        timeUpdate.value = list[i][0]
        timeUpdate.name = "time_value"

        todoUpdate.type="text"
        todoUpdate.id = "todo_update_"+i
        todoUpdate.classList.add("article_todoUpdate")
        todoUpdate.classList.add("display_none")
        todoUpdate.value = list[i][1]
        todoUpdate.name = "content_value"

        confirmBtn.value="확인"
        confirmBtn.type="submit"
        confirmBtn.id="confirm_btn_"+i
        confirmBtn.classList.add("article_btn")
        confirmBtn.classList.add("display_none")

        confirmBtn.onclick = updateEvent

        articleIdx.type = "hidden"
        articleIdx.value = list[i][3]
        articleIdx.name = "article_idx_value"

        ownerIdx.type = "hidden"
        ownerIdx.value = list[i][4]
        ownerIdx.name = "owner_idx_value"

        date.type = "hidden"
        date.value = year + "-" + month + "-" + day
        date.name = "date_value"
        console.log("데이트의 값",date.value)

        article.appendChild(form)
        form.appendChild(executionStatus)
        form.appendChild(checkbox)
        form.appendChild(time)
        form.appendChild(timeUpdate)
        form.appendChild(todo)
        form.appendChild(todoUpdate)
        form.appendChild(confirmBtn)
        form.appendChild(updateBtn)
        form.appendChild(deleteBtn)
        form.appendChild(articleIdx)
        form.appendChild(ownerIdx)
        form.appendChild(date)
        modalContent.appendChild(article)
    }
}