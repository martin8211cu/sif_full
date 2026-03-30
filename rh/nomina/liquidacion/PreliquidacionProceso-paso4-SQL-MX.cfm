<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		<cfif (isdefined("Form.Alta") or isdefined("Form.Cambio")) and isdefined("Form.Did") and Len(Trim(Form.Did))>
			<cfif isdefined("form.Dmetodo") and form.Dmetodo neq 0 >
				<cfquery name="rsDatosDeduccion" datasource="#Session.DSN#">
					select Ddescripcion, Dreferencia, SNcodigo, Dvalor
					from DeduccionesEmpleado
					where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Did#">
				</cfquery>
				<cfset Form.Ddescripcion = rsDatosDeduccion.Ddescripcion>
				<cfif Len(Trim(rsDatosDeduccion.Dreferencia))>
					<cfset Form.referencia = rsDatosDeduccion.Dreferencia>
				</cfif>
				<cfset Form.SNcodigo = rsDatosDeduccion.SNcodigo>
				<cfset Form.Ivalor = rsDatosDeduccion.Dvalor>
			<cfelse>
				<cfquery name="rsDatosDeduccion" datasource="#Session.DSN#">
					select sum(importe) as importe
					from RHLiqIngresosPrev
					where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
				</cfquery>
				<cfif len(trim(rsDatosDeduccion.importe)) and isdefined("form.RHLDporcentaje") and len(trim(form.RHLDporcentaje))>
					<cfset Form.Ivalor = rsDatosDeduccion.importe * (form.RHLDporcentaje/100) >
				<cfelse>
					<cfset Form.Ivalor = 0 >
				</cfif>
			</cfif>
		</cfif>
		<cfif isdefined("Form.Alta")>
			<cfquery name="RHLiqDeduccionPrev" datasource="#session.DSN#">
				insert into RHLiqDeduccionPrev (RHPLPid, DEid, Did, RHLDdescripcion, RHLDreferencia, SNcodigo, importe, BMUsucodigo, fechaalta, RHLDporcentaje)
				select 
					RHPLPid,
					DEid,
					<cfif isdefined("Form.Did") and Len(Trim(Form.Did))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.referencia#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.Ivalor#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfif isdefined("form.Dmetodo") and form.Dmetodo eq 0 and isdefined("form.RHLDporcentaje") and len(trim(form.RHLDporcentaje))>
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHLDporcentaje#">					
					<cfelse>
						null
					</cfif>
				from RHPreLiquidacionPersonal
				where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
			</cfquery>
		<cfelseif isdefined("Form.Baja")> 
			<cfquery name="delRHLiqDeduccionPrev" datasource="#Session.DSN#">
				delete RHLiqDeduccionPrev
				where RHLPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHLPDid#">
				and RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
			</cfquery>
			<cfset Form.Nuevo = "1">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="updRHConcursos" datasource="#Session.DSN#">
				update RHLiqDeduccionPrev set
					<cfif isdefined("Form.Did") and Len(Trim(Form.Did))>
						Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">,
					<cfelse>
						Did = null,
					</cfif>
					RHLDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddescripcion#">,
					RHLDreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.referencia#">,
					SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,
					importe = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.Ivalor#">,
					RHLDporcentaje = <cfif isdefined("form.Dmetodo") and form.Dmetodo eq 0 and isdefined("form.RHLDporcentaje") and len(trim(form.RHLDporcentaje)) ><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHLDporcentaje#"><cfelse>null</cfif>
					
				where RHLPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHLPDid#">
				and RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
			</cfquery>

		</cfif>
	</cfif>
</cftransaction>
