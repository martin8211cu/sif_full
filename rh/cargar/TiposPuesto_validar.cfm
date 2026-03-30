<!--- Validación 100: Validar que no existan campos repetidos (CDRHHTiposPuesto) --->
<cfinvoke ErrorCode="100" method="funcVRepetidos" ColumnName="CDRHHTPcodigo" ColumnType="S"/>

<!--- Validacion 200: Que los registros no hayan sido insertados (CDRHHTiposPuesto vs RHTPuestos) --->
<cfinvoke ErrorCode="200" method="funcVRepetidos" ColumnName="CDRHHTPcodigo" 
	TableDest="RHTPuestos" ColumnDest="RHTPcodigo" Filtro="Ecodigo = #Gvar.Ecodigo#"
	ColumnType="S"/>	