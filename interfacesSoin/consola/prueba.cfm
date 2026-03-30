<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>
<cfif isdefined("form.btnAplicar")>
	RESULTADO APLICACION DOCUMENTO <cfoutput>#form.Doc#</cfoutput><BR>
	<cfstoredproc procedure="EJEMPLO_INTERFAZ" datasource="sifInterfaces">
		<cfprocparam cfsqltype="cf_sql_varchar" value="#form.txtMoneda#">
		<cfprocparam cfsqltype="cf_sql_money" value="#form.txtMonto#">
	</cfstoredproc>
	<cfquery name="rsSQL" datasource="sifInterfaces">
		select * 
		  from Documento 
		 where Numero = #form.doc#
	</cfquery>
	<cfdump var="#rsSQL#">
	<BR><BR><BR>
	==========================================================================
</cfif>
<cfquery name="rsSQL" datasource="sifInterfaces">
	SELECT COALESCE(MAX(NUMERO),0)+1 as DOC FROM DOCUMENTO
</cfquery>
<cfset LvarDOC = rsSQL.DOC>
<cfquery datasource="sifInterfaces">
	INSERT INTO DOCUMENTO (NUMERO, APLICADO) VALUES (#LvarDOC#,0)
</cfquery>
<form method="post" action="prueba.cfm">
	DOCUMENTO: <cfoutput><strong>#LvarDoc#</strong>
	<input type="hidden" name="Doc" value="#LvarDoc#"></cfoutput> 
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
	Moneda: <input type="text" name="txtMoneda" value="CRC" size="3">&nbsp;&nbsp;&nbsp;
	Monto: <input type="text" name="txtMonto" value="10000000"><BR>
	<input type="submit" name="btnAplicar" value="APLICAR">
</form>
</body>
</html>
