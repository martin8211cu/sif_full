<!--- Ejecución de extraccion y procesamiento de Compras CxP
      por tarea programada.
	  Eduardo Gonzalez (APH)
	  21/11/2018
--->

<cfsetting  requesttimeout="3600">
<cflock scope="Application" timeout="90">
	<!--- Extraccion --->
	<cflog file="Log_Ejecuta_LD_Interface_ComprasCxP" application="no" text="Iniciando extraccion Compras CxP">
	<cfinvoke component="Extraccion/LD_Extraccion_Compras" method="Ejecuta"/>
	<cflog file="Log_Ejecuta_LD_Interface_ComprasCxP" application="no" text="Extraccion Compras CxP ejecutada: #now()#">

	<!--- Procesamiento --->
	<cflog file="Log_Ejecuta_LD_Interface_ComprasCxP" application="no" text="Inicia procesamiento Compras CxP">
	<cfinvoke component="LD_interfaz_CxP_Compras" method="Ejecuta"/>
	<cflog file="Log_Ejecuta_LD_Interface_ComprasCxP" application="no" text="Procesamiento Compras CxP terminado: #now()#">
</cflock>
