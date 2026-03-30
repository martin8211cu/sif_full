<!--- <cfset mixml=StructNew()> --->
<title>Reportes SIF</title>
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">
<cfparam name="url.Conexion" default="#session.DSN#">
<cfparam name="url.FMT01COD" default="">

<cfif Len(Trim(url.Ecodigo)) EQ 0>
	<cflocation addtoken="no" url="../errorPages/BDerror.cfm?errMsg=No tiene sesión. Proceso Cancelado!.">
<cfelseif Len(Trim(url.Conexion)) EQ 0>	
	<cflocation addtoken="no" url="../errorPages/BDerror.cfm?errMsg=No tiene conexión con la Base de  datos! Proceso Cancelado.">
<cfelseif Len(Trim(url.FMT01COD)) EQ 0>	
	<cflocation addtoken="no" url="../errorPages/BDerror.cfm?errMsg=Debe de indicar el código del Reporte que desea visualizar.">
<cfelse>	
	<cfset LvarParamsRep = "">
	<cfloop collection="#url#" item="LvarIndex">
		<cfset LvarIndex = ucase(LvarIndex)>
		<cfif LvarIndex NEQ "ECODIGO" AND LvarIndex NEQ "CONEXION" AND LvarIndex NEQ "FMT01COD" AND url[LvarIndex] NEQ "">
			<cfset LvarParamsRep = LvarParamsRep & LvarIndex & "=" & url[LvarIndex] & "&">
		</cfif>
	</cfloop>

	<cfif LvarParamsRep EQ "">
		<cflocation addtoken="no" url="../errorPages/BDerror.cfm?errMsg=No se han definido los parámetros del Reporte quye desea consultar. Proceso Cancelado!.">
	<cfelse>	
		<cfinvoke 
		 component="sif.Componentes.pGenReportesCarta"
		 method="TirarReporte">
			<cfinvokeargument name="Ecodigo" value="#url.Ecodigo#"/>
			<cfinvokeargument name="Conexion" value="#url.Conexion#"/>
			<cfinvokeargument name="FMT01COD" value="#url.FMT01COD#"/>
			<cfinvokeargument name="paramsRep" value="#LvarParamsRep#"/>
		</cfinvoke>
	</cfif>
</cfif>
