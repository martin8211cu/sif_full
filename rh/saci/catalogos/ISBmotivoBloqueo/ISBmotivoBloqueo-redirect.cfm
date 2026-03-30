<cfset params="">
<cfset location = "ISBmotivoBloqueo.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>

<cfif isdefined("Form.filtro_MBdescripcion") and Len(Trim(Form.filtro_MBdescripcion))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_MBdescripcion=" & Form.filtro_MBdescripcion>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_MBdescripcion=" & Form.filtro_MBdescripcion>	
</cfif>		
<cfif isdefined("Form.filtro_HabilitadoDesc") and Len(Trim(Form.filtro_HabilitadoDesc))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_HabilitadoDesc=" & Form.filtro_HabilitadoDesc>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_HabilitadoDesc=" & Form.filtro_HabilitadoDesc>	
</cfif>
<cfif isdefined("Form.filtro_MBconCompromisoImg") and Len(Trim(Form.filtro_MBconCompromisoImg))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_MBconCompromisoImg=" & Form.filtro_MBconCompromisoImg>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_MBconCompromisoImg=" & Form.filtro_MBconCompromisoImg>	
</cfif>
<cfif isdefined("Form.filtro_MBautogestionImg") and Len(Trim(Form.filtro_MBautogestionImg))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_MBautogestionImg=" & Form.filtro_MBautogestionImg>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_MBautogestionImg=" & Form.filtro_MBautogestionImg>	
</cfif>
<cfif isdefined("Form.filtro_MBdesbloqueableImg") and Len(Trim(Form.filtro_MBdesbloqueableImg))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_MBdesbloqueableImg=" & Form.filtro_MBdesbloqueableImg>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_MBdesbloqueableImg=" & Form.filtro_MBdesbloqueableImg>	
</cfif>

<cfif not IsDefined("form.Regresar") and not isdefined('form.Baja')>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "MBmotivo="& Form.MBmotivo>
	<cfset location = "ISBmotivoBloqueo-edit.cfm">
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">