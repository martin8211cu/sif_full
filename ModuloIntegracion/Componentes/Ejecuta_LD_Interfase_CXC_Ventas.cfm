<cfsetting  requesttimeout="3600">

<cflock scope="Application" timeout="90">

	<cflog file="LOG_Ejecuta_LD_Interfase_CXC_Ventas" application="no" text="Iniciando extraccion">
		<cfinvoke component="Extraccion/LD_Extraccion_VentasCred" method="Ejecuta"/>
	<cflog file="LOG_Ejecuta_LD_Interfase_CXC_Ventas" application="no" text="Ejecutada extraccion de Ventas Credito #now()#">

	<cflog file="LOG_Ejecuta_LD_Interfase_CXC_Ventas" application="no" text="Inicia importacion">
	<cfinvoke component="LD_interfaz_CxC_Ventas" method="Ejecuta" SIScodigo="LD"/>
</cflock>