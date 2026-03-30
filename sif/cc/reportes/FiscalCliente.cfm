<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<cfinclude template="../../cg/consultas/Funciones.cfm">
<cfset periodo="#get_val(50).Pvalor#">
<cfset mes="#get_val(60).Pvalor#">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset TIT_RepFisc = t.Translate('TIT_RepFisc','Reporte Fiscal de Clientes')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset LB_Desde = t.Translate('LB_Desde','Desde','/sif/generales.xml')>
<cfset LB_Hasta = t.Translate('LB_Hasta','Hasta','/sif/generales.xml')>

<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">
	<cfinclude template="../../portlets/pNavegacionCC.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_RepFisc#'>
		<form name="form1" method="get" action="FiscalCliente-SQL.cfm">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr><td valign="top"><fieldset><legend><cfoutput>#LB_DatosReporte#</cfoutput></legend>
					<table  width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr><td colspan="6">&nbsp;</td></tr>
						<tr>
							<td>&nbsp;</td>
							<td align="left"><strong><cfoutput>#LB_Desde#:&nbsp;</cfoutput></strong></td>
							<td align="left"><strong><cfoutput>#LB_Hasta#:&nbsp;</cfoutput></strong></td>
							<td align="left">&nbsp;</td>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
						  <td>&nbsp;</td>
						  <td align="left" nowrap="nowrap"><select name="periodo">
							<option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
							<option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
							<option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
							<option value="<cfoutput>#periodo+1#</cfoutput>"><cfoutput>#periodo+1#</cfoutput></option>
							<option value="<cfoutput>#periodo+2#</cfoutput>"><cfoutput>#periodo+2#</cfoutput></option>
						  </select>
                          <cfoutput>
							<select name="mes" size="1">
							  <option value="1" <cfif mes EQ 1>selected</cfif>>#CMB_Enero#</option>
							  <option value="2" <cfif mes EQ 2>selected</cfif>>#CMB_Febrero#</option>
							  <option value="3" <cfif mes EQ 3>selected</cfif>>#CMB_Marzo#</option>
							  <option value="4" <cfif mes EQ 4>selected</cfif>>#CMB_Abril#</option>
							  <option value="5" <cfif mes EQ 5>selected</cfif>>#CMB_Mayo#</option>
							  <option value="6" <cfif mes EQ 6>selected</cfif>>#CMB_Junio#</option>
							  <option value="7" <cfif mes EQ 7>selected</cfif>>#CMB_Julio#</option>
							  <option value="8" <cfif mes EQ 8>selected</cfif>>#CMB_Agosto#</option>
							  <option value="9" <cfif mes EQ 9>selected</cfif>>#CMB_Septiembre#</option>
							  <option value="10" <cfif mes EQ 10>selected</cfif>>#CMB_Octubre#</option>
							  <option value="11" <cfif mes EQ 11>selected</cfif>>#CMB_Noviembre#</option>
							  <option value="12" <cfif mes EQ 12>selected</cfif>>#CMB_Diciembre#</option>
							</select>
                          </cfoutput>  
                          </td>
						  <td align="left" nowrap="nowrap"><select name="periodo2">
							<option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
							<option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
							<option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
							<option value="<cfoutput>#periodo+1#</cfoutput>"><cfoutput>#periodo+1#</cfoutput></option>
							<option value="<cfoutput>#periodo+2#</cfoutput>"><cfoutput>#periodo+2#</cfoutput></option>
						  </select>
                          <cfoutput>
							<select name="mes2" size="1">
							  <option value="1" <cfif mes EQ 1>selected</cfif>>#CMB_Enero#</option>
							  <option value="2" <cfif mes EQ 2>selected</cfif>>#CMB_Febrero#</option>
							  <option value="3" <cfif mes EQ 3>selected</cfif>>#CMB_Marzo#</option>
							  <option value="4" <cfif mes EQ 4>selected</cfif>>#CMB_Abril#</option>
							  <option value="5" <cfif mes EQ 5>selected</cfif>>#CMB_Mayo#</option>
							  <option value="6" <cfif mes EQ 6>selected</cfif>>#CMB_Junio#</option>
							  <option value="7" <cfif mes EQ 7>selected</cfif>>#CMB_Julio#</option>
							  <option value="8" <cfif mes EQ 8>selected</cfif>>#CMB_Agosto#</option>
							  <option value="9" <cfif mes EQ 9>selected</cfif>>#CMB_Septiembre#</option>
							  <option value="10" <cfif mes EQ 10>selected</cfif>>#CMB_Octubre#</option>
							  <option value="11" <cfif mes EQ 11>selected</cfif>>#CMB_Noviembre#</option>
							  <option value="12" <cfif mes EQ 12>selected</cfif>>#CMB_Diciembre#</option>
							</select>
                          </cfoutput>  
                          </td>
						  <td align="left">&nbsp;</td>
						  <td colspan="2">&nbsp;</td>
						</tr>
						<tr>
						  <td>&nbsp;</td>
						  <td align="left"><strong><cfoutput>#LB_Formato#&nbsp;</cfoutput></strong></td>
						  <td align="left">&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td colspan="2" align="left"><div align="left">
							  <select name="Formato" id="Formato" tabindex="1">
								<option value="flashpaper">FLASHPAPER</option>
								<option value="pdf">PDF</option>
								<option value="Excel">Microsoft Excel</option>
							  </select>
						  </div></td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr><td colspan="6">&nbsp;</td></tr>
						<tr><td colspan="6"><cf_botones values="Generar" names="Generar"></td></tr>
					</table>
					</fieldset>
				</td>	
			</tr>
		</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>