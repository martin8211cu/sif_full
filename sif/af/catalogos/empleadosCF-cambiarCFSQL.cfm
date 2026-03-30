<!---
 Acrchivo:	empleadoCF-cambiarCFSQL.cfm
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

<cfif isdefined("form.btnCambiarCF")>
	
	<cftransaction>
	
		<!--- Query que sirve para cerrar una nueva línea de tiempo --->
		<cfquery name="rsUpdateCF" datasource="#session.dsn#">
			Update EmpleadoCFuncional 
			set ECFhasta = <cf_dbfunction name="dateadd" args="-1, #LSParseDateTime(form.ECFdesde)#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ECFlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECFlinea#">
		</cfquery>
		
		<!--- Asignación de valores de las fechas --->
		<cfif isdefined("form.ECFdesde") and trim(form.ECFdesde) NEQ "">
			<cfset form.fechaDesde = #form.ECFdesde#>
		</cfif>
	
		<cfif isdefined("form.ECFhasta") and trim(form.ECFhasta) NEQ "">
			<cfset form.fechaHasta = #form.ECFhasta#>
		<cfelse>
			<cfset form.fechaHasta = '6100-01-01 00:00:00' >
		</cfif>
	
		<!--- Valida que la fecha final sea mayor que la fecha inicio --->

		<cfquery name="rsValidaFechaMayor" datasource="#session.dsn#">
			select <cf_dbfunction name="datediff" args="#LSParseDateTime(form.fechaDesde)#, #LSParseDateTime(form.fechaHasta)#"> as diasDiferencia
				from dual
		</cfquery>

		<cfif rsValidaFechaMayor.diasDiferencia GT 0>
		
			<!--- Valida que exista la fecha inicio en el rango de fechas --->
			<cfquery name="rsValidaFechaInicio" datasource="#session.dsn#">
				select 1
				from EmpleadoCFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				   and #LSParseDateTime(form.fechaDesde)# between ECFdesde and ECFhasta   
			</cfquery>
			
			<cfif rsValidaFechaInicio.recordCount EQ 0>
			
				<!--- Valida que exista la fecha final en el rango de fechas --->
				<cfquery name="rsValidaFechaFinal" datasource="#session.dsn#">
					select 1
					from EmpleadoCFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					   and #LSParseDateTime(form.fechaHasta)# between ECFdesde and ECFhasta   
				</cfquery>
				
				<cfif rsValidaFechaFinal.recordCount EQ 0>

					<!--- Valida que exista la fecha ECFdesde en el rango de fechas recibidas de la pantalla --->
					<cfquery name="rsValidaRangoIncial" datasource="#session.dsn#">
					select 1
					from EmpleadoCFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					   and ECFdesde between #LSParseDateTime(form.fechaDesde)# and  #LSParseDateTime(form.fechaHasta)#
					</cfquery>

					<cfif rsValidaRangoIncial.recordCount EQ 0>

						<!--- Valida que exista la fecha ECFhasta en el rango de fechas recibidas de la pantalla --->
						<cfquery name="rsValidaRangoFinal" datasource="#session.dsn#">
							select 1
							from EmpleadoCFuncional
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							   and ECFhasta between #LSParseDateTime(form.fechaDesde)# and  #LSParseDateTime(form.fechaHasta)#  
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
									<cfqueryparam cfsqltype="cf_sql_date"  value="#LSParseDateTime(form.ECFdesde)#">,
									<cfif isdefined("form.ECFhasta") and trim(form.ECFhasta) EQ "">
										<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime('01/01/6100')#">,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ECFhasta)#">,
									</cfif> 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
									<cfif isdefined("form.ECFencargado")>1<cfelse>0</cfif>
								)
							</cfquery>

						<cfelse>
							<cfset mensaje = Error5 >
							<cftransaction action="rollback">
						</cfif>

					<cfelse>
						<cfset mensaje = Error4 >
						<cftransaction action="rollback">
					</cfif>

				<cfelse>
					<cfset mensaje = Error3 >
					<cftransaction action="rollback">
				</cfif>
			
			<cfelse>
				<cfset mensaje = Error2 >
				<cftransaction action="rollback">
			</cfif>
		
		<cfelse>
			<cfset mensaje = Error1 >
			<cftransaction action="rollback">
		</cfif>

	</cftransaction>

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

