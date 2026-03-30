<cfset varGEid = -1>
<cfif isdefined("url.GE")>
	<cfset LvarAction = '../../ce/GrupoEmpresas/generacion/GenerarXMLCuentasCE.cfm'>
	<cfset varGEid = url.GE>
</cfif>

<!---cfif isdefined("Form.friltrar")>
    <cfset filtro=''>
	<cfif #Form.selectMes# neq '0'>
		<cfset filtro = #filtro# & " and Mes = '#Form.selectMes#'">
	</cfif>
	<cfif #Form.selectPeriodo# neq '0'>
		<cfset filtro = #filtro# & " and Anio = '#Form.selectPeriodo#'">
	</cfif>
	<cfif #Form.selectEstatus# neq '0'>
		<cfset filtro = #filtro# & " and cex.Status = '#Form.selectEstatus#'">
	</cfif>
	<cfif #Form.CAgrupador# neq ''>
		<cfset filtro = #filtro# & " and cex.CAgrupador = '#Form.CAgrupador#'">
	</cfif>
</cfif>

<cfif isdefined("Form.btnEliminar")>
	<cfquery name="catalogo" datasource="#Session.DSN#">
		SELECT Id_XMLEnc FROM CEXMLEncabezadoCuentas WHERE CAgrupador = '#Form.CAgrupadorC#' AND Version = '#Form.VersionC#' AND Mes = '#Form.MesC#' AND Anio = #Form.AnioC#
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		DELETE FROM CEXMLDetalleCuentas WHERE Id_XMLEnc = #catalogo.Id_XMLEnc#
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		DELETE FROM CEXMLEncabezadoCuentas WHERE CAgrupador = '#Form.CAgrupadorC#' AND Version = '#Form.VersionC#' AND Mes = '#Form.MesC#' AND Anio = #Form.AnioC#
    </cfquery>
</cfif>

<cfset LvarAction = 'EliminarXMLCuentasCE.cfm'>
	<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
	    <cfoutput>
		    <cfif isdefined("Form.friltrar")>
		        <input type="hidden" name="filtro" value="#filtro#">
		        <input type="hidden" name="Mes" value="#Form.selectMes#">
		        <input type="hidden" name="Periodo" value="#Form.selectPeriodo#">
		        <input type="hidden" name="Estatus" value="#Form.selectEstatus#">
		        <input type="hidden" name="Id_Agrupador" value="#Form.Id_Agrupador#">
		        <input type="hidden" name="CAgrupador" value="#Form.CAgrupador#">
		        <input type="hidden" name="Descripcion" value="#Form.Descripcion#">
            </cfif>
	    </cfoutput>
    </form--->
<cfset LvarAction = '../consultas/ConsultarXMLCuentasCE.cfm'>
<cfif isdefined("url.GE") and url.GE EQ 1>
	<cfset LvarAction = '../../ce/GrupoEmpresas/consultas/ConsultarXMLCuentasCE.cfm'>
</cfif>
<cfquery name="catalogo" datasource="#Session.DSN#">
	SELECT Id_XMLEnc FROM CEXMLEncabezadoCuentas WHERE CAgrupador = '#CAgrupadorC#' AND Version = '#VersionC#' AND Mes = '#MesC#' AND Anio = #AnioC#
	and Ecodigo = #Session.Ecodigo# AND GEid = #varGEid#
</cfquery>

<cfquery datasource="#Session.DSN#" name="aaa">
	delete  FROM CEXMLDetalleCuentas WHERE Id_XMLEnc = #catalogo.Id_XMLEnc# and Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery datasource="#Session.DSN#">
	DELETE FROM CEXMLEncabezadoCuentas WHERE CAgrupador = '#CAgrupadorC#'
		AND Version = '#VersionC#' AND Mes = '#MesC#' AND Anio = #Form.AnioC# and Ecodigo = #Session.Ecodigo#
		and Id_XMLEnc = #catalogo.Id_XMLEnc# AND GEid = #varGEid#
</cfquery>

<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">

</form>


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>