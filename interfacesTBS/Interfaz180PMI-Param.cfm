<!--- 
	Creado por: Maria de los Angeles Blanco López
		Fecha: 25 Mayo 2011
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Interfaz de Nómina'>


<cfoutput>
	<form name="form1" method="post" action="interfaz180PMI-sql.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top">
			<fieldset><legend>Datos a procesar</legend>
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
					
						<td align="center"> 
							
							<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Pago de Nómina</strong>
							<!---<input type="checkbox" name="NNomina" value="1" tabindex="3"/>--->
						</td>
					</tr>
					
				<!---	<tr align="center">
						<td colspan="10">
							
							<strong>&nbsp;Cancelación Nómina</strong>
							<input type="checkbox" name="CNomina" value="1" tabindex="4"/>
						</td>
					</tr>--->		
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="6"></td></tr>
				</table>
				</fieldset>
			</td>	
		</tr>
	</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<!---<script language="javascript" type="text/javascript">
	function funcGenerar()
		{
			var aplicann = false;
			var aplicacn = false;
			if ( document.form1.NNomina ||  document.form1.CNomina) {
				aplicann = document.form1.NNomina.checked;
				aplicacn =  document.form1.CNomina.checked;
			}
			else {
				alert('Debe Seleccionar el tipo de Nómina que desea generar');
				return false;
			}
			if (aplicann || aplicacn) 
				return true;
			else {
				alert('Debe Seleccionar el tipo de Nómina que desea generar');
				return false;
			}
		}
</script>--->

<cfset session.ListaReg = "">
