<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		 <cfif isdefined("Form.Alta")>
			<cfquery name="rsRHLiqCargas" datasource="#session.DSN#">
				insert into RHLiqCargasPrev (RHPLPid, DEid, DClinea, SNcodigo, Ecodigo, RHLCdescripcion, importe, fechaalta, RHLCautomatico, BMUsucodigo)
				select 
					RHPLPid,
					DEid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">,
					0,
					Ecodigo,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.Ivalor#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from RHPreLiquidacionPersonal 
				where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
			</cfquery>

		<cfelseif isdefined("Form.Baja")> 
			<cfquery name="delRHLiqCargas" datasource="#Session.DSN#">
				delete RHLiqCargas
				where RHLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHLCid#">
				and RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
			</cfquery>
			<cfset Form.Nuevo = "1">
			
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="updRHConcursos" datasource="#Session.DSN#">
				update RHLiqCargas set
					importe = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.Ivalor#">
				where RHLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHLCid#">
				and RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
			</cfquery>
			
		<cfelseif isdefined("Form.Calcular")>
			<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnExisteLF" returnvariable="existeLF">
				<cfinvokeargument name="RHPLPid" value="#form.RHPLPid#">
				<cfinvokeargument name="DEid" value="#form.DEid#">
			</cfinvoke>
			<cfif not existeLF>
				<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnAltaLF">
					<cfinvokeargument name="RHPLPid" 				value="#form.RHPLPid#">
					<cfinvokeargument name="DEid" 					value="#form.DEid#">
					<cfinvokeargument name="RHLFLtGrabadoF" 	 	value="#form.MontoGrabadoF#">
					<cfinvokeargument name="RHLFLtExentoF" 	 		value="#form.MontoExentoF#">
					<cfinvokeargument name="RHLFLisptF" 	 		value="#form.ISPTF#">
					<cfinvokeargument name="RHLFLinfonavit" 	 	value="#form.Infonavit#">
					<cfinvokeargument name="RHLFLtotalL" 	 		value="#form.TotalL#">
					<cfinvokeargument name="RHLFLsalarioMensual" 	value="#form.SalarioMensual#">
					<cfinvokeargument name="RHLFLisptSalario" 		value="#form.ISPTSL#">
					<cfinvokeargument name="RHLFLisptL" 	 		value="#form.ISPTL#">
					<cfinvokeargument name="RHLFLresultado" 	 	value="#form.Neto#">
                    <cfinvokeargument name="RHLFLISPTRealL" 	 	value="#form.ISPTRealL#">
				</cfinvoke>
			</cfif>
		<cfelseif isdefined("Form.Recalcular")>
			<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnCambioLF">
				<cfinvokeargument name="RHPLPid" 				value="#form.RHPLPid#">
				<cfinvokeargument name="DEid" 					value="#form.DEid#">
				<cfinvokeargument name="RHLFLtGrabadoF" 	 	value="#form.MontoGrabadoF#">
				<cfinvokeargument name="RHLFLtExentoF" 	 		value="#form.MontoExentoF#">
				<cfinvokeargument name="RHLFLisptF" 	 		value="#form.ISPTF#">
				<cfinvokeargument name="RHLFLinfonavit" 	 	value="#form.Infonavit#">
				<cfinvokeargument name="RHLFLtotalL" 	 		value="#form.TotalL#">
				<cfinvokeargument name="RHLFLsalarioMensual" 	value="#form.SalarioMensual#">
				<cfinvokeargument name="RHLFLisptSalario" 		value="#form.ISPTSL#">
				<cfinvokeargument name="RHLFLisptL" 	 		value="#form.ISPTL#">
				<cfinvokeargument name="RHLFLresultado" 	 	value="#form.Neto#">
                <cfinvokeargument name="RHLFLISPTRealL" 		value="#form.ISPTRealL#">
			</cfinvoke>
		</cfif>
	
	</cfif>
</cftransaction>
