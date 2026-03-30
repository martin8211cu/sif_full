<cfoutput>

<!--- Si viene el Codigo del turno ---->
<cfif isdefined("form.Codigo_turno") and len(trim(form.Codigo_turno))>
	<!--- Si el id del turno viene vacio se selecciona el id del codigo digitado ---->
	<cfif isdefined("form.Turno_id") and len(trim(form.Turno_id)) EQ 0>
		<cfquery name="rsTurno" datasource="#session.DSN#">
			select Turno_id
			from Turnos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Codigo_turno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Codigo_turno#">
		</cfquery>
		<!--- Si existe el codigo carga el ID en form.Turno_id ---->
		<cfif rsTurno.Recordcount NEQ 0>
			<cfset form.Turno_id = rsTurno.Turno_id>
			<cfset form.Turno_id = rsTurno.Turno_id>
		<cfelse>
			<script>alert('El código de turno digitado no exisite');</script>
		</cfif>	
	</cfif>
</cfif>

<!---- Si vienen las llaves ---->
<cfif isdefined("form.Turno_id") and len(trim(form.Turno_id)) and isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
	<!--- Si viene el boton Agregar es para realizar un Insert (asignar) en la tabla Turnosxofi ---->
	<cfif isdefined("form.btnAgregar")>	
		<cfquery name="Insert" datasource="#session.DSN#">
			insert  into Turnoxofi(Ecodigo, Ocodigo, Turno_id, Testado, BMUsucodigo)
			values(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Turno_id#">,
				1,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">		
				)
		</cfquery>
	</cfif>

	<!---- Si viene el campo SQL hay 2 opciones: 
				a)Update del estado del turno en esa oficina 
				b)Delete el turno 
	---->
	<cfif isdefined("form.SQL") and len(trim(form.SQL))>
		<cfif form.SQL EQ "Cambio">
			<cfif isdefined('form.Testado_#form.Turno_id#_#form.Ocodigo#')>				
				<cfquery name="Update" datasource="#session.DSN#">
					update Turnoxofi set
						Testado = 1
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Turno_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Turno_id#">
						and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">				
				</cfquery>	
			<cfelse>
				<cfquery name="Update" datasource="#session.DSN#">
					update Turnoxofi set
						Testado = 0
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Turno_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Turno_id#">
						and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">				
				</cfquery>	
			</cfif>		
		</cfif>		

		<cfif form.SQL EQ "Eliminar">
			<cfif isdefined("form.Turno_id") and len(trim(form.Turno_id)) and isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
				<cfquery name="Delete" datasource="#session.DSN#">
					delete 
					from Turnoxofi
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Turno_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Turno_id#">
						and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
				</cfquery>		
			</cfif>	
		</cfif>

	</cfif>
</cfif>
</cfoutput>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.CMAid') and form.CMAid NEQ ''>
		<cfset params= params&'&CMAid='&form.CMAid>	
	</cfif>
</cfif>
<cfif isdefined('form.Ocodigo') and form.Ocodigo NEQ ''>
	<cfset params= params&'&Ocodigo='&form.Ocodigo>	
</cfif>
<cfif isdefined('form.Odescripcion') and form.Odescripcion NEQ ''>
	<cfset params= params&'&Odescripcion='&form.Odescripcion>	
</cfif>
<cfif isdefined('form.filtro_Ocodigo') and form.filtro_Ocodigo NEQ ''>
	<cfset params= params&'&filtro_Ocodigo='&form.filtro_Ocodigo>	
	<cfset params= params&'&hfiltro_Ocodigo='&form.filtro_Ocodigo>		
</cfif>
<cfif isdefined('form.filtro_Odescripcion') and form.filtro_Odescripcion NEQ ''>
	<cfset params= params&'&filtro_Odescripcion='&form.filtro_Odescripcion>	
	<cfset params= params&'&hfiltro_Odescripcion='&form.filtro_Odescripcion>		
</cfif>
<cflocation url="Turnosxofi.cfm?Pagina=#Form.Pagina##params#">