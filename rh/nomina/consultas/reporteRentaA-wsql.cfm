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
	irA="reporteRentaK.cfm"
	FileName="reporteRenta_#session.Usuario#_#lsdateformat(now(),'yyyymmdd')#.xls"
	title="#LB_titulo#">

<cf_templatecss>

<cfoutput>
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<cfinvoke key="LB_PeriodoInicial" default="<b>Per&iacute;odo inicial</b>" returnvariable="LB_PeriodoInicial" component="sif.Componentes.Translate"  method="Translate"/>
			<cfinvoke key="LB_PeriodoFinal" default="<b>Per&iacute;odo final</b>" returnvariable="LB_PeriodoFinal" component="sif.Componentes.Translate"  method="Translate"/>
			<cfset filtro1 = LB_PeriodoInicial&': #ucase(LSMonthAsString(Form.mes_inicial))# - #Form.periodo_inicial#'>
			<cfset filtro2 = LB_PeriodoFinal&': #ucase(LSMonthAsString(Form.mes_final))# - #Form.periodo_final#'>
			<cf_EncReporte
				Titulo="#LB_titulo#"
				Color="##E3EDEF"
				filtro1="#filtro1#"
				filtro2="#filtro2#"
			>
		</td>
	</tr>
</table>
<!----===================== ENCABEZADO ANTERIOR =====================
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="3" align="center" ><strong><font size="3">#Session.Enombre#</font></strong></td></tr>
	<tr><td nowrap colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3" align="center"><strong><font size="3">#LB_titulo#</font></strong></td></tr>
	<tr>
		<td colspan="3" align="center">
			<table width="20%" align="center">
				<tr>
					<td nowrap align="center"><strong><font size="2"><cf_translate  key="LB_PeriodoInicial">Per&iacute;odo inicial</cf_translate>:&nbsp;</strong>#ucase(LSMonthAsString(Form.mes_inicial))# - #Form.periodo_inicial#</font></td>
				</tr>
				<tr>
					<td align="center" nowrap><strong><font size="2"><cf_translate  key="LB_PeriodoFinal">Per&iacute;odo final</cf_translate>:&nbsp;</strong>#ucase(LSMonthAsString(Form.mes_final))# - #Form.periodo_final#</font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="3" align="center"><font size="2"><strong><cf_translate  key="LB_Fecha">Fecha</cf_translate>:&nbsp;</strong>#LSDateFormat(now(),'dd/mm/yyyy')#&nbsp;<strong><cf_translate  key="LB_Hora">Hora</cf_translate>:&nbsp;</strong>#TimeFormat(now(),'medium')#</font></td></tr>
	<tr><td colspan="3" nowrap>&nbsp;</td></tr>
</table>
----->
</cfoutput>

<table width="99%" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<td class="tituloListas" ><cf_translate  key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
		<td class="tituloListas" ><cf_translate  key="LB_Nombre">Nombre</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_SalarioGravable">Salario Gravable</cf_translate></td>
		<!----<td class="tituloListas" align="right" ><cf_translate  key="LB_MontoRenta">Monto Renta</cf_translate></td>--->
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_MontoConyugue">Monto Conyuge</cf_translate></td>
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_MontoHijos">Monto Hijos</cf_translate></td>
		<!---<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_RentaNeta">Renta Neta</cf_translate></td>--->
		<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_RentaRentenida">Renta Rentenida</cf_translate></td>
		<!---<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_Diferencia">Diferencia</cf_translate></td>--->
		<!---<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_Diferencia">Meses</cf_translate></td>--->
	</tr>

	<cfif data.recordcount gt 0>
		<cfoutput query="data">
			<tr>
				<td style="border-bottom: 1px solid gray;">#data.id#</td>
				<td style="border-bottom: 1px solid gray;">#data.name#</td>
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.SalGraba,',9.00')#</td>
				<!---<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.MonRenta,',9.00')#</td>--->
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.MonConyu,',9.00')#</td>
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.MonHijos,',9.00')#</td>
				<!---<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.RentNeta,',9.00')#</td>--->
				<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.RentRete,',9.00')#</td>
				<!---<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.Diferencia,',9.00')#</td>--->
				<!---<td style="border-bottom: 1px solid gray;" align="right">#LSNumberFormat(data.Meses,',9')#</td>--->
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