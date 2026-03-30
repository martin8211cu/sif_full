<html>
<head>
<title> Longin 2 test Gustavo</title>
</head>
<body>
<form action="prosses.cfm" method="post">
<table align="center" bgcolor="orange">
	<tr>
		<td align="right"> Id:</td>
		<td> 
			<input type="text" name="loginId" maxlength="5">
			<input type="hidden" name="loginId_required" value="Id is required!">
			<input type="hidden" name="loginId_integer" value="invalid id specified!">
		</td>
	</tr>
	<tr>
		<td align="right"> Password:</td>
		<td>
		  <input type="password" name="loginpassword" maxlength="20">
		  <input type="hidden" name="loginpassword_required" value="Id is required!">
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="submit" value= "login"></td>
	</tr>
</table>

</form>
<cfdump var="#form#">

</body>
</html>