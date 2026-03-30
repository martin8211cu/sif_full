<cfset params="">

<cfif isdefined("Form.Pquien_CT") and Len(Trim(Form.Pquien_CT))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pqc=" & Form.Pquien_CT>
<cfelseif isdefined("Form.pqc") and Len(Trim(Form.pqc))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pqc=" & Form.pqc>
</cfif>

<cfif isdefined("Form.CTid") and Len(Trim(Form.CTid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cue=" & Form.CTid>
<cfelseif isdefined("Form.cue") and Len(Trim(Form.cue))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cue=" & Form.cue>
</cfif>

<cfif isdefined("Form.Contratoid") and Len(Trim(Form.Contratoid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pkg=" & Form.Contratoid>
<cfelseif isdefined("Form.pkg") and Len(Trim(Form.pkg))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "pkg=" & Form.pkg>
</cfif>

<cfif isdefined("Form.LGnumero") and Len(Trim(Form.LGnumero))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "logg=" & Form.LGnumero>
<cfelseif isdefined("Form.logg") and Len(Trim(Form.logg))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "logg=" & Form.logg>
</cfif>

<cfif isdefined("Form.cliente") and Len(Trim(Form.cliente))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cli=" & Form.cliente>
<cfelseif isdefined("Form.cli") and Len(Trim(Form.cli))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cli=" & Form.cli>
</cfif>

<cfif isdefined("Form.lpaso") and Len(Trim(Form.lpaso))>	<!---paso para el menu de logines --->
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "lpaso=" & Form.lpaso>
<cfelseif isdefined("url.lpaso") and Len(Trim(url.lpaso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "lpaso=" & url.lpaso>
</cfif>

<cfif isdefined("Form.cpaso") and Len(Trim(Form.cpaso))>	<!---paso para el menu en cuentas --->
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cpaso=" & Form.cpaso>
<cfelseif isdefined("url.cpaso") and Len(Trim(url.cpaso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cpaso=" & url.cpaso>
</cfif>

<cfif isdefined("Form.csub") and Len(Trim(Form.csub))>		<!---sub-paso para el menu en cuentas en el paso 3 (forma de cobro)--->
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "csub=" & Form.csub>
<cfelseif isdefined("url.csub") and Len(Trim(url.csub))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "csub=" & url.csub>
</cfif>

<cfif isdefined("Form.ppaso") and Len(Trim(Form.ppaso))>	<!---paso para el menu de productos(paquetes) --->
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "ppaso=" & Form.ppaso>
<cfelseif isdefined("url.ppaso") and Len(Trim(url.ppaso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "ppaso=" & url.ppaso>
</cfif>

<cfif isdefined("Form.cpass") and Len(Trim(Form.cpass))>	<!--- Cambio de Passwords--->
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cpass=" & Form.cpass>
<cfelseif isdefined("url.cpass") and Len(Trim(url.cpass))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "cpass=" & url.cpass>
</cfif>

<cfif isdefined("Form.tab") and Len(Trim(Form.tab))>		<!--- Tab para los datos del cliente(datos generales, representantes, Usuario saci)--->
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "tab=" & Form.tab>
<cfelseif isdefined("url.tab") and Len(Trim(url.tab))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "tab=" & url.tab>
</cfif>

<cfif isdefined("Form.adser") and Len(Trim(Form.adser))>	<!--- Agregar servicios (funciona como indicador de paso)--->
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "adser=" & Form.adser>
<cfelseif isdefined("url.adser") and Len(Trim(url.adser))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "adser=" & url.adser>
</cfif>

<cfif isdefined("Form.recarga") and Len(Trim(Form.recarga))>	<!--- Recarga de prepago (funciona como indicador de paso)--->
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "recarga=" & Form.recarga>
<cfelseif isdefined("url.recarga") and Len(Trim(url.recarga))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "recarga=" & url.recarga>
</cfif>

<cfif isdefined("ExtraParams") and Len(Trim(ExtraParams))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?"))& ExtraParams>
</cfif>

<cfset location = "gestion.cfm">
<cfset Request.Error.Url="#location#">

<cflocation url="#location##params#">
