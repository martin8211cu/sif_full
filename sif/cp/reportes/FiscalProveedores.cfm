<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_RepFisProv	= t.Translate('TIT_RepFisProv','Reporte Fiscal de Proveedores')>
<cfset LB_DatosRep 		= t.Translate('LB_DatosRep','Datos del Reporte')>
<cfset LB_Desde		= t.Translate('LB_Desde','Desde','/sif/generales.xml')>
<cfset LB_Hasta		= t.Translate('LB_Hasta','Hasta','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
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
<cfset Oficina 			= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Todos" default="Todos" 
returnvariable="LB_Todos" xmlfile="BalanzaDetalle.xml"/>

<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_RepFisProv#'>
  <cfinclude template="../../cg/consultas/Funciones.cfm">
  <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
  <cfset periodo="#get_val(50).Pvalor#">
  <cfset mes="#get_val(60).Pvalor#">
  
  <cfquery datasource="#Session.DSN#" name="rsOficinas">
    select Ocodigo, Odescripcion
    from Oficinas 
    where Ecodigo = #Session.Ecodigo#
    order by Ocodigo 
</cfquery>
<form name="form1" method="get" action="FiscalProveedores-SQL.cfm">

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend><cfoutput>#LB_DatosRep#</cfoutput></legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td align="left"><strong>#LB_Desde#:&nbsp;</strong></td>
					<td align="left"><strong>#LB_Hasta#:&nbsp;</strong></td>
					<td align="left">&nbsp;</td>
					<td colspan="2">&nbsp;</td>
                    </cfoutput>
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
                  </tr>
                  <tr>
				  <td>&nbsp;</td>
				  <td align="left" nowrap="nowrap"><strong><cfoutput>#Oficina#:</cfoutput></strong></td><tr></tr><td>&nbsp;</td>
						<td align="left"><select name="Ocodigo" id="select" tabindex="14">
                          <cfoutput><option value="-1">#LB_Todos#</option></cfoutput>
                          <cfoutput query="rsOficinas">
                            <option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
                          </cfoutput>
                        </select></td>
						<td nowrap align="left">&nbsp;</td>
			    </tr>
				
				
				<tr>
                	<cfoutput>
				  <td>&nbsp;</td>
				  <td align="left"><strong>#LB_Formato#&nbsp;</strong></td>
				  <td align="left">&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
                	</cfoutput>
			    </tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="2" align="left"><div align="left">
					  
					  <select name="Formato" id="Formato" tabindex="1">
					    <option value="pdf">PDF</option>
                        <option value="Excel">Microsoft Excel</option>
				      </select>
				  </div></td>
					<td>&nbsp;</td>
				    <td>&nbsp;</td>
				</tr>
				
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar">					</td>
				</tr>
			</table>
			</fieldset>
		</td>	
	</tr>
</table>
</form>

<cf_web_portlet_end>
<cf_templatefooter>