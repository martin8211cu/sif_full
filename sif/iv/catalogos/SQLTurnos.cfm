<!---- Se crea una variable tipo dateTime para las horas, minutos, segundos para poder insertar/modificar ----->
<CFSET form.HI_turno = CreateDateTime(#Year(now())#, #Month(now())#, #Day(now())#,form.HI_turnoH,form.HI_turnoM, 00)>
<CFSET form.HF_turno = CreateDateTime(#Year(now())#, #Month(now())#, #Day(now())#,form.HF_turnoH, form.HF_turnoM, 00)>

<!---- *****************************************************************************************************----->
<!---SQL que trae registros cuando el codigo aduanal digitado por el usuario ya existe--->
<cfquery name="rsExiste" datasource="#Session.DSN#">
	select Codigo_turno 
	from Turnos
	where Codigo_turno  = <cfqueryparam value="#form.Codigo_turno#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif isdefined("form.Alta")>
	<cfif rsExiste.recordcount GE 1>
		<cf_errorCode	code = "50394" msg = "El registro que desea ingresar ya existe">
		<cflocation url="formTurnos.cfm">
	</cfif>
</cfif>

<!--- Si la opcion elegida es la de Modificar un Codigo existente verifica que lo que se esta modificando es el codigo el resto no importa--->
<cfif isdefined("form.Cambio") and form.Codigo_turno2 NEQ form.Codigo_turno>
	<cfif rsExiste.recordcount GE 1>
		<cf_errorCode	code = "50394" msg = "El registro que desea ingresar ya existe">
		<cflocation url="formTurnos.cfm">
	</cfif>
</cfif>
<!---- *****************************************************************************************************----->
	<cfset modo = "ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cftransaction>
				<cfquery name="insert" datasource="#Session.DSN#">
					insert into Turnos(Ecodigo, Codigo_turno,Tdescripcion, HI_turno, HF_turno, BMUsucodigo) 
					values ( <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#Form.Codigo_turno#" cfsqltype="cf_sql_varchar">,
							 <cfqueryparam value="#Form.Tdescripcion#" cfsqltype="cf_sql_varchar">,
							 <cfqueryparam value="#form.HI_turno#" cfsqltype="cf_sql_timestamp">,
							 <cfqueryparam value="#form.HF_turno#" cfsqltype="cf_sql_timestamp">,						 
							 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
						   )
					 <cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="insert"> 	   
			</cftransaction>
			
			<cfif isdefined('insert')>
				<cfset form.Turno_id = insert.identity>		
			</cfif>
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="rsExiste" datasource="#session.DSN#">
				select 1
				from Turnoxofi
				where Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
				  and  Turno_id = <cfqueryparam value="#form.Turno_id#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
			<cfif isdefined("rsExiste") and rsExiste.RecordCount NEQ 0>
				<cf_errorCode	code = "50401" msg = "No se puede eliminar el turno ya que posee registros asociados">			
			<cfelse>			
				<cfquery name="delete" datasource="#session.DSN#">
					delete from Turnos
					where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
					  and  Turno_id = <cfqueryparam value="#form.Turno_id#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfif>
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="Turnos"
							redirect="Turnos.cfm"
							timestamp="#form.ts_rversion#"
							field1="Turno_id" 
							type1="numeric" 
							value1="#form.Turno_id#"
							>
	
			<cfquery name="update" datasource="#Session.DSN#">
				update Turnos set
					   Codigo_turno = <cfqueryparam value="#Form.Codigo_turno#" cfsqltype="cf_sql_varchar">,
					   Tdescripcion = <cfqueryparam value="#Form.Tdescripcion#" cfsqltype="cf_sql_varchar">,					    
					   HI_turno   = <cfqueryparam value="#Form.HI_turno#" cfsqltype="cf_sql_timestamp">,
					   HF_turno   = <cfqueryparam value="#Form.HF_turno#" cfsqltype="cf_sql_timestamp">
				where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  Turno_id = <cfqueryparam value="#form.Turno_id#" cfsqltype="cf_sql_numeric">
			</cfquery> 
		</cfif>
	</cfif>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.Turno_id') and form.Turno_id NEQ ''>
		<cfset params= params&'&Turno_id='&form.Turno_id>	
	</cfif>
</cfif>
<cfif isdefined('form.filtro_Codigo_turno') and form.filtro_Codigo_turno NEQ ''>
	<cfset params= params&'&filtro_Codigo_turno='&form.filtro_Codigo_turno>	
	<cfset params= params&'&hfiltro_Codigo_turno='&form.filtro_Codigo_turno>		
</cfif>
<cfif isdefined('form.filtro_Tdescripcion') and form.filtro_Tdescripcion NEQ ''>
	<cfset params= params&'&filtro_Tdescripcion='&form.filtro_Tdescripcion>	
	<cfset params= params&'&hfiltro_Tdescripcion='&form.filtro_Tdescripcion>		
</cfif>
<cflocation url="Turnos.cfm?Pagina=#Form.Pagina##params#">

