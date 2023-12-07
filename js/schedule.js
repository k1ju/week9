 //전역 코드 모아놓기
    var date = new Date()
    var selectYear = selectYear
    var selectMonth = selectMonth
    var selectDay = selectDay
    var userIdx = userIdx
    var ownerIdx = ownerIdx
    var ownerName = ownerName
    var ownerPhonenumber = ownerPhonenumber
    var memberList = memberList
    var scheduleList= scheduleList
    console.log("멤버리스트:",memberList)
    console.log("유저idx",userIdx)
    console.log("ownerName",ownerName)
    console.log("ownerPhonenumber",ownerPhonenumber)
    console.log("ownerIdx",ownerIdx)

    //현재날짜 표시  
    document.getElementById("current_date").innerHTML = date.getFullYear() + "-" +  (date.getMonth() + 1) + "-" + date.getDate();

    //함수선언
    makeCalenderName(ownerName,selectYear,selectMonth)
    makeCalender(selectMonth)
    teamMember(memberList)

    // 월 버튼 생성
    for(var i=0;i<12;i++){
        var monthBtn = document.createElement("button")
        var monthName = document.createElement("div")
        var monthChecked = document.createElement("div")

        monthBtn.classList.add("month_btn")
        monthBtn.id ='month_btn_' + (i+1)

        monthName.classList.add("name_month")
        monthName.innerHTML = (i+1) + "월"
        monthName.id = "month_name_" + (i+1)

        monthChecked.innerHTML = "V"
        monthChecked.style.display = "none"
        monthChecked.id='month_checked_' + (i+1)

        monthBtn.appendChild(monthName)
        monthBtn.appendChild(monthChecked)
        document.getElementById("month_btn_box").appendChild(monthBtn)

        monthBtn.onclick= monthBtnEvent

    }

    document.getElementById("month_checked_" + (selectMonth)).style.display="block"

    //함수정의
    function makeCalenderName(ownerName,selectYear,selectMonth){
        var ownerCalender = document.getElementById("owner_calender")
        ownerCalender.innerHTML = ownerName + "팀원의 " + selectYear + "년 " + selectMonth + "월 일정"
    }
    function teamMember(memberList){//2차원리스트, 이름,전화번호순
        for(var i=0;i<memberList.length;i++){
            var member = document.createElement("a")
            member.innerHTML=memberList[i][0] + " : " + memberList[i][1].substring(0,3) + "-" + memberList[i][1].substring(3,7) + "-" + memberList[i][1].substring(7,11)             
            member.classList.add("member")
            member.href= "schedule.jsp?ownerName=" + memberList[i][0] + "&ownerPhonenumber=" + memberList[i][1] 
            //이름,전화번호 전달
            document.getElementById("team_member").appendChild(member)
        }
    }
    //날짜 생성함수
    function makeCalender(selectMonth){
        var calender = document.getElementById("calender")

        var maxDay = 0
        if (selectMonth ==2){
            maxDay=28
        } else if(selectMonth== 1 || selectMonth== 3 || selectMonth== 5 || selectMonth== 5 ||
        selectMonth== 7 || selectMonth== 8 || selectMonth== 10 || selectMonth== 12 ){
            maxDay = 31
        } else {
            maxDay=30
        }

        calender.innerHTML=""
        for(var i=0;i<5;i++){
            var trTag = document.createElement("tr")
            calender.appendChild(trTag)
            trTag.classList.add("tr_tag")
            for(var j=0; j<7;j++){
                var tdTag = document.createElement("td")
                var dayBtn = document.createElement("button")
                var scheduleCount = 0
                var scheduleLine = document.createElement("div")
                
                for(var k=0; k<scheduleList.length; k++){
                    if(scheduleList[k][0].substring(8,10) == (i*7)+(j+1)){
                        scheduleCount++
                    }
                }

                tdTag.className="tdTag"
                dayBtn.className="dayBtn"
                dayBtn.id = "day_btn_"+(parseInt(j+1) + parseInt(i*7))
                scheduleLine.className="scheduleLine"
                scheduleLine.id = "day_scheduleLine_" + (parseInt(j+1) + parseInt(i*7))
                tdTag.appendChild(dayBtn)
                if ((j+1)+(i*7) > maxDay){
                    break
                }
                dayBtn.innerHTML = (j+1)+(i*7)
                trTag.appendChild(tdTag)
                dayBtn.appendChild(scheduleLine)

                if(scheduleCount!=0){
                    if(scheduleCount>9){
                        scheduleCount="9+"
                    }
                    scheduleLine.innerHTML = scheduleCount
                }else{
                    scheduleLine.style.display="none"
                }
                //반복문으로 만든 여러개의 개체에 동시에 이벤트부여하는 것은 addevent가 더 낫다

                dayBtn.onclick = dayBtnEvent

            }
        }
    }
