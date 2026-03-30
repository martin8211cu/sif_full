<cfset CRCFolios = createObject( "component","crc.Componentes.CRCFolios")>
<cfinclude template="/commons/flash.cfm" >
<!DOCTYPE html>
<html>
	<head>
 		<cf_importLibs>
		<cfhtmlhead text='<link href="#cgi.CONTEXT_PATH##session.sitio.css#" rel="stylesheet" type="text/css"/>'>
		<cfoutput>
			<link href="#cgi.CONTEXT_PATH#/commons/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
		</cfoutput>
	</head>
	<body>

	<cfif isdefined('form.bguardar')>
		<cftry>
			<cfset flashInsert(saveFeedback = CRCFolios.CancelaLote(Lote=form.lote,FolioInicial=form.FolioI,FolioFinal=form.FolioF))>
		<cfcatch>
			<cfset flashInsert(saveFeedback = "Ocurrio un error en la Cancelacion, verifique los datos. #cfcatch.message#")>
		</cfcatch>
		</cftry>
	</cfif>

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cancelar Folios'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td>
								<cfoutput>
									<cfform action="ControlFolios_cancelar.cfm" method="post" name="form1" style="margin:0;">
										<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
											<tr>
												<td align="right" nowrap width="50%">
													<b>Lote:&nbsp;</b>
												</td>
												<td>
													<input type="text" name="Lote" maxlength="8" size="20" value="" onkeypress="return soloNumeros(event);">
												</td>
											</tr>
											<tr>
												<td width="20%" align="right">
													<b>Folio Inicial:&nbsp;</b>
												</td>
												<td>
													<input type="text" name="FolioI" maxlength="10" size="10" value="" onkeypress="return soloNumeros(event);">
												</td>
											</tr>
											<tr>
												<td width="20%" align="right">
													<b>Folio Final:&nbsp;</b>
												</td>
												<td>
													<input type="text" name="FolioF" maxlength="10" size="10" value="" onkeypress="return soloNumeros(event);">
												</td>
											</tr>
											<tr>
												<td colspan="2" nowrap align="center">
													<input type="submit" name="bGuardar" value="Cancelar" class="btnEliminar">
												</td>
											</tr>
										</table>
									</cfform>
								</cfoutput>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<cfoutput>
			<cfif flashKeyExists("saveFeedback")>
				<pre>#flash("saveFeedback")#</pre>
			</cfif>
		</cfoutput>
		<cf_web_portlet_end>

<script type="text/javascript">
	function soloNumeros(e)
	{
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 0))
		return true;
		return /\d/.test(String.fromCharCode(keynum));
	}
</script>
	</body>
</html>