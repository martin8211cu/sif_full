<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body> 
<cfparam name="Session.Hola1" default="0">
<cfset cualq = Session.Hola1>

<cfoutput>
<form name="prueba" action="Fomr2.cfm" method="post">
	<p>
      <input name="Hola1_1" value="#cualq#">
      <br>
      <input name="Hola1_2" value="1|2">
      <br>
      <input name="Hola2_1" value="2|1">
      <br>
      <input name="Hola2_2" value="2|2">
    </p>
    <p> 
      <input type="text" name="oscar">
      <input type="text" name="oscar">
      <input type="text" name="oscar">
      <br>
      <input type="submit" value="Aceptar" name="Aceptar">
    </p>
  </form>
</cfoutput>
</body>
</html>
