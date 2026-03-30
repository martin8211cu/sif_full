<cf_templateheader title="Envío de solicitud de aprobación de pago">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Envío de solicitud de aprobación de pago'>
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">
			<cfoutput>
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td class="subTitulo tituloListas">&nbsp;</td>
	  						<td colspan="3" class="subTitulo tituloListas">
								<img src="solicitudes-email.gif" width="37" height="12">&nbsp;&nbsp; El correo ha sido enviado satisfactoriamente 
							</td>
	  					</tr>
						<tr>
							<td>&nbsp;</td>
							<td>De:</td>
	  						<td>&nbsp;</td>
	  						<td>#enviadoPor#</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Para:</td>
	  						<td>&nbsp;</td>
	 					 	<td>#HTMLEditFormat(url.email)#</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Asunto:</td>
	  						<td>&nbsp;</td>
	  						<td>Aprobacion de Solicitud de Pago #url.TESSPnumero#</td>
						</tr>
						<tr>
	  						<td align="center" colspan="4"><input type="button" value="Cerrar Ventana" name="btnCerrar" onclick="fnCerrar()"></td>
	  					</tr>
						<tr>
	  						<td colspan="4"><hr></td>
	  					</tr>
					</table>

			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>
   <script lnguage="javascript">
   function fnCerrar(){
	    window.parent.close();
	}
   </script>