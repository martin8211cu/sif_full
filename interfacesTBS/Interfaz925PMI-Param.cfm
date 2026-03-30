<!--- 
	Creado por: Maria de los Angeles Blanco López
		Fecha: 25 Mayo 2011
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Interfaz de Nómina'>


<cfoutput>
	<form name="form1" method="post" action="interfaz925PMI-sql.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top">
			<fieldset><legend>Datos a procesar</legend>
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
					
						<td align="left"> 							
							<strong>Pago de Nómina</strong>
						</td>
					</tr>
					
				
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
					<td>
					<input type="button" name="Generar" id="Generar" value="Generar" onclick="javascript:GenerarNomina();" />
					<input type="button" name="Errores" id="Errores" value="Errores Nómina"  onclick="javascript:MostrarErrores();" />
					</td>
					</tr>
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
<cfset session.ListaReg = "">

<script language="JavaScript1.2" type="text/javascript">
	function MostrarErrores(){
		document.form1.action = "interfaz925PMI-ConsultaNRCs.cfm";
		document.form1.submit();
		}
		
	function GenerarNomina(){
		document.form1.action = "interfaz925PMI-sql.cfm";
		document.form1.submit();
		}
	
</script>




