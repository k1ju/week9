
date = new Date();
var currentYear = date.getFullYear();
var currentMonth = date.getMonth() + 1;
var currentDay = date.getDate();
var userTeam = userTeam
var userPosition = userPosition
var teamList = document.getElementsByName('team_value')
var positionList = document.getElementsByName('position_value')
var memberList = memberList;
for(var i=0;i<teamList.length;i++){
    if(teamList[i].value == userTeam){
        teamList[i].checked = true
    }
}
for(var i=0;i<positionList.length;i++){
    if(positionList[i].value == userPosition){
        positionList[i].checked = true
    }
}

// 날짜표시
document.getElementById("current_date").innerHTML = currentYear + "-" +  currentMonth + "-" + currentDay

teamMember(memberList)

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