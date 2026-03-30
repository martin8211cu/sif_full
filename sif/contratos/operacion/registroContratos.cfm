
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_msgElUsuarioActualnoestádefinidocomocomprador" Default= "El Usuario Actual no está definido como comprador!, Acceso Denegado!" XmlFile="registroContratos.xml" returnvariable="LB_msgElUsuarioActualnoestádefinidocomocomprador"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RegistroManualContratos" Default= "Registro Manual Contratos" XmlFile="registroContratos.xml" returnvariable="LB_RegistroManualContratos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RegistroContratos" Default= "Registro Contratos" XmlFile="registroContratos.xml" returnvariable="LB_RegistroContratos"/>

<cfset lvarProvCorp = false>
<cfif isdefined("form.Ecodigo_f") and #form.Ecodigo_f# neq "">
	<cfset lvarFiltroEcodigo = form.Ecodigo_f>
<cfelse>
	<cfset lvarFiltroEcodigo = session.Ecodigo>
</cfif>


	<!----Verificar que el usuario logueado sea un usuario autorizador de Contratos---->
	<cfquery name="rsUsuario_autorizado" datasource="#session.DSN#">
		select CTCid from CTCompradores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	    and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
        and CTCactivo <> 0
	</cfquery>

<!----Si el usuario logueado NO es usuario autorizado o el parametro no existe o esta desacti---->
	<cfif isdefined("rsUsuario_autorizado") and rsUsuario_autorizado.RecordCount EQ 0>
            <cf_errorCode	code = "80003" msg = #LB_msgElUsuarioActualnoestádefinidocomocomprador#>	
    </cfif>


<cf_templateheader title="#LB_RegistroManualContratos#">
	<cf_web_portlet_start titulo="#LB_RegistroContratos#">		
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="contratoE.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>

