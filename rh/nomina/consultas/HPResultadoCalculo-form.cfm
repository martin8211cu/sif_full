<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ReporteHistoricoDePagos" Default="Reporte Histórico de Pagos" returnvariable="LB_ReporteHistoricoDePagos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Regresar" Default="Regresar" returnvariable="vRegresar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("url.RCNid") and not isdefined("form.RCNid")>	
	<cfset form.RCNid = url.RCNid >
</cfif>

<cfif isdefined("url.DEid") and not isdefined("form.DEid")>	
	<cfset form.DEid = url.DEid >
</cfif>

<cfif isdefined("url.Tcodigo") and not isdefined("form.Tcodigo")>	
	<cfset form.Tcodigo = url.Tcodigo >
</cfif>

<!--- Consultas --->
<!--- Monedas --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo 
	from Monedas a, HRCalculoNomina b, TiposNomina c 
	where b.Tcodigo = c.Tcodigo 
	  and a.Mcodigo = c.Mcodigo 
	  and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>
<cfquery name="rsSE" datasource="#Session.DSN#">
	select SEcalculado
	from HSalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>

<!--- JavaScript --->
<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0;

	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
</script>

<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<cf_templatecss>

<style type="text/css">
.tituloAlterno2 {
	font-weight: bolder;
	text-align: center;
	vertical-align: middle;

	padding: 2px;
	background-color: #DFDFDF;
}

</style>

<cf_sifHTML2Word>
<table width="97%" >


<tr bgcolor="#EEEEEE" style="padding: 3px;"><td align="center"><font size="3"><b>
	<cfoutput>#LB_ReporteHistoricoDePagos#</cfoutput> 
</b></font></td></tr>
</table>

<cfinclude template="/rh/portlets/pEmpleado.cfm">
<table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
  <tr>
	<td nowrap colspan="8" align="center" class="<cfoutput> #Session.Preferences.Skin#_thcenter</cfoutput>"><font size="2"><cf_translate  key="LB_InformacionResumida" xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml">Informaci&oacute;n Resumida</cf_translate></font></td>
  </tr>
  <tr><td colspan="8"><cfinclude template="../../nomina/consultas/frame-HPSalarioEmpleado.cfm"><!--- Información Resumida ---></td></tr>
</table>
<form action="<cfoutput>#Url.Regresar#</cfoutput>" method="post" name="form1">
  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
    <tr> 
      <td nowrap colspan="8" align="center" class="<cfoutput> #Session.Preferences.Skin#_thcenter</cfoutput>"><font size="2"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"  key="LB_InformacionDetallada">Informaci&oacute;n Detallada</cf_translate></font></td>
    </tr>
    <cfinclude template="../../nomina/consultas/frame-HPPagosEmpleado.cfm"></td>
    <!--- Salarios --->

    <tr valign="top"> 
      <td nowrap colspan="8">&nbsp;</td>
    </tr>
    <cfinclude template="../../nomina/consultas/frame-HPIncidenciasCalculo.cfm"></td>
    <!--- Incidencias --->

    <tr valign="top"> 
      <td nowrap colspan="8">&nbsp;</td>
    </tr>
    <cfinclude template="../../nomina/consultas/frame-HPCargasCalculo.cfm"></td>
    <!--- Cargas --->

    <tr valign="top"> 
      <td nowrap colspan="8">&nbsp;</td>
    </tr>
    <cfinclude template="../../nomina/consultas/frame-HPDeduccionesCalculo.cfm"></td>
	
    <tr valign="top"> 
      <td nowrap colspan="8">&nbsp;</td>
    </tr>

    <cfoutput> 

	  <cfif not isdefined("url.Archivo")>
		  <tr valign="top"> 
			<td nowrap colspan="8" align="center">
			  <input type="button" name="Regresar" class="btnAnterior" value="#vRegresar#" onClick="javascript: regresar();"> 
			</td>
		  </tr>
	  </cfif> 

      <tr valign="top"> 
        <td nowrap colspan="8" align="center">
			<input name="Tcodigo" type="hidden" value="#Url.Tcodigo#">
			<input name="fecha" type="hidden" value="#Url.fecha#">
			<input name="butFiltrar" type="hidden" value="Filtrar">
			<input name="RCNid" type="hidden" value="#Url.RCNid#">
        </td>
      </tr>
	  <tr><td>&nbsp;</td></tr>
	  
    </cfoutput> 
  </table>
</form>
</cf_sifHTML2Word>
