<!--- VARIBLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CertificacionesDeRH" Default="Certificaciones de RH" returnvariable="LB_CertificacionesDeRH"/> 
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/sif/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO" Default="C&oacute;digo" XmlFile="/sif/generales.xml" returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" Default="Descripci&oacute;n del Formato" returnvariable="LB_DESCRIPCION"/>			
<cfinvoke Key="LB_Filtrar" Default="Filtrar" returnvariable="LB_Filtrar" XmlFile="/sif/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Nuevo" Default="Nuevo" returnvariable="LB_Nuevo"  component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Autor" Default="Autor" returnvariable="LB_Autor" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIBLES DE TRADUCCION --->
<cfset va_arrayCategoria=ArrayNew(1)>

<cf_templateheader title="#LB_RecursosHumanos#">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cf_web_portlet_start border="true" titulo="#LB_CertificacionesDeRH#" skin="#Session.Preferences.Skin#">			
			<cfinclude template="../portlets/pNavegacionAD.cfm">
			<table width="100%" border="0" cellspacing="1" cellpadding="1">			
				<!----LISTA---->
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="1" cellpadding="1">
						  <tr>
							<td valign="top" width="45%">
								<cfquery name="rsLista" datasource="#session.DSN#">
									select a.EFid, a.EFcodigo, a.EFdescripcion
									from EFormato a
										inner join TFormatos b
											on b.TFid = a.TFid
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									order by a.EFcodigo
								</cfquery>
									<cf_translatedata name="get" tabla="EFormato" col="a.EFdescripcion" returnvariable="LvarEFdescripcion">
								<cfinvoke 
									component="commons.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRet"
									columnas="a.EFid, a.EFcodigo, #LvarEFdescripcion# as EFdescripcion"
									tabla="EFormato a
											inner join TFormatos b
												on b.TFid = a.TFid"
									filtro="a.Ecodigo = #Session.Ecodigo#
											order by a.EFcodigo"
									desplegar="EFcodigo, EFdescripcion"
									etiquetas="#LB_CODIGO#, #LB_DESCRIPCION#"
									formatos="S,S"
									filtrar_por="EFcodigo, EFdescripcion"
									mostrar_filtro="true"
									filtrar_automatico="true"
									TranslateDataCols="EFdescripcion"
									align="left, left"
									ira="Formatos.cfm"
									showEmptyListMsg="true"
									/>	
							</td>				
						  </tr>
						</table>		        
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<cfoutput>
				<tr><td align="center"><input type="button" name="btnNuevo" value="#LB_Nuevo#" onClick="javascript: funcNuevo();"></td></tr>
				</cfoutput>
			</table>
			<script type="text/javascript">
				function funcNuevo(){
					location.href = 'Formatos.cfm';
				}
			</script>
	<cf_web_portlet_end>
<cf_templatefooter>
