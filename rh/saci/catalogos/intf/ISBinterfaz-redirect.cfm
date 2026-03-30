<cfset params="">
<cfset location = "ISBinterfaz-edit.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>

<cfif isdefined("Form.filtro_interfaz") and Len(Trim(Form.filtro_interfaz))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_interfaz=" & Form.filtro_interfaz>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_interfaz=" & Form.filtro_interfaz>	
</cfif>		
<cfif isdefined("Form.filtro_S02ACC") and Len(Trim(Form.filtro_S02ACC))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_S02ACC=" & Form.filtro_S02ACC>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_S02ACC=" & Form.filtro_S02ACC>	
</cfif>		
<cfif isdefined("Form.filtro_nombreInterfaz") and Len(Trim(Form.filtro_nombreInterfaz))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_nombreInterfaz=" & Form.filtro_nombreInterfaz>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_nombreInterfaz=" & Form.filtro_nombreInterfaz>	
</cfif>
<cfif isdefined("Form.filtro_componente") and Len(Trim(Form.filtro_componente))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_componente=" & Form.filtro_componente>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_componente=" & Form.filtro_componente>	
</cfif>
<cfif isdefined("Form.filtro_metodo") and Len(Trim(Form.filtro_metodo))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_metodo=" & Form.filtro_metodo>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_metodo=" & Form.filtro_metodo>	
</cfif>

<cfif not IsDefined("form.Regresar") and not IsDefined("form.Baja") and not IsDefined("form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "interfaz="& Form.interfaz>
<cfelse>
	<cfif not IsDefined("form.Nuevo")>
		<cfset location = "ISBinterfaz.cfm">	
	</cfif>
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">