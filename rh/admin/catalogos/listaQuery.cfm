?<cfdump var="#url#">

<cfquery name="updLista1" datasource="#session.DSN#">
	select DFEorden as o1
	from DFormatosExpediente
	where DFElinea = #url.llave1#
</cfquery>
<cfquery name="updLista2" datasource="#session.DSN#">
	select DFEorden as o2
	from DFormatosExpediente
	where DFElinea = #url.llave2#
</cfquery>
<cfquery name="updLista" datasource="#session.DSN#">
	update DFormatosExpediente 
		set DFEorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#updLista2.o2#"> 
	where DFElinea = #url.llave1#
</cfquery>
<cfquery name="updLista" datasource="#session.DSN#">
	update DFormatosExpediente 
		set DFEorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#updLista1.o1#"> 
	where DFElinea = #url.llave2#
</cfquery>
<!----
<cfquery name="updLista" datasource="#session.DSN#">
	set nocount on
	declare @cont int, @o1 int, @o2 int

	select @o1 = DFEorden 
	from DFormatosExpediente
	where DFElinea = #url.llave1#

	select @o2 = DFEorden 
	from DFormatosExpediente
	where DFElinea = #url.llave2#

	update DFormatosExpediente set DFEorden = @o2
	where DFElinea = #url.llave1#

	update DFormatosExpediente set DFEorden = @o1
	where DFElinea = #url.llave2#

	set nocount off
</cfquery>
---->

