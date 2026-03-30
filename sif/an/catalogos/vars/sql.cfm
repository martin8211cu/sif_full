<cfif isdefined("form.alta")>
	<cfquery name="rssql" datasource="#session.dsn#">
		insert into AnexoVar
		(CEcodigo, Ecodigo, AVnombre, AVdescripcion, AVtipo, AVusar_oficina, AVvalor_anual, AVvalor_arrastrar, BMfecha, BMUsucodigo)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AVnombre#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AVdescripcion#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.AVtipo#">, 
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.AVusar_oficina')#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.AVvalor_anual')#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.AVvalor_arrastrar')#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelseif isdefined("form.cambio")>
	<cf_dbtimestamp
				datasource="#session.dsn#"
				table="AnexoVar" 
				redirect="index.cfm?AVid=#form.AVid#"
				timestamp="#form.ts_rversion#"
				field1="CEcodigo,numeric,#session.cecodigo#"
				field2="Ecodigo,numeric,#session.ecodigo#"
				field3="AVid,numeric,#form.AVid#">
	<cftransaction>
		<cfquery name="rssql" datasource="#session.dsn#">
			update AnexoVar
			set AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AVnombre#">,
				AVdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AVdescripcion#">,
				AVtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.AVtipo#">,
				AVusar_oficina = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.AVusar_oficina')#">,
				AVvalor_anual = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.AVvalor_anual')#">,
				AVvalor_arrastrar = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.AVvalor_arrastrar')#">,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
			and AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AVid#">
		</cfquery>
<cfelseif isdefined("form.baja")>
	<cfquery name="rssql" datasource="#session.dsn#">
		delete from AnexoVar 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
			and AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AVid#">
	</cfquery>
</cfif>
<cflocation url="index.cfm">