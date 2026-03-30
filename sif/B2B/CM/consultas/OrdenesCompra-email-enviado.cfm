<cf_templateheader title="Envío de Órdenes de Compra Aplicadas">
		<cfquery datasource="#session.dsn#" name="hdr">
			select a.EOnumero, coalesce (a.EOtotal, 0) as EOtotal, b.SNnombre, b.SNemail, m.Msimbolo, m.Miso4217,
					a.EOImpresion
			from EOrdenCM a
				left join SNegocios b
					on b.Ecodigo = a.Ecodigo
					and b.SNcodigo = a.SNcodigo
				left join Monedas m
					on m.Ecodigo = a.Ecodigo
					and m.Mcodigo = a.Mcodigo
			where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Órdenes de Compra '>
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">
			
			<cfoutput>
				<form action="OrdenesCompra-lista.cfm" name="form1" id="form1" method="get">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td class="subTitulo tituloListas">&nbsp;</td>
	  						<td colspan="3" class="subTitulo tituloListas">
								<img src="OrdenesCompra-email.gif" width="37" height="12">&nbsp;&nbsp; El correo ha sido enviado satisfactoriamente 
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
	 					 	<td>#HTMLEditFormat(hdr.SNnombre)# &lt;#HTMLEditFormat(url.email)#&gt;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>						
	  						<td>Copia:</td>
	  						<td>&nbsp;</td>
	  						<td><cfif isdefined("url.Ccemail") and len(trim(url.Ccemail)) NEQ 0>&lt;#HTMLEditFormat(url.Ccemail)#&gt;</cfif></td>
	  					</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Asunto:</td>
	  						<td>&nbsp;</td>
	  						<td>Orden de compra N&uacute;mero #HTMLEditFormat(hdr.EOnumero)# por #HTMLEditFormat(hdr.Msimbolo)##NumberFormat(hdr.EOtotal,',0.00')#</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
	  						<td colspan="3"><input type="submit" value="Continuar" name="btnEnviar"></td>
	  					</tr>
						<tr>
	  						<td colspan="4"><hr></td>
	  					</tr>
					</table>
				</form>
	
				<cfinclude template="OrdenesCompra-email-archivo.cfm">

			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>