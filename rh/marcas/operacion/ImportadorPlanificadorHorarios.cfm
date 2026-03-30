<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RHRHImportadoresDeMarcas"
	Default="RH-Importadores de Horarios Jornada"
	returnvariable="LB_RHRHImportadoresDeHorarios"/>

<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Importar Horarios Jornada"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
</cfsilent>
<cf_templateheader title="#LB_RHRHImportadoresDeHorarios#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#nombre_proceso#">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
		    <td colspan="3" align="center">&nbsp;</td>
	      </tr>
		  <tr>
		    <td align="center" width="2%">&nbsp;</td>
		    <td align="center" valign="top" width="60%">
			   <cf_sifFormatoArchivoImpr EIcodigo = 'P-HORARIOS'>
			</td>
			<td align="center" style="padding-left: 15px " valign="top">
				<cf_sifimportar EIcodigo="P-HORARIOS" mode="in" />
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>