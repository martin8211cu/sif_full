
<cfset tabChoice = 1>

<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>

<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
<cfelse>
	<cfset tabChoice = 1>
</cfif>

<cfset tabNames = ArrayNew(1)>
<cfset tabNames[1] = "Datos Personales">
<cfset tabNames[2] = "Datos Experiencia Laboral">
<cfset tabNames[3] = "Educaci&oacute;n y Capacitaci&oacute;n">
<cfset tabNames[4] = "Participaci&oacute;n en Consursos">
<!--- <cfset tabNames[8] = "Vacaciones"> --->

<cfset tabLinks = ArrayNew(1)>
<cfif isdefined("form.RHCconcurso")>
	<cfset tabLinks[1] = "OferenteExterno.cfm?o=1&sel=1&RHCconcurso=" & Form.RHCconcurso & "&RegCon=true">
	<cfset tabLinks[2] = "OferenteExterno.cfm?o=2&sel=1&RHCconcurso=" & Form.RHCconcurso & "&RegCon=true">
	<cfset tabLinks[3] = "OferenteExterno.cfm?o=3&sel=1&RHCconcurso=" & Form.RHCconcurso & "&RegCon=true">
	<cfset tabLinks[4] = "OferenteExterno.cfm?o=4&sel=1&RHCconcurso=" & Form.RHCconcurso & "&RegCon=true">
<cfelse>
	<cfset tabLinks[1] = "OferenteExterno.cfm?o=1&sel=1">
	<cfset tabLinks[2] = "OferenteExterno.cfm?o=2&sel=1">
	<cfset tabLinks[3] = "OferenteExterno.cfm?o=3&sel=1">	
	<cfset tabLinks[4] = "OferenteExterno.cfm?o=4&sel=1">		
</cfif>


<!--- <cfset tabLinks[8] = "OferenteExterno.cfm?o=8&sel=1"> --->

<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "Informaci&oacute;n personal por oferente">
<cfset tabStatusText[2] = "Datos de la experiencia laboral por oferente">
<cfset tabStatusText[3] = "Educaci&oacute;n y capacitaci&oacute;n del empleado">
<cfset tabStatusText[4] = "Participaci&oacute;n en Consursos">
<!--- <cfset tabStatusText[8] = "Vacaciones del empleado seleccionado"> --->

<!---
validar la seguridad
--->
<cfset tabAccess = ArrayNew(1)>
<cfset proceso = Trim(Replace(cgi.SCRIPT_NAME,'/cfmx','','one')) >
<cfif  Session.Params.ModoDespliegue EQ 1>
	<cfset tabAccess[1] = true>
	<cfset tabAccess[2] = true>
	<cfset tabAccess[3] = true>
	<cfset tabAccess[4] = true>	
	<!--- <cfset tabAccess[8] = true> --->
<cfelse>
	<cfset tabAccess[1] = acceso_uri(proceso & '/dp')>
	<cfset tabAccess[2] = acceso_uri(proceso & '/df')>
	<cfset tabAccess[3] = acceso_uri(proceso & '/an')>
	<cfset tabAccess[4] = acceso_uri(proceso & '/pc')>
	<!--- <cfset tabAccess[8] = acceso_uri(proceso & '/va')> --->
</cfif>

<cfif not tabAccess[tabChoice]>
	<cfloop from="1" to="#ArrayLen(tabAccess)#" index="i">
		<cfif tabAccess[i]>
			<cfset tabChoice = i>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>