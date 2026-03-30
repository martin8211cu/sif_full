<cfinclude template="../../../sif/cg/consultas/Funciones.cfm">
<cfset gpoElimina="#get_val(1330).Pvalor#">

<cfquery name="rsGpoEmpresa" datasource="#Session.DSN#">
    select a.GEid as Ecodigo, a.GEnombre as Edescripcion
    from AnexoGEmpresa a
    where a.CEcodigo = #session.cecodigo# and a.GEid=#gpoElimina#
</cfquery>

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
                    and e.Ecodigo in (Select Ecodigo from AnexoGEmpresaDet where GEid=#gpoElimina#) 
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
	select Ecodigo, Edescripcion 
	from Empresas 
    where Ecodigo in (Select Ecodigo from AnexoGEmpresaDet where GEid=#gpoElimina#)
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
				<cfset LvarIrA  = 'ReporteCuentasMapeoCons.cfm'>
			</cfif>
			<cf_htmlreportsheaders
				title="#Title#" 
				filename="#FileName#" 
				download="no"
				ira="#LvarIrA#">
		</td>
	</tr>
	<tr class="area"> 
		<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#rsGpoEmpresa.Edescripcion#</cfoutput></td>
	</tr>
	<tr class="area"> 
		<td align="center" colspan="8" nowrap><strong>Mapeo de Cuentas</strong></td>
	</tr>
	<tr> 
		<td colspan="8" align="right"><strong>Fecha: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
	</tr>
	<tr class="tituloListas">
		<td><strong>Código Cuenta</strong></td>
		<td><strong>Cuenta</strong></td>
		<td><strong>Mapeadas</strong></td>
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