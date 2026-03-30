<cfset LvarMat = 1 * -1>
<cfoutput>#LvarMat#</cfoutput>


<cfquery name="rs" datasource="#session.dsn#">
select Ecodigo 
                       from RHPTUE 
                       where RHPTUEid = 10
</cfquery>
<cfdump var="#rs#">

<cfquery name="rsSueldoMensualLT" datasource="#session.DSN#">
    select LTsalario, LTdesde, LThasta
    from LineaTiempo a 
    where a.Ecodigo = 1181
    and a.DEid = 86486
    <!--- and '20000101' >= a.LTdesde
    <!--- and '#LvarFechaHasta#' <= a.LThasta --->
    and #now()# <= a.LThasta --->
</cfquery>
<cfdump var="#rsSueldoMensualLT#">

<cfquery name="rsSueldoMensualLT" datasource="#session.DSN#">
    select coalesce(max(LTsalario),0) as LTsalario
    from LineaTiempo a 
    where a.Ecodigo = 1181
    and a.DEid = 86486
    and '20090714' >= a.LTdesde
    <!--- and '#LvarFechaHasta#' <= a.LThasta --->
    and #now()# <= a.LThasta
</cfquery>

<cfdump var="#rsSueldoMensualLT#">