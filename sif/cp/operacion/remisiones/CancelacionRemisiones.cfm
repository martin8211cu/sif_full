<!---►►Cancelacion de Remisiones◄◄--->
<cf_navegacion name="IDdocumento" 	default="-1">
<cf_navegacion name="btnNuevo">
<cf_navegacion name="Botones" 		default="Cancelar_Remisión">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_RegRem 	= t.Translate('LB_RegRem','Cancelación de Remisiones')>

<cfif isdefined('url.datos') and LEN(TRIM(url.datos))>
	<cfset IDdocumento = url.datos>
</cfif>

<cfset titulo         		= "#LB_RegRem#">
<cfset LvarTipoMov    		= "C">
<cfset LvarTipDoc    		= "FA">
<cfset URLira 	      		= "CancelacionRemisiones.cfm">
<cfset URLNew	      		= "CancelacionRemisiones.cfm">
<cfset FiltroExtra	  		= "">
<cfset PermisoAplicar 		= "true">
<cfset PermisoAnular 		= "false">
<cfset PermisoBorrar 		= "true">
<cfset PermisoModificar 	= "true">
<cfset PermisoAgregar 	    = "true">

<cfif NOT LEN(TRIM(IDdocumento))><cfset IDdocumento = -1></cfif>

<cfif IDdocumento NEQ -1 or isdefined('btnNuevo') or isdefined('SNnumero')>
	<cfinclude template="/sif/cp/operacion/remisiones/RegistroDocumentosRemision.cfm">
<cfelse>
	<cfinclude template="/sif/cp/operacion/remisiones/DocumentoRemision-list.cfm">
</cfif>