<!----////////////////////////// INSERTAR NUEVO COMPONENTE, ELIMINAR UNO, O MODIFICAR////////////////////////////////////----->
<cfoutput>
<!---Insertado de nuevo componente salarial---->
<cfif isdefined("form.RHEid") and len(trim(form.RHEid)) and isdefined("form.RHSAid") and len(trim(form.RHSAid))>
	<!---Inserta componente nuevo---->
	<cfif isdefined("form.btn_nuevo")>	
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cftransaction>
			<cfquery name="rsMoneda" datasource="#session.DSN#">
				select Mcodigo
				from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="Inserta" datasource="#session.DSN#">
				insert into RHCSituacionActual(RHSAid, 
												CSid, 
												Ecodigo, 
												Cantidad, 
												Monto,
												CFformato, 
												BMfecha, 
												BMUsucodigo)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_float" value="#form.CantidadNuevo#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.MontoNuevo,',','','all')#">,
							 <cfif isdefined("form.CScomplemento") and len(trim(form.CScomplemento))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CScomplemento#"><cfelse>null</cfif>,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							)
			</cfquery>	
		</cftransaction>	
	<!----Modificacion de montos------>
	<cfelseif isdefined("form.btn_guardar") and isdefined("form.RHCSAid") and len(trim(form.RHCSAid))>
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cftransaction>
			<cfloop list="#form.RHCSAid#" index="i">				
				<cfif isdefined("form.Monto_#i#") and len(trim(form['Monto_#i#']))>
					<cfquery datasource="#session.DSN#">
						update RHCSituacionActual 
							set Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['Monto_#i#'],',','','all')#">						
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHCSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">						
					</cfquery>
				</cfif>
			</cfloop>
		</cftransaction>		
	<!----Borrado de componente---->
	<cfelseif isdefined("form.RHCSAidEliminar") and len(trim(form.RHCSAidEliminar))>
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cftransaction>
			<cfquery name="Delete" datasource="#session.DSN#">
				delete from RHCSituacionActual
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHCSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCSAidEliminar#">	
			</cfquery>
		</cftransaction>
	<!---Actualizar datos del encabezado---->
	<cfelseif isdefined("form.btn_modificar") and isdefined("form.RHSAid") and len(trim(form.RHSAid))>
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cftransaction>
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios	
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfquery name="rsUpdateEncabezado" datasource="#session.DSN#">
			update RHSituacionActual
				set RHTTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">,
					RHCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">,
					RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">,
					RHMPestadoplaza = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHMPestadoplaza#">,
					fdesdeplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fdesdeplaza#">,
					fhastaplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fhastaplaza#">,
					CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">		
		</cfquery>
		<cfset lvarExiste = true>
		<cfset i = 1>
		<cfloop  condition="#lvarExiste#">
			<cfif isdefined('RHCSAid_#i#')>
				<cfset lvarRHCSAid = evaluate('RHCSAid_#i#')>
				<cfset lvarMonto = evaluate('MontoRes_#i#')>
				<cfquery datasource="#session.dsn#">
					update RHCSituacionActual set
						Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(lvarMonto,',','','all')#">
					where RHCSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHCSAid#">
				</cfquery>
			<cfelse>
				<cfset lvarExiste = false>
			</cfif>
			<cfset i = i + 1>
		</cfloop>
		</cftransaction>	
	</cfif>	
</cfif>	
<form action="SA-ComponentePlazas.cfm" method="post" name="sql">
	<cfif isdefined("form.RHEid") and Len(Trim(form.RHEid))>
		<input name="RHEid" type="hidden" value="#Form.RHEid#">
	</cfif>
	<cfif isdefined("form.RHSAid") and Len(Trim(form.RHSAid))>
		<input name="RHSAid" type="hidden" value="#Form.RHSAid#">
	</cfif>	
</form>
</cfoutput>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

