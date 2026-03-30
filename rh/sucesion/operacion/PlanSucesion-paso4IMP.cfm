<html>
<head>
<title>Recuros Humanos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfset vsFiltro = ''>
<cfif isdefined("form.DEid") and Len(Trim(form.DEid)) NEQ 0>   		
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "DEid=" & form.DEid>
</cfif>
<cfif isdefined("form.paso") and Len(Trim(form.paso)) NEQ 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "paso=" & form.paso>
</cfif>	
<cfif isdefined("form.ext") and Len(Trim(form.ext)) NEQ 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "ext=" & form.ext>
</cfif>
<cf_rhimprime datos="/rh/sucesion/consultas/PlanSucesion-paso4.cfm" paramsuri="&RHPcodigo=#form.RHPcodigo#&#vsFiltro#"> 
<form name="form1">
	<cf_sifHTML2Word>
	<table width="98%">
		<tr><td><cfinclude template="PlanSucesion-paso4.cfm"></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><input type="button" value="Regresar" onClick="javascript: history.back();"></td></tr>
	</table>
	</cf_sifHTML2Word>
</form>
</body>
</html>