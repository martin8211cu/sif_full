<!--- Campos del filtro para la lista de alumnos --->
<cfset tabChoice = 1>

<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>

<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
<cfelse>
	<cfset tabChoice = 1>
</cfif>

<cfset filtroTab = "">
<cfif isdefined('form.Pagina')>
	<cfset filtroTab = filtroTab & Iif(Len(Trim(filtroTab)) NEQ 0, DE("&"), DE("")) & "Pagina=" &form.Pagina>				
</cfif>
<cfif isdefined('form.Filtro_Estado')>
	<cfset filtroTab = filtroTab & Iif(Len(Trim(filtroTab)) NEQ 0, DE("&"), DE("")) & "Filtro_Estado=" &form.Filtro_Estado>				
</cfif>
<cfif isdefined('form.Filtro_Grado')>
	<cfset filtroTab = filtroTab & Iif(Len(Trim(filtroTab)) NEQ 0, DE("&"), DE("")) & "Filtro_Grado=" &form.Filtro_Grado>	
</cfif>
<cfif isdefined('form.Filtro_Ndescripcion')>
	<cfset filtroTab = filtroTab & Iif(Len(Trim(filtroTab)) NEQ 0, DE("&"), DE("")) & "Filtro_Ndescripcion=" &form.Filtro_Ndescripcion>
</cfif>
<cfif isdefined('form.Filtro_Nombre')>
	<cfset filtroTab = filtroTab & Iif(Len(Trim(filtroTab)) NEQ 0, DE("&"), DE("")) & "Filtro_Nombre=" &form.Filtro_Nombre>
</cfif>
<cfif isdefined('form.Filtro_Pid')>
	<cfset filtroTab = filtroTab & Iif(Len(Trim(filtroTab)) NEQ 0, DE("&"), DE("")) & "Filtro_Pid=" &form.Filtro_Pid>
</cfif>
<cfif isdefined('form.NoMatr')>
	<cfset filtroTab = filtroTab & Iif(Len(Trim(filtroTab)) NEQ 0, DE("&"), DE("")) & "NoMatr=" &form.NoMatr>
</cfif>


<cfset tabNames = ArrayNew(1)>
<cfset tabNames[1] = "Datos Alumno">
<cfset tabNames[2] = "Expediente Médico">
<cfset tabNames[3] = "Datos Encargado">

<cfset tabLinks = ArrayNew(1)>
<cfset tabLinks[1] = "alumno.cfm?o=1">
<cfset tabLinks[2] = "alumno.cfm?o=2">
<cfset tabLinks[3] = "alumno.cfm?o=3">

<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "Informaci&oacute;n personal por Alumno">
<cfset tabStatusText[2] = "Expediente Médico por Alumno">
<cfset tabStatusText[3] = "Datos del Encargado por Alumno">
<!---
validar la seguridad

<cfset tabAccess = ArrayNew(1)>
<cfset proceso = Trim(Replace(cgi.SCRIPT_NAME,'/cfmx','','one')) >
<cfif  Session.Params.ModoDespliegue EQ 0>
	<cfset tabAccess[1] = true>
	<cfset tabAccess[2] = true>
	<cfset tabAccess[3] = true>
</cfif>

<cfif not tabAccess[tabChoice]>
	<cfloop from="1" to="#ArrayLen(tabAccess)#" index="i">
		<cfif tabAccess[i]>
			<cfset tabChoice = i>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>
--->
<!--- <cfparam name="tabChoice" default="1">

<cfset tabNames = ArrayNew(1)>
<cfset tabNames[1] = "Datos Alumno">
<cfset tabNames[2] = "Expediente Médico">
<cfset tabNames[3] = "Datos Encargado">

<cfset tabLinks = ArrayNew(1)>
<!--- Se utiliza cuando el que consulta es el administrador --->
 <cfif isdefined("form.persona") and len(trim(form.persona)) neq 0> 
	<script language="JavaScript" type="text/javascript">
		function gotoTab(tab) {
			document.regAlum.o.value = tab;
			document.regAlum.persona.value = '<cfoutput>#form.persona#</cfoutput>';
			document.regAlum.submit();
		}
	</script>

	<cfset tabLinks[1] = "alumno.cfm?o=1&" & #filtroTab#>
	<cfset tabLinks[2] = "alumno.cfm?o=2&" & #filtroTab#>
	<cfset tabLinks[3] = "alumno.cfm?o=3&" & #filtroTab#>

<!--- Se utiliza cuando el que consulta es el empleado --->
<cfelse >
	<cfset tabLinks[1] = "alumno.cfm?o=1">
	<cfset tabLinks[2] = "alumno.cfm?o=2">
	<cfset tabLinks[3] = "alumno.cfm?o=3">
</cfif> 
<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "">
<cfset tabStatusText[2] = "">
<cfset tabStatusText[3] = "">
 --->