<cfif isdefined("form.paso")>
	<cfswitch expression="#form.paso#"> 
		<cfcase value="0">
			<cfinclude template="liquidacionProceso-paso0-SQL#sufijo#.cfm">
		</cfcase>
		<cfcase value="1"> 
			<cfinclude template="liquidacionProceso-paso1-SQL#sufijo#.cfm">
		</cfcase> 
		<cfcase value="2">
			<cfinclude template="liquidacionProceso-paso2-SQL#sufijo#.cfm">
		</cfcase>
		<cfcase value="3">
			<cfinclude template="liquidacionProceso-paso3-SQL#sufijo#.cfm">
		</cfcase>
		<cfcase value="4">
			<cfinclude template="liquidacionProceso-paso4-SQL#sufijo#.cfm">
		</cfcase>
		<cfcase value="5">
			<cfinclude template="liquidacionProceso-paso5-SQL#sufijo#.cfm">
		</cfcase>	
	</cfswitch>
	<cfif isdefined("form.btnActulizar")>
    	<!---<cf_dump var = "#form#">--->
        <!---SML. Inicio Hacer un update para registrar la Causa del Finiquito--->
        <cfquery name="rsUpdateD" datasource="#session.DSN#">
			update RHLiquidacionPersonal 
            set RHLPCausa = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CausaBaja#">
			where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
		</cfquery>
        <!---SML. Fin Hacer un update para registrar la Causa del Finiquito--->
        
		<cfquery name="rsUpdateD" datasource="#session.DSN#">
			select b.RHLPid
			from RHLiquidacionPersonal a
			  inner join RHLiqIngresos b
				on  a.Ecodigo = b.Ecodigo and a.DEid = b.DEid and a.DLlinea = b.DLlinea
			where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
			  and b.RHLPautomatico = 1
		</cfquery>
		<cfloop query="rsUpdateD">
			<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnCalculaEG">
				<cfinvokeargument name="RHLPid" value="#rsUpdateD.RHLPid#">
			</cfinvoke>
		</cfloop>
                
	</cfif>
	<cfif isdefined("form.btnFiniquito") and isdefined("form.RHLPid") and len(trim(form.RHLPid))>
		<cfquery datasource="#session.DSN#">
			update RHLiqIngresos set RHLIFiniquito = case when RHLIFiniquito = 0 then 1 else 0 end
			where RHLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHLPid#">
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined('DLlinea') and len(trim(DLlinea)) gt 0>
	<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnEsPrimeraVez" returnvariable="esPrimera">
		<cfinvokeargument name="DLlinea" 		value="#DLlinea#">
	</cfinvoke>
	<cfif esPrimera>
		<cfquery datasource="#session.DSN#">
			update RHLiqIngresos set RHLIFiniquito = b.CIlimitaconcepto
			from RHLiqIngresos a
			inner join CIncidentes b
				on b.CIid = a.CIid
			where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
		</cfquery>
	</cfif>
</cfif>