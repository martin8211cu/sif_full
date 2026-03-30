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
	key="LB_Datos_Familiares"
	Default="Datos Familiares"
	returnvariable="vDatosFamiliares"/>

<!--- Descripciones de TABS --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Datos_Personales"
	Default="Informaci&oacute;n personal por Jugador"
	returnvariable="vDatosPersonalesDesc"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Datos_Familiares"
	Default="Datos de los familiares por Jugador"
	returnvariable="vDatosFamiliaresDesc"/>

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
<cfset tabNames[2] = "#vDatosFamiliares#">

<cfset tabLinks = ArrayNew(1)>
<cfset tabLinks[1] = "expediente-cons.cfm?o=1&sel=1">
<cfset tabLinks[2] = "expediente-cons.cfm?o=2&sel=1">

<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "#vDatosPersonalesDesc#">
<cfset tabStatusText[2] = "#vDatosFamiliaresDesc#">

<!---
validar la seguridad
--->
<cfset tabAccess = ArrayNew(1)>
<cfset proceso = Trim(Replace(cgi.SCRIPT_NAME,'/cfmx','','one')) >

<cfif  Session.Params.ModoDespliegue EQ 0>
	<cfset tabAccess[1] = true>
	<cfset tabAccess[2] = true>

<cfelse>
	<cfset tabAccess[1] = acceso_uri(proceso & '/dp')>
	<cfset tabAccess[2] = acceso_uri(proceso & '/df')>

</cfif>

<cfif not tabAccess[tabChoice]>
	<cfloop from="1" to="#ArrayLen(tabAccess)#" index="i">
		<cfif tabAccess[i]>
			<cfset tabChoice = i>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

