<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_TablasSalariales" default="Tablas Salariales" returnvariable="LB_TablasSalariales" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SituacionActual" default="Situaci&oacute;n Actual" returnvariable="LB_SituacionActual"component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_OcupacionDePlazas" default="Ocupaci&oacute;n de Plazas" returnvariable="LB_OcupacionDePlazas" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_SolicitudDePlazas" default="Solicitud de Plazas" returnvariable="LB_SolicitudDePlazas" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_OtrasPartidas" default="Otras Partidas" returnvariable="LB_OtrasPartidas"component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_CargasPatronales" default="Cargas Patronales" returnvariable="LB_CargasPatronales"component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" default="Escenarios" vsgrupo="103" returnvariable="nombre_proceso"/>