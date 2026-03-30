<cfquery datasource="sifinterfaces">
delete
from PMIINT_ID10
where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

delete
from PMIINT_IE10
where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

delete
from PMIINT_ID10
where FechaRegistro < <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">

delete
from PMIINT_IE10
where FechaRegistro < <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
</cfquery>