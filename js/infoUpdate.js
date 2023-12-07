
date = new Date();
var currentYear = date.getFullYear();
var currentMonth = date.getMonth() + 1;
var currentDay = date.getDate();
var userTeam = userTeam
var userPosition = userPosition
var teamList = document.getElementsByName('team_value')
var positionList = document.getElementsByName('position_value')

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