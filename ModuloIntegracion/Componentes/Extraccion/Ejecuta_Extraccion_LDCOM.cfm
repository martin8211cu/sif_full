
<!--- LLAMADO A COMPONENTES DE EXTRACCION LD --->
<!---   ISRAEL RODRIGUEZ --->
<cfsetting  requesttimeout="3600">
	<cflock scope="Application" timeout="5400">

		<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Inicia Extraccion">
		<!--- Ejecucion Extraccion de Venta --->

		<cfinvoke component="LD_Extraccion_VentasCont" method="Ejecuta"/>
		<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Ejecutada extraccion de Ventas Contado #now()#">

		<!--- PRIMERO POR XML --->
		<cfinvoke component="ModuloIntegracion.Componentes.LD_VentasCredito_Xml" method="Ejecuta"/>
		<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Ejecutada extraccion de Ventas Credito por XML #now()#">

		<!--- Extraccion Ventas Crédito --->
		<cfinvoke component="LD_Extraccion_VentasCred" method="Ejecuta"/>
		<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Ejecutada extraccion de Ventas Credito #now()#">

		<!--- Ejecucion Extraccion de Compra --->
		<cfinvoke component="LD_Extraccion_Compras" method="Ejecuta"/>
		<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Ejecutada extraccion de Compras #now()#">

		<!--- Ejecucion Extraccion de Inventario --->
		<cfinvoke component="LD_Extraccion_Inventarios" method="Ejecuta"/>
		<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Ejecutada extraccion de Inventarios #now()#">

		<!--- Ejecucion Extraccion de RetirosCaja --->
		<!---<cfinvoke component="LD_Extraccion_RetirosCaja" method="Ejecuta"/>--->

		<!--- Ejecucion Extraccion de RetirosBanco --->
		<!---<cfinvoke component="LD_Extraccion_RetirosBan" method="Ejecuta"/>--->

		<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Finalizada Extraccion">

</cflock>
<!---------------------------------------------------------------------------->

