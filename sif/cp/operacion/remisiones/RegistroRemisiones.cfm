<!---►►Registro de Remisiones◄◄--->
<cf_navegacion name="IDdocumento" 	default="-1">
<cf_navegacion name="btnNuevo">
<cf_navegacion name="Botones" 		default="Nuevo">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_RegRem 	= t.Translate('LB_RegRem','Registro de Remisiones')>

<cfif isdefined('url.datos') and LEN(TRIM(url.datos))>
	<cfset IDdocumento = url.datos>
</cfif>

<cfset titulo         		= "#LB_RegRem#">
<cfset LvarTipoMov    		= "C">
<cfset LvarTipDoc    		= "FA">
<cfset URLira 	      		= "RegistroRemisiones.cfm">
<cfset URLNew	      		= "RegistroRemisiones.cfm">
<cfset FiltroExtra	  		= "">
<cfset PermisoAplicar 		= "true">
<cfset PermisoAnular 		= "false">
<cfset PermisoBorrar 		= "true">
<cfset PermisoModificar 	= "true">
<cfset PermisoAgregar 	    = "true">

<cfif NOT LEN(TRIM(IDdocumento))><cfset IDdocumento = -1></cfif>

<cfif IDdocumento NEQ -1 or isdefined('btnNuevo') or 
    (isdefined('SNnumero') and not isdefined("tokenListaDoc"))>
	<cfinclude template="/sif/cp/operacion/remisiones/RegistroDocumentosRemision.cfm">
<cfelse>
	<cfinclude template="/sif/cp/operacion/remisiones/DocumentoRemision-list.cfm">
</cfif>