<cfset modo = 'ALTA'>
<!--- 
<cf_dump var="#form#">
<cf_dump var="#url#">
 --->

<cftry> 
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<!--- Si ya existe un registro con AFRdescripcion no permite insertarlo --->
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select AFRdescripcion
				from AFRetiroCuentas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
				  and upper(AFRdescripcion) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(Form.AFRdescripcion))#"> 
			</cfquery>	
	
			<cfset valido = true>
			<cfif #rsVerifica.recordCount# eq 0>	
				<!--- Si viene definido revisa que no exista. --->
				<cfif isDefined("form.AFRmotivo") and len(trim(form.AFRmotivo))>					
					<cfquery name="rsExiste" datasource="#session.DSN#">
						select AFRmotivo
						from AFRetiroCuentas 
						where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and AFRmotivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFRmotivo#">
					</cfquery>
					<cfif #rsExiste.recordCount# eq 0>
						<cfset vAFRmotivo = #form.AFRmotivo#>
					<cfelse>
						<cfset valido = false>
						<cf_errorCode	code = "50037" msg = "No se puede agregar. Ya existe un motivo de retiro asignado.">
					</cfif>
				<cfelse>
					<!--- Obtiene el consecutivo. --->
					<cfquery name="data" datasource="#session.DSN#">
						select max(AFRmotivo) as AFRmotivo
						from AFRetiroCuentas 
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif data.RecordCount gt 0 and len(trim(data.AFRmotivo))>
						<cfset vAFRmotivo = data.AFRmotivo + 1>
					<cfelse>
						<cfset vAFRmotivo = 1>
					</cfif>				
				</cfif>
				
				<cfif valido>
					<cftransaction>			
						<cfquery name="inserta" datasource="#session.DSN#">
							insert into AFRetiroCuentas(Ecodigo, AFRmotivo, AFRdescripcion, AFRgasto, AFRingreso, AFRtransito, AFResventa)
							values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#vAFRmotivo#" >,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.AFRdescripcion#" >,
									<cfif isdefined("Form.Ccuenta1") and len(trim(Form.Ccuenta1))>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta1#" >,
									<cfelse>
										null,
									</cfif>
									<cfif isdefined("Form.Ccuenta2") and len(trim(Form.Ccuenta2))>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta2#" >,
									<cfelse>
										null,
									</cfif>	
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta0#" >,
									<cfif isdefined("Form.AFResventa")>'S'<cfelse>'N'</cfif>
							)
						</cfquery>	
					</cftransaction>
					<cfset Form.AFRmotivo = #vAFRmotivo#>
					<cfset modo="CAMBIO">
				</cfif>
			<cfelse>
				<cf_errorCode	code = "50037" msg = "No se puede agregar. Ya existe un motivo de retiro asignado.">
			</cfif>			
				
		<cfelseif isdefined("Form.Baja")>
			<cfset form.AFRmotivo = #form.AFRmotivoL#>
			<cfquery name="delete" datasource="#session.DSN#">
				delete from AFRetiroCuentas
				where Ecodigo 	= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and AFRmotivo = <cfqueryparam value="#Form.AFRmotivoL#" cfsqltype="cf_sql_integer">
			</cfquery> 
			<cfset modo="ALTA">
	
		<cfelseif isdefined("Form.Cambio")>
			<!--- Si ya existe o soy yo mismo entonces permite modificarlo --->
			<cfset form.AFRmotivo = #form.AFRmotivoL#>
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select AFRdescripcion
				from AFRetiroCuentas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
				  and upper(AFRdescripcion) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.AFRdescripcion))#"> 
				  and upper(AFRdescripcion) <> <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.AFRdescripcionL))#"> 
			</cfquery>	
			<cfif #rsVerifica.recordCount# eq 0>	
				<cf_dbtimestamp datasource="#session.dsn#"
								table="AFRetiroCuentas"
								redirect="AFCuentasRet.cfm"
								timestamp="#form.ts_rversion#"
								field1="AFRmotivo" 
								type1="integer" 
								value1="#form.AFRmotivoL#"
								field2="Ecodigo" 
								type2="integer" 
								value2="#session.Ecodigo#"
								>
		
				<cfquery name="update" datasource="#session.DSN#">
					update AFRetiroCuentas
					set AFRdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.AFRdescripcion#">,
						<cfif isdefined("Form.Ccuenta1") and len(trim(Form.Ccuenta1))>
							AFRgasto			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta1#">,
						<cfelse>
							AFRgasto			= null,
						</cfif>
						<cfif isdefined("Form.Ccuenta2") and len(trim(Form.Ccuenta2))>
							AFRingreso			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta2#">,
						<cfelse>
							AFRingreso			= null,
						</cfif>
						AFRtransito			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta0#">,
						AFResventa		= <cfif isdefined("Form.AFResventa") and len(trim(Form.AFResventa)) gt 0 >'S'<cfelse>'N'</cfif>
					where Ecodigo			= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and AFRmotivo		= <cfqueryparam value="#Form.AFRmotivoL#" cfsqltype="cf_sql_integer">
				</cfquery>	  
				<cfset modo="CAMBIO">
			<cfelse>
				<cf_errorCode	code = "50038" msg = "No se puede modificar. Ya existe un motivo de retiro asignado.">
			</cfif>
		</cfif>
	</cfif>
	
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>


<form action="AFCuentasRet.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="AFRmotivo" type="hidden" value="<cfif isdefined("Form.AFRmotivo")>#Form.AFRmotivo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

