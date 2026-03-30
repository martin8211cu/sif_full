<cfquery name="rs" datasource="#session.DSN#">
	set nocount on
	update ConceptosTipoAccion
	set CTAsalario = case CTAsalario when 1 then 0 when 0 then 1 end
	where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid#">
	  and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTid#">

	select CTAsalario 
	from ConceptosTipoAccion
	where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid#">
	  and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTid#">
	set nocount off
</cfquery>

<cfif rs.CTAsalario eq 0 >
	<cflocation url="/cfmx/rh/imagenes/checked.gif">
<cfelse>	
	<cflocation url="/cfmx/rh/imagenes/unchecked.gif">
</cfif>