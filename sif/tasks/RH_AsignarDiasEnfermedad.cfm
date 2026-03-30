<cfapplication name="SIF_ASP">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Asignar Dias de Enfermedad</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br>
<cfquery name="caches" datasource="asp">
	select distinct c.Ccache as cache, 
					e.Ereferencia as Ecodigo

	from Empresa e, ModulosCuentaE m, Caches c

	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'RH'
      and e.Ereferencia is not null
</cfquery>

<!--- Procesamiento para datasource que use RH --->
<cfloop query="caches">
	<cfset DSN = caches.cache>
	<cfset vEcodigo = caches.Ecodigo>
	<cftry>
	<!--- Verifica que la empresa utilize calculo de dias de enfermedad --->
	<cfquery name="rs_enfermedad" datasource="#DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigo#">
		  and Pcodigo = 960
	</cfquery>

	<!--- Si la empresa procesa dias de enfermedad --->
	<cfif rs_enfermedad.pvalor eq 1 >
		<!--- lee los parametros de configuracion del proceso 970, 980, 990--->
		<cfset dias_tope 	= 36 >		<!--- cantidad de dias maximo que se puede adjudicar a un empleado por enfermedad --->
		<cfset dias_periodo = 26 >		<!--- cantidad de dias donde el empleado no debe tener acciones incapacidad|permiso de no pago --->
		<cfset dias_asignar = 1.5 >		<!--- cantidad de dias ganados por el empleado al cumplir periodos sin acciones de incapacidad|permiso de no pago --->

		<cfquery name="rs_p970" datasource="#DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigo#">
			  and Pcodigo = 970
		</cfquery>
		<cfif len(trim(rs_p970.Pvalor))>
			<cfset dias_tope = rs_p970.Pvalor >
		</cfif>

		<cfquery name="rs_p980" datasource="#DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigo#">
			  and Pcodigo = 980
		</cfquery>
		<cfif len(trim(rs_p980.Pvalor))>
			<cfset dias_periodo = rs_p980.Pvalor >
		</cfif>

		<cfquery name="rs_p990" datasource="#DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigo#">
			  and Pcodigo = 990
		</cfquery>		
		<cfif len(trim(rs_p990.Pvalor))>
			<cfset dias_asignar = rs_p990.Pvalor >
		</cfif>

		<!--- recupera todos los empleados activos al dia de hoy de la empresa --->
		<cfquery name="rs_empleados" datasource="#DSN#">
			select ve.DEid, coalesce(EVfenfermedad, EVfantig) as fecha
			from EVacacionesEmpleado ve, DatosEmpleado de
			where de.DEid=ve.DEid
			  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEcodigo#">

			  <!--- solo empleados activos al dia de hoy (ver si esto aplica) ---> 	
			  and exists (  select 1
			  				from LineaTiempo lt
							where lt.DEid = ve.DEid
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta )
		</cfquery>
		<!--- 4. Procesa cada uno de los registros recuperados en 2 --->
		<cftransaction>
		<cfloop query="rs_empleados">
			<!--- 5. solo empleados con mas de dias_periodo dias de antiguedad (proceso para panama es cada dias_periodo dias, podria parametrizarse esto) --->
			<cfif abs(datediff('d', rs_empleados.fecha, now())) gte dias_periodo >
				<!--- 	PROCESO 
						=======
						Se debe revisar para cada empleado, si ha laborado dias_periodo dias sin interrupcion sin aplicarsele una accion de
						personal de tipo incapacidad o de tipo permiso, y que no paga.
						Si no tiene este tipo de accion, para una periodicidad de dias_periodo dias (ejemplo si la diferencia en dias 
						desde la ultima ejecucion de este proceso, hasta el dia de la nueva ejecucion, es 55 dias, tenemos dos periodos 
						de dias_periodo dias (52 dias) y nos sobran 3 que no se toman en cuenta ), por cada periodo encontrado se le van a sumar dias_asignar
						dias al saldo de dias de enfermedad. Ademas debe actualizarse la fecha del ultimo calculo de este proceso.
						Si el empleado tiene periodos de dias_periodo dias, pero con acciones de incapacidad|permiso que no pagan, NO se le asignan
						los dias_asignar dias y SOLO se actualiza la ultima fecha de ejecucion de este proceso.
				--->
				
				<!--- 6. 	Calcula si el empleado tiene incapacidades|permisos de no pago a partir de la ultima fecha de ejecucion de este proceso 
							Esto para determinar la forma en que vamos a procesar los registros. (periodo por periodo {dias_periodo dias} para ubicar la accion o un poco mas masivo {
							como no hay acciones, dividimos entre dias_periodo y obtenemos la cantidad de periodos de una} )
				--->

				<cfquery name="rs_tieneacciones" datasource="#DSN#">
					select lt.DEid, lt.LTdesde as desde, lt.LThasta as hasta
					from LineaTiempo lt, RHTipoAccion ta
					where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEcodigo#">
					and ta.RHTid = lt.RHTid
					and ta.RHTcomportam = 4
					and RHTpaga = 0
					and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
					and ( <cfqueryparam cfsqltype="cf_sql_date" value="#rs_empleados.fecha#"> between lt.LTdesde and lt.LThasta
						  or
						  lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rs_empleados.fecha#"> )
					
					union
					
					select lt.DEid, lt.LTdesde as desde, lt.LThasta as hasta
					from LineaTiempo lt, RHTipoAccion ta
					where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEcodigo#">
					and ta.RHTid = lt.RHTid
					and ta.RHTcomportam = 5
					and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
					and ( <cfqueryparam cfsqltype="cf_sql_date" value="#rs_empleados.fecha#"> between lt.LTdesde and lt.LThasta
						  or
						  lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rs_empleados.fecha#"> )

					union

					select lt.DEid, lt.RHSPEfdesde as desde, RHSPEfhasta as hasta
					from RHSaldoPagosExceso lt, RHTipoAccion ta
					where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEcodigo#">
					and ta.RHTid=lt.RHTid
					and ta.RHTcomportam = 4
					and lt.RHSPEanulado = 0
					and ta.RHTpaga=0
					and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
					and ( <cfqueryparam cfsqltype="cf_sql_date" value="#rs_empleados.fecha#"> between lt.RHSPEfdesde and lt.RHSPEfhasta
						  or
						  lt.RHSPEfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rs_empleados.fecha#"> )
					
					union
					
					select lt.DEid, lt.RHSPEfdesde as desde, RHSPEfhasta as hasta
					from RHSaldoPagosExceso lt, RHTipoAccion ta
					where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEcodigo#">
					and ta.RHTid=lt.RHTid
					and ta.RHTcomportam = 5
					and lt.RHSPEanulado = 0					
					and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
					and ( <cfqueryparam cfsqltype="cf_sql_date" value="#rs_empleados.fecha#"> between lt.RHSPEfdesde and lt.RHSPEfhasta
						  or
						  lt.RHSPEfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rs_empleados.fecha#"> )

 					order by desde
				</cfquery>
				<!--- Dias de enfermedad que actualmente tiene asignados el empleado --->
				<cfquery name="rs_diasempleado" datasource="#DSN#">
					select coalesce(sum(DVEenfermedad), 0) as DVEenfermedad
					from DVacacionesEmpleado
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
				</cfquery>

				<!--- si el empleado tiene acciones de incapadidad|permisos calcula por aqui cuantos dias de enfermedad le tocan --->
				<!--- inicialmente parte el tiempo en periodos de dias_periodo dias uno a uno ver si se puede masificar un poco --->
				<cfset descripcion = 'Asignación de días de enfermedad ' >
				<cfif rs_tieneacciones.recordcount gt 0 >
					<!--- inicializa fechas --->
					<cfset fecha_ultima_ejecucion = rs_empleados.fecha >
					<cfset fecha_temporal = dateadd('d', dias_periodo, fecha_ultima_ejecucion) >
					
					<!--- descripcion para poner en DVacaciones empleado (falta una fecha) --->
					<cfset descripcion = descripcion & 'período del #LSDateFormat(fecha_ultima_ejecucion, "dd/mm/yyyy")# al ' >

					<cfset dias_ganados = 0 >	<!--- contador de dias de enfermedad ganados --->
					<cfloop condition="fecha_temporal lte now()">
						<!--- Revisa si hay acciones de incapacidad|permiso y de no pago en el rango de fechas --->
						<cfquery name="rs_tieneaccionesRango" datasource="#DSN#">
							select lt.DEid, lt.LTdesde as desde, lt.LThasta as hasta
							from LineaTiempo lt, RHTipoAccion ta
							where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEcodigo#">
							  and ta.RHTid = lt.RHTid
							  and ta.RHTcomportam = 4
							  and RHTpaga = 0
							  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_ultima_ejecucion#"> <= lt.LThasta
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_temporal#"> >= lt.LTdesde
							
							union
							
							select lt.DEid, lt.LTdesde as desde, lt.LThasta as hasta
							from LineaTiempo lt, RHTipoAccion ta
							where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEcodigo#">
							  and ta.RHTid = lt.RHTid
							  and ta.RHTcomportam = 5
							  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_ultima_ejecucion#"> <= lt.LThasta
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_temporal#"> >= lt.LTdesde

							union							
		
							select lt.DEid, lt.RHSPEfdesde as desde, RHSPEfhasta as hasta
							from RHSaldoPagosExceso lt, RHTipoAccion ta
							where lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#vEcodigo#">
							  and ta.RHTid=lt.RHTid
							  and ta.RHTcomportam = 4
							  and ta.RHTpaga=0
							  and lt.RHSPEanulado = 0							  
							  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_ultima_ejecucion#"> <= lt.RHSPEfhasta
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_temporal#"> >= lt.RHSPEfdesde

							union
							
							select lt.DEid, lt.RHSPEfdesde as desde, RHSPEfhasta as hasta
							from RHSaldoPagosExceso lt, RHTipoAccion ta
							where lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#vEcodigo#">
							  and ta.RHTid=lt.RHTid
							  and ta.RHTcomportam = 5
		  					  and lt.RHSPEanulado = 0
							  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_ultima_ejecucion#"> <= lt.RHSPEfhasta
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_temporal#"> >= lt.RHSPEfdesde
						</cfquery>

						<!--- si no hay acciones incapacidad|permiso de no pago, suma dias_asignar dias para cada periodo de fechas --->
						<cfif rs_tieneaccionesRango.recordcount eq 0 >
							<cfset dias_ganados = dias_ganados + dias_asignar >
						</cfif>

						<!--- nuevas fechas --->
						<cfset fecha_ultima_ejecucion = dateadd('d', 1, fecha_temporal) >
						<cfset fecha_temporal = dateadd('d', dias_periodo, fecha_ultima_ejecucion) >
					</cfloop>
					
					<!--- termina la descripcion --->
					<cfset descripcion = descripcion & LSDateFormat(dateadd('d', -1, fecha_ultima_ejecucion), "dd/mm/yyyy") >
					
					<!--- Pone en el encabezado de vacaciones la ultima fecha de ejecucion del proceso --->
					<cfquery datasource="#DSN#">
						update EVacacionesEmpleado
						set  EVfenfermedad = <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d', -1, fecha_ultima_ejecucion)#" >
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
					</cfquery>
				<!--- si no tiene este tipo de acciones, se divide la cantidad de dias entre dias_periodo y la parte entera son los periodos de dias_periodo dias completos--->
				<cfelse>
					<cfset dias_proceso = abs(datediff('d', rs_empleados.fecha, now())) >
					<cfset periodos = int(dias_proceso / dias_periodo) >
					<!--- 7. Dias ganados por los periodos laborados --->
					<cfset dias_ganados = periodos * dias_asignar >
					
					<!--- 10. Pone en el encabezado de vacaciones la ultima fecha de ejecucion del proceso --->
					<cfset fecha_ejecucion = dateadd('d', periodos*dias_periodo, rs_empleados.fecha ) >
					<cfquery datasource="#DSN#">
						update EVacacionesEmpleado
						set  EVfenfermedad = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_ejecucion#" >
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">
					</cfquery>
					
					<!--- descripcion para poner en DVacaciones empleado (falta una fecha) --->
					<cfset descripcion = descripcion & 'período del #LSDateFormat(rs_empleados.fecha, "dd/mm/yyyy")# al #LSDateFormat(fecha_ejecucion, "dd/mm/yyyy")#' >
					
				</cfif>
				
				<!--- 9. 	Va a insertar en el detalle de vacaciones un registro, si y solo si:
							i)	 Si el empleado NO tiene asignados dias_tope dias de enfermedad en el sistema actualmente(rs_diasempleado.DVEenfermedad)
							ii)  Si lo asignado mas lo calculado en este proceso, no excede los dias_tope dias de enfermedad. Si asi fuera se completa lo
								 asignado a dias_tope dias, lo demas se desecha (lo calculado aqui).
							iii) Si lo asignado mas lo calculado en este proceso, no excede los dias_tope dias de enfermedad	
				--->
				<!--- i --->
				<cfif rs_diasempleado.DVEenfermedad lt dias_tope >
					<!--- ii --->
					<cfif rs_diasempleado.DVEenfermedad + dias_ganados gt dias_tope >
						<cfset dias_ganados = dias_tope - rs_diasempleado.DVEenfermedad >
					</cfif> 

					<!--- iii --->
					<!--- inserta en DVacacionesEmpleado  --->
					<cfquery datasource="#DSN#">
						insert into DVacacionesEmpleado(	DEid, 
															Ecodigo,
															DVEfecha, 
															DVEdescripcion, 
															DVEdisfrutados, 
															DVEcompensados, 
															DVEenfermedad, 
															DVEadicionales, 
															DVEmonto, 
															Usucodigo, 
															Ulocalizacion)
						values( 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_empleados.DEid#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
									'#descripcion#',
									0,
									0,
									<cfqueryparam cfsqltype="cf_sql_float" value="#dias_ganados#">,
									0,
									0.00,
									1,
									'00' )
					</cfquery>
				</cfif>
				
			</cfif>
		</cfloop> <!--- rs_empleados --->

		</cftransaction>
	</cfif>	

	<cfcatch type="any">
		<cflog 	text = "#cfcatch.Message#: #cfcatch.detail#"	
				file = "Proceso_Dias_Enfermedad"	
				application = "yes">
	</cfcatch>
	</cftry>
</cfloop>
<cfset finish = Now()>
<br><br>Proceso Terminado<cfoutput> #TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>

</body>
</html>