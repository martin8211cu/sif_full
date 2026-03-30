<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Parametrizaci&oacute;n de Origenes Contables">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<cfinclude template="../../portlets/pNavegacionAD.cfm">
					</td>
				</tr>
				<tr> 
					<td  width="50%" valign="top"> 
						<table  width="100%" cellpadding="2" cellspacing="0" border="0" >
							<tr>
								<td valign="top"> <cfinclude template="lista_origenes-Filtro.cfm"></td>
							</tr>
							<tr>
								<td valign="top">
									<cfquery name="rslista" datasource="#Session.DSN#">
										select a.Oorigen,Cdescripcion,coalesce(OPconst,OPtablaMayor) as mayor
										from OrigenDocumentos a ,ConceptoContable b
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										and a.Ecodigo = b.Ecodigo
										and a.Oorigen = b.Oorigen
										<cfif isdefined("Form.fOorigen") and len(trim(form.fOorigen))>
											and upper(a.Oorigen) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Trim(UCase(form.fOorigen))#%">
										</cfif>
										order by a.Oorigen
									</cfquery>							
								    <cfinvoke 
										component="sif.Componentes.pListas"
										method="pListaQuery"
										returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rslista#"/>
											<cfinvokeargument name="desplegar" 	value="Oorigen,Cdescripcion,mayor"/>
											<cfinvokeargument name="etiquetas" 	value="Origen,Descripci&oacute;n,Mayor"/>
											<cfinvokeargument name="formatos" value="V,V,V"/>
											<cfinvokeargument name="align" value="left,left,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="debug" value="N"/>
											<cfinvokeargument name="keys" value="Oorigen"/> 
   											<cfinvokeargument name="showEmptyListMsg" value= "1"/>
											<cfinvokeargument name="irA" value= "lista_origenes.cfm"/>
									</cfinvoke>
									
								</td>
							</tr>
						</table>
				</td>
				<td valign="top">
					<cfinclude template="formlista_origenes.cfm"> 
				</td>
			</tr>
		</table>
<cf_web_portlet_end>
<cf_templatefooter>