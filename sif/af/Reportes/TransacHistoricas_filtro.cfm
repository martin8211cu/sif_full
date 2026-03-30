<!--- 
	Creado por Gustavo Fonseca H.
		Motivo: Nueva consulta para transacciones Históricas.
		Fecha:16-5-2006.
 --->
<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfquery name="rsOficinas" datasource="#session.dsn#">
	select Ocodigo,Oficodigo,Odescripcion 
	from  Oficinas
	where Ecodigo = #session.Ecodigo#
	order by Oficodigo
</cfquery>	

<cfset valuesArray = ArrayNew(1)>
<cfif isdefined("url.codigodesde")>
	<cfset ArrayAppend(valuesArray, url.codigodesde)>
</cfif>
<cfif isdefined("url.ACinicio")>
	<cfset ArrayAppend(valuesArray, url.ACinicio)>
</cfif>
<cfif isdefined("url.ACdescripciondesde")>							
	<cfset ArrayAppend(valuesArray, url.ACdescripciondesde)>
</cfif>	
	
<cfset valuesArrayB = ArrayNew(1)>
<cfif isdefined("url.codigohasta")>
	<cfset ArrayAppend(valuesArrayB, url.codigohasta)>
</cfif>
<cfif isdefined("url.AChasta")>
	<cfset ArrayAppend(valuesArrayB, url.AChasta)>
</cfif>
<cfif isdefined("url.ACdescripcionhasta")>
	<cfset ArrayAppend(valuesArrayB, url.ACdescripcionhasta)>
</cfif>

<cfset valuesArrayC = ArrayNew(1)>
<cfif isdefined("url.CFidinicio")>
	<cfset ArrayAppend(valuesArrayC, url.CFidinicio)>
</cfif>
<cfif isdefined("url.CFcodigoinicio")>
	<cfset ArrayAppend(valuesArrayC, url.CFcodigoinicio)>
</cfif>
<cfif isdefined("url.CFdescripcioninicio")>
	<cfset ArrayAppend(valuesArrayC, url.CFdescripcioninicio)>
</cfif>

<cfset valuesArrayD = ArrayNew(1)>
<cfif isdefined("url.CFidfinal")>
	<cfset ArrayAppend(valuesArrayD, url.CFidfinal)>
</cfif>
<cfif isdefined("url.CFcodigofinal")>
	<cfset ArrayAppend(valuesArrayD, url.CFcodigofinal)>
</cfif>
<cfif isdefined("url.CFdescripcionfinal")>
	<cfset ArrayAppend(valuesArrayD, url.CFdescripcionfinal)>
</cfif>

	<cf_templateheader title="#nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
			<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>
			<form name="form1" method="get" style="margin:0;" action="TransacHistoricas_form.cfm">
				<table align="center" border="0" width="100%" cellpadding="2" cellspacing="0">
					<tr><td colspan="7">&nbsp;</td></tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="3">&nbsp;</td>
						<td align="left"><input checked="checked" type="radio" name="TipoRep" value="1"/>Resumido
						<input type="radio" name="TipoRep" value="2" <cfif isdefined("url.TipoRep") and len(trim(url.TipoRep)) and url.TipoRep eq 2>checked="checked"</cfif> />Detallado</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Transacciones:</strong>&nbsp;</td>
						<td>
							<select name="TransacHis" tabindex="1">
								<option value="1" <cfif isdefined("url.TransacHis") and len(trim(url.TransacHis)) and url.TransacHis eq 1>selected</cfif>>Adquisiciones</option>
								<option value="5" <cfif isdefined("url.TransacHis") and len(trim(url.TransacHis)) and url.TransacHis eq 5>selected</cfif>>Mejoras</option>
								<option value="2" <cfif isdefined("url.TransacHis") and len(trim(url.TransacHis)) and url.TransacHis eq 2>selected</cfif>>Retiros</option>
								<option value="3" <cfif isdefined("url.TransacHis") and len(trim(url.TransacHis)) and url.TransacHis eq 3>selected</cfif>>Depreciación</option>
								<option value="4" <cfif isdefined("url.TransacHis") and len(trim(url.TransacHis)) and url.TransacHis eq 4>selected</cfif>>Depreciados Totalmente</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Per&iacute;odo:</strong>&nbsp;</td>
						<td>
							<cfif isdefined("url.periodoInicial") and len(trim(url.periodoInicial))>
								<cf_periodos name="periodoInicial" value="#url.periodoInicial#" tabindex="1">
							<cfelse>
								<cf_periodos name="periodoInicial" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Mes Inicial:</strong>&nbsp;</td>
						<td>
							<cfif isdefined("url.mesInicial") and len(trim(url.mesInicial))>
								<cf_meses name="mesInicial" value="#url.mesInicial#" tabindex="1">
							<cfelse>
								<cf_meses name="mesInicial" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Mes Final:</strong>&nbsp;</td>
						<td>
							<cfif isdefined("url.mesFinal") and len(trim(url.mesFinal))>
								<cf_meses name="mesFinal" value="#url.mesFinal#" tabindex="1">
							<cfelse>
								<cf_meses name="mesFinal" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
						<td align="right" width="25%" nowrap><strong>Tipo de Activo:&nbsp;</strong></td>
						<td>
							<cf_siftipoactivo id="AFCcodigopadre" name="AFCcodigoclaspadre" desc="Cdescpadre" tabindex="1">
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td nowrap="nowrap" align="right">
							<strong>Categor&iacute;a Inicial:</strong>&nbsp;
						</td>
						<td>
							<cf_conlis
								campos="codigodesde, ACinicio, ACdescripciondesde"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
								valuesArray="#valuesArray#" 
								tabla="ACategoria"
								columnas="ACcodigo as codigodesde, ACcodigodesc as ACinicio, ACdescripcion as ACdescripciondesde"
								filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
								desplegar="ACinicio, ACdescripciondesde"
								filtrar_por="ACcodigodesc, ACdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="codigodesde, ACinicio, ACdescripciondesde"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
								tabindex="1">
						</td>
						<td width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right">
							<strong>Categor&iacute;a Final:</strong>&nbsp;
						</td>
						<td>
							<cf_conlis
								campos="codigohasta, AChasta, ACdescripcionhasta"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
								valuesArray="#valuesArrayB#" 
								tabla="ACategoria"
								columnas="ACcodigo as codigohasta, ACcodigodesc as AChasta, ACdescripcion as ACdescripcionhasta"
								filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
								desplegar="AChasta, ACdescripcionhasta"
								filtrar_por="ACcodigodesc, ACdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="codigohasta, AChasta, ACdescripcionhasta"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
								tabindex="1">
						</td>
						<td width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Centro Funcional Inicial:&nbsp;</strong></td>
						<td>
							<cf_conlis
								campos="CFidinicio, CFcodigoinicio, CFdescripcioninicio"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								valuesArray="#valuesArrayC#" 
								tabla="CFuncional"
								columnas="CFid as CFidinicio, CFcodigo as CFcodigoinicio, CFdescripcion as CFdescripcioninicio"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFcodigoinicio, CFdescripcioninicio"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFidinicio, CFcodigoinicio, CFdescripcioninicio"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1">
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Centro Funcional Final:&nbsp;</strong></td>
						<td>
							<cf_conlis
								campos="CFidfinal, CFcodigofinal, CFdescripcionfinal"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								valuesArray="#valuesArrayD#" 
								tabla="CFuncional"
								columnas="CFid as CFidfinal, CFcodigo as CFcodigofinal, CFdescripcion as CFdescripcionfinal"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFcodigofinal, CFdescripcionfinal"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFidfinal, CFcodigofinal, CFdescripcionfinal"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1">
						</td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
						<td align="right"><strong>Oficina Inicial:</strong>&nbsp;</td>
						<td>
								 <select name="OficinaIni" tabindex="2">
                                    <option value="" selected></option>
                                    <cfloop query="rsOficinas">
                                      <option value="#Ocodigo#" <cfif isdefined("url.OficinaIni") and url.OficinaIni eq rsOficinas.Ocodigo>selected</cfif>>#Oficodigo#-#Odescripcion#</option>
                                    </cfloop>
                                 </select>
						</td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
						<td align="right"><strong>Oficina Final:</strong>&nbsp;</td>
						<td>
								 <select name="OficinaFin" tabindex="2">
                                    <option value="" selected></option>
                                    <cfloop query="rsOficinas">
                                      <option value="#Ocodigo#" <cfif isdefined("url.OficinaFin") and url.OficinaFin eq rsOficinas.Ocodigo>selected</cfif>>#Oficodigo#-#Odescripcion#</option>
                                    </cfloop>
                                 </select>
						</td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
						<td align="right"><strong>Formato:</strong>&nbsp;</td>
						<td>
							<select name="Formato" tabindex="1">
								<option value="1">HTML</option>
								<option value="2">Exportar a Excel</option>
								<option value="3">Exportar Archivo Plano</option>
							</select> 
						</td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
						<td colspan="2" align="center">
							<fieldset style="width:80%;">
							<legend style="font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:normal; font-weight:bolder;">Información Opcional</legend>
							<table cellpadding="0" cellspacing="0" style="width:80%" align="center">
								<tr><td colspan="4">&nbsp;</td></tr>
								<tr>
									<td align="right" nowrap="nowrap"><strong>Mostrar Adquisici&oacute;n:</strong></td>
									<td><input type="checkbox" name="chkveradq" <cfif isdefined("form.chkveradq")>checked="checked"</cfif>/></td>
									<td align="right" nowrap="nowrap"><strong>Mostrar Mejora:</strong></td>
									<td><input type="checkbox" name="chkvermej" <cfif isdefined("form.chkvermej")>checked="checked"</cfif>/></td>
								</tr>													
								<tr>
									<td align="right"><strong>Mostrar Revaluaci&oacute;n:</strong></td>
									<td><input type="checkbox" name="chkverrev" <cfif isdefined("form.chkverrev")>checked="checked"</cfif>/></td>
									<td align="right"><strong>Mostrar Dep. Adquisi&oacute;n:</strong></td>
									<td><input type="checkbox" name="chkverdepadq" <cfif isdefined("form.chkverdepadq")>checked="checked"</cfif>/></td>
								</tr>
								<tr>
									<td align="right"><strong>Mostrar Dep. Mejora:</strong></td>
									<td><input type="checkbox" name="chkverdepmej" <cfif isdefined("form.chkverdepmej")>checked="checked"</cfif>/></td>
									<td align="right"><strong>Mostrar Dep. Revaluaci&oacute;n:</strong></td>
									<td><input type="checkbox" name="chkverdeprev" <cfif isdefined("form.chkverdeprev")>checked="checked"</cfif> /></td>
								</tr>
							</table>											
							</fieldset>
						</td>
					</tr>
					<tr><td colspan="7" align="center"><cf_botones tabindex="1" include="Generar" exclude="Alta,Limpiar"></td></tr>
					<tr><td colspan="7">&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
		<cf_web_portlet_end>
		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			objForm.periodoInicial.required = true;
			objForm.periodoInicial.description = 'Período';
			objForm.mesInicial.required = true;
			objForm.mesInicial.description = 'Mes Inicial';
			objForm.mesFinal.required = true;
			objForm.mesFinal.description = 'Mes Final';
		</script>
	<cf_templatefooter>