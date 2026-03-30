<cfset params="">
<cfif isdefined("Form.paso") and Len(Trim(Form.paso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "paso=" & Form.paso>
</cfif>
<cfif isdefined("Form.pagina") and Len(Trim(Form.pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pagina=" & Form.pagina>
</cfif>
<cfif isdefined("Form.Filtro_MDref") and Len(Trim(Form.Filtro_MDref))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Filtro_MDref=" & Form.Filtro_MDref>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hFiltro_MDref=" & Form.Filtro_MDref>	
</cfif>
<cfif isdefined("Form.Filtro_Limite") and Len(Trim(Form.Filtro_Limite))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Filtro_Limite=" & Form.Filtro_Limite>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hFiltro_Limite=" & Form.Filtro_Limite>	
</cfif>
<cfif isdefined("Form.Filtro_Saldo") and Len(Trim(Form.Filtro_Saldo))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Filtro_Saldo=" & Form.Filtro_Saldo>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hFiltro_Saldo=" & Form.Filtro_Saldo>	
</cfif>
<cfif isdefined("Form.Filtro_Uso") and Len(Trim(Form.Filtro_Uso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Filtro_Uso=" & Form.Filtro_Uso>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hFiltro_Uso=" & Form.Filtro_Uso>	
</cfif>

<cfif not IsDefined("form.Bloquear") 
	and not isdefined('form.btnDesbloquear') 
	and not isdefined('form.Baja')
	and not isdefined('form.Nuevo')>
	<cfif isdefined("Form.MDref") and Len(Trim(Form.MDref))>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "MDref=" & Form.MDref>
	</cfif>
</cfif>

<cfset location = "u900.cfm">
<cfset Request.Error.Url="#location#">

<cflocation url="#location##params#">
