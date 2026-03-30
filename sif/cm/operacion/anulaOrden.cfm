<cf_templateheader title="Anulaci&oacute;n de Ordenes de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Anulaci&oacute;n de Ordenes de Compra'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
					<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden))>
						<td align="center">
							<cfset title = "Orden de Compra">
							<cfinclude template="AREA_HEADER.cfm">
							<form name="form1" action="anulaOrden.cfm" method="post">
								<input type="hidden" name="DOobservaciones#CurrentRow#" value="#Trim(qryLista.DOobservaciones)#">
								<input type="hidden" name="DOalterna#CurrentRow#" value="#Trim(qryLista.DOalterna)#">
								<cfinclude template="../consultas/OrdenesCompra-vistaForm.cfm">	
								<input type="submit" name="btnRegresar" value="Regresar">
							</form>					
						</td>
					<cfelse>	
						<td>
							<cfinclude template="listaAnulacionOrdenes.cfm"> 
						</td>							
					</cfif>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>