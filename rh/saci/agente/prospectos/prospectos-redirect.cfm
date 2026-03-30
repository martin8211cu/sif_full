<cfset params="">
<cfset location = "prospectos.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>
<cfif isdefined("Form.filtro_Pid") and Len(Trim(Form.filtro_Pid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_Pid=" & Form.filtro_Pid>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_Pid=" & Form.filtro_Pid>
</cfif>
<cfif isdefined("Form.filtro_nombre") and Len(Trim(Form.filtro_nombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_nombre=" & Form.filtro_nombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_nombre=" & Form.filtro_nombre>
</cfif>
<cfif isdefined("Form.Registrar")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "prospecto=1">	
	<cfif isdefined("form.Pquien_Ant") and Len(Trim(form.Pquien_Ant))>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pq=" & form.Pquien_Ant>
	</cfif>
	<cfset location = "/cfmx/saci/vendedor/venta/venta.cfm">
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">