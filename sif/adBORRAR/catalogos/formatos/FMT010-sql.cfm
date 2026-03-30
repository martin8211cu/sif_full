<cfif isDefined('form.btnAutomatico')>
	
	<cfquery datasource="sifcontrol" name="hdr">
		select FMT01SQL from FMT000
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
	</cfquery>
	<cfset my_query = hdr.FMT01SQL>
	<cfdump var="#my_query#">
	
	<cfset fld = REFind('##([^##]+)##',my_query,1,true)>
	
	<cfdump var="#fld#" label="fld">
	
	PANTALLA EN PROGRESO<br>&nbsp;&nbsp;&nbsp;-danim
	
	<cfabort>
	
	<cftransaction>
		<cfquery datasource="sifcontrol">
			delete from FMT010
			where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
		</cfquery>
		<cfset i = 0>
		<cfloop list="#resultados.columnlist#" index="column">
			<cfif UCase(column) neq 'TS_RVERSION'>
				<cfset i=i+1>
				<cfquery datasource="sifcontrol">
					insert into FMT010 (FMT00COD, FMT10LIN, FMT10TIP, FMT10PAR, FMT10DEF, FMT10LON)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#column#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#column#"> )
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
<cfelseif isdefined('form.btnGuardar')>
	<cfquery datasource="sifcontrol" name="cnt">
		select count(1) as cnt from FMT010
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
		  and FMT10LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LIN#">
	</cfquery>
	<cfif cnt.cnt is 1>
		<cfquery datasource="sifcontrol">
			update FMT010
			set FMT10TIP = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10TIP#">,
				FMT10PAR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT10PAR#">,
				FMT10DEF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT10DEF#">,
				FMT10LON = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LON#">
			where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
			  and FMT10LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LIN#">
		</cfquery>
	<cfelse>
		<cfquery datasource="sifcontrol">
			insert into FMT010 (FMT00COD, FMT10LIN, FMT10TIP, FMT10PAR, FMT10DEF, FMT10LON)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LIN#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10TIP#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT10PAR#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT10DEF#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LON#"> )
		</cfquery>
	</cfif>
<cfelseif isDefined('form.btnEliminar')>
	<cfquery datasource="sifcontrol">
		delete from FMT010
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
		  and FMT10LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LIN#">
	</cfquery>
</cfif>

<cflocation url="FMT000.cfm?FMT00COD=#URLEncodedFormat(form.FMT00COD)#">