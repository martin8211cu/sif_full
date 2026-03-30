
<!--- LLAMADO A COMPONENTES DE EXTRACCION LD --->
<!---   ABG AGO-2009--->

<cfsetting  requesttimeout="3600">

<!--- Ejecucion Extraccion de Venta --->
<cfinvoke component="Extraccion_Ventas" method="Ejecuta"/> 

<!--- Ejecucion Extraccion de Compra --->
<cfinvoke component="Extraccion_Compras" method="Ejecuta"/> 

<!--- Ejecucion Extraccion de Inventario --->
<cfinvoke component="Extraccion_Inventarios" method="Ejecuta"/> 

<!--- Ejecucion Extraccion de RetirosCaja --->
<cfinvoke component="Extraccion_RetirosCaja" method="Ejecuta"/> 

<!--- Ejecucion Extraccion de RetirosBanco --->
<cfinvoke component="Extraccion_RetirosBanco" method="Ejecuta"/> 

<!---------------------------------------------------------------------------->


