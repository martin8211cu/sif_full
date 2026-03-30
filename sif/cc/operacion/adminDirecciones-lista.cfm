<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select Pvalor 
	from Parametros
	where Ecodigo = #session.Ecodigo#
	  and Pcodigo = 50
</cfquery>
<cfquery name="rsMes" datasource="#session.DSN#">
	select Pvalor 
	from Parametros
	where Ecodigo = #session.Ecodigo#
	  and Pcodigo = 60
</cfquery>
<cfquery name="rsTipoTran" datasource="#session.DSN#">
	select CCTcodigo, CCTdescripcion
	from CCTransacciones
	where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsusuario" datasource="#session.DSN#" >
	select distinct Dusuario
	from Documentos a
	where a.Dsaldo=a.Dtotal		<!--- solo documentos sin transacciones aplicadas --->
	and a.Dtotal > 0
	order by Dusuario
</cfquery>			

<cfset vId = '' >
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfset vId = form.SNcodigo >
</cfif>
		
<cf_templateheader title="SIF - Cuentas por Cobrar">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cambiar Direcciones'>
			<cfoutput>
				<form name="form1" method="post" action="adminDirecciones-facturas.cfm" >
					<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
						<tr>
							<td nowrap="nowrap" width="1%"><strong>Socio de Negocios:</strong></td>
							<td width="1%"><cf_sifsociosnegocios2 idquery="#vId#" SNcodigo="fSNcodigo" tabindex="1"></td>
							<td nowrap="nowrap" width="1%"><strong>Direcci&oacute;n:</strong></td>
							<td width="1%"><select style="width:347px" name="fid_direccion" id="fid_direccion" tabindex="2"></select></td>
						</tr>
						<tr>
							<td nowrap="nowrap" width="1%"><strong>Documento:</strong></td>
							<td width="1%"><input type="text" name="fDdocumento" value=""></td>
							<td nowrap="nowrap" width="1%"><strong>Tipo de Transacci&oacute;n:</strong></td>
							<td width="1%">
								
								<select  name="fCCTcodigo" id="fCCTcodigo" tabindex="2">
									<option value="">- Todos -</option>
									<cfloop query="rsTipoTran">
										<option value="#rsTipoTran.CCTcodigo#" >#trim(rsTipoTran.CCTcodigo)# - #HTMLEditFormat(rsTipoTran.CCTdescripcion)#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap" width="1%"><strong>Fecha desde:</strong></td>
							<td>
								<cf_sifcalendario name="fDfechadesde" value="01/#repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#/#rsPeriodo.Pvalor#">
								<input type="hidden" name="dia_inicio" value="#rsPeriodo.Pvalor##repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#01" />
							</td>
							<td nowrap="nowrap" width="1%"><strong>Fecha hasta:</strong></td>
							<td>
								<cfset vDias = daysinmonth(createdate(rsperiodo.pvalor,rsmes.pvalor, 01)) >
								<cf_sifcalendario name="fDfechahasta" value="#vDias#/#repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#/#rsPeriodo.Pvalor#" >
								<input name="dia_final" type="hidden" value="#rsPeriodo.Pvalor##repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor##vDias#" />
							</td>
						</tr>
						<tr>
							<td ><strong>Usuario:</strong></td>
							<td >
								<select name="fDusuario">
									<option value="" >-Todos-</option>
									<cfloop query="rsusuario">
										<option value="#rsusuario.Dusuario#" <cfif isdefined("form.fDusuario") and form.fDusuario eq rsusuario.Dusuario >selected="selected"</cfif> >#rsusuario.Dusuario#</option>
									</cfloop>
								</select>
							</td>
							<td colspan="2" ><input class="btnFiltrar" type="submit" name="btnTraerDocumentos" value="Traer Documentos" maxlength="20" size="25"></td>
						</tr>
						</table>
							<input type="hidden" name="tdia_inicio" value="01/#repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#/#rsPeriodo.Pvalor#" />
							<input type="hidden" name="tdia_final" value="#vDias#/#repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#/#rsPeriodo.Pvalor#" />
					</form>
				</cfoutput>
		<iframe id="fr_direccion" name="fr_direccion" style="visibility:hidden;" width="0" height="0" frameborder="0" src=""></iframe>
		
		<script type="text/javascript" language="javascript1.2">
			function funcSNnumero(){
				document.getElementById('fr_direccion').src = 'adminDirecciones-direccion.cfm?SNcodigo='+document.form1.fSNcodigo.value;
			}
			
			function validafecha(fecha){
				var vFecha = fecha.split('/');
				var sFecha = vFecha[2] + vFecha[1] + vFecha[0]

				if ( sFecha > document.form1.dia_final.value || sFecha < document.form1.dia_inicio.value){
					return true;	
				}
				return false;
			}
			function validafechadesde(){
				if (validafecha(document.form1.fDfechadesde.value) ){
					this.error = 'La Fecha desde debe estar entre el primer y ultimo día del mes y período auxiliar';
				}
			}
			function validafechahasta(){
				if (validafecha(document.form1.fDfechahasta.value) ){
					this.error = 'La Fecha hasta debe estar entre el primer y ultimo día del mes y período auxiliar';
				}
			}
		</script>
		<cf_qforms >
			<cf_qformsrequiredfield args="fSNcodigo,Socio de Negocios">
			<cf_qformsrequiredfield args="fDfechadesde,Fecha Desde,validafechadesde">
			<cf_qformsrequiredfield args="fDfechahasta,Fecha Hasta,validafechahasta">
		</cf_qforms>
	<cf_web_portlet_end>
<cf_templatefooter>