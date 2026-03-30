
<cf_templateheader title="SIF - Inventarios">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte Precios de mercado de productos'>
  <cfinclude template="../../cg/consultas/Funciones.cfm">
  <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<!---   <cfset periodo="#get_val(30).Pvalor#">
  <cfset mes="#get_val(40).Pvalor#"> --->
  
    <cfset periodo="#get_val(50).Pvalor#">
  <cfset mes="#get_val(60).Pvalor#">

<form name="form1" method="get" action="Precios-SQL.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>Datos del Reporte</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
				  <td align="left"><strong>Periodo:&nbsp;</strong></td>
				  <td align="left" nowrap="nowrap">
				  <select name="periodo">
                    <option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
                    <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
                    <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
                    <option value="<cfoutput>#periodo+1#</cfoutput>"><cfoutput>#periodo+1#</cfoutput></option>
                    <option value="<cfoutput>#periodo+2#</cfoutput>"><cfoutput>#periodo+2#</cfoutput></option>
                  </select>
				  </td>
				  <td align="left"><strong>Mes:&nbsp;</strong></td>
				  <td align="left" nowrap="nowrap">
				    <select name="mes" size="1">
                      <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
                      <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
                      <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
                      <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
                      <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
                      <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
                      <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
                      <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
                      <option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
                      <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
                      <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
                      <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
                    </select>
					</td>
			    </tr>
				
				
				<tr>
				  <td align="left"><strong>Formato:&nbsp;</strong></td>
				  <td align="left" colspan="3">
				  	<select name="Formato" id="Formato" tabindex="1">
					    <option value="flashpaper">FLASHPAPER</option>
					    <option value="pdf">PDF</option>
				    </select>
				   </td>
			    </tr>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
				  <td colspan="4">
					<cf_botones values="Generar" names="Generar">					
				  </td>
				</tr>
			</table>
			</fieldset>
		</td>	
	</tr>
</table>
</form>
<cf_web_portlet_end>
<cf_templatefooter>