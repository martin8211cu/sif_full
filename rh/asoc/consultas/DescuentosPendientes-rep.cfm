<!--- <cf_dump var="#url#"> --->
<!--- TRAE FUNCIONES PARA BUSCAR LOS DATOS DEL PRESTAMO --->
<cfinvoke component="rh.asoc.Componentes.RH_PlanPagos" method="init" returnvariable="this.plan">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_DescuentosPendientesDeAplicar" default="Decuentos Pendientes de Aplicar" returnvariable="LB_DescuentosPendientesDeAplicar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- DATOS DE LA NOMINA A CONSULTAR --->
<cfquery name="rsDatosNomina" datasource="#session.DSN#">
	select CPhasta, CPcodigo, CPdescripcion
	from CalendarioPagos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Tcodigo =  '#TRIM(url.Tcodigo)#'
	  and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
</cfquery>
<!--- TABLA TEMPORAL PARA LOS ASOCIADOS CON CREDITOS --->
    <cf_dbtemp name="salidaAsociadosDP" returnvariable="AsociadosDs">
    	<cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="Cedula"   		type="varchar(60)"  mandatory="no">
        <cf_dbtempcol name="Nombre"			type="varchar(255)"	mandatory="no">
		<cf_dbtempcol name="ACCTid"   		type="numeric"     	mandatory="yes">
		<cf_dbtempcol name="ACCAid"   		type="numeric"     	mandatory="yes">
		<cf_dbtempcol name="TDid"   		type="numeric"     	mandatory="yes">
 		<cf_dbtempcol name="SinAplicar"		type="money"		mandatory="no">
		<cf_dbtempcol name="Siguiente"		type="money"		mandatory="no">
		<cf_dbtempcol name="Saldo"			type="money"		mandatory="no">
        <cf_dbtempkey cols="DEid">
    </cf_dbtemp>

	<cfquery name="rsRecibos" datasource="#session.DSN#">
		insert into #AsociadosDs# (DEid, Cedula, Nombre, ACCTid,TDid, ACCAid)
		select a.DEid, DEidentificacion, 
			{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})},
			d.ACCTid,
			e.TDid,
			d.ACCAid
		from ACAsociados a
		inner join ACCreditosAsociado d
			on d.ACAid = a.ACAid
		inner join ACCreditosTipo e
			on e.ACCTid = d.ACCTid
			<cfif isdefined('url.ACCTid') and url.ACCTid GT 0>
			and e.ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACCTid#">
			</cfif>
		inner join DatosEmpleado b
			on b.DEid = a.DEid
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		inner join LineaTiempo c
			on c.Ecodigo = b.Ecodigo
			and c.DEid = b.DEid
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosNomina.CPhasta#"> between LTdesde and LThasta
			and c.Tcodigo = '#TRIM(url.Tcodigo)#'
	</cfquery>
	<!--- BUSCA LAS DEDUCCIONES DEL EMPLEADO QUE FUERON APLICADAS EN LA NOMINA EN LA  NOMINA --->
	<cfquery name="rsDeducciones" datasource="#session.DSN#">
		update #AsociadosDs#
		set SinAplicar = coalesce((select sum(Dvalor)
					  from HDeduccionesCalculo a, DeduccionesEmpleado b
					  where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
						and a.DCvalor = 0
						and a.DEid = #AsociadosDs#.DEid
						and b.Did = a.Did
						and b.TDid = #AsociadosDs#.TDid
					  ),0.00)
	</cfquery>
	<!--- BUSCA LAS DEDUCCIONES DEL EMPLEADO QUE FUERON APLICADAS EN LA NOMINA EN LA  NOMINA --->
	<cfquery name="rsDeducciones" datasource="#session.DSN#">
		update #AsociadosDs#
		set Saldo = coalesce((select Dsaldo
					  from HDeduccionesCalculo a, DeduccionesEmpleado b
					  where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
						and a.DCvalor = 0
						and a.DEid = #AsociadosDs#.DEid
						and b.Did = a.Did
						and b.TDid = #AsociadosDs#.TDid
					  ),0.00)
	</cfquery>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select DEid,ACCAid
		from #AsociadosDs#
	</cfquery>
	<cfloop query="rsDatos">
		<cfset data_cuotas = this.plan.obtenerCuotasAdelanto( rsDatos.ACCAid,2,2,session.DSN ) >
		<cfquery name="rsCuota" datasource="#session.DSN#">
			update #AsociadosDs#
			set Siguiente = <cfif data_cuotas.REcordCount>#data_cuotas.cuota#<cfelse>0</cfif>
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">
			  and ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ACCAid#">
		</cfquery>
		
	</cfloop>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.*, b.ACCTcodigo, b.ACCTdescripcion
		from #AsociadosDs# a
		inner join ACCreditosTipo b
			on b.ACCTid = a.ACCTid
		<!--- where SinAplicar <> 0 --->
		order by a.ACCTid,Cedula
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
	.titulo_columnar1 {
		font-size:14px;
		font-weight:bold;
		background-color:#999999;
		text-align:left;
		height:20px}
	.titulo_columnar2 {
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
		<table width="700" align="center" border="0" cellspacing="0" cellpadding="2">
			<cfoutput>
			<tr><td align="center" colspan="5" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
			<tr><td align="center" colspan="5" class="titulo_empresa2"><strong>#LB_DescuentosPendientesDeAplicar#</strong></td></tr>
			<tr><td colspan="5" align="center" class="titulo_empresa2"><strong>#rsDatosNomina.CPcodigo# - #rsDatosNomina.CPdescripcion#</strong></td></tr>
			<tr><td colspan="5" align="right"><strong>#LSDateFormat(now(),'dd/mm/yyyy')#</strong></td></tr>
			</cfoutput>
			<tr><td colspan="5">&nbsp;</td></tr>
			<cfsilent>
				<cfset Lvar_TGralSinAplicar = 0>
				<cfset Lvar_TGralSiguiente = 0>
				<cfset Lvar_TGralSaldo = 0>
			</cfsilent>
			<cfoutput query="rsReporte" group="ACCTid">
				<tr><td colspan="5" class="titulo_columnar1"><cf_translate key="LB_Anticipo">Anticipo</cf_translate>:&nbsp;#ACCTcodigo#&nbsp;-&nbsp;#ACCTdescripcion#</td></tr>
				<tr class="titulo_columnar2">
					<td align="left"><cf_translate key="LB_Indentificacion">Identificaci&oacute;n</cf_translate></td>
					<td align="left"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
					<td align="right"><cf_translate key="LB_SinAplicar">Sin Aplicar</cf_translate></td>
					<td align="right"><cf_translate key="LB_Siguiente">Siguiente</cf_translate></td>
					<td align="right"><cf_translate key="LB_Saldo">Saldo</cf_translate></td>
				</tr>
				<cfsilent>
					<cfset Lvar_TSinAplicar = 0>
					<cfset Lvar_TSiguiente = 0>
					<cfset Lvar_TSaldo = 0>
				</cfsilent>
				<cfoutput>
					<tr>
						<td class="detalle">#Cedula#</td>
						<td class="detalle">#Nombre#</td>
						<td class="detaller">#LsCurrencyFormat(SinAplicar,'none')#</td>
						<td class="detaller">#LsCurrencyFormat(Siguiente,'none')#</td>
						<td class="detaller">#LsCurrencyFormat(Saldo,'none')#</td>
					</tr>
					<cfset Lvar_TSinAplicar = Lvar_TSinAplicar + SinAplicar>
					<cfset Lvar_TSiguiente = Lvar_TSiguiente + Siguiente>
					<cfset Lvar_TSaldo = Lvar_TSaldo + Saldo>
					<cfset Lvar_TGralSinAplicar = Lvar_TGralSinAplicar + Lvar_TSinAplicar>
					<cfset Lvar_TGralSiguiente = Lvar_TGralSiguiente + Lvar_TSiguiente>
					<cfset Lvar_TGralSaldo = Lvar_TGralSaldo + Lvar_TSaldo>
				</cfoutput>
				<cfif isdefined('url.chkTotales')>
				<tr><td colspan="2"></td><td colspan="5" height="1" bgcolor="000000"></td></tr>
				<tr class="totales">
					<td colspan="2" align="right"><cf_translate key="LB_Total">Total</cf_translate>&nbsp; #ACCTcodigo#&nbsp;-&nbsp;#ACCTdescripcion#</td>
					<td align="right">#LsCurrencyFormat(Lvar_TSinAplicar,'none')#</td>
					<td align="right">#LsCurrencyFormat(Lvar_TSiguiente,'none')#</td>
					<td align="right">#LsCurrencyFormat(Lvar_TSaldo,'none')#</td>
				</tr>
				</cfif>
				<tr><td colspan="5">&nbsp;</td></tr>
			</cfoutput>
			<cfif isdefined('url.chkTotales')>
			<cfoutput>
				<tr class="totales">
					<td colspan="2" align="right"><cf_translate key="LB_TotalGeneral">Total General</cf_translate></td>
					<td align="right">#LsCurrencyFormat(Lvar_TGralSinAplicar,'none')#</td>
					<td align="right">#LsCurrencyFormat(Lvar_TGralSiguiente,'none')#</td>
					<td align="right">#LsCurrencyFormat(Lvar_TGralSaldo,'none')#</td>
				</tr>
			</cfoutput>
			</cfif>
		</table>
<cfelse>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center"><cf_translate key="MSG_NoHayDatosRelacionados">No hay datos relacionados</cf_translate></td></tr>
	</table>
</cfif>
