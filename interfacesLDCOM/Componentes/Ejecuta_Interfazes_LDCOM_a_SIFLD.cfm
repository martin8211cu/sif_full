
<!--- 	RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LAS INTERFAZES.     
		RUTINAS DE TRANSFORMACION DE DATOS EXTRAIDOS DE LDCOM, LOS CUALES SERAN PROCESADOS   
		SIENDO INSERTADOS EN TABLAS INTERMEDIAS(TABLAS IEXX) Y POSTERIORMENTE PROCESADAS POR 
		EL MOTOR DE INTERFAZES, EXTRAYENDO LOS DATOS DE LAS MISMAS PARA SER VALIDADOS Y      
		DEPOSITADOS EN TABLAS DEL SIF.        ---------------------------------------------->
<!---   Autor : Gabriel Ernesto Sanchez Huerta       15/07/2009                          --->

<cfsetting  requesttimeout="3600">
<!---
<!--- Ejecucion de Interfaz de Cuentas por Pagar (Compras) --->
<cfinvoke component="interfaz_CxP_Compras" method="Ejecuta" SIScodigo="LD"/> 

<!--- Ejecucion de Interfaz de Cuentas por Cobrar (Ventas) --->
<cfinvoke component="interfaz_CxC_Ventas" method="Ejecuta" SIScodigo="LD"/> 

<!--- Ejecucion de Interfaz de Prefacturacion (CXC) --->
<cfinvoke component="Interfaz_Prefacturacion" method="Ejecuta" SIScodigo="LD"/>

<!--- Ejecucion de Interfaz de Bancos (Movimientos) --->
<cfinvoke component="Interfaz_Mov_Bancarios" method="Ejecuta" SIScodigo="LD"/>
--->

<!------------  INTERFAZES DE CONTABILIDAD GENERAL  -------------------------->
<!--- Ejecucion de Interfaz de Ventas --->
<cfinvoke component="Interfaz_CG_Ventas" method="Ejecuta" SIScodigo="LD"/>
<!---
<!--- Ejecucion de Interfaz de Inventarios --->
<cfinvoke component="Interfaz_CG_Inventarios" method="Ejecuta" SIScodigo="LD"/>

<!--- Ejecucion de Interfaz de Caja --->
<cfinvoke component="interfaz_CG_Caja" method="Ejecuta" SIScodigo="LD"/>
<!---------------------------------------------------------------------------->


--->