
<cfset LvarIrAformConciliacionRes = "formConciliacionResumida.cfm">
<cfset LvarTitulo = "Reporte de Conciliaci&oacute;n Bancaria Resumido">
<cfif isdefined("LvarConciliacionResumida")>
	<cfset LvarIrAformConciliacionRes = "formConciliacionResumidaTCE.cfm">
	<cfset LvarTitulo = "Reporte de Conciliaci&oacute;n Bancaria Resumido TCE">
</cfif> 


<cfif not isdefined("form.ECid") and  isdefined("url.ECid")>
	<cfset form.CBid = url.ECid>
</cfif>

<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
	
<cf_templateheader title="#LvarTitulo#">
	<cfinclude  template="../../portlets/pNavegacionMB.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarTitulo#'>			
		<!---Para utilizar en Bancos con formConciliacionResumida.cfm o en TCE con formConciliacionResumidaTCE.cfm--->
		<form name="form1" method="post" onsubmit="return sinbotones()"  action="<cfoutput>#LvarIrAformConciliacionRes#</cfoutput>">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td align="right" width="50%"><strong>Conciliaciones </strong></td>
					<td>				
						<select name="Conciliaciones">
							<option value="-1">Todas</option>
							<option value="1">Aplicadas</option>
							<option value="2">No Aplicadas</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right" width="50%"><strong>Fecha del Estado de Cuenta:&nbsp;</strong></td>
					<td>
							<cf_sifcalendario name="EChasta">
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" name="btnConsultar" value="Consultar">
						<input type="button" name="btnLimpiar"   value="Limpiar" onClick="javascript:limpiar(this);">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</form>            	
	 <cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2">
		
	function limpiar(obj){
		var form = obj.form
		form.EChasta.value = "";
		form.Bid.value			 = '';
		form.CBid.value			 = '';
	}
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	/*-------------------------*/		
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_allowSubmitOnError = false;
	
	objForm.EChasta.required = true;
	objForm.EChasta.description = "Fecha del Estado de Cuenta";
</script>