
<cf_dbtemp name="ERRORES_TEMP1" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 	type="integer" 		mandatory="yes">
	<cf_dbtempcol name="Cedula" 	type="varchar(60)" 	mandatory="no">
</cf_dbtemp>
<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO VENGA VACIO --->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select 1
	from #table_name#
</cfquery>

<cfif isdefined("rsCheck1") and  rsCheck1.recordcount EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)
		values('El archivo de importaci&oacute;n no tiene l&iacute;neas',1,null)
	</cfquery>
<cfelse>

	
	<!--- VALIDA EMPLEADOS --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)
		select <cf_dbfunction name="concat" args="'El empleado con cedula: ''',x.DEidentificacion,''' no existe en el catalogo de empleados'">,1,x.DEidentificacion
		from #table_name# x
		where  ltrim(rtrim(x.DEidentificacion)) not in (
			select ltrim(rtrim(b.DEidentificacion)) 
			from DatosEmpleado b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>
	<!--- VALIDA EMPLEADOS ACTIVOS EN LINEA TIEMPO--->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)
		select <cf_dbfunction name="concat" args="'El empleado: ',a.DEnombre,'  ',a.DEapellido1,' ',a.DEapellido2,' con cedula: ',x.DEidentificacion,'  no es un Funcionario Activo'">,1,x.DEidentificacion
		from #table_name# x
			inner join DatosEmpleado a
				on rtrim(ltrim(x.DEidentificacion))=rtrim(ltrim(a.DEidentificacion))
				and a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">				
		where not exists (	Select (1) 
						  	from LineaTiempo  b
							Where a.DEid=b.DEid
							and a.Ecodigo=b.Ecodigo 
							and <cf_dbfunction name="to_date"  args="x.ACCTfechaInicio" YMD="true"> between  LTdesde and LThasta)
	</cfquery>	
	
	<!--- VALIDA EMPLEADOS ACTIVOS EN LA ASOCIACION--->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)
		select <cf_dbfunction name="concat" args="'El empleado: ',a.DEnombre,'  ',a.DEapellido1,' ',a.DEapellido2,' con cedula: ',x.DEidentificacion,'  no es miembro activo de la asociacion'">,1,x.DEidentificacion
		from #table_name# x
			inner join DatosEmpleado a
				on rtrim(ltrim(x.DEidentificacion))=rtrim(ltrim(a.DEidentificacion))
			inner join ACAsociados b
				on ACAestado=0
				and a.DEid=b.DEid				
		where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	</cfquery>
	
	<!---VALIDA QUE EL ARCHIVO A IMPORTAR NO TENGA EMPLEADOS DUPLICADOS PARA UN CREDITO UNICO--->
	<cfquery name="rsCheck2" datasource="#Session.Dsn#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)  
		select <cf_dbfunction name="concat" args="'El archivo de importaci&oacute;n tiene duplicados créditos únicos: ',a.ACCTdescripcion,' codigo:',a.ACCTcodigo,' para el empleado:  ',b.DEnombre,'  ',b.DEapellido1,' ',b.DEapellido2,' con cedula: ',x.DEidentificacion,' '">,2,x.DEidentificacion
			from #table_name# x
			left join DatosEmpleado b
				on rtrim(ltrim(x.DEidentificacion))=rtrim(ltrim(b.DEidentificacion))
				and b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
			inner join ACCreditosTipo a 
				on a.ACCTcodigo=x.ACCTcodigo
				and a.ACCTunico=1
			where x.DEidentificacion in
				(select ltrim(rtrim(y.DEidentificacion))
				from #table_name# y
				group by y.DEidentificacion
				having count(*) > 1) 
			and x.ACCTcodigo in
				(select ltrim(rtrim(y.ACCTcodigo))
				from #table_name# y
				group by y.ACCTcodigo
				having count(*) > 1) 	
	</cfquery>
	
	<!--- VALIDA EL TIPO DE CREDITO --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)
		select <cf_dbfunction name="concat" args="'El codigo: ''',x.ACCTcodigo,''' no existe en el catalogo de tipos de credito'">,2,x.DEidentificacion
		from #table_name# x
		where  ltrim(rtrim(x.ACCTcodigo)) not in (
			select ltrim(rtrim(b.ACCTcodigo)) 
			from ACCreditosTipo b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>
	
	<!--- VALIDA SI NO MODIFICABLE DATOS EN CERO --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)
		select 	<cf_dbfunction name="concat" args="'La Operacion de Credito con codigo:''',x.ACCTcodigo,''' ',a.ACCTdescripcion,' no permite modificar el campo plazo o tasa /mora. Solucion: modifique el catalogo de tipos de credito o indique en el registro a importar valores cero en dicha informacion'">,2,x.DEidentificacion
		from #table_name# x
		inner join 	ACCreditosTipo a
			on a.ACCTcodigo=x.ACCTcodigo
			and (		x.ACCTplazo 	<> case a.ACCTmodificable  when 0 then 0 end 
					or 	x.ACCTtasa 		<> case a.ACCTmodificable  when 0 then 0 end 
					or	x.ACCTtasaMora 	<> case a.ACCTmodificable  when 0 then 0 end
				)
		where  a.Ecodigo = #session.Ecodigo#
	</cfquery>

	
	<!---VALIDA QUE EL ARCHIVO A IMPORTAR NO TENGA UN MISMO EMPLEADO,CREDITO Y FECHA DE INICIO--->
	<cf_dbfunction name="date_format"	args="x.ACCTfechaInicio,DD/MM/YYYY" returnvariable="LvarFechaInicio2" >
	<cf_dbfunction name="OP_concat" returnvariable = "_Cat">
	<cfquery name="rsCheck2" datasource="#Session.Dsn#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)  
		select 	'El archivo de importación tiene créditos duplicados: ' #_Cat# x.ACCTcodigo #_Cat# ' ' #_Cat# a.ACCTdescripcion #_Cat# ' para un mismo empleado ' #_Cat# b.DEnombre #_Cat# ' ' #_Cat# b.DEapellido1 #_Cat# ' con cedula: ' #_Cat# x.DEidentificacion #_Cat# ' y misma fecha de inicio: ' #_Cat# #LvarFechaInicio2#,2,x.DEidentificacion
			from #table_name# x
			left join DatosEmpleado b
				on rtrim(ltrim(x.DEidentificacion))=rtrim(ltrim(b.DEidentificacion))
				and b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
			left join ACCreditosTipo a 
				on a.ACCTcodigo=x.ACCTcodigo
			where x.DEidentificacion in
				(select ltrim(rtrim(y.DEidentificacion))
				from #table_name# y
				group by y.DEidentificacion
				having count(1) > 1) 
			and x.ACCTcodigo in
				(select ltrim(rtrim(y.ACCTcodigo))
				from #table_name# y
				group by y.ACCTcodigo
				having count(1) > 1) 
			and x.ACCTfechaInicio in
				(select ltrim(rtrim(y.ACCTfechaInicio))
				from #table_name# y
				group by y.ACCTfechaInicio
				having count(1) > 1) 		
	</cfquery>	
	
	<!--- VALIDA QUE EL MONTO SEA MAYOR QUE CERO --->
	<cfquery name="rsCheck3" datasource="#Session.Dsn#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)  
		select <cf_dbfunction name="concat" args="'El archivo de importaci&oacute;n tiene montos menores o igual a cero para el credito: ',a.ACCTdescripcion,' codigo:',a.ACCTcodigo,' y empleado:  ',b.DEnombre,'  ',b.DEapellido1,' ',b.DEapellido2,' con cedula: ',x.DEidentificacion,' '">,7,x.DEidentificacion
			from #table_name# x
			left join DatosEmpleado b
				on rtrim(ltrim(x.DEidentificacion))=rtrim(ltrim(b.DEidentificacion))
				and b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
			left join ACCreditosTipo a 
				on a.ACCTcodigo=x.ACCTcodigo
			where ACCTcapital <= 0 
	</cfquery>
	

	<cfquery name="rsCreditos" datasource="#session.dsn#">
		select 
			x.DEidentificacion,
			x.ACCTcodigo,
			case a.ACCTmodificable
				when 0 then a.ACCTplazo 
				when 1 then x.ACCTplazo
				end as ACCTplazo,
			case a.ACCTmodificable
				when 0 then a.ACCTtasa
				when 1 then x.ACCTtasa
				end as ACCTtasa,
			case a.ACCTmodificable
				when 0 then a.ACCTtasaMora
				when 1 then x.ACCTtasaMora
				end as ACCTtasaMora,		
			x.ACCTfechaInicio,  
			x.ACCTcapital,
			a.ACCTid,                  
			a.ACCTmodificable,
			a.ACCTdescripcion, 
			c.ACAid,
			e.Tcodigo,
			e.Ttipopago as ACCAperiodicidad,
			round(case a.ACCTmodificable when 0 then a.ACCTplazo when 1 then x.ACCTplazo end  *(select <cf_dbfunction name="to_number" args="acp30.Pvalor"> from ACParametros acp30 where acp30.Ecodigo = e.Ecodigo and acp30.Pcodigo = 30)/(<cf_dbfunction name="to_number" args="acp.Pvalor">*12),0) as ACCTcuotas,
			b.DEnombre,
			b.DEapellido1,
			b.DEapellido2 
			
			
		from #table_name# x
		inner join 	ACCreditosTipo a
			on a.ACCTcodigo=x.ACCTcodigo
		inner join DatosEmpleado b
			on 	x.DEidentificacion=b.DEidentificacion
			and  a.Ecodigo=b.Ecodigo
		inner join ACAsociados c
			on b.DEid=c.DEid	
		inner join LineaTiempo  d
			on d.DEid=b.DEid
			and d.Ecodigo=b.Ecodigo
		inner join TiposNomina e
			on d.Tcodigo=e.Tcodigo
			and d.Ecodigo=e.Ecodigo	
		left join ACParametros acp
			 on acp.Ecodigo = e.Ecodigo
			and acp.Pcodigo = 
					case e.Ttipopago
						when 0 then 90
						when 1 then 80
						when 2 then 70
						when 3 then 60
					end
		where  a.Ecodigo = #session.Ecodigo#
		and <cf_dbfunction name="to_date"   args="x.ACCTfechaInicio" YMD="true"> between  LTdesde and LThasta
	</cfquery>
	
	
	<cfloop query="rsCreditos">
		<!---  VERIFICA QUE NO HAYA UN CREDITO DE ESTE TIPO Y SEA UN PRESTAMO UNICO EN BD --->
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select 1
			from ACCreditosAsociado a
			inner join ACCreditosTipo b
				on b.Ecodigo = a.Ecodigo
				and b.ACCTid = a.ACCTid
				and b.ACCTunico = 1
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.ACAid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACAid#">
			  and a.ACCTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACCTid#">
			  and (a.ACCTcapital - a.ACCTamortizado) > 0
		</cfquery>
		<cfif isdefined("rsVerifica") and  rsVerifica.recordcount gt 0>
			<cfquery name="INS_Error" datasource="#session.DSN#">
				insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)
				values(
				<cf_dbfunction name="concat" args="'El empleado: #DEnombre#  #DEapellido1# #DEapellido2# con cedula: #DEidentificacion# ya cuenta con el crédito único: #ACCTdescripcion# codigo:#ACCTcodigo# registrado en el aplicativo de SOIN', ,''">,2,'#DEidentificacion#')
			</cfquery>
		</cfif>	
		
		
		<!---VALIDA QUE EL ARCHIVO A IMPORTAR NO TENGA UN MISMO EMPLEADO,CREDITO Y FECHA DE INICIO--->
		<cf_dbfunction name="date_format"  args="x.ACCTfechaInicio,dd/mm/yyyy" returnvariable="LvarFecha">
		<cfquery name="rsVerifica2" datasource="#Session.Dsn#">
			select 1
				from ACCreditosAsociado a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a.ACAid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACAid#">
				  and a.ACCTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACCTid#">
				  and (a.ACCTcapital - a.ACCTamortizado) > 0	
				  and  '#ACCTfechaInicio#' between a.ACCTfechaInicio and a.ACCTfechaInicio 	
		</cfquery>
		<cfif isdefined("rsVerifica2") and  rsVerifica2.recordcount gt 0>
			<cfquery name="INS_Error" datasource="#session.DSN#">
				insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Cedula)
				values(
				'El empleado: #DEnombre#  #DEapellido1# #DEapellido2# con cedula: #DEidentificacion# ya cuenta con el crédito: #ACCTdescripcion# codigo:#ACCTcodigo# registrado en el aplicativo de SOIN en la misma fecha que: #LSDateformat(ACCTfechaInicio,'DD/MM/YYYY')#',2,'#DEidentificacion#')
			</cfquery>
		</cfif>
		
	</cfloop>
</cfif>


<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by Cedula,ErrorNum
</cfquery>	

<cfif (err.recordcount) EQ 0>
	
	<cfinvoke component="rh.asoc.Componentes.RH_PlanPagos" method="init" returnvariable="plan">
	
	<cftransaction>
		<cfloop query="rsCreditos">
			<!--- 1. Crea el credito para el asociado --->
			<cfset ACCAid = plan.insertarCredito( 	ACAid,
													ACCTid,
													replace(ACCTcapital, ',', '', 'all' ),
													replace(ACCTplazo, ',', '', 'all' ), 
													replace(ACCTtasa, ',', '', 'all' ), 
													replace(ACCTtasaMora, ',', '', 'all' ), 
													ACCTfechaInicio, 
													ACCAperiodicidad,
													0,
													Tcodigo,
													replace(ACCTcuotas, ',', '', 'all' ) ) >
			
			<!--- 2. Crea el plan de pagos --->										
			<cfset plan.crearPlan(	ACCAid,
									false,
									session.usucodigo,
									session.Ecodigo,
									session.DSN )> 
		</cfloop>							
	</cftransaction>
</cfif>


