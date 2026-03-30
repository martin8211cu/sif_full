<cftransaction >
<cfquery datasource="#session.dsn#" name="rss">
	insert into DatosEmpleado (Ecodigo,DEsexo,DEcantdep,DEsistema,DEidentificacion,DEnombre,DEcivil,DEfechanac,DETipoAnticipo)
	values(1268,'F',1,1,'21213','fred',1,getdate(),1)
	<cf_dbidentity1>
</cfquery>

<cf_dbidentity2 name="rss">
<cfdump var="#rss#">

<cfquery datasource="#session.dsn#" name="rs">
select max(DEid)  from DatosEmpleado
</cfquery>
<cfdump var="#rs#">

<cfquery datasource="#session.dsn#" name="rs">
select DEid,Ecodigo,DEsexo,DEcantdep,DEsistema,DEidentificacion,DEnombre,DEcivil,DEfechanac,DETipoAnticipo
from DatosEmpleado where DEid= #rss.identity#
</cfquery>
<cfdump var="#rs#">

<cfquery datasource="#session.dsn#" name="rs">

select max(bitacoraid) from MonBitacora
</cfquery>
<cfdump var="#rs#">

<cfquery datasource="#session.dsn#" name="rs">
select max(bitacoraid) from aspmonitor..MonBitacora
</cfquery>
<cfdump var="#rs#">
<cfabort>
</cftransaction>