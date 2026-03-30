<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Tipos de Homologación de Cuentas" 
returnvariable="LB_Titulo" xmlfile="ANhomologacion.xml"/>

<cf_templateheader title="#LB_Titulo# ">
	<cf_web_portlet_start titulo="#LB_Titulo#">

		<cf_navegacion name="Ecodigo"	default="#session.Ecodigo#" navegacion="">
		<cf_navegacion name="GODid"		default="" navegacion="">
		<table width="100%" align="center">
			<tr>
				<td width="48%" valign="top">
					<cfinclude template="ANhomologacion_form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>


