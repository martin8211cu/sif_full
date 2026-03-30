<cf_templateheader title="Reporte de Saldos de Consolidados de &Oacute;rdenes de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Saldos de Consolidados de Ordenes de Compra'>
			<cfinclude template="/home/menu/pNavegacion.cfm">
			
			<!--- Carga los parámetros que vienen por url --->
			<cfif isdefined("url.ECOCid") and not isdefined("form.ECOCid")>
				<cfset form.ECOCid = url.ECOCid>
			</cfif>
			<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
				<cfset form.SNcodigo = url.SNcodigo>
			</cfif>
			<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
				<cfset form.Mcodigo = url.Mcodigo>
			</cfif>
			<cfif isdefined("url.TipoReporte") and not isdefined("form.TipoReporte")>
				<cfset form.TipoReporte = url.TipoReporte>
			</cfif>
			
			<!--- Obtiene los datos para el encabezado del correo --->
			<cfquery name="rsInfoConsolidado" datasource="#session.dsn#">
				select ecoc.ECOCnumero
				from EConsolidadoOrdenCM ecoc
				where ecoc.ECOCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECOCid#">
			</cfquery>
			
			<cfquery name="rsInfoProveedor" datasource="#session.dsn#">
				select sn.SNnombre, sn.SNemail
				from SNegocios sn
				where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			</cfquery>
			
			<cfquery name="rsInfoMoneda" datasource="#session.dsn#">
				select mon.Mnombre
				from Monedas mon
				where mon.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
					and mon.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#">
			
			<cfif form.TipoReporte eq 'R'>
				<cfset Asunto = "Reporte Resumido Consolidado Número " & HTMLEditFormat(rsInfoConsolidado.ECOCnumero) & " en " & HTMLEditFormat(rsInfoMoneda.Mnombre)>
			<cfelseif form.TipoReporte eq 'D'>
				<cfset Asunto = "Reporte Detallado Consolidado Número " & HTMLEditFormat(rsInfoConsolidado.ECOCnumero) & " en " & HTMLEditFormat(rsInfoMoneda.Mnombre)>
			</cfif>
	
			<cfoutput>
				<!--- Encabezado del correo --->
				<form action="ConsolidadoOCs-enviacorreo.cfm" name="formEnviarCorreo" method="post" onSubmit="return validar(this)">

					<input type="hidden" name="ECOCid" value="#form.ECOCid#">
					<input type="hidden" name="SNcodigo" value="#form.SNcodigo#">
					<input type="hidden" name="Mcodigo" value="#form.Mcodigo#">
					<input type="hidden" name="TipoReporte" value="#form.TipoReporte#">
					<input type="hidden" name="Asunto" value="#Asunto#">

					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td class="subTitulo tituloListas">&nbsp;</td>
							<td colspan="3" class="subTitulo tituloListas">
								<img src="OrdenesCompra-email.gif" width="37" height="12">&nbsp;&nbsp;Env&iacute;o de Consolidado de Ordenes de Compra
							</td>
	  					</tr>
						<tr>
							<td>&nbsp;</td>
							<td>De:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" readonly="" value="#enviadoPor#"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Para:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" name="email" id="email" onFocus="this.select()" value="#HTMLEditFormat(Trim(rsInfoProveedor.SNemail))#"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
	  						<td>Cc:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" name="Ccemail" id="Ccemail" onFocus="this.select()" value="#HTMLEditFormat(Trim(rsInfoProveedor.SNemail))#;">&nbsp;Use punto y coma ';' como separador</td>
	  					</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Asunto:</td>
	  						<td>&nbsp;</td>
	  						<td><input size="60" type="text" readonly="" value="#Asunto#"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
	  						<td colspan="3">
								<input type="submit" value="Enviar" name="btnEnviar">
							</td>
	  					</tr>
						<tr>
	  						<td colspan="4">&nbsp;</td>
	  					</tr>
					</table>
				</form>
			</cfoutput>
			
			<!--- Reporte a enviar en el correo --->
			<cfif form.TipoReporte eq 'R'>
				<cfinclude template="ConsolidadoOCs-represum.cfm">
			<cfelseif form.TipoReporte eq 'D'>
				<cfinclude template="ConsolidadoOCs-repdet.cfm">
			</cfif>

		<cf_web_portlet_end>
	<cf_templatefooter>

<cfoutput>
<cf_qforms form="formEnviarCorreo">
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
