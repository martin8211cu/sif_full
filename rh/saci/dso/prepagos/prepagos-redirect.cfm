<cfset params="">
<cfset location = "prepagos.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>
<cfif isdefined("Form.filtro_TJlogin") and Len(Trim(Form.filtro_TJlogin))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_TJlogin=" & Form.filtro_TJlogin>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_TJlogin=" & Form.filtro_TJlogin>	
</cfif>		
<cfif isdefined("Form.filtro_descTJestado") and Len(Trim(Form.filtro_descTJestado))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_descTJestado=" & Form.filtro_descTJestado>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_descTJestado=" & Form.filtro_descTJestado>	
</cfif>
<cfif isdefined("Form.filtro_nombreAgente") and Len(Trim(Form.filtro_nombreAgente))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_nombreAgente=" & Form.filtro_nombreAgente>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_nombreAgente=" & Form.filtro_nombreAgente>	
</cfif>
<cfif isdefined("Form.filtro_TJuso") and Len(Trim(Form.filtro_TJuso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_TJuso=" & Form.filtro_TJuso>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_TJuso=" & Form.filtro_TJuso>	
</cfif>
<cfif isdefined("Form.filtro_TJvigencia") and Len(Trim(Form.filtro_TJvigencia))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_TJvigencia=" & Form.filtro_TJvigencia>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_TJvigencia=" & Form.filtro_TJvigencia>	
</cfif>

<cfif not IsDefined("form.Regresar") and not isdefined('form.masivo')>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "TJid="& Form.TJid>
	<cfset location = "prepagos-edit.cfm">
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">