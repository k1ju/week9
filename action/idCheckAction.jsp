<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import = "java.util.regex.Pattern"%>


<%
request.setCharacterEncoding("utf-8");

String inputID = request.getParameter("inputID");
boolean idChecked = true;
String sql = null;
String dbURL = "jdbc:mysql://localhost/week9";
String dbID = "stageus";
String dbPassword = "1234";

ResultSet rs = null;
PreparedStatement query = null;
Connection connect = null;

try{
    String userIDRegex = "^[a-zA-Z가-힣][a-zA-Z가-힣0-9]{0,19}$";

    if(!Pattern.matches(userIDRegex,inputID)){
        throw new Exception();
    }

    Class.forName("com.mysql.jdbc.Driver"); //db연결
    connect = DriverManager.getConnection(dbURL,dbID,dbPassword);
    sql = "SELECT id FROM account WHERE id = ? ";
    query = connect.prepareStatement(sql);
    query.setString(1,inputID);
    rs = query.executeQuery();

    if(rs.next()){
        idChecked=false;
    }
}catch(Exception e){
    //response.sendRedirect("../page/join.jsp");
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

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>


<script>
    var idChecked = <%=idChecked%>
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
        idChecked = idChecked
        idBanner.innerHTML="사용불가능한아이디"
        idBanner.style.color="red"
    }
    window.close()
    
</script>
    
</body>
</html>