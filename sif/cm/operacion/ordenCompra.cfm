<cfset lvarProvCorp = false>
<cfif isdefined("form.Ecodigo_f") and #form.Ecodigo_f# neq "">
	<cfset lvarFiltroEcodigo = form.Ecodigo_f>
<cfelse>
	<cfset lvarFiltroEcodigo = session.Ecodigo>
</cfif>
<!--- Verifica si esta activa la Probeduria Corporativa --->
<cfparam  name="lvarFiltroEcodigo" default="#session.Ecodigo#">
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo=#session.Ecodigo#
	and Pcodigo=5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
    <cfif isdefined("form.EOidorden") and len(trim(form.EOidorden))>
    	<cfquery name="rsEcodigo" datasource="#Session.DSN#">
            select Ecodigo
            from EOrdenCM
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
        </cfquery>
        <cfif Len(trim(rsEcodigo.Ecodigo))>
    		<cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
        </cfif>
    </cfif>
</cfif>
<!----Verificar si esta encendido el parámetro de múltiples contratos---->
<cfquery name="rsParametro_MultipleContrato" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#"> 
		and Pcodigo = 730 
</cfquery>

<cfif isdefined("rsParametro_MultipleContrato") and rsParametro_MultipleContrato.Pvalor EQ 1>
	<!----Verificar que el usuario logueado sea un usuario autorizador de OC's---->
	<cfquery name="rsUsuario_autorizado" datasource="#session.DSN#"><!--- Maxrows="1": El maxrows es porque aun no se ha indicado si un Usuario puede ser autorizado por mas de 1 comprador---->
		select CMCid from CMUsuarioAutorizado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
</cfif>

<cfset vnComprador ="">
<!----Si el usuario logueado NO es usuario autorizado o el parametro no existe o esta desacti---->
<cfif isdefined("rsUsuario_autorizado") and rsUsuario_autorizado.RecordCount NEQ 0>
	<!----<cfset vnComprador = rsUsuario_autorizado.CMCid>---->
	<cfset vnComprador = valueList(rsUsuario_autorizado.CMCid)>	
	<cfif isdefined("session.compras.comprador") and len(trim(session.compras.comprador))>
		<cfset vnComprador = vnComprador &','& session.compras.comprador>
	</cfif>
<cfelse> 
	<!---Valida Comprador. Se asegura que solo hay acceso a esta pantalla si es un comprador --->
	<cfif not (isdefined("session.compras.comprador") and len(trim(session.compras.comprador)))>
		<cf_errorCode	code = "50294" msg = " El Usuario Actual no está definido como comprador!, Acceso Denegado!">
	</cfif>
</cfif>

    
<!-----
COMPRADOR:<cfdump var="#session.compras.comprador#"><br>
VNCOMPRADOR:<cfdump var="#vnComprador#"><br>
Usuario<cfdump var="#session.Usucodigo#"><br>
----->

<cf_templateheader title="Registro Manual de Ordenes de Compra">
	<cf_web_portlet_start titulo="Registro Manual de Ordenes de Compra">		
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="ordenCompraE.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>

