<!--- 
******************************************
CARGA INICIAL DE EMPLEADOS
	FECHA    DE    CREACIÓN:    14/03/2007
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

<!--- Validación 100: Valida Repetidos de Identificación --->
<cfinvoke ErrorCode	 = "100" 
		  method	 = "funcVRepetidos" 
		  ColumnName = "CDRHDEidentificacion"/>

<!--- Validacion 200: Valida Existenca de Identificación en DatosEmpleado --->
<cfinvoke ErrorCode	 = "200" 
		  method	 = "funcVNoExistencia" 
		  ColumnName = "CDRHDEidentificacion" 
		  ColumnDest = "DEidentificacion" 
		  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 300: Valida Identificacion: C,P,G --->
<cfinvoke ErrorCode	 = "300" 
		  method	 = "funcVIntegridad" 
		  ColumnName = "CDRHDEtipoidentificacion" 
		  TableDest	 = "NTipoIdentificacion" 
		  ColumnDest = "NTIcodigo"/>

<!--- Validacion 400: Valida Estado Civil: 1-6 --->
<cfinvoke ErrorCode	 = "400" 
		  method	 = "funcVValor" 
		  ColumnName = "CDRHDEecivil" 
		  ColumnType = "I" 
		  ListValues = "0,1,2,3,4,5"/>

<!--- Validacion 500: Valida Sexo: M,F --->
<cfinvoke ErrorCode	 = "500" 
		  method	 = "funcVValor" 
		  ColumnName = "CDRHDEsexo" 
		  ListValues = "M,F"/>

<!--- Validacion 600: Valida Integridad de ID del Banco --->
<cfinvoke ErrorCode	 = "600" 
		  method	 = "funcVIntegridad" 
		  ColumnName = "CDRHDEbanco" 
		  ColumnType = "I"
		  TableDest	 = "Bancos" 
		  ColumnDest = "Bid" 
		  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 700: Valida Integridad de ID del Moneda --->
<cfinvoke ErrorCode	 = "700" 
		  method	 = "funcVIntegridad" 
		  ColumnName = "CDRHDEmoneda" 
		  ColumnType = "I" 
		  AllowNulls = "true"
		  TableDest	 = "Monedas" 
		  ColumnDest = "Mcodigo" 
		  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 800: Valida Integridad de Tipo de Cuenta --->
<cfinvoke ErrorCode	 = "800" 
	  	  method	 = "funcVValor" 
		  ColumnName = "CDRHDEtipocuenta" 
		  ColumnType = "I" 
		  ListValues = "0,1"/>