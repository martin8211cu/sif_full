<cfif isdefined("url.CFpk") and not isdefined("form.CFpk")>
	<cfset form.CFpk = url.CFpk >
</cfif>
<cfif isdefined("url.fecha") and not isdefined("form.fecha")>
	<cfset form.fecha = url.fecha >
</cfif>
<cfif isdefined("url.ordenamiento") and not isdefined("form.ordenamiento")>
	<cfset form.ordenamiento = url.ordenamiento >
</cfif>
<cfif isdefined("url.mostrarcomo") and not isdefined("form.mostrarcomo")>
	<cfset form.mostrarcomo = url.mostrarcomo >
</cfif>
<cfset vs_filtro = ''>
<cfif isdefined("form.ordenamiento") and form.ordenamiento EQ 1>
	<cfset vs_filtro = 'order by cf.CFcodigo,a.DEnombre,a.DEapellido1'>
<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 2>		
	<cfset vs_filtro = 'order by cf.CFcodigo,a.DEapellido1,a.DEnombre'>
<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 3>
	<cfset vs_filtro = 'order by a.DEapellido1,a.DEnombre'>
<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 4>
	<cfset vs_filtro = 'order by a.DEnombre,a.DEapellido1'>
<cfelse>
	<cfset vs_filtro = 'order by cf.CFcodigo,a.DEnombre,a.DEapellido1'>
</cfif>


<cffunction name="salario_promedio" returntype="string">
	<cfargument name="Fecha1_Accion" type="date"    required="true" default="#DateAdd('d',  7, Now())#"><!--- CreateDate(2003,10,20)  --->
	<cfargument name="Fecha2_Accion" type="date"    required="true" default="#DateAdd('d', 14, Now())#">
	<cfargument name="DEid"          type="numeric" required="true" default="-1">
	<cfargument name="Ecodigo"       type="numeric" required="true" default="#session.Ecodigo#">
	<cfargument name="Tcodigo"       type="string"  required="true" default="">

	<cfset SalarioPromedio = 0 >
			
	<cfset Tcodigo = Arguments.Tcodigo >
	<cfset lvarRHAlinea = 0 >	

	<cf_dbtemp name="TempPagosEmpleado" returnvariable="tbl_PagosEmpleado">
		<cf_dbtempcol name="Registro" type="numeric" identity="yes" mandatory="yes"> 
		<cf_dbtempcol name="RCNid" type="numeric">
		<cf_dbtempcol name="DEid" type="numeric"> 
		<cf_dbtempcol name="FechaDesde" type="datetime">
		<cf_dbtempcol name="FechaHasta" type="datetime">
		<cf_dbtempcol name="Cantidad" type="int">
		<cf_dbtempcol name="RHAlinea" type="numeric">
		<cf_dbtempkey cols="Registro">
	</cf_dbtemp>
			
	<cfquery name="rsTipoPago" datasource="#Session.DSN#">
		select Ttipopago
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
	</cfquery>
	<cfset Ttipopago = rsTipoPago.Ttipopago>
	
	<cfquery name="rsDiasNoPago" datasource="#Session.DSN#">
		select count(1) as diasnopago
		from DiasTiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
	</cfquery>
	<cfset DiasNoPago = rsDiasNoPago.diasnopago>
	
	<cfswitch expression="#Ttipopago#">
		<cfcase value="0"> <cfset DiasNoPago = DiasNoPago * 1> </cfcase>
		<cfcase value="1"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
		<cfcase value="2"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
		<cfcase value="3"> <cfset DiasNoPago = DiasNoPago * 4> </cfcase>
		<cfdefaultcase> <cfset DiasNoPago = DiasNoPago * 1> </cfdefaultcase>
	</cfswitch>
	
	<cfquery name="rsParametros" datasource="#Session.DSN#">
		select Pvalor as cantidadperiodos
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		and Pcodigo = 160
	</cfquery>

	<!--- JC --->
	<!--- Saca de parametros RH el indicador de meses (1) o periodos (0) --->
	<cfquery name="rsParametros2" datasource="#Session.DSN#">
	select Pvalor as tipodeperiodos
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
	and Pcodigo = 161
	</cfquery>

	<!--- Si el indicador no existe deja el cero (default) ...soporte para clientes viejos --->
	<cfif rsParametros2.recordCount>
		<cfset TipoPeriodos = rsParametros2.tipodeperiodos>
	<cfelse>
		<cfset TipoPeriodos = 0>
	</cfif>
					
	<cfif rsParametros.recordCount>
		<cfset CantidadPeriodos = rsParametros.cantidadperiodos>
	<cfelse>
		<cfset CantidadPeriodos = 13>
	</cfif>

	<cfquery name="rsFecha1" datasource="#Session.DSN#">
		select max(CPdesde) as fecha1
		from CalendarioPagos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
		and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
	</cfquery>

	<cfquery name="rsFecha2" datasource="#Session.DSN#">
		select max(CPhasta) as fecha1
		from CalendarioPagos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
		and CPdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1#">
	</cfquery>

	<cfset Fecha1 = rsFecha2.fecha1>
			
	<!--- JC --->
	<!--- Resta la cantidad de meses a Fecha1, es decir se devuelve esa cantidad de meses --->
	<cfif (Len(Trim(Fecha1)))>
		<cfset Fecha3 = DateAdd('m', -CantidadPeriodos, Fecha1)>
	<cfelse>
		<cfset Fecha3 = DateAdd('m', -CantidadPeriodos, now())>  <!--- OJO ESTO LO TUVE QUE PONER PORQUE SI NO ME DA ERROR  DE NULL, NULL --->  
	</cfif>
					
	<cfif Len(Trim(Fecha1))>
		<cfset Fecha2 = DateAdd('yyyy', -1, DateAdd('d', -30, Fecha1))>
				
		<cfquery name="tbl_PagosEmpleadoInsert" datasource="#session.DSN#">
			insert into #tbl_PagosEmpleado# (RCNid, DEid, FechaDesde, FechaHasta, Cantidad, RHAlinea)
			select distinct a.RCNid, #DEid#, a.RCdesde, a.RChasta, 0, <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
			from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp
			where b.DEid = #DEid#
			and a.RCNid = b.RCNid
			and a.Ecodigo = #arguments.Ecodigo#
			and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
			and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">
			and cp.CPid = a.RCNid
			and cp.CPtipo = 0
			order by a.RChasta desc
		</cfquery>
	</cfif>
	
	<!--- Borrar de la historia los periodos donde existe incapacidad --->
	<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
		delete #tbl_PagosEmpleado#
		where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
		  and exists (	select 1
						from HPagosEmpleado pe, RHTipoAccion d
						where pe.DEid = #tbl_PagosEmpleado#.DEid
							and pe.RCNid = #tbl_PagosEmpleado#.RCNid
							and d.RHTid = pe.RHTid
							and d.RHTcomportam = 5 )
	</cfquery>
			
	<!---
		Borrar de la historia los periodos anteriores o iguales a una salida de la empresa 
		Se busca la fecha maxima de salida y se eliminan los pagos anteriores
	--->
	<cfquery name="rsFechaSalida" datasource="#Session.DSN#">
		select max(LTdesde) as fechasalida
		from LineaTiempo lt, RHTipoAccion ta
		where lt.DEid = #DEid#
		  and ta.RHTid = lt.RHTid
		  and ta.RHTcomportam = 2
		  and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		  and ta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
	</cfquery>
	<cfif rsFechaSalida.recordCount and Len(Trim(rsFechaSalida.fechasalida))>
		<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
			delete #tbl_PagosEmpleado#
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			  and FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#">
		</cfquery>
	</cfif>
	
	<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
		select *
		from #tbl_PagosEmpleado#
		WHERE RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
		order by Registro
	</cfquery>
	<cfloop query="rsPagosEmpleado">
		<cfquery name="updPagoEmpleado" datasource="#Session.DSN#">
			update #tbl_PagosEmpleado#
			set Cantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPagosEmpleado.CurrentRow#">
			where Registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.Registro#">
		</cfquery>
	</cfloop>
	
	<!--- JC  --->
	<!--- Si el tipo que se obtuvo de RHParametros es 1 (meses) se devuelve meses, si no se devuelve periodos  --->
	<cfif TipoPeriodos EQ 1 and Len(Trim(Fecha3))>
		<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
			delete #tbl_PagosEmpleado#
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			  and FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha3#">
		</cfquery>
	<cfelse>
		<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
			delete #tbl_PagosEmpleado#
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			  and Cantidad > <cfqueryparam cfsqltype="cf_sql_integer" value="#CantidadPeriodos#">
		</cfquery>
	</cfif>
	
	<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
		select 1
		from #tbl_PagosEmpleado#
		where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
	</cfquery>
			
	<cfif rsPagosEmpleado.recordCount>
		<cfquery name="rsSalarioPromedio1" datasource="#Session.DSN#">
			select sum(SEsalariobruto + SEincidencias) as salario
			from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
			where se.RCNid = pe.RCNid
			  and se.DEid = pe.DEid
			  and pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
			  and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
		</cfquery>
		<cfquery name="rsSalarioPromedio2" datasource="#Session.DSN#">
			select coalesce(sum(ic.ICmontores), 0.00) as incidencias
			from #tbl_PagosEmpleado# pe, HIncidenciasCalculo ic, CIncidentes ci
			where pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
			  and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			  and  ic.RCNid = pe.RCNid
			  and ic.DEid = pe.DEid
			  and ci.CIid = ic.CIid
			  and ci.CIafectasalprom = 0
		</cfquery>
		<cfquery name="rsSalarioPromedio3" datasource="#Session.DSN#">
			select sum(coalesce(PEcantdias, 0)) as dias
			from HPagosEmpleado b, #tbl_PagosEmpleado# a
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
			  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			  and b.RCNid = a.RCNid
			  and b.DEid = a.DEid
			  and b.PEtiporeg = 0
		</cfquery>
		<cfif rsSalarioPromedio3.recordCount GT 0 AND rsSalarioPromedio3.dias GT 0>
			<cfset Lvardias = rsSalarioPromedio3.dias>
		<cfelse>
			<cfset Lvardias = 1>
		</cfif>

		<!--- Obtener el salario promedio diario --->
<!--- Marcel --->
		<cfif Lvardias EQ 0> <cfset Lvardias = 1></cfif>
		<cfset SalarioPromedio = (rsSalarioPromedio1.salario - rsSalarioPromedio2.incidencias) / Lvardias>
		<!--- Salario Promedio = Salario Promedio Diario * Cantidad de Dias para calculo de Salario Diario --->
		<cfquery name="rsParametros" datasource="#Session.DSN#">
			select FactorDiasSalario as Pvalor
			from TiposNomina
			where Ecodigo = #arguments.Ecodigo#
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
		</cfquery>
		<cfif len(trim(rsParametros.Pvalor)) EQ 0 or rsParametros.RecordCount EQ 0>
			<cfquery name="rsParametros" datasource="#Session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = #arguments.Ecodigo#
				and Pcodigo = 80
			</cfquery>
		</cfif>
		<cfset SalarioPromedio = SalarioPromedio * rsParametros.Pvalor>

		<!--- <cfquery name="dropPagosEmpleado" datasource="#Session.DSN#">
			drop table #tbl_PagosEmpleado#
		</cfquery> --->

	<cfelse>
		<cfset SalarioPromedio = 0>
	</cfif>

	<cfreturn SalarioPromedio >
</cffunction>

<cfsetting requesttimeout="14400">

<style type="text/css">
	td{	font-family:Arial, Helvetica, sans-serif; font-size:small;}
</style>


<!---
 <cf_htmlreportsheaders
			title="Cesantia de Empleados" 
			filename="CesantiaEmpleados#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
			ira="cesantia-filtro.cfm">
--->			

<cfset vfecha_corte 		= '' >
<cfset vfecha_ingreso 		= '' >
<cfset vanos_antes 			= 0 >
<cfset vmeses_antes 		= 0 >
<cfset vmeses_despues 		= 0 >
<cfset vanos_despues1 		= 0 >
<cfset vanos_despues 		= 0 >
<cfset vtotal_meses 		= 0 >
<cfset vaplica	 			= 0 >
<cfset vdias_antes 			= 0 >
<cfset vdias_despues 		= 0 >
<cfset vanos_operador 		= 0 >
<cfset vcantidad 			= 0 >
<cfset vsalariopromedio 	= 0 >
<cfset vresultado 			= 0 >

<style type="text/css">
	.corte { page-break-after:always;  }
	.letra { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif; }
</style>

<!--- Esto deberia salir de una consulta según el empleado --->
<!---
create table #datos
(cedula varchar(30), fecha_ing datetime, cesantia money)

insert #datos
(cedula, fecha_ing, cesantia )
select DEidentificacion, LTdesde, 0
from DatosEmpleado a,  LineaTiempo b
where a.DEid = b.DEid
and LThasta = '61000101'
--->

<cfset vFecha = LSParseDateTime(form.fecha) >

<cfif len(trim(form.CFpk)) eq 0>
	<cfset form.CFpk = 0 >
</cfif>

<cfquery name="rsCF" datasource="#session.DSN#">
	select CFcodigo, CFdescripcion
	from CFuncional
	where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
</cfquery>

<cfsavecontent variable="myquery">
	<cfoutput>
	select 	cf.CFcodigo,
			cf.CFdescripcion, 
			a.DEid,
			a.DEnombre,
			a.DEapellido1,
			a.DEapellido2,
			a.DEidentificacion, 
			b.LTdesde, 
			0 as cesantia,
			b.Tcodigo,
            tn.FactorDiasSalario
	from LineaTiempo b 
	
	inner join DatosEmpleado a
	on b.DEid = a.DEid
	
	inner join RHPlazas p
	on p.RHPid=b.RHPid
	<cfif form.CFpk gt 0 >
		and p.CFid = #form.CFpk#
	</cfif>
	
	inner join CFuncional cf
	on cf.CFid = p.CFid
    
    inner join TiposNomina tn
    on tn.Ecodigo = b.Ecodigo
    and tn.Tcodigo = b.Tcodigo

	where {d '#LSDateFormat(LSParsedateTime(form.fecha), "yyyy-mm-dd")#'} between b.LTdesde and b.LThasta
	and b.Ecodigo = #session.Ecodigo#

	and exists (  	select 1 
				from EVacacionesEmpleado
				where DEid = b.DEid
				and EVfantig <= {d '#LSDateFormat(LSParsedateTime(form.fecha), "yyyy-mm-dd")#'} )
	
	#vs_filtro# <!---a.DEapellido1 cf.CFcodigo, a.DEidentificacion--->
	</cfoutput>
</cfsavecontent>

<cftry>
	<cfflush interval="8000">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#preservesinglequotes(myquery)#</cfoutput>
	</cf_jdbcquery_open>
	
	<!---
	<cfif isdefined("url.exportar")>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Mov_Adq_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	</cfif>
	--->
		<table width="95%" align="center" cellpadding="2" cellspacing="0">
			<cfoutput>
			<tr>
				<td colspan="14">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td>
							<cfinvoke key="LB_Reporte_de_Cesantia_Masiva" default="Reporte de Cesant&iacute;a Masiva" returnvariable="LB_Reporte_de_Cesantia_Masiva" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate"  method="Translate" xmlfile="/rh/generales.xml"/>
							<cfinvoke key="LB_Todos" default="Todos" returnvariable="LB_Todos" component="sif.Componentes.Translate"  method="Translate"/>
							<cfset filtro1= ''>
							<cfif form.CFpk gt 0>
								<cfset filtro1= '#LB_CentroFuncional#: #trim(rsCF.CFcodigo)# - #rsCF.CFdescripcion#'>
							<cfelse>
								<cfset filtro1= '#LB_CentroFuncional#: #LB_Todos#'>
							</cfif>
							<cf_EncReporte
								Titulo="#LB_Reporte_de_Cesantia_Masiva#"
								Color="##E3EDEF"
								filtro1="#filtro1#"	
							>
						</td></tr>
					</table>
				</td>
			</tr>
			<!-----================================= ENCABEZADO ANTERIOR =================================
			<tr>
				<td colspan="14" align="center"><strong><font size="+1" face="Arial, Helvetica, sans-serif">#session.Enombre#</font></strong></td>
			</tr>
			<tr>
				<td colspan="14" align="center"><strong><font size="+0" face="Arial, Helvetica, sans-serif"><cf_translate key="LB_Reporte_de_Cesantia_Masiva">Reporte de Cesant&iacute;a Masiva</cf_translate></font></strong></td>
			</tr>
			<tr>
				<td colspan="14" align="center"><strong><font face="Arial, Helvetica, sans-serif"><cf_translate key="LB_CentroFuncional" xmlfile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</font></strong><cfif form.CFpk gt 0>#trim(rsCF.CFcodigo)# - #rsCF.CFdescripcion#<cfelse>Todos</cfif></td>
			</tr>
			<tr>
				<td colspan="14" align="center"><strong><font face="Arial, Helvetica, sans-serif"><cf_translate key="LB_FECHA" xmlfile="/rh/generales.xml">Fecha</cf_translate>:&nbsp;</font></strong>#form.fecha#</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			----->
			</cfoutput>

			
			
			<!---
			<tr bgcolor="#c7c7c7">
				<td class="letra"><strong>Identificaci&oacute;n</strong></td>
				<td class="letra"><strong>Nombre</strong></td>
				<td class="letra" align="right"><strong>Salario Promedio</strong></td>
				<td class="letra" align="center"><strong>Fecha de Ingreso</strong></td>
				<td class="letra" align="center"><strong>Cantidad de D&iacute;as</strong></td>
				<td class="letra" align="right"><strong>Monto Cesant&iacute;a</strong></td>
			</tr>
			--->
		
		<cfset registros = 0 >
		<cfset registros_pagina = 0 >		
			
			<tr bgcolor="f5f5f5">
				<td class="letra"><strong><cf_translate key="LB_Identificacion" xmlfile="/rh/generales.xml">Identificaci&oacute;n</cf_translate></strong></td>
				<td class="letra"><strong><cf_translate key="LB_Nombre" xmlfile="/rh/generales.xml">Nombre</cf_translate></strong></td>
				<td class="letra" align="center"><strong><cf_translate key="LB_Fecha_de_Ingreso" xmlfile="/rh/generales.xml">Fecha de Ingreso</cf_translate></strong></td>
				<td class="letra" align="center"><strong><cf_translate key="LB_Tiempo_años" xmlfile="/rh/generales.xml">Años</cf_translate></strong></td>
				<td class="letra" align="center"><strong><cf_translate key="LB_Tiempo_meses" xmlfile="/rh/generales.xml">Meses</cf_translate></strong></td>
				<td class="letra" align="center"><strong><cf_translate key="LB_Tiempo_dias" xmlfile="/rh/generales.xml">D&iacute;as</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Salario_Promedio">Salario Promedio</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">D&iacute;as Antes</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">D&iacute;as Después</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">D&iacute;as Antes (Transici&oacute;n)</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">D&iacute;as Despu&eacute;s (Transici&oacute;n)</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">Cantidad de D&iacute;as</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Salario_Promedio">Promedio Diario</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Monto_Cesantia">Monto Cesant&iacute;a</cf_translate></strong></td>
			</tr>

			<!---<cfoutput query="data" group="CFcodigo">--->
			<cfoutput query="data">
				<!---
				<tr bgcolor="##c7c7c7">
					<td class="letra" colspan="5"><strong>Centro Funcional:&nbsp;</strong>#trim(CFcodigo)# - #CFdescripcion#</td>
				</tr>
				--->
	

				<!---<cfoutput>--->

				<cfset registros = registros + 1 >		
				<cfset registros_pagina = registros_pagina + 1 >				
	
				<!--- select @fecha_ingreso = '20050906' --->
				<cfquery name="rsFechaIngreso" datasource="#session.DSN#">
					select EVfantig 
					from EVacacionesEmpleado
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				</cfquery>
				<cfset vfecha_ingresoview = rsFechaIngreso.EVfantig >
				<cfset vfecha_ingreso = rsFechaIngreso.EVfantig >
										
				<cfset vsalariopromedio= salario_promedio(vFecha, DateAdd('d', 14, Now()),DEid,session.Ecodigo,Tcodigo) >
				<cfset vsalariopromedioview = vsalariopromedio >			
				<cfset vsalariopromedio = vsalariopromedio / FactorDiasSalario >
	
				<cfset vfecha_corte = createdate(2001, 03, 01) > <!--- '20010301' --->
	
	<!---  ----------------------------------------------------------------	 Nuevo Codigo de JCG ---->			
				
				
	<cfif vfecha gte vfecha_ingreso>  			
		<cfset vanos_total =  datediff('yyyy', vfecha_ingreso, vfecha ) >
	<cfelse>  
		<cfset vanos_total = 0 >
	</cfif>	

	<cfset rango =  8 * 12 >  <!---  Máximo de años permitido para pago = 8 años --->
	
	<!---  Tiempo Laborado --->
	<cfset tiempo_anos =  abs(datediff('yyyy', vfecha_ingreso, vfecha )) >
	<cfset tiempo_meses = datediff('m', vfecha_ingreso, vfecha ) - (tiempo_anos * 12) >
	<!---**<cfdump var="#datediff('m', vfecha_ingreso, vfecha )#">**  <cfdump var="#LSDateFormat(vfecha_ingreso, 'dd/mm/yyyy')#"> contra <cfdump var="#LSDateFormat(vfecha, 'dd/mm/yyyy')#"> <br />--->
	<cfset tiempo_dias =  datediff('d', vfecha_ingreso, dateadd('m', -tiempo_meses, dateadd('yyyy', -tiempo_anos, vfecha )))+1 >
	
	<cfset vtotal_meses =  datediff('m', vfecha_ingreso, vfecha ) >
	
	<!---  Se modifica la fecha de ingreso para calcular sobre el rango permitido (8años) --->
	<cfif vtotal_meses gt rango >  			
		<cfset vfecha_ingreso =  dateadd('d',vfecha,-((rango/12)*365)) >
	</cfif>	
	
	<!---  Años Antes de la Ley --->
	<cfif vfecha_corte gte vfecha_ingreso >  			
		<cfset vanos_antes =  abs(datediff('yyyy', vfecha_corte, vfecha_ingreso )) >
	<cfelse>
		<cfset vanos_antes = 0 >
	</cfif>
	
	<!---  Meses Antes de la Ley --->
	<cfif vfecha_corte gte vfecha_ingreso >  			
		<!--- <cfset vmeses_antes =  datediff('m', vfecha_corte, vfecha_ingreso ) - (vanos_antes * 12) >  --->
		<cfset vmeses_antes =  round(abs(datediff('d', vfecha_corte, vfecha_ingreso )) / 30.5) - (vanos_antes * 12) >
	<cfelse>
		<cfset vmeses_antes = 0 >
	</cfif>
		
	<!---  Total Meses Después de la Ley --->
	<cfif vfecha_ingreso lte vfecha_corte >  			
		<cfset vtotal_meses_despues =  abs(datediff('m', vfecha_corte, vfecha )) >
	<cfelse>
		<cfset vtotal_meses_despues =  abs(datediff('m', vfecha_ingreso , vfecha )) >
	</cfif>
		
	<!---  Periodo de Transición --->
	<cfif (vmeses_antes + vtotal_meses_despues ) gte 12 >
		<cfset mdproctran =  12 >
	<cfelse>
		<cfset mdproctran =  (vmeses_antes + vtotal_meses_despues )  >
	</cfif>
	
	<!---  Meses Después (sin transición) --->
	<cfif mdproctran gte vtotal_meses_despues >
		<cfset vmeses_despues =  0 >
	<cfelse>
		<cfset vmeses_despues =  mdproctran - vmeses_antes  >
	</cfif>
	
	<!---  Años Después --->
	<cfif vmeses_antes eq 0 >
		<cfset vanos_despues =  vtotal_meses_despues / 12 >
	<cfelse>
		<cfif ( vtotal_meses_despues - vmeses_despues) gte 12  >
			<cfset vanos_despues =  (vtotal_meses_despues - vmeses_despues) / 12 >
		<cfelse>
			<cfset vanos_despues =  0 >
		</cfif>	
	</cfif>

	<cfset ventero_despues =  fix(vanos_despues) >
	<cfset vresiduo_despues =  vanos_despues - ventero_despues >
	
	<!---  Años Después --->
	<cfif vresiduo_despues gte 0.50 >
		<cfset vanos_despues =  ventero_despues + 1 >
	<cfelse>
		<cfset vanos_despues =  ventero_despues >
	</cfif>
	
						
				<!--- Aplica --->							
				
				<cfset vaplica = 0 >
							
				<cfif vtotal_meses gte 3 >
					<cfif vtotal_meses lt 6 >
						<cfset vaplica = 7 >
					</cfif>
				</cfif>

				<cfif vtotal_meses gte 96 >
					<cfset vfecha_ingreso =  vfecha - (8 *365) >
				</cfif>					
			
				<cfif vtotal_meses gte 6 and vtotal_meses lt 12 >
					<cfset vaplica = 14 >
				</cfif>
	
				<cfif vtotal_meses gte 12 and  vtotal_meses lt 24 >
					<cfset vaplica = 19.5 >
				</cfif>
	
				<cfif vtotal_meses gte 24 and vtotal_meses lt 36 >
					<cfset vaplica = 20 >
				</cfif>			
				
				<cfif vtotal_meses gte 36 and vtotal_meses lt 48 >
					<cfset vaplica = 20.5 >
				</cfif>			
	
				<cfif vtotal_meses gte 48 and vtotal_meses lt 60 >
					<cfset vaplica = 21 >
				</cfif>			
	
				<cfif vtotal_meses gte 60 and vtotal_meses lt 72 >
					<cfset vaplica = 21.24 >
				</cfif>			
	
				<cfif vtotal_meses gte 72 and vtotal_meses lt 84 >
					<cfset vaplica = 21.5 >
				</cfif>						
				
				<cfif vtotal_meses gte 84 and vtotal_meses lt 96 >
					<cfset vaplica = 22 >
				</cfif>						
	
				<cfif vtotal_meses gte 96 and vtotal_meses lt 108 >
					<cfset vaplica = 22 >
				</cfif>						
	
				<cfif vtotal_meses gte 108 and vtotal_meses lt 120 >
					<cfset vaplica = 22 >
				</cfif>						
	
				<cfif vtotal_meses gte 120 and vtotal_meses lt 132 >
					<cfset vaplica = 21.5 >
				</cfif>						
	
				<cfif vtotal_meses gte 132 and vtotal_meses lt 144 >
					<cfset vaplica = 21 >
				</cfif>						
				
				<cfif vtotal_meses gte 132 and vtotal_meses lt 144 >
					<cfset vaplica = 21 >
				</cfif>						
				
				<cfif vtotal_meses gte 156 >
					<cfset vaplica = 20 >
				</cfif>
				
			<!--- fin de aplica --->	
				
	
					
				<cfset vdias_antes = vanos_antes * 30>
							
				<cfif vanos_total gte 1>
					<cfset factordiasantes = 30 >
				<cfelse>	
					<cfset factordiasantes = 20 >
				</cfif>

				<!---  TRANSICION --->
				
				<!---  Días antes de la transicion --->
<!--- Marcel--->
				<cfif mdproctran EQ 0> <cfset mdproctran = 1></cfif>

				<cfset vdias_antes_tran = ( vmeses_antes / mdproctran ) * factordiasantes >
				
								
				<!---  dias despues de la transicion --->
				<cfif vmeses_antes eq 0>
					<cfset vdias_despues_tran =  0 >
				<cfelse>	
					<cfset vdias_despues_tran  =  (vmeses_despues / mdproctran) *  vaplica > 
				</cfif>
								
									
				<!---  fin de TRANSICION --->
				<cfif vanos_despues lt 0>
					<cfset vdias_despues =  0 >
				<cfelse>	
					<cfif vanos_despues eq 0>
						<cfset vdias_despues =  vaplica >
					<cfelse>	
						<cfset vdias_despues  =  vanos_despues * vaplica > 
					</cfif>
				</cfif>
				
						
				
				<cfset vcantidad = vdias_antes + vdias_despues + vdias_antes_tran + vdias_despues_tran >
				<cfset vresultado = vsalariopromedio * vcantidad >
							
				<!---
				---  Despliega informacion
				select @fecha_corte, @fecha_ingreso, @fecha, @salariopromedio, @resultado resultado
				--->
	
				<cfif registros_pagina eq 40 >
					<tr class="corte" ><td></td></tr>
					<tr>
						<td colspan="14">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr><td>
									<cfinvoke key="LB_Reporte_de_Cesantia_Masiva" default="Reporte de Cesant&iacute;a Masiva" returnvariable="LB_Reporte_de_Cesantia_Masiva" component="sif.Componentes.Translate"  method="Translate"/>
									<cfinvoke key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate"  method="Translate" xmlfile="/rh/generales.xml"/>
									<cfinvoke key="LB_Todos" default="Todos" returnvariable="LB_Todos" component="sif.Componentes.Translate"  method="Translate"/>
									<cfset filtro1= ''>
									<cfif form.CFpk gt 0>
										<cfset filtro1= '#LB_CentroFuncional#: #trim(rsCF.CFcodigo)# - #rsCF.CFdescripcion#'>
									<cfelse>
										<cfset filtro1= '#LB_CentroFuncional#: #LB_Todos#'>
									</cfif>
									<cf_EncReporte
										Titulo="#LB_Reporte_de_Cesantia_Masiva#"
										Color="##E3EDEF"
										filtro1="#filtro1#"	
									>
								</td></tr>
							</table>
						</td>
					</tr>
					<!----==================== ENCABEZADO ANTERIOR ====================
					<tr>
						<td colspan="7" align="center"><strong><font size="+1" face="Arial, Helvetica, sans-serif">#session.Enombre#</font></strong></td>
					</tr>
					<tr>
						<td colspan="7" align="center"><strong><font size="+0" face="Arial, Helvetica, sans-serif">Reporte de Cesant&iacute;a Masiva</font></strong></td>
					</tr>
					<tr>
						<td colspan="7" align="center"><strong><font face="Arial, Helvetica, sans-serif">Centro Funcional:&nbsp;</font></strong><cfif form.CFpk gt 0>#trim(rsCF.CFcodigo)# - #rsCF.CFdescripcion#<cfelse>Todos</cfif></td>
					</tr>
					<tr>
						<td colspan="7" align="center"><strong><font face="Arial, Helvetica, sans-serif">Fecha:&nbsp;</font></strong>#form.fecha#</td>
					</tr>
					----->
			<tr bgcolor="f5f5f5">
				<td class="letra"><strong><cf_translate key="LB_Identificacion" xmlfile="/rh/generales.xml">Identificaci&oacute;n</cf_translate></strong></td>
				<td class="letra"><strong><cf_translate key="LB_Nombre" xmlfile="/rh/generales.xml">Nombre</cf_translate></strong></td>
				<td class="letra" align="center"><strong><cf_translate key="LB_Fecha_de_Ingreso" xmlfile="/rh/generales.xml">Fecha de Ingreso</cf_translate></strong></td>
				<td class="letra" align="center"><strong><cf_translate key="LB_Tiempo_años" xmlfile="/rh/generales.xml">Años</cf_translate></strong></td>
				<td class="letra" align="center"><strong><cf_translate key="LB_Tiempo_meses" xmlfile="/rh/generales.xml">Meses</cf_translate></strong></td>
				<td class="letra" align="center"><strong><cf_translate key="LB_Tiempo_dias" xmlfile="/rh/generales.xml">D&iacute;as</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Salario_Promedio">Salario Promedio</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">D&iacute;as Antes</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">D&iacute;as Despu&eacute;s</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">D&iacute;as Antes (Transici&oacute;n)</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">D&iacute;as Despu&eacute;s (Transici&oacute;n)</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">Cantidad de D&iacute;as</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Salario_Promedio">Promedio Diario</cf_translate></strong></td>
				<td class="letra" align="right"><strong><cf_translate key="LB_Monto_Cesantia">Monto Cesant&iacute;a</cf_translate></strong></td>
			</tr>

				</cfif>
				<tr >
					<td class="letra">#trim(DEidentificacion)#</td>
					<!---<td class="letra" nowrap="nowrap">#DEapellido1# #DEapellido2# #DEnombre#</td>--->
					
					<td class="letra" nowrap="nowrap">
						<cfif isdefined("form.mostrarComo") and form.mostrarComo EQ 1>
							#DEnombre# #DEapellido1# #DEapellido2#
						<cfelseif isdefined("form.mostrarComo") and form.mostrarComo EQ 2>		
							#DEapellido1# #DEapellido2# #DEnombre#
						<cfelse>
							#DEnombre# #DEapellido1# #DEapellido2#
						</cfif>
					</td>
					
					<td class="letra" align="center">#LSDateformat(vfecha_ingresoview, 'dd/mm/yyyy')#</td>
					<td class="letra" align="center">#tiempo_anos#</td>
					<td class="letra" align="center">#tiempo_meses#</td>
					<td class="letra" align="center">#tiempo_dias#</td>
					<td class="letra" align="right">#LSNumberFormat(vsalariopromedioview, '9,00.00')#</td>
					<td class="letra" align="right">#LSNumberFormat(vdias_antes, ',9.00')#</td>
					<td class="letra" align="right">#LSNumberFormat(vdias_despues, ',9.00')#</td>
					<td class="letra" align="right">#LSNumberFormat(vdias_antes_tran, ',9.00')#</td>
					<td class="letra" align="right">#LSNumberFormat(vdias_despues_tran, ',9.00')#</td>
					<td class="letra" align="right" bgcolor="f5f5f5">#LSNumberFormat(vcantidad, ',9.00')#</td>
					<td class="letra" align="right">#LSNumberFormat(vsalariopromedio, '9,00.00')#</td>
					<td class="letra" align="right" bgcolor="f5f5f5">#LSNumberFormat(vresultado, ',9.00')#</td>
				</tr>
				
				<cfif registros_pagina eq 40 >
					<cfset registros_pagina = 0 >
				</cfif>

			<!---</cfoutput>--->
		</cfoutput>
		
		<tr><td>&nbsp;</td></tr>
		<cfif registros gt 0 >
			<tr><td colspan="14" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
		<cfelse>
			<tr><td colspan="14" align="center" class="letra">--- <cf_translate key="MSG_NoSeEncontraronRegistros" xmlfile="/rh/generales.xml">No se encontraron Registros</cf_translate>---</td></tr>
		</cfif>


		</table>
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfthrow object="#cfcatch#">
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
