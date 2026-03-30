<!--- Validacion 100: Valida Existenca del Empleado (Identificación) --->
<!----
<cfinvoke ErrorCode	 = "100" 
	  method	 = "funcVNoExistencia" 
	  ColumnName = "CDRHHDEidentificacion" 
	  ColumnDest = "DEidentificacion" 
	  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"/>
----->
<cfinvoke ErrorCode	 = "200" 
	  method	 = "funcVIntegridad" 
	  ColumnName = "CDRHHDEidentificacion" 
	  TableDest	 = "DatosEmpleado" 
	  ColumnDest = "DEidentificacion"/>  		  
		  		  
<!--- Validacion 300: Valida existencia del tipo Identificacion --->
<cfinvoke ErrorCode	 = "300" 
	  method	 = "funcVIntegridad" 
	  ColumnName = "CDRHHNTIcodigo" 
	  TableDest	 = "NTipoIdentificacion" 
	  ColumnDest = "NTIcodigo"/>  

<!--- Validacion 400: Valida existencia del Parentesco --->
<cfinvoke ErrorCode	 = "400" 
	  method	 = "funcVIntegridad" 
	  ColumnName = "CDRHHPid" 
	  TableDest	 = "RHParentesco" 
	  ColumnDest = "Pid"
	  ColumnType = "I"/> 		  
		  
<!--- Validacion 500: Valida existencia del ConceptoDeduc (Tipo de credito que aplica) --->
<!---<cfinvoke ErrorCode	 = "500" 
	  method	 = "funcVIntegridad" 
	  ColumnName = "CDRHHCDcodigo" 
	  TableDest	 = "ConceptoDeduc" 
	  ColumnDest = "CDcodigo"/> --->		  
