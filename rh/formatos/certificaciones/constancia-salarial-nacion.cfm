<cf_dbtemp name="constancia" returnvariable="constancia" datasource="#session.dsn#">
	<cf_dbtempcol name="nombre"			type="varchar(60)"  mandatory="no">
	<cf_dbtempcol name="identificacion"	type="varchar(10)"  mandatory="no">
	<cf_dbtempcol name="salariomensual"	type="money"		mandatory="no">
	<cf_dbtempcol name="salariodiario"	type="money"		mandatory="no">
	<cf_dbtempcol name="puesto"			type="varchar(50)"	mandatory="no">
	<cf_dbtempcol name="codigopuesto"	type="varchar(5)"	mandatory="no">
	<cf_dbtempcol name="plaza"			type="varchar(5)"	mandatory="no">
	<cf_dbtempcol name="plazadesc"		type="varchar(50)"	mandatory="no">	
	<cf_dbtempcol name="departamento"	type="varchar(50)"	mandatory="no">
	<cf_dbtempcol name="oficina"		type="varchar(50)"	mandatory="no">
	<cf_dbtempcol name="empresa"		type="varchar(50)"	mandatory="no">
	<cf_dbtempcol name="fechai"			type="datetime"		mandatory="no">
	<cf_dbtempcol name="salariobruto"	type="money"  		mandatory="no">
	<cf_dbtempcol name="salarioliquido"	type="money"  		mandatory="no">
	<cf_dbtempcol name="renta"			type="money"		mandatory="no">
	<cf_dbtempcol name="deducciones"	type="money"		mandatory="no">
	<cf_dbtempcol name="cargas"			type="money"		mandatory="no">
	<cf_dbtempcol name="periodo"		type="int"			mandatory="no">
	<cf_dbtempcol name="mes"			type="varchar(10)"  mandatory="no">
</cf_dbtemp>

<cfset Errs="">

<cfif len(rtrim(rsData.fecha)) eq 0>
		<cfset Errs=Errs&"- No se existe una Fecha de Solicitud definida<br>">
<cfelseif len(rtrim(rsData.DEidentificacion)) eq 0>
	<cfset Errs=Errs&"- No se definió un N&uacute;mero de Identificaci&oacute;n al Empleado<br>">
</cfif>
	
<cfset prommensual 		= 0 >
<cfset prombisemanal 	= 0 >
<cfset fechaL 			= '' >
<cfset date 			= now() >
<cfset periodo 			= year(rsData.fecha) >
<cfset mes 				= month(rsData.fecha) >
<cfset fechah 			= '' >
<cfset fechai 			= '' >
<cfset fechaingreso 	= '' >
<cfset fecletra 		= '' >
<cfset salariobrutoP 	= 0 >
<cfset salarioliquidoP 	= 0 >
<cfset nomina 			= '' >
<cfset embargos 		= 0 >
<cfset bruto_ultimo 	= 0 >
<cfset liquido_ultimo 	= 0 >

<cffunction name="CalculoPromedio" output="false" access="public" returntype="struct">
		<cfargument name="cedula" 	type="string" 	required="yes"> <!--- Cedula del empleado  --->
		<cfargument name="nomina" 	type="string" 	required="yes"> <!--- Tipo de Nómina --->
		<cfargument name="fecha" 	type="string" 	required="yes"> <!--- fecha apartir de la cual se desea conocer el promedio del salario --->
		
	 <cfset StructReturn = StructNew()>
	
		<cfset DEid                   	= 0 >
		<cfset salariopromediodiario   	= 0 >
		<cfset salariopromediomensual  	= 0 >
		<cfset salariopromedioLdiario  	= 0 >
        <cfset salariopromedioLmensual 	= 0 >
		<cfset fecha1                 	= ''> 
		<cfset fecha2                 	= ''>
		<cfset cantidad               	= 0 >
		<cfset cantidadperiodos       	= 0 >
		<cfset fechasalida            	= ''>
		<cfset Ttipopago              	= 0 >
		<cfset DiasNoPago             	= 0 >

		<cfquery name="rsEmpleado" datasource="#session.DSN#">
			select d.DEid, d.Ecodigo  
			  from DatosEmpleado d 
			where d.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cedula#">
			  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
		</cfquery>
		
		<cfif len(trim(rsEmpleado.DEid))>
			<cfset DEid = rsEmpleado.DEid >
		</cfif>	

		<cf_dbtemp name="pagosempleado" returnvariable="pagosempleado" datasource="#session.dsn#">
			<cf_dbtempcol name="registro"				type="numeric"  		mandatory="yes" identity="yes">
			<cf_dbtempcol name="RCNid"					type="numeric"  		mandatory="no">
			<cf_dbtempcol name="DEid"					type="numeric"			mandatory="no">
			<cf_dbtempcol name="fechadesde"				type="datetime"			mandatory="no">
			<cf_dbtempcol name="fechahasta"				type="datetime"			mandatory="no">
			<cf_dbtempcol name="cantidad"				type="int"				mandatory="no">	
			<cf_dbtempcol name="bruto"					type="money"  			mandatory="no">
			<cf_dbtempcol name="incidencias"			type="money"			mandatory="no">
			<cf_dbtempcol name="salarioneto"			type="money"			mandatory="no">
			<cf_dbtempcol name="salnetoconstancias"		type="money"			mandatory="no">
			<cf_dbtempcol name="deducciones"			type="money"  			mandatory="no">
		</cf_dbtemp>

		<cf_dbtemp name="PET" returnvariable="PET" datasource="#session.dsn#">
			<cf_dbtempcol name="registro"				type="numeric"  		mandatory="yes">
			<cf_dbtempcol name="RCNid"					type="numeric"  		mandatory="no">
			<cf_dbtempcol name="DEid"					type="numeric"			mandatory="no">
			<cf_dbtempcol name="fechadesde"				type="datetime"			mandatory="no">
			<cf_dbtempcol name="fechahasta"				type="datetime"			mandatory="no">
			<cf_dbtempcol name="cantidad"				type="int"				mandatory="no">	
			<cf_dbtempcol name="bruto"					type="money"  			mandatory="no">
			<cf_dbtempcol name="incidencias"			type="money"			mandatory="no">
			<cf_dbtempcol name="salarioneto"			type="money"			mandatory="no">
			<cf_dbtempcol name="salnetoconstancias"		type="money"			mandatory="no">
			<cf_dbtempcol name="deducciones"			type="money"  			mandatory="no">
		</cf_dbtemp>
	
		
		<cfquery name="rsTipoPago" datasource="#session.DSN#">
			select Ttipopago 
			from TiposNomina 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.nomina#">
		</cfquery>
		<cfset Ttipopago = rsTipoPago.Ttipopago >

		<cfquery name="rsDiasNoPago" datasource="#session.DSN#">
		  select coalesce(count(1), 0) as dias
			from DiasTiposNomina 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.nomina#">
		</cfquery>
		<cfset DiasNoPago = rsDiasNoPago.dias >

		<cfswitch expression = #Ttipopago#>
			<cfcase value = "0"><cfset DiasNoPago = DiasNoPago * 1 ></cfcase>
			<cfcase value = "1"><cfset DiasNoPago = DiasNoPago * 2 ></cfcase>
			<cfcase value = "2"><cfset DiasNoPago = DiasNoPago * 3 ></cfcase>
			<cfcase value = "3"><cfset DiasNoPago = DiasNoPago * 4 ></cfcase>
		</cfswitch>

		<cfquery name="rsParam160" datasource="#session.DSN#">
			select coalesce(min(Pvalor), '12') as Pvalor
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 160 
		</cfquery>
		<cfset cantidadperiodos = rsParam160.Pvalor >	
		
		<cfset cantidadperiodos = 12>	<!--- Nacion no puede usar el Parámetro General, pq lo utiliza para Cálculo de Pagos de Vacaciones--->

		<!--- Extrae la Fecha del Calendario de Pagos Mas Cercano a la Fecha de la Certificacion --->
		<cfquery name="rsFecha1" datasource="#session.DSN#">
			select max(RCdesde) as CPdesde
			from HRCalculoNomina a
			inner join HSalarioEmpleado b
			on   a.RCNid=b.RCNid
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.nomina#">
			  and RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
			  and DEid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">	
		</cfquery>	

			<cfset fecha1 = rsFecha1.CPdesde >
			<cfif len(rsFecha1.CPdesde) EQ 0>
					<!--- No hay Calendarios se devuelve 0 --->
					<cfset StructInsert(StructReturn,"salariobrutoP", 0)>  
					<cfset StructInsert(StructReturn,"salarioLiquidoPL", 0)>  
					<cfset StructInsert(StructReturn,"salariobrutoUM", 0)>  
					<cfset StructInsert(StructReturn,"salarioLiquidoUM", 0)> 		
					<cfreturn StructReturn>
			</cfif>

		
		<cfset fecha1 = rsFecha1.CPdesde > 		<!--- Indica el Hasta de la Nómina Anterior al Calendario mas cercano--->
		<cfset fecha2 = dateadd('yyyy', -3, fecha1) > <!---  a la Fecha resultante le resta 3 año de histórico --->

		<cfquery datasource="#session.DSN#">
			insert #pagosempleado#( RCNid, DEid, fechadesde, fechahasta, cantidad, bruto, incidencias, salarioneto, salnetoconstancias, deducciones ) 
			select distinct a.RCNid, 
							b.DEid, 
							a.RCdesde, 
							a.RChasta, 
							SEsalariobruto, 
							( select coalesce(sum(ICmontores), 0)  
							  from  HIncidenciasCalculo hci
								inner join CIncidentes ci
								on hci.CIid=ci.CIid
							  where HIncidenciasCalculo.RCNid = b.RCNid  
							      and HIncidenciasCalculo.DEid = b.DEid 
							      and HIncidenciasCalculo.CIid = CIncidentes.CIid 
							      and CIafectasalprom = 1) ,
							SEliquido,
							0,
							SEdeducciones 
			from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp 
			where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid #">
			  and a.RCNid = b.RCNid 
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha1#">
			  and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha2#">
			  and cp.CPid = a.RCNid 
			  and cp.CPtipo = 0 
			order by a.RChasta desc 
		</cfquery>
		<cf_dumptable var="#pagosempleado#">
					 
		<!--- Borrar de la historia los periodos donde existe incapacidad ---> 
		<cfquery datasource="#session.DSN#">
			delete from #pagosempleado# 
			where exists( select 1
						  from HPagosEmpleado pe, RHTipoAccion d 
						  where pe.DEid = #pagosempleado#.DEid 
							and pe.RCNid = #pagosempleado#.RCNid 
							and d.RHTid = pe.RHTid 
							and d.RHTcomportam = 5 )
		</cfquery>
		
		<!--- Borrar de la historia los periodos anteriores o iguales a una salida de la empresa 
		 	  Se busca la fecha maxima de salida y se eliminan los pagos anteriores ---> 
		<cfquery datasource="#session.DSN#">
			delete from #pagosempleado# 
			where fechahasta <= (Select EVfantig
								 from EVacacionesEmpleado eve
								 Where eve.DEid = #pagosempleado#.DEid)
		</cfquery>		
		
		<!--- Borrar de la historia cuando hay mas periodos de los requeridos ---> 		
		<cfquery datasource="#session.DSN#">
		delete from #pagosempleado# 
		where registro > <cfqueryparam cfsqltype="cf_sql_integer" value="#cantidadperiodos#">
		</cfquery>
			  

		<cfquery datasource="#session.DSN#">
			update #pagosempleado# 
			set salnetoconstancias = 		  
							(select b.SEsalariobruto + SEincidencias -
								   (	coalesce( (	select coalesce(sum(d.DCvalor),0.00)  
													from HDeduccionesCalculo d, 
													inner join DeduccionesEmpleado e
														on d.Did =e.Did
														inner join TDeduccion f  
														on and e.TDid = f.TDid 
													where d.DEid = b.DEid  
												  	  and d.RCNid = b.RCNid 
												  	  and  f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
														  and  exists (Select 1
																from RHReportesNomina rhpn
																	inner join RHColumnasReporte rhcr
																	on  rhpn.RHRPTNid=rhcr.RHRPTNid
																		inner join RHConceptosColumna rhcc
																		on rhcc.RHCRPTid=rhcr.RHCRPTid
																Where Ecodigo=1214
																and RHRPTNcodigo='CERTN'
																and RHCRPTcodigo='NacSalNeto'
																and f.TDid=rhcc.TDid)
)
										  		 , 0.00) 							
								   )
							from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp 
							where a.RCNid = #pagosempleado#.RCNid
							  and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid #">
							  and a.RCNid = b.RCNid 
							  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha1#">
							  and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha2#">
							  and cp.CPid = a.RCNid 
							  and cp.CPtipo = 0 
							 and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )

			where #pagosempleado#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid #">
			and exists ( 	select 1 
							from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp 
							where a.RCNid = #pagosempleado#.RCNid
							  and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid #">
							  and a.RCNid = b.RCNid 
							  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha1#">
							  and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha2#">
							  and cp.CPid = a.RCNid 
							  and cp.CPtipo = 0 
							 and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
		</cfquery>			

		
		<!--- ordenar los registros por fecha desde --->
		<cfquery datasource="#session.DSN#">
			insert into #PET#(registro, RCNid, DEid, fechadesde, fechahasta, cantidad, bruto, incidencias, salarioneto,salnetoconstancias,deducciones)
			select registro, RCNid, DEid, fechadesde, fechahasta, cantidad, bruto, incidencias, salarioneto,salnetoconstancias,deducciones
     		from #pagosempleado# 
			order by fechadesde 
		</cfquery>
		
		<cfquery name="rsSalarioProm" datasource="#session.DSN#">
			select sum(bruto + incidencias) as salariopromediodiario
			from #PET#  
		</cfquery>
		<cfset salariopromediodiario = rsSalarioProm.salariopromediodiario>

		<!--- Obtener el salario promedio diario bruto --->
		<cfquery name="rsSalarioPromedio" datasource="#session.DSN#">
			select sum(PEcantdias) as PEcantdias
			from HPagosEmpleado a, #PET# b
			where a.DEid = b.DEid
			  and a.RCNid = b.RCNid 
			  and a.PEtiporeg = 0
		</cfquery>
		<cfif len(trim(rsSalarioPromedio.PEcantdias)) and rsSalarioPromedio.PEcantdias gt 0>
			<cfset salariopromediodiario = salariopromediodiario / rsSalarioPromedio.PEcantdias >
		</cfif>

		<!--- Obtener el Salario devengado en el Ultimo mes --->
        <cfquery name="rsBruto" datasource="#session.DSN#">
			select sum(bruto) as bruto
			from #PET# a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			and a.fechadesde <= ( 	select max(fechadesde) 
								  	from #pagosempleado# b
								  	where b.DEid = a.DEid )  
			and a.fechadesde >= (	select <cf_dbfunction name="dateadd" args="-16, max(fechadesde)">	
									from #pagosempleado# b 
									where b.DEid = a.DEid )
		</cfquery>
		<cfset bruto_ult_mes = rsBruto.bruto >

        <cfquery name="rsSalNetoConstancias" datasource="#session.DSN#">
			select sum(salnetoconstancias) as salnetoconstancias
			from #PET# a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			and a.fechadesde <= (select max(fechadesde) from #pagosempleado# b
								where b.DEid = a.DEid )  
			and a.fechadesde >= (select dateadd(dd, -16 , max(fechadesde)) from #pagosempleado# b 
								where b.DEid = a.DEid )
		</cfquery>
		<cfset liquido_ult_mes = rsSalNetoConstancias.salnetoconstancias >

   		<!--- Salario Promedio Mensual = Salario Promedio Diario * Cantidad de Dias para calculo de Salario Diario --->
        <cfquery name="rsParametro80" datasource="#session.DSN#">
	   		select coalesce(Pvalor, '0') as Pvalor 
     		from RHParametros 
    		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      		  and Pcodigo = 80 
		</cfquery>
		<cfif len(trim(rsParametro80.Pvalor)) and len(trim(salariopromediodiario))>
			<cfset salariopromediomensual = salariopromediodiario * rsParametro80.Pvalor > 
		</cfif>

        <cfquery name="rssalnetoconstancias" datasource="#session.DSN#">
			select sum(salnetoconstancias) as salnetoconstancias
			from #PET# 
		</cfquery>
		<cfset salariopromedioLdiario = rssalnetoconstancias.salnetoconstancias>
     	
		<!--- Obtener el salario promedio diario liquido --->
        <cfquery name="rsPEcantdias" datasource="#session.DSN#">
			select sum(PEcantdias) as PEcantdias
			from HPagosEmpleado a, #PET# b
			where a.DEid = b.DEid
				and a.RCNid = b.RCNid 
				and a.PEtiporeg = 0
		</cfquery>
		<cfif len(trim(rsPEcantdias.PEcantdias))>
			<cfset salariopromedioLdiario = salariopromedioLdiario / rsPEcantdias.PEcantdias >
		</cfif>

       	<!--- Salario Promedio Mensual liquido = Salario Promedio Diario liquido * Cantidad de Dias para calculo de Salario Diario --->
        <cfquery name="rsParametro80" datasource="#session.DSN#">
			select coalesce(Pvalor, '0') as Pvalor 
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 80 
		</cfquery>  
		<cfif len(trim(rsParametro80.Pvalor)) and len(trim(salariopromedioLdiario)) >
			<cfset salariopromedioLmensual = salariopromedioLdiario * rsParametro80.Pvalor>
		</cfif>

		<cfset StructInsert(StructReturn,"salariobrutoP", salariopromediomensual)>  
		<cfset StructInsert(StructReturn,"salarioLiquidoPL", salariopromedioLmensual)>  
		<cfset StructInsert(StructReturn,"salariobrutoUM", bruto_ult_mes)>  
		<cfset StructInsert(StructReturn,"salarioLiquidoUM", liquido_ult_mes)> 		
		<cfreturn StructReturn>
	</cffunction>
	
<cfquery datasource="#session.DSN#">
	insert into #constancia#(	nombre, 
								identificacion,
								salariomensual, 
								salariodiario, 
							 	puesto,
								codigopuesto, 
								plaza, 
								plazadesc, 
								departamento,
								oficina ,
							 	empresa, 
								fechai, 
								salariobruto, 
								salarioliquido ,
							 	renta, 
								deducciones, 
								cargas, 
								periodo, 
								mes )
	select 	<cf_dbfunction name="concat" args="a.DEapellido1,' ',a.DEapellido2,' ', a.DEnombre" >, 
			a.DEidentificacion, 
			b.LTsalario, 
			b.LTsalario / <cf_dbfunction name="to_number" args="FactorDiasSalario"> as SalarioDiario  ,
			pt.RHPdescpuesto, 
			pt.RHPcodigo, 
			p.RHPcodigo, 
			p.RHPdescripcion, 
			d.Ddescripcion, 
			o.Odescripcion, 
			e.Edescripcion, 
			ev.EVfantig,
			coalesce((	select sum(SEsalariobruto + SEincidencias)  
						from CalendarioPagos cp, HSalarioEmpleado h 
						where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
						  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
						  and  h.RCNid = cp.CPid
						  and h.DEid = a.DEid), 0.00),   <!--- Suma de los Salarios DEvengados Recibidos en el MES de la CERTIFICACION--->
			coalesce( (	select sum(SEliquido)  
						from CalendarioPagos cp, HSalarioEmpleado h 
						where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
						  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
						  and h.RCNid = cp.CPid
						  and h.DEid = a.DEid), 0.00),    <!--- Suma de los Salarios Liquidos Recibidos en el MES de la CERTIFICACION--->
			coalesce( (	select sum(SErenta)  
						from CalendarioPagos cp, HSalarioEmpleado h 
						where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
						and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
						and  h.RCNid = cp.CPid
						and h.DEid = a.DEid), 0.00),    <!--- Suma de Renta Rebajadas durante el  MES de la CERTIFICACION--->
			coalesce((	select sum(SEdeducciones)  
						from CalendarioPagos cp, HSalarioEmpleado h 
						where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
						and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
						and  h.RCNid = cp.CPid
						and h.DEid = a.DEid), 0.00),   <!--- Suma de Deducciones Rebajadas durante el  MES de la CERTIFICACION--->
			coalesce((	select sum(SEcargasempleado)  
						from CalendarioPagos cp, HSalarioEmpleado h 
						where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
						and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
						and  h.RCNid = cp.CPid
						and h.DEid = a.DEid), 0.00),  <!--- Suma de Cargas Patronales durante el  MES de la CERTIFICACION--->
			<cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">, 
			case when #mes# = 1 then 'Enero' 
				 when #mes# = 2 then 'Febrero' 
				 when #mes# = 3 then 'Marzo' 
				 when #mes# = 4 then 'Abril' 
				 when #mes# = 5 then 'Mayo' 
				 when #mes# = 6 then 'Junio' 
				 when #mes# = 7 then 'Julio' 
				 when #mes# = 8 then 'Agosto' 
				 when #mes# = 9 then 'Setiembre' 
				 when #mes# = 10 then 'Octubre' 
				 when #mes# = 11 then 'Noviembre' 
				 else 'Diciembre'
			end
	from Empresas e
		 inner join DatosEmpleado a
			on a.Ecodigo = a.Ecodigo
		 inner join LineaTiempo b
	 	  	on b.DEid = a.DEid
		   and  b.Ecodigo = a.Ecodigo
		 inner join RHPlazas p
		    on p.RHPid = b.RHPid
		 inner join RHPuestos pt
		 	on p.RHPpuesto = pt.RHPcodigo
	  		and p.Ecodigo = pt.Ecodigo
		 inner join Oficinas o
		    on o.Ecodigo = p.Ecodigo
	  		and o.Ocodigo = p.Ocodigo
		 inner join Departamentos d
		 	on 	d.Ecodigo = p.Ecodigo
			  and d.Dcodigo = p.Dcodigo
		 inner join EVacacionesEmpleado ev
		 	on a.DEid = ev.DEid
		 inner join TiposNomina tn
		 	on b.Tcodigo=tn.Tcodigo
			and b.Ecodigo=tn.Ecodigo
	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.DEidentificacion#">
	  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsData.fecha#"> between b.LTdesde and b.LThasta
</cfquery> 



	<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="fechaL">
		<cfinvokeargument name="fecha" value="#LSdateFormat(rsdata.fecha, 'dd/mm/yyyy')#">
		<cfinvokeargument name="Ingles" value="0">	
	</cfinvoke>

	<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="fechah">
		<cfinvokeargument name="fecha" value="#LSdateFormat(date, 'dd/mm/yyyy')#">
		<cfinvokeargument name="Ingles" value="0">	
	</cfinvoke>

	<cfquery name="rsFechai" datasource="#session.DSN#">
		select fechai 
		from #constancia#
	</cfquery>
	
	<cfif len(trim(rsFechai.fechai))>
		<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="fechaingreso">
			<cfinvokeargument name="fecha" value="#LSdateFormat(rsFechai.fechai, 'dd/mm/yyyy')#">
			<cfinvokeargument name="Ingles" value="0">	
		</cfinvoke>
	</cfif>

	<cfquery name="rsNomina" datasource="#session.DSN#">
		select l.Tcodigo 
		from LineaTiempo l , DatosEmpleado d
		where <cfqueryparam cfsqltype="cf_sql_date" value="#rsData.fecha#"> between l.LTdesde and l.LThasta
			and l.DEid = d.DEid 
			and d.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.DEidentificacion#">
			and l.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif len(rtrim(rsNomina.Tcodigo)) eq 0>
			<cfset Errs=Errs&"- El Empleado seleccionado no existe laboralmente para la fecha de Solicitud ">
	<cfelse>
			<cfset nomina = rsNomina.Tcodigo >
	</cfif>

	<!--- mensaje de error en caso que existan errores--->
	<cfif len(trim(Errs))>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(Errs)#" addtoken="no">
		<cfabort>
	</cfif>

		<!--- Verifica según el ultimo Mes si el Empleado tiene o no Embargos--->
		<cfquery name="rsEmbargos" datasource="#session.DSN#">
			select case coalesce(sum(h.DCvalor),0) when 0 then 
				'libre de embargos' 
			else 
				'embargado' 
			end as embargos
			from HDeduccionesCalculo h, 
				 DatosEmpleado de, 
				 DeduccionesEmpleado d, 
				 TDeduccion t
			where  h.DEid = de.DEid
				 and de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.DEidentificacion#">
				 and h.DEid = d.DEid
				 and h.Did = d.Did
				 and <cfqueryparam cfsqltype="cf_sql_date" value="#rsData.fecha#"> between d.Dfechaini and d.Dfechafin
				 and d.TDid = t.TDid
				 and d.Ecodigo = t.Ecodigo
				 and upper(t.TDcodigo) = 'OEM'
		</cfquery>
		
		<cfset embargos = rsEmbargos.embargos >
		
		<cfinvoke  method="CalculoPromedio" >
			<cfinvokeargument name="cedula" value="#rsData.DEidentificacion#">
			<cfinvokeargument name="nomina" value="#nomina#">
			<cfinvokeargument name="fecha" 	value="#LSDateFormat(rsData.fecha)#">				
		</cfinvoke>

		<cfquery name="rsQuery" datasource="#session.DSN#">
			select 	nombre, 
					identificacion,
					salariomensual, 
					salariodiario , 
					puesto, 
					codigopuesto, 
					plaza, 
					plazadesc, 
					departamento,
					oficina,
					empresa, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#fechaingreso#"> as fechaingreso, 
					salariobruto, 
					salarioliquido ,
					renta, 
					deducciones, 
					cargas, 
					periodo, 
					mes,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#fechaL#"> as fecha, 
					'#salariobrutoP#' as salariobrutoP, <!--- de la Funcion --->
					#salarioliquidoP# as salarioliquidoP,  <!--- de la Funcion --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#fechah#"> as fechadehoy, 
					'#embargos#' as embargo, 
					'#bruto_ultimo#' as bum,  <!--- de la Funcion --->
					'#liquido_ultimo#' as liq_ult <!--- de la Funcion --->
			from #constancia#
		</cfquery>   