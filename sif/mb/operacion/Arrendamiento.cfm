<!--- =============================================================== --->
<!---   Autor: 	Rodrigo Rivera                                        --->
<!---	Nombre: Arrendamiento                                         --->
<!---	Fecha: 	28/03/2014    										  --->
<!---	Última Modificación: 16/04/2014    	                          --->
<!--- =============================================================== --->

<!--- =============================================================== --->
<!---                  Navegacion                                	  --->
<!--- =============================================================== --->
<cf_navegacion name="IDArrend" 		default=-1>	
<cf_navegacion name="btnNuevo">	
<cf_navegacion name="SNnumero">
<cf_navegacion name="TipoCam">
<cf_navegacion name="Botones" 		default="Nuevo">
<cf_navegacion name="Fecha">
<cf_navegacion name="datos">    
<cf_navegacion name="modo"          default="ALTA"> 
<cf_navegacion name="modoDet"       default="ALTA">    
<cf_navegacion name="Documento"     default="">     
<cf_navegacion name="Usuario"       default="">    
<cf_navegacion name="Moneda"        default="-1">   
<cf_navegacion name="Registros"     default="20">    
<cf_navegacion name="pageNum_lista" default="1">
<cf_navegacion name="TipoCambio"    default="0">

<!--- translate --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Arrendamientos" default="Registro de Arrendamientos" returnvariable="LB_RegArrendamientos" xmlfile="Arrendamiento.xml"/>


<!--- =============================================================== --->
<!---                   Inicializacion  Variables               	  --->
<!--- =============================================================== --->
<cfset titulo         		= "#LB_RegArrendamientos#">
<cfset URLira 	      		= "Arrendamiento.cfm">
<cfset URLNew	      		= "Arrendamiento.cfm">
<cfset FiltroExtra	  		= "">
<cfset PermisoAplicar 		= "true">
<cfset PermisoAnular 		= "false">
<cfset PermisoBorrar 		= "true">
<cfset PermisoModificar 	= "true">
<cfset PermisoAgregar 	    = "true">

<cfif (IDArrend GT -1 or isDefined('btnNuevo')) or isdefined('SNnumero')>
	<cfset modo= "ALTA">
		<cfinclude template="/sif/mb/operacion/RegistroArrendamiento.cfm">
	<cfelse>
		<cfinclude template="/sif/mb/operacion/Arrendamiento-list.cfm">
</cfif>