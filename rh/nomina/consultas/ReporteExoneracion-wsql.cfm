<!---RVNP--->
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default="#nav__SPdescripcion#" returnvariable="LB_titulo"/>

<cffunction name="LSMonthAsString">
	<cfargument name="month" default="1" type="Numeric">
	<cfset var Lvar_VSdesc = "">
	<cfquery name="getDesc" datasource="#session.dsn#">
		select VSdesc
		from VSidioma 
		where VSgrupo = 1 
		and VSvalor = '#month#'
		and Iid = (
			select Iid
			from Idiomas
			where Icodigo = 'es_CR'
		)
	</cfquery>
	<cfif getDesc.recordcount gt 0 and len(trim(getDesc.VSdesc))>
		<cfset Lvar_VSdesc = getDesc.VSdesc>
	</cfif>
	<cfreturn Lvar_VSdesc>
</cffunction>

<cf_htmlReportsHeaders
	irA="ReporteExoneracion.cfm"
	FileName="ReporteExoneracion_#session.Usuario#_#lsdateformat(now(),'yyyymmdd')#.xls"
	title="#LB_titulo#">

<cf_templatecss>
<cfsavecontent variable="Exportar">
	

<cfoutput>
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<cfinvoke key="LB_PeriodoInicial" default="<b>Per&iacute;odo inicial</b>" returnvariable="LB_PeriodoInicial" component="sif.Componentes.Translate"  method="Translate"/>
			<cfinvoke key="LB_PeriodoFinal" default="<b>Per&iacute;odo final</b>" returnvariable="LB_PeriodoFinal" component="sif.Componentes.Translate"  method="Translate"/>

			<cfif form.radio neq 2>
				<cfset filtro1 = LB_PeriodoInicial&': #ucase(LSMonthAsString(Form.mes_inicial))# - #Form.periodo_inicial#'>
				<cfset filtro2 = LB_PeriodoFinal&': #ucase(LSMonthAsString(Form.mes_final))# - #Form.periodo_final#'>
			<cfelse>
				<cfset filtro1 = form.CPcodigo2 &' - '&form.CPdescripcion2>
				<cfset filtro2 = ''>
			</cfif>


			<cf_EncReporte
				Titulo="#LB_titulo#"
				Color="##E3EDEF"
				filtro1="#filtro1#"
				filtro2="#filtro2#"
			>
		</td>
	</tr>
</table>

</cfoutput>


<style type="text/css">
	.border{
		border-left: 1px solid black;
		border-right: 1px solid black;
		border-bottom: 1px solid black;
		border-top: 1px solid black;

	}
</style>

<table width="99%" cellpadding="2" cellspacing="0" align="center" border ="0">
	<tr>
		<td class="tituloListas" colspan="2"></td>
		<td class="tituloListas border" colspan="3"  class="tituloListas"  align="center" nowrap  ><cf_translate  key="LB_CargaSocial">Cargas Sociales</cf_translate></td>
		<td class="tituloListas border"  colspan="5"  lass="tituloListas"  align="center" nowrap ><cf_translate  key="LB_Renta">Renta</cf_translate></td>
	</tr> 

	<tr>
		<td class="tituloListas" align="left" nowrap  ><cf_translate  key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
		<td class="tituloListas" ><cf_translate  key="LB_Nombre">Nombre</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_PensionesComplC">Pensiones complementarias</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_PagosRealizadosC">Pagos realizados</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_TotalC">Total</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_Conyuge">Conyuge</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_Hijos">Hijos</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_PensionesComplR">Pensiones complementarias</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_PagosRealizadosR">Pagos realizados</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_TotalR">Total</cf_translate></td>
	</tr>

	<cfif data.recordcount gt 0>
		<cfoutput query="data">
			<tr>
				<td style="border-bottom: 1px solid gray;">#data.id#</td>
				<td style="border-bottom: 1px solid gray;">#data.name#</td> 
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.pc,',9.00')#</td> 
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.cpe,',9.00')#</td>
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.totalp,',9.00')#</td>
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.RCony,',9.00')#</td>
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.RHijo,',9.00')#</td>
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.pc,',9.00')#</td>
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.rpe,',9.00')#</td>
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.totals,',9.00')#</td>
				
			</tr>
		</cfoutput>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="10" align="center">--- <cf_translate  key="LB_FinDelReporte">Fin del Reporte</cf_translate> ---</td></tr>
		<tr><td>&nbsp;</td></tr>
	<cfelse>
		<tr><td colspan="10" align="center"><strong>-- <cf_translate  key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> -- </strong></td></tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>
</table>
</cfsavecontent>

