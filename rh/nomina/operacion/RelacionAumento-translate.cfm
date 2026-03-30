<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_aplicar_esta_relacion_de_aumentos_salariales"
	Default="¿Está seguro de que desea aplicar esta relación de aumentos salariales?"	
	returnvariable="LB_AplicarRelacAumento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_eliminar_este_lote_de_aumentos_salariales"
	Default="¿Está seguro de que desea eliminar este lote de aumentos salariales?"	
	returnvariable="LB_EliminarLote"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_eliminar_esta_deduccion"
	Default="¿Está seguro de que desea eliminar esta deducción?"	
	returnvariable="LB_EliminarDeduccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TituloPorletDetalleAumentoSalarial"
	Default="#tit#"	
	returnvariable="LB_TituloPorletDetalleAumentoSalarial"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AgregarEmpleadosPorCentroFuncional"
	Default="Agregar Empleados Por Centro Funcional"	
	returnvariable="LB_TituloPorletCF"/>	

<!---Boton Agregar--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>	
<!---Boton Buscar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Buscar"
	Default="Buscar"
	XmlFile="/rh/generales.xml"
	returnvariable="vBuscar"/>
<!---Boton Modificar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Cambiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>		
<!---Boton Eliminar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>
<!----Boton Nuevo ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Nuevo"/>	
<!---Boton de aplicar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar"
	Default="Aplicar"	
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Aplicar"/>
<!---Boton de eliminar lote--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_EliminarLote"
	Default="Eliminar Lote"	
	returnvariable="BTN_EliminarLote"/>

<!---Lista identificacion ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"	
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Identificacion"/>	
<!---Lista Nombre ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"	
	returnvariable="LB_NombreCompleto"/>
<!---Lista Salario Actual ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Salario_Actual"
	Default="Salario Actual"	
	returnvariable="LB_Salario_Actual"/>	
<!---Lista Aumento---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Aumento"
	Default="Aumento"	
	returnvariable="LB_Aumento"/>
<!---Lista Salario Propuesto---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SalarioPropuesto"
	Default="Salario Propuesto"	
	returnvariable="LB_SalarioPropuesto"/>
<!---Qforms Empleado---->			
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"	
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Empleado"/>
<!---Qforms Monto---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Monto"
	Default="Monto"	
	returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Porcentaje"
	Default="Porcentaje"	
	returnvariable="LB_Porcentaje"/>
<!---Qforms Fecha de Vigencia---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeVigencia"
	Default="Fecha de Vigencia"	
	returnvariable="LB_FechaDeVigencia"/>
<!---Qforms MSG Campo cero---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ElCampoNoPuedeSerCero"
	Default=" no puede ser cero"	
	returnvariable="LB_ElCampoNoPuedeSerCero"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ElCampoNoPuedeSerMayorA100"
	Default=" no puede ser mayor a 100"	
	returnvariable="LB_ElCampoNoPuedeSerMayorA100"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Listado_de_empleados_para_la_relacion_de_aumento"
	Default="Listado de empleados para la relaci&oacute;n de aumento"
	returnvariable="vlistado"/>

<!---Boton Agregar--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>	

<cfinvoke Key="LB_TablaSalarial" Default="Tabla Salarial" returnvariable="LB_TablaSalarial" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Vigencia" Default="Vigencia" returnvariable="LB_Vigencia" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ListaVigencias" default="Lista de Vigencias" returnvariable="LB_ListaVigencias" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_FechaHasta" default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_Estado" default="Estado" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_ListaTablas" default="Lista de Tablas Salariales" returnvariable="LB_ListaTablas" component="sif.Componentes.Translate" method="Translate"/>			
