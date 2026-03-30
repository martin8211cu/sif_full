<!--- =============================================================== --->
<!---   Autor: 	Rodrigo Rivera                                        --->
<!---	Fecha: 	28/03/2014              	                          --->
<!--- =============================================================== --->
<!--- Modificado por: Andres Lara                						  --->
<!---	Nombre: Financiamiento                                         --->
<!---	Fecha: 	02/04/2014              	                          --->
<!--- =============================================================== --->
<!---                  Navegacion                                	  --->
<!--- =============================================================== --->
<!--- <cfthrow message ="a"> --->
<cf_navegacion name="IDFinan" 		default="-1">
<cf_navegacion name="btnNuevo">
<cf_navegacion name="SNnumero">
<cf_navegacion name="TipoCam">
<cf_navegacion name="Botones" 		default="Nuevo">
<!--- translate --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Financiamientos" default="Registro de Financiamientos" returnvariable="LB_RegFinanciamientos" xmlfile="Financiamiento.xml"/>


<!--- =============================================================== --->
<!---                   Inicializacion  Variables               	  --->
<!--- =============================================================== --->
<cfset titulo         		= "#LB_RegFinanciamientos#">
<cfset URLira 	      		= "Financiamiento.cfm">
<cfset URLNew	      		= "Financiamiento.cfm">
<cfset FiltroExtra	  		= "">
<cfset PermisoAplicar 		= "true">
<cfset PermisoAnular 		= "false">
<cfset PermisoBorrar 		= "true">
<cfset PermisoModificar 	= "true">
<cfset PermisoAgregar 	    = "true">

<cfif IDFinan GT -1 or isDefined('btnNuevo')>
		<cfinclude template="/sif/mb/Financiamiento/RegistroFinanciamiento.cfm">
	<cfelse>
		<cfinclude template="/sif/mb/Financiamiento/Financiamiento-list.cfm">
</cfif>