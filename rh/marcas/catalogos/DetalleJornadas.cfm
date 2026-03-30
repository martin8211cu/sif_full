<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#"
Default="Recursos Humanos"
VSgrupo="103"
returnvariable="nombre_modulo"/>

<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Detalle de Jornadas"
VSgrupo="103"
returnvariable="nombre_proceso"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Codigo"
Default="C&oacute;digo"
xmlfile="/rh/generales.xml"
returnvariable="vCodigo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripci&oacute;n"
xmlfile="/rh/generales.xml"
returnvariable="vDescripcion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Lunes"
Default="Lunes"
xmlfile="/rh/generales.xml"
returnvariable="vLunes"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Martes"
Default="Martes"
xmlfile="/rh/generales.xml"
returnvariable="vMartes"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Miercoles"
Default="Mi&eacute;rcoles"
xmlfile="/rh/generales.xml"
returnvariable="vMiercoles"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Jueves"
Default="Jueves"
xmlfile="/rh/generales.xml"
returnvariable="vJueves"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Viernes"
Default="Viernes"
xmlfile="/rh/generales.xml"
returnvariable="vViernes"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Sabado"
Default="S&aacute;bado"
xmlfile="/rh/generales.xml"
returnvariable="vSabado"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Domingo"
Default="Domingo"
xmlfile="/rh/generales.xml"
returnvariable="vDomingo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Jornada"
Default="Jornada"
xmlfile="/rh/generales.xml"
returnvariable="vJornada"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Almuerzo"
Default="Almuerzo"
returnvariable="vAlmuerzo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Modificar"
Default="Modificar"
xmlfile="/rh/generales.xml"
returnvariable="vModificar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_De"
Default="De"
xmlfile="/rh/marcas/catalogos/JornadasComp.xml"
returnvariable="vDE"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_A"
Default="A"
xmlfile="/rh/marcas/catalogos/JornadasComp.xml"
returnvariable="vA"/>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nombre_modulo#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#nombre_proceso#'>
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellspacing="2" cellpadding="0">
				<tr> 
					<td width="45%" valign="top"> 
						<cfinvoke 
							component="rh.Componentes.pListas" 
							method="pListaRH"
							returnvariable="rsLista"
							columnas="RHJid,RHJcodigo,RHJdescripcion"
							etiquetas="#vCodigo#,#vDescripcion#"
							tabla="RHJornadas"
							keys="RHJid"
							filtro="Ecodigo=#Session.Ecodigo# order by RHJcodigo,RHJdescripcion"
							mostrar_filtro="true"
							filtrar_automatico="true"
							desplegar="RHJcodigo,RHJdescripcion"
							filtrar_por="RHJcodigo,RHJdescripcion"
							align="left,left"				
							formatos="S,S"
							ira="DetalleJornadas.cfm"
							maxrows="20"
							showemptylistmsg="true"
						/>		
					</td>
					<td valign="top" align="center">
						<cfinclude template="DetalleJornadas-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>