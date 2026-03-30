	<!---------
	Creado por: Ana Villavicencio
	Fecha: 14 de noviembre del 2005
	Motivo:	Nuevo reporte de documentos preconciliados 
----------->

<cfquery name="rsBancos" datasource="#session.DSN#">
	select *
	from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsCuentas" datasource="#session.DSN#">
	select *
	from CuentasBancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
</cfquery>
<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<cf_templateheader title="Reporte de Documentos Preconciliados">
	<cfinclude  template="../../portlets/pNavegacionMB.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Conciliaci&oacute;n Bancaria'>			
					<form action="formPreconciliacion.cfm" name="form1" method="post"  onsubmit="return sinbotones()">
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td colspan="2">
									
								</td>
							</tr>	
							
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td align="right" width="50%"><strong>Banco:&nbsp;</strong></td>
								<td>
									<select name="Bid" onChange="javascript:cambio_cuenta(this);">
										<option value="">-- seleccionar --</option>
										<cfoutput query="rsBancos">
											<option value="#rsBancos.Bid#" <cfif isdefined('form.Bid') and rsBancos.Bid EQ form.Bid>selected</cfif>>#rsBancos.Bdescripcion#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
							<tr>
								<td align="right" width="50%"><strong>Cuenta:&nbsp;</strong></td>
								<td>
									<select name="CBid" id="CBid">
										<option value="">-- seleccionar --</option>
									</select>
								</td>
							</tr>
							<tr>
								<td align="right" nowrap width="40%"><strong>Fecha del Estado de Cuenta:</strong>&nbsp;</td>
								<td>
									<cf_sifcalendario name="EChasta">
								</td>
		
							<tr><td colspan="2">&nbsp;</td></tr>

							<tr>
								<td colspan="2" align="center">
									<input type="submit" name="btnConsultar" value="Consultar">
									<input type="button" name="btnLimpiar"   value="Limpiar" onClick="javascript:limpiar(this);">
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
						</table>
					</form>            	
	<cf_web_portlet_end>	
<cf_templatefooter>
<script language="JavaScript1.2">
	function limpiar(obj){
		var form = obj.form
		form.EChasta.value          = "";
		form.Bid.value			 = '';
		form.CBid.value			 = '';
	}

		function cambio_cuenta(obj){
			var form = obj.form;
			var combo = form.CBid;
			
			combo.length = 1;
			combo.options[0].text = '-- seleccionar --';
			combo.options[0].value = '';

			var i = 1;
			<cfoutput query="rsCuentas">
				var tmp = #rsCuentas.Bid# ;
				if ( obj.value != '' && tmp != '' && parseFloat(obj.value) == parseFloat(tmp) ) {
					combo.length++;
					combo.options[i].text = '#rsCuentas.CBdescripcion#';
					combo.options[i].value = '#rsCuentas.CBid#';
					<cfif (isdefined("form.CBid") and len(trim(form.CBid)) and form.CBid eq rsCuentas.CBid)>
						combo.options[i].selected=true;
					</cfif>
					i++;

				}
				
			</cfoutput>
		}
		
	function _forminit(){
		var form = document.form1;
		cambio_cuenta(form.Bid);
	}
	_forminit();
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	/*-------------------------*/		
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_allowSubmitOnError = false;
	
	
	objForm.Bid.required = true;
	objForm.Bid.description = "Banco";
	objForm.CBid.required = true;
	objForm.CBid.description = "Cuenta";
	objForm.EChasta.required = true;
	objForm.EChasta.description = "Fecha del Estado de Cuenta";
</script>