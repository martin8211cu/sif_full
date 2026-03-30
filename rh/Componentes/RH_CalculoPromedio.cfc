<cfcomponent>
	<cffunction name="CalculoPromedio" output="false" returntype="struct" access="public">
		<cfargument name="cedula" 	type="string" 	required="yes"> <!--- Cedula del empleado  --->
		<cfargument name="nomina" 	type="string" 	required="yes"> <!--- Tipo de Nómina --->
		<cfargument name="fecha" 	type="string" 	required="yes"> <!--- fecha apartir de la cual se desea conocer el promedio del salario --->

		<!--- Procedimiento para calculo de salario promedio de un empleado apartir de una fecha dada.  
		** Utilizado en un reporte de B.O. 
		** Hecho por: Hannia Diaz Alvarez 
		** Fecha 29 Mayo 2004 
		** Migrado por: Josue, 05/06/2007 
		---> 

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
			  from DatosEmpleado d , LineaTiempo  l
			where d.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cedula#">
			  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
			  and d.DEid = l.DEid
			  and l.LThasta = (	select max(LThasta) 
			  					from LineaTiempo 
								where LineaTiempo.DEid = l.DEid 
								  and LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
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

		<cfquery name="rsFecha1" datasource="#session.DSN#">
			select max(CPdesde) as CPdesde
			from CalendarioPagos 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.nomina#">
			  and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
		</cfquery>	
		<cfset fecha1 = rsFecha1.CPdesde >

		<cfquery name="rsFecha1" datasource="#session.DSN#">
			select max(CPhasta) as CPhasta
			from CalendarioPagos 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.nomina#">
			  and CPdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#fecha1#">
		</cfquery>	
		<cfset fecha1 = rsFecha1.CPhasta >
		<cfset fecha2 = dateadd('d', -30, fecha1) >
		<cfset fecha2 = dateadd('yyyy', -1, fecha2) >

		<cfquery datasource="#session.DSN#">
			insert #pagosempleado#( RCNid, DEid, fechadesde, fechahasta, cantidad, bruto, incidencias, salarioneto, salnetoconstancias, deducciones ) 
			select distinct a.RCNid, 
							b.DEid, 
							a.RCdesde, 
							a.RChasta, 
							0,
							SEsalariobruto, 
							0, 
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

		<cfquery datasource="#session.DSN#">
			update #pagosempleado# 
			set salnetoconstancias = 		  
							(select b.SEliquido + 
								   (	coalesce( (	select coalesce(sum(d.DCvalor),0.00)  
													from HDeduccionesCalculo d, DeduccionesEmpleado e,TDeduccion f  
													where d.DEid = b.DEid  
												  	  and d.RCNid = b.RCNid 
												  	  and d.Did = e.Did 
												  	  and e.TDid = f.TDid 
												  	  and  f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												  	  and  f.TDcodigo in ('AHA', 'ADO','ANA'))
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
		<cfquery name="rsFechaSalida" datasource="#session.DSN#">
			select LTdesde
			from LineaTiempo lt, RHTipoAccion ta 
			where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			and ta.RHTid = lt.RHTid 
			and ta.RHTcomportam = 2 
		</cfquery>
		<cfset fechasalida = rsFechaSalida.LTdesde  >
		<cfif len(trim(fechasalida))>
			<cfquery datasource="#session.DSN#">
			    delete from #pagosempleado# 
				where fechahasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#fechasalida#">
			</cfquery>
		</cfif>
		<cfquery datasource="#session.DSN#">
			update #pagosempleado# 
			set incidencias = ( select coalesce(sum(ICmontores), 0)  
							    from  HIncidenciasCalculo, CIncidentes 
							    where HIncidenciasCalculo.RCNid = #pagosempleado#.RCNid  
							      and HIncidenciasCalculo.DEid = #pagosempleado#.DEid 
							      and HIncidenciasCalculo.CIid = CIncidentes.CIid 
							      and CIafectasalprom = 1) 
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			delete from #pagosempleado# 
			where registro > <cfqueryparam cfsqltype="cf_sql_integer" value="#cantidadperiodos#">
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

        <cfset prommensual  = salariopromediomensual >
        <cfset prombisemanal  = salariopromedioLmensual  >


		<!--- SALIDA en el struct --->
		<!---
		@prommensual      money output,        -- promedio mensual 
		@prombisemanal    money output,        -- promedio bisemanal 
		@bruto_ult_mes    money output,        -- bruto del ultimo mes 
		@liquido_ult_mes  money output        -- liquido del ultimo mes 
		--->
		<cfset promedios.prommensual = prommensual >
		<cfset promedios.prombisemanal = prombisemanal >
		<cfset promedios.liquido_ult_mes = liquido_ult_mes >
		<cfset promedios.bruto_ult_mes = bruto_ult_mes >
		
		<cfreturn promedios >
		
	</cffunction>

</cfcomponent>