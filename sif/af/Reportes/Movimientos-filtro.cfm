<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cf_templatecss>
		<cfoutput>#pNavegacion#</cfoutput>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>

			<!--- Tipo de Transaccion --->
			<cfquery name="tipo" datasource="#session.DSN#">
				select IDtrans, AFTdes
				from AFTransacciones
				where IDtrans in (1, 5, 9)
			</cfquery>
			
			<cfquery name="retiro" datasource="#session.DSN#">
				select AFRmotivo, AFRdescripcion
				from AFRetiroCuentas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				order by AFRdescripcion			
			</cfquery>
			
			<form name="form1" method="get" style="margin:0;" action="Movimientos.cfm">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" width="45%"><strong>Tipo de Transacci&oacute;n:</strong>&nbsp;</td>
						<td>
							<select name="IDtrans" onchange="javascript:retiro(this.value);" tabindex="1">
								<cfloop query="tipo">
									<option value="#tipo.IDtrans#" <cfif isdefined("url.IDtrans") and tipo.IDtrans eq url.IDtrans>selected</cfif>>#tipo.AFTdes#</option>
								</cfloop>
							</select>
						</td>
					</tr>

					<tr>
						<td align="right"><strong>Per&iacute;odo Inicial:</strong>&nbsp;</td>
						<td>
							<cfif isdefined("url.periodoInicial") and len(trim(url.periodoInicial))>
								<cf_periodos name="periodoInicial" value="#url.periodoInicial#" tabindex="1">
							<cfelse>
								<cf_periodos name="periodoInicial" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Per&iacute;odo Final:</strong>&nbsp;</td>
						<td>
							<cfif isdefined("url.periodoFinal") and len(trim(url.periodoFinal))>
								<cf_periodos name="periodoFinal" value="#url.periodoFinal#" tabindex="1">
							<cfelse>
								<cf_periodos name="periodoFinal" tabindex="1">
							</cfif>
						</td>
					</tr>


					<tr>
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
						<td align="right"><strong>Centro Funcional Inicial:&nbsp;</strong></td>
						<td><!---<cf_rhcfuncional index="inicio">--->
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
						<td align="right"><strong>Centro Funcional Final:&nbsp;</strong></td>
						<td>
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
						<td nowrap="nowrap" align="right">
							<strong>Categor&iacute;a Inicial:</strong>&nbsp;
						</td>
						<td>
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
							<cf_conlis
								campos="codigodesde, ACinicio, ACdescripciondesde"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
								valuesArray="#valuesArray#"
								tabla="ACategoria"
								columnas="ACcodigo as codigodesde, ACcodigodesc as ACinicio, ACdescripcion as ACdescripciondesde"
								filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigo"
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
						<td align="right">
							<strong>Categor&iacute;a Final:</strong>&nbsp;
						</td>
						<td>
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
							<cf_conlis
								campos="codigohasta, AChasta, ACdescripcionhasta"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
								valuesArray="#valuesArrayB#" 
								tabla="ACategoria"
								columnas="ACcodigo as codigohasta, ACcodigodesc as AChasta, ACdescripcion as ACdescripcionhasta"
								filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigo"
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
					
					<tr id="retiro">
						<td align="right"><strong>Motivo de Retiro:</strong>&nbsp;</td>
						<td>
							<select name="AFRmotivo" tabindex="1">
								<option value=" ">-Todos-</option>
								<cfloop query="retiro">
									<option value="#retiro.AFRmotivo#" <cfif isdefined("url.AFRmotivo") and url.AFRmotivo eq retiro.AFRmotivo>selected</cfif>>#retiro.AFRdescripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>

					<tr><td colspan="3" align="center"><cf_botones tabindex="1" include="Filtrar,Exportar" exclude="Alta,Limpiar"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
		<cf_web_portlet_end>

		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			function retiro(valor){
				if (valor == 5){
					document.getElementById('retiro').style.display = '';
				}
				else{
					document.getElementById('retiro').style.display = 'none';
				}
			}
			retiro(document.form1.IDtrans.value);
		
			objForm.IDtrans.required = true;
			objForm.IDtrans.description = 'Tipo de Transacción';
			objForm.periodoInicial.required = true;
			objForm.periodoInicial.description = 'Período Inicial';
			objForm.periodoFinal.required = true;
			objForm.periodoFinal.description = 'Período Final';
			objForm.mesInicial.required = true;
			objForm.mesInicial.description = 'Mes Inicial';
			objForm.mesFinal.required = true;
			objForm.mesFinal.description = 'Mes Final';
			objForm.CFidinicio.required = true;
			objForm.CFidinicio.description = 'Centro Funcional Inicial';
			objForm.CFidfinal.required = true;
			objForm.CFidfinal.description = 'Centro Funcional Final';
		</script>
	<cf_templatefooter>