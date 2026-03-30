<cf_templateheader title="Envío de Órdenes de Compra Aplicadas">
		<cfquery name="hdr" datasource="#session.dsn#">
			select a.EOnumero, coalesce (a.EOtotal, 0) as EOtotal, b.SNnombre, b.SNemail, m.Msimbolo, m.Miso4217
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
				<form action="OrdenesCompra-email-apply.cfm" name="form1" id="form1" method="post" onSubmit="return validar(this)">
					<input type="hidden" name="EOidorden" id="EOidorden" value="#HTMLEditFormat(url.EOidorden)#">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td class="subTitulo tituloListas">&nbsp;</td>
							<td colspan="3" class="subTitulo tituloListas">
								<img src="OrdenesCompra-email.gif" width="37" height="12">&nbsp;&nbsp;Env&iacute;o de orden de compra
							</td>
	  					</tr>
						<tr>
							<td>&nbsp;</td>
							<td>De:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" readonly="" value="#enviadoPor# "></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Para:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" name="email" id="email" onFocus="this.select()" value="#HTMLEditFormat(Trim(hdr.SNemail))#"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
	  						<td>Cc:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" name="Ccemail" id="Ccemail" onFocus="this.select()" value="#HTMLEditFormat(Trim(hdr.SNemail))#;">&nbsp;Use punto y coma ';' como separador</td>
	  					</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Asunto:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" readonly="" value="Orden de compra N&uacute;mero #HTMLEditFormat(hdr.EOnumero)# por #HTMLEditFormat(hdr.Msimbolo)##NumberFormat(hdr.EOtotal,',0.00')#"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
	  						<td colspan="3">
								<input type="submit" value="Enviar" name="btnEnviar">
							</td>
	  					</tr>
						<tr>
	  						<td colspan="4"><hr></td>
	  					</tr>
					</table>
				</form>
	</cfoutput>
				<cfinclude template="OrdenesCompra-email-archivo.cfm">
				
			
		<cf_web_portlet_end>
	<cf_templatefooter>

<cfoutput>
<cf_qforms form="form1">
	<script language="javascript" type="text/javascript">
		objForm.email.description="#JSStringFormat('E-mail')#";
		
		function habilitarValidacion() {
			objForm.email.required = true;
		}
		
		function deshabilitarValidacion() {
			objForm.email.required = false;
		}
		
		habilitarValidacion();
		
		function isEmail(s){
			return /^[\w\.-]+@[\w-]+(\.[\w-]+)+$/.test(s);
		}
			
		function validar(f){
			if (f.email.value.length < 5) {
				alert ('Por favor indique la direccion de correo de proveedor');
				return false;
			}
			
			if (!isEmail(f.email.value)) {
				return confirm ('El correo que ha indicado no parece válido.  ¿Desea continuar?');
			}
			return true;
		}
	</script>
</cfoutput>


