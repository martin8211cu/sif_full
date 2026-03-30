<cfdump var="#form#">
<CFSET form.HI_turno = CreateDateTime(#Year(now())#, #Month(now())#, #Day(now())#,form.HI_turnoH, form.HI_turnoM, form.HI_turnoS)>
<cfdump var="#form.HIturno#">
<cfabort>



<!---- *****************************************************************************************************----->
<!---SQL que trae registros cuando el codigo aduanal digitado por el usuario ya existe--->
<cfquery name="rsExiste" datasource="#Session.DSN#">
	select Codigo_turno 
	from Turnos
	where Codigo_turno  = <cfqueryparam value="#form.Codigo_turno#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif isdefined("form.Alta")>
	<cfif rsExiste.recordcount GE 1>
		<cfthrow message="El registro que desea ingresar ya existe">
		<cflocation url="formTurnos.cfm">
	</cfif>
</cfif>

<!--- Si la opcion elegida es la de Modificar un Codigo existente verifica que lo que se esta modificando es el codigo el resto no importa--->
<cfif isdefined("form.Cambio") and form.Codigo_turno2 NEQ form.Codigo_turno>
	<cfif rsExiste.recordcount GE 1>
		<cfthrow message="El registro que desea ingresar ya existe">
		<cflocation url="formTurnos.cfm">
	</cfif>
</cfif>
<!---- *****************************************************************************************************----->
	<cfset modo = "ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into Turnos(Ecodigo, Codigo_turno,Tdescripcion, HI_turno, HF_turno, BMUsucodigo) 
				values ( <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Form.Codigo_turno#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Form.Tdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					   )
			</cfquery>		   
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delete" datasource="#session.DSN#">
					delete Turnos
					where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
					  and  Turno_id = <cfqueryparam value="#form.Turno_id#" cfsqltype="cf_sql_numeric">
				</cfquery>
			<cfset modo="BAJA">
	
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
			<cfset modo="CAMBIO">
		</cfif>
	</cfif>
<cfoutput>
<form action="Turnos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("Form.Turno_id") and isdefined("Form.Cambio") >
		<input name="Turno_id" type="hidden" value="#Form.Turno_id#">
	</cfif>
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>



