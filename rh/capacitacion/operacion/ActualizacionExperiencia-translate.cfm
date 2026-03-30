<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke Key="LB_NombreDeLaEmpresa" Default="Nombre de la empresa" returnvariable="LB_NombreDeLaEmpresa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TelefonoDeLaEmpresa" Default="Tel&eacute;fono de la empresa" returnvariable="LB_TelefonoDeLaEmpresa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Profesion_u_oficio" Default="Profesi&oacute;n u oficio" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDeIngreso" Default="Fecha de ingreso" returnvariable="LB_FechaDeIngreso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDeRetiro" Default="Fecha de retiro" returnvariable="LB_FechaDeRetiro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_MotivoDelRetiro" Default="Motivo del retiro" returnvariable="LB_MotivoDelRetiro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FuncionesYLogrosObtenidos" Default="Funciones y logros obtenidos" returnvariable="LB_FuncionesYLogrosObtenidos"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="CHK_Actualmente" Default="Actualmente" returnvariable="CHK_Actualmente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AnnosLaborados" Default="A&ntilde;os Laborados" returnvariable="LB_AnnosLaborados" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate"XmlFile="/rh/generales.xml" />
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Modificar" Default="Modificar" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate"XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Eliminar" Default="Eliminar" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Nuevo" Default="Nuevo" returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DeseaEliminarElRegistro" Default="Desea eliminar el registro" returnvariable="MSG_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="LB_MesDeInicio" Default="Mes de inicio" returnvariable="LB_MesDeInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AnoDeInicio" Default="Año de Inicio" returnvariable="LB_AnoDeInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_MesDeRetiro" Default="Mes de retiro" returnvariable="LB_MesDeRetiro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AnoDeRetiro" Default="Año de retiro" returnvariable="LB_AnoDeRetiro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_PuestoDesempenado" Default="Puesto desempeñado" returnvariable="LB_PuestoDesempenado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSeleccionarElAnoYMesDeFinalizacion" Default="Debe seleccionar el año y mes de finalización" returnvariable="MSG_DebeSeleccionarElAnoYMesDeFinalizacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="LB_ExperienciaDel" Default="Experiencia del" returnvariable="LB_ExperienciaDel" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Oferente" Default="oferente"  returnvariable="LB_Oferente" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>	
<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>	
<cfinvoke Key="LB_Actualmente" Default="Actualmente" returnvariable="LB_Actualmente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ExperienciaLaboral" Default="Experiencia laboral" returnvariable="LB_ExperienciaLaboral" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Deseable" default="Deseable"returnvariable="LB_Deseable" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Intercambiable" default="Intercambiable"returnvariable="LB_Intercambiable" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Requerido" default="Requerido"returnvariable="LB_Requerido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ExperienciaRequerida" default="Experiencia Requerida" returnvariable="LB_ExperienciaRequerida" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_PendienteDeAprobar" default="Pendiente de Aprobar" returnvariable="LB_PendienteDeAprobar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Rechazada" default="Rechazada" returnvariable="LB_Rechazada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DeseaAprobarElEstudioRealizado" default="Desea aprobar el Estudio Realizado?" returnvariable="MSG_DeseaAprobarElEstudioRealizado" component="sif.Componentes.Translate" method="Translate"/>
