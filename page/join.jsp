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
        <form class = "join_form" action="../action/joinAction.jsp" onsubmit="return checkEvent()">
         
            <table>
                <tr>
                    <th>아이디</th>
                    <!-- <form id = "idCheckForm" action="idCheckAction.jsp" onsubmit="return idCheckEvent()"> 폼안에 폼은 쓸수없음. 지워진다.-->
                        <td class="c2">
                            <input id = "input_id"  type="text" placeholder="아이디" name="id_value" onchange="checkBtnEvent()">
                        </td>
                        <td class="c3"> 
                            <!-- TODO: 이벤트 함수 밖으로 빼서 form태그 정상적으로 가져와지는지 출력으로 확인할 것 -->
                            <input id="btn_check" type="button" class = "check_btn" value="중복확인" onclick="idCheckEvent()">
                        </td>
                        <td class="c4">
                            <span id="id_banner"></span>
                        </td>
                    <!-- </form> -->
                </tr>
                <tr>
                    <th>비밀번호</th>
                    <td class="c2">
                        <input id = "input_pw"  type="password" placeholder="비밀번호" name="pw_value">
                    </td>
                </tr>
                <tr>
                    <th>비밀번호확인</th>
                    <td class="c2">
                        <input id = "input_pw_check"  type="password" placeholder="비밀번호 확인" name="pw_check_value">
                    </td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td class="c2 input_name">
                        <input id = "input_name"  type="text" placeholder="이름" name="name_value">
                    </td>
                </tr>
                <tr>
                    <th>연락처</th>
                    <td class="c2">
                        <input id = "input_phonenumber" type="text" placeholder="연락처" name="phonenumber_value">
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
</body>

<script>

var idBanner = document.getElementById("id_banner")
var checkBtn = document.getElementById("btn_check")
var inputIDTag = document.getElementById("input_id")

//이벤트 설정

//회원가입 버튼
function checkEvent(){
    
    //아이디 정규표현식
    var idRegex = /^[a-zA-Z가-힣][a-zA-Z가-힣0-9]{0,19}$/g
    var id = document.getElementById("input_id").value

    var pwRegex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{1,20})$/
    var pw = document.getElementById("input_pw").value.trim()
    var pw_check = document.getElementById("input_pw_check").value.trim()

    var nameRegex = /^[가-힣]{2,4}$/
    var name = document.getElementById("input_name").value.trim()

    var phonenumberRegex = /^[0-9]{10,11}$/
    var phonenumber = document.getElementById("input_phonenumber").value.trim().replaceAll(/[^0-9]/,"")

    var teamTagList = document.getElementsByName("team_value")
    var positionTagList = document.getElementsByName("position_value")

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

    if(!id || !pw || !pw_check || !name || !phonenumber || !team || !position){ // 하나라도 널값이라면
       alert("필수값 입력해주세요")
       return false
    }else if(pw != pw_check){
        alert("비밀번호가 일치하지 않습니다")
        return false
    }else if(checkBtn.disabled==false){ // 아이디 중복확인이 안되어있다면, 
        alert("아이디 중복검사를 진행해주세요")
        return false
    }else if(!(idRegex.test(id))){
        alert("아이디 20글자이하,첫글자 문자")
       return false
    }else if(!(pwRegex.test(pw))){
        alert("비밀번호 문자,숫자,특수문자 포함 20글자이하")
        return false
    }else if( !nameRegex.test(name) ){
        alert("이름 한글 2~4글자")
        return false
    }else if(!phonenumberRegex.test(phonenumber)){
        alert("전화번호 숫자10,11글자")
        return false
    }

}

function checkBtnEvent(){
    console.log("중복버튼활성화")
    checkBtn.disabled=false
    checkBtn.style.backgroundColor="royalblue"
}
function idCheckEvent(){
    var id = document.getElementById("input_id").value
    var idRegex = /^[a-zA-Z가-힣][a-zA-Z가-힣0-9]{0,19}$/g

    var url = "../action/idCheckAction.jsp?inputID=" + encodeURIComponent(id)


    if(!id ){ // 하나라도 널값이라면
       alert("필수값 입력해주세요")
       return false
    }
    if(!(idRegex.test(id))){
        alert("아이디 20글자이하,첫글자 문자")
       return false
    }
    window.open(url,"_blank")
    
    // window.open()
    // 팝업창으로 띄우고, 위에서 가져온 idValue를 보내주는 방법으로
    // 해당 팝업창에서 백엔드 통신을 통해 아이디 중복체크 진행
    // 해당 결과를 부모 페이지인 이 페이지로 받아오는 것 까지
}


function moveToDestEvent(e){
    console.log(e)
    location.href=e
}

</script>
</body>
</html>


