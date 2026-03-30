<!--- Ejecución de extraccion y procesamiento de Ventas Contado
      por tarea programada.
	  Eduardo Gonzalez (APH)
	  21/11/2018
--->

<cfsetting  requesttimeout="3600">
<cflock scope="Application" timeout="90">
	<!--- Extraccion --->
	<cflog file="Log_Ejecuta_LD_Interface_VentasContado" application="no" text="Iniciando extraccion Ventas Contado">
	<cfinvoke component="Extraccion/LD_Extraccion_VentasCont" method="Ejecuta"/>
	<cflog file="Log_Ejecuta_LD_Interface_VentasContado" application="no" text="Extraccion Ventas Contado ejecutada: #now()#">

	<!--- Procesamiento --->
	<cflog file="Log_Ejecuta_LD_Interface_VentasContado" application="no" text="Inicia procesamiento Ventas Contado">
	<cfinvoke component="LD_interfaz_CG_Ventas" method="Ejecuta"/>
	<cflog file="Log_Ejecuta_LD_Interface_VentasContado" application="no" text="Procesamiento Ventas Contado terminado: #now()#">
</cflock>
