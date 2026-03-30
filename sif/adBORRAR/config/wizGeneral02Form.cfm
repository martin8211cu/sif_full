 <!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cfif isdefined("form.periodo") and len(trim(form.periodo)) gt 0 >
	<cfset PvalorPeriodo.Pvalor = form.periodo>
</cfif>
<cfif isdefined("form.mes") and len(trim(form.mes)) gt 0 >
	<cfset PvalorMes.Pvalor = form.mes>
</cfif>
<cfif isdefined("form.periodoAux") and len(trim(form.periodoAux)) gt 0 >
	<cfset PvalorPeriodoAux.Pvalor = form.periodoAux>
</cfif>
<cfif isdefined("form.mesAux") and len(trim(form.mesAux)) gt 0 >
	<cfset PvalorMesAux.Pvalor = form.mesAux>
</cfif>
<cfif isdefined("form.mesFiscal") and len(trim(form.mesFiscal)) gt 0 >
	<cfset PvalorMesFiscal.Pvalor = form.mesFiscal>
</cfif>

<cfif isdefined("PvalorPeriodo") and isdefined("PvalorMes") and isdefined("PvalorPeriodoAux") and isdefined("PvalorMesAux") and isdefined("PvalorMesFiscal")
  and len(trim(PvalorPeriodo.Pvalor)) gt 0 and len(trim(PvalorMes.Pvalor)) gt 0 and len(trim(PvalorPeriodoAux.Pvalor)) gt 0 and len(trim(PvalorMesAux.Pvalor)) gt 0 and len(trim(PvalorMesFiscal.Pvalor)) gt 0>
<cfelse>
	<cflocation url="wizGeneral01.cfm">
</cfif>

<cfquery name="rsCatalogos"  datasource="asp">
	select WTCid, WECdescripcion 
	from WTContable
</cfquery>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// función para devolverse a la pantalla anterior
	function doAnterior() {
		document.form1.action = "wizGeneral01.cfm";
		return true;
	}
</script>

<style type="text/css">
select {  background-color: #FAFAFA; font-size:12px }
</style>

<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr><td class="ayuda">Un Cat&aacute;logo Contable esta formado por un conjunto de Cuentas Contables b&aacute;sicas para el funcionamiento de una empresa. Seleccione el C&aacute;talogo Contable que se ajusta a las necesidades de su Empresa.</td></tr>

		<tr>
			<td style="padding-left: 5px; padding-right: 5px;" valign="top" nowrap>
				<form name="form1" action="wizConfirma.cfm" enctype="multipart/form-data" method="post" >
					<input type="hidden" value="#PvalorPeriodo.Pvalor#" name="periodo">
					<input type="hidden" value="#PvalorMes.Pvalor#" name="mes">
					<input type="hidden" value="#PvalorPeriodoAux.Pvalor#" name="periodoAux">
					<input type="hidden" value="#PvalorMesAux.Pvalor#" name="mesAux">
					<input type="hidden" value="#PvalorMesFiscal.Pvalor#" name="mesFiscal">
					<input type="hidden" value="" name="mascara">
	
					<table border="0" width="100%" cellpadding="2" cellspacing="0" v>

						<tr><td></td></tr>	

						<tr>
							<td class="etiquetaCampo" align="left" nowrap><font size="2">Seleccione el Cat&aacute;logo Contable:</font></td>
						</tr>

						<tr>
							<td align="left" nowrap>
								<select name="WTCid" onChange="javascript:cambio(this);">
									<option value="0">- ninguno -</option> 
									<cfloop query="rsCatalogos">
										<option value="#rsCatalogos.WTCid#" <cfif isdefined("form.WTCid") and form.WTCid eq rsCatalogos.WTCid >selected</cfif> >#rsCatalogos.WECdescripcion#</option>
									</cfloop>
								</select>
							</td>
						</tr>

						<tr><td>&nbsp;</td></tr>
						<tr>
							<td nowrap valign="top" >
								<table border="0" width="100%" >
									<tr id="trImagen" style="visibility:hidden " nowrap>
										<td class="textoMenu" id="tdInfo" width="60%" valign="top" bgcolor="##eeeeee" ></td>
										<td width="3%">&nbsp;</td>
										<td align="center" width="37%">
											<img name="infoImagen" type="image" src="imagenes/wtc1.gif" align="middle" />
										</td>	
									</tr>	
								</table>
							</td>
							
							<td valign="top" nowrap >
								<table border="0" width="100%">
									<tr>
										<td width="1%" valign="top">
											<cfset thisForm = 2>
											<cfinclude template="frame-Progreso.cfm">
										</td>
									</tr>	
								</table>	
							</td>		

						</tr>
	
						<tr><td>&nbsp;</td></tr>
			
						<tr>
							<td align="center" colspan="3">
								<input type="submit" name="anterior" id="anterior" value=" << Anterior " onclick="javascript: doAnterior();">
								<input type="submit" name="siguiente" id="siguiente" value=" Siguiente >> ">
							</td>
						</tr>
					</table>
				</form>
				<iframe frameborder="1" width="0" height="0" id="info" name="info" src=""></iframe>
			</td>
		
		</tr>
	</table>
	
</cfoutput>

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	/*
	objForm.Campo.required = true;
	objForm.Campo.description = "Etiqueta";

	function habilitarValidacion() {
		objForm.Campo.required = false;
	}

	function deshabilitarValidacion() {
		objForm.Campo.required = false;
	}
	*/
	
	
	function cambio(obj){
		document.getElementById("info").src = 'wizInfo.cfm?WTCid='+obj.value;
	}
	
	cambio(document.form1.WTCid);
	
</script>
