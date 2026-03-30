<cfsetting requesttimeout="14400">
<!---
<cf_dbtemp name="datos" returnvariable="datos" datasource="#session.dsn#">
	<cf_dbtempcol name="origen"  		type="char(4)"		mandatory="yes">
	<cf_dbtempcol name="documento"		type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="RCNid"			type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="monto"			type="money"  		mandatory="yes">
	<cf_dbtempcol name="tc"				type="float"  		mandatory="no">
	<cf_dbtempcol name="tipo"			type="char(1)" 		mandatory="no">
	<cf_dbtempcol name="CFcodigo"		type="char(10)"		mandatory="yes">
	<cf_dbtempcol name="Ocodigo"		type="int"			mandatory="yes">
	<cf_dbtempcol name="Ccuenta"  		type="numeric"		mandatory="yes">
	<cf_dbtempcol name="Cformato"		type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="CFcuenta"		type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="Cdescripcion"	type="varchar(255)"	mandatory="yes">
	<cf_dbtempcol name="CFdescripcion"	type="varchar(255)" mandatory="yes">
</cf_dbtemp>
--->

<cfquery name="data_relacion" datasource="#session.DSN#">
	select cp.CPcodigo, a.RCdesde, a.RChasta, a.RCDescripcion, n.Tcodigo, n.Tdescripcion
	from RCalculoNomina a
	
	inner join CalendarioPagos cp
	on cp.CPid=a.RCNid
	
	inner join TiposNomina n
	on n.Ecodigo=a.Ecodigo
	and n.Ecodigo=a.Ecodigo
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	  and n.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">

</cfquery>

<cfsavecontent variable="myquery">
	<cfoutput>
	<!---insert into #datos#(origen, documento, RCNid, monto, tc, tipo, CFcodigo, Ocodigo, Ccuenta, Cformato, CFcuenta, Cdescripcion, CFdescripcion) --->
	select 	'RHPN' as origen,													
			'#data_relacion.CPcodigo#' as documento,							
			#form.RCNid# as RCNid, 															
			sum(round(a.montores*coalesce(n.RCtc, 1),2)) as monto_tc,			
			n.RCtc,
			a.tipo, 															
			cf.CFcodigo,  														
			a.Ocodigo,															
			a.Ccuenta, 															
			cc.Cformato,
			a.CFcuenta,															
			cc.Cdescripcion,
			cf.CFdescripcion	
	
	from RCuentasTipo a
	
	inner join RCalculoNomina n
	on n.RCNid=a.RCNid
	
	inner join CFuncional cf
	on cf.CFid = a.CFid
	
	inner join CContables cc
	on (cc.Ccuenta=a.Ccuenta
	or cc.Cformato=a.Cformato)
	and cc.Ecodigo = #session.Ecodigo#  --- se agregó
	
	where a.RCNid = #form.RCNid#
	and a.Ecodigo = #session.Ecodigo#
	
	group by a.tipo, a.Ocodigo, a.Ccuenta, cc.Cformato, a.CFcuenta, cf.CFcodigo,n.RCtc, cc.Cdescripcion, cf.CFdescripcion --- se quito el campo a.tiporeg
	order by cc.Cformato, cf.CFcodigo
	</cfoutput>
</cfsavecontent>

 <cf_htmlreportsheaders
			title="Revision Contable" 
			filename="RevisionContable#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
			ira="revisionContable-filtro.cfm">

<br />
<cfoutput>
<table width="95%" align="center" cellpadding="2" cellspacing="0">
	<tr>
		<td>
			<cfinvoke key="LB_Reporte_de_Revision_Contable" default="Reporte de Revisi&oacute;n Contable" returnvariable="LB_Reporte_de_Revision_Contable" component="sif.Componentes.Translate"  method="Translate"/>
			<cfinvoke key="LB_Nomina" default="N&oacute;mina" returnvariable="LB_Nomina" component="sif.Componentes.Translate"  method="Translate"/>
			<cfinvoke key="LB_Tipo_de_Nomina" default="Tipo de N&oacute;mina" returnvariable="LB_Tipo_de_Nomina" component="sif.Componentes.Translate"  method="Translate" xmlfile="/rh/generales.xml"/>
			<cfinvoke key="LB_Fecha_Inicio" default="Fecha Inicio" returnvariable="LB_Fecha_Inicio" component="sif.Componentes.Translate"  method="Translate"  xmlfile="/rh/generales.xml"/>
			<cfinvoke key="LB_Fecha_Final" default="Fecha Hasta" returnvariable="LB_Fecha_Final" component="sif.Componentes.Translate"  method="Translate"  xmlfile="/rh/generales.xml"/>
			<cf_EncReporte
				Titulo="#LB_Reporte_de_Revision_Contable#"
				Color="##E3EDEF"
				filtro1="<b>#LB_Nomina#:</b> #data_relacion.RCDescripcion#"
				filtro2="<b>#LB_Tipo_de_Nomina#:</b> #trim(data_relacion.Tcodigo)# - #data_relacion.Tdescripcion#"
				filtro3="<b>#LB_Fecha_Inicio#:</b> #LSDateFormat(data_relacion.RCdesde, 'dd/mm/yyyy')#"
				filtro4="<b>#LB_Fecha_Final#:</b> #LSDateFormat(data_relacion.RChasta, 'dd/mm/yyyy')#"
			>
		</td>
	</tr>
</table>
<!----===================== ENCABEZADO ANTERIOR =====================
<table width="95%" align="center" cellpadding="2" cellspacing="0">
	<tr><td align="center" class="empresa"><strong>#session.Enombre#</strong></td></tr>
	<tr><td align="center" class="titulo"><strong><cf_translate key="LB_Reporte_de_Revision_Contable">Reporte de Revisi&oacute;n Contable</cf_translate></strong></td></tr>
	<tr><td align="center"><strong><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate>:&nbsp;</strong>#data_relacion.RCDescripcion#</td></tr>	
	<tr><td align="center"><strong><cf_translate key="LB_Tipo_de_Nomina" xmlfile="/rh/generales.xml">Tipo de N&oacute;mina</cf_translate>:&nbsp;</strong>#trim(data_relacion.Tcodigo)# - #data_relacion.Tdescripcion#</td></tr>	
	<tr><td align="center"><strong><cf_translate key="LB_Fecha_Inicio" xmlfile="/rh/generales.xml">Fecha Inicio</cf_translate>:&nbsp;</strong>#LSDateFormat(data_relacion.RCdesde, 'dd/mm/yyyy')#</td></tr>	
	<tr><td align="center"><strong><cf_translate key="LB_Fecha_Final" xmlfile="/rh/generales.xml">Fecha Hasta</cf_translate>:&nbsp;</strong>#LSDateFormat(data_relacion.RChasta, 'dd/mm/yyyy')#</td></tr>	
</table>	
------>
</cfoutput>
<br />

<cftry>
	<cfflush interval="8000">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#preservesinglequotes(myquery)#</cfoutput>
	</cf_jdbcquery_open>

	<table width="95%" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td class="tituloListas"><cf_translate key="LB_Linea">L&iacute;nea</cf_translate></td>
			<td colspan="2" class="tituloListas"><cf_translate key="LB_Cuenta">Cuenta</cf_translate></td>		
			<td colspan="2" class="tituloListas"><cf_translate key="LB_CentroFuncional" xmlfile="/rh/generales.xml">Centro Funcional</cf_translate></td>
			<td class="tituloListas" align="right"><cf_translate key="LB_Tipo_de_Cambio" xmlfile="/rh/generales.xml">Tipo de Cambio</cf_translate></td>
			<td class="tituloListas" align="right"><cf_translate key="LB_Monto_Debitos">D&eacute;bitos</cf_translate></td>
			<td class="tituloListas" align="right"><cf_translate key="LB_Monto_Creditos">Cr&eacute;ditos</cf_translate></td>
		</tr>
		<cfset reg = 0 >
		<cfset total_debitos  = 0 >
		<cfset total_creditos = 0 >
		<cfoutput query="data" group="cformato">
			<cfoutput group="CFcodigo">
				<cfset reg = reg + 1 >
				<cfset debitos = 0 >
				<cfset creditos = 0 >
				<tr>
					<td>#reg#</td>
					<td>#Cformato#</td>
					<td>#Cdescripcion#</td>
					<td>#CFcodigo#</td>
					<td>#CFdescripcion#</td>
					<td align="right">#LSNumberFormat(RCtc, ',9.00')#</td>
					<cfoutput>
						<cfif tipo eq 'D'>
							<cfset debitos = debitos + monto_tc >
							<cfset total_debitos  = total_debitos + monto_tc >
						<cfelse>
							<cfset creditos = creditos + monto_tc >
							<cfset total_creditos  = total_creditos + monto_tc >
						</cfif>
					</cfoutput>
					<td align="right">#LSNumberFormat(debitos, ',9.00')#</td>
					<td align="right">#LSNumberFormat(creditos, ',9.00')#</td>
				</tr>
			</cfoutput>
		</cfoutput>
		<cfoutput>
		<tr><td>&nbsp;</td></tr>
		<tr style="padding:3px;">
			<td colspan="5" style="padding:3px;"></td>
			<td align="right" style="padding:3px;"><strong><cf_translate key="LB_Total" xmlfile="/rh/generales.xml">Total</cf_translate></strong>:</td>
			<td align="right" style="padding:3px;">#LSNumberFormat(total_debitos, ',9.00')#</td>
			<td align="right" style="padding:3px;">#LSNumberFormat(total_creditos, ',9.00')#</td>			
		</tr>
		</cfoutput>
		
		<cfif reg gt 0>
			<tr><td colspan="8" align="center">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del reporte</cf_translate> ---</td></tr>
		<cfelse>
			<tr><td colspan="8" align="center">--- <cf_translate key="MSG_NoSeEncontraronRegistros" xmlfile="/rh/generales.xml">No se encontraron registros</cf_translate>---</td></tr>
		</cfif>
	</table>
	
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfthrow object="#cfcatch#">
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
	

