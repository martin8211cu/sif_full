<!--- =============================== --->
<!--- TRADUCCION --->
<!--- =============================== --->
<!--- TABS --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Datos_Personales"
	Default="Datos Personales"
	returnvariable="vDatosPersonales"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Anualidades"
	Default="Anualidades"
	returnvariable="vAnualidades"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Datos_Familiares"
	Default="Datos Familiares"
	returnvariable="vDatosFamiliares"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Anotaciones"
	Default="Anotaciones"
	returnvariable="vAnotaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Datos_Laborales"
	Default="Datos Laborales"
	returnvariable="vDatosLaborales"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Acciones"
	Default="Acciones"
	returnvariable="vAcciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Cargas"
	Default="Cargas"
	returnvariable="vCargas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Deducciones"
	Default="Deducciones"
	returnvariable="vDeducciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Vacaciones"
	Default="Vacaciones"
	returnvariable="vVacaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_DatosAsociado"
	Default="Datos Asociado"
	returnvariable="vDatosAsociado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="Direccion"
	Default="Dirección"
	returnvariable="vDireccion"/>
		
<!--- Descripciones de TABS --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Datos_Personales"
	Default="Informaci&oacute;n personal por empleado"
	returnvariable="vDatosPersonalesDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Anualidades"
	Default="Informaci&oacute;n sobre las anualidades del Empleado"
	returnvariable="vAnualidadesDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Datos_Familiares"
	Default="Datos de los familiares por empleado"
	returnvariable="vDatosFamiliaresDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Anotaciones"
	Default="Anotaciones positivas y negativas del expediente del empleado"
	returnvariable="vAnotacionesDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Datos_Laborales"
	Default="Anotaciones laborales del empleado seleccionado"
	returnvariable="vDatosLaboralesDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Acciones"
	Default="Acciones de personal realizadas al empleado seleccionado"
	returnvariable="vAccionesDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Cargas"
	Default="Cargas sociales aplicadas al empleado seleccionado"
	returnvariable="vCargasDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Deducciones"
	Default="Deducciones laborales aplicadas al empleado seleccionado"
	returnvariable="vDeduccionesDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Vacaciones"
	Default="Vacaciones del empleado seleccionado"
	returnvariable="vVacacionesDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_DatosAsociado"
	Default="Datos Asociado del empleado seleccionado"
	returnvariable="vDatosAsociadoDesc"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Archivos"
	Default="Archivos"
	returnvariable="MSG_Archivos"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="vArchAsociadoDesc"
	Default="Archivos Asociado del empleado seleccionado"
	returnvariable="vArchAsociadoDesc"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="Direccion"
	Default="Dirección"
	returnvariable="vDireccionDesc"/>	
	
<!--- =============================== --->
<!--- =============================== --->

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
<cfset tabNames[1] = "#vDatosPersonales#">
<cfset tabNames[2] = "#vDireccion#" >
<cfset tabNames[3] = "#vDatosFamiliares#">
<cfset tabNames[4] = "#vAnotaciones#">
<cfset tabNames[5] = "#vDatosLaborales#">
<cfset tabNames[6] = "#vAcciones#">
<cfset tabNames[7] = "#vCargas#">
<cfset tabNames[8] = "#vDeducciones#">
<cfset tabNames[9] = "#vVacaciones#" >
<cfset tabNames[10] = "#MSG_Archivos#" >
<cfset tabNames[12] = "#vDatosAsociado#" >
<cfset tabNames[11] = "#vAnualidades#" >


<cfset tabLinks = ArrayNew(1)>
<cfset tabLinks[1] = "expediente-cons.cfm?o=1&sel=1">
<cfset tabLinks[2] = "expediente-cons.cfm?o=2&sel=1">
<cfset tabLinks[3] = "expediente-cons.cfm?o=3&sel=1">
<cfset tabLinks[4] = "expediente-cons.cfm?o=4&sel=1">
<cfset tabLinks[5] = "expediente-cons.cfm?o=5&sel=1">
<cfset tabLinks[6] = "expediente-cons.cfm?o=6&sel=1">
<cfset tabLinks[7] = "expediente-cons.cfm?o=7&sel=1">
<cfset tabLinks[8] = "expediente-cons.cfm?o=8&sel=1">
<cfset tabLinks[9] = "expediente-cons.cfm?o=9&sel=1">
<cfset tabLinks[10] = "expediente-cons.cfm?o=10&sel=1">
<cfset tabLinks[11] = "expediente-cons.cfm?o=11&sel=1">
<cfset tabLinks[12] = "expediente-cons.cfm?o=12&sel=1">


<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "#vDatosPersonalesDesc#">
<cfset tabStatusText[2] = "#vDireccionDesc#">
<cfset tabStatusText[3] = "#vDatosFamiliaresDesc#">
<cfset tabStatusText[4] = "#vAnotacionesDesc#">
<cfset tabStatusText[5] = "#vDatosLaboralesDesc#">
<cfset tabStatusText[6] = "#vAccionesDesc#">
<cfset tabStatusText[7] = "#vCargasDesc#">
<cfset tabStatusText[8] = "#vDeduccionesDesc#">
<cfset tabStatusText[9] = "#vVacacionesDesc#">
<cfset tabStatusText[10] = "#vArchAsociadoDesc#">
<cfset tabStatusText[12] = "#vDatosAsociadoDesc#">
<cfset tabStatusText[11] = "#vAnualidadesDesc#">


<!---
validar la seguridad
--->




<cfset tabAccess = ArrayNew(1)>
<cfset proceso = Trim(Replace(cgi.SCRIPT_NAME,'/cfmx','','one')) >


<cfif  Session.Params.ModoDespliegue EQ 0>
	<cfset tabAccess[1] = true>
	<cfset tabAccess[2] = true>
	<cfset tabAccess[3] = true>
	<cfset tabAccess[4] = true>
	<cfset tabAccess[5] = true>
	<cfset tabAccess[6] = true>
	<cfset tabAccess[7] = true>
	<cfset tabAccess[8] = true>
	<cfset tabAccess[9] = true>
	<cfset tabAccess[10] = true>
	<cfset tabAccess[11] = true>
	<cfset tabAccess[12] = true>
<cfelse>
	<cfset tabAccess[1] = acceso_uri(proceso & '/dp')>
	<cfset tabAccess[2] = acceso_uri(proceso & '/di')>
	<cfset tabAccess[3] = acceso_uri(proceso & '/df')>
	<cfset tabAccess[4] = acceso_uri(proceso & '/an')>
	<cfset tabAccess[5] = acceso_uri(proceso & '/dl')>
	<cfset tabAccess[6] = acceso_uri(proceso & '/ac')>
	<cfset tabAccess[7] = acceso_uri(proceso & '/ca')>
	<cfset tabAccess[8] = acceso_uri(proceso & '/de')>
	<cfset tabAccess[9] = acceso_uri(proceso & '/va')>
	<cfset tabAccess[12] = acceso_uri(proceso & '/da')>
	<cfset tabAccess[10] = true>
	<cfset tabAccess[11] = true>
</cfif>


<cfif not tabAccess[tabChoice]>
	<cfloop from="1" to="#ArrayLen(tabAccess)#" index="i">
		<cfif tabAccess[i]>
			<cfset tabChoice = i>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>


