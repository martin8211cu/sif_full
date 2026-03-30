<cf_templateheader title="Detalle de Impuestos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Impuestos - Detalle'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td valign="top" width="50%"> 
						<cfquery name="rsComponentes" datasource="#session.DSN#">
							select Ecodigo, Icodigo, DIcodigo, DIporcentaje, DIdescripcion, 
								case DIcreditofiscal when 0 then '<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>' 
								else '<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>' end as DIcreditofiscal, 
								Usucodigo, DIfecha
							from DImpuestos	
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
							order by DIcodigo, DIdescripcion
						</cfquery>
						<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pListaQuery"
							 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsComponentes#"/>
							<cfinvokeargument name="desplegar" value="DIcodigo, DIdescripcion, DIporcentaje, DIcreditofiscal"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Porcentaje, C.F."/>
							<cfinvokeargument name="formatos" value="S,S,M,S"/>
							<cfinvokeargument name="align" value="left,left,right,right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="DetImpuestos.cfm"/>
							<cfinvokeargument name="Keys" value="	DIcodigo"/>
						</cfinvoke>
					</td>
					<td valign="top" width="50%">
						<cfinclude template="formDetImpuestos.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>	
<cf_templatefooter>
