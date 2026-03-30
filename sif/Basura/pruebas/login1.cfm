<html>
<head>
<title> Longin 1 test Gustavo</title>
</head>
<body>
<form action="prosses.cfm" method="post">
<table>
	<tr>
		<td align="right"> Id:</td>
		<td> <input type="text" name="loginId" maxlength="5"></td>
	</tr>
	<tr>
		<td align="right"> Password:</td>
		<td> <input type="password" name="loginpassword" maxlength="20"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="submit" value= "login"></td>
	</tr>
</table>

</form>
<cfdump var="#form#">

</body>
</html>