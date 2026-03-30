
<!--- Variables de Traducción --->
<!--- Botones --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Calcular"
	Default="Calcular"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Calcular"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar"
	Default="Aplicar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Aplicar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Guardar"
	Default="Guardar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Guardar"/>

<!--- Etiquetas --->	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_FechaInicial" 
	Default="Fecha Inicial" 
	returnvariable="LB_FechaInicial"/>

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_FechaInicial" 
	Default="Fecha Inicial" 
	returnvariable="LB_FechaDesde"/>
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_FechaFinal" 
	Default="Fecha Final" 
	returnvariable="LB_FechaHasta"/>
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Descripcion_del_ajuste" 
	Default="Descripci&oacute;n del ajuste" 
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_JS_Descripcion_del_ajuste" 
	Default="Descripción del ajuste" 
	returnvariable="LB_Descripcion_JS"/>

<!--- Etiquetas del archivo registroMasivoAjuste-sql.cfm --->
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_RegistroMasivoAjustes" 
	Default="Registro Masivo de Ajuste de Vacaciones" 
	returnvariable="LB_RegistroMasivoAjustes"/>
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Fecha" 
	Default="Fecha" 
	returnvariable="LB_Fecha"/>
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Identificacion" 
	xml="/rh/generales.xml" 
	Default="Identificaci&oacute;n" 
	returnvariable="LB_Identificacion"/>	
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Empleado" 
	Default="Empleado"
	xml="/rh/generales.xml" 
	returnvariable="LB_Empleado"/>

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_SaldoActual" 
	Default="Saldo Actual" 
	returnvariable="LB_SaldoActual"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_SaldoProyectado" 
	Default="Saldo Proyectado" 
	returnvariable="LB_SaldoProyectado"/>

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Rebajar" 
	Default="Rebajar" 
	returnvariable="LB_Rebajar"/>
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Aumentar" 
	Default="Aumentar" 
	returnvariable="LB_Aumentar"/>	
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Seleccione_los_criterios_para_incluir_empleados_al_proceso_masivo_ajuste" 
	Default="Seleccione los criterios para incluir empleados al proceso masivo de ajuste" 
	returnvariable="LB_Agregar_Empleados"/>	

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Defina_el_rango_de_fechas_que_seran_tomados_como_vacaciones" 
	Default="Defina el rango de fechas que ser&aacute;n tomados como vacaciones" 
	returnvariable="LB_Fechas"/>	
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Ajuste_positivo" 
	Default="Ajuste (+)" 
	returnvariable="LB_Ajuste_positivo"/>	
		
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Ajuste_negativo" 
	Default="Ajuste (-)" 
	returnvariable="LB_Ajuste_negativo"/>	

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Desde" 
	Default="Desde" 
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Desde"/>	

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Hasta" 
	Default="Hasta" 
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Hasta"/>	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Todos" 
	Default="Todos" 
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Todos"/>		
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Desea_aplicar_los_registros_seleccionados" 
	Default="Desea aplicar los registros seleccionados" 
	returnvariable="LB_ConfirmaAplicar"/>		

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Desea_eliminar_del_ajuste_los_registros_seleccionados" 
	Default="Desea eliminar del ajuste los registros seleccionados" 
	returnvariable="LB_ConfirmaEliminar"/>		

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Debe_seleccionar_al_menos_un_registro_de_la_lista_para_procesar" 
	Default="Debe seleccionar al menos un registro de la lista para procesar" 
	returnvariable="LB_Seleccionar"/>	
	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Debe_seleccionar_al_menos_un_registro_de_la_lista_para_procesar" 
	Default="No se han encontrado registros para el proceso de aplicaci&oacute;n" 
	returnvariable="LB_Mensaje"/>	

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Se_realizo_con_exito_la_aplicacion_de_ajustes_de_vacaciones" 
	Default="Se realiz&oacute; con &eacute;xito la aplicaci&oacute;n de ajustes de vacaciones" 
	returnvariable="LB_exito"/>	
	
	
	

		