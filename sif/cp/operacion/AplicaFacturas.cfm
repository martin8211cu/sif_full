<!---►►Aplicación de Facturas por Usuario de CXP◄◄--->
<cf_navegacion name="IDdocumento" 	default="-1">	
<cf_navegacion name="btnNuevo">	
<cf_navegacion name="Botones" 		default="Aplicar,Anular">				

<cfset titulo         		= "Aplicación de Facturas por Usuario">
<cfset LvarTipoMov    		= "C">  
<cfset LvarTipDoc    		= "AF">  
<cfset URLira 	      		= "AplicaFacturas.cfm">
<cfset URLNew	      		= "AplicaFacturas.cfm">
<cfset FiltroExtra    		= " and a.EVestado not in (1,3)">
<cfset PermisoAplicar 		= "true">
<cfset PermisoAnular  		= "true">
<cfset PermisoBorrar 	 	= "false">
<cfset PermisoModificar 	= "false">
<cfset PermisoAgregar 	    = "false">

<cfif NOT LEN(TRIM(IDdocumento))><cfset IDdocumento = -1></cfif>

<cfif IDdocumento NEQ -1 or isdefined('btnNuevo') or isdefined('SNnumero')>
	<cfinclude template="/sif/cp/operacion/RegistroDocumentosCP.cfm">
<cfelse>
	<cfinclude template="/sif/cp/operacion/DocumentoCP-list.cfm">
</cfif>
