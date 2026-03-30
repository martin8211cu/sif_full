<cfoutput>
	<cfif isdefined("url.fecDesde")>
		<cfparam name="Form.fecDesde" default="#url.fecDesde#">
	</cfif>
	
	<cfif isdefined("url.fecHasta")>
		<cfparam name="Form.fecHasta" default="#url.fecHasta#">
	</cfif>
</cfoutput>

<cfquery name="rsTotal" datasource="#Session.DSN#">
	Select sum(T.CTThoras) horas
	from CTReporteTiempos R, CTTiempos T
	where R.CTRcodigo = T.CTRcodigo
	and R.Ecodigo = #Session.Ecodigo#
	And R.CTRfecha >= convert(datetime,'#LSDateFormat(Form.fecDesde,"YYYYMMDD")#')
	And R.CTRfecha <= convert(datetime,'#LSDateFormat(Form.fecHasta,"YYYYMMDD")#')
</cfquery>

<cfquery name="rsProyectos" datasource="#Session.DSN#">
	select P.CTPcobrable tipo, P.CTPdescripcion nombre, sum(T.CTThoras) horas
	from CTProyectos P, CTReporteTiempos R, CTTiempos T
	where R.CTRcodigo = T.CTRcodigo
	and P.CTPcodigo = T.CTPcodigo
	and P.Ecodigo = #Session.Ecodigo#
	and R.Ecodigo = #Session.Ecodigo#
	And R.CTRfecha >= convert(datetime,'#LSDateFormat(Form.fecDesde,"YYYYMMDD")#')
	And R.CTRfecha <= convert(datetime,'#LSDateFormat(Form.fecHasta,"YYYYMMDD")#')
	group by P.CTPcobrable, P.CTPdescripcion
</cfquery>

<cfquery name="rsEmpresa" datasource="#session.DSN#" >
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>

<form name="formResultados" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
    <tr> 
      <td colspan="4" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="4" align="center"><b>Reporte de Horas por Proyecto</b></td>
    </tr>
	<tr> 
	  <cfoutput>
	  	<td colspan="4" align="center"><b>Fecha del Reporte:&nbsp;</b> #LSDateFormat(fecDesde, 'dd-mm-yyyy')# &nbsp; <b>Hasta:&nbsp;</b>#LSDateFormat(fecHasta, 'dd-mm-yyyy')#</td>
	  </cfoutput>
    </tr>
	<tr class="encabReporte">
		<td colspan="2" align="center">Proyectos</td>
		<td align="right">Cantidad de Horas</td>
		<td align="right"><b>Porcentaje de Horas</b></td>
	</tr>
	<cfset porcentajeTotal = 0>
	<!--- Proyectos cobrables --->
	<cfquery name="rsCobrables" dbtype="query">
		select *
		from rsProyectos
		where rsProyectos.tipo = 1 <!--- Cobrable --->
	</cfquery>
	<cfif rsCobrables.recordcount GT 0>
		<tr>
			<td><b>Cobrables</b></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<cfoutput query="rsCobrables">
		<tr>
			<td>&nbsp;</td>
			<td>#rsCobrables.nombre#</td>
			<td align="right">#LSNumberFormat(rsCobrables.horas,',9.00')#</td>
			<cfset porcentaje = rsCobrables.horas*100/rsTotal.horas>
			<td align="right">#LSNumberFormat(porcentaje,',9.00')#%</td>
			<cfset porcentajeTotal = porcentajeTotal + porcentaje>
		</tr>	
		</cfoutput>
	</cfif>
	<!--- Proyectos No cobrables --->
	<cfquery name="rsNoCobrables" dbtype="query">
		select *
		from rsProyectos
		where rsProyectos.tipo = 0 <!--- No Cobrable --->
	</cfquery>
	<cfif rsNoCobrables.recordcount GT 0>
		<tr>
			<td><b>No Cobrables</b></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<cfoutput query="rsNoCobrables">
		<tr>
			<td>&nbsp;</td>
			<td>#rsNoCobrables.nombre#</td>
			<td align="right">#LSNumberFormat(rsNoCobrables.horas,',9.00')#</td>
			<cfset porcentaje = rsNoCobrables.horas*100/rsTotal.horas>
			<td align="right">#LSNumberFormat(porcentaje,',9.00')#%</td>
			<cfset porcentajeTotal = porcentajeTotal + porcentaje>
		</tr>	
		</cfoutput>
	</cfif>
	
	<!--- Pintado de Totales --->
	<tr>
		<td class="topline"><b>Totales</b></td>
		<td class="topline">&nbsp;</td>
		<td align="right" class="topline" nowrap><cfoutput>#LSNumberFormat(rsTotal.horas,',9.00')#</cfoutput></td>
		<td align="right" class="topline" nowrap><cfoutput>#LSNumberFormat(porcentajeTotal,',9.00')#</cfoutput>%</td>
	</tr>
	
    <tr> 
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="4" class="topline">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="4"><div align="center">------------------ Fin del Reporte ------------------</div></td>
    </tr>
  </table>
</form>
