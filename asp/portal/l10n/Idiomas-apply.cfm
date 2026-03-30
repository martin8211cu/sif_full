

<cfif IsDefined("form.Cambio")>
	
	
	
	
	
	
	
	
	
	
	
	
		
		
	
		<cf_dbtimestamp datasource="sifcontrol"
				table="Idiomas"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="Iid"
				type1="numeric"
				value1="#form.Iid#"
			
		>
	
	<cfquery datasource="sifcontrol">
		update Idiomas
		set Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#" null="#Len(form.Icodigo) Is 0#">
		, Descripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Descripcion#" null="#Len(form.Descripcion) Is 0#">
		, Inombreloc = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Inombreloc#" null="#Len(form.Inombreloc) Is 0#">
		
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#" null="#Len(form.Iid) Is 0#">
	</cfquery>

	<cflocation url="Idiomas.cfm?Iid=#URLEncodedFormat(form.Iid)#">

<cfelseif IsDefined("form.Baja")>
	
	<cfquery datasource="sifcontrol">
		delete from VSidioma
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#" null="#Len(form.Iid) Is 0#">
	</cfquery>
	
	<cfquery datasource="sifcontrol">
		delete from Idiomas
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#" null="#Len(form.Iid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cftransaction action="begin">
		<cfquery datasource="sifcontrol">
			insert into Idiomas (
				Icodigo,
				Descripcion,
				Inombreloc)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#" null="#Len(form.Icodigo) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Descripcion#" null="#Len(form.Descripcion) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Inombreloc#" null="#Len(form.Inombreloc) Is 0#">)
		</cfquery>
		<cfquery datasource="sifcontrol">
			insert into VSidioma (Iid, VSgrupo, VSvalor, VSdesc)
			select i.Iid, v.VSgrupo, v.VSvalor, v.VSdesc
			from Idiomas i, VSidioma v
			where i.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#" null="#Len(form.Icodigo) Is 0#">
			   and v.Iid = 1
			   and not exists (
			  select 1
			  from VSidioma v2
			  where v2.Iid = i.Iid
				 and v2.VSgrupo = v.VSgrupo 
			 )
		 </cfquery>
		 <cftransaction action="commit">
	 </cftransaction>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="Idiomas.cfm">


