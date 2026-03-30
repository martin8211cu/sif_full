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
			<cfset flashInsert(saveFeedback = CRCFolios.CreaLote(Cuentaid=form.Cuentaid,CantidadFolios=form.Cantidad).message)>
		<cfcatch>
			<cfset flashInsert(saveFeedback = "Ocurrio un error al crear el Lote, verifique los datos. #cfcatch.message#")>
		</cfcatch>
		</cftry>
	</cfif>

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Nuevo Lote'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td>
								<cfoutput>
									<cfform action="ControlFolios_crear.cfm" method="post" name="form1" style="margin:0;">
										<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
											<tr>
												<td align="right" nowrap width="50%">
													<b>Socio de Negocio:&nbsp;</b>
												</td>
												<td>
													<cf_conlis
														Campos="Cuentaid,SNid,SNnumero,SNnombre"
														Desplegables="N,N,S,S"
														Modificables="N,N,S,N"
														Size="0,0,10,30"
														tabindex="2"
														Tabla="Snegocios s inner join CRCCuentas c
																on c.SNegociosSNid = s.SNid
																and c.Tipo = 'D'"
														Columnas="id as Cuentaid,SNid,SNnumero,SNnombre"
														form="form1"
														Filtro=" s.Ecodigo = #Session.Ecodigo# and (disT = 1) and s.eliminado is null
																order by SNnombre"
														Desplegar="SNnumero,SNnombre"
														Etiquetas="Numero, Nombre"
														filtrar_por="SNnumero,SNnombre"
														Formatos="S,S"
														Align="left,left"
														Asignar="Cuentaid,SNid,SNnumero,SNnombre"
														Asignarformatos="S,S,S"/>
												</td>
											</tr>
											<tr>
												<td width="20%" align="right">
													<b>Cantidad de Folios:&nbsp;</b>
												</td>
												<td>
													<input type="text" name="Cantidad" maxlength="3" size="10" rquired="" value="" onkeypress="return soloNumeros(event);">
												</td>
											</tr>
											<tr>
												<td colspan="2" nowrap align="center">
													<input type="submit" name="bGuardar" value="Agregar" class="btnModificar">
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