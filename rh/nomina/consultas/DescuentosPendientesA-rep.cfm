<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_DescuentosPendientesDeAplicar" default="Decuentos Pendientes de Aplicar" returnvariable="LB_DescuentosPendientesDeAplicar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nomina" default="N&oacute;mina" returnvariable="LB_Nomina" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined('url.TipoNomina')>
	<cfset tablaCalculoNomina = 'HRCalculoNomina'>
	<cfset tablaDeduccionesCalculo = 'HDeduccionesCalculo'>
	<cfset tablaSalarioEmpleado = 'HSalarioEmpleado'>
	<cfset tablaPagosEmpleado = 'HPagosEmpleado'> 
	<cfset tablaIncidenciasCalculo = 'HIncidenciasCalculo'> 
	<cfset tablaCargasCalculo = 'HCargasCalculo'>
<cfelse>
	<cfset tablaCalculoNomina = 'RCalculoNomina'>
	<cfset tablaDeduccionesCalculo = 'DeduccionesCalculo'>
	<cfset tablaSalarioEmpleado = 'SalarioEmpleado'>
	<cfset tablaPagosEmpleado = 'PagosEmpleado'>
	<cfset tablaIncidenciasCalculo = 'IncidenciasCalculo'> 
	<cfset tablaCargasCalculo = 'CargasCalculo'>
</cfif>

<!--- DATOS DE LA NOMINA A CONSULTAR --->
<cfquery name="rsDatosNomina" datasource="#session.DSN#">
	select CPhasta, CPcodigo, coalesce(CPdescripcion,RCDescripcion) as Descripcion
	from CalendarioPagos a
	inner join #tablaCalculoNomina# b
		on b.RCNid = a.CPid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.Tcodigo =  '#TRIM(url.Tcodigo)#'
	  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
</cfquery>
<!--- TABLA TEMPORAL PARA LOS ASOCIADOS CON CREDITOS --->
    <cf_dbtemp name="salidaDeducPA" returnvariable="DeducPA">
    	<cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
		<cf_dbtempcol name="Did"   			type="numeric"     	mandatory="yes">
		<cf_dbtempcol name="TDid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="Cedula"   		type="varchar(60)"  mandatory="no">
        <cf_dbtempcol name="Nombre"			type="varchar(255)"	mandatory="no">
 		<cf_dbtempcol name="SinAplicar"		type="money"		mandatory="no">
		<cf_dbtempcol name="Siguiente"		type="money"		mandatory="no">
		<cf_dbtempcol name="Saldo"			type="money"		mandatory="no">
        <cf_dbtempkey cols="DEid,Did">
    </cf_dbtemp>
    
    
	<cfquery name="rsinAplicar" datasource="#session.DSN#">
		insert into #DeducPA# (DEid,Cedula, Nombre, TDid, Siguiente, Saldo, SinAplicar, Did)
		select a.DEid, DEidentificacion,{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})},
				TDid,coalesce(Dvalor,Dmonto), c.Dsaldo, DCvalor,c.Did
		from #tablaSalarioEmpleado# a
		inner join #tablaDeduccionesCalculo# b
			on  b.RCNid = a.RCNid
			and b.DEid = a.DEid
		inner join DeduccionesEmpleado c
			on c.Did = b.Did
			and c.DEid = b.DEid
		inner join DatosEmpleado d
			on c.DEid = d.DEid
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
		  and c.Dsaldo > 0
		  and c.Dfechafin >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
		  <cfif isdefined('url.DEid') and LEN(TRIM(url.DEid))>
		  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#"> 
		  </cfif>
		  <cfif isdefined('url.TDid') and LEN(TRIM(url.TDid))>
		  and c.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDid#"> 
		  </cfif>
		  
	</cfquery>
	
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.*, b.TDcodigo, b.TDdescripcion
		from #DeducPA# a
		inner join TDeduccion b
			on b.TDid = a.TDid
		order by a.TDid,Cedula
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
			<tr>
				<td colspan="5">
					<cf_EncReporte Titulo="#LB_DescuentosPendientesDeAplicar#" Color="##E3EDEF" filtro1="#LB_Nomina#: #rsDatosNomina.CPcodigo# - #rsDatosNomina.Descripcion#" Columnas="5">
				</td>
			</tr>
			<!----
			<tr><td align="center" colspan="5" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
			<tr><td align="center" colspan="5" class="titulo_empresa2"><strong>#LB_DescuentosPendientesDeAplicar#</strong></td></tr>
			<tr><td colspan="5" align="center" class="titulo_empresa2"><strong>#rsDatosNomina.CPcodigo# - #rsDatosNomina.Descripcion#</strong></td></tr>
			<tr><td colspan="5" align="right"><strong>#LSDateFormat(now(),'dd/mm/yyyy')#</strong></td></tr>
			<tr><td colspan="5">&nbsp;</td></tr>
			------>
			</cfoutput>			
			<cfsilent>
				<cfset Lvar_TGralSinAplicar = 0>
				<cfset Lvar_TGralSiguiente = 0>
				<cfset Lvar_TGralSaldo = 0>
			</cfsilent>
			<cfoutput query="rsReporte" group="TDid">
				<tr><td colspan="5" class="titulo_columnar1"><cf_translate key="LB_Anticipo">Anticipo</cf_translate>:&nbsp;#TDcodigo#&nbsp;-&nbsp;#TDdescripcion#</td></tr>
				<tr>
					<td align="left" class="titulo_columnar2"><cf_translate key="LB_Indentificacion">Identificaci&oacute;n</cf_translate></td>
					<td align="left" class="titulo_columnar2"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
					<td align="right" class="titulo_columnar2"><cf_translate key="LB_Aplicada">Aplicada</cf_translate></td>
					<td align="right" class="titulo_columnar2"><cf_translate key="LB_Siguiente">Siguiente</cf_translate></td>
					<td align="right" class="titulo_columnar2"><cf_translate key="LB_Saldo">Saldo</cf_translate></td>
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
				</cfoutput>
					<cfset Lvar_TGralSinAplicar = Lvar_TGralSinAplicar + Lvar_TSinAplicar>
					<cfset Lvar_TGralSiguiente = Lvar_TGralSiguiente + Lvar_TSiguiente>
					<cfset Lvar_TGralSaldo = Lvar_TGralSaldo + Lvar_TSaldo>
				<cfif isdefined('url.chkTotales')>
				<tr><td colspan="2"></td><td colspan="5" height="1" bgcolor="000000"></td></tr>
				<tr class="totales">
					<td colspan="2" align="right"><cf_translate key="LB_Total">Total</cf_translate>&nbsp; #TDcodigo#&nbsp;-&nbsp;#TDdescripcion#</td>
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
