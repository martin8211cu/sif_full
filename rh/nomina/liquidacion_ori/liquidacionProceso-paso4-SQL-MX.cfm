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
					from RHLiqIngresos
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
				</cfquery>
				<cfif len(trim(rsDatosDeduccion.importe)) and isdefined("form.RHLDporcentaje") and len(trim(form.RHLDporcentaje))>
					<cfset Form.Ivalor = rsDatosDeduccion.importe * (form.RHLDporcentaje/100) >
				<cfelse>
					<cfset Form.Ivalor = 0 >
				</cfif>
			</cfif>
		</cfif>
		<cfif isdefined("Form.Alta")>
			<cfquery name="RHLiqDeduccion" datasource="#session.DSN#">
				insert into RHLiqDeduccion (DLlinea, DEid, Did, RHLDdescripcion, RHLDreferencia, SNcodigo, importe, BMUsucodigo, fechaalta, RHLDporcentaje)
				select 
					DLlinea,
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
				from RHLiquidacionPersonal
				where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
			</cfquery>
		<cfelseif isdefined("Form.Baja")> 
			<cfquery name="delRHLiqDeduccion" datasource="#Session.DSN#">
				delete RHLiqDeduccion
				where RHLDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHLDid#">
				and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
			</cfquery>
			<cfset Form.Nuevo = "1">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="updRHConcursos" datasource="#Session.DSN#">
				update RHLiqDeduccion set
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
					
				where RHLDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHLDid#">
				and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
			</cfquery>

		</cfif>
	</cfif>
</cftransaction>
