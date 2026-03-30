<!--- JMRV. Inicio. Pagos a terceros. 31/07/2014 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Interfaz Pagos a Terceros'>

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
						<cfif isdefined("url.Exito") and url.Exito EQ 1>
							<font size="3" color="red">LOS PAGOS ELEGIDOS HAN SIDO ENVIADOS A PROCESAR</font>
						<cfelse>				
							<strong>Pagos</strong>
						</cfif>
						</td>
					</tr>
					
				
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
					<td>
					<input type="button" name="Generar" id="Generar" value="Generar" onclick="javascript:GenerarNomina();" />
					<!---<input type="button" name="Errores" id="Errores" value="Errores Nómina"  onclick="javascript:MostrarErrores();" />--->
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
		document.form1.action = "interfazPagoATercerosPMI-ConsultaNRCs.cfm";
		document.form1.submit();
		}
		
	function GenerarNomina(){
		document.form1.action = "interfazPagoATercerosPMI-sql.cfm";
		document.form1.submit();
		}
	
</script>

<!--- JMRV. Fin. Pagos a terceros. 31/07/2014 --->


