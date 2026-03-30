<!---►►Registro de Notas de Credito de CXP◄◄--->
<cf_navegacion name="IDdocumento" 	default="-1">	
<cf_navegacion name="btnNuevo">		
<cf_navegacion name="Botones" 		default="Aplicar,Nuevo,Importar_Facturas,Importar_Transito,Reporte,Cambiar_Fecha">	
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_RegNC 	= t.Translate('LB_RegNC','Registro de Notas de Crédito')>

<cfset titulo           	= "#LB_RegNC#">
<cfset LvarTipoMov      	= "D">  
<cfset LvarTipDoc    		= "NC">  
<cfset URLira 	        	= "RegistroNotasCreditoCP.cfm">
<cfset URLNew	        	= "RegistroNotasCreditoCP.cfm">
<cfset FiltroExtra      	= "">
<cfset PermisoAplicar   	= "true">
<cfset PermisoAnular    	= "false">
<cfset PermisoBorrar    	= "true">
<cfset PermisoModificar 	= "true">
<cfset PermisoAgregar 	    = "true">

<cfif NOT LEN(TRIM(IDdocumento))><cfset IDdocumento = -1></cfif>

<cfif IDdocumento NEQ -1 or isdefined('btnNuevo') or 
    (isdefined('SNnumero') and not isdefined("tokenListaDoc"))>
	<cfinclude template="/sif/cp/operacion/RegistroDocumentosCP.cfm">
<cfelse>
	<cfinclude template="/sif/cp/operacion/DocumentoCP-list.cfm">
</cfif>