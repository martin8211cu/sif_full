<!--- Modified with Notepad --->
<cfset Session.DebugInfo = false><!--- Quitar CFSILENT cuando se desea debuguear --->
<!--- Pago de Bancos (INC.) --->
<cfsilent><!--- Quitar cuando se desea debuguear --->
	<!--- Invoca el portlet de traducción y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<!--- Genera variables de traducción --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Reporte_de_Bancos_INC"
		Default="#nav__SPdescripcion#"
		returnvariable="LB_Reporte_de_Bancos_INC"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Control"
		Default="Control"
		returnvariable="LB_Control"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Identificacion"
		Default="Identificaci&oacute;n"
		returnvariable="LB_Identificacion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Nombre"
		Default="Nombre"
		returnvariable="LB_Nombre"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Monto"
		Default="Monto"
		returnvariable="LB_Monto"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Cuenta"
		Default="Cuenta"
		returnvariable="LB_Cuenta"/>
	<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="calendario" returnvariable="calendario">
		<cf_dbtempcol name="RCNid"      type="int"        mandatory="yes">
		<cf_dbtempcol name="RCdesde"    type="datetime"   mandatory="no">
		<cf_dbtempcol name="RChasta"    type="datetime"   mandatory="no">
		<cf_dbtempcol name="Tcodigo"    type="char(5)"    mandatory="no">
		<cf_dbtempcol name="FechaPago"  type="datetime"   mandatory="no">
		<cf_dbtempcol name="Mcodigo"    type="numeric"    mandatory="no">
		<cf_dbtempcol name="Moneda"     type="char(30)"   mandatory="no">
		<cf_dbtempcol name="TipoCambio" type="money"      mandatory="no">
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"       type="int"        mandatory="yes">
		<cf_dbtempcol name="Nombre"     type="char(60)"   mandatory="no">
		<cf_dbtempcol name="Identificacion" type="char(30)" mandatory="no">
		<cf_dbtempcol name="Monto"      type="money"      mandatory="no">
		<cf_dbtempcol name="Cuenta"     type="char(30)"   mandatory="no">
		<cf_dbtempkey cols="DEid">
	</cf_dbtemp>
	<!--- Define Form.CPidlist (Puede venir en Form.CPidlist1) --->
	<cfset Form.CPidlist = Form.CPidlist1>
	<cfif isdefined("Form.CPidlist1") and len(trim(Form.CPidlist1)) gt 0>
		<cfset Form.CPidlist = Form.CPidlist1>
	<cfelse>
		<!--- Este error no debe presentarse. --->
		<cfthrow message="Error. Se requiere CPidlist (1 o 2). Proceso Cancelado!">
	</cfif>
	<!--- Define Form.Mcodigo --->
	<cfquery name="rsMonLoc" datasource="#session.dsn#">
		select Mcodigo
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">	
	</cfquery>
	<cfparam name="Form.Mcodigo" default="#rsMonLoc.Mcodigo#" type="numeric">	
	<!--- Define Form.TipoCambio --->
	<cfparam name="Form.TipoCambio" default="1.00" type="numeric">
	<!--- Obtiene inFormación del calendario de pago
	selecccionado por el usuario. --->
	<cfquery datasource="#session.dsn#">	
		insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago, Mcodigo, TipoCambio)
		select CPid, CPdesde, CPhasta, Tcodigo, CPfpago, #Form.Mcodigo#, #Form.TipoCambio#
		from CalendarioPagos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and <cf_whereInList Column="CPid" ValueList="#Form.CPidlist#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cf_debuginfo table="#calendario#" label="calendario - tomado de Calendario Pagos">
	<!--- Obtiene la Moneda y el Tipo de Cambio --->
	<cfquery datasource="#session.dsn#">
		update #calendario#
		set Mcodigo = coalesce(a.Mcodigo,#Form.Mcodigo#)
			,TipoCambio = coalesce(a.RCtc,#Form.TipoCambio#)
		from RCalculoNomina a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and <cf_whereInList Column="a.RCNid" ValueList="#Form.CPidlist#" cfsqltype="cf_sql_numeric">
		and #calendario#.RCNid = a.RCNid
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update #calendario#
		set Moneda = Mnombre
		from Monedas
		where Monedas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and Monedas.Mcodigo = #calendario#.Mcodigo
	</cfquery>	
	<cf_debuginfo table="#calendario#" label="calendario - tipo cambio actualizado con RCalculoNomina">
	<!--- carga la tabla temporal de salida --->
	<cfquery datasource="#session.dsn#">
		insert #salida# (DEid, Nombre, Identificacion, Monto, Cuenta)
			select a.DEid, upper(coalesce(a.DEinfo1, {fn concat(a.DEapellido1, {fn concat('  ', {fn concat(a.DEapellido2, {fn concat('  ',a.DEnombre)})})})})),
					upper(coalesce(a.DEdato2,a.DEidentificacion)), b.SEliquido, DEcuenta
			from DatosEmpleado a, HSalarioEmpleado b, #calendario# c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.DEid = b.DEid
			and b.RCNid = c.RCNid
			and not exists (select 1 from HERNomina aa, HDRNomina bb, #calendario# cc
											where cc.RCNid = aa.RCNid and aa.ERNid = bb.ERNid and 
											bb.DEid = a.DEid and bb.HDRNinclexcl = 2)
	</cfquery>
	<cfquery name="rsReporte" datasource="#session.dsn#">
		select Nombre, Identificacion, Monto, Cuenta from #salida#
		order by 1
	</cfquery>
	<cfquery name="rsReporteSums" dbtype="query">
		select sum(Monto) as Monto
		from rsReporte
	</cfquery>
	<cfquery name="rsCalendario" datasource="#session.dsn#">
		select Moneda, TipoCambio
		from #calendario#
	</cfquery>
</cfsilent><!--- Quitar cuando se desea debuguear --->
<cf_htmlReportsHeaders 
	irA="ReporteBancosInc.cfm"
	FileName="Reporte_de_Bancos_INC.xls"
	title="#LB_Reporte_de_Bancos_INC#">
<cf_templatecss>
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<cfoutput>
	<!--- SECCIÓN DE TITULOS --->
	<!--- INC no utiliza tipo cambio <tr>
		<td colspan="15" align="right" nowrap><cf_translate key="LB_Tipo_De_Cambio">Tipo de Cambio</cf_translate>(#rsCalendario.Moneda#):#LSCurrencyFormat(rsCalendario.TipoCambio,'none')#</td>
	</tr> --->
	<tr>
		<td colspan="15">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td>
					<cfinvoke key="LB_ReporteDeBancosINC" default="Reporte de Bancos (INC.)" returnvariable="LB_ReporteDeBancosINC" component="sif.Componentes.Translate"  method="Translate"/>
					<cf_EncReporte
						Titulo="#LB_ReporteDeBancosINC#"
						Color="##E3EDEF"
					>
				</td></tr>
			</table>
		</td>
	</tr>
	<!----============================ ENCABEZADO ANTERIOR ============================
	<tr><td colspan="15" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
	------>
	<!--- SECCIÓN DE TITULOS DE LA LISTA --->
	<tr>
		<td  class="tituloListas" valign="top"><strong>#LB_Control#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong>#LB_Identificacion#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Monto#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong>#LB_Cuenta#</strong>&nbsp;</td>
	</tr>
	</cfoutput>
	<!--- SECCIÓN DE LISTA --->
	<cfoutput query="rsReporte">
		<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap>#rsReporte.CurrentRow#</td>
			<td nowrap>#rsReporte.Nombre#</td>
			<td nowrap>#rsReporte.Identificacion#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsReporte.Monto,'none')#</td>
			<td nowrap>&nbsp;&nbsp;#rsReporte.Cuenta#</td>
		</tr>
	</cfoutput>
	<cfoutput>
	<!--- SECCIÓN DE TOTALES --->
	<tr>
		<td  class="tituloListas" valign="top"><strong></strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong></strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong></strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LSCurrencyFormat(rsReporteSums.Monto,'none')#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong></strong>&nbsp;</td>
	</tr>
	<tr><td colspan="5">&nbsp;</td></tr>
	<!--- SECCIÓN DE TITULOS 2 --->
	<tr>
		<td  class="tituloListas" valign="top"><strong>#LB_Control#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong>#LB_Identificacion#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LB_Monto#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong>#LB_Cuenta#</strong>&nbsp;</td>
	</tr>
	<!--- SECCIÓN DE TOTALES 2 --->
	<tr>
		<td  class="tituloListas" valign="top"><strong></strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong><cf_translate key="LB_Total"> Gran Total </cf_translate></strong></strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong></strong>&nbsp;</td>
		<td  class="tituloListas" valign="top" align="right"><strong>#LSCurrencyFormat(rsReporteSums.Monto,'none')#</strong>&nbsp;</td>
		<td  class="tituloListas" valign="top"><strong></strong>&nbsp;</td>
	</tr>
	</cfoutput>
	<tr><td colspan="17" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>