<!--- VARIABLES DE TRADUCCION --->
<cfsilent>
<cfinvoke Key="LB_Factores" Default="Factores" returnvariable="LB_Factores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Filtrar" Default="Filtrar" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Ponderacion" Default="Ponderaci&oacute;n" returnvariable="LB_Ponderacion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_RHHFpuntuacion" Default="Puntuaci&oacute;n" returnvariable="LB_RHHFpuntuacion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Subfactores" Default="Subfactores" returnvariable="LB_Subfactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="Factores" VSgrupo="103"/>
<cfinvoke Key="MSG_DeseaEliminarElDetalle" Default="Desea Eliminar el Detalle" returnvariable="MSG_DeseaEliminarElDetalle" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Modificar" Default="Modificar" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_Codigo" Default="Código" returnvariable="MSG_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_Descripcion" Default="Descripción" returnvariable="MSG_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_RHHFpuntuacion" Default="Puntuación" returnvariable="MSG_RHHFpuntuacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Ponderacion" Default="Ponderación" returnvariable="MSG_Ponderacion" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
</cfsilent>
<!--- FIN VARIABLES DE TRADUCCION --->