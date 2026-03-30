<cfparam name="Action" default="/cfmx/sif/imagenes/"/><!--- checked.gif unchecked.gif --->
<cfparam name="Url.Usucodigo" type="numeric">
<cfparam name="Url.CPSMid" type="numeric">
<cfparam name="Url.ts_rversion" type="string">
<cfparam name="Url.Who" type="string">
<!---
<cf_dbtimestamp 
	datasource = "#session.dsn#"
	table = "CPSeguridadMascarasCtasP"
	redirect = "#Action#"
	timestamp = "#url.ts_rversion#"
	field1 = "Ecodigo"
	type1 = "integer"
	value1 = "#Session.Ecodigo#"
	field2 = "Usucodigo"
	type2 = "numeric"
	value2 = "#Url.Usucodigo#"
	field3 = "CPSMid"
	type3 = "numeric"
	value3 = "#Url.CPSMid#">
--->
<cfquery datasource="#session.dsn#">
	Update CPSeguridadMascarasCtasP 
	set #Url.Who# = case #Url.Who# when 0 then 1 else 0 end
	where Ecodigo = #Session.Ecodigo#
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.Usucodigo#">
		and CPSMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CPSMid#">
</cfquery>
<cfquery name="rsQryChecked" datasource="#session.dsn#">
	select #Url.Who# as Checked
	from CPSeguridadMascarasCtasP 
	where Ecodigo = #Session.Ecodigo#
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.Usucodigo#">
		and CPSMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CPSMid#">
</cfquery>
<cflocation url="#Action##iif(rsQryChecked.Checked,DE('checked.gif'),DE('unchecked.gif'))#">