<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/join.css?after">

</head>
<body>
    <div id="container">
    <h1 id="title">Time Tree</h1>
        <form class = "join_form" action="joinAction.jsp">
         

        <table>
            <tr>
                <th></th>
                <form action="idCheckAction.jsp">
                    <td class="c2">
                        <input id = "input_id"  type="text" placeholder="아이디" name="id_value">
                    </td>
                    <td class="c3">
                        <input class = "check_btn" type="submit" value="중복확인" >
                    </td>
                    <td class="c4">
                        <span id="id_banner">사용가능한 아이디</span>
                    </td>
                </form>
            </tr>
            <tr>
                <th></th>
                <td class="c2">
                    <input id = "input_pw"  type="password" placeholder="비밀번호" name="pw_value">
                </td>
            </tr>
            <tr>
                <th></th>
                <td class="c2">
                    <input id = "input_pw_check"  type="password" placeholder="비밀번호 확인">
                </td>
            </tr>
            <tr>
                <td></td>
            </tr>
            <tr>
                <th></th>
                <td class="c2 input_name">
                    <input id = "input_name"  type="text" placeholder="이름" name="name_value">
                </td>
            </tr>
            <tr>
                <th></th>
                <td class="c2">
                    <input id = "input_phonenumber"  type="text" placeholder="연락처" name="phonenumber_value">
                </td>
            </tr>
            <tr>
                <th>부서</th>
                <td class="c2 team">
                    <input class="input_team" type="radio" value="스테이지어스" name="team_value">스테이지어스
                    <input class="input_team" type="radio" value="네이버" name="team_value">네이버
                </td>
            </tr>
            <tr>
                <th>직급</th>
                <td class="c2 position">
                    <input class="input_position" type="radio" value="팀원" name="position_value">팀원
                    <input class="input_position" type="radio" value="팀장" name="position_value">팀장
                </td>
            </tr>
            <tr>
                <th></th>
                <td class="c2">
                    <input id="btn_join" class="Btn" type="submit" value="회원가입">
                </td>
            </tr>
        </table>

        
    </form>

    </div>

<script>
var id 
var pw 
var name 
var phonenumber 
var teamTagList = document.getElementsByName("team_value")
var positionTagList = document.getElementsByName("position_value")
var position
var team

var idBanner = document.getElementById("id_banner")
var checkBtn = document.getElementById("btn_check")
var inputId = document.getElementById("input_id")
var idStatus = null



//이벤트 설정

//회원가입 버튼
document.getElementById("btn_join").addEventListener('click',function(){
    event.preventDefault()

    id = document.getElementById("input_id").value
    pw = document.getElementById("input_pw").value
    pw_check = document.getElementById("input_pw_check").value
    name = document.getElementById("input_name").value
    phonenumber = document.getElementById("input_phonenumber").value

    for(var i=0;i<teamTagList.length;i++){ // 체크된 radio 찾기
        if(teamTagList[i].checked == true){
            team = teamTagList[i].value;
            break;
        }
    }
    for(var j=0;j<positionTagList.length;j++){ 
        if(positionTagList[j].checked == true){
            position=positionTagList[j].value;
            break;
        }
    }

    console.log(pw)
    console.log(pw_check)

    if(!id || !pw || !pw_check || !name || !phonenumber || !team || !position){ // 하나라도 널값이라면
       alert("필수값 입력해주세요")

    }else if(id.length>20){
        alert("아이디 최대 20글자 제한")
    }else if(pw.length>20){
        alert("비밀번호 최대 20글자 제한")
    }else if(name.length>9){
        alert("이름 최대 10글자 제한")
    // }else if(phonenumber.length>12 || phonenumber.length<10){
    //     alert("연락처 10,11글자 제한")
    }else if(pw != pw_check){
        alert("비밀번호가 일치하지 않습니다")
    }else if(checkBtn.disabled==false){ // 아이디 중복확인이 안되어있다면, 
        alert("아이디 중복검사를 진행해주세요")
    }
})

//중복확인 버튼
function idCheckEvent(){
    id = document.getElementById("input_id").value

    if( (id!="") && (!!id) && (id != undefined)){
        console.log(id)
        idBanner.innerHTML = "사용가능한 아이디"
        idBanner.style.color = "green"
        checkBtn.disabled=true
        checkBtn.style.backgroundColor="gray"
        inputId.readOnly=true
        inputId.style.border="solid 4px black"
    } else{
        console.log(id)
        idBanner.innerHTML = "중복된 아이디"
        idBanner.style.color = "red"
    }
}


function moveToDest(e){
    console.log(e)
    location.href=e
}

</script>
</body>
</html>


