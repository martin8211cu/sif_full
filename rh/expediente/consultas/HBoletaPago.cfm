<!--- PARÁMETROS--->
<cfif isdefined("url.RCNid") and not isdefined("form.RCNid")>	
	<cfset form.RCNid = url.RCNid >
</cfif>

<cfif isdefined("url.DEid") and not isdefined("form.DEid")>	
	<cfset form.DEid = url.DEid >
</cfif>

<cfif isdefined("url.Tcodigo") and not isdefined("form.Tcodigo")>	
	<cfset form.Tcodigo = url.Tcodigo >
</cfif>

<cfif isdefined("url.chkIncidencias") and not isdefined("form.chkIncidencias")>	
	<cfset form.chkIncidencias = url.chkIncidencias >
</cfif>

<cfif isdefined("url.chkCargas") and not isdefined("form.chkCargas")>	
	<cfset form.chkCargas = url.chkCargas >
</cfif>

<cfif isdefined("url.chkDeducciones") and not isdefined("form.chkDeducciones")>	
	<cfset form.chkDeducciones = url.chkDeducciones >
</cfif>

<!--- CONSULTAS --->

<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo 
	from Monedas a, HRCalculoNomina b, TiposNomina c 
	where b.Tcodigo = c.Tcodigo 
	and a.Mcodigo = c.Mcodigo 
	and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>

<cfquery name="rsHistorico" datasource="#Session.DSN#">
	select c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
	from HRCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
key="LB_Boleta_Pago"
default="Boleta de Pago"
returnvariable="LB_Boleta"/> 

<cfset Titulo = "#LB_Boleta#: " & rsHistorico.RCDescripcion>

<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#">
	select 
	{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )}as nombreEmpl	, DEemail, DEidentificacion, NTIdescripcion
	from DatosEmpleado de, NTipoIdentificacion ti
	where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and de.NTIcodigo = ti.NTIcodigo
</cfquery>

<cfquery name="rsSalBrutoMensual" datasource="#Session.DSN#">
	select coalesce(PEsalario,0) as PEsalario
	from HPagosEmpleado a
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.PEtiporeg = 0
	and a.PEdesde = (
		select max(PEdesde)
		from HPagosEmpleado
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and PEtiporeg = 0
	)
</cfquery>

<cfquery name="rsSalBrutoRelacion" datasource="#Session.DSN#">
	select sum(PEmontores) as Monto
	from HPagosEmpleado a
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.PEtiporeg = 0
</cfquery>

<cfquery name="rsRetroactivos" datasource="#Session.DSN#">
	select sum(PEmontores) as Monto
	from HPagosEmpleado a
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.PEtiporeg > 0
</cfquery>

<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
	select SErenta, SEcargasempleado, SEdeducciones
	from HSalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>

<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
	select ICid as ICid, b.CIdescripcion, a.ICfecha, 
		   (case when CItipo < 2 then a.ICvalor else null end) as ICvalor, 
		   (case when (CItipo < 2 and a.ICvalor > 0) then round(a.ICmontores/(a.ICvalor*1.00), 2) else null end) as ICvalorcalculado, 
		   a.ICmontores, a.ICcalculo
	from HIncidenciasCalculo a, CIncidentes b
	where a.CIid = b.CIid
	and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and CIcarreracp = 0		<!--- no considera conceptos de pago por carrera profesional --->
	order by a.ICfecha
</cfquery>
<cfif rsIncidenciasCalculo.recordCount GT 0>
	<cfquery name="rsSumIncidencias" dbtype="query">
		select sum(ICmontores) as Monto
		from rsIncidenciasCalculo
	</cfquery>
	<cfset montoIncidencias = rsSumIncidencias.Monto + Iif(Len(Trim(rsRetroactivos.Monto)), DE(rsRetroactivos.Monto), DE("0.00"))>
<cfelse>
	<cfset montoIncidencias = 0.00 + Iif(Len(Trim(rsRetroactivos.Monto)), DE(rsRetroactivos.Monto), DE("0.00"))>
</cfif>			

<cfquery name="rsIncidenciasCarreraP" datasource="#Session.DSN#">
	select ICid as ICid, b.CIdescripcion, a.ICfecha, 
		   (case when CItipo < 2 then a.ICvalor else null end) as ICvalor, 
		   (case when (CItipo < 2 and a.ICvalor > 0) then round(a.ICmontores/(a.ICvalor*1.00), 2) else null end) as ICvalorcalculado, 
		   a.ICmontores, a.ICcalculo,CCPid, CCPacumulable, CCPprioridad, TCCPid
	from HIncidenciasCalculo a, CIncidentes b, ConceptosCarreraP c
	where a.CIid = b.CIid
	and c.CIid = b.CIid
	and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and CIcarreracp = 1		<!--- considera conceptos de pago por carrera profesional --->
	order by a.ICfecha
</cfquery>

<cfif rsIncidenciasCarreraP.recordCount GT 0>
	<cfquery name="rsSumIncidencias" dbtype="query">
		select sum(ICmontores) as Monto
		from rsIncidenciasCarreraP
	</cfquery>
	<cfset montoCarreraP = rsSumIncidencias.Monto >
<cfelse>
	<cfset montoCarreraP = 0.00 >
</cfif>			

<cfquery name="rsTotalesResumido" dbtype="query">
	select #rsSalBrutoRelacion.Monto# + #montoIncidencias# + #montoCarreraP# as Pagos,
		   SErenta + SEcargasempleado + SEdeducciones as Deducciones,
		   (#rsSalBrutoRelacion.Monto# + #montoIncidencias# + #montoCarreraP#) - (SErenta + SEcargasempleado + SEdeducciones) as Liquido
	from rsSalarioEmpleado
</cfquery>

<cfquery name="rsCargas" datasource="#Session.DSN#">
	select a.DClinea as DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto, ECresumido, c.ECid
	from HCargasCalculo a, DCargas b, ECargas c
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	  and a.DClinea = b.DClinea
	  and b.ECid = c.ECid
	  and CCvaloremp is not null
	  and CCvaloremp <> 0
	  order by c.ECid
</cfquery>

<cfquery name="rsSumCargas" dbtype="query">
	select sum(CCvaloremp) as cargas
	from rsCargas
</cfquery>
<cfif rsSumCargas.recordCount GT 0>
	<cfset SumCargas = rsSumCargas.cargas>
<cfelse>
	<cfset SumCargas = 0.00>
</cfif>

<cfquery name="rsDeducciones" datasource="#Session.DSN#">
	select a.Did as Did, a.DCvalor, 
		   a.DCinteres, a.DCcalculo, b.Ddescripcion, 
		   b.Dvalor, b.Dmetodo, a.DCsaldo, 
		   b.Dcontrolsaldo, b.Dreferencia
	from HDeduccionesCalculo a, DeduccionesEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Did = b.Did
	order by b.Dreferencia
</cfquery>
<cfquery name="rsSumDeducciones" dbtype="query">
	select sum(DCvalor) as deduc
	from rsDeducciones
</cfquery>
<cfif rsSumDeducciones.recordCount GT 0>
	<cfset SumDeducciones = rsSumDeducciones.deduc>
<cfelse>
	<cfset SumDeducciones = 0.00>
</cfif>

<cfquery name="rsDetalleMovimientos" datasource="#Session.DSN#">
	select 
		case when a.DLfvigencia is not null then <cf_dbfunction name="date_format" args="a.DLfvigencia,DD/MM/YY"> else '&nbsp;' end as Vigencia,
		case when a.DLffin is not null then <cf_dbfunction name="date_format" args="a.DLffin,DD/MM/YY"> else '&nbsp;' end as Finalizacion,
		a.DLsalario as DLsalario, 
		a.DLsalarioant as DLsalarioant, 
		<cf_dbfunction name="date_format" args="a.DLfechaaplic,DD/MM/YY"> as FechaAplicacion,
		b.RHTdesc as Descripcion
	from DLaboralesEmpleado a, RHTipoAccion b, HRCalculoNomina c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.RHTid = b.RHTid
	and a.Ecodigo = b.Ecodigo
	and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.Ecodigo = c.Ecodigo
	and a.DLfechaaplic between c.RCdesde and c.RChasta
	order by a.DLfechaaplic
</cfquery>

	<!--- ================================================================== --->
	<!--- Calculo de salario por hora  										 ---> 
	<!--- ================================================================== --->
	<cfquery name="rsDias" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_float" args="FactorDiasSalario"> as dias, r.RChasta
		from TiposNomina t, HRCalculoNomina r
		where t.Ecodigo = r.Ecodigo
		  and t.Tcodigo = r.Tcodigo
		  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif isdefined('rsSalBrutoMensual') and rsSalBrutoMensual.RecordCount GT 0>
		<cfset vSalarioBruto = rsSalBrutoMensual.PEsalario >
	<cfelse>
		<cfset vSalarioBruto = 0>
	</cfif>
	<cfset vDiasNomina = rsDias.dias >

	<cfset vHorasDiarias = 0 >
	<cfquery name="rsHoras" datasource="#session.DSN#" >
		select RHJhoradiaria, RHJornadahora
		from RHJornadas a, LineaTiempo b
		where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and a.Ecodigo = #Session.Ecodigo#
		and b.Ecodigo = #Session.Ecodigo#
		and a.RHJid = b.RHJid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDias.RChasta#"> between LTdesde and LThasta 
	</cfquery>
	<cfif isdefined('rsHoras') and rsHoras.RecordCount>
		<cfset vHorasDiarias = rsHoras.RHJhoradiaria >
		<cfset vSalarioporHora = rsHoras.RHJornadahora >
	<cfelse>
		<cfset vHorasDiarias = 0>
		<cfset vSalarioporHora = 0>
	</cfif>
	<cfif vSalarioBruto GT 0 and vDiasNomina GT 0 and vHorasDiarias GT 0>
		<cfset vSalarioHora = (vSalarioBruto/vDiasNomina)/vHorasDiarias >	
	<cfelse>
		<cfset vSalarioHora = 0>
	</cfif>

	<!--- ================================================================== --->
	<!--- ================================================================== --->

<cfsavecontent variable="info">
	<html>
	<head>
	<title>Boleta de Pago</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	
	<body>
	<style type="text/css">
		td {font-size: 8pt; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
	</style>
	
	<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border: 2px solid black;">
		<tr><td align="center"><strong>#Session.Enombre#</strong></td></tr>
		<tr><td align="center"><strong><cf_translate xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" key="LB_Boleta_Pago">Boleta de Pago</cf_translate> : #rsHistorico.RCDescripcion#</strong></td></tr>
		<tr><td align="center"><strong><cf_translate xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" key="LB_Del">Del</cf_translate>: #LSDateFormat(rsHistorico.RCdesde,'dd/mm/yyyy')# <cf_translate xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" key="LB_Al">al</cf_translate> #LSDateFormat(rsHistorico.RChasta,'dd/mm/yyyy')# </strong></td></tr>
		<tr><td align="center"><strong><cf_translate xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" key="LB_Fecha_de_Pago">Fecha de Pago</cf_translate>: #LSDateFormat(rsHistorico.CPfpago,'dd/mm/yyyy')#</strong></td></tr>
		<tr><td align="center">&nbsp;</td></tr>
	  	<tr>
			<td align="center">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="30%" nowrap><strong><cf_translate key="LB_Nombre_Completo" xmlfile="/rh/generales.xml">Nombre Completo</cf_translate>: </strong></td>
						<td nowrap>#rsEncabEmpleado.NombreEmpl#</td>
					</tr>
					<tr>
						<td nowrap><strong><cf_translate key="LB_Cedula" xmlfile="/rh/generales.xml">C&eacute;dula</cf_translate>:</strong></td>
						<td nowrap>#rsEncabEmpleado.DEidentificacion#</td>
					</tr>
					<tr>
						<td nowrap><strong><cf_translate key="LB_Salario_Bruto_Mensual" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Bruto Mensual</cf_translate>:</strong></td>
						<td align="right" nowrap><strong>#LSCurrencyFormat(rsSalBrutoMensual.PEsalario, 'none')#</strong></td>
					</tr>
					<tr>
						<td nowrap><strong><cf_translate key="LB_SalarioBruto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Bruto</cf_translate> #rsHistorico.RCDescripcion#:</strong></td>
						<td align="right" nowrap><strong>#LSCurrencyFormat(rsSalBrutoRelacion.Monto, 'none')#</strong></td>
					</tr>
					<cfif vSalarioporHora GT 0>
						<tr>
							<td nowrap><strong><cf_translate xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" key="LB_Salario_por_Hora">Salario por Hora</cf_translate>:</strong></td>
							<td align="right" nowrap><strong>#LSCurrencyFormat(vSalarioHora, 'none')#</strong></td>
						</tr>
					</cfif>
				</table>
			</td>
	  	</tr>
	  	<tr><td align="center">&nbsp;</td></tr>
		<tr>
			<td align="center" style="border-top: 2px solid black; ">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					<tr align="center">
						<td colspan="5" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate  key="LB_InformacionResumida" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Informaci&oacute;n de Pago Resumida</cf_translate></strong></td>
					</tr>
					<tr>
						<td colspan="5" align="center" nowrap>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" align="center" bgcolor="##CCCCCC" nowrap><strong><cf_translate xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" key="LB_Conceptos_de_Pago">Conceptos de Pago</cf_translate></strong></td>
						<td width="20" align="center" nowrap>&nbsp;</td>
						<td colspan="2" align="center" bgcolor="##CCCCCC" nowrap><strong><cf_translate  key="LB_InformacionResumida" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Deducciones</cf_translate></strong></td>
					</tr>
					<tr>
						<td nowrap><cf_translate key="LB_SalarioBruto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Bruto</cf_translate>:</td>
						<td align="right" nowrap>#LSCurrencyFormat(rsSalBrutoRelacion.Monto, 'none')#</td>
						<td align="right" nowrap>&nbsp;</td>
						<td nowrap><cf_translate key="LB_Cargas" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Cargas Laborales</cf_translate>:</td>
						<td align="right" nowrap><cfif rsSalarioEmpleado.SEcargasempleado GT 0>(</cfif>#LSCurrencyFormat(rsSalarioEmpleado.SEcargasempleado,'none')#<cfif rsSalarioEmpleado.SEcargasempleado GT 0>)</cfif></td>
					</tr>
					<tr>
						<td nowrap><cf_translate key="LB_Otros_Movimientos" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otros Movimientos</cf_translate>:</td>
						<td align="right" nowrap>
							#LSNumberFormat(montoIncidencias+montoCarreraP, '(___,___,___,___,___.__)')#
						</td>
						<td align="right" nowrap>&nbsp;</td>
						<td nowrap><cf_translate key="LB_Otras_Deducciones" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otras Deducciones</cf_translate>:</td>
						<td align="right" nowrap><cfif rsSalarioEmpleado.SEdeducciones GT 0>(</cfif>#LSCurrencyFormat(rsSalarioEmpleado.SEdeducciones,'none')#<cfif rsSalarioEmpleado.SEdeducciones GT 0>)</cfif></td>
					</tr>
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap><cf_translate key="LB_Renta" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Renta</cf_translate>:</td>
						<td align="right" nowrap><cfif rsSalarioEmpleado.SErenta GT 0>(</cfif>#LSCurrencyFormat(rsSalarioEmpleado.SErenta,'none')#<cfif rsSalarioEmpleado.SErenta GT 0>)</cfif></td>
					</tr>
					<tr><td nowrap colspan="5">&nbsp;</td></tr>
					<tr>
						<td nowrap><strong><cf_translate key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
						<td align="right" nowrap>#LSNumberFormat(rsTotalesResumido.Pagos, '(___,___,___,___,___.__)')#</td>
						<td align="right" nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td align="right" nowrap><cfif rsTotalesResumido.Deducciones GT 0>(</cfif>#LSCurrencyFormat(rsTotalesResumido.Deducciones, 'none')#<cfif rsTotalesResumido.Deducciones GT 0>)</cfif></td>
					</tr>
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap><strong><cf_translate key="LB_SalarioLIquido" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario L&iacute;quido</cf_translate>:</strong></td>
						<td align="right" nowrap>
							<strong>#rsMoneda.Msimbolo# #LSNumberFormat(rsTotalesResumido.Liquido, '(___,___,___,___,___.__)')#</strong>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	 	<tr><td align="center">&nbsp;</td></tr>
	  	<tr>
			<td align="center" style="border-top: 2px solid black; ">
			<!--- Parametro general de RH para determinar si se pinta o no las columnas de "Unidades" y "Valor" --->
				<cfquery name="rsParamRH" datasource="#Session.DSN#">
					select Pvalor
					from RHParametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and Pcodigo = 550
				</cfquery>				
				<cfset cantCols = 5>
				<cfset tamColDescr = 50>
				
				<cfif isdefined('rsParamRH') and rsParamRH.recordCount GT 0>
					<cfif rsParamRH.Pvalor EQ 1>
						<cfset cantCols = 5>
						<cfset tamColDescr = 50>
					<cfelse>
						<cfset cantCols = 3>
						<cfset tamColDescr = 75>
					</cfif>
				</cfif>		
				
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					<tr align="center">
						<td colspan="6" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate key="LB_Otros_Movimientos" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otros Movimientos</cf_translate></strong></td>
					</tr>
					
					<!--- Incidencias normales --->
					<cfif (rsIncidenciasCalculo.recordCount+rsIncidenciasCarreraP.recordCount) GT 0>
						<tr>
							<td width="10%" align="center" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Fecha">Fecha</cf_translate></strong></td>
							<td width="#tamColDescr#%" align="left" nowrap colspan="2"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
							<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
								<td width="10%" align="right" nowrap><strong><cf_translate key="LB_Unidades" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Unidades</cf_translate></strong></td>
								<td width="15%" align="right" nowrap><strong><cf_translate key="LB_Valor" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Valor</cf_translate></strong></td>
							</cfif>					
							<td width="15%" align="right" nowrap><strong><cf_translate key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
						</tr>
						<cfloop query="rsIncidenciasCalculo">
							<tr>
								<td align="center" style="border-top: 1px solid gray; " nowrap>#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
								<td align="left" style="border-top: 1px solid gray; " nowrap colspan="2">#CIdescripcion#</td>
								<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
									<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalor))>#LSNumberFormat(ICvalor,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
									<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalorcalculado))>#LSNumberFormat(ICvalorcalculado,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
								</cfif>							
								<td align="right" style="border-top: 1px solid gray; " nowrap>#LSNumberFormat(ICmontores,'(___,___,___,___,___.__)')#</td>
							</tr>
						</cfloop>
						<cfif rsIncidenciasCarreraP.recordCount GT 0 >
							<tr><td colspan="6" bgcolor="##CCCCCC" ><strong><cf_translate key="LB_Carerra_Profesional" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Carrera Profesional</cf_translate></strong></td></tr>
							<tr>
								<td width="10%" align="center" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Fecha">Fecha</cf_translate></strong></td>
								<td width="#tamColDescr#%" align="left" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
								<td width="#tamColDescr#%" align="left" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Puntos">Puntos</cf_translate></strong></td>
								<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
									<td width="10%" align="right" nowrap><strong><cf_translate key="LB_Unidades" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Unidades</cf_translate></strong></td>
									<td width="15%" align="right" nowrap><strong><cf_translate key="LB_Valor" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Valor</cf_translate></strong></td>
								</cfif>					
								<td width="15%" align="right" nowrap><strong><cf_translate key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
							</tr>
							<cfloop query="rsIncidenciasCarreraP">
								<cfinvoke component="rh.Componentes.RH_CalculoCP" method="AcumulaConceptos" returnvariable="Conceptos" conexion="#session.DSN#"
									ecodigo = "#session.Ecodigo#" ccpid = "#rsIncidenciasCarreraP.CCPid#" acumula = "#rsIncidenciasCarreraP.CCPacumulable#" tccpid="#rsIncidenciasCarreraP.TCCPid#"
									prioridad="#rsIncidenciasCarreraP.CCPprioridad#" rcdesde="#rsHistorico.RCdesde#" rchasta="#rsHistorico.RChasta#" deid = "#Form.DEid#"/>
						
								<tr>
									<td align="center" style="border-top: 1px solid gray; " nowrap>#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
									<td align="left" style="border-top: 1px solid gray; " nowrap>#CIdescripcion#</td>
									<td align="left" style="border-top: 1px solid gray; " nowrap>#Conceptos.valor#</td>
									<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
										<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalor))>#LSNumberFormat(ICvalor,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
										<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalorcalculado))>#LSNumberFormat(ICvalorcalculado,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
									</cfif>							
									<td align="right" style="border-top: 1px solid gray; " nowrap>#LSNumberFormat(ICmontores,'(___,___,___,___,___.__)')#</td>
								</tr>
							</cfloop>
						</cfif>
						
						<cfif Len(Trim(rsRetroactivos.Monto)) and Trim(rsRetroactivos.Monto) NEQ 0>
							<tr>
								<td align="center" style="border-top: 1px solid gray; " nowrap>&nbsp;</td>
								<td align="left" style="border-top: 1px solid gray; " nowrap colspan="2"><cf_translate key="LB_AJUSTE_RETROACTIVO" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">AJUSTE RETROACTIVO</cf_translate></td> 
								<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
									<td align="right" style="border-top: 1px solid gray; " nowrap>&nbsp;</td>
									<td align="right" style="border-top: 1px solid gray; " nowrap>&nbsp;</td>
								</cfif>						
								<td align="right" style="border-top: 1px solid gray; " nowrap>#LSNumberFormat(rsRetroactivos.Monto,'(___,___,___,___,___.__)')#</td>
							</tr>
						</cfif>
						<tr>
							<td align="left" style="border-top: 2px solid black; " nowrap><strong><cf_translate key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
							<td align="left" style="border-top: 2px solid black; " nowrap>&nbsp;</td>
							<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
								<td align="right" style="border-top: 2px solid black; " nowrap>&nbsp;</td>
								<td align="right" style="border-top: 2px solid black; " nowrap>&nbsp;</td>
							</cfif>								
							<td align="right" style="border-top: 2px solid black; " nowrap>
								<strong>#rsMoneda.Msimbolo# #LSNumberFormat(montoIncidencias+montocarreraP, '(___,___,___,___,___.__)')#</strong>
							</td>
						</tr>
					<cfelse>
						<tr>
							<td colspan="#tamColDescr#" align="center"><strong>--- <cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron otros movimientos registrados</cf_translate> ---</strong></td>
						</tr>
					</cfif>
				</table>
			</td>
	  	</tr>
	  	<tr><td align="center">&nbsp;</td></tr>
	  	<tr>
			<td align="center" style="border-top: 2px solid black; ">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					<tr align="center">
						<td colspan="2" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate key="LB_Cargas" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Cargas</cf_translate></strong></td>
					</tr>
					<cfset idBandera= "" >	
					<cfif rsCargas.recordCount GT 0>
						<tr>
							<td nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
							<td align="right" nowrap><strong><cf_translate key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
						</tr>
						<cfloop query="rsCargas">
						
						<cfif rsCargas.ECresumido is  1 >										            
					      <cfif idBandera neq #rsCargas.ECid#>  					     				  		 			  
			  				<cfquery name = "rsCargasCalculoResumido" datasource="#Session.DSN#">
						   		 select e.ECdescripcion as descripcion, sum(cc.CCvaloremp) as empleado
								 from HCargasCalculo cc, ECargas e, DCargas d
								 where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
				  				 and cc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
								 and e.ECid = #rsCargas.ECid#
				  				 and cc.DClinea = d.DClinea
				  	        	 and e.ECid = d.ECid  
				  				 and e.Ecodigo = #Session.Ecodigo#					
                    		     and cc.CCvaloremp is not null
		            			 and cc.CCvaloremp <> 0					
								 group by e.ECdescripcion, e.ECid 																					
				           </cfquery>							   
					   		<cfset idBandera=#rsCargas.ECid# >	
							<tr>
								<td style="border-top: 1px solid gray; " nowrap>#rsCargasCalculoResumido.descripcion#</td>							
								<td align="right" style="border-top: 1px solid gray; " nowrap><cfif rsCargasCalculoResumido.empleado NEQ 0>(</cfif>#LSCurrencyFormat(rsCargasCalculoResumido.empleado,'none')#<cfif rsCargasCalculoResumido.empleado NEQ 0>)</cfif></td>
							</tr>						
						 </cfif>
						<cfelse>
							<tr>
								<td style="border-top: 1px solid gray; " nowrap>#DCdescripcion#</td>
								<td align="right" style="border-top: 1px solid gray; " nowrap><cfif CCvaloremp NEQ 0>(</cfif>#LSCurrencyFormat(CCvaloremp,'none')#<cfif CCvaloremp NEQ 0>)</cfif></td>
							</tr>
							</cfif>
						</cfloop>
						<tr>
							<td style="border-top: 2px solid black; " nowrap><strong><cf_translate key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
							<td align="right" style="border-top: 2px solid black; " nowrap>
								<strong>#rsMoneda.Msimbolo# <cfif SumCargas NEQ 0>(</cfif>#LSCurrencyFormat(SumCargas,'none')#<cfif SumCargas NEQ 0>)</cfif></strong>
							</td>
						</tr>
					<cfelse>
						<tr align="center">
							<td colspan="2"><strong>--- <cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron cargas laborales registradas</cf_translate> ---</strong></td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
	  	<tr><td align="center">&nbsp;</td></tr>
	  	<tr>
			<td align="center" style="border-top: 2px solid black; ">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					<tr align="center">
						<td colspan="4" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate key="LB_Otras_Deducciones" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otras Deducciones</cf_translate></strong></td>
					</tr>
					<cfif rsDeducciones.recordCount GT 0>
						<tr>
							<td width="60%" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
							<td width="20%" nowrap><strong><cf_translate xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" key="LB_Referencia">Referencia</cf_translate></strong></td>
							<td align="right" nowrap><strong><cf_translate xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" key="LB_Saldo_Posterior">Saldo Posterior</cf_translate></strong></td>
							<td width="10%" align="right" nowrap><strong><cf_translate key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
						</tr>
						<cfloop query="rsDeducciones">
							<tr>
								<td style="border-top: 1px solid gray; " nowrap>#Ddescripcion#</td>
								<td style="border-top: 1px solid gray; " nowrap>#Dreferencia#</td>
								<td width="10%" align="right" style="border-top: 1px solid gray; " nowrap><cfif Dcontrolsaldo EQ 1>#LSCurrencyFormat(DCsaldo-DCvalor,'none')#<cfelse>&nbsp;</cfif></td>
								<td align="right" style="border-top: 1px solid gray; " nowrap><cfif DCvalor NEQ 0>(</cfif>#LSCurrencyFormat(DCvalor,'none')#<cfif DCvalor NEQ 0>)</cfif></td>
							</tr>
						</cfloop>
						<tr>
							<td style="border-top: 2px solid black; " nowrap><strong><cf_translate key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
							<td style="border-top: 2px solid black; " nowrap>&nbsp;</td>
							<td style="border-top: 2px solid black; " align="right" nowrap>&nbsp;</td>
							<td style="border-top: 2px solid black; " align="right" nowrap>
								<strong>#rsMoneda.Msimbolo# <cfif SumDeducciones NEQ 0>(</cfif>#LSCurrencyFormat(SumDeducciones,'none')#<cfif SumDeducciones NEQ 0>)</cfif></strong>
							</td>
						</tr>
					<cfelse>
						<tr align="center">
							<td colspan="4"><strong>--- <cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron deducciones registradas</cf_translate> ---</strong></td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
		<tr><td align="center">&nbsp;</td></tr>
	  	<tr>
			<td align="center" style="border-top: 2px solid black; ">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					<tr align="center">
						<td colspan="5" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate key="LB_Detalle_de_Movimientos" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Detalle de Movimientos</cf_translate></strong></td>
					</tr>
					<cfif rsDetalleMovimientos.recordCount GT 0>
						<tr>
							<td width="10%" align="center" nowrap><strong><cf_translate key="LB_Rige" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Rige</cf_translate></strong></td>
							<td width="10%" align="center" nowrap><strong><cf_translate key="LB_Vence" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Vence</cf_translate></strong></td>
							<td width="60%" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
							<td width="10%" align="right" nowrap><strong><cf_translate key="LB_Salario_Anterior" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Anterior</cf_translate></strong></td>
							<td width="10%" align="right" nowrap><strong><cf_translate key="LB_Salario_Posterior" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Posterior</cf_translate></strong></td>
						</tr>
						<cfloop query="rsDetalleMovimientos">
							<tr>
								<td align="center" style="border-top: 1px solid gray; " nowrap>#Vigencia#</td>
								<td align="center" style="border-top: 1px solid gray; " nowrap>#Finalizacion#</td>
								<td style="border-top: 1px solid gray; " nowrap>#Descripcion#</td>
								<td align="right" style="border-top: 1px solid gray; " nowrap>#DLsalarioant#</td>
								<td align="right" style="border-top: 1px solid gray; " nowrap>#DLsalario#</td>
							</tr>
						</cfloop>
					<cfelse>
						<tr align="center">
							<td colspan="5"><strong>--- <cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron movimientos registrados</cf_translate> ---</strong></td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
		<tr><td align="center">&nbsp;</td></tr>
	  	<tr>
			<td align="center" style="border-top: 2px solid black; "><strong><cf_translate key="MSG_Fin_de_Boleta_de_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Fin de Boleta de Pago</cf_translate>: #rsHistorico.RCDescripcion#</strong></td>
		</tr>
		<tr>
			<td align="center"><cf_translate key="MSG_Mensaje_generado" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Este mensaje es generado autom&aacute;ticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje.</cf_translate></td>
		</tr>
	</table>
	</cfoutput>
	</body>
	</html>
</cfsavecontent>

<!--- ENVÍA EL EMAIL --->
<cfinclude template="../../pago/operacion/EnviarEmails-funciones.cfm">

<cfscript>
	dequien = getRHPvalor(190);
	if (len(trim(dequien)) gt 0)
	{
		paraquien = "";
		enviarAlAdmin = getRHPvalor(170);
		if ( len(trim(enviarAlAdmin)) gt 0 and enviarAlAdmin eq 1 )
		{
			admin = getRHPvalor(180);
			if ( len(trim(admin)) gt 0 ) {
				paraquien = getEmailFromAdmin(admin);
			}
		}
		else
		{
			if ( len(trim(rsEncabEmpleado.DEemail)) gt 0 )
			{
				paraquien = rsEncabEmpleado.DEemail;
			}
			else
			{
				emailJefe = getEmailFromJefe(Form.DEid);
				if ( len(trim(emailJefe)) gt 0 )
				{
					paraquien = emailJefe;
				}
				else
				{
					admin = getRHPvalor(180);
					if ( len(trim(admin)) gt 0 ) {
						paraquien = getEmailFromAdmin(admin);
					}
				}
			}
		}
		
		mensaje = info;
				
		if ( len(trim(paraquien)) gt 0 )
		{
			enviarCorreo(dequien , paraquien, titulo, mensaje);
		}
	}
</cfscript>

<!--- RETORNA A LA PANTALLA --->
<html>
<head>
</head>
<body>
<cfoutput>

<form action="HResultadoCalculo.cfm" method="get" name="form1">
	<input type="hidden" name="RCNid" value="#form.RCNid#">
	<input type="hidden" name="Tcodigo" value="#Form.Tcodigo#">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<input type="hidden" name="CPcodigo" value="#Form.CPcodigo#">
	<!---<input type="hidden" name="Regresar" value="/cfmx/rh/nomina/consultas/ConsultaRCalculo.cfm">--->
	<cfif isdefined("form.Regresar") and trim(form.Regresar) neq 'HistoricoPagos.cfm' >
		<input type="hidden" name="Regresar" value="#form.regresar#">
	</cfif>

	<cfif isDefined("Form.chkIncidencias")>
		<input type="hidden" name="chkIncidencias" value="1">
	</cfif>

	<cfif isDefined("Form.chkCargas")>
		<input type="hidden" name="chkCargas" value="1">
	</cfif>

	<cfif isDefined("Form.chkDeducciones")>
		<input type="hidden" name="chkDeducciones" value="1">
	</cfif>

	<input type="hidden" name="enviado" id="enviado" value="true">
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	document.form1.submit();
</script>
</body>
</html>
