<!---►►Registro de Facturas por Usuario de CXP◄◄--->
<cf_navegacion name="IDdocumento" 	default="-1">	
<cf_navegacion name="btnNuevo">		
<cf_navegacion name="Botones" 		default="Enviar_a_Aplicar,Nuevo,Importar_Facturas,Importar_Transito,Reporte,Imprimir_Tramite">				

<cfset titulo         		= "Registro de Facturas por Usuario">
<cfset LvarTipoMov    		= "C">  
<cfset LvarTipDoc     		= "FU">  
<cfset URLira 	     		= "RegistroFacturasxUsuarioCP.cfm">
<cfset URLNew	      		= "RegistroFacturasxUsuarioCP.cfm">
<cfset FiltroExtra    		= " and a.BMUsucodigo = #session.Usucodigo# and (a.EVestado in (1,3) or a.EVestado is null)">
<cfset PermisoAplicar 		= "false">
<cfset PermisoAnular  		= "false">
<cfset PermisoBorrar  		= "true">
<cfset PermisoModificar 	= "true">
<cfset PermisoAgregar 	    = "true">

<cfif NOT LEN(TRIM(IDdocumento))><cfset IDdocumento = -1></cfif>

<cfif IDdocumento NEQ -1 or isdefined('btnNuevo') or isdefined('SNnumero')>
	<cfinclude template="/sif/cp/operacion/RegistroDocumentosCP.cfm">
<cfelse>
	<cfinclude template="/sif/cp/operacion/DocumentoCP-list.cfm">
</cfif>