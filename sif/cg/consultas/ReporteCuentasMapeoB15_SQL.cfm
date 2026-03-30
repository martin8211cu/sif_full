

<cfquery name="rsReporte" datasource="#session.DSN#">
	select
		m.CGICMcodigo, m.CGICMnombre,
		me.CGICCcuenta, me.CGICCnombre,
		(( 
			select count(1)
			from CGIC_Cuentas mc
				inner join CContables c
					inner join Empresas e
					on e.Ecodigo = c.Ecodigo
					and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				on c.Ccuenta = mc.Ccuenta
			where mc.CGICCid = me.CGICCid
		)) as CuentasMapeadas
	from CGIC_Mapeo m
		inner join CGIC_Catalogo me
		on me.CGICMid = m.CGICMid
	where 
		<cfif isdefined("form.CGICMid") and len(trim(form.CGICMid))>
			m.CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
		<cfelse>
			1 = 1
		</cfif>
	order by m.CGICMcodigo, me.CGICCcuenta
</cfquery>
<cfquery name="Empresas" datasource="#Session.DSN#">
	select 
		Ecodigo, 
		Edescripcion 
	from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<cfhtmlhead text="
<style type='text/css'>
td {  font-size: 11px; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
a {
	text-decoration: none;
	color: ##000000;
}
.listaCorte { font-size: 11px; font-weight:bold; background-color:##CCCCCC; text-align:left;}
.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}	
.tituloSub { background-color:##FFFFFF; font-weight: bolder; text-align: center; vertical-align: middle; font-size: smaller; border-color: black black ##CCCCCC; border-style: inset; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
.tituloListas {

	font-weight: bolder;
	vertical-align: middle;
	padding: 5px;
	background-color: ##F5F5F5;
}
</style>">

<cfinvoke key="LB_Titulo" default="Mapeo de Cuentas" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteCuentasMapeo_SQL.xml"/>


<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="8" align="right">
			<cfset Title = "Mapeo de Cuentas">
			<cfset FileName = "MapeoCuentas">
			<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

			<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
			<cfif isdefined("LvarInfo")>
				<cfset LvarIrA  = 'ReporteCuentasMapeo_INFO.cfm'>
			<cfelse>
				<cfset LvarIrA  = 'ReporteCuentasMapeoB15.cfm'>
			</cfif>
			<cf_htmlreportsheaders
				title="#Title#" 
				filename="#FileName#" 
				download="no"
				ira="#LvarIrA#">
		</td>
	</tr>
	<tr class="area"> 
		<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
	</tr>
	<tr class="area"> 
		<td align="center" colspan="8" nowrap><strong><cf_translate key=LB_Titulo>Mapeo de Cuentas</cf_translate></strong></td>
	</tr>
	<tr> 
		<td colspan="8" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
	</tr>
	<tr class="tituloListas">
		<td><strong><cf_translate key=LB_CodigoCuenta>Código Cuenta</cf_translate></strong></td>
		<td><strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate></strong></td>
		<td><strong><cf_translate key=LB_Mapeada>Mapeadas</cf_translate></strong></td>
	</tr>
	<cfflush interval="3">
	<cfoutput query="rsReporte" group="CGICMcodigo">
			<tr>
				<td colspan="8" class="listaCorte">#rsReporte.CGICMcodigo#</td>
			</tr>	
		<cfoutput>
			<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td>
					#rsReporte.CGICCcuenta#
				</td>
				<td>
					#rsReporte.CGICCnombre#
				</td>
				<td colspan="5">
					#rsReporte.CuentasMapeadas#
				</td>
			</tr>
		</cfoutput>
	</cfoutput>
</table>