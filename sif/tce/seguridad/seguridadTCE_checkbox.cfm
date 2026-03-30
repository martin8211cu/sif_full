<cfparam name="Action" default="/cfmx/sif/imagenes/"/><!--- checked.gif unchecked.gif --->
<cfparam name="Url.CBDUid" type="numeric">
<cfparam name="Url.CBUid" type="numeric">
<cfparam name="Url.Who" type="string">
<cfparam name="Url.Var" type="numeric">
<cfquery datasource="#session.dsn#">
	Update CBDusuarioTCE 
	set #Url.Who# = case #Url.Var# when 0 then 1 else 0 end
	where CBDUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CBDUid#">
		and CBUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CBUid#">
</cfquery>
<cfquery name="rsQryChecked" datasource="#session.dsn#">
	select #Url.Who# as Checked
	from CBDusuarioTCE 
	where CBDUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CBDUid#">
		and CBUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CBUid#">
</cfquery>
<cflocation url="#Action##iif(rsQryChecked.Checked,DE('checked.gif'),DE('unchecked.gif'))#">