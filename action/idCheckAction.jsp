<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>


<%
    request.setCharacterEncoding("utf-8");

    String inputID = request.getParameter("inputID");
    boolean idChecked = true;
    String dbURL = "jdbc:mysql://localhost/week9";
    String dbID = "stageus";
    String dbPassword = "1234";

    if(inputID.length()>20){
        idChecked=false;

    }else if(inputID == null || inputID == ""){
        idChecked=false;
    } else{

        Class.forName("com.mysql.jdbc.Driver"); //db연결
        Connection connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
        String sql = "SELECT id FROM user WHERE id = ? ";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1,inputID);

        ResultSet rs = query.executeQuery();

        if(rs.next()){
            idChecked=false;
        }
    }

%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>


<script>
    var idChecked = <%=idChecked%>

    if (idChecked ==true){ 
        console.log("중복아닌경우")
        console.log(idChecked)
        window.opener.idBanner.innerHTML="사용가능한 아이디"
        window.opener.idBanner.style.color="green"
        window.opener.checkBtn.disabled = true
        window.opener.checkBtn.style.backgroundColor = "gray"
    }else{ //중복된 아이디
        console.log("중복인 경우")
        console.log(idChecked)
        window.opener.idChecked = idChecked
        window.opener.idBanner.innerHTML="사용불가능한아이디"
        window.opener.idBanner.style.color="red"
    }
    window.close()
//아이디 전송은 url로
//돌려주는것은 window.opener.checkedID = false
// 부모창에 checkedID가 선언되어있음

</script>
    
</body>
</html>