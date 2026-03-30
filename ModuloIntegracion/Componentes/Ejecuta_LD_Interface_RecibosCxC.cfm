<!--- Ejecución de extraccion y procesamiento de  RecibosCxC
      por tarea programada.
	  Eduardo Gonzalez (APH)
	  29/10/2018
--->

<cfsetting  requesttimeout="3600">
<cflock scope="Application" timeout="90">
	<!--- Extraccion --->
	<cflog file="Log_Ejecuta_LD_Interface_RecibosCxC" application="no" text="Iniciando extraccion RecibosCxC">
	<cfinvoke component="Extraccion/LD_Extraccion_RecibosCxC" method="Ejecuta"/>
	<cflog file="Log_Ejecuta_LD_Interface_RecibosCxC" application="no" text="Extraccion RecibosCxC ejecutada: #now()#">

	<!--- Procesamiento --->
	<cflog file="Log_Ejecuta_LD_Interface_RecibosCxC" application="no" text="Inicia procesamiento RecibosCxC">
	<cfinvoke component="LD_interfaz_CxC_Recibos" method="Ejecuta"/>
	<cflog file="Log_Ejecuta_LD_Interface_RecibosCxC" application="no" text="Procesamiento RecibosCxC terminado: #now()#">
</cflock>
