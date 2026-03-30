<cfsetting requesttimeout="36000">
<cfif isdefined('url.historico')>
	<cfset url.RCNid = url.CPid>
	<cfset tablaCalculoNomina = 'HRCalculoNomina'>
	<cfset tablaCargasCalculo = 'HCargasCalculo'>
<cfelse>
	<cfset tablaCalculoNomina = 'RCalculoNomina'>
	<cfset tablaCargasCalculo = 'CargasCalculo'>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select
		 a.RCDescripcion,
		 emp.Ecodigo, 
		 emp.Edescripcion as Empresa, 
		 ec.ECid,
		 ec.ECcodigo,
		 ec.ECdescripcion,
		 sn.SNcodigo,
		 sn.SNnumero,
		 sn.SNnombre,
		 cp.CPcodigo, 
		 <cf_dbfunction name="date_format" args="cp.CPdesde,DD/MM/YYYY">  as CPdesde, 
		 <cf_dbfunction name="date_format" args="cp.CPhasta,DD/MM/YYYY">  as CPhasta, 
		 de.DEidentificacion,
		 {fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})} as DEnombre,
		 b.CCvaloremp,
		 b.CCvalorpat,
		 coalesce((	select {fn concat(rtrim(cf.CFcodigo),{fn concat(' - ',rtrim(cf.CFdescripcion))})}
		 	from LineaTiempo lt, RHPlazas pl, CFuncional cf 
		 	where lt.DEid = de.DEid
			and pl.RHPid=lt.RHPid
			and cf.CFid=pl.CFid
			and a.RCdesde between lt.LTdesde and LThasta
		 ), (	select {fn concat(rtrim(cf.CFcodigo),{fn concat(' - ',rtrim(cf.CFdescripcion))})}
		 	from LineaTiempo lt, RHPlazas pl, CFuncional cf 
		 	where lt.DEid = de.DEid
			and pl.RHPid=lt.RHPid
			and cf.CFid=pl.CFid
			and a.RChasta between lt.LTdesde and LThasta
		 ))  as CFdescripcion, '#LSDateFormat(Now(), "dd/mm/yyyy")#'as fecha,
			dc.DCcodigo,dc.DCdescripcion
		from #tablaCalculoNomina# a, #tablaCargasCalculo# b, CargasEmpleado c, ECargas ec, DCargas dc, CalendarioPagos cp, DatosEmpleado de, SNegocios sn, Empresas emp
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.Ecodigo = emp.Ecodigo
		  and cp.CPid = a.RCNid
		  and a.RCNid = b.RCNid
		  and b.DClinea = c.DClinea
		  and b.DEid = c.DEid
		  and c.DClinea = dc.DClinea
		  and dc.ECid = ec.ECid
		  and dc.Ecodigo = ec.Ecodigo
		  and a.Ecodigo = ec.Ecodigo
		  and b.DEid = de.DEid
		  and dc.Ecodigo = sn.Ecodigo
		  and dc.SNcodigo = sn.SNcodigo
		  and (b.CCvaloremp + b.CCvalorpat) != 0
		  <cfif isdefined('url.ECid') and url.ECid GT 0>
		  and dc.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECid#">
		  </cfif>
		order by CFdescripcion, ec.ECcodigo, {fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})}
</cfquery>

<cfif isdefined('url.chkAgrupar')>

	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>

	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and isdefined('url.formato') and url.formato EQ "Excel">
	    <!--- <cfset typeRep = 1>
		<cf_js_reports_service_tag queryReport = "#rsReporte#" 
			isLink = False 
			typeReport = typeRep
			fileName = "Reporte de Cargas"/> --->

		<cf_QueryToFile query="#rsReporte#" FILENAME="Reporte_de_Cargas.xls" titulo="Reporte de Cargas">
	<cfelse>
		<cfreport format="#url.formato#" template= "RepRCCargas.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
			<cfif isdefined("url.formato") and Len(Trim(url.formato))>
				<cfreportparam name="formato" value="#url.formato#">
			</cfif>
		</cfreport>
	</cfif>

<cfelse>
	<cfinvoke Key="LB_Cargas" Default="Cargas" returnvariable="LB_Cargas" component="sif.Componentes.Translate" method="Translate"/>
	<!--- Datos de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfquery name="rsDatosNomina" datasource="#session.DSN#">
		select RCDescripcion,Tdescripcion,RCdesde,RChasta
		from #tablaCalculoNomina# a
		inner join TiposNomina b
			on b.Tcodigo = a.Tcodigo
			and b.Ecodigo = a.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	</cfquery>
	<style>
		h1.corte {
			PAGE-BREAK-AFTER: always;}
		.tituloAlterno {
			font-size:20px;
			font-weight:bold;
			text-align:center;}
		.tituloEncab {
			font-size:14px;
			font-weight:bold;
			text-align:left;}
		.titulo_empresa2 {
			font-size:16px;
			font-weight:bold;
			text-align:center;}
		.titulo_reporte {
			font-size:16px;
			font-style:italic;
			text-align:center;}
		.titulo_filtro {
			font-size:14px;
			font-style:italic;
			text-align:center;}
		.titulolistas {
			font-size:14px;
			font-weight:bold;
			background-color:#CCCCCC;
			}
		.titulo_columnar {
			font-size:14px;
			font-weight:bold;
			background-color:#CCCCCC;
			text-align:right;}
		.listaCorte {
			font-size:12px;
			font-weight:bold;
			background-color: #F4F4F4;
			text-align:left;}
		.listaCorte3 {
			font-size:12px;
			font-weight:bold;
			background-color:  #E8E8E8;
			text-align:left;}
		.listaCorte2 {
			font-size:12px;
			font-weight:bold;
			background-color: #D8D8D8;
			text-align:left;}
		.listaCorte1 {
			font-size:12px;
			font-weight:bold;
			background-color:#CCCCCC;
			text-align:left;}
		.total {
			font-size:14px;
			font-weight:bold;
			background-color:#C5C5C5;
			text-align:right;}
	
		.detalle {
			font-size:11px;
			text-align:left;}
		.detaller {
			font-size:11px;
			text-align:right;}
		.detallec {
			font-size:11px;
			text-align:center;}	
			
		.mensaje {
			font-size:14px;
			text-align:center;}
		.paginacion {
			font-size:14px;
			text-align:center;}
	</style>
	<cfif isdefined('url.Tipo') and url.Tipo EQ 'D'>
		<cfquery name="rsReporte" dbtype="query">
			select DCcodigo,DCdescripcion,CCvaloremp,CCvalorpat,DEnombre,DEidentificacion
			from rsReporte
			order by DCcodigo,DEidentificacion
		</cfquery>
	<cfelse>
  		<cfquery name="rsReporte" dbtype="query">
			select DCcodigo,DCdescripcion,sum(CCvaloremp) as TotalEmp,sum(CCvalorpat) as TotalPat
			from rsReporte
			group by DCcodigo,DCdescripcion
		</cfquery>
	</cfif>
	<cfif isdefined('url.historico')>
		<cfset Lvar_irA = '../../indexHistoricos.cfm'>
	<cfelse>
		<cfset Lvar_irA = '../../indexReportes.cfm?Tcodigo=#url.Tcodigo#&fecha=#rsDatosNomina.RCdesde#&RCNid=#url.RCNid#'>
	</cfif>

	<cf_htmlreportsheaders
		title="#LB_Cargas#" 
		filename="ReporteCargas#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
		ira="#Lvar_irA#"
		method="url">
	<table width="80%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
		<tr><td colspan="3" align="center"><font size="2"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td></tr>
		<tr> 
			<td colspan="3" align="center">
				<font size="2"><strong><cf_translate key="LB_Reporte_de_CargasDeNomina_en_Proceso">Reporte de Cargas de N&oacute;minas en Proceso</cf_translate></strong></font>
			</td>
		</tr>
		<tr> 
			<td colspan="3" align="center">
				<font size="2"><strong><cfoutput>#rsDatosNomina.Tdescripcion# - #rsDatosNomina.RCDescripcion#</cfoutput></strong></font>
			</td>
		</tr>
		<tr> 
			<td colspan="3" align="center">
				<font size="2"><strong><cfoutput><cf_translate key="LB_Desde">Desde</cf_translate> </cfoutput></strong><cfoutput>#LSDateFormat(rsDatosNomina.RCdesde,'dd/mm/yyyy')#</cfoutput><strong><cfoutput><cf_translate key="LB_Hasta"> Hasta </cf_translate></cfoutput></strong><cfoutput>#LSDateFormat(rsDatosNomina.RChasta,'dd/mm/yyyy')#</cfoutput></font>
			</td>
		</tr>
		<tr><td colspan="3">&nbsp;</td></tr>
		<cfif isdefined('url.Tipo') and url.Tipo EQ 'D'>
			<tr>
				<td>
					<table width="85%" cellpadding="0" cellspacing="0" align="center">
						<cfset Lvar_TotalGralEmp = 0>
						<cfset Lvar_TotalGralPat = 0>
						<cfoutput query="rsReporte" group="DCcodigo">
							<tr><td height="1" bgcolor="000000" colspan="4"></td>
							<tr class="listaCorte1"><td colspan="4">&nbsp;#DCcodigo#&nbsp;-&nbsp;#DCdescripcion#</td></tr>
							<tr><td height="1" bgcolor="000000" colspan="4"></td>
							<tr class="listaCorte3" >
								<td>&nbsp;<cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
								<td>&nbsp;<cf_translate key="LB_Nombre">Nombre</cf_translate></td>
								<td align="right">&nbsp;<cf_translate key="LB_MontoEmpleado">Monto Empleado</cf_translate>&nbsp;</td>
								<td  align="right">&nbsp;<cf_translate key="LB_MontoEmpresa">Monto Empresa</cf_translate>&nbsp;</td>
							</tr>
							<tr><td height="1" bgcolor="000000" colspan="4"></td>
							<cfset Lvar_TotalEmp = 0>
							<cfset Lvar_TotalPat = 0>
							<cfoutput>
								<tr>
									<td class="detalle">&nbsp;#DEidentificacion#</td>
									<td class="detalle">&nbsp;#DEnombre#</td>
									<td class="detaller">#LSCurrencyFormat(CCvaloremp,'none')#</td>
									<td class="detaller">#LSCurrencyFormat(CCvalorpat,'none')#</td>
								</tr>
								<cfset Lvar_TotalEmp = Lvar_TotalEmp + CCvaloremp>
								<cfset Lvar_TotalPat = Lvar_TotalPat + CCvalorpat>
							</cfoutput>
							<tr><td height="1" bgcolor="000000" colspan="4"></td></tr>
							<tr>
							  <td colspan="2" class="detaller"><strong><cf_translate key="LB_Total">Total</cf_translate>&nbsp;#DCcodigo#&nbsp;-&nbsp;#DCdescripcion#</strong></td>
								<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalEmp,'none')#</strong></td>
								<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalPat,'none')#</strong></td>
							</tr>
							<tr><td colspan="4">&nbsp;</td></tr>
							<cfset Lvar_TotalGralEmp = Lvar_TotalGralEmp + Lvar_TotalEmp>
							<cfset Lvar_TotalGralPat = Lvar_TotalGralPat + Lvar_TotalPat>
						</cfoutput>
						<cfoutput>
						<tr>
							<td colspan="2" class="detaller"><strong><cf_translate key="LB_TotalGeneral">Total General</cf_translate>&nbsp;</strong></td>
							<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalGralEmp,'none')#</strong></td>
							<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalGralPat,'none')#</strong></td>
						</tr>
						</cfoutput>
						<tr><td colspan="4">&nbsp;</td></tr>
					</table>
				</td>
			</tr>
		<cfelse>
			<tr>
				<td>
					<table width="75%" cellpadding="0" cellspacing="0" align="center">
						<tr><td colspan="3" height="1" bgcolor="000000"></td></tr>
						<tr class="listaCorte3" >
							<td><strong><cf_translate key="LB_Carga">Carga</cf_translate></strong></td>
							<td align="right"><strong><cf_translate key="LB_MontoEmpleado">Monto Empleado</cf_translate></strong></td>
							<td align="right"><strong><cf_translate key="LB_MontoEmpresa">Monto Empresa</cf_translate></strong></td>
						</tr>	
						<tr><td colspan="3" height="1" bgcolor="000000"></td></tr>
						<cfset TotalGeneralEmp = 0>
						<cfset TotalGeneralPat = 0>
						<cfoutput query="rsReporte">
							<tr>
								<td class="detalle" nowrap>#DCcodigo#&nbsp;-&nbsp;#DCdescripcion#</td>
								<td class="detaller">#LSCurrencyFormat(TotalEmp,'none')#</td>
								<td class="detaller">#LSCurrencyFormat(TotalPat,'none')#</td>
							</tr>
							<cfset TotalGeneralEmp = TotalGeneralEmp + TotalEmp>
							<cfset TotalGeneralPat = TotalGeneralPat + TotalPat>
						</cfoutput>
						<cfoutput>
						<tr><td></td><td colspan="2" height="1" bgcolor="000000"></td></tr>
						<tr>
							<td class="detaller"><strong><cf_translate key="LB_TotalGeneral">Total General</cf_translate>&nbsp;</strong></td>
							<td class="detaller"><strong>#LSCurrencyFormat(TotalGeneralEmp,'none')#</strong></td>
							<td class="detaller"><strong>#LSCurrencyFormat(TotalGeneralPat,'none')#</strong></td>
						</tr>
						</cfoutput>
					</table>
				</td>
			</tr>
		</cfif>
	</table>

	</cfif>