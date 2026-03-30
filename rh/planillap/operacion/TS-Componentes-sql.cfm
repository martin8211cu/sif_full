
<cftransaction>
	<cfif isdefined("form.btn_nuevo")>			
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfquery name="rsMoneda" datasource="#session.DSN#">
			select Mcodigo
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery name="Inserta" datasource="#session.DSN#">
			insert into RHDTablasEscenario (Ecodigo, 
											RHETEid, 
											RHEid, 
											RHTTid, 
											RHMPPid, 
											RHCid, 
											CSid, 
											RHDTEmonto, 
											Mcodigo, 
											RHDTEfdesde, 
											RHDTEfhasta, 
											BMfecha, 
											BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHETEid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
						 <cfqueryparam cfsqltype="cf_sql_money" value="#form.RHDTEmontoNuevo#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fdesdeNuevo#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fhastaNuevo#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						)
		</cfquery>	
	<cfelseif isdefined("form.btn_modifica")>
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfloop list="#form.RHDTEid#" index="i">
			<cfquery datasource="#session.DSN#">
				update RHDTablasEscenario 
					set RHDTEmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['RHDTEmonto_#i#'],',','','all')#">
					<cfif isdefined("form.fdesde_#i#") and len(trim(form['fdesde_#i#']))>
						, RHDTEfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form['fdesde_#i#']#">
					</cfif>
					<cfif isdefined("form.fhasta_#i#") and len(trim(form['fhasta_#i#']))>
						, RHDTEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form['fhasta_#i#']#">
					</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHDTEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
		</cfloop>		
	</cfif>
</cftransaction>


<script language="JavaScript1.2" type="text/javascript">
</script>
<form action="" method="post" name="sql">
	<cfif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
		<input name="PageNum" type="hidden" value="#Form.PageNum#">
	</cfif>
</form>


<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

