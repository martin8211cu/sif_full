<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
	<cfdump var="#Form#">
	<cfloop collection="#Form#" item="i">
		<cfoutput>#i#</cfoutput>
	</cfloop>
<form name="form1" method="post" action="">
  <p>
    <input name="Splaza1" type="text" id="Splaza1">
  </p>
  <p> 
    <input name="Splaza12" type="text" id="Splaza12">
  </p>
  <p>
    <input type="submit" name="Submit" value="Submit">
  </p>
</form>
</body>
</html>
