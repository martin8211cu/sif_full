<!--- 	
	Modificado por: Ana Villavicencio
	Fecha: 11 de octubre del 2005
	Motivo: Agregar filtro por numero de factura(Documento). 
			Se crearon dos cajas de texto para el filtro por documento.
 --->

<cf_templateheader title="SIF - Cuentas por Cobrar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Generaci&oacute;n Documentos de Soporte'>

	<cfquery name="rsCCTransacciones" datasource="#Session.DSN#">
		select a.CCTcodigo, a.CCTdescripcion 
		from CCTransacciones a
			inner join CCTransaccionesD b
				 on b.Ecodigo = a.Ecodigo
				and b.CCTcodigo = a.CCTcodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and a.CCTpago = 0
		   and a.CCTtranneteo = 0
	</cfquery>
	
	<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/JavaScript">
		<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		//-->
	</script>
	<form name="form1" method="get" action="genFactServRes.cfm">		
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
				<fieldset><legend>Datos del Reporte</legend>
					<table cellpadding="2" cellspacing="0" border="0" align="center">
						<tr><td colspan="2">&nbsp;</td></tr>	
						<tr>
							<td nowrap align="right" width="22%"><strong>Sucursal:</strong></td>
							<td nowrap align="left" width="68%"><cf_sifoficinas tabindex="1"></td>
						</tr>
						<tr>
							<td align="right"><strong>Cliente:</strong></td>
							 <td align="left">
								<cf_sifsociosnegocios2 tabindex="1">
							 </td>
						</tr>
						<tr>
							<td nowrap align="right" width="22%"><strong>Transacci&oacute;n: </strong></td>
							<td nowrap align="left" width="68%">
								<cfoutput>
									<select name="CCTcodigo" tabindex="1">
										<!--- <option value="-1">Todas</option> --->
										<cfloop query="rsCCTransacciones">
											<option value="#Trim(CCTcodigo)#">#CCTdescripcion#</option>
										</cfloop>
									</select>
								</cfoutput>							
							</td>
						</tr>						
						<tr>
							<td nowrap align="right" width="22%"><strong>Fecha&nbsp;Inicial:</strong></td>
							<td nowrap align="left" width="68%"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
						<tr>
							<td nowrap align="right"><strong>Fecha&nbsp;Final:</strong></td>
							<td nowrap align="left"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
						</tr>
						<tr>
							<td nowrap align="right"><strong>Documento&nbsp;Inicial:</strong></td>
							<td nowrap align="left"><input name="DocIni" type="text" size="30" tabindex="1"></td>
						</tr>
						<tr>
							<td nowrap align="right"><strong>Documento&nbsp;Final:</strong></td>
							<td nowrap align="left"><input name="DocFin" type="text" size="30" tabindex="1"></td>
						</tr>
						<tr>
							<td align="right" width="22%" nowrap><strong>Formato:</strong>
							</td>
							<td align="left">
								<select name="Formato" id="Formato" tabindex="1">
									<option value="1">FLASHPAPER</option>
									<option value="2">PDF</option>
                            	</select>
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
					</table>
				  </fieldset>
				</td>	
			</tr>
		</table>
	</form>
<cf_web_portlet_end>
<cf_templatefooter>

<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
		function _isFechas(){
		var valorINICIO=0;
		var valorFIN=0;
		var INICIO = document.form1.fechaDes.value;
		var FIN = this.value;
		
		INICIO = INICIO.substring(6,10) + INICIO.substring(3,5) + INICIO.substring(0,2)
		FIN = FIN.substring(6,10) + FIN.substring(3,5) + FIN.substring(0,2)
		valorINICIO = parseInt(INICIO)
		valorFIN = parseInt(FIN)

		if (valorINICIO > valorFIN)
			this.error="Error, la fecha de inicio (" + document.form1.fechaDes.value + ") no debe ser mayor que la fecha final (" + this.value + ")";
	}	
	
	_addValidator("isFechas", _isFechas);		
	
	objForm.Ocodigo.required = false;
	objForm.Ocodigo.description="Sucursal";				
	objForm.SNcodigo.required = false;
	objForm.SNcodigo.description="Cliente";		
	objForm.CCTcodigo.required = true;
	objForm.CCTcodigo.description="TransacciÃ³n";			
	objForm.fechaDes.required = true;
	objForm.fechaDes.description="Fecha Inicial";			
	objForm.fechaHas.required = true;
	objForm.fechaHas.description="Fecha Final";		
	objForm.fechaHas.validateFechas();	
</SCRIPT>

