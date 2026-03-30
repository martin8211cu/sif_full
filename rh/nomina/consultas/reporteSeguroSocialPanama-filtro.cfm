<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeSeguroSocialPanama" Default="Reporte de Seguro Social Panam&aacute;" returnvariable="LB_ReporteDeSeguroSocialPanama"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>											

<cfset rsPeriodo = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodo,3)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now())-2,1)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now())-1,2)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now()),3)>

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeSeguroSocialPanama#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">			
			<cfoutput>
				<form method="post" name="form1" action="" style="margin:0;" >
					<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
							<td width="45%" valign="top">
								<table width="100%" >
									<tr>
										<td valign="top">
											<cf_web_portlet_start border="true" titulo="#LB_ReporteDeSeguroSocialPanama#" skin="info1">
										  		<div align="justify">
										  			<p>
													<cf_translate  key="LB_ReporteDeSeguroSocialPanama">
													Reporte de planillas para el seguro social Panama
													</cf_translate>
													</p>
												</div>
											<cf_web_portlet_end>									  
										</td>
									</tr>
								</table>  
							</td>
							<td valign="top">
								<table width="100%" cellpadding="2" cellspacing="2" align="center">
									<tr>
										<td align="right"><strong><cf_translate  key="LB_Periodo">Periodo</cf_translate>:&nbsp;</strong></td>
										<td>
											<select name="periodo">
												<cfloop query="rsPeriodo">
													<option value="#Pvalor#" <cfif Year(Now()) eq Pvalor> selected </cfif>>#Pvalor#</option>
												</cfloop>
											</select>
										</td>
									</tr>
									<tr>
										<td align="right"><strong><cf_translate  key="LB_Mes">Mes</cf_translate>:&nbsp;</strong></td>
										<td>
											<select name="mes">
											<cfloop query="rsMeses">
												<option value="#Pvalor#" <cfif Month(Now()) eq Pvalor>selected</cfif>>#Pdescripcion#</option>
											</cfloop>
											</select>
										</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td>
											<input type="radio" name="opt_impresion" value="1" checked><label for="opt_impresion">
											<cf_translate key="LB_Impresion">Impresi&oacute;n</cf_translate></label>
										</td>
									</tr>
									<tr>	
										<td>&nbsp;</td>
										<td>
											<input type="radio" name="opt_impresion" value="2"><label for="opt_impresion">
											<cf_translate key="LB_GenerarArchivoDeTexto">Generar archivo de texto</cf_translate></label>
										</td>
									</tr>
									<tr><td colspan="2">&nbsp;</td></tr>
									<tr>
										<td align="center" colspan="2">
											<input type="submit" onClick="javascript: funcConsultar();" name="Consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
										</td>
									</tr>
									<tr><td colspan="2">&nbsp;</td></tr>
								</table>
							</td>	
						</tr>
					</table>
				</form>
			</cfoutput>				
		<cf_web_portlet_end>
	<cf_templatefooter>
	<script type="text/javascript" language="javascript1.2">
		function funcConsultar(){
			if(document.form1.opt_impresion[0].checked){
				document.form1.action='reporteSeguroSocialPanama-form.cfm';
				document.form1.submit();
			}
			else{
				document.form1.action='txtNominaDHCPanama.cfm';
				document.form1.submit();			
			}
		}
		
	</script>