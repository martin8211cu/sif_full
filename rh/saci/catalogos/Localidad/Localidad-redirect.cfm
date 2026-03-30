<cfset params="">
<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>
<cfif isdefined("Form.MaxRows") and Len(Trim(Form.MaxRows))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "MaxRows=" & Form.MaxRows>
</cfif>
<cfif isdefined("Form.filtro_LCcod") and Len(Trim(Form.filtro_LCcod))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_LCcod=" & Form.filtro_LCcod>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_LCcod=" & Form.filtro_LCcod>
</cfif>
<cfif isdefined("Form.filtro_LCnombre") and Len(Trim(Form.filtro_LCnombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_LCnombre=" & Form.filtro_LCnombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_LCnombre=" & Form.filtro_LCnombre>
</cfif>
<cfif isdefined("Form.filtro_DPnombre") and Len(Trim(Form.filtro_DPnombre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_DPnombre=" & Form.filtro_DPnombre>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_DPnombre=" & Form.filtro_DPnombre>
</cfif>

<cfif not IsDefined("form.Nuevo") and not IsDefined("form.Baja")>
	<cfif isdefined("Form.LCid") and Len(Trim(Form.LCid))>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "LCid=" & Form.LCid>
	</cfif>
</cfif>
<cfif isdefined("Form.Pagina2") and Len(Trim(Form.Pagina2))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina2=" & Form.Pagina2>
</cfif>
<cfif isdefined("Form.filtro_LCcodb") and Len(Trim(Form.filtro_LCcodb))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_LCcodb=" & Form.filtro_LCcodb>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_LCcodb=" & Form.filtro_LCcodb>
</cfif>
<cfif isdefined("Form.LCidPadre") and Len(Trim(Form.LCidPadre))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "LCidPadre=" & Form.LCidPadre>
</cfif>
<cfif isdefined("Form.filtro_LCnombreb") and Len(Trim(Form.filtro_LCnombreb))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_LCnombreb=" & Form.filtro_LCnombreb>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_LCnombreb=" & Form.filtro_LCnombreb>
</cfif>

<cfif IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "btnNuevo=btnNuevo">
</cfif>
<cfif isdefined('form.modoLoc') and form.modoLoc NEQ ''>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "modoLoc=" & Form.modoLoc>	
</cfif>

<cfset location = "Localidad.cfm">
<cfset Request.Error.Url="#location#">

<cflocation url="#location##params#">
