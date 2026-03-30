<!--- ASIGNA LA INCIDENCIA EN CASO QUE SE DEBA TOMAR EN CUENTA LA INCIDENCIA DE CALCULO --->
<cfif isdefined('url.chkICalculo')>
	<cfset url.CIid = url.CIid1>
</cfif>
<cfif isdefined('url.historico')>
	<cfset url.RCNid = url.CPid>
	<cfset tablaCalculoNomina = 'HRCalculoNomina'>
	<cfset tablaIncidenciasCalculo = 'HIncidenciasCalculo'>
<cfelse>
	<cfset tablaCalculoNomina = 'RCalculoNomina'>
	<cfset tablaIncidenciasCalculo = 'IncidenciasCalculo'>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
		select 
		 ci.CIcodigo Incidencia,
		 <cf_dbfunction name="string_part" args="ci.CIdescripcion,1,30">  as  Descripcion,
		 <cf_dbfunction name="string_part" args="{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat(', ',e.DEnombre)})})})}|1|40" delimiters="|"> as Nombre,
		 <cf_dbfunction name="string_part" args="e.DEidentificacion,1,15"> Cedula, 
		 <cf_dbfunction name="date_format" args="a.ICfecha,DD/MM/YYYY">  Fecha,
		 cp.CPcodigo, 
		 cp.CPdesde, 
		 cp.CPhasta,
		 emp.Edescripcion,
		 z.RCDescripcion,
		 sum(a.ICvalor) Valor,
		 sum(a.ICmontores) Monto,
		 '#LSDateFormat(Now(), "dd/mm/yyyy")#' FechaHoy,
		 {fn concat(cf.CFcodigo,{fn concat(' - ',CFdescripcion)})} as CFdescripcion
			
		from #tablaIncidenciasCalculo# a
			, DatosEmpleado e
			, CIncidentes ci
			, CalendarioPagos cp
			, Empresas emp
			, #tablaCalculoNomina# z
			, CFuncional cf
		
		
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		  <cfif isdefined('url.CIid') and url.CIid GT 0>
		  and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid#">
		  </cfif>
		   and e.DEid = a.DEid
		   and ci.CIid = a.CIid
		   and a.RCNid = cp.CPid
		   and cp.Ecodigo = emp.Ecodigo
		   and z.RCNid = a.RCNid
		   and a.CFid = cf.CFid
		   <cfif not isdefined('url.chkICalculo')>
		   and ci.CItipo <> 3
		   </cfif>
		
		group by 
		 ci.CIcodigo,
		 <cf_dbfunction name="string_part" args="ci.CIdescripcion,1,30">  ,
		 <cf_dbfunction name="string_part" args="{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat(', ',e.DEnombre)})})})}|1|40" delimiters="|">,
		 <cf_dbfunction name="string_part" args="e.DEidentificacion,1,15">, 
		 <cf_dbfunction name="date_format" args="a.ICfecha,DD/MM/YYYY">,
		 cp.CPcodigo,
		 cp.CPdesde, 
		 cp.CPhasta,
		 emp.Edescripcion,
		 z.RCDescripcion,
		 {fn concat(cf.CFcodigo,{fn concat(' - ',CFdescripcion)})}	 
	 
	 
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
	    <cfset typeRep = 1>
		<!--- <cf_js_reports_service_tag queryReport = "#rsReporte#" 
			isLink = False 
			typeReport = typeRep
			fileName = "Reporte de Incidencias"/> --->
			<cf_QueryToFile query="#rsReporte#" FILENAME="Reporte_de_Incidencias.xls" titulo="Reporte de Incidencias">
	<cfelse>
		<cfreport format="#url.formato#" template= "RepRCIncidencias.cfr" query="rsReporte">
			<cfreportparam name="Empresa" value="#Session.Enombre#">
			<cfif isdefined("url.formato") and Len(Trim(url.formato))>
				<cfreportparam name="formato" value="#url.formato#">
			</cfif>
		</cfreport>
	</cfif>
<cfelse>
	<cfinvoke Key="LB_Incidencias" Default="Incidencias" returnvariable="LB_Incidencias" component="sif.Componentes.Translate" method="Translate"/>
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
		<cfif isdefined('url.Agrupa') and url.Agrupa EQ 'D'>
			<cfquery name="rsReporte" dbtype="query">
				select Incidencia,Descripcion,Valor,Monto,Nombre,Cedula,Fecha
				from rsReporte
				order by Incidencia,Cedula
			</cfquery>
		<cfelse>
			<cfquery name="rsReporte" dbtype="query">
				select Incidencia,Descripcion,
					sum(Valor) as Valor,
					sum(Monto) as Monto,
					Nombre,Cedula
				from rsReporte
				group by Incidencia,Descripcion,
					Nombre,Cedula
				order by Incidencia,Cedula
			</cfquery>
		</cfif>
	<cfelse>
  		<cfquery name="rsReporte" dbtype="query">
			select Incidencia,Descripcion,sum(Valor) as TotalValorInc,Sum(Monto) as TotalMontoInc
			from rsReporte
			group by Incidencia,Descripcion
		</cfquery>
	</cfif>
	<cfif isdefined('url.historico')>
		<cfset Lvar_irA = '../../indexHistoricos.cfm'>
	<cfelse>
		<cfset Lvar_irA = '../../indexReportes.cfm?Tcodigo=#url.Tcodigo#&fecha=#rsDatosNomina.RCdesde#&RCNid=#url.RCNid#'>
	</cfif>

	<cf_htmlreportsheaders
		title="#LB_Incidencias#" 
		filename="ReporteIncidencias#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
		ira="#Lvar_irA#"
		method="url">
	<table width="80%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
		<tr><td colspan="3" align="center"><font size="2"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td></tr>
		<tr> 
			<td colspan="3" align="center">
				<font size="2"><strong><cf_translate key="LB_Reporte_de_IncidenciasDeNomina_en_Proceso">Reporte de Incidencias de N&oacute;minas en Proceso</cf_translate></strong></font>
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
						<cfset Lvar_TotalGralValor = 0>
						<cfset Lvar_TotalGralMonto = 0>
						<cfif isdefined('url.Agrupa') and url.Agrupa EQ 'D'><cfset Lvar_ColSpan = 5><cfelse><cfset Lvar_ColSpan = 4></cfif>
						<cfoutput query="rsReporte" group="Incidencia">
							<tr><td height="1" bgcolor="000000" colspan="5"></td>
							<tr class="listaCorte1"><td colspan="#Lvar_ColSpan#">&nbsp;#Incidencia#&nbsp;-&nbsp;#Descripcion#</td></tr>
							<tr><td height="1" bgcolor="000000" colspan="#Lvar_ColSpan#"></td>
							<tr class="listaCorte3" >
								<td>&nbsp;<cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
								<td>&nbsp;<cf_translate key="LB_Nombre">Nombre</cf_translate></td>
								<cfif isdefined('url.Agrupa') and url.Agrupa EQ 'D'>
								<td>&nbsp;<cf_translate key="LB_Fecha">Fecha</cf_translate></td>
								</cfif>
								<td align="right">&nbsp;<cf_translate key="LB_Valor">Valor</cf_translate>&nbsp;</td>
								<td  align="right">&nbsp;<cf_translate key="LB_Monto">Monto</cf_translate>&nbsp;</td>
							</tr>
							<tr><td height="1" bgcolor="000000" colspan="#Lvar_ColSpan#"></td>
							<cfset Lvar_TotalValor = 0>
							<cfset Lvar_TotalMonto = 0>
							<cfoutput>
								<tr>
									<td class="detalle">&nbsp;#Cedula#</td>
									<td class="detalle">&nbsp;#Nombre#</td>
									<cfif isdefined('url.Agrupa') and url.Agrupa EQ 'D'>
									<td class="detalle">&nbsp;#LSDateFormat(Fecha,'dd/mm/yyyy')#</td>
									</cfif>
									<td class="detaller">#LSCurrencyFormat(Valor,'none')#</td>
									<td class="detaller">#LSCurrencyFormat(Monto,'none')#</td>
								</tr>
								<cfset Lvar_TotalValor = Lvar_TotalValor + Valor>
								<cfset Lvar_TotalMonto = Lvar_TotalMonto + Monto>
							</cfoutput>
							<tr><td height="1" bgcolor="000000" colspan="#Lvar_ColSpan#"></td></tr>
							<tr>
							  <td colspan="#Lvar_ColSpan-2#" class="detaller"><strong><cf_translate key="LB_Total">Total</cf_translate>&nbsp;#Incidencia#&nbsp;-&nbsp;#Descripcion#</strong></td>
								<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalValor,'none')#</strong></td>
								<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalMonto,'none')#</strong></td>
							</tr>
							<tr><td colspan="#Lvar_ColSpan#">&nbsp;</td></tr>
							<cfset Lvar_TotalGralValor = Lvar_TotalGralValor + Lvar_TotalValor>
							<cfset Lvar_TotalGralMonto = Lvar_TotalGralMonto + Lvar_TotalMonto>
						</cfoutput>
						<cfoutput>
						<tr>
							<td colspan="#Lvar_ColSpan-2#" class="detaller"><strong><cf_translate key="LB_TotalGeneral">Total General</cf_translate>&nbsp;</strong></td>
							<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalGralValor,'none')#</strong></td>
							<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalGralMonto,'none')#</strong></td>
						</tr>
						</cfoutput>
						<tr><td colspan="#Lvar_ColSpan#">&nbsp;</td></tr>
					</table>
				</td>
			</tr>
		<cfelse>
			<tr>
				<td>
					<table width="75%" cellpadding="0" cellspacing="0" align="center">
						<tr><td colspan="3" height="1" bgcolor="000000"></td></tr>
						<tr class="listaCorte3" >
							<td><strong><cf_translate key="LB_ConceptoIncidente">Concepto Incidente</cf_translate></strong></td>
							<td align="right"><strong><cf_translate key="LB_Valor">Valor</cf_translate></strong></td>
							<td align="right"><strong><cf_translate key="LB_Monto">Monto</cf_translate></strong></td>
						</tr>	
						<tr><td colspan="3" height="1" bgcolor="000000"></td></tr>
						<cfset TotalGeneralMonto = 0>
						<cfset TotalGeneralValor = 0>
						<cfoutput query="rsReporte">
							<tr>
								<td class="detalle" nowrap>#Incidencia#&nbsp;-&nbsp;#Descripcion#</td>
								<td class="detaller">#LSCurrencyFormat(TotalValorInc,'none')#</td>
								<td class="detaller">#LSCurrencyFormat(TotalMontoInc,'none')#</td>
							</tr>
							<cfset TotalGeneralValor = TotalGeneralValor + TotalValorInc>
							<cfset TotalGeneralMonto = TotalGeneralMonto + TotalMontoInc>
						</cfoutput>
						<cfoutput>
						<tr><td></td><td colspan="2" height="1" bgcolor="000000"></td></tr>
						<tr>
							<td class="detaller"><strong><cf_translate key="LB_TotalGeneral">Total General</cf_translate>&nbsp;</strong></td>
							<td class="detaller"><strong>#LSCurrencyFormat(TotalGeneralValor,'none')#</strong>&nbsp;</td>
							<td class="detaller"><strong>#LSCurrencyFormat(TotalGeneralMonto,'none')#</strong>&nbsp;</td>
						</tr>
						</cfoutput>
					</table>
				</td>
			</tr>
		</cfif>
	</table>
</cfif>