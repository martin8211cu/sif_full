<!---Este componente sirve para realizar los calculos necesarios para la validacion de Planilla Presupuestaria
Se desarrollara en analisis de tres situaciones                                                               
1. Horas Extra                                                                                                
2. Acciones de Personal                                                                                       
3.Nomina                                                                                                  --->

<!---*************************************************************1.Horas Extra********************************************************************--->
<cfcomponent>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<!---1.Verificar la existencia de la cuenta       
2.Realizar el calculo del monto por horas extra   
3.Verificar que existe disponible en la cuenta    
 3.1 Si existe disponible realizar la reserva --->
<cffunction name="ValidaCuenta" access="public" output="true">
	<cfargument name="CIid" 	type="numeric" 	required="yes">
	<cfargument name="fecha" 	type="date" 	required="yes">
	<cfargument name="valor"    type="numeric" 	required="yes">
	<cfargument name="DEid"    type="numeric" 	required="yes">
	<cfargument name="CAMid"    type="numeric" 	required="yes">

	<cfquery name="rsCIid" datasource="#session.dsn#">
		select CIfactor,Ccuenta,Cformato
		from CIncidentes
		where CIid=#arguments.CIid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfif len(trim(rsCIid.Cformato)) eq 0 or len(trim(rsCIid.Ccuenta)) eq 0>
		<cfset LvarRev=reversa(#arguments.CAMid#,#arguments.DEid#,#arguments.fecha#)>
		<cfthrow message="No existe una cuenta asociada al concepto de pago por horas extra">
	</cfif>
	
	<cfquery name="rsDE" datasource="#session.dsn#">
		select DEnombre #LvarCNCT#' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT# DEapellido2 as nombre
		from DatosEmpleado where DEid=#arguments.DEid#
	</cfquery>
		
	<cfset vn_posicionInicial = Find('-',rsCIid.Cformato,0)>
	<cfset Lvarvalor=vn_posicionInicial-1>
	
	<cfset vs_cuentaMayor = Mid(rsCIid.Cformato,1,Lvarvalor)><!----Separar la cuenta de mayor del CFformato---->
	
	<cfquery name="rsNiveles" datasource="#session.DSN#">
		select PCEMnivelesP
		from CPVigencia vig
		inner join PCEMascaras mas
		on mas.PCEMid = vig.PCEMid
		where vig.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_cuentaMayor#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between CPVdesde and CPVhasta
	</cfquery>
	
	<cfobject component="sif.Componentes.AplicarMascara" name="Obj_CFormato">
	
	<!---Cuenta que pertenece al concepto de pago--->
	<cfif isdefined("rsNiveles") and rsNiveles.RecordCount neq 0 and len(trim(rsNiveles.PCEMnivelesP))>
		<cfset vs_CPformato = Obj_CFormato.ExtraerNivelesP(rsCIid.Cformato,rsNiveles.PCEMnivelesP)>
	</cfif>
	
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select count(1) as cantidad from RHOtrasPartidas where Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif rsExiste.cantidad eq 0>
		<cfthrow message="No se han definido las cuentas presupuestarias para horas extra, 
		en el m&oacute;dulo de Planilla Presupuestaria>Escenarios>Otras Partidas.Proceso Cancelado!">
	</cfif>
	
	<!---Existencia de la cuenta--->
	<cfquery name="rsCuenta" datasource="#session.dsn#">
		select c.CPformato,b.RHOPid from 
			RHOtrasPartidas a
			inner join RHOPFormulacion b
			on b.RHOPid=a.RHOPid
			
			inner join RHPOtrasPartidas c
			on c.RHPOPid=a.RHPOPid
			and ltrim(rtrim(c.CPformato))=ltrim(rtrim('#vs_CPformato#'))
			
			inner join RHEscenarios e
			on a.RHEid=e.RHEid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between RHEfdesde and RHEfhasta
			--and RHEcalculado = 1
			--and RHEestado='V'
		where a.Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfif len(trim(rsCuenta.CPformato)) eq 0>
		<cfthrow message="La cuenta especificada en el concepto de pago asociado a la hora extra no corresponde a una cuenta utilizada en Planilla Presupuestaria. Proceso Cancelado!">
	</cfif>
	
	<!---Monto por hora                                
	1.Averiguar el salario base                        
	2.Averiguar el factor de dias de pago              
	3.Averiguar cuanta se gana por hora                
	       Calculo: SB/factorDias/HorasJornada         
	4.Calculo del monto por horas extra                
	        Cuanto es el factor de horas extra         
	        Cuanto es el monto correspondiente     --->
	
	<cfquery name="rsSB" datasource="#session.dsn#">
		select LTsalario from LineaTiempo where DEid=#arguments.DEid#
		and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between LTdesde and LThasta
	</cfquery>
	<cfset LvarSB=#rsSB.LTsalario#>

	<cfquery name="rsFactor" datasource="#session.dsn#">
		select FactorDiasSalario 
			from TiposNomina t
		where Ecodigo=#session.Ecodigo#
		and Tcodigo=(select Tcodigo from LineaTiempo where DEid=#arguments.DEid#
					and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between LTdesde and LThasta
					)
	</cfquery>
	<cfset LvarFactor=#rsFactor.FactorDiasSalario#>
	
	
	<cfquery name="rsJornada" datasource="#session.dsn#">
		select <cf_dbfunction name="datediff" args="RHJhoraini, RHJhorafin,HH"> as hora,
		<cf_dbfunction name="datediff" args="RHJhorainicom, RHJhorafincom,HH"> as horaC,
		RHJrebajaocio
		from RHJornadas
		where Ecodigo=#session.Ecodigo#
		and RHJid=(select RHJid from LineaTiempo where DEid=#arguments.DEid#
					and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between LTdesde and LThasta
					)
	</cfquery>
	
	<cfif rsJornada.RHJrebajaocio eq 0>
		<cfset LvarJornada=rsJornada.hora>
	<cfelse>
		<cfset LvarJornada=rsJornada.hora-rsJornada.horaC>
	</cfif>
		
	<cfset LvarCalculo=LvarSB/LvarFactor/LvarJornada>
	
	<cfset LvarMonto=rsCIid.CIfactor*LvarCalculo*arguments.valor>

	<cfquery name="validaFormulacion" datasource="#session.dsn#">
		select 
		coalesce(RHOPFgastado,0) as RHOPFgastado,
		coalesce(RHOPFdisponible,0) as RHOPFdisponible,
		coalesce(RHOPFreserva,0) as RHOPFreserva,
		coalesce(RHOPFrefuerzo,0) as RHOPFrefuerzo,
		coalesce(RHOPFmodificacion,0) as RHOPFmodificacion
		from RHOPFormulacion
		where RHOPid=#rsCuenta.RHOPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfset LvarDisponible=#validaFormulacion.RHOPFdisponible#+#validaFormulacion.RHOPFrefuerzo#+#validaFormulacion.RHOPFmodificacion#-(#validaFormulacion.RHOPFreserva#+#validaFormulacion.RHOPFgastado#)>
	<cfif LvarMonto gt LvarDisponible>			
			<cfset LvarRev=reversa(#arguments.CAMid#,#arguments.DEid#,#arguments.fecha#)>
		<cfthrow message="No existe disponible en la cuenta presupuestaria para ejecutar esta solicitud. Proceso Cancelado!">
	<cfelse>
		<cfset LvarReserva = ActualizaReserva(#rsCuenta.RHOPid#,#LvarMonto#)>
		<cfreturn #LvarMonto#>
	</cfif>
</cffunction>


<cffunction name="ActualizaReserva" access="public" output="true">
	<cfargument name="RHOPid" 	type="numeric" 	required="yes">
	<cfargument name="monto" 	type="numeric" 	required="yes">

	<cfquery name="validaFormulacion" datasource="#session.dsn#">
		select 
		coalesce(RHOPFgastado,0) as RHOPFgastado,
		coalesce(RHOPFdisponible,0) as RHOPFdisponible,
		coalesce(RHOPFreserva,0) as RHOPFreserva,
		coalesce(RHOPFrefuerzo,0) as RHOPFrefuerzo,
		coalesce(RHOPFmodificacion,0) as RHOPFmodificacion
		from RHOPFormulacion
		where RHOPid=#arguments.RHOPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfset LvarReserva=validaFormulacion.RHOPFreserva+arguments.monto>
		
	<cfquery name="rsReserva" datasource="#session.dsn#">
		update RHOPFormulacion
		set RHOPFreserva=#LvarReserva#
		where RHOPid=#arguments.RHOPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
</cffunction>

<cffunction name="reversa" access="public" output="true">
	<cfargument name="DEid" 	type="numeric" 	required="yes">
	<cfargument name="CAMid" 	type="numeric" 	required="yes">
	<cfargument name="fecha" 	type="date" 	required="yes">
<!---En caso de que esto suceda y el tipo de pago que se esta cobrando es hora extra tipo B, se tiene que reversar la reserva que se realizo para las horas extra tipo A--->
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	DEid, coalesce(RHJid,0) as RHJid, CAMfhasta,
			CAMcanthorasreb, coalesce(CAMincidrebhoras,0) as CAMincidrebhoras,
			CAMcanthorasjornada, CAMincidjornada,
			CAMcanthorasextA, CAMincidhorasextA,
			CAMcanthorasextB, CAMincidhorasextB,
			CAMmontoferiado, CAMincidferiados
	from RHCMCalculoAcumMarcas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
</cfquery>

<cfif rsDatos.CAMcanthorasextA GT 0>
	<cfquery name="rsCIid" datasource="#session.dsn#">
		select CIfactor,Ccuenta,Cformato
		from CIncidentes
		where CIid=#rsDatos.CAMincidhorasextA#
		and Ecodigo=#session.Ecodigo#
	</cfquery>

	<cfset vn_posicionInicial = Find('-',rsCIid.Cformato,0)>
	
	<cfset vs_cuentaMayor = Mid(rsCIid.Cformato,1,vn_posicionInicial-1)><!----Separar la cuenta de mayor del CFformato---->
	
	<cfquery name="rsNiveles" datasource="#session.DSN#">
		select PCEMnivelesP
		from CPVigencia vig
		inner join PCEMascaras mas
		on mas.PCEMid = vig.PCEMid
		where vig.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_cuentaMayor#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between CPVdesde and CPVhasta
	</cfquery>
	
	<cfobject component="sif.Componentes.AplicarMascara" name="Obj_CFormato">
	
	<!---Cuenta que pertenece al concepto de pago--->
	<cfif isdefined("rsNiveles") and rsNiveles.RecordCount neq 0 and len(trim(rsNiveles.PCEMnivelesP))>
		<cfset vs_CPformato = Obj_CFormato.ExtraerNivelesP(rsCIid.Cformato,rsNiveles.PCEMnivelesP)>
	</cfif>
	
	<cfquery name="rsCuenta" datasource="#session.dsn#">
		select c.CPformato,b.RHOPid from 
			RHOtrasPartidas a
			inner join RHOPFormulacion b
			on b.RHOPid=a.RHOPid
			
			inner join RHPOtrasPartidas c
			on c.RHPOPid=a.RHPOPid
			and ltrim(rtrim(c.CPformato))=ltrim(rtrim('#vs_CPformato#'))
			
			inner join RHEscenarios e
			on a.RHEid=e.RHEid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between RHEfdesde and RHEfhasta
			--and RHEcalculado = 1
			--and RHEestado='V'
		where a.Ecodigo=#session.Ecodigo#
	</cfquery>

	<cfquery name="rsSB" datasource="#session.dsn#">
		select LTsalario from LineaTiempo where DEid=#arguments.DEid#
		and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between LTdesde and LThasta
	</cfquery>
	<cfset LvarSB=#rsSB.LTsalario#>

	<cfquery name="rsFactor" datasource="#session.dsn#">
		select FactorDiasSalario 
			from TiposNomina t
		where Ecodigo=#session.Ecodigo#
		and Tcodigo=(select Tcodigo from LineaTiempo where DEid=#arguments.DEid#
					and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between LTdesde and LThasta
					)
	</cfquery>
	<cfset LvarFactor=#rsFactor.FactorDiasSalario#>
	
	
	<cfquery name="rsJornada" datasource="#session.dsn#">
		select <cf_dbfunction name="datediff" args="RHJhoraini, RHJhorafin,HH"> as hora,
		<cf_dbfunction name="datediff" args="RHJhorainicom, RHJhorafincom,HH"> as horaC,
		RHJrebajaocio
		from RHJornadas
		where Ecodigo=#session.Ecodigo#
		and RHJid=(select RHJid from LineaTiempo where DEid=#arguments.DEid#
					and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between LTdesde and LThasta
					)
	</cfquery>
	
	<cfif rsJornada.RHJrebajaocio eq 0>
		<cfset LvarJornada=rsJornada.hora>
	<cfelse>
		<cfset LvarJornada=rsJornada.hora-rsJornada.horaC>
	</cfif>
		
	<cfset LvarCalculo=LvarSB/LvarFactor/LvarJornada>
	
	<cfset LvarMonto=rsCIid.CIfactor*LvarCalculo*rsDatos.CAMcanthorasextA>

	<cfquery name="validaFormulacion" datasource="#session.dsn#">
		select 
		coalesce(RHOPFgastado,0) as RHOPFgastado,
		coalesce(RHOPFdisponible,0) as RHOPFdisponible,
		coalesce(RHOPFreserva,0) as RHOPFreserva,
		coalesce(RHOPFrefuerzo,0) as RHOPFrefuerzo,
		coalesce(RHOPFmodificacion,0) as RHOPFmodificacion
		from RHOPFormulacion
		where RHOPid=#rsCuenta.RHOPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfset LvarReserva=validaFormulacion.RHOPFreserva-LvarMonto>

	<cfquery name="rsReserva" datasource="#session.dsn#">
		update RHOPFormulacion
		set RHOPFreserva=LvarReserva
		where RHOPid=#arguments.RHOPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>	
</cfif>	
</cffunction>

<!---*************************************************************2.Acciones de Personal********************************************************************--->
<cffunction name="ReservaAccion" access="public" output="true">
	<cfargument name="RHAlinea" type="numeric" 	required="yes">
	
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select RHCPlinea,DLfvigencia,RHAporc from RHAcciones where RHAlinea=#arguments.RHAlinea#
	</cfquery>

	<cfif len(trim(rsDatos.RHCPlinea)) gt 0 >
	<!---Averiguo la tabla-categoria-puesto--->
		<cfquery name="rsCat" datasource="#session.dsn#">
			select a.RHTTid,a.RHMPPid,a.RHCid,c.RHPPid from 
			RHCategoriasPuesto a
				inner join RHMaestroPuestoP b
					inner join RHPlazaPresupuestaria c
					on b.RHMPPid=c.RHMPPid
					and c.RHPPcodigo='#form.RHPPcodigo#'
				on a.RHMPPid=b.RHMPPid
			where RHCPlinea=#rsDatos.RHCPlinea#
		</cfquery>	
	
	<cfif rsCat.recordcount gt 0>
		<!---Para realizar la reserva de acuerdo a la accion de personal se va a hacer en dos pasos
			 1. Verificacion de disponible    
			 2.Actualizacion de la reserva--->
			 
		<!---Traer cuales son los componentes que tienen la accion de personal y verificar las partidas que se le hicieron a estos--->	
		<cfquery name="rsDet" datasource="#session.dsn#">
			select CSid,RHDAmontores from RHDAcciones where RHAlinea=#arguments.RHAlinea#
		</cfquery>
		
		
		<!---1.Verifico que tengo presupuesto, si existe para todos los componentes realizo la actualizacion--->
		<cfloop query="rsDet">
		<!---Identifico las partidas presupuestarias--->
			<cfquery name="rsEsc" datasource="#session.dsn#">
				select CSid,RHCFid,e.RHEfhasta,RHCFid,e.RHEid,
						coalesce(RHCFMonto,0) as RHCFMonto,
						coalesce(RHCFgastado,0) as RHCFgastado,
						coalesce(RHCFdisponible,0) as RHCFdisponible,
						coalesce(RHCFreserva,0) as RHCFreserva,
						coalesce(RHCFrefuerzo,0) as RHCFrefuerzo,
						coalesce(RHCFmodificacion,0) as RHCFmodificacion,
						coalesce(RHCFPresupuestado,0) as RHCFPresupuestado						
						
				from RHCFormulacion b
				inner join RHFormulacion a
					inner join RHEscenarios e
					on a.RHEid=e.RHEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatos.DLfvigencia#"> between RHEfdesde and RHEfhasta
					--and RHEcalculado = 1
					--and RHEestado='V'
				on a.RHFid=b.RHFid
				where b.Ecodigo=#session.Ecodigo#
				and b.CSid=#rsDet.CSid#
				and a.RHMPPid=#rsCat.RHMPPid#
				and a.RHCid=#rsCat.RHCid#
				and a.RHTTid=#rsCat.RHTTid#
				and a.RHPPid=#rsCat.RHPPid#
			</cfquery>
			
			<cfif rsEsc.recordcount eq 0>
				<cfthrow message="No existe una partida presupuestaria espec&iacute;fica para esa categor&iacute;a-puesto">
			</cfif>	
			
			<cfset LvarDisponible=rsEsc.RHCFdisponible+rsEsc.RHCFrefuerzo+rsEsc.RHCFmodificacion-(rsEsc.RHCFreserva+rsEsc.RHCFgastado)>

			
		<!---Para poder saber si realmente tengo presupuesto debo proyectar el monto que tengo a los meses que hacen falta para el cierre presupuestario--->
		<cf_dbtemp name="Mes" returnvariable="mes" datasource="#session.DSN#">
			<cf_dbtempcol name="mes"		type="int"      mandatory="yes">
			<cf_dbtempcol name="periodo"	type="int"     mandatory="yes">
		</cf_dbtemp>
			
		<cfquery name="rsInicio" datasource="#session.DSN#">
			select min(fdesdecorte) as desde
			from RHFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
		</cfquery>
		
		<cfquery name="rsFinal" datasource="#session.DSN#">
			select max(fhastacorte) as hasta
			from RHFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
		</cfquery>
		
		<cfset inicio = rsInicio.desde >
		<cfset fin = rsFinal.hasta >
		<cfloop condition=" inicio lte fin " >
			<cfquery datasource="#session.DSN#">
				insert into #mes#(mes, periodo)
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('m', inicio)#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('yyyy', inicio)#"> )
			</cfquery>
			<cfset inicio = dateadd('m', 1, inicio) >
		</cfloop>
		<!--- TABLA TEMPORAL DE TRABAJO --->
		<cf_dbtemp name="cortes" returnvariable="cortes" datasource="#session.DSN#">
			<cf_dbtempcol name="RHFid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="RHCFid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="Ecodigo"	 type="int"      mandatory="yes"> 
			<cf_dbtempcol name="periodo"	 type="int"      mandatory="yes"> 
			<cf_dbtempcol name="mes"		 type="int"      mandatory="yes"> 
			<cf_dbtempcol name="fdesdecorte" type="datetime" mandatory="yes"> 
			<cf_dbtempcol name="fhastacorte" type="datetime" mandatory="yes"> 
			<cf_dbtempcol name="permes"		 type="int" 		mandatory="yes"> 
			<cf_dbtempcol name="CSid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="Cantidad"	 type="float"    mandatory="yes"> 
			<cf_dbtempcol name="Monto"		 type="money"    mandatory="yes">
		</cf_dbtemp>
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
		<cfquery name="consulta" datasource="#session.DSN#" >
			 insert into #cortes#( RHFid, RHCFid, Ecodigo, periodo, mes, fdesdecorte, fhastacorte, permes, CSid, Cantidad, Monto ) 
			select 	f.RHFid, 
					cf.RHCFid ,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					m.periodo, 
					m.mes, 
					f.fdesdecorte , 
					f.fhastacorte, 
					convert(int, convert(varchar, m.periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar,mes) else  convert(varchar,mes) end) as permes,
					cf.CSid,
					cf.Cantidad,
					cf.Monto
			from RHFormulacion f
			
			inner join RHCFormulacion cf
			on cf.RHFid = f.RHFid
			
			inner join #mes# m
			on convert( int, convert(varchar, m.periodo) #LvarCNCT#  ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT#  convert(varchar, m.mes) #LvarCNCT# '01')*100  
				 >=  convert(int,  convert(varchar,	( convert(datetime, rtrim(convert(varchar,datepart(yy,f.fdesdecorte))) #LvarCNCT# case when datepart(mm,f.fdesdecorte) < 10 then '0' #LvarCNCT# rtrim(convert(varchar,datepart(mm,f.fdesdecorte))) else convert(varchar,datepart(mm,f.fdesdecorte)) end #LvarCNCT# '01' )	)	, 112)  )*100
				and  convert( int,  convert(varchar, m.periodo) #LvarCNCT# ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT# convert(varchar, m.mes) #LvarCNCT# '01' )*100 
				<= convert(int,  convert(varchar, f.fhastacorte, 112))*100
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
			and CSid=#rsEsc.CSid#
			and RHCFid=#rsEsc.RHCFid#
			order by f.RHFid, CSid, periodo, mes
		</cfquery>	

		<cfquery datasource="#session.DSN#">
			update #cortes# set fdesdecorte =  convert( datetime,
													 convert(varchar, periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar, mes) else  convert(varchar, mes) end #LvarCNCT# '01')
			where permes != (select min(permes) from #cortes# a where a.RHFid = RHFid)
			  and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
		</cfquery>
			
		<cfquery datasource="#session.DSN#">
			update #cortes# 
			set fhastacorte = convert( datetime,
										convert( varchar,periodo) #LvarCNCT# 
												 case when mes < 10 then '0' #LvarCNCT# 
																		  convert(varchar,mes) 
														else  convert(varchar,mes) end #LvarCNCT# 
															  case when mes in (1,3,5,7,8,10,12) then '31' 
																   when mes = 2 then '28' 
																   else '30' end)
			where permes != (select max(permes) from #cortes# a where a.RHFid = RHFid)
			 and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
		</cfquery>

		<cfquery datasource="#session.DSN#" name="rsProy">
			select
			sum((#rsDet.RHDAmontores# * (abs(datediff(dd, f.fdesde, f.fhasta ))+1)) / 
						( abs(datediff( dd, 
										convert(varchar, f.Periodo) #LvarCNCT# convert(varchar, case when f.Mes < 10 
										then '0'#LvarCNCT# convert(varchar, f.Mes) else convert(varchar, f.Mes)  end ) #LvarCNCT# '01',  
										convert(varchar, dateadd(dd, -1, dateadd(mm, 1,  convert(varchar, f.Periodo)#LvarCNCT#convert(varchar, 
										case when f.Mes < 10 then '0'#LvarCNCT# convert(varchar, f.Mes) else convert(varchar, 
										f.Mes)  end ) #LvarCNCT# '01')) ,112) )) + 1 ) )as proyec
			from RHCFormulacion b
			
			inner join RHCortesPeriodoF f
			on b.RHCFid=f.RHCFid
			inner join RHFormulacion c
			on c.RHFid = b.RHFid
			and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
			
			where b.CSid=#rsEsc.CSid#
			and b.RHCFid=#rsEsc.RHCFid#
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset LvarProyec=rsProy.proyec>
	
			<cfif LvarProyec gt LvarDisponible>
				<cfthrow message="No se puede realizar la solicitud debido a que no existe presupuesto disponible">
			</cfif>
		</cfloop>
	
		<!---2.Actualizacion de la reserva--->
		<cfloop query="rsDet">
		<cfset LvarMonto=0>
			<cfquery name="rsEsc" datasource="#session.dsn#">
				select CSid,RHCFid,e.RHEfhasta,RHCFid,e.RHEid,
						coalesce(RHCFMonto,0) as RHCFMonto,
						coalesce(RHCFgastado,0) as RHCFgastado,
						coalesce(RHCFdisponible,0) as RHCFdisponible,
						coalesce(RHCFreserva,0) as RHCFreserva,
						coalesce(RHCFrefuerzo,0) as RHCFrefuerzo,
						coalesce(RHCFmodificacion,0) as RHCFmodificacion,
						coalesce(RHCFPresupuestado,0) as RHCFPresupuestado		
				from RHCFormulacion b
				inner join RHFormulacion a
					inner join RHEscenarios e
					on a.RHEid=e.RHEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatos.DLfvigencia#"> between RHEfdesde and RHEfhasta
					--and RHEcalculado = 1
					--and RHEestado='V'
				on a.RHFid=b.RHFid
				where b.Ecodigo=#session.Ecodigo#
				and b.CSid=#rsDet.CSid#
				and a.RHMPPid=#rsCat.RHMPPid#
				and a.RHCid=#rsCat.RHCid#
				and a.RHTTid=#rsCat.RHTTid#
				and a.RHPPid=#rsCat.RHPPid#
			</cfquery>

			<cfset LvarDisponible=rsEsc.RHCFdisponible+rsEsc.RHCFrefuerzo+rsEsc.RHCFmodificacion-(rsEsc.RHCFreserva+rsEsc.RHCFgastado)>
	
			<!---Para poder saber si realmente tengo presupuesto debo proyectar el monto que tengo a los meses que hacen falta para el cierre presupuestario--->
				<cf_dbtemp name="Mes" returnvariable="mes" datasource="#session.DSN#">
					<cf_dbtempcol name="mes"		type="int"      mandatory="yes">
					<cf_dbtempcol name="periodo"	type="int"     mandatory="yes">
				</cf_dbtemp>
					
				<cfquery name="rsInicio" datasource="#session.DSN#">
					select min(fdesdecorte) as desde
					from RHFormulacion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
				</cfquery>
				
				<cfquery name="rsFinal" datasource="#session.DSN#">
					select max(fhastacorte) as hasta
					from RHFormulacion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
				</cfquery>
				
				<cfset inicio = rsInicio.desde >
				<cfset fin = rsFinal.hasta >
				<cfloop condition=" inicio lte fin " >
					<cfquery datasource="#session.DSN#">
						insert into #mes#(mes, periodo)
						values( <cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('m', inicio)#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('yyyy', inicio)#"> )
					</cfquery>
					<cfset inicio = dateadd('m', 1, inicio) >
				</cfloop>
				<!--- TABLA TEMPORAL DE TRABAJO --->
				<cf_dbtemp name="cortes" returnvariable="cortes" datasource="#session.DSN#">
					<cf_dbtempcol name="RHFid"		 type="numeric"  mandatory="yes"> 
					<cf_dbtempcol name="RHCFid"		 type="numeric"  mandatory="yes"> 
					<cf_dbtempcol name="Ecodigo"	 type="int"      mandatory="yes"> 
					<cf_dbtempcol name="periodo"	 type="int"      mandatory="yes"> 
					<cf_dbtempcol name="mes"		 type="int"      mandatory="yes"> 
					<cf_dbtempcol name="fdesdecorte" type="datetime" mandatory="yes"> 
					<cf_dbtempcol name="fhastacorte" type="datetime" mandatory="yes"> 
					<cf_dbtempcol name="permes"		 type="int" 		mandatory="yes"> 
					<cf_dbtempcol name="CSid"		 type="numeric"  mandatory="yes"> 
					<cf_dbtempcol name="Cantidad"	 type="float"    mandatory="yes"> 
					<cf_dbtempcol name="Monto"		 type="money"    mandatory="yes">
				</cf_dbtemp>
				<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
				<cfquery name="consulta" datasource="#session.DSN#" >
					 insert into #cortes#( RHFid, RHCFid, Ecodigo, periodo, mes, fdesdecorte, fhastacorte, permes, CSid, Cantidad, Monto ) 
					select 	f.RHFid, 
							cf.RHCFid ,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							m.periodo, 
							m.mes, 
							f.fdesdecorte , 
							f.fhastacorte, 
							convert(int, convert(varchar, m.periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar,mes) else  convert(varchar,mes) end) as permes,
							cf.CSid,
							cf.Cantidad,
							cf.Monto
					from RHFormulacion f
					
					inner join RHCFormulacion cf
					on cf.RHFid = f.RHFid
					
					inner join #mes# m
					on convert( int, convert(varchar, m.periodo) #LvarCNCT#  ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT#  convert(varchar, m.mes) #LvarCNCT# '01')*100  
						 >=  convert(int,  convert(varchar,	( convert(datetime, rtrim(convert(varchar,datepart(yy,f.fdesdecorte))) #LvarCNCT# case when datepart(mm,f.fdesdecorte) < 10 then '0' #LvarCNCT# rtrim(convert(varchar,datepart(mm,f.fdesdecorte))) else convert(varchar,datepart(mm,f.fdesdecorte)) end #LvarCNCT# '01' )	)	, 112)  )*100
						and  convert( int,  convert(varchar, m.periodo) #LvarCNCT# ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT# convert(varchar, m.mes) #LvarCNCT# '01' )*100 
						<= convert(int,  convert(varchar, f.fhastacorte, 112))*100
					where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
					and CSid=#rsEsc.CSid#
					and RHCFid=#rsEsc.RHCFid#
					order by f.RHFid, CSid, periodo, mes
				</cfquery>	
		
				<cfquery datasource="#session.DSN#">
					update #cortes# set fdesdecorte =  convert( datetime,
															 convert(varchar, periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar, mes) else  convert(varchar, mes) end #LvarCNCT# '01')
					where permes != (select min(permes) from #cortes# a where a.RHFid = RHFid)
					  and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
				</cfquery>
					
				<cfquery datasource="#session.DSN#">
					update #cortes# 
					set fhastacorte = convert( datetime,
												convert( varchar,periodo) #LvarCNCT# 
														 case when mes < 10 then '0' #LvarCNCT# 
																				  convert(varchar,mes) 
																else  convert(varchar,mes) end #LvarCNCT# 
																	  case when mes in (1,3,5,7,8,10,12) then '31' 
																		   when mes = 2 then '28' 
																		   else '30' end)
					where permes != (select max(permes) from #cortes# a where a.RHFid = RHFid)
					 and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
				</cfquery>
		
				<cfquery datasource="#session.DSN#" name="rsProy">
					select
					sum((#rsDet.RHDAmontores# * (abs(datediff(dd, f.fdesde, f.fhasta ))+1)) / 
						( abs(datediff( dd, 
										convert(varchar, f.Periodo) #LvarCNCT# convert(varchar, case when f.Mes < 10 
										then '0'#LvarCNCT# convert(varchar, f.Mes) else convert(varchar, f.Mes)  end ) #LvarCNCT# '01',  
										convert(varchar, dateadd(dd, -1, dateadd(mm, 1,  convert(varchar, f.Periodo)#LvarCNCT#convert(varchar, 
										case when f.Mes < 10 then '0'#LvarCNCT# convert(varchar, f.Mes) else convert(varchar, 
										f.Mes)  end ) #LvarCNCT# '01')) ,112) )) + 1 ) )as proyec
					from RHCFormulacion b
					
					inner join RHCortesPeriodoF f
					on b.RHCFid=f.RHCFid
					inner join RHFormulacion c
					on c.RHFid = b.RHFid
					and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
					
					where b.CSid=#rsEsc.CSid#
					and b.RHCFid=#rsEsc.RHCFid#
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset LvarProyec=rsProy.proyec>
		
			<cfquery name="rsUpd" datasource="#session.dsn#">
				update RHCFormulacion set RHCFreserva=#LvarProyec#
				where RHCFid=#rsEsc.RHCFid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
	</cfloop>
	<cfelse>
		<cfthrow message="No se ha definido las plazas presupuestarias">
	</cfif>
	
	<cfelse>
		<cfthrow message="No existe la relacion entre la tabla-puesto-categoria">
	</cfif>
<!---	<cfquery name="x" datasource="#session.dsn#">
		select * from RHCFormulacion where RHCFid=#rsEsc.RHCFid#
	</cfquery>
	<cf_dump var="#x#">--->
</cffunction>

<!---*************************************************************3.Nomina**********************************************************************--->
<cffunction name="ValidaNomina" access="public" output="true" returntype="numeric">
	<cfargument name="RCNid" 	type="numeric" 	required="yes">
	
	
	<cfset Lvarerror=0><!---Si esta variable se devuelve mayor que 0 significa q existe algun error (no existe presupuesto o no hay disponible) sin embargo solo 
						se debe de encargar de enviar una alerta ya que el proceso de la nomina no se debe detener--->
						
	<cfquery name="rsFecha" datasource="#session.dsn#">
		select RCdesde from RCalculoNomina where RCNid=#arguments.RCNid#
	</cfquery>
	
	<!---Busco el salario Base de todos los empleados que se encuentran en la nomina--->
	<cfquery name="rsRCNid" datasource="#session.dsn#">
		select p.DEid,l.RHCPlinea, p.PEsalario,p.PEcantdias,t.FactorDiasSalario,l.RHCPlinea,RHTTid,RHMPPid,RHCid,z.RHPPid,
		((p.PEsalario/t.FactorDiasSalario)*p.PEcantdias) as total,
			l.LTsalario -(select coalesce(sum(DLTmonto),0) 
							from DLineaTiempo 
								where DLineaTiempo.LTid=l.LTid 
								and CIid in (select CIid 
												from ComponentesSalariales
											where Ecodigo=#session.Ecodigo# and CIid is not null
											)) as salario
		from PagosEmpleado p
			inner join LineaTiempo l
				
				inner join RHCategoriasPuesto r
				on r.RHCPlinea=l.RHCPlinea
				
				inner join TiposNomina t
				on t.Tcodigo=l.Tcodigo
				
				inner join RHPlazas z
				on z.RHPid=l.RHPid
				
				inner join DLineaTiempo d
				on l.LTid=d.LTid
				
			on p.LTid=l.LTid
			and p.DEid=l.DEid
			
		where RCNid=#arguments.RCNid#
		and l.Ecodigo=#session.Ecodigo#
		group by p.DEid,l.RHCPlinea,l.LTsalario,l.LTid, p.PEsalario,p.PEcantdias,t.FactorDiasSalario,l.RHCPlinea,RHTTid,RHMPPid,RHCid,z.RHPPid
	</cfquery>

	<cfloop query="rsRCNid">
		<cfset LvarReserva=0>
		<!---Primero se va a realizar es la verificacion del disponible del salario bases--->
		
		<cfquery name="rsSB" datasource="#session.dsn#">
			select CSid from ComponentesSalariales where CSsalariobase=1 and Ecodigo=#session.Ecodigo#
		</cfquery>
	
		<!---Busco los montos que tenga la tabla de formulacion de acuerdo a la configuracion puesto/categoria asignado al empleado--->
		<cfquery name="rsPres" datasource="#session.dsn#">
			select CSid,RHCFid,
					coalesce(RHCFMonto,0) as RHCFMonto,
					coalesce(RHCFgastado,0) as RHCFgastado,
					coalesce(RHCFdisponible,0) as RHCFdisponible,
					coalesce(RHCFreserva,0) as RHCFreserva,
					coalesce(RHCFrefuerzo,0) as RHCFrefuerzo,
					coalesce(RHCFmodificacion,0) as RHCFmodificacion
			from RHCFormulacion a
				inner join RHFormulacion b
					inner join RHEscenarios e
					on b.RHEid=e.RHEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha.RCdesde#"> between RHEfdesde and RHEfhasta
					--and RHEcalculado = 1
					--and RHEestado='V'
				on b.RHFid=a.RHFid
				and b.RHTTid=#rsRCNid.RHTTid#
				and b.RHMPPid=#rsRCNid.RHMPPid#
				and b.RHCid=#rsRCNid.RHCid#
				and b.RHPPid=#rsRCNid.RHPPid#
			where a.Ecodigo=#session.Ecodigo#
			and CSid in (#rsSB.CSid#)
		</cfquery>
		<cfdump var="#rsPres#" label="presupuesto"></br>
		
		<cfif rsPres.recordcount eq 0>
			<cfset Lvarerror=Lvarerror+1>
		<cfelse>
				
				<cfset LvarDisponible=#rsPres.RHCFdisponible#+#rsPres.RHCFreserva#+#rsPres.RHCFmodificacion#-(#rsPres.RHCFreserva#+#rsPres.RHCFgastado#)>
				
				<cfif rsRCNid.total gt LvarDisponible>
					<cfset Lvarerror=Lvarerror+1>
				</cfif>
				
				<!---<cfset LvarReserva=rsPres.RHCFreserva+rsRCNid.total>
				
				<cfquery datasource="#session.dsn#">
					update RHCFormulacion 
						set RHCFreserva=#LvarReserva#
					where RHCFid=#rsPres.RHCFid#
				</cfquery>--->
				
				<!---Busco todas las incidencias que tenga que pagar el empleado--->
				<cfquery name="rsInc" datasource="#session.dsn#">
					select CSid,sum(ICmontores) as valor from IncidenciasCalculo
					where RCNid=#arguments.RCNid#
					and CSid is not null
					and CSid in (select CSid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CIid is not null)
					and DEid=#rsRCNid.DEid#
					group by CSid
				</cfquery>
				
				<!---Verifico el disponible que tenga en las incidencias correspondientes asignadas a la categoria/puesto del empleado--->
				<cfloop query="rsInc">
					<cfset LvarReserva=0>
					
					<cfquery name="rsPres" datasource="#session.dsn#">
						select CSid,RHCFid
								coalesce(RHCFMonto,0) as RHCFMonto,
								coalesce(RHCFgastado,0) as RHCFgastado,
								coalesce(RHCFdisponible,0) as RHCFdisponible,
								coalesce(RHCFreserva,0) as RHCFreserva,
								coalesce(RHCFrefuerzo,0) as RHCFrefuerzo,
								coalesce(RHCFmodificacion,0) as RHCFmodificacion
						from RHCFormulacion a
							inner join RHFormulacion b
								inner join RHEscenarios e
								on b.RHEid=e.RHEid
								and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha.RCdesde#"> between RHEfdesde and RHEfhasta
								--and RHEcalculado = 1
								--and RHEestado='V'
							on b.RHFid=a.RHFid
							and b.RHTTid=#rsRCNid.RHTTid#
							and b.RHMPPid=#rsRCNid.RHMPPid#
							and b.RHCid=#rsRCNid.RHCid#
						where a.Ecodigo=#session.Ecodigo#
						and CSid =#rsInc.CSid#
					</cfquery>
					
					<cfif rsPres.recordcount eq 0>
						<cfset Lvarerror=Lvarerror+1>
					<cfelse>	
										
					<cfset LvarDisponible=#rsPres.RHCFdisponible#+#rsPres.RHCFreserva#+#rsPres.RHCFmodificacion#-(#rsPres.RHCFreserva#+#rsPres.RHCFgastado#)>
					
					<cfif rsInc.valor gt LvarDisponible>
						<cfset Lvarerror=Lvarerror+1>
					</cfif>
					
					<!---<cfset LvarReserva=rsPres.RHCFreserva+rsInc.valor>
					
					<cfquery datasource="#session.dsn#">
						update RHCFormulacion 
							set RHCFreserva=#LvarReserva#
						where RHCFid=#rsPres.RHCPid#
					</cfquery>--->
					</cfif>
				</cfloop>
					<cfdump var="#rsInc#" label="incidencias">
			</cfif>
	</cfloop><!---<cf_dump var="1">--->
<cfreturn #Lvarerror#>
</cffunction>

<!---/***************************************************************************************************************************************************/--->
<cffunction name="FinalizaNomina" access="public" output="true" >
	<cfargument name="ERNid" 	type="numeric" 	required="yes">
	
	<cfquery name="rsEnc" datasource="#session.dsn#">
		select RCNid from HERNomina where ERNid =#arguments.ERNid#
	</cfquery>
	
	<cfquery name="rsSB" datasource="#session.dsn#">
		select CSid from ComponentesSalariales where CIid is null and CSsalariobase=1 and Ecodigo=#session.Ecodigo#
	</cfquery>	
	
	<cfquery name="rsFecha" datasource="#session.dsn#">
		select RCdesde from HRCalculoNomina where RCNid=#rsEnc.RCNid#
	</cfquery>
		
	<cfquery name="rsRCNid" datasource="#session.dsn#">
		select p.DEid,l.RHCPlinea, p.PEsalario,p.PEcantdias,t.FactorDiasSalario,l.RHCPlinea,RHTTid,RHMPPid,RHCid,z.RHPPid,
		coalesce(((p.PEsalario/t.FactorDiasSalario)*p.PEcantdias),0) as total,
			l.LTsalario -(select coalesce(sum(DLTmonto),0) 
							from DLineaTiempo 
								where DLineaTiempo.LTid=l.LTid 
								and CIid in (select CIid 
												from ComponentesSalariales
											where Ecodigo=1 and CIid is not null
											)) as salario
		from HPagosEmpleado p
			inner join LineaTiempo l
				
				inner join RHCategoriasPuesto r
				on r.RHCPlinea=l.RHCPlinea
				
				inner join TiposNomina t
				on t.Tcodigo=l.Tcodigo
				
				inner join RHPlazas z
				on z.RHPid=l.RHPid
				
				inner join DLineaTiempo d
				on l.LTid=d.LTid
				
			on p.LTid=l.LTid
			and p.DEid=l.DEid
			
		where RCNid=#rsEnc.RCNid#
		and l.Ecodigo=#session.Ecodigo#
		group by p.DEid,l.RHCPlinea,l.LTsalario,l.LTid, p.PEsalario,p.PEcantdias,t.FactorDiasSalario,l.RHCPlinea,RHTTid,RHMPPid,RHCid,z.RHPPid
	</cfquery>

	<cfquery name="rsInc" datasource="#session.dsn#">
		select CSid from HIncidenciasCalculo h
			inner join ComponentesSalariales c
			on c.CIid=h.CIid
		where h.RCNid=#rsEnc.RCNid#
		and c.Ecodigo=#session.Ecodigo#
	</cfquery>
		
	<cfloop query="rsRCNid">

		<cfset LvarReserva=0>
		
		<cfquery name="rsSB" datasource="#session.dsn#">
			select CSid from ComponentesSalariales where CSsalariobase=1 and Ecodigo=#session.Ecodigo#
		</cfquery>
	
		<!---Busco los montos que tenga la tabla de formulacion de acuerdo a la configuracion puesto/categoria asignado al empleado
		     en este caso solamente busco los montos del salario base                                                          --->
		<cfquery name="rsPres" datasource="#session.dsn#">
			select CSid,RHCFid,
					coalesce(RHCFMonto,0) as RHCFMonto,
					coalesce(RHCFgastado,0) as RHCFgastado,
					coalesce(RHCFdisponible,0) as RHCFdisponible,
					coalesce(RHCFreserva,0) as RHCFreserva,
					coalesce(RHCFrefuerzo,0) as RHCFrefuerzo,
					coalesce(RHCFmodificacion,0) as RHCFmodificacion
			from RHCFormulacion a
				inner join RHFormulacion b
					inner join RHEscenarios e
					on b.RHEid=e.RHEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha.RCdesde#"> between RHEfdesde and RHEfhasta
					--and RHEcalculado = 1
					--and RHEestado='V'
				on b.RHFid=a.RHFid
				and b.RHTTid=#rsRCNid.RHTTid#
				and b.RHMPPid=#rsRCNid.RHMPPid#
				and b.RHCid=#rsRCNid.RHCid#
				and b.RHPPid=#rsRCNid.RHPPid#
			where a.Ecodigo=#session.Ecodigo#
			and CSid in (#rsSB.CSid#)
		</cfquery>
	
		<cfset LvarDisponible=#rsPres.RHCFdisponible#+#rsPres.RHCFreserva#+#rsPres.RHCFmodificacion#-(#rsPres.RHCFreserva#+#rsPres.RHCFgastado#)>
			<cfset LvarGastado=#rsPres.RHCFgastado#+#rsRCNid.total#>
			<cfset LvarReserva=#rsPres.RHCFreserva#-#rsRCNid.total#>
		<!---Hago la resta a la reserva y le suom al gasto*****--->
			<cfquery name="rsUpdate" datasource="#session.dsn#">
				update RHCFormulacion set RHCFgastado=coalesce(#LvarGastado#,0),
											RHCFreserva= coalesce(#LvarReserva#,0)
				where RHCFid=#rsPres.RHCFid#
			</cfquery>
		
		<cfloop query="rsInc">
			<!---Agarro las incidencias que tiene presupuestada cada empleado--->
			<cfquery name="rsPres1" datasource="minisif">
				select CSid,RHCFid,
						coalesce(RHCFMonto,0) as RHCFMonto,
						coalesce(RHCFgastado,0) as RHCFgastado,
						coalesce(RHCFdisponible,0) as RHCFdisponible,
						coalesce(RHCFreserva,0) as RHCFreserva,
						coalesce(RHCFrefuerzo,0) as RHCFrefuerzo,
						coalesce(RHCFmodificacion,0) as RHCFmodificacion
				from RHCFormulacion a
					inner join RHFormulacion b
						inner join RHEscenarios e
						on b.RHEid=e.RHEid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha.RCdesde#"> between RHEfdesde and RHEfhasta
						--and RHEcalculado = 1
						--and RHEestado='V'
					on b.RHFid=a.RHFid
					and b.RHTTid=#rsRCNid.RHTTid#
					and b.RHMPPid=#rsRCNid.RHMPPid#
					and b.RHCid=#rsRCNid.RHCid#
					and b.RHPPid=#rsRCNid.RHPPid#
				where a.Ecodigo=#session.Ecodigo#
				and CSid in (#rsInc.CSid#)
			</cfquery>
			<cfif rsPres1.recordcount gt 0>
				<cfset LvarDisponible=#rsPres1.RHCFdisponible#+#rsPres1.RHCFreserva#+#rsPres1.RHCFmodificacion#-(#rsPres1.RHCFreserva#+#rsPres1.RHCFgastado#)>
				<!---Que incidencias tengo que pagar--->
				<cfquery name="rsInc1" datasource="#session.dsn#">
					select coalesce(ICvalor,0) as ICvalor from HIncidenciasCalculo h
					where h.RCNid=#rsEnc.RCNid#
					and h.DEid=#rsRCNid.DEid#
					and CIid in(select CIid from ComponentesSalariales where CSid=#rsInc.CSid#)
				</cfquery>
				<cfif isdefined ('rsInc1') and rsInc1.recordcount gt 0 and len(trim(rsInc1.ICvalor)) gt 0>
					<cfset LvarGastado=#rsPres1.RHCFgastado#+#rsInc1.ICvalor#>
					<cfset LvarReserva=#rsPres1.RHCFreserva#-#rsInc1.ICvalor#>
					<cfquery name="rsUpdate" datasource="#session.dsn#">
						update RHCFormulacion set RHCFgastado=coalesce(#LvarGastado#,0),
													RHCFreserva= coalesce(#LvarReserva#,0)
						where RHCFid=#rsPres1.RHCFid#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cfloop>
</cffunction>
<!---*****************************************************Articulo 40**********************************************************************--->
<cffunction name="Art40" access="public" output="true" returntype="numeric">
	<cfargument name="RHAlinea" 	type="numeric" 	required="yes">
	
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select RHCPlinea,RHCPlineaP,DLfvigencia,RHAporc from RHAcciones where RHAlinea=#arguments.RHAlinea#
	</cfquery>
	
	<!---Salario Base de la categoria actual--->
	<cfquery name="rsMonto" datasource="#session.dsn#">
		select coalesce(RHMCmonto,0) as RHMCmonto from RHCategoriasPuesto p
		 inner join RHVigenciasTabla t
		 on t.RHTTid=p.RHTTid
		 inner join RHMontosCategoria m
		 on m.RHCid=p.RHCid
	 where p.RHCPlinea=(select min(RHCPlinea) from LineaTiempo 
						where DEid=(select DEid from RHAcciones where RHAlinea=#arguments.RHAlinea#))
	 and m.RHVTid=( 
					 select RHVTid from RHVigenciasTabla 
					 where 
					 (select DLfvigencia from RHAcciones where RHAlinea = #arguments.RHAlinea#) between RHVTfecharige and RHVTfechahasta
					 and RHTTid = (select RHTTid from RHCategoriasPuesto where RHCPlinea=(select min(RHCPlinea) from LineaTiempo 
									where DEid=(select DEid from RHAcciones where RHAlinea=#arguments.RHAlinea#)))
					 )
								
	</cfquery>

	<!---Salario Base de la categoria propuesta--->
	<cfquery name="rsMontoP" datasource="#session.dsn#">
		select coalesce(RHMCmonto,0) as RHMCmonto 
		from RHCategoriasPuesto p 
		inner join RHVigenciasTabla t 
		on t.RHTTid=p.RHTTid 
		inner join RHMontosCategoria m 
		on m.RHCid=p.RHCid 
		where p.RHCPlinea=(select RHCPlineaP from RHAcciones where RHAlinea=#arguments.RHAlinea#) 
		and m.RHVTid=( select RHVTid from RHVigenciasTabla 
								where (select DLfvigencia from RHAcciones where RHAlinea = #arguments.RHAlinea#) between RHVTfecharige and RHVTfechahasta 
							   and RHTTid = (select RHTTid from RHCategoriasPuesto where RHCPlinea=(select RHCPlineaP from RHAcciones where RHAlinea=#arguments.RHAlinea#)) ) 			
	</cfquery>

	<cfset LvarMonto=((rsMontoP.RHMCmonto-rsMonto.RHMCmonto)/2)>

	<cfif len(trim(rsDatos.RHCPlinea)) gt 0 >
	<!---Averiguo la tabla-categoria-puesto--->
		<cfquery name="rsCat" datasource="#session.dsn#">
			select a.RHTTid,a.RHMPPid,a.RHCid,c.RHPPid from 
			RHCategoriasPuesto a
				inner join RHMaestroPuestoP b
					inner join RHPlazaPresupuestaria c
					on b.RHMPPid=c.RHMPPid
					and c.RHPPcodigo='#form.RHPPcodigo#'
				on a.RHMPPid=b.RHMPPid
			where RHCPlinea=#rsDatos.RHCPlinea#
		</cfquery>	

	<cfif rsCat.recordcount gt 0>
		<!---Para realizar la reserva de acuerdo a la accion de personal se va a hacer en dos pasos
			 1. Verificacion de disponible    
			 2.Actualizacion de la reserva--->
			 
		<!---Traer cuales son los componentes que tienen la accion de personal y verificar las partidas que se le hicieron a estos--->	
		<cfquery name="rsDet" datasource="#session.dsn#">
			select CSid from RHDAcciones where RHAlinea=#arguments.RHAlinea#
		</cfquery>

			
		<!---1.Verifico que tengo presupuesto, si existe para todos los componentes realizo la actualizacion--->
		<cfloop query="rsDet">
		<!---Identifico las partidas presupuestarias--->
			<cfquery name="rsEsc" datasource="#session.dsn#">
				select CSid,RHCFid,e.RHEfhasta,RHCFid,e.RHEid,
						coalesce(RHCFMonto,0) as RHCFMonto,
						coalesce(RHCFgastado,0) as RHCFgastado,
						coalesce(RHCFdisponible,0) as RHCFdisponible,
						coalesce(RHCFreserva,0) as RHCFreserva,
						coalesce(RHCFrefuerzo,0) as RHCFrefuerzo,
						coalesce(RHCFmodificacion,0) as RHCFmodificacion,
						coalesce(RHCFPresupuestado,0) as RHCFPresupuestado						
						
				from RHCFormulacion b
				inner join RHFormulacion a
					inner join RHEscenarios e
					on a.RHEid=e.RHEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatos.DLfvigencia#"> between RHEfdesde and RHEfhasta
					--and RHEcalculado = 1
					--and RHEestado='V'
				on a.RHFid=b.RHFid
				where b.Ecodigo=#session.Ecodigo#
				and b.CSid=#rsDet.CSid#
				and a.RHMPPid=#rsCat.RHMPPid#
				and a.RHCid=#rsCat.RHCid#
				and a.RHTTid=#rsCat.RHTTid#
				and a.RHPPid=#rsCat.RHPPid#
			</cfquery>
					
			<cfif rsEsc.recordcount eq 0>
				<cfthrow message="No existe una partida presupuestaria espec&iacute;fica para esa categor&iacute;a-puesto">
			</cfif>	
			
			<cfset LvarDisponible=rsEsc.RHCFdisponible+rsEsc.RHCFrefuerzo+rsEsc.RHCFmodificacion-(rsEsc.RHCFreserva+rsEsc.RHCFgastado)>
			
		<!---Para poder saber si realmente tengo presupuesto debo proyectar el monto que tengo a los meses que hacen falta para el cierre presupuestario--->
		<cf_dbtemp name="Mes" returnvariable="mes" datasource="#session.DSN#">
			<cf_dbtempcol name="mes"		type="int"      mandatory="yes">
			<cf_dbtempcol name="periodo"	type="int"     mandatory="yes">
		</cf_dbtemp>
			
		<cfquery name="rsInicio" datasource="#session.DSN#">
			select min(fdesdecorte) as desde
			from RHFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
		</cfquery>
		
		<cfquery name="rsFinal" datasource="#session.DSN#">
			select max(fhastacorte) as hasta
			from RHFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
		</cfquery>
		
		<cfset inicio = rsInicio.desde >
		<cfset fin = rsFinal.hasta >
		<cfloop condition=" inicio lte fin " >
			<cfquery datasource="#session.DSN#">
				insert into #mes#(mes, periodo)
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('m', inicio)#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('yyyy', inicio)#"> )
			</cfquery>
			<cfset inicio = dateadd('m', 1, inicio) >
		</cfloop>
		<!--- TABLA TEMPORAL DE TRABAJO --->
		<cf_dbtemp name="cortes" returnvariable="cortes" datasource="#session.DSN#">
			<cf_dbtempcol name="RHFid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="RHCFid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="Ecodigo"	 type="int"      mandatory="yes"> 
			<cf_dbtempcol name="periodo"	 type="int"      mandatory="yes"> 
			<cf_dbtempcol name="mes"		 type="int"      mandatory="yes"> 
			<cf_dbtempcol name="fdesdecorte" type="datetime" mandatory="yes"> 
			<cf_dbtempcol name="fhastacorte" type="datetime" mandatory="yes"> 
			<cf_dbtempcol name="permes"		 type="int" 		mandatory="yes"> 
			<cf_dbtempcol name="CSid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="Cantidad"	 type="float"    mandatory="yes"> 
			<cf_dbtempcol name="Monto"		 type="money"    mandatory="yes">
		</cf_dbtemp>
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
		<cfquery name="consulta" datasource="#session.DSN#" >
			 insert into #cortes#( RHFid, RHCFid, Ecodigo, periodo, mes, fdesdecorte, fhastacorte, permes, CSid, Cantidad, Monto ) 
			select 	f.RHFid, 
					cf.RHCFid ,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					m.periodo, 
					m.mes, 
					f.fdesdecorte , 
					f.fhastacorte, 
					convert(int, convert(varchar, m.periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar,mes) else  convert(varchar,mes) end) as permes,
					cf.CSid,
					cf.Cantidad,
					cf.Monto
			from RHFormulacion f
			
			inner join RHCFormulacion cf
			on cf.RHFid = f.RHFid
			
			inner join #mes# m
			on convert( int, convert(varchar, m.periodo) #LvarCNCT#  ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT#  convert(varchar, m.mes) #LvarCNCT# '01')*100  
				 >=  convert(int,  convert(varchar,	( convert(datetime, rtrim(convert(varchar,datepart(yy,f.fdesdecorte))) #LvarCNCT# case when datepart(mm,f.fdesdecorte) < 10 then '0' #LvarCNCT# rtrim(convert(varchar,datepart(mm,f.fdesdecorte))) else convert(varchar,datepart(mm,f.fdesdecorte)) end #LvarCNCT# '01' )	)	, 112)  )*100
				and  convert( int,  convert(varchar, m.periodo) #LvarCNCT# ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT# convert(varchar, m.mes) #LvarCNCT# '01' )*100 
				<= convert(int,  convert(varchar, f.fhastacorte, 112))*100
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
			and CSid=#rsEsc.CSid#
			and RHCFid=#rsEsc.RHCFid#
			order by f.RHFid, CSid, periodo, mes
		</cfquery>	
	
		<cfquery datasource="#session.DSN#">
			update #cortes# set fdesdecorte =  convert( datetime,
													 convert(varchar, periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar, mes) else  convert(varchar, mes) end #LvarCNCT# '01')
			where permes != (select min(permes) from #cortes# a where a.RHFid = RHFid)
			  and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
		</cfquery>
			
		<cfquery datasource="#session.DSN#">
			update #cortes# 
			set fhastacorte = convert( datetime,
										convert( varchar,periodo) #LvarCNCT# 
												 case when mes < 10 then '0' #LvarCNCT# 
																		  convert(varchar,mes) 
														else  convert(varchar,mes) end #LvarCNCT# 
															  case when mes in (1,3,5,7,8,10,12) then '31' 
																   when mes = 2 then '28' 
																   else '30' end)
			where permes != (select max(permes) from #cortes# a where a.RHFid = RHFid)
			 and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
		</cfquery>

		<cfquery datasource="#session.DSN#" name="rsProy">
			select
			sum((#LvarMonto# * (abs(datediff(dd, f.fdesde, f.fhasta ))+1)) / 
						( abs(datediff( dd, 
										convert(varchar, f.Periodo) #LvarCNCT# convert(varchar, case when f.Mes < 10 
										then '0'#LvarCNCT# convert(varchar, f.Mes) else convert(varchar, f.Mes)  end ) #LvarCNCT# '01',  
										convert(varchar, dateadd(dd, -1, dateadd(mm, 1,  convert(varchar, f.Periodo)#LvarCNCT#convert(varchar, 
										case when f.Mes < 10 then '0'#LvarCNCT# convert(varchar, f.Mes) else convert(varchar, 
										f.Mes)  end ) #LvarCNCT# '01')) ,112) )) + 1 ) )as proyec
			from RHCFormulacion b
			
			inner join RHCortesPeriodoF f
			on b.RHCFid=f.RHCFid
			inner join RHFormulacion c
			on c.RHFid = b.RHFid
			and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
			
			where b.CSid=#rsEsc.CSid#
			and b.RHCFid=#rsEsc.RHCFid#
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset LvarProyec=rsProy.proyec>
			<cfif LvarProyec gt LvarDisponible>
				<cfthrow message="No se puede realizar la solicitud debido a que no existe presupuesto disponible">
			</cfif>
		</cfloop>
		
		<!---2.Actualizacion de la reserva--->
		<cfloop query="rsDet">
		<cfset LvarMonto=0>
			<cfquery name="rsEsc" datasource="#session.dsn#">
				select CSid,RHCFid,e.RHEfhasta,RHCFid,e.RHEid,
						coalesce(RHCFMonto,0) as RHCFMonto,
						coalesce(RHCFgastado,0) as RHCFgastado,
						coalesce(RHCFdisponible,0) as RHCFdisponible,
						coalesce(RHCFreserva,0) as RHCFreserva,
						coalesce(RHCFrefuerzo,0) as RHCFrefuerzo,
						coalesce(RHCFmodificacion,0) as RHCFmodificacion,
						coalesce(RHCFPresupuestado,0) as RHCFPresupuestado		
				from RHCFormulacion b
				inner join RHFormulacion a
					inner join RHEscenarios e
					on a.RHEid=e.RHEid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatos.DLfvigencia#"> between RHEfdesde and RHEfhasta
					--and RHEcalculado = 1
					--and RHEestado='V'
				on a.RHFid=b.RHFid
				where b.Ecodigo=#session.Ecodigo#
				and b.CSid=#rsDet.CSid#
				and a.RHMPPid=#rsCat.RHMPPid#
				and a.RHCid=#rsCat.RHCid#
				and a.RHTTid=#rsCat.RHTTid#
				and a.RHPPid=#rsCat.RHPPid#
			</cfquery>

			<cfset LvarDisponible=rsEsc.RHCFdisponible+rsEsc.RHCFrefuerzo+rsEsc.RHCFmodificacion-(rsEsc.RHCFreserva+rsEsc.RHCFgastado)>
	
			<!---Para poder saber si realmente tengo presupuesto debo proyectar el monto que tengo a los meses que hacen falta para el cierre presupuestario--->
				<cf_dbtemp name="Mes" returnvariable="mes" datasource="#session.DSN#">
					<cf_dbtempcol name="mes"		type="int"      mandatory="yes">
					<cf_dbtempcol name="periodo"	type="int"     mandatory="yes">
				</cf_dbtemp>
					
				<cfquery name="rsInicio" datasource="#session.DSN#">
					select min(fdesdecorte) as desde
					from RHFormulacion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
				</cfquery>
				
				<cfquery name="rsFinal" datasource="#session.DSN#">
					select max(fhastacorte) as hasta
					from RHFormulacion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
				</cfquery>
				
				<cfset inicio = rsInicio.desde >
				<cfset fin = rsFinal.hasta >
				<cfloop condition=" inicio lte fin " >
					<cfquery datasource="#session.DSN#">
						insert into #mes#(mes, periodo)
						values( <cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('m', inicio)#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('yyyy', inicio)#"> )
					</cfquery>
					<cfset inicio = dateadd('m', 1, inicio) >
				</cfloop>
				<!--- TABLA TEMPORAL DE TRABAJO --->
				<cf_dbtemp name="cortes" returnvariable="cortes" datasource="#session.DSN#">
					<cf_dbtempcol name="RHFid"		 type="numeric"  mandatory="yes"> 
					<cf_dbtempcol name="RHCFid"		 type="numeric"  mandatory="yes"> 
					<cf_dbtempcol name="Ecodigo"	 type="int"      mandatory="yes"> 
					<cf_dbtempcol name="periodo"	 type="int"      mandatory="yes"> 
					<cf_dbtempcol name="mes"		 type="int"      mandatory="yes"> 
					<cf_dbtempcol name="fdesdecorte" type="datetime" mandatory="yes"> 
					<cf_dbtempcol name="fhastacorte" type="datetime" mandatory="yes"> 
					<cf_dbtempcol name="permes"		 type="int" 		mandatory="yes"> 
					<cf_dbtempcol name="CSid"		 type="numeric"  mandatory="yes"> 
					<cf_dbtempcol name="Cantidad"	 type="float"    mandatory="yes"> 
					<cf_dbtempcol name="Monto"		 type="money"    mandatory="yes">
				</cf_dbtemp>
				<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
				<cfquery name="consulta" datasource="#session.DSN#" >
					 insert into #cortes#( RHFid, RHCFid, Ecodigo, periodo, mes, fdesdecorte, fhastacorte, permes, CSid, Cantidad, Monto ) 
					select 	f.RHFid, 
							cf.RHCFid ,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							m.periodo, 
							m.mes, 
							f.fdesdecorte , 
							f.fhastacorte, 
							convert(int, convert(varchar, m.periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar,mes) else  convert(varchar,mes) end) as permes,
							cf.CSid,
							cf.Cantidad,
							cf.Monto
					from RHFormulacion f
					
					inner join RHCFormulacion cf
					on cf.RHFid = f.RHFid
					
					inner join #mes# m
					on convert( int, convert(varchar, m.periodo) #LvarCNCT#  ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT#  convert(varchar, m.mes) #LvarCNCT# '01')*100  
						 >=  convert(int,  convert(varchar,	( convert(datetime, rtrim(convert(varchar,datepart(yy,f.fdesdecorte))) #LvarCNCT# case when datepart(mm,f.fdesdecorte) < 10 then '0' #LvarCNCT# rtrim(convert(varchar,datepart(mm,f.fdesdecorte))) else convert(varchar,datepart(mm,f.fdesdecorte)) end #LvarCNCT# '01' )	)	, 112)  )*100
						and  convert( int,  convert(varchar, m.periodo) #LvarCNCT# ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT# convert(varchar, m.mes) #LvarCNCT# '01' )*100 
						<= convert(int,  convert(varchar, f.fhastacorte, 112))*100
					where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
					and CSid=#rsEsc.CSid#
					and RHCFid=#rsEsc.RHCFid#
					order by f.RHFid, CSid, periodo, mes
				</cfquery>	
		
				<cfquery datasource="#session.DSN#">
					update #cortes# set fdesdecorte =  convert( datetime,
															 convert(varchar, periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar, mes) else  convert(varchar, mes) end #LvarCNCT# '01')
					where permes != (select min(permes) from #cortes# a where a.RHFid = RHFid)
					  and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
				</cfquery>
					
				<cfquery datasource="#session.DSN#">
					update #cortes# 
					set fhastacorte = convert( datetime,
												convert( varchar,periodo) #LvarCNCT# 
														 case when mes < 10 then '0' #LvarCNCT# 
																				  convert(varchar,mes) 
																else  convert(varchar,mes) end #LvarCNCT# 
																	  case when mes in (1,3,5,7,8,10,12) then '31' 
																		   when mes = 2 then '28' 
																		   else '30' end)
					where permes != (select max(permes) from #cortes# a where a.RHFid = RHFid)
					 and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
				</cfquery>
		
				<cfquery datasource="#session.DSN#" name="rsProy">
					select
					sum((#LvarMonto#* (abs(datediff(dd, f.fdesde, f.fhasta ))+1)) / 
						( abs(datediff( dd, 
										convert(varchar, f.Periodo) #LvarCNCT# convert(varchar, case when f.Mes < 10 
										then '0'#LvarCNCT# convert(varchar, f.Mes) else convert(varchar, f.Mes)  end ) #LvarCNCT# '01',  
										convert(varchar, dateadd(dd, -1, dateadd(mm, 1,  convert(varchar, f.Periodo)#LvarCNCT#convert(varchar, 
										case when f.Mes < 10 then '0'#LvarCNCT# convert(varchar, f.Mes) else convert(varchar, 
										f.Mes)  end ) #LvarCNCT# '01')) ,112) )) + 1 ) )as proyec
					from RHCFormulacion b
					
					inner join RHCortesPeriodoF f
					on b.RHCFid=f.RHCFid
					inner join RHFormulacion c
					on c.RHFid = b.RHFid
					and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsc.RHEid#">
					
					where b.CSid=#rsEsc.CSid#
					and b.RHCFid=#rsEsc.RHCFid#
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset LvarProyec=rsProy.proyec>
		
			<cfquery name="rsUpd" datasource="#session.dsn#">
				update RHCFormulacion set RHCFreserva=#LvarProyec#
				where RHCFid=#rsEsc.RHCFid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
	</cfloop>
	<cfelse>
		<cfthrow message="No se ha definido las plazas presupuestarias">
	</cfif>
	
	<cfelse>
		<cfthrow message="No existe la relacion entre la tabla-puesto-categoria">
	</cfif>
</cffunction>
</cfcomponent>






































