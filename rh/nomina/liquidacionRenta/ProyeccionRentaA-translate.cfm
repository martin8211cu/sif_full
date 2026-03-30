<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="Proceso de Liquidaci&oacute;n de Renta" VSgrupo="103" returnvariable="nombre_proceso"/>
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="vIdentificacion" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Nombre" Default="Nombre" returnvariable="vNombre" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Empleado" Default="Empleado" returnvariable="vEmpleado"component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Filtrar" Default="Filtrar" returnvariable="vFiltrar"component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Nuevo_Empleado" Default="Nuevo Empleado" returnvariable="vNuevoEmpleado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/catalogos/expediente-cons.xml"/>
<cfinvoke key="LB_Activos" Default="Activos" returnvariable="vActivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Inactivos" Default="Inactivos" returnvariable="vInactivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Todos" Default="Todos" returnvariable="vTodos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>			
<cfinvoke key="LB_Estado" Default="Estado" returnvariable="vEstado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_IdTarjeta" Default="Id Tarjeta" returnvariable="vTarjeta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>			
<cfinvoke Key="LB_Todos" Default="Todos" returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="LB_Activos" Default="Activos" returnvariable="LB_Activos" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="LB_Inactivos" Default="Inactivos" returnvariable="LB_Inactivos" component="sif.Componentes.Translate" method="Translate"/>		
