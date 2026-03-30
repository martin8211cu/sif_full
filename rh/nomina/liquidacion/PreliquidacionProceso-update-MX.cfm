<cfif isdefined("form.paso")>
	<cfswitch expression="#form.paso#"> 
		<cfcase value="0">
			<cfinclude template="PreliquidacionProceso-paso0-SQL#sufijo#.cfm">
		</cfcase>
		<cfcase value="1"> 
			<cfinclude template="PreliquidacionProceso-paso1-SQL#sufijo#.cfm">
		</cfcase> 
		<cfcase value="2">
			<cfinclude template="PreliquidacionProceso-paso2-SQL#sufijo#.cfm">
		</cfcase>
		<cfcase value="3">
			<cfinclude template="PreliquidacionProceso-paso3-SQL#sufijo#.cfm">
		</cfcase>
		<cfcase value="4">
			<cfinclude template="PreliquidacionProceso-paso4-SQL#sufijo#.cfm">
		</cfcase>
		<cfcase value="5">
			<cfinclude template="PreliquidacionProceso-paso5-SQL#sufijo#.cfm">
		</cfcase>	
	</cfswitch>
	<cfif isdefined("form.btnActulizar")>
		<cfquery name="rsUpdateD" datasource="#session.DSN#">
			select b.RHLPPid
			from RHPreLiquidacionPersonal a
			  inner join RHLiqIngresosPrev b
				on  a.Ecodigo = b.Ecodigo and a.DEid = b.DEid and a.RHPLPid = b.RHPLPid
			where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
			  and b.RHLPautomatico = 1
		</cfquery>
		<cfloop query="rsUpdateD">
			<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnCalculaEG">
				<cfinvokeargument name="RHLPPid" value="#rsUpdateD.RHLPPid#">
			</cfinvoke>
		</cfloop>
	</cfif>
	<cfif isdefined("form.btnFiniquito") and isdefined("form.RHLPPid") and len(trim(form.RHLPPid))>
		<cfquery datasource="#session.DSN#">
			update RHLiqIngresosPrev set RHLIFiniquito = case when coalesce(RHLIFiniquito,0) = 0 then 1 else 0 end
			where RHLPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHLPPid#">
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined('DLlinea') and len(trim(DLlinea)) gt 0>
	<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnEsPrimeraVez" returnvariable="esPrimera">
		<cfinvokeargument name="RHLPPid" 		value="#RHLPPid#">
	</cfinvoke>
	<cfif esPrimera>
		<cfquery datasource="#session.DSN#">
			update RHLiqIngresosPrev set RHLIFiniquito = b.CIlimitaconcepto
			from RHLiqIngresosPrev a
			inner join CIncidentes b
				on b.CIid = a.CIid
			where RHLPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHLPPid#">
		</cfquery>
	</cfif>
</cfif>