<!--- Ejecución de extraccion y procesamiento de Inventarios
      por tarea programada.
	  Eduardo Gonzalez (APH)
	  21/11/2018
--->

<cfsetting  requesttimeout="3600">
<cflock scope="Application" timeout="90">
	<!--- Extraccion --->
	<cflog file="Log_Ejecuta_LD_Interface_Inventarios" application="no" text="Iniciando extraccion Inventarios">
	<cfinvoke component="Extraccion/LD_Extraccion_Inventarios" method="Ejecuta"/>
	<cflog file="Log_Ejecuta_LD_Interface_Inventarios" application="no" text="Extraccion Inventarios ejecutada: #now()#">

	<!--- Procesamiento --->
	<cflog file="Log_Ejecuta_LD_Interface_Inventarios" application="no" text="Inicia procesamiento Inventarios">
	<cfinvoke component="LD_interfaz_CG_Inv" method="Ejecuta"/>
	<cflog file="Log_Ejecuta_LD_Interface_Inventarios" application="no" text="Procesamiento Inventarios terminado: #now()#">
</cflock>
