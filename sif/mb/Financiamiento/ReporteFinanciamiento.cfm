<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_ReptFin	= t.Translate('TIT_RepFisProv','Reporte Financiamiento')>
<cfset LB_DatosRep 		= t.Translate('LB_DatosRep','Datos del Reporte')>
<cfset LB_Buq		= t.Translate('LB_Buq','Buque')>
<cfset LB_Hasta		= t.Translate('LB_Hasta','Hasta','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>

<cfquery name="ConsBuques" datasource="#session.dsn#">
	select * from EncFinanciamiento
	where Ecodigo = #Session.Ecodigo#
</cfquery>



<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_ReptFin#'>
  <cfinclude template="../../cg/consultas/Funciones.cfm">
  <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
  <cfset periodo="#get_val(50).Pvalor#">
  <cfset mes="#get_val(60).Pvalor#">
<form name="form1" method="get" action="ReporteFinanciamiento-SQL.cfm" onsubmit="return validaOption();">

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
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="left"><strong>#LB_Buq#:&nbsp;</strong></td>
					<td align="left"><strong>#LB_Formato#&nbsp;</strong></td>
					<td align="left">&nbsp;</td>
					<td colspan="2">&nbsp;</td>
                    </cfoutput>
				</tr>
				<tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td align="left" nowrap="nowrap"><select name="Buque">
					<option value="-1">--&nbsp;Selecciona&nbsp;--</option>
					<cfoutput>
						<cfloop query="ConsBuques">
							<option value="#ConsBuques.IDFinan#">#ConsBuques.Documento#</option>
						</cfloop>
					</select>
                	</cfoutput>
                  </td>
				  <td colspan="2" align="left"><div align="left">

					  <select name="Formato" id="Formato" tabindex="1">
					    <option value="flashpaper">FLASHPAPER</option>
					    <option value="pdf">PDF</option>
					    <option value="Excel">Microsoft Excel</option>
				      </select>
				  </div></td>
			    </tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="5">
					<cf_botones values="Generar" names="Generar">					</td>
				</tr>
			</table>
			</fieldset>
		</td>
	</tr>
</table>
</form>
<script>

function validaOption(){
	if(form1.Buque.value == '-1'){
alert('Es necesario indicar el Buque');
	return false;
		}else{
return true;}


}
</script>


<cf_web_portlet_end>
<cf_templatefooter>