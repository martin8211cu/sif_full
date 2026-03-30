<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<br />
			<cfoutput>
			<form name="form1" method="get" action="Activos-rep.cfm">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td nowrap colspan="2">&nbsp;</td></tr>
					<tr>
						<td valign="top" width="40%" align="center">
							<table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr>
									<td>
										<cf_web_portlet_start border="true" titulo="Consulta de Activos" skin="info1">
											<p align="justify">
											En esta consulta se muestra la informaci&oacute;n de todos los activos según el modelo, la marca, la serie o la descrici&oacute;n de &eacute;ste. 
											Este reporte se puede generar en varios formatos - Html, pdf y xls-,
											mejorando su presentaci&oacute;n y aumentando as&iacute; su utilidad
											y eficiencia en el traslado de datos. 
											</p>
										<cf_web_portlet_end>
									</td>
								</tr>
							</table>
						</td>
						
						<td valign="top" width="60%" align="center">
							<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
								<tr>
									<td class="fileLabel" align="right">Marca:</td>
									<td rowspan="2">
										<cf_sifmarcamod tabindexMar="1" tabindexMod="1">
									</td>
								    <td class="fileLabel" align="right">Serie:</td>
								    <td>
										<input type="text" name="Aserie" size="30" maxlength="50" tabindex="1">
									</td>
								</tr>
								<tr>
								  <td class="fileLabel" align="right">Modelo:</td>
							  	  <td class="fileLabel" align="right">Descripci&oacute;n:</td>
							      <td>
										<input type="text" name="Adescripcion" size="30" maxlength="100" tabindex="1">
								  </td>
							  	</tr>
								<tr>
								  <td class="fileLabel" align="right">Formato:</td>
							  	  <td colspan="3">
								  	<select name="formato" tabindex="1">
										<option value="flashpaper">Flashpaper</option>
										<option value="pdf">Pdf</option>
										<option value="excel">Exportar a Archivo Excel</option>
										<option value="txt">Exportar a Archivo TXT</option>
									</select>
								  </td>
						      	</tr>
								<tr><td colspan="4">&nbsp;</td></tr>
								<tr>
									<td colspan="4" align="center">
										<cf_botones values="Consultar,Limpiar" tabindex="1">
									</td>
								</tr>
								<tr><td colspan="4">&nbsp;</td></tr>
							</table>
						</td>
					</tr>
					<tr><td colspan="2" align="center" valign="top">&nbsp;</td></tr>
				</table>
			</form>
			</cfoutput>
			
		<cf_web_portlet_end>
	<cf_templatefooter>