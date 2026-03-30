
<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Consulta de Cesant&iacute;a Acumulada"
VSgrupo="103"
returnvariable="LB_nav__SPdescripcion"/>

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<table style="vertical-align:top" width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr><td>
				 <cf_htmlreportsheaders
							title="#LB_nav__SPdescripcion#" 
							download="true"
							method="url"
							filename="Cesantia#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
							ira="cesantia-filtro.cfm">			
			</td></tr>
			<tr>
				<td valign="top">			
					<cfinclude template="cesantia-form.cfm">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
