	<cf_templateheader title="Cuentas Contables de Configuración">

	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

		<cfif isdefined("url.WTCid") and not isdefined("form.WTCid") >
			<cfset form.WTCid = url.WTCid >
		</cfif>

		<cfif isdefined("url.WECid") and not isdefined("form.WECid") >
			<cfset form.WECid = url.WECid >
		</cfif>

		<!--- modo del encabezado --->
		<cfparam name="modo" default="ALTA">
		<cfif isdefined("form.WTCid") and len(trim(form.WTCid)) gt 0 >
			<cfset modo = 'CAMBIO'>
		</cfif>
		
		<!--- modo del detalle --->
		<cfif modo eq 'CAMBIO'>
			<cfparam name="dmodo" default="ALTA">
			<cfif isdefined("form.WECid") and len(trim(form.WECid)) gt 0 >
				<cfset dmodo = 'CAMBIO'>
			</cfif>
		</cfif>

		
		<table border="0" width="100%" cellpadding="2" cellspacing="2">
			<tr>
				<td width="1%" valign="top"><cfinclude template="/sif/menu.cfm"></td>
				<td valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cuentas Contables para Configuración'>
						<form name="form1" method="post" action="ccuentas-sql.cfm" onSubmit="">
						<table width="100%" cellpadding="3" cellspacing="0">
							<tr><td class="tituloAlterno" align="center"><b>Cat&aacute;logo Contable</b></td></tr>
							<tr><td><cfinclude template="ccuentas-form.cfm"></td></tr>
							<cfif modo neq 'ALTA'>
								<tr><td align="center">&nbsp;</td></tr>
								<tr><td class="tituloAlterno" align="center"><b>Cuentas Contables</b></td></tr>
								<tr><td><cfinclude template="dcuentas-form.cfm"></td></tr>
								<tr><td align="center">&nbsp;</td></tr>
							</cfif>

							<tr>
								<td align="center">
									<cfif modo eq 'ALTA'>
										<input type="submit" name="eAgregar" value="Agregar">
									<cfelse>
										<cfif dmodo neq 'ALTA'>
											<input type="submit" name="Modificar" value="Modificar" >
											<input type="submit" name="dEliminar" value="Eliminar Cuenta" onClick="deshabilitarValidacion(); if (!confirm('Desea eliminar la Cuenta Contable?')){return false;}" >
										<cfelse>
											<input type="submit" name="DAgregar" value="Agregar Cuenta" title="Agrega Cuenta Contable" >
											<input type="submit" name="eEliminar" value="Eliminar Cat&aacute;logo" onClick="deshabilitarValidacion(); if(!confirm('Desea eliminar el Catálogo Contable?')){return false;}" title="Elimina Cat&aacute;logo Contable y todas sus cuentas">
										</cfif>
									</cfif>
									<input type="submit" name="Lista" value="Lista" title="Ver lista de Cat&aacute;logos Contables" onClick="deshabilitarValidacion()">
								</td>
							</tr>
						</table>			
						
						</form>
						<cfif modo neq 'ALTA'>
							<cfinclude template="listaCuentas.cfm">
						</cfif>
					<cf_web_portlet_end>	
				</td>	
			</tr>
		</table>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.WECdescripcion.required = true;
	objForm.WECdescripcion.description="Descripción";

	objForm.WTCmascara.required = true;
	objForm.WTCmascara.description="Máscara";

	<cfif modo neq 'ALTA'>
		objForm.Cformato.required = true;
		objForm.Cformato.description="Formato";
	
		objForm.Cdescripcion.required = true;
		objForm.Cdescripcion.description="Descripción";

	</cfif>

	function deshabilitarValidacion(){
		objForm.WECdescripcion.required = false;
		objForm.WTCmascara.required = false;
	
		<cfif modo neq 'ALTA'>
			objForm.Cformato.required = false;
			objForm.Cdescripcion.required = false;
		</cfif>
	}
	
</script>
<cf_templatefooter>
