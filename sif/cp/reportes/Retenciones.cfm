<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 	= t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_RepRet	= t.Translate('TIT_RepRet','Reporte Retenciones')>
<cfset LB_DatosRep	= t.Translate('LB_DatosRep','Datos del Reporte','FiscalProveedores.xml')>
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
<cfset LB_TipoProv	= t.Translate('LB_TipoProv','Tipo de Proveedores')>
<cfset LB_Retencion	= t.Translate('LB_Retencion','Retenci&oacute;n')>
<cfset LB_Todos		= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Nacionales	= t.Translate('LB_Nacionales','Nacionales')>
<cfset LB_Extranjeros = t.Translate('LB_Extranjeros','Extranjeros')>
<cfset LB_Todas		= t.Translate('LB_Todas','Todas','/sif/generales.xml')>

<cf_templateheader title="SIF - Cuentas por Pagar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_RepRet#'>
  <cfinclude template="../../cg/consultas/Funciones.cfm">
  <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
  <cfset periodo="#get_val(50).Pvalor#">
  <cfset mes="#get_val(60).Pvalor#">
<form name="form1" method="POST" action="">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend><cfoutput>#LB_DatosRep#</cfoutput></legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
            	<cfoutput>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><strong>#LB_Desde#:&nbsp;</strong></td>
					 <td align="left"><strong>#LB_Hasta#:&nbsp;</strong></td>
					  <td align="left">&nbsp;</td>
					<td colspan="2">&nbsp;</td>
				</tr>
                </cfoutput>
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
                <cfoutput>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><strong>#LB_TipoProv#:&nbsp;</strong></td>
					 <td align="left"><strong>#LB_Retencion#:&nbsp;</strong></td>
					  <td align="left">&nbsp;</td>
					<td colspan="2">&nbsp;</td>
				</tr>
                </cfoutput>
				<tr>
				  <td>&nbsp;</td>
				  <td align="left" nowrap="nowrap">
                  <cfoutput>
				  <select name="TipoSocio" size="1">
                      <option value="T" selected="selected" >#LB_Todos#</option>
                      <option value="N" >#LB_Nacionales#</option>
                      <option value="E" >#LB_Extranjeros#</option>
                    </select>
                  </cfoutput>  
				  </td>
                  
				  <td align="left" nowrap="nowrap">
					<cfquery name="rsRetenciones" datasource="#Session.DSN#">
						select Rcodigo, Rdescripcion 
						from Retenciones 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						order by Rdescripcion
					</cfquery>					
					<select name="Rcodigo" tabindex="1">
						<option value="" ><cfoutput>-- #LB_Todas# --</cfoutput></option>
						<cfoutput query="rsRetenciones"> 
							<option value="#rsRetenciones.Rcodigo#">
								#rsRetenciones.Rdescripcion#
							</option>
						</cfoutput> 
					</select>
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
					    <option value="pdf">PDF</option>
					    <option value="excel">Excel</option>
					    <option value="html">HTML</option>
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

<script type="text/javascript">

	function funcGenerar()
	{
		var valCombo = document.getElementById('Formato').selectedIndex;
		
		if(valCombo == 3)
		{
			document.form1.action = "RetencionesHTML.cfm";
		}
		else 
		{
			document.form1.method = "get";
			document.form1.action = "Retenciones-SQL.cfm";
		}
		
		return true;
	}
</script>

<cf_web_portlet_end>
<cf_templatefooter>