<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>


<cfquery name="data" datasource="minisif">
	select SNcodigo, SNnumero, SNnombre
	from SNegocios
	where SNcodigo=1
</cfquery>

<form name="form1" method="post">
<cf_sifsociosnegociosFA query="#data#">
</form>

</body>
</html>
