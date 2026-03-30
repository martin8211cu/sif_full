<cfinvoke key="LB_Titulo" default="Nueva Version" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"
xmlfile="NuevaVersionCE.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfset filtro = "">
		<cfset navegacion = "">

		<cfset IRA = 'AgrupadorCuentasSATCE.cfm'>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" width="50%">
					<cfinclude template="formNuevaVersionCE.cfm">
		        </td>
		    </tr>
		</table>

	<cf_web_portlet_end>
<cf_templatefooter>