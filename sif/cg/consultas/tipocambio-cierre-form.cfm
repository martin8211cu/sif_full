<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfparam name="form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfparam name="form.mes" default="#url.mes#">
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfparam name="form.Mcodigo" default="#url.Mcodigo#">
</cfif>

<cfquery name="datos" datasource="#session.DSN#">
	select tce.Periodo, tce.Mes, m.Miso4217, m.Mnombre, tce.TCEtipocambio as tc
	from TipoCambioEmpresa  tce
	
	inner join Monedas m
	on m.Mcodigo=tce.Mcodigo
	and m.Ecodigo=tce.Ecodigo
	
	where tce.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("form.periodo") and len(trim(form.periodo))>
		and tce.Periodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
	</cfif>			

	<cfif isdefined("form.mes") and len(trim(form.mes))>
		and tce.Mes=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
	</cfif>
	
	<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
		and tce.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfif>	

	order by tce.Periodo desc, tce.Mes desc, m.Mnombre
</cfquery>

<cfset meses = '#CMB_Enero#,#CMB_Febrero#,#CMB_Marzo#,#CMB_Abril#,#CMB_Mayo#,#CMB_Junio#,#CMB_Julio#,#CMB_Agosto#,#CMB_Setiembre#,#CMB_Octubre#,#CMB_Noviembre#,#CMB_Diciembre#' >

<cfoutput>
<table width="99%" cellpadding="3" align="center">
	<tr>
		<td align="center"><font size="4"><strong>#session.Enombre#</strong></font></td>
	</tr>
	<tr>
		<td align="center"><font size="3"><strong><cf_translate key=LB_Titulo>Tipo de Cambio de Cierre Contable</cf_translate></strong></font></td>
	</tr>

	<tr>
		<td align="center"><font size="2"><strong><cfif isdefined("form.Periodo") and len(trim(form.Periodo))><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate>:&nbsp; #form.periodo#</cfif>  <cfif isdefined("form.mes") and len(trim(form.mes))><cf_translate key=LB_Mes>Mes</cf_translate>:&nbsp; #listgetat(meses,form.mes)#</cfif></strong></font></td>
	</tr>

</table>
</cfoutput>

<table width="99%" align="center" cellpadding="2" cellspacing="0">
	<tr class="tituloListas">
		<td width="25%"><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate></strong></td>
		<td width="25%"><strong><cf_translate key=LB_Mes>Mes</cf_translate></strong></td>
		<td width="25%"><strong><cf_translate key=LB_Moneda>Moneda</cf_translate></strong></td>
		<td align="right" width="25%"><strong><cf_translate key=LB_TipoCambio>Tipo de Cambio</cf_translate></strong></td>
	</tr>
	<cfif datos.recordcount gt 0>
		<cfoutput query="datos">
		<tr class="<cfif datos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td>#datos.periodo#</td>
			<td>#ListGetAt(meses, datos.mes)#</td>
			<td>#datos.mnombre#</td>
			<td align="right">#LSNumberFormat(datos.tc,',9.9999999999')#</td>
		</tr>
		</cfoutput>
		<tr><td colspan="4" align="center">--- <cf_translate key=LB_FinReporte>Fin del Reporte</cf_translate> ---</td></tr>
	<cfelse>
		<tr><td colspan="4" align="center">- <cf_translate key=LB_SinRegistros>No se encontraron registros</cf_translate> -</td></tr>
	</cfif>
</table>
<br />
