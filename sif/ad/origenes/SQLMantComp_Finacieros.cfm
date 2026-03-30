<cfif isdefined("Form.Alta") and len(trim(form.Alta))>
	
	<cf_sifcomplementofinanciero action='update'
		tabla="#form.OPtabla#"
		llave="#form.ODchar#" />
	<center>	
<cfelseif isdefined("Form.Baja") and len(trim(form.Baja))>

	<cf_sifcomplementofinanciero action='delete'
		tabla="#form.OPtabla#"
		llave="#form.ODchar#" />
	<center>	
</cfif>

<form action="Comp_Finacieros.cfm" method="post" name="sql">
<cfoutput>
	<input type="hidden" name="OPtabla_F" value="#form.OPtabla#">
	<input type="hidden" name="ODchar_F" value="#form.ODchar#">
</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
