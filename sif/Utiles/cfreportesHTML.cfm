<cfsetting enablecfoutputonly="yes">
<!--- <cfset mixml=StructNew()> --->
<cfparam name="url.Ecodigo" default="">
<cfparam name="url.Conexion" default="">
<cfparam name="url.FMT01COD" default="">
<cfparam name="url.paramsRep" default="">

<cfif Len(Trim(url.Ecodigo)) EQ 0>
	<cflocation addtoken="no" url="../errorPages/BDerror.cfm?errMsg=No tiene sesión. Proceso Cancelado!.">
<cfelseif Len(Trim(url.Conexion)) EQ 0>	
	<cflocation addtoken="no" url="../errorPages/BDerror.cfm?errMsg=No tiene conexión con la Base de  datos! Proceso Cancelado.">
<cfelseif Len(Trim(url.FMT01COD)) EQ 0>	
	<cflocation addtoken="no" url="../errorPages/BDerror.cfm?errMsg=Debe de indicar el código del Reporte que desea visualizar.">
<cfelseif Len(Trim(url.paramsRep)) EQ 0>	
	<cflocation addtoken="no" url="../errorPages/BDerror.cfm?errMsg=No se han definido los parámetros del Reporte quye desea consultar. Proceso Cancelado!.">
<cfelse>	
	<cfinvoke 
	 component="sif.Componentes.pGenReportesHTML"
	 method="TirarReporte"
	 returnvariable="mixml">
		<cfinvokeargument name="Ecodigo" value="#url.Ecodigo#"/>
		<cfinvokeargument name="Conexion" value="#url.Conexion#"/>
		<cfinvokeargument name="FMT01COD" value="#url.FMT01COD#"/>
		<cfinvokeargument name="paramsRep" value="#url.paramsRep#"/>
		<cfinvokeargument name="html" value="0"/>
		<cfinvokeargument name="debug" value="0"/>
	</cfinvoke>
</cfif>
<cfoutput>#mixml.html#</cfoutput>
<!--- Salida de datos 
<cfdump var="#mixml#">
--->


