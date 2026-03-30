<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#"
Default="Recursos Humanos"
VSgrupo="103"
returnvariable="nombre_modulo"/>

<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Conceptos de Pago por Hora"
VSgrupo="103"
returnvariable="nombre_proceso"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Concepto_de_Pago"
Default="Concepto de Pago"
xmlfile="/rh/generales.xml"
returnvariable="vConcepto"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Fecha_Rige"
Default="Fecha Rige"
xmlfile="/rh/generales.xml"
returnvariable="vFechaRige"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Fecha_Vence"
Default="Fecha Vence"
xmlfile="/rh/generales.xml"
returnvariable="vFechaVence"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Hora_Inicio"
Default="Hora Inicio"
returnvariable="vHoraInicio"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Hora_Fin"
Default="Hora fin"
returnvariable="vHoraFin"/>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nombre_modulo#</cfoutput>	</cf_templatearea>
	<cf_templatearea name="body">
	<cf_templatecss>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start titulo="#nombre_proceso#">
					  	<cfinclude template="/rh/portlets/pNavegacion.cfm">
					  	<cfinclude template="IncidenciasHora-form.cfm">
					<cf_web_portlet_end>				
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>
