<!---►►Registro de Facturas de CXP◄◄--->
<cf_navegacion name="IDdocumento" 	default="-1">
<cf_navegacion name="btnNuevo">
<cf_navegacion name="Botones" 		default="Aplicar,Nuevo,Importar_Facturas,Importar_Transito,Reporte, Imprimir_Tramite">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_RegFact 	= t.Translate('LB_RegFact','Registro de Facturas')>

<cfif isdefined('url.datos') and LEN(TRIM(url.datos))>
	<cfset IDdocumento = url.datos>
</cfif>

<cfset titulo         		= "#LB_RegFact#">
<cfset LvarTipoMov    		= "C">
<cfset LvarTipDoc    		= "FA">
<cfset URLira 	      		= "RegistroFacturasCP.cfm">
<cfset URLNew	      		= "RegistroFacturasCP.cfm">
<cfset FiltroExtra	  		= "">
<cfset PermisoAplicar 		= "true">
<cfset PermisoAnular 		= "false">
<cfset PermisoBorrar 		= "true">
<cfset PermisoModificar 	= "true">
<cfset PermisoAgregar 	    = "true">

<cfif NOT LEN(TRIM(IDdocumento))><cfset IDdocumento = -1></cfif>

<cfif IDdocumento NEQ -1 or isdefined('btnNuevo') or 
    (isdefined('SNnumero') and not isdefined("tokenListaDoc"))>
	<cfinclude template="/sif/cp/operacion/RegistroDocumentosCP.cfm">
<cfelse>
	<cfinclude template="/sif/cp/operacion/DocumentoCP-list.cfm">
</cfif>