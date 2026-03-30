
<cfif isdefined('url.historico')>
	<cfset url.RCNid = url.CPid>
	<cfset tablaCalculoNomina = 'HRCalculoNomina'>
	<cfset tablaDeduccionesCalculo = 'HDeduccionesCalculo'>
	<cfset tablaSalarioEmpleado = 'HSalarioEmpleado'>
	<cfset tablaPagosEmpleado = 'HPagosEmpleado'>
<cfelse>
	<cfset tablaCalculoNomina = 'RCalculoNomina'>
	<cfset tablaDeduccionesCalculo = 'DeduccionesCalculo'>
	<cfset tablaSalarioEmpleado = 'SalarioEmpleado'>
	<cfset tablaPagosEmpleado = 'PagosEmpleado'>
</cfif>

<cfset Lvar_Renta = 1>
<cfset Lvar_TDid = 0>
<!--- SE BUSCA A DEDUCCIN DE RENTA PARA TOMARLA ENCUENTA DENTRO DEL REPORTE --->
 	<cfquery name="rsRenta" datasource="#session.DSN#">
	 	Select TDid
		from TDeduccion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 <cfif isdefined('url.TDid') and url.TDid GT 0>
		 and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDid#">
		 </cfif>
		  and TDrenta = 1
	</cfquery>
	<cfif isdefined('rsRenta') and rsRenta.RecordCount EQ 0>
		<cfset Lvar_Renta = 0>
	<cfelseif isdefined('rsRenta') and rsRenta.RecordCount GT 0>
		<cfset Lvar_TDid = rsRenta.TDid>
	</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select
	a.RCDescripcion,
	emp.Ecodigo, 
	emp.Edescripcion as Empresa, 
	d.TDid,
	d.TDcodigo,
	d.TDdescripcion,
	sn.SNcodigo,
	sn.SNnumero,
	sn.SNnombre,
	cp.CPcodigo, 
	<cf_dbfunction name="date_format" args="cp.CPdesde,DD/MM/YYYY">  as CPdesde, 
	<cf_dbfunction name="date_format" args="cp.CPhasta,DD/MM/YYYY">  as CPhasta, 
	de.DEidentificacion,
	{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})} as DEnombre,
	b.DCvalor as DCvalor,
	coalesce(c.Dmonto,0) as Dmonto,
	case when c.Dcontrolsaldo = 1 then c.Dsaldo else 0 end Dsaldo,
	( select {fn concat (rtrim(max(cf.CFcodigo)),{fn concat(' - ' ,rtrim(max(cf.CFdescripcion)))})}
	from #tablaPagosEmpleado# pe, RHPlazas pl, CFuncional cf 
	where pe.RCNid = b.RCNid 
	  and pe.DEid = b.DEid 
	  and pe.PEdesde = (select max(pe2.PEdesde) from #tablaPagosEmpleado# pe2 where pe2.RCNid = pe.RCNid and pe2.DEid = pe.DEid)
	  and pl.RHPid = pe.RHPid 
	  and cf.CFid = pl.CFid
	) as CFdescripcion,
	'#LSDateFormat(Now(), "dd/mm/yyyy")#' as fecha,
	c.Dreferencia,
	'#session.Enombre#' as Edescripcion
	from #tablaCalculoNomina# a, #tablaDeduccionesCalculo# b, DeduccionesEmpleado c, TDeduccion  d, CalendarioPagos cp, DatosEmpleado de, SNegocios sn, Empresas emp
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.Ecodigo = emp.Ecodigo
	  and cp.CPid = a.RCNid
	  and a.RCNid = b.RCNid
	  and b.Did = c.Did
	  and b.DEid = de.DEid
	  and c.TDid = d.TDid
	  and c.Ecodigo = a.Ecodigo
	  and c.Ecodigo = sn.Ecodigo
	  and c.SNcodigo = sn.SNcodigo
	  and d.Ecodigo = a.Ecodigo
	  <cfif isdefined('url.TDid') and url.TDid GT 0>
	  and d.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDid#">
	  </cfif>
	<cfif Lvar_Renta and not isdefined('url.chkAgrupar')>
	union all
		select RCDescripcion,
				emp.Ecodigo, 
				emp.Edescripcion as Empresa, 
				d.TDid,
				d.TDcodigo,
				d.TDdescripcion,
				0,'','',
				cp.CPcodigo, 
				<cf_dbfunction name="date_format" args="cp.CPdesde,DD/MM/YYYY">  as CPdesde, 
				<cf_dbfunction name="date_format" args="cp.CPhasta,DD/MM/YYYY">  as CPhasta,
				de.DEidentificacion,
				{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})} as DEnombre, 
				SErenta as DCvalor,
				coalesce(c.Dmonto,0) as Dmonto,
				c.Dsaldo as Dsaldo,
				( select max({fn concat (rtrim(max(cf.CFcodigo)),{fn concat(' - ' ,rtrim(max(cf.CFdescripcion)))})})
				from #tablaPagosEmpleado# pe, RHPlazas pl, CFuncional cf 
				where pe.RCNid = b.RCNid 
				  and pe.DEid = b.DEid 
				  and pe.PEdesde = (select max(pe2.PEdesde) from #tablaPagosEmpleado# pe2 where pe2.RCNid = pe.RCNid and pe2.DEid = pe.DEid)
				  and pl.RHPid = pe.RHPid 
				  and cf.CFid = pl.CFid
				) as CFdescripcion,
				'#LSDateFormat(Now(), "dd/mm/yyyy")#' as fecha,
				c.Dreferencia,
				'#session.Enombre#' as Edescripcion
			from #tablaCalculoNomina# a, 
				 #tablaSalarioEmpleado# b,
				 DeduccionesEmpleado c,
				 TDeduccion d,
				 DatosEmpleado de,
				 Empresas emp,
				 CalendarioPagos cp
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
			  and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and b.RCNid = a.RCNid
			  and b.DEid = c.DEid
			  and c.TDid = d.TDid
			  and d.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_TDid#">
			  and b.SErenta > 0
			  and c.Dactivo = 1
			  and b.DEid = de.DEid
			  and a.Ecodigo = de.Ecodigo 
			  and a.Ecodigo = emp.Ecodigo
			  and cp.CPid = a.RCNid
	</cfif>

	order by 5, 7, 14
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
			typeReport = "#typeRep#"
			fileName = "Reporte de Deducciones"/> --->

		<cf_QueryToFile query="#rsReporte#" FILENAME="Reporte_de_Deducciones.xls" titulo="Reporte de Deducciones">

	<cfelse>
		<cfreport format="#url.formato#" template= "RepRCDeducciones.cfr" query="rsReporte"></cfreport>
	</cfif>
<cfelse>

	<cfinvoke key="LB_Deducciones" default="Deducciones" returnvariable="LB_Deducciones" component="sif.Componentes.Translate" method="Translate"/>
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
			select TDid,TDcodigo,TDdescripcion,DEidentificacion,DEnombre,DCvalor,Dmonto, Dsaldo
			from rsReporte
			where DCvalor > 0
			order by TDid,DEidentificacion
		</cfquery>
	<cfelse>
  		<cfquery name="rsReporte" dbtype="query">
			select TDid,TDcodigo,TDdescripcion,sum(DCvalor) as TotalDeduc, sum(Dsaldo) as Dsaldo
			from rsReporte
			group by TDid,TDcodigo,TDdescripcion
		</cfquery>
	</cfif>
	
	<cfif isdefined('url.historico')>
		<cfset Lvar_irA = '../../indexHistoricos.cfm'>
	<cfelse>
		<cfset Lvar_irA = '../../indexReportes.cfm?Tcodigo=#url.Tcodigo#&fecha=#rsDatosNomina.RCdesde#&RCNid=#url.RCNid#'>
	</cfif>

	<cf_htmlreportsheaders
			title="#LB_Deducciones#" 
			filename="ReporteDeducciones#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
			ira="#Lvar_irA#"
			method="url">
	<table width="80%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
		<tr><td colspan="3" align="center"><font size="2"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td></tr>
		<tr> 
			<td colspan="3" align="center">
				<font size="2"><strong><cf_translate key="LB_Reporte_de_DeduccionesDeNomina_en_Proceso">Reporte de Deducciones de N&oacute;minas en Proceso</cf_translate></strong></font>
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
					<table width="85%" cellpadding="0" cellspacing="0" align="center" border="0">
						<cfset Lvar_TotalGralDesc = 0>
						<cfoutput query="rsReporte" group="TDid">
						 	<cfflush interval="512">
							<tr><td height="1" bgcolor="000000" colspan="5"></td>
							<tr class="listaCorte1"><td colspan="5">&nbsp;#TDcodigo#&nbsp;-&nbsp;#TDdescripcion#</td></tr>
							<tr><td height="1" bgcolor="000000" colspan="5"></td>
							<tr class="listaCorte3" >
								<td width="15%">&nbsp;<cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
								<td width="40%">&nbsp;<cf_translate key="LB_Nombre">Nombre</cf_translate></td>
								<td width="15%" align="right">&nbsp;<cf_translate key="LB_Principal">Principal</cf_translate>&nbsp;</td>
								<td width="15%" align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
								<td width="15%" align="right"><cf_translate key="LB_Saldo">Saldo</cf_translate></td>
							</tr>
							<tr><td height="1" bgcolor="000000" colspan="5"></td>
							<cfset Lvar_TotalDesc = 0>
							<cfoutput>
								<tr>
									<td class="detalle">#DEidentificacion#</td>
									<td class="detalle">#DEnombre#</td>
									<td class="detaller">#LSCurrencyFormat(Dmonto,'none')#</td>
									<td class="detaller">#LSCurrencyFormat(DCvalor,'none')#</td>
									<td class="detaller">#LSCurrencyFormat(Dsaldo,'none')#</td>
								</tr>
								<cfset Lvar_TotalDesc = Lvar_TotalDesc + DCvalor>
							</cfoutput>
							<tr>
								<td colspan="2"></td>
								<td height="1" bgcolor="000000"></td>
								<td height="1" bgcolor="000000"></td>
								<td height="1" bgcolor="000000"></td>
							</tr>
							<tr>
							  <td colspan="4" class="detaller"><strong><cf_translate key="LB_Total">Total</cf_translate>&nbsp;#TDcodigo#&nbsp;-&nbsp;#TDdescripcion#</strong></td>
								<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalDesc,'none')#</strong></td>
							</tr>
							<tr><td colspan="4">&nbsp;</td></tr>
							<cfset Lvar_TotalGralDesc = Lvar_TotalGralDesc + Lvar_TotalDesc>
						</cfoutput>
						<cfoutput>
						<tr>
							<td colspan="3" class="detaller"><strong><cf_translate key="LB_TotalGeneral">Total General</cf_translate>&nbsp;</strong></td>
							<td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalGralDesc,'none')#</strong></td>
							<td>&nbsp;</td>
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
						<tr class="listaCorte3" >
							<td><strong><cf_translate key="LB_Deduccion">Deducci&oacute;n</cf_translate></strong></td>
							<td align="right"><strong><cf_translate key="LB_Monto">Monto </cf_translate></strong></td>
						</tr>	
						<cfset  TotalGeneral = 0>
						<cfset  TotalGeneralSaldo = 0>
						<cfoutput query="rsReporte">
						<cfflush interval="512">
							<tr>
								<td class="detalle">#TDcodigo#&nbsp;-&nbsp;#TDdescripcion#</td>
								<td class="detaller">#LSCurrencyFormat(TotalDeduc,'none')#</td>
								
							</tr>
							<cfset TotalGeneral = TotalGeneral + TotalDeduc>
							
						</cfoutput>
						<tr><td></td><td height="1" bgcolor="000000"></td><td height="1" bgcolor="000000"></td></tr>
						<tr>
							
							<td class="detaller"><strong><cf_translate key="LB_TotalGeneral">Total General</cf_translate>&nbsp;</strong></td>
							<td class="detaller"><cfoutput>#LSCurrencyFormat(TotalGeneral,'none')#</cfoutput></td>
						</tr>
					</table>
				</td>
			</tr>
		</cfif>
	</table>

</cfif>


