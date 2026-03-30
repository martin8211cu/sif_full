<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ReciboMensualDeAporteAsociacion" default="Recibo Mensual de Aporte Asociación" returnvariable="LB_ReciboMensualDeAporteAsociacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<!--- BUSCA LOS CREDITOS QUE SEAN ELECTROD0MESTICO O SILVACANO PARA NO TOMARLOS EN CUENTA EN DATO DEL ABONO. --->
<cfset Lvar_Excepciones = ''>
<cfif rsEmpresa.RecordCount>
	<cfquery name="rsSilva" datasource="#session.DSN#">
		select * from ACParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and Pcodigo = 130
	</cfquery>
	<cfif isdefined('rsSilva') and rsSilva.RecordCount>
		<cfset Lvar_CSilva = rsSilva.Pvalor>
		<cfset Lvar_Excepciones = ListAppend(Lvar_Excepciones,Lvar_CSilva)>
	<cfelse>
		<cfthrow message="No se ha definido el parámetro para Crédito SilvaCano, para el reporte Resumen Mensual.">
	</cfif>
	<cfquery name="rsElect" datasource="#session.DSN#">
		select Pvalor from ACParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and Pcodigo = 140
	</cfquery>
	<cfif isdefined('rsElect') and rsElect.RecordCount>
		<cfset Lvar_CElect = rsElect.Pvalor>
		<cfset Lvar_Excepciones = ListAppend(Lvar_Excepciones,Lvar_CElect)>
	<cfelse>
		<cfthrow message="No se ha definido el parámetro para Crédito Electrodom&eacute;stico, para el reporte Resumen Mensual.">
	</cfif>
</cfif>
<!--- SI SE INDICA QUE SE TOME EN CUENTA LAS DEPENDENCIAS ENTOCES SE BUSCA TODAS LAS DEPENDENCIAS DEL CENTRO FUNCIONAL --->
<cfif isdefined('url.dependencias')>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
		cfid = "#url.CFid#"
		nivel = 5
		returnvariable="Dependencias"/>
	<cfset CentrosLista = ValueList(Dependencias.CFid)>
<cfelseif isdefined('url.CFid')>
	<cfset CentrosLista = url.CFid>
<cfelse>
	<cfset CentrosLista = ''>
</cfif> 
<!--- SE BUSCAN LOS APORTES QUE SE REGISTRAN COMO CARGAS EN LA NOMINA. --->
<cfquery name="rsCargas" datasource="#session.DSN#">
	select distinct DClinea
	from ACAportesTipo
	where DClinea is not null
</cfquery>
<cfset Lvar_ListaCargas = ValueList(rsCargas.DClinea)>
<!--- SE BUSCAN  LOS APORTES QUE SE REGISTRAN COMO DEDUCCIONES EN LA NOMINA --->
<cfquery name="rsDeducciones" datasource="#session.DSN#">
	select distinct TDid
	from ACAportesTipo
	where TDid is not null
</cfquery>
<cfset Lvar_ListaDeducciones = ValueList(rsDeducciones.TDid)>
<!--- SE BUSCAN LOS CREDITOS QUE SE REGISTRAN COMO DEDUCCIONES EN LA NOMINA  --->
<cfquery name="rsCreditos" datasource="#session.DSN#">
	select distinct TDid
	from ACCreditosTipo
	<cfif LEN(TRIM(Lvar_Excepciones))>
	where ACCTid not in (#Lvar_Excepciones#)
	</cfif>
</cfquery>
<cfset Lvar_ListaDCreditos = ValueList(rsCreditos.TDid)>

<!--- DATOS DEL CALENDARIO DE PAGOS --->
<cfquery name="rsCalendario" datasource="#session.DSN#">
	select CPperiodo, CPmes
	from CalendarioPagos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">
	  and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
</cfquery>
<cfset Lvar_Periodo = rsCalendario.CPperiodo>
<cfset Lvar_Mes = rsCalendario.CPmes>
<!--- TABLA TEMPORAL PARA LOS ASOCIADOS CON CREDITOS --->
    <cf_dbtemp name="salidaRecibo" returnvariable="Recibos">
    	<cf_dbtempcol name="ACAid"   		type="numeric"     	mandatory="yes">
		<cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
		<cf_dbtempcol name="CFid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="Carga"   		type="money"     	mandatory="no">
        <cf_dbtempcol name="Ahorro"			type="money"		mandatory="no">
 		<cf_dbtempcol name="Abono"			type="money"		mandatory="no">
		<cf_dbtempcol name="suma"			type="money"		mandatory="no">
		<cf_dbtempcol name="TotalCarga"		type="money"		mandatory="no">
		<cf_dbtempcol name="TotalAhorro"	type="money"		mandatory="no">
		<cf_dbtempcol name="SaldoPrestamo"	type="money"		mandatory="no">
        <cf_dbtempkey cols="ACAid,DEid">
    </cf_dbtemp>

	<cfquery name="rsRecibos" datasource="#session.DSN#">
		insert into #Recibos# (ACAid,DEid,CFid)
		select a.ACAid,a.DEid,d.CFid
		from ACAsociados a
		inner join DatosEmpleado b
			on b.DEid = a.DEid
		inner join LineaTiempo c
			on c.Ecodigo = b.Ecodigo
			and c.DEid = b.DEid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta
			and c.Tcodigo = '#TRIM(url.Tcodigo)#'
		inner join RHPlazas d
			on d.Ecodigo = c.Ecodigo
			and d.RHPid = c.RHPid
			<cfif isdefined('CentrosLista') and LEN(TRIM(CentrosLista)) and not isdefined('url.DEid')>
			and d.CFid in (#CentroLista#)
			</cfif>
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined('url.DEid')>
		  and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
		<cfif isdefined('url.Estado') and url.Estado NEQ -1>
		  and a.ACAestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Estado#">
		</cfif>
	</cfquery>
	<!--- BUSCA LOS APORTES OBLIGATORIOS DE LOS ASOCIADOS EN LA NOMINA --->
	<cfif LEN(TRIM(Lvar_ListaCargas))>
		<cfquery name="rsCargas" datasource="#session.DSN#">
			update #Recibos#
			set Carga = coalesce((select sum(CCvaloremp)
						from HCargasCalculo
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
						  and DClinea in (#Lvar_ListaCargas#)
						  and DEid = #Recibos#.DEid
							),0.00)
			
		</cfquery>
	</cfif>
	<!--- BUSCA LOS APORTES VOLUNTARIO DE LOS ASOCIADOS EN LA  NOMINA --->
	<cfif LEN(TRIM(Lvar_ListaDeducciones))>
		<cfquery name="rsDeducciones" datasource="#session.DSN#">
			update #Recibos#
			set Ahorro = coalesce((select sum(DCvalor)
						  from HDeduccionesCalculo a
						  inner join DeduccionesEmpleado b
							  on b.Did = a.Did
							  and b.TDid in(#Lvar_ListaDeducciones#)
						  where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
							and a.DEid = #Recibos#.DEid
						  ),0.00)
		</cfquery>
	</cfif>
	<!--- BUSCA LOS APORTES VOLUNTARIO DE LOS ASOCIADOS EN LA  NOMINA --->
	<cfif LEN(TRIM(Lvar_ListaDCreditos))>
		<cfquery name="rsDeducciones" datasource="#session.DSN#">
			update #Recibos#
			set Abono = coalesce((select sum(DCvalor)
						  from HDeduccionesCalculo a
						  inner join DeduccionesEmpleado b
							  on b.Did = a.Did
							  and b.TDid in(#Lvar_ListaDCreditos#)
						  where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
							and a.DEid = #Recibos#.DEid
						  ),0.00)
		</cfquery>
	</cfif>
	<!--- HACE LA SUMA DE EL APORTE EN LA PLANILLA --->
	<cfquery name="rsSuma" datasource="#session.DSN#">
		update #Recibos#
		set suma = coalesce((select Carga+Ahorro+Abono
					from #Recibos# a
					where a.DEid = #Recibos#.DEid),0.00)
	</cfquery>
	<!--- VERIFICA SALDOS DE CREDITOS --->
	<cfquery name="rsSaldo" datasource="#session.DSN#">
		update #Recibos#
		set SaldoPrestamo = (select sum(ACPPpagoPrincipal)
							from ACAsociados a
							inner join ACCreditosAsociado b
								  on b.ACAid = a.ACAid
							inner join ACPlanPagos c
								  on c.ACCAid = b.ACCAid
								  and ACPPestado = 'N'
							where a.DEid = #Recibos#.DEid
							<cfif 	LEN(TRIM(Lvar_Excepciones))>
							and ACCTid not in (#Lvar_Excepciones#)
							</cfif>
							and b.ACCestado = 0
							)
	</cfquery>
	<cfquery name="rsTotalCarga" datasource="#session.DSN#">
		update #Recibos#
		set TotalCarga = (select sum(d.ACAAsaldoInicial + d.ACAAaporteMes)
							  from ACAsociados a, ACAportesAsociado b, ACAportesSaldos d, ACAportesTipo c
							  where a.DEid = #Recibos#.DEid
							    and b.ACAid = a.ACAid
								and d.ACAAid = b.ACAAid
								and c.ACATid = b.ACATid 
								and c.TDid is null
								and c.DClinea is not null
								and b.DClinea = c.DClinea
								and ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">
								and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">
								and ACATorigen = 'O'
								and b.ACAestado = 0)
	</cfquery>
	<cfquery name="rsTotalCarga" datasource="#session.DSN#">
		update #Recibos#
		set TotalAhorro = (	select sum(d.ACAAsaldoInicial + d.ACAAaporteMes)
							  from ACAsociados a, ACAportesAsociado b, ACAportesSaldos d, ACAportesTipo c
							  where a.DEid = #Recibos#.DEid
							    and b.ACAid = a.ACAid
								and d.ACAAid = b.ACAAid
								and c.ACATid = b.ACATid 
								and c.TDid is not null
								and c.DClinea is null
								and ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">
								and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">
								and b.ACAestado = 0)
	</cfquery>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.*, 
			DEidentificacion,
			{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre
		from #Recibos# a
		inner join DatosEmpleado b
			on b.DEid = a.DEid
		order by DEidentificacion
	</cfquery>

<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;
		height:20px}
	.detalle {
		font-size:14px;
		text-align:left;}
	.detaller {
		font-size:14px;
		text-align:right;}
	.detallec {
		font-size:14px;
		text-align:center;}
	.totales {
		font-size:14px;
		text-align:right;
		font-weight:bold;}	
	DIV.pageBreak { page-break-before: always; }

</style>

<cfif rsReporte.RecordCount>
	<cfset Lvar_corte = 0>
	<cfoutput query="rsReporte">
		<cfset Lvar_corte = Lvar_corte +1>
		<table width="700" align="center" border="0" cellspacing="0" cellpadding="2">
		<tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
		<tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#LB_ReciboMensualDeAporteAsociacion#</strong></td></tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr><td align="right" colspan="4" class="detaller"><strong><cf_translate key="LB_Por">Por</cf_translate>#LSCurrencyFormat(suma,'none')#</strong></td></tr>
		<tr><td colspan="4" class="detalle"><cf_translate key="LB_RecibiDe">RECIBI DE:</cf_translate>#DEidentificacion#&nbsp;-&nbsp;#nombre#</td></tr>
		<cfinvoke component="rh.Componentes.sp_MontoLetras" method="MontoLetras" returnvariable="Vmontoletras">
			<cfinvokeargument name="conexion" value="#session.DSN#">		
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
			<cfinvokeargument name="debug" value="false">
			<cfinvokeargument name="Monto" value="#suma#">
			<cfinvokeargument name="Centimos" value="no">
		</cfinvoke>
		<tr><td colspan="4" class="detalle"><cf_translate key="LB_LaSumaDe">LA SUMA DE:</cf_translate>#Vmontoletras#</td></tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr class="titulo_columnar">
			<td align="center">&nbsp;</td>
			<td align="right">5%&nbsp;<cf_translate key="LB_Salario">SALARIO</cf_translate></td>
			<td align="right"><cf_translate key="LB_AhorroExtr">AHORRO EXTRA</cf_translate></td>
			<td align="right"><cf_translate key="LB_AbonoPrestamo">ABONO PRESTAMO</cf_translate></td>
		</tr>
		<tr>
			<td align="left" class="detalle"><cf_translate key="LB_EstaAportacion">ESTA APORTACION</cf_translate></td>
			<td align="right" class="detaller">#LSCurrencyFormat(carga,'none')#</td>
			<td align="right" class="detaller">#LSCurrencyFormat(ahorro,'none')#</td>
			<td align="right" class="detaller">#LSCurrencyFormat(abono,'none')#</td>
		</tr>
		<tr>
			<td align="left" class="detalle"><cf_translate key="LB_AportacionAcumulada">APORTACION ACUM</cf_translate></td>
			<td align="right" class="detaller">#LSCurrencyFormat(TotalCarga,'none')#</td>
			<td align="right" class="detaller">#LSCurrencyFormat(TotalAhorro,'none')#</td>
			<td align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="left" class="detalle"><cf_translate key="LB_SaldoPrestamo">SALDO PRESTAMO</cf_translate></td>
			<td align="center">&nbsp;</td>
			<td align="center">&nbsp;</td>
			<td align="right" class="detaller">#LSCurrencyFormat(SaldoPrestamo,'none')#</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr><td colspan="4">#LSDateFormat(now(),'dd/mm/yyyy')#</td></tr>
		<tr>
			<td colspan="3"></td>
			<td height="1" bgcolor="000000"></td>
		</tr>
		<tr>
			<td align="right" colspan="3">&nbsp;</td>
			<td align="center"><cf_translate key="LB_Tesorero">Tesorero</cf_translate></td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<cfif Lvar_corte EQ 3>
		<tr><td width="1%" colspan="3"><div class="pageBreak"/></tr>
			<cfset Lvar_corte = 0>
		</cfif>
	</table>
	</cfoutput>
<cfelse>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center"><cf_translate key="MSG_NoHayDatosRelacionados">No hay datos relacionados</cf_translate></td></tr>
	</table>
</cfif>
