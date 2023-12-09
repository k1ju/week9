
var idChecked = idChecked
var idBanner = window.opener.document.getElementById("id_banner")
var checkBtn = window.opener.document.getElementById("btn_check")
console.log("<%=sql%>")
console.log("<%=inputID%>")

if (idChecked == true){ 
    console.log("중복아닌경우")
    console.log(idChecked)
    idBanner.innerHTML="사용가능한 아이디"
    idBanner.style.color="green"
    checkBtn.disabled = true
    checkBtn.style.backgroundColor = "gray"
}else{ //중복된 아이디
    console.log("중복인 경우")
    console.log(idChecked)
    idBanner.innerHTML="사용불가능한아이디"
    idBanner.style.color="red"
}
window.close()