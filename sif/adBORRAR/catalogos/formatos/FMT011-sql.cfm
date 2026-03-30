<cfif isDefined('form.probar_ds') and Len(form.probar_ds)>
	
	<cfquery datasource="sifcontrol" name="hdr">
		select FMT01SQL from FMT000
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
	</cfquery>

	<cfset my_query = hdr.FMT01SQL>

	<cfquery datasource="sifcontrol" name="rsFMT010">
		select FMT10PAR, FMT10TIP, FMT10DEF from FMT010
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
	</cfquery>
	
	<cfoutput query="rsFMT010">
		<cfif rsFMT010.FMT10TIP EQ "0">
			<cfif rsFMT010.FMT10DEF EQ "">
				<cfset LvarDefault = "'X'">
			<cfelse>
				<cfset LvarDefault = "'#rsFMT010.FMT10DEF#'">
			</cfif>
			<cfset my_query = ReplaceNoCase (my_query,"'##" & rsFMT010.FMT10PAR & "##'", LvarDefault, "ALL")>
		<cfelseif rsFMT010.FMT10TIP EQ "1">
			<cfif rsFMT010.FMT10DEF EQ "">
				<cfset LvarDefault = "0">
			<cfelse>
				<cfset LvarDefault = "#rsFMT010.FMT10DEF#">
			</cfif>
		<cfelseif rsFMT010.FMT10TIP EQ "2">
			<cfif rsFMT010.FMT10DEF EQ "">
				<cf_dbfunction name="to_date" args="'01/01/2000'">
			<cfelse>
				<cf_dbfunction name="to_date" args="'#rsFMT010.FMT10DEF#'">
			</cfif>
		</cfif>
		<cfset my_query = ReplaceNoCase (my_query, "##" & rsFMT010.FMT10PAR & "##", LvarDefault, "ALL")>
	</cfoutput>
	
	<cftransaction>
		<cfquery datasource="#form.probar_ds#" name="resultados">
			#PreserveSingleQuotes(my_query)#
		</cfquery>
		<cftransaction action="rollback">
	</cftransaction>
	
	<cftransaction>
		<cfquery datasource="sifcontrol">
			delete from FMT011
			where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
		</cfquery>

 		<cfset i = 0>

		<cfquery name="rsFMT011" datasource="sifcontrol">
			select FMT11NOM
			  from FMT011
			where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
		</cfquery>

 		<cfset i = rsFMT011.recordCount>

		<cfloop list="#resultados.columnlist#" index="column">
			<cfif UCase(column) neq 'TS_RVERSION'>
			
				<cfset column_pos = FindNoCase(column, my_query)>
				<cfif column_pos>
					<cfset column_name = Mid(my_query, column_pos, Len(column))>
				</cfif>
			
				<cfset tipo = 0><!--- texto --->
				<cfif ListFindNoCase('numeric,integer,float,real,decimal,smallint,tinyint,bit', resultados.getColumnTypeName(resultados.findColumn(column)))>
					<cfset tipo = 1>
				<cfelseif ListFindNoCase('time,datetime,timestamp,time,smalldatetime', resultados.getColumnTypeName(resultados.findColumn(column)))>
					<cfset tipo = 2>
				</cfif>
				<cfif ListFindNoCase(ValueList(rsFMT011.FMT11NOM), column_name) EQ 0>
					<cfset i=i+1>
					<cfquery datasource="sifcontrol">
						insert into FMT011 (FMT00COD, FMT02SQL, FMT10TIP, FMT11NOM, FMT11DES)
						values (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#tipo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#column_name#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#column_name#"> )
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
	
<cfelseif isdefined('form.btnGuardar')>
	<cfquery datasource="sifcontrol" name="cnt">
		select count(1) as cnt from FMT011
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
		  and FMT02SQL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT02SQL#">
	</cfquery>
	<cfif cnt.cnt is 1>
		<cfquery datasource="sifcontrol">
			update FMT011
			set FMT10TIP = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10TIP#">,
				FMT11NOM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT11NOM#">,
				FMT11DES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT11DES#">
			where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
			  and FMT02SQL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT02SQL#">
		</cfquery>
	<cfelse>
		<cfquery datasource="sifcontrol">
			insert into FMT011 (FMT00COD, FMT02SQL, FMT10TIP, FMT11NOM, FMT11DES)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT02SQL#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10TIP#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT11NOM#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT11DES#"> )
		</cfquery>
	</cfif>
	<cfif isdefined("form.FMT11CNT")>
		<cfquery datasource="sifcontrol">
			update FMT011
			set FMT11CNT = 
					case when FMT02SQL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT02SQL#"> 
							then 1 
							else 0
					end
			where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
		</cfquery>
	</cfif>
<cfelseif isDefined('form.btnEliminar')>
	<cfquery datasource="sifcontrol">
		delete from FMT011
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#">
		  and FMT02SQL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT02SQL#">
	</cfquery>
</cfif>

<cflocation url="FMT000.cfm?FMT00COD=#URLEncodedFormat(form.FMT00COD)#">