<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_MesDeInicio" default="Mes de inicio" returnvariable="LB_MesDeInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_AnoDeInicio" default="Año de Inicio" returnvariable="LB_AnoDeInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_MesDeFinalizacion" default="Mes de Finalización" returnvariable="LB_MesDeFinalizacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_AnoDeFinalizacion" default="Año de Finalización" returnvariable="LB_AnoDeFinalizacion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_TituloObtenido" default="T&iacute;tulo obtenido" returnvariable="LB_TituloObtenido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_InstitucionEnQueEstudio" default="Instituci&oacute;n en que estudi&oacute;" returnvariable="LB_InstitucionEnQueEstudio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_OtraInstitucion" default="Otra instituci&oacute;n" returnvariable="LB_OtraInstitucion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaDeIngreso" default="Fecha de ingreso" returnvariable="LB_FechaDeIngreso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaDeFinalizacion" default="Fecha de finalizaci&oacute;n" returnvariable="LB_FechaDeFinalizacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NivelAlcanzado" default="Nivel alcanzado" returnvariable="LB_NivelAlcanzado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SinTerminar" default="Sin terminar" returnvariable="LB_SinTerminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TituloObtenido" default="Título obtenido" returnvariable="LB_TituloObtenido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CapacitacionNoFormal" default="Capacitaci&oacute;n no formal" returnvariable="LB_CapacitacionNoFormal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EducacionDel" default="Educación del" returnvariable="LB_EducacionDel" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Oferente" default="oferente" xmlfile="/rh/generales.xml" returnvariable="LB_Oferente" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Empleado" default="Empleado" xmlfile="/rh/generales.xml" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Actualmente" default="Actualmente"returnvariable="LB_Actualmente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EstudiosRealizados" default="Estudios Realizados" returnvariable="LB_EstudiosRealizados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DeseaAprobarElEstudioRealizado" default="Desea aprobar el Estudio Realizado?" returnvariable="MSG_DeseaAprobarElEstudioRealizado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SinDefinir" default="Sin definir" returnvariable="LB_SinDefinir" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Educacion" default="Educacion" returnvariable="LB_Educacion" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Aprobar" default="Aprobar" returnvariable="LB_Aprobar" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Rechazar" default="Rechazar" returnvariable="LB_Rechazar"  xmlFile="/rh/capacitacion/operacion/ActualizacionEstudiosR.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Regresar" default="Regresar" returnvariable="LB_Regresar"  xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>

