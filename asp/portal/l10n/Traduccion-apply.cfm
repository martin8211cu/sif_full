<cftransaction>
	<cfquery datasource="sifcontrol" name="hay">
		select ltrim(rtrim(VSvalor)) as VSvalor
		from VSidioma
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Iid#">
		  and VSgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#VSgrupo#">
		order by VSvalor
	</cfquery>
	<cfset hay = ValueList(hay.VSvalor)>
	<cfloop list="#form.VSvalor#" index="VSvalor">
		<cfoutput>#VSvalor#=#form['valor_' & VSvalor]#<br></cfoutput>
		<cfif Not ListFind(hay, Trim(VSvalor))>
			<cfquery datasource="sifcontrol">
				insert into VSidioma ( Iid, VSgrupo, VSvalor, VSdesc )
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Iid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#VSgrupo#">,
					<cfqueryparam cfsqltype="cf_sql_char"    value="#VSvalor#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['valor_' & VSvalor]#"> )
			</cfquery>
		<cfelseif Len(Trim(form['valor_' & VSvalor]))> <!--- if hay --->
			<cfquery datasource="sifcontrol">
				update VSidioma
				set VSdesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['valor_' & VSvalor]#">
				where Iid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Iid#">
				  and VSgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#VSgrupo#">
				  and VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#VSvalor#">
			</cfquery>
		<cfelse> <!--- if hay --->
			<cfquery datasource="sifcontrol">
				delete from VSidioma
				where Iid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Iid#">
				  and VSgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#VSgrupo#">
				  and VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#VSvalor#">
			</cfquery>
		</cfif> <!--- if hay --->
	</cfloop><!--- form.VSvalor --->
</cftransaction>

<cfset params = '' >
<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))>
	<cfset params = params & '&SScodigo=#HTMLEditFormat(form.SScodigo)#' >
</cfif>
<cfif isdefined("form.SMcodigo") and len(trim(form.SMcodigo))>
	<cfset params = params & '&SMcodigo=#HTMLEditFormat(form.SMcodigo)#' >
</cfif>

<cflocation url="Traduccion.cfm?Iid=#HTMLEditFormat(form.redirIid)#&VSgrupo=#HTMLEditFormat(form.redirVSgrupo)##params#">
