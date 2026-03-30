<cfset LvarAction = 'ConsultarXMLCuentasCE.cfm'>
<cfif isdefined("url.GE") and url.GE EQ 1>
	<cfset LvarAction = '../../ce/GrupoEmpresas/consultas/ConsultarXMLCuentasCE.cfm'>
</cfif>
<cfif isdefined("Form.friltrar")>
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
	<cfif #Form.CAgrupadorCon# neq ''>
		<cfset filtro = #filtro# & " and cex.CAgrupador = '#Form.CAgrupadorCon#'">
	</cfif>

</cfif>


<!---cfif isdefined("Form.btnGenerar")>
	<cfsetting enablecfoutputonly="yes">
    <cfcontent type="application/xml">
    <cfheader name="Content-Disposition" value="attachment; filename=Catalogo-#Form.MesC#-#Form.AnioC#-V.#VersionC#.xml">
	<cfquery name="catalogo" datasource="#Session.DSN#">
		SELECT Id_XMLEnc, Version, Rfc, TotalCtas, Mes, Anio FROM CEXMLEncabezadoCuentas WHERE CAgrupador = '#Form.CAgrupadorC#' AND Version = '#Form.VersionC#' AND Mes = '#Form.MesC#' AND Anio = #Form.AnioC#
	</cfquery>
	<cfquery name="ctas" datasource="#Session.DSN#">
	   SELECT CodAgrup, NumCta, Descripcion, SubCtaDe, Nivel, Natur FROM CEXMLDetalleCuentas WHERE Id_XMLEnc = #catalogo.Id_XMLEnc# ORDER BY NumCta
     </cfquery>
    <cfoutput><?xml version="1.0" encoding="ISO-8859-1"?>
<Catalogo Version="#catalogo.Version#" RFC="#catalogo.Rfc#" TotalCtas="#catalogo.TotalCtas#" Mes="#catalogo.Mes#" Ano="#catalogo.Anio#">
    <cfloop query="ctas"><Ctas CodAgrup="#ctas.CodAgrup#" NumCta="#Trim(ctas.NumCta)#" Desc="#ctas.Descripcion#" SubCtaDe="#Trim(ctas.SubCtaDe)#" Nivel="#ctas.Nivel#" Natur="#ctas.Natur#"/>
    </cfloop></cfoutput>
<cfoutput ></Catalogo></cfoutput>
<cfquery datasource="#Session.DSN#">
	UPDATE CEXMLEncabezadoCuentas SET Status = 'Generado' WHERE CAgrupador = '#Form.CAgrupadorC#' AND Version = '#Form.VersionC#' AND Mes = '#Form.MesC#' AND Anio = #Form.AnioC#
</cfquery>

</cfif--->

	<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
	    <cfoutput>
		    <cfif isdefined("Form.friltrar")>
		        <input type="hidden" name="filtro" value="#filtro#">
		        <input type="hidden" name="MesS" value="#Form.selectMes#">
		        <input type="hidden" name="Periodo" value="#Form.selectPeriodo#">
		        <input type="hidden" name="Estatus" value="#Form.selectEstatus#">
		        <input type="hidden" name="Id_Agrupador" value="#Form.Id_Agrupador#">
                <input type="hidden" name="CAgrupadorCon" value="#Form.CAgrupadorCon#">
                <input type="hidden" name="Descripcion" value="#Form.Descripcion#">
				<cfif isdefined("form.chkGE")>
					<input type="hidden" id="chkGE" name="chkGE" value="" >
				</cfif>
				<!---cfelse>
				<input type="hiden" name="Id_Agrupador" value="#Form.Id_Agrupador#">
				<input type="hiden" name="CAgrupadorCon" value="#Form.CAgrupador#">
                <input type="hiden" name="Descripcion" value="#Form.Descripcion#"--->
            </cfif>
	    </cfoutput>
    </form>



<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>