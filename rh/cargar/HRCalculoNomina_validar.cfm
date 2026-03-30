<!--- 
******************************************
CARGA INICIAL DE HRCALCULONOMINA
	FECHA    DE    CREACIÓN:    19/03/2007
	CREADO   POR:   DORIAN   ABARCA  GÓMEZ
******************************************
*********************************
Archivo      de      validaciónes
Este  archivo debe contener todas 
las    validaciones   requeridas, 
previas  a  la  importación final 
del archivo.
*********************************
--->
<!--- Validacion 100: Valida Repetidos de Identificacion --->
<cfinvoke ErrorCode	 = "100" 
		  method	 = "funcVRepetidos" 
		  ColumnName = "CDRHHRCnomina, CDRHHRCfdesde, CDRHHRCfhasta" 
		  ColumnType = "S,D,D"/>

<!--- Validacion 200: Valida Existenca de Identificación en HRCalculoNimina --->
<cfinvoke ErrorCode  = "200" 
		  method	 = "funcVNoExistencia" 
		  ColumnName = "CDRHHRCnomina, CDRHHRCfdesde, CDRHHRCfhasta" 
		  ColumnType = "S,D,D"
		  ColumnDest = "Tcodigo, RCdesde, RChasta" 
		  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 300: Valida existencia en CalendarioPagos de CDRHHRCnomina, CDRHHRCfdesde, CDRHHRCfhasta --->
<cfinvoke ErrorCode	 = "300" 
		  method	 = "funcVIntegridad" 
		  ColumnName = "CDRHHRCnomina, CDRHHRCfdesde, CDRHHRCfhasta" 
		  ColumnType = "S,D,D"
		  TableDest	 = "CalendarioPagos" 
		  ColumnDest = "Tcodigo, CPdesde, CPhasta" 
		  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"
		  Message	 = "No existe el Calendario de Pagos"/>