<cfparam name="Action" default="/cfmx/sif/imagenes/"/><!--- checked.gif unchecked.gif --->
<cfparam name="Url.Usucodigo" type="numeric">
<cfparam name="Url.CPSUid" type="numeric">
<cfparam name="Url.ts_rversion" type="string">
<cfparam name="Url.Who" type="string">
<!---
<cf_dbtimestamp 
	datasource = "#session.dsn#"
	table = "CPSeguridadUsuario"
	redirect = "#Action#"
	timestamp = "#url.ts_rversion#"
	field1 = "Ecodigo"
	type1 = "integer"
	value1 = "#Session.Ecodigo#"
	field2 = "Usucodigo"
	type2 = "numeric"
	value2 = "#Url.Usucodigo#"
	field3 = "CPSUid"
	type3 = "numeric"
	value3 = "#Url.CPSUid#">
--->
<cfquery datasource="#session.dsn#">
	Update CPSeguridadUsuario 
	set #Url.Who# = case #Url.Who# when 0 then 1 else 0 end
	where Ecodigo = #Session.Ecodigo#
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.Usucodigo#">
		and CPSUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CPSUid#">
</cfquery>
<cfquery name="rsQryChecked" datasource="#session.dsn#">
	select #Url.Who# as Checked
	from CPSeguridadUsuario 
	where Ecodigo = #Session.Ecodigo#
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.Usucodigo#">
		and CPSUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CPSUid#">
</cfquery>
<cflocation url="#Action##iif(rsQryChecked.Checked,DE('checked.gif'),DE('unchecked.gif'))#">