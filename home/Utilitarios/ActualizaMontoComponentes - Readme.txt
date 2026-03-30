ljimenez 20131025
Este proceso actualiza los monto de componentes salariales  
para un conjunto de lineas del tiempo definidas o comprendidas 
entre dos fechas proceso se creo para el ITCR se debe de ejecutar 
en conjunto con el componente Actualizacomponetes


requiere :
	TipoLinea	0 ninguna / 1 Principal / 2 Recargo / 3 Ambas
	ListaCSid 	lista de componentes que vamos a recalcular
    	DEid		Empleado que vamos a actualizar
    	Desde		Inicio de fecha de costes que queremos afecatar
    	Hasta		Fin de fechas de cortes  que deamos afectar
    	debug 		true Muestra los datos y hace rollback
