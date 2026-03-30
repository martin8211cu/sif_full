<cfif Len(form.modalidad)>
	<cfquery datasource="asp" name="existe">
		select 1 from
		CatalogoEmpresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		  and tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tabla#" null="#Len(form.tabla) Is 0#">
	</cfquery>
	<cfif existe.RecordCount>
		<cf_dbtimestamp datasource="asp"
				table="CatalogoEmpresa"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="Ecodigo"
				type1="numeric"
				value1="#form.Ecodigo#"
			
				field2="tabla"
				type2="char"
				value2="#form.tabla#">
		<cfquery datasource="asp">
			update CatalogoEmpresa
			set modalidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.modalidad#" null="#Len(form.modalidad) Is 0#">
			, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
			  and tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tabla#" null="#Len(form.tabla) Is 0#">
		</cfquery>
	<cfelse>
		<cfquery datasource="asp">
			insert into CatalogoEmpresa (			
				Ecodigo,
				tabla,
				modalidad,
				BMfecha,
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.tabla#" null="#Len(form.tabla) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.modalidad#" null="#Len(form.modalidad) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		</cfquery>
	</cfif>	
<cfelse>
	<cfquery datasource="asp">
		delete from CatalogoEmpresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		  and tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tabla#" null="#Len(form.tabla) Is 0#">
	</cfquery>
</cfif>
<cflocation url="CatalogoEmpresa.cfm?selCEcodigo=#URLEncodedFormat(form.CEcodigo)#&selEcodigo=#URLEncodedFormat(form.Ecodigo)#&tabla=#URLEncodedFormat(form.tabla)#">
