<cfif isdefined("Form.Aprobar")>
	<cfquery name="rsDetalleRHLiquidacionPersonal" datasource="#session.DSN#">
		select DLfvigencia as DLfechaaplic
			 from DLaboralesEmpleado 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
	</cfquery>
	<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
		<cfinvokeargument name="DLlinea" value="#form.DLlinea#">
		<cfinvokeargument name="DEid" value="#form.DEid#">
	</cfinvoke>
	<cfif rsLF.recordcount gt 0>
		<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnValidaModificaciones" returnvariable="datosHanCambiado">
			<cfinvokeargument name="DLlinea" value="#form.DLlinea#">
			<cfinvokeargument name="DEid" value="#form.DEid#">
			<cfinvokeargument name="Fecha" value="#rsDetalleRHLiquidacionPersonal.DLfechaaplic#">
		</cfinvoke>
		<cfif datosHanCambiado>
			<cfthrow message="Los datos del paso 2 han sido modificados y no se han guardado, debe de Guardar los datos para aprobar la Liquidación.">
		</cfif>
	<cfelse>
		<cfthrow message="El paso 2 es necesario para la liquidación y este no ha sido proceso, debe de Guardar los datos generados por este para aprobar la Liquidación.">
	</cfif>
	<cftransaction>

		<!--- Procesillo para matar saldo de vacaciones de un empleado cesado.
			  Este calculo se REALIZABA cuando se aplicaba la accion, pero se cambio
			  para realizarlo en este punto.	
		 --->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Liquidacion_de_Vacaciones"
			xmlfile="/rh/nomina/liquidacion/liquidacionProceso.xml"
			Default="Liquidación de Vacaciones."	
			returnvariable="MSG_Liquidacion"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Liquidacion_de_Dias_de_Enfermedad"
			xmlfile="/rh/nomina/liquidacion/liquidacionProceso.xml"
			Default="Liquidación de Días de Enfermedad."	
			returnvariable="MSG_LiquidacionEnf"/>

		<cfif isdefined("form.DLlinea") and len(trim(form.DLlinea))>
			<cfquery datasource="#session.DSN#" name="rsFcese">
				select DLfvigencia from DLaboralesEmpleado where DLlinea=#form.DLlinea# 
			</cfquery>
			<cfset fechaLiq = rsFcese.DLfvigencia>
		<cfelse>
			<cfset fechaLiq = now()>
		</cfif>
		
		<cfquery datasource="#session.DSN#" >
			insert into DVacacionesEmpleado( DEid, 
											 Ecodigo, 
											 DVEfecha, 
											 DVEdescripcion, 
											 DVEdisfrutados, 
											 DVEcompensados, 
											 DVEenfermedad, 
											 DVEadicionales, 
											 DVEmonto, 
											 Usucodigo, 
											 Ulocalizacion, 
											 DVEfalta, 
											 BMUsucodigo )
			select DEid,
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				   <cfqueryparam cfsqltype="cf_sql_date" value="#fechaLiq#">,
				   '#MSG_Liquidacion#',
				    sum(DVEdisfrutados + DVEcompensados)*-1,
					0,
					0,
					0,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					'00',
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					
			from DVacacionesEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			group by DEid
		</cfquery>

		<!--- 	Desarrollo Baroda-DHC  
				Se inserta un registro para saldar a cero los dias de enfermedad del empleado.
				Solo si empresa maneja dias de enfermedad.
		--->
		<cfquery name="rs_p960" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 960
		</cfquery>

		<cfif trim(rs_p960.Pvalor) eq 1>
			<cfquery datasource="#session.DSN#" >
				insert into DVacacionesEmpleado( DEid, 
												 Ecodigo, 
												 DVEfecha, 
												 DVEdescripcion, 
												 DVEdisfrutados, 
												 DVEcompensados, 
												 DVEenfermedad, 
												 DVEadicionales, 
												 DVEmonto, 
												 Usucodigo, 
												 Ulocalizacion, 
												 DVEfalta, 
												 BMUsucodigo )
				select DEid,
					   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					   #fechaLiq#,
					   '#MSG_LiquidacionEnf#',
						0,
						0,
						sum(DVEenfermedad)*-1,
						0,
						0,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						'00',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						
				from DVacacionesEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				group by DEid
			</cfquery>
			
			<cfquery datasource="#session.DSN#">
				update EVacacionesEmpleado
				set EVfenfermedad = ( select DLfvigencia 
									  from DLaboralesEmpleado 
									  where DEid = EVacacionesEmpleado.DEid 
									    and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> )
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfquery>
		</cfif>

		<!--- Procesillo para matar pago de intereses por cesantia --->
		<!--- solo si empresa para intereses por cesantia --->
		<cfquery name="rs_parametro_810" datasource="#session.DSN#" >
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 810
		</cfquery>
		<cfif ucase(rs_parametro_810.Pvalor) eq 'YES'>
			<cfquery name="rs_datos" datasource="#session.DSN#">
				select RHLPid, DEid, motivoliq 
				from RHLiqIngresos
				where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
				and cesantia = 1
			</cfquery>
			
			<cfif len(trim(rs_datos.DEid)) and len(trim(rs_datos.motivoliq)) >
				<!--- hace los calculos del pago de intereses por cesantia --->
				<cfinvoke component="rh.Componentes.RH_Cesantia" method="liquidacion" returnvariable="rs_calculado">
					<cfinvokeargument name="DEid" value="#rs_datos.DEid#">
					<cfinvokeargument name="tipo" value="#rs_datos.motivoliq#">
				</cfinvoke>
				
				<!--- modifica el registro asociado a la cesantia (solo es uno) --->
				<cfquery datasource="#session.DSN#">
					update RHLiqIngresos
					set importe = <cfif len(trim(rs_calculado.monto_total))><cfqueryparam cfsqltype="cf_sql_money" value="#rs_calculado.intereses#"><cfelse>0</cfif>
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
					and cesantia = 1
				</cfquery>
				
			<cfelse>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Error._Debe_definir_el_Concepto_Incidente_y_el_motivo_de_la_liquidacion_para_el_calculo_de_intereses_por_Cesantia._Debe_ir_al_paso_1_a_definir_esta_informacion"
					xmlfile="/rh/nomina/liquidacion/liquidacionProceso.xml"
					Default="Error de configuraci&oacute;n. Debe definir el Concepto Incidente y el motivo de la liquidaci&oacute;n para el c&aacute;lculo de intereses por Cesant&iacute;a. Debe ir al paso 1 a definir esta informaci&oacute;n"	
					returnvariable="MSG_Error"/>
				    <cf_throw message="#MSG_Error#" errorCode="1075">	
			</cfif>
		</cfif>	

		<cfquery name="updLiquidacion" datasource="#Session.DSN#">
			update RHLiquidacionPersonal
			set RHLPestado = 1,
			RHLPfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
		</cfquery>
		
		<!--- pone la fecha de ultima liquidacion de cesantia para el empleado --->
		<cfquery datasource="#session.DSN#">
			update EVacacionesEmpleado
			set EVfliquidacion = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			where DEid = ( select DEid from RHLiquidacionPersonal where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> )
		</cfquery>
	</cftransaction>
	<cflocation url="liquidacionProceso.cfm">
</cfif>