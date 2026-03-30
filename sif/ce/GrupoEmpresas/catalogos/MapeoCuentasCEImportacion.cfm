<cfinvoke key="LB_Regresar" default="Regresar" returnvariable="LB_Regresar" component="sif.Componentes.Translate" method="Translate"
xmlfile="MapeoCuentasCEImportacion.xml"/>
<cfset LvarAction = 'listaCatalogoCuentasSATCE.cfm?form.CAgrupador=#form.CAgrupador#'>

<cf_templateheader title="Mapeo de Cuentas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Importación del Mapeo Cuentas'>
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
		  <tr>
			<td valign="top" width="60%">
				<cf_sifFormatoArchivoImpr EIcodigo = 'CEMAPEOGE'>
			</td>
			<td align="center" style="padding-left: 15px " valign="top">

				<cf_sifimportar EIcodigo="CEMAPEOGE" mode="in"  />
			</td>
		  </tr>
		  <tr><td colspan="3" align="center"><input type="button" name="Regresar" value="<cfoutput>#LB_Regresar#</cfoutput>" onClick="javascript:location.href='<cfoutput>#LvarAction#</cfoutput>'"></td></tr>
		  <tr><td colspan="3" align="center">&nbsp;</td></tr>
		</table>

		<cflock timeout=20 scope="Session" type="Exclusive">
            <cfset session.CAgrupador = #form.CAgrupador#>
        </cflock>

	<cf_web_portlet_end>
<cf_templatefooter>