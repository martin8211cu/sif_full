<cfquery name="rs" datasource="#session.dsn#">
	select isnull(count(1),0) as cantidad
	from MEEntidad
	where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
	  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfquery name="rsMETE" datasource="#session.dsn#">
	select METEdesc 
	from METipoEntidad 
	where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
</cfquery>
<cfoutput>
<FONT face="arial, helvetica, verdana" size=2>Hoy en d&iacute;a cuenta con #rs.cantidad# #rsMETE.METEdesc#.</FONT>
</cfoutput>