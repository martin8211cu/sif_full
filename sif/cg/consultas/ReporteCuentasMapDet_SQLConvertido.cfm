<cfquery name="rsReporte" datasource="#session.DSN#">
	select
		e.Edescripcion,
		m.CGICMcodigo, m.CGICMnombre,
		me.CGICCcuenta, me.CGICCnombre,
		c.Cformato, c.Cdescripcion
	from CGIC_Mapeo m
		inner join CGIC_Catalogo me
			inner join CGIC_Cuentas mc
				inner join CContables c
					inner join Empresas e
					on e.Ecodigo = c.Ecodigo
				on c.Ccuenta = mc.Ccuenta
			on mc.CGICCid = me.CGICCid
		on me.CGICMid = m.CGICMid
	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.CGICMid") and len(trim(form.CGICMid))>
			and m.CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
		</cfif>
	order by m.CGICMcodigo, me.CGICCcuenta, c.Cformato
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

<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="8" align="right">
			<cfset Title = "Detalle de Cuentas Mapeadas">
			<cfset FileName = "MapeoCuentasDET">
			<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

			<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
			<cfif isdefined("LvarInfo")>
				<cfset LvarIrA  = 'ReporteCuentasMapeo_INFOConvertido.cfm'>
			<cfelse>
				<cfset LvarIrA  = 'ReporteCuentasMapeoConvertido.cfm'>
			</cfif>
			<cf_htmlreportsheaders
				title="#Title#" 
				filename="#FileName#" 
				download="no"
				ira="#LvarIrA#">
		</td>
	</tr>
	<tr class="area"> 
		<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#rsReporte.Edescripcion#</cfoutput></td>
	</tr>
	<tr class="area"> 
		<td align="center" colspan="8" nowrap><strong>Detalle de Cuentas Mapeadas</strong></td>
	</tr>
	<tr> 
		<td colspan="8" align="right"><strong>Fecha: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
	</tr>
	<cfflush interval="512">
	<cfoutput query="rsReporte" group="CGICMcodigo">
		<tr>
			<td colspan="8">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="8" align="center"><strong>#rsReporte.CGICMcodigo# #rsReporte.CGICMnombre#</strong></td>
		</tr>	
		<tr class="listaCorte">
			<td ><strong>C&oacute;digo</strong></td>
			<td colspan="7"><strong>Descripci&oacute;n</strong></td>
		</tr>
		<cfset LvarCuentaControl = "">
		<cfoutput>

			<cfif LvarCuentaControl NEQ rsReporte.CGICCcuenta>
				<tr class="listaCorte">
				<td>
					#rsReporte.CGICCcuenta#
				</td>
				<td colspan="7">
					#rsReporte.CGICCnombre#
				</td>
				</tr>
				<cfset LvarCuentaControl = rsReporte.CGICCcuenta>
				<tr>
				<td colspan="1">&nbsp;
					
				</td>
				<td colspan="3">
					<strong>Cuenta</strong>
				</td>
				<td colspan="4">
					<strong>Nombre</strong>
				</td>
				</tr>
			</cfif>
			<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td colspan="1">&nbsp;
					
				</td>
				<td colspan="3">
					#rsReporte.Cformato#
				</td>
				<td colspan="4">
					#rsReporte.Cdescripcion#
				</td>
			</tr>
		</cfoutput>
	</cfoutput>
</table>