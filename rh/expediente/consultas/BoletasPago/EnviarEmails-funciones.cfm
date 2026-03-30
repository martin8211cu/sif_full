<!--- FUNCIONES--->
<cffunction access="private" name="prepararCorreo" output="true" returntype="string">
	<!--- PARÁMETROS--->
	<cfargument name="DEid" required="yes" type="numeric">
	<cfargument name="RCNid" required="yes" type="numeric">
	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
key="LB_Boleta_Pago"
default="Boleta de Pago"
returnvariable="LB_Boleta"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Semanal"
Default="Semanal"	
returnvariable="LB_Semanal"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Bisemanal"
Default="Bisemanal"	
returnvariable="LB_Bisemanal"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Quincenal"
Default="Quincenal"	
returnvariable="LB_Quincenal"/>


	<cfset Titulo = "#LB_Boleta#: " & RCalculoNomina.RCDescripcion>
	
	<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
		select coalesce(Pvalor,'0') as  Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 1040
	</cfquery>	
	
	<cfquery name="HRCalculoNomina" datasource="#Session.DSN#">
		select a.Tcodigo,
		case Ttipopago 
		when 0 then '#LB_Semanal#'
		when 1 then '#LB_Bisemanal#'
		when 2 then '#LB_Quincenal#'
		else ''
		end as   descripcion,RCdesde
		from HRCalculoNomina a
		inner join TiposNomina b
			on a.Tcodigo = b.Tcodigo
			and a.Ecodigo =  b.Ecodigo
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	</cfquery>
	
	
	<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#">
		select {fn concat({fn concat({fn concat({fn concat(DEapellido1 , ' ' )}, DEapellido2 )}, ', ' )}, DEnombre )}  as nombreEmpl, DEemail, DEidentificacion, NTIdescripcion
		from DatosEmpleado de, NTipoIdentificacion ti
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and de.NTIcodigo = ti.NTIcodigo
	</cfquery>
	
	<cfquery name="rsSalBrutoMensual" datasource="#Session.DSN#">
		select coalesce(PEsalario,0) as PEsalario
		from HPagosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.PEtiporeg = 0
		and a.PEdesde = (
			select max(PEdesde)
			from HPagosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			and PEtiporeg = 0
		)
	</cfquery>
	
	<cfquery name="rsSalBrutoRelacion" datasource="#Session.DSN#">
		select coalesce(sum(PEmontores),0) as Monto
		from HPagosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.PEtiporeg = 0
	</cfquery>
	
	<cfquery name="rsRetroactivos" datasource="#Session.DSN#">
		select sum(PEmontores) as Monto
		from HPagosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.PEtiporeg > 0
	</cfquery>
	
	<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
		select SErenta, SEcargasempleado, SEdeducciones
		from HSalarioEmpleado 
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
	</cfquery>
	
	<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
		select  <cf_dbfunction name="to_char" args="ICid"  > as ICid, b.CIdescripcion, a.ICfecha, 
			   (case when CItipo < 2 then a.ICvalor
			   	else null end) as ICvalor, 
			   (case when (CItipo < 2 and a.ICvalor > 0) then round(a.ICmontores/(a.ICvalor*1.00), 2) 
			         when (CItipo = 3 and a.ICvalor > 0) then a.ICvalor
			   else null end) as ICvalorcalculado, 
			   a.ICmontores, a.ICcalculo
		from HIncidenciasCalculo a, CIncidentes b
		where a.CIid = b.CIid
		and CIcarreracp = 0		<!--- considera conceptos de pago por carrera profesional --->		
		and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		order by b.CIcodigo
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
		select  <cf_dbfunction name="to_char" args="ICid"  > as ICid, b.CIdescripcion, a.ICfecha, 
			   (case when CItipo < 2 then a.ICvalor
			   	else null end) as ICvalor, 
			   (case when (CItipo < 2 and a.ICvalor > 0) then round(a.ICmontores/(a.ICvalor*1.00), 2) 
			         when (CItipo = 3 and a.ICvalor > 0) then a.ICvalor
			   else null end) as ICvalorcalculado, 
			   a.ICmontores, a.ICcalculo,CCPid, CCPacumulable, CCPprioridad, TCCPid
		from HIncidenciasCalculo a, CIncidentes b, ConceptosCarreraP c
		where a.CIid = b.CIid
		and c.CIid = b.CIid
		and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and CIcarreracp = 1		<!--- considera conceptos de pago por carrera profesional --->
		order by b.CIcodigo
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
		select #rsSalBrutoRelacion.Monto# + #montoIncidencias# + #montoCarreraP#as Pagos,
			   SErenta + SEcargasempleado + SEdeducciones as Deducciones,
			   (#rsSalBrutoRelacion.Monto# + #montoIncidencias# + #montoCarreraP#) - (SErenta + SEcargasempleado + SEdeducciones) as Liquido
		from rsSalarioEmpleado
	</cfquery>
	
	<cfquery name="rsCargas" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_char" args="a.DClinea"  >  as DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto,  ECresumido , c.ECid
		from HCargasCalculo a, DCargas b, ECargas c
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
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
		select <cf_dbfunction name="to_char" args="a.Did"  >  as Did, a.DCvalor, 
			   a.DCinteres, a.DCcalculo, b.Ddescripcion, 
			   b.Dvalor, b.Dmetodo, case when b.Dcontrolsaldo = 1 then isnull(b.Dsaldo, 0.00) - a.DCvalor else null end as DCsaldo, 
			   b.Dcontrolsaldo, b.Dreferencia
		from HDeduccionesCalculo a, DeduccionesEmpleado b
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
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
			case when a.DLffin is not null then <cf_dbfunction name="date_format" args="a.DLffin,DD/MM/YY">  else '&nbsp;' end as Finalizacion,
			<cf_dbfunction name="to_char" args="a.DLsalario"  >  as DLsalario, 
			<cf_dbfunction name="to_char" args="a.DLsalarioant"  >  as DLsalarioant, 
			<cf_dbfunction name="date_format" args="a.DLfechaaplic,DD/MM/YY">  as FechaAplicacion,
			b.RHTdesc as Descripcion
		from DLaboralesEmpleado a, RHTipoAccion b, HRCalculoNomina c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.RHTid = b.RHTid
		and a.Ecodigo = b.Ecodigo
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
		  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif isdefined('rsSalBrutoMensual') and rsSalBrutoMensual.RecordCount EQ 0>
		<cfset vSalarioBruto = rsSalBrutoMensual.PEsalario >
	<cfelse>
		<cfset vSalarioBruto = 0>
	</cfif>
	<cfif isdefined('rsDias') and rsDias.RecordCount GT 0>
		<cfset vDiasNomina = rsDias.dias >
	<cfelse>
		<cfset vDiasNomina = 0>
	</cfif>


	<cfset vHorasDiarias = 0 >
	<cfquery name="rsHoras" datasource="#session.DSN#" >
		select RHJhoradiaria, RHJornadahora
		from RHJornadas a, LineaTiempo b
		where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.Ecodigo = #Session.Ecodigo#
		and b.Ecodigo = #Session.Ecodigo#
		and a.RHJid = b.RHJid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDias.RChasta#"> between LTdesde and LThasta 
	</cfquery>
	<cfif isdefined('rsHoras') and rsHoras.RecordCount GT 0>
		<cfset vHorasDiarias = rsHoras.RHJhoradiaria >
		<cfset vJornadaporHora = rsHoras.RHJornadahora>
	<cfelse>
		<cfset vHorasDiarias = 0>
		<cfset vJornadaporHora = 0>	
	</cfif>
	<cfif vSalarioBruto GT 0 and vDiasNomina GT 0 and vHorasDiarias GT 0>
		<cfset vSalarioHora = (vSalarioBruto/vDiasNomina)/vHorasDiarias >	
	<cfelse>
		<cfset vSalarioHora = 0>
	</cfif>	
	<!--- ================================================================== --->
	<!--- ================================================================== --->

	<!--- ARMA EL EMAIL--->
	<cfsavecontent variable="info">
	<cfoutput>
	<html>
	<head>
	<title>#LB_Boleta#</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	
	<body>
	<style type="text/css">
		td {font-size: 8pt; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
	</style>
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border: 2px solid black;">
	  <tr>
		<td align="center"><strong>#Session.Enombre#</strong></td>
	  </tr>
	  <tr>
		<td align="center"><strong><cf_translate  key="LB_Boleta_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Boleta de Pago</cf_translate>: #RCalculoNomina.RCDescripcion#</strong></td>
	  </tr>
	  <tr>
		<td align="center"><strong><cf_translate  key="LB_Del" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Del</cf_translate>: #LSDateFormat(RCalculoNomina.RCdesde,'dd/mm/yyyy')# <cf_translate  key="LB_Al" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">al</cf_translate> #LSDateFormat(RCalculoNomina.RChasta,'dd/mm/yyyy')# </strong></td>
	  </tr>
	  <tr>
		<td align="center"><strong><cf_translate  key="LB_Fecha_de_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Fecha de Pago</cf_translate>: #LSDateFormat(RCalculoNomina.CPfpago,'dd/mm/yyyy')#</strong></td>
	  </tr>
	  <tr>
	    <td align="center">&nbsp;</td>
      </tr>
	  <tr>
		<td align="center"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="30%" nowrap><strong><cf_translate  key="LB_Nombre_Completo" xmlfile="/rh/generales.xml">Nombre Completo</cf_translate>: </strong></td>
			<td nowrap>#rsEncabEmpleado.NombreEmpl#</td>
		  </tr>
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_Cedula" xmlfile="/rh/generales.xml">C&eacute;dula</cf_translate>:</strong></td>
			<td nowrap>#rsEncabEmpleado.DEidentificacion#</td>
		  </tr>
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_Salario_Bruto_Mensual" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Bruto Mensual</cf_translate>:</strong></td>
			<td align="right" nowrap><strong>#LSCurrencyFormat(rsSalBrutoMensual.PEsalario, 'none')#</strong></td>
		  </tr>
		  
		  <cfif rsMostrarSalarioNominal.Pvalor eq 1>
			<cfif HRCalculoNomina.Tcodigo neq 3>
				<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
					select LTsalario from LineaTiempo
					where <cfqueryparam cfsqltype="cf_sql_date" value="#HRCalculoNomina.RCdesde#">  between LTdesde and LThasta
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				</cfquery>
				<cfif rsLineaTiempo.recordCount EQ 0>
					<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
						select LTsalario from LineaTiempo
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and LThasta =    (select max(LThasta) from LineaTiempo  where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">)
					</cfquery>
				</cfif>
				<cfinvoke component="rh.Componentes.RH_Funciones" 
					method="salarioTipoNomina"
					salario = "#rsLineaTiempo.LTsalario#"
					Tcodigo = "#HRCalculoNomina.Tcodigo#"
					returnvariable="var_salarioTipoNomina">
					
				
				<tr>
					<td nowrap><strong><cf_translate  key="LB_Salario" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario</cf_translate>&nbsp;#HRCalculoNomina.descripcion#:&nbsp;</strong></td>
					<td align="right" nowrap><strong>#LSCurrencyFormat(var_salarioTipoNomina, 'none')#</strong></td>
				</tr>
			</cfif>
		 </cfif>  		  
		  
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_SalarioBruto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Bruto</cf_translate> #RCalculoNomina.RCDescripcion#:</strong></td>
			<td align="right" nowrap><strong>#LSCurrencyFormat(rsSalBrutoRelacion.Monto, 'none')#</strong></td>
		  </tr>
		  <cfif vJornadaporHora GT 0>
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_Salario_por_Hora" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario por Hora</cf_translate>:</strong></td>
			<td align="right" nowrap><strong>#LSCurrencyFormat(vSalarioHora, 'none')#</strong></td>
		  </tr>
		  </cfif>
		</table></td>
	  </tr>
	  <tr>
	    <td align="center">&nbsp;</td>
      </tr>
	  <tr>
		<td align="center" style="border-top: 2px solid black; "><table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
			<td colspan="5" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate  key="LB_InformacionResumida" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Informaci&oacute;n de Pago Resumida</cf_translate></strong></td>
			</tr>
		  <tr>
		    <td colspan="5" align="center" nowrap>&nbsp;</td>
	      </tr>
		  <tr>
			<td colspan="2" align="center" bgcolor="##CCCCCC" nowrap><strong><cf_translate  key="LB_Conceptos_de_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Conceptos de Pago</cf_translate></strong></td>
			<td width="20" align="center" nowrap>&nbsp;</td>
			<td colspan="2" align="center" bgcolor="##CCCCCC" nowrap><strong><cf_translate  key="LB_Deducciones" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Deducciones</cf_translate></strong></td>
		  </tr>
		  <tr>
			<td nowrap><cf_translate  key="LB_SalarioBruto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Bruto</cf_translate>:</td>
			<td align="right" nowrap>#LSCurrencyFormat(rsSalBrutoRelacion.Monto, 'none')#</td>
			<td align="right" nowrap>&nbsp;</td>
			<td nowrap><cf_translate  key="LB_Cargas" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Cargas Laborales</cf_translate>:</td>
			<td align="right" nowrap><cfif rsSalarioEmpleado.SEcargasempleado GT 0>(</cfif>#LSCurrencyFormat(rsSalarioEmpleado.SEcargasempleado,'none')#<cfif rsSalarioEmpleado.SEcargasempleado GT 0>)</cfif></td>
		  </tr>
		  <tr>
			<td nowrap><cf_translate  key="LB_Otros_Movimientos" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otros Movimientos</cf_translate>:</td>
			<td align="right" nowrap>
				#LSNumberFormat(montoIncidencias+montoCarreraP, '(___,___,___,___,___.__)')#
			</td>
			<td align="right" nowrap>&nbsp;</td>
			<td nowrap><cf_translate  key="LB_Otras_Deducciones" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otras Deducciones</cf_translate>:</td>
			<td align="right" nowrap><cfif rsSalarioEmpleado.SEdeducciones GT 0>(</cfif>#LSCurrencyFormat(rsSalarioEmpleado.SEdeducciones,'none')#<cfif rsSalarioEmpleado.SEdeducciones GT 0>)</cfif></td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap><cf_translate key="LB_Renta" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Renta</cf_translate>:</td>
			<td align="right" nowrap><cfif rsSalarioEmpleado.SErenta GT 0>(</cfif>#LSCurrencyFormat(rsSalarioEmpleado.SErenta,'none')#<cfif rsSalarioEmpleado.SErenta GT 0>)</cfif></td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
			<td align="right" nowrap>#LSNumberFormat(rsTotalesResumido.Pagos, '(___,___,___,___,___.__)')#</td>
			<td align="right" nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td align="right" nowrap><cfif rsTotalesResumido.Deducciones GT 0>(</cfif>#LSCurrencyFormat(rsTotalesResumido.Deducciones, 'none')#<cfif rsTotalesResumido.Deducciones GT 0>)</cfif></td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap><strong><cf_translate  key="LB_SalarioLIquido" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario L&iacute;quido</cf_translate>:</strong></td>
			<td align="right" nowrap>
				<strong>#rsMoneda.Msimbolo# #LSNumberFormat(rsTotalesResumido.Liquido, '(___,___,___,___,___.__)')#</strong>
			</td>
		  </tr>
		</table></td>
	  </tr>
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>
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
				<td colspan="6" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate  key="LB_Otros_Movimientos" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otros Movimientos</cf_translate></strong></td>
			  </tr>
			  <cfif (rsIncidenciasCalculo.recordCount+rsIncidenciasCarreraP.recordCount) GT 0>
				  <tr>
					<td width="10%" align="center" nowrap><strong><cf_translate  key="LB_Fecha" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Fecha</cf_translate></strong></td>
					<td width="#tamColDescr#%" align="left" nowrap colspan="2"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
					<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
						<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_Unidades" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Unidades</cf_translate></strong></td>
						<td width="15%" align="right" nowrap><strong><cf_translate  key="LB_Valor" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Valor</cf_translate></strong></td>
					</cfif>
					<td width="15%" align="right" nowrap><strong><cf_translate  key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
				  </tr>
				  <cfloop query="rsIncidenciasCalculo">
					  <tr>
						<td align="center" style="border-top: 1px solid gray; " nowrap>#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
						<td align="left" style="border-top: 1px solid gray; " colspan="2" nowrap>#CIdescripcion#</td>
						<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
							<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalor))>#LSNumberFormat(ICvalor,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
							<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalorcalculado))>#LSNumberFormat(ICvalorcalculado,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
						</cfif>						
						<td align="right" style="border-top: 1px solid gray; " nowrap>#LSNumberFormat(ICmontores,'(___,___,___,___,___.__)')#</td>
					  </tr>
				  </cfloop>
				  <cfif rsIncidenciasCarreraP.recordCount GT 0 >
					  <tr><td colspan="5" bgcolor="##CCCCCC" ><strong><cf_translate key="LB_Carerra_Profesional" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Carrera Profesional</cf_translate></strong></td></tr>
					  <tr>
						<td width="10%" align="center" nowrap><strong><cf_translate  key="LB_Fecha" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Fecha</cf_translate></strong></td>
						<td width="#tamColDescr#%" align="left" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
						<td align="left" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Puntos">Puntos</cf_translate></strong></td>
						<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
							<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_Unidades" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Unidades</cf_translate></strong></td>
							<td width="15%" align="right" nowrap><strong><cf_translate  key="LB_Valor" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Valor</cf_translate></strong></td>
						</cfif>
						<td width="15%" align="right" nowrap><strong><cf_translate  key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
					  </tr>
					  <cfloop query="rsIncidenciasCarreraP">
						<cfinvoke component="rh.Componentes.RH_CalculoCP" method="AcumulaConceptos" returnvariable="Conceptos" conexion="#session.DSN#"
							ecodigo = "#session.Ecodigo#" ccpid = "#rsIncidenciasCarreraP.CCPid#" acumula = "#rsIncidenciasCarreraP.CCPacumulable#" tccpid="#rsIncidenciasCarreraP.TCCPid#"
							prioridad="#rsIncidenciasCarreraP.CCPprioridad#" rcdesde="#RCalculoNomina.RCdesde#" rchasta="#RCalculoNomina.RChasta#" deid = "#Arguments.DEid#"/>
					  <tr>
						<td align="center" style="border-top: 1px solid gray; " nowrap>#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
						<td align="left" style="border-top: 1px solid gray; " nowrap>#CIdescripcion#</td>
						<td align="right" style="border-top: 1px solid gray; " nowrap>#Conceptos.valor#</td>
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
					<td align="left" style="border-top: 1px solid gray; " colspan="2" nowrap><cf_translate  key="LB_AJUSTE_RETROACTIVO" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">AJUSTE RETROACTIVO</cf_translate></td>
					<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
						<td align="right" style="border-top: 1px solid gray; " nowrap>&nbsp;</td>
						<td align="right" style="border-top: 1px solid gray; " nowrap>&nbsp;</td>
					</cfif>							
					<td align="right" style="border-top: 1px solid gray; " nowrap>#LSNumberFormat(rsRetroactivos.Monto,'(___,___,___,___,___.__)')#</td>
				  </tr>
				  </cfif>
				  <tr>
					<td align="left" style="border-top: 2px solid black; " nowrap><strong><cf_translate  key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
					<td align="left" style="border-top: 2px solid black; " colspan="2" nowrap>&nbsp;</td>
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
					<td colspan="#tamColDescr#" align="center"><strong>--- <cf_translate  key="LB_NoSeEncontraronRegistros" xmlfile="/rh/generales.xml">No se encontraron otros movimientos registrados</cf_translate> ---</strong></td>
				  </tr>
			  </cfif>
			</table>
		
		</td>
	  </tr>
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>
  
	  <tr>
		<td align="center" style="border-top: 2px solid black; "><table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
			<td colspan="2" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate  key="LB_Cargas" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Cargas Laborales</cf_translate></strong></td>
		  </tr>
		    <cfset idBandera= "" >
		  <cfif rsCargas.recordCount GT 0>
			  <tr>
				<td nowrap><strong><cf_translate  key="LB_DESCRIPCION" xmlfile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
				<td align="right" nowrap><strong><cf_translate  key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
			  </tr>
			  <cfloop query="rsCargas">			  
			  <cfif rsCargas.ECresumido is  1 >										            
					   <cfif idBandera neq #rsCargas.ECid#>  					     				  		 			  
			  				<cfquery name = "rsCargasCalculoResumido" datasource="#Session.DSN#">
						   		 select e.ECdescripcion as descripcion, sum(cc.CCvaloremp) as empleado
								 from HCargasCalculo cc, ECargas e, DCargas d
								 where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
				  				 and cc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
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
				<td style="border-top: 2px solid black; " nowrap><strong><cf_translate  key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
				<td align="right" style="border-top: 2px solid black; " nowrap>
					<strong>#rsMoneda.Msimbolo# <cfif SumCargas NEQ 0>(</cfif>#LSCurrencyFormat(SumCargas,'none')#<cfif SumCargas NEQ 0>)</cfif></strong>
				</td>
			  </tr>
		  <cfelse>
			  <tr align="center">
				<td colspan="2"><strong>--- <cf_translate  key="LB_NoSeEncontraronRegistros">No se encontraton cargas laborales registradas</cf_translate> ---</strong></td>
			  </tr>
		  </cfif>
		</table></td>
	  </tr>
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center" style="border-top: 2px solid black; "><table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
			<td colspan="4" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate  key="LB_Otras_Deducciones" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otras Deducciones</cf_translate></strong></td>
		  </tr>
		  <cfif rsDeducciones.recordCount GT 0>
			  <tr>
				<td width="60%" nowrap><strong><cf_translate  key="LB_DESCRIPCION" xmlfile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
				<td width="20%" nowrap><strong><cf_translate  key="LB_Referencia" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Referencia</cf_translate></strong></td>
				<td align="right" nowrap><strong><cf_translate  key="LB_SaldoPosterior" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Saldo Posterior</cf_translate></strong></td>
				<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
			  </tr>
			  <cfloop query="rsDeducciones">
			  <tr>
				<td style="border-top: 1px solid gray; " nowrap>#Ddescripcion#&nbsp;</td>
				<td style="border-top: 1px solid gray; " nowrap>#Dreferencia#&nbsp;</td>
				<td width="10%" align="right" style="border-top: 1px solid gray; " nowrap><cfif Dcontrolsaldo EQ 1>#LSCurrencyFormat(DCsaldo,'none')#<cfelse>&nbsp;</cfif></td>
				<td align="right" style="border-top: 1px solid gray; " nowrap><cfif DCvalor NEQ 0>(</cfif>#LSCurrencyFormat(DCvalor,'none')#<cfif DCvalor NEQ 0>)</cfif></td>
			  </tr>
			  </cfloop>
			  <tr>
				<td style="border-top: 2px solid black; " nowrap><strong><cf_translate  key="LB_Total">Total</cf_translate>:</strong></td>
				<td style="border-top: 2px solid black; " nowrap>&nbsp;</td>
				<td style="border-top: 2px solid black; " align="right" nowrap>&nbsp;</td>
				<td style="border-top: 2px solid black; " align="right" nowrap>
					<strong>#rsMoneda.Msimbolo# <cfif SumDeducciones NEQ 0>(</cfif>#LSCurrencyFormat(SumDeducciones,'none')#<cfif SumDeducciones NEQ 0>)</cfif></strong>
				</td>
			  </tr>
		  <cfelse>
		  <tr align="center">
			<td colspan="4"><strong>--- <cf_translate  key="LB_NoSeEncontraronRegistros" xmlfile="/rh/generales.xml">No se encontraron deducciones registradas</cf_translate> ---</strong></td>
		  </tr>
		  </cfif>
		</table></td>
	  </tr>
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center" style="border-top: 2px solid black; "><table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
			<td colspan="5" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate key="LB_Detalle_de_Movimientos" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Detalle de Movimientos</cf_translate></strong></td>
		  </tr>
		  <cfif rsDetalleMovimientos.recordCount GT 0>
			  <tr>
				<td width="10%" align="center" nowrap><strong><cf_translate  key="LB_Del" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Rige</cf_translate></strong></td>
				<td width="10%" align="center" nowrap><strong><cf_translate  key="LB_Al" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Vence</cf_translate></strong></td>
				<td width="60%" nowrap><strong><cf_translate  key="LB_DESCRIPCION" xmlfile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
				<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_SalarioAnterior" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Anterior</cf_translate></strong></td>
				<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_SalarioPosterior" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Posterior</cf_translate></strong></td>
			  </tr>
			  <cfloop query="rsDetalleMovimientos">
			  <tr>
				<td align="center" style="border-top: 1px solid gray; " nowrap>#Vigencia#&nbsp;</td>
				<td align="center" style="border-top: 1px solid gray; " nowrap>#Finalizacion#&nbsp;</td>
				<td style="border-top: 1px solid gray; " nowrap>#Descripcion#&nbsp;</td>
				<td align="right" style="border-top: 1px solid gray; " nowrap>#DLsalarioant#&nbsp;</td>
				<td align="right" style="border-top: 1px solid gray; " nowrap>#DLsalario#&nbsp;</td>
			  </tr>
			  </cfloop>
		  <cfelse>
		  <tr align="center">
			<td colspan="5"><strong>--- <cf_translate  key="LB_NoSeEncontraronRegistros" xmlfile="/rh/generales.xml">No se encontraron movimientos registrados</cf_translate> ---</strong></td>
		  </tr>
		  </cfif>
		</table></td>
	  </tr>
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center" style="border-top: 2px solid black; "><strong><cf_translate  key="MSG_Fin_de_Boleta_de_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Fin de Boleta de Pago</cf_translate>: #RCalculoNomina.RCDescripcion#</strong></td>
	  </tr>
	  <tr>
		<td align="center"><cf_translate  key="MSG_Mensaje_generado" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Este mensaje es generado autom&aacute;ticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje</cf_translate>. </td>
	  </tr>
	</table>
	</body>
	</html>
	</cfoutput>	
	</cfsavecontent>
	<cfreturn info>
</cffunction>

<cffunction access="private" name="enviarCorreo" output="true" returntype="boolean">
	<cfargument name="from" required="yes" type="string">
	<cfargument name="to" required="yes" type="string">
	<cfargument name="subject" required="yes" type="string">
	<cfargument name="message" required="yes" type="string">
	
	<!--- ENVÍA EL EMAIL --->
	
	<cfset errores = 0>
	
	<cftry>
		<cfquery datasource="asp">
			insert SMTPQueue 
				(SMTPremitente, SMTPdestinatario, SMTPasunto,
				SMTPtexto, SMTPhtml)
			 values(
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.from)#">,
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.to)#">,
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
			 	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.message#">,
				1)
		</cfquery>
		<!---
		<cfmail from="#Arguments.from#" to="#Arguments.to#" subject="#subject#" type="html">
			#Arguments.message#
		</cfmail>--->
		<cfcatch type="any">
			<cfset errores = errores + 1>
			<cfoutput>Error: Tipo: #cfcatch.type#, <br>Mensaje: #cfcatch.Message#, <br>Detalle: #cfcatch.Detail#</cfoutput>
			<cfabort>
		</cfcatch>
	</cftry>
	
	<cfreturn errores eq 0>
</cffunction>

<cffunction access="private" name="getRHPvalor" output="false" returntype="string">
	<cfargument name="Pcodigo" required="yes" type="string">
	<cfquery name="rs" datasource="#session.dsn#">
		select Pvalor
		from RHParametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = #Arguments.Pcodigo#
	</cfquery>
	<cfreturn rs.Pvalor>
</cffunction>

<cffunction access="private" name="getEmailFromAdmin" output="false" returntype="string">
	<cfargument name="UsucodigoAdmin" required="yes" type="numeric">
	<cfquery name="rs" datasource="asp">
		select b.Pemail1 as Email
		from Usuario a, DatosPersonales b
		where a.Usucodigo = #Arguments.UsucodigoAdmin#
		and a.datos_personales = b.datos_personales
	</cfquery>
	<cfreturn rs.Email>
</cffunction>

<cffunction access="private" name="getEmailFromJefe" output="false" returntype="string">
	<cfargument name="DEid" required="yes" type="numeric">
	
		<cfset mail = ''>
	<cfquery name="rsRHPid" datasource="#session.dsn#">
		select RHPid
		from LineaTiempo 
		where DEid = #Arguments.DEid#
			and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
	</cfquery>
	
	<cfif rsRHPid.RecordCount NEQ 0 and len(trim(rsRHPid.RHPid))>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid
			from RHPlazas 
			where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHPid.RHPid#">
		</cfquery>
		<cfif rsCFid.RecordCount NEQ 0 and len(trim(rsCFid.CFid))>		
			<cfquery name="rsRHPid2" datasource="#session.dsn#">
				select RHPid 
				from CFuncional 
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFid.CFid#">
			</cfquery>
	
			<cfif rsRHPid2.RecordCount NEQ 0 and len(trim(rsRHPid2.RHPid))>		
				<cfquery name="rsDEid" datasource="#session.dsn#">
					select min(DEid) as DEid
					from LineaTiempo 
					where Ecodigo = #session.Ecodigo#
						and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHPid2.RHPid#">
						and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
				</cfquery>
				<cfif rsDEid.RecordCount NEQ 0 and len(trim(rsDEid.DEid))>
					<cfquery name="rs" datasource="#session.dsn#">
						select DEemail as Email
						from DatosEmpleado 
						where DEid = #rsDEid.DEid#
					</cfquery>
				</cfif>
				<cfif isdefined("rs") and rs.RecordCount NEQ 0 and len(trim(rs.Email))>
					<cfset mail = '#rs.Email#'>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	<cfreturn mail>
	<!----
	<cfquery name="rs" datasource="#session.dsn#">
		declare @RHPid numeric,
			@CFid numeric,
			@DEid numeric
		
		select @RHPid = RHPid
		from LineaTiempo 
		where DEid = #Arguments.DEid#
		 and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
		 
		select @CFid = CFid
		from RHPlazas 
		where RHPid = @RHPid
		 
		select @RHPid = RHPid 
		from CFuncional 
		where CFid = @CFid
		 
		select @DEid = min(DEid)
		from LineaTiempo 
		where Ecodigo = #session.Ecodigo#
		and RHPid = @RHPid
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
		
		select DEemail as Email
		from DatosEmpleado 
		where DEid = @DEid
	</cfquery>
	<cfreturn rs.Email>
	----->
</cffunction>