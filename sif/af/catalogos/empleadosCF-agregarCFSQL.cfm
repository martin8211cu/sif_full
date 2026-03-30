<!---
 Acrchivo:	empleadoCF-agregarCFSQL.cfm
 Creado: 	Randall Colomer Villalta en SOIN
 Fecha:  	04 Diciembre del 2006.
 --->

<!--- Variables para mostrar el mensaje de Error --->
<cfset mensaje = "">
<cfset Error1 = "La fecha inicial no puede ser mayor o igual que la fecha final.">
<cfset Error2 = "La fecha inicial se encuentra en un rango de fechas existente.">
<cfset Error3 = "La fecha final se encuentra en un rango de fechas existente.">
<cfset Error4 = "El rango de fechas que esta tratando de incluir es invalido.">
<cfset Error5 = "El rango de fechas que esta tratando de incluir es invalido.">
<cfset Error6 = "La fecha de retiro no puede ser mayor a la fecha de hoy.">

<cfif isdefined("form.btnAgregarCF")>

	<!--- Verifica si el empleado tiene alguna línea de tiempo asociada --->
	<cfquery name="rsValidaExistaEmpleado" datasource="#Session.DSN#">
		select 1
		from EmpleadoCFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">				  
	</cfquery>

	<cfif rsValidaExistaEmpleado.recordCount GT 0>
	
		<!--- Asignación de valores de las fechas --->
		<cfif isdefined("form.ECFdesde") and trim(form.ECFdesde) NEQ "">
			<cfset form.fechaDesde = #LSdateformat(form.ECFdesde,'yyyymmdd')#>
		</cfif>
	
		<cfif isdefined("form.ECFhasta") and trim(form.ECFhasta) NEQ "">
			<cfset form.fechaHasta = #LSdateformat(form.ECFhasta,'yyyymmdd')#>
		<cfelse>
			<cfset form.fechaHasta = '61000101' >
		</cfif>
	
		<!--- Valida que la fecha final sea mayor que la fecha inicio --->
		<cfquery name="rsValidaFechaMayor" datasource="#session.dsn#">
			select datediff(dd,convert(datetime,'#form.fechaDesde#'),convert(datetime,'#form.fechaHasta#')) as diasDiferencia
		</cfquery>

		<cfif rsValidaFechaMayor.diasDiferencia GT 0>
		
			<!--- Valida que exista la fecha inicio en el rango de fechas --->
			<cfquery name="rsValidaFechaInicio" datasource="#session.dsn#">
				select 1
				from EmpleadoCFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				   and convert(varchar,#form.fechaDesde#,112) between ECFdesde and ECFhasta   
			</cfquery>
			
			<cfif rsValidaFechaInicio.recordCount EQ 0>
			
				<!--- Valida que exista la fecha final en el rango de fechas --->
				<cfquery name="rsValidaFechaFinal" datasource="#session.dsn#">
					select 1
					from EmpleadoCFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					   and convert(varchar,#form.fechaHasta#,112) between ECFdesde and ECFhasta   
				</cfquery>
				
				<cfif rsValidaFechaFinal.recordCount EQ 0>
				
					<!--- Valida que exista la fecha ECFdesde en el rango de fechas recibidas de la pantalla --->
					<cfquery name="rsValidaRangoIncial" datasource="#session.dsn#">
					select 1
					from EmpleadoCFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					   and ECFdesde between convert(varchar,#form.fechaDesde#,112) and  convert(varchar,#form.fechaHasta#,112)  
					</cfquery>

					<cfif rsValidaRangoIncial.recordCount EQ 0>
					
						<!--- Valida que exista la fecha ECFhasta en el rango de fechas recibidas de la pantalla --->
						<cfquery name="rsValidaRangoFinal" datasource="#session.dsn#">
							select 1
							from EmpleadoCFuncional
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							   and ECFhasta between convert(varchar,#form.fechaDesde#,112) and  convert(varchar,#form.fechaHasta#,112)  
						</cfquery>
						
						<cfif rsValidaRangoFinal.recordCount EQ 0>
						
							<!--- Query que sirve para insertar una nueva línea de tiempo --->
							<cfquery name="rsInsertarCF" datasource="#session.dsn#">
								insert into EmpleadoCFuncional (
									Ecodigo, 
									DEid, 
									CFid, 
									ECFdesde, 
									ECFhasta, 
									BMUsucodigo, 
									ECFencargado
								)
								values (
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid2#">, 
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECFdesde)#">,
									<cfif isdefined("form.ECFhasta") and trim(form.ECFhasta) EQ "">
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100 23:59:59')#">,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECFhasta)#">,
									</cfif> 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
									<cfif isdefined("form.ECFencargado")>1<cfelse>0</cfif>
								)
							</cfquery>
							
						<cfelse>
							<cfset mensaje = Error5 >
						</cfif>
						
					<cfelse>
						<cfset mensaje = Error4 >
					</cfif>
					
				<cfelse>
					<cfset mensaje = Error3 >
				</cfif>
				
			<cfelse>
				<cfset mensaje = Error2 >
			</cfif>
			
		<cfelse>
			<cfset mensaje = Error1 >
		</cfif>
		
	<cfelse>
	
		<!--- Query que sirve para insertar una nueva línea de tiempo --->
		<cfquery name="rsInsertarCF" datasource="#session.dsn#">
			insert into EmpleadoCFuncional (
				Ecodigo, 
				DEid, 
				CFid, 
				ECFdesde, 
				ECFhasta, 
				BMUsucodigo, 
				ECFencargado
			)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid2#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECFdesde)#">,
				<cfif isdefined("form.ECFhasta") and trim(form.ECFhasta) EQ "">
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100 23:59:59')#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECFhasta)#">,
				</cfif> 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfif isdefined("form.ECFencargado")>1<cfelse>0</cfif>
			)
		</cfquery>
		
	</cfif>
	
</cfif>

<!--- Funcion de Javascrip que sirve para mostrar el error al usuario o regresar a la lista. --->
<script language="javascript1.2" type="text/javascript">
	<cfif mensaje neq "">	
		alert("<cfoutput>#mensaje#</cfoutput>");
		history.back(-1);
	<cfelse>
		opener.document.location.reload();
		window.close();
	</cfif>
</script>

