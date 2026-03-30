<cfset session.sitio.template = '/plantillas/loginPrueba/Plantilla.cfm'>

	<cf_templateheader title="Contabilidad General">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conceptos Contables'>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3">
							<cfif isdefined("session.modulo") and session.modulo EQ "CG">
								<cfinclude template="../../portlets/pNavegacionCG.cfm">
							<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
								<cfinclude template="../../portlets/pNavegacionAD.cfm">
							</cfif>				
						</td>
					</tr>
					<tr> 
						<td valign="top"> 
							<cfinvoke component="sif.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet" >
							<cfinvokeargument name="tabla" value="ConceptoContableE"/>
							<cfinvokeargument name="columnas" value="Cconcepto, Cdescripcion"/>
							<cfinvokeargument name="desplegar" value="Cconcepto, Cdescripcion"/>
							<cfinvokeargument name="etiquetas" value="Código, Descripción del Concepto"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N,N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="keys" value="Cconcepto"/>
							<cfinvokeargument name="irA" value="ConceptoContableE.cfm"/>
							</cfinvoke>
						</td>
						<td valign="top">
							<cfinclude template="formConceptoContableE.cfm">
						</td>
					</tr>
				</table>
		<cf_web_portlet_end>
	<cf_templatefooter>			
