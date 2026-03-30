
<!--- 	RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LAS INTERFAZES.     
		RUTINAS DE TRANSFORMACION DE DATOS EXTRAIDOS DE LDCOM, LOS CUALES SERAN PROCESADOS   
		SIENDO INSERTADOS EN TABLAS INTERMEDIAS(TABLAS IEXX) Y POSTERIORMENTE PROCESADAS POR 
		EL MOTOR DE INTERFAZES, EXTRAYENDO LOS DATOS DE LAS MISMAS PARA SER VALIDADOS Y      
		DEPOSITADOS EN TABLAS DEL SIF.        ---------------------------------------------->


<cfsetting  requesttimeout="3600">

<!------------  INTERFAZES DE CONTABILIDAD GENERAL  -------------------------->
<!--- Ejecucion de Interfaz de Ventas --->
<cfinvoke component="LD_Interfaz_CG_Ventas" method="Ejecuta" SIScodigo="LD"/> 


<!--- Ejecucion de Interfaz de Cuentas por Cobrar (Ventas) --->
<cfinvoke component="LD_interfaz_CxC_Ventas" method="Ejecuta" SIScodigo="LD"/>


<!--- Ejecucion de Interfaz de Cuentas por Pagar (Compras) --->
<cfinvoke component="LD_interfaz_CxP_Compras" method="Ejecuta" SIScodigo="LD"/>

<!--- Ejecucion de Interfaz de Inventarios --->
<cfinvoke component="LD_interfaz_CG_Inv" method="Ejecuta" SIScodigo="LD"/> 

<!--- Ejecucion de Interfaz de Caja --->
<!---<cfinvoke component="LD_interfaz_CG_Caja" method="Ejecuta" SIScodigo="LD"/>--->
<!---------------------------------------------------------------------------->

<!--- Ejecucion de Interfaz de Prefacturacion (CXC) --->
<!---<cfinvoke component="LD_Interfaz_Prefacturacion" method="Ejecuta" SIScodigo="LD"/>--->

<!--- Ejecucion de Interfaz de Bancos (Movimientos) --->
<!---<cfinvoke component="LD_Interfaz_Mov_Bancarios" method="Ejecuta" SIScodigo="LD"/>--->


