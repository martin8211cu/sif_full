<html>
<head>
<title> Process test Gustavo</title>
</head>
<body>
<cfif len(trim(loginID)) is 0 >
<h1>Error!</h1>
<cfabort>
</cfif>

<cfif isnumeric (loginid) is "no">
<h1> Error! numeric!</h1>
<cfabort>
</cfif>

<cfif len(trim(loginpassword)) is "0">
<h1> Error! numeric!</h1>
<cfabort>
</cfif>

<center><h1>intranet viene aquí!</h1></center>


</body>
</html>