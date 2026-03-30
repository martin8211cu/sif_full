<!--- Eduardo Gonzalez Sarabia (APH)
	  Solo procesa ventas de credito por XML y costo.
	  04/12/2018 --->
<cfsetting  requesttimeout="3600">

<cflock scope="Application" timeout="90">
	<!--- PRIMERO POR XML --->
	<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Inicia extraccion/procesamiento de Ventas Credito por XML #now()#">
	<cfinvoke component="ModuloIntegracion.Componentes.LD_VentasCredito_Xml" method="Ejecuta"/>
	<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Finaliza extraccion/procesamiento de Ventas Credito por XML #now()#">

	<!--- EXTRACCION POLIZAS COSTO --->
	<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Inicia extraccion de polizas de costo #now()#">
	<cfinvoke component="ModuloIntegracion.Componentes.Extraccion.LD_Extraccion_PolizasCosto" method="Ejecuta"/>
	<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Finaliza extraccion de polizas de costo #now()#">

	<!--- PROCESAMIENTO DE CXC, PARA LAS POLIZAS DE COSTO --->
	<cflog file="LOG_Ejecuta_LD_Interfase_CXC_Ventas" application="no" text="Inicia Procesamiento de polizas de costo #now()#">
	<cfinvoke component="LD_interfaz_CxC_Ventas" method="Ejecuta" SIScodigo="LD"/>
	<cflog file="LOG_Ejecuta_LD_Interfase_CXC_Ventas" application="no" text="Finaliza Procesamiento de polizas de costo #now()#">

</cflock>