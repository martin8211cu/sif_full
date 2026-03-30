<cfif not isdefined("form.nuevo")>
	<cfif isdefined("form.btnAgregar")>
		<cfquery name="insert" datasource="#session.DSN#">
			insert into FMT010(FMT01COD, FMT10LIN, FMT10PAR, FMT10TIP, FMT10LON, FMT10DEF)
			values( <cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01COD#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LIN#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT10PAR#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10TIP#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LON#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT10DEF#">
				  )
		</cfquery>
	<cfelseif isdefined("form.btnModificar")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="FMT010" 
			redirect="FMTParametros.cfm"
			timestamp="#form.ts_rversion#"
			field1="FMT01COD,char,#Form.FMT01COD#"
			field2="FMT10LIN,integer,#form.FMT10LIN#">
		<cfquery name="update" datasource="#session.DSN#">
			update FMT010 
			set FMT10PAR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT10PAR#">,
				FMT10TIP = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10TIP#">,
				FMT10LON = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LON#">,
				FMT10DEF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT10DEF#">
			where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01COD#">
			  and FMT10LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LIN#">
		</cfquery>
	<cfelseif isdefined("form.btnEliminar")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from FMT010 
			where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01COD#">
			  and FMT10LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LIN#">
		</cfquery>
	</cfif>
</cfif>

<cflocation url="FMTParametros.cfm?FMT01COD=#form.FMT01COD#">