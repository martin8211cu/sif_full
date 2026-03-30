<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cf_templateheader title="Reporte de cambios del estado de impresi&oacute;n de OC">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de cambios del estado de impresi&oacute;n de OC'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			
			<cfset ValuesComprador = ArrayNew(1)>
			<cfset ValuesTipoOC= ArrayNew(1)>
			
			<form name="form1" action="RepcambioestadoimpresionOC-vista.cfm" method="post">
				<table width="99%" align="center" border="0" cellspacing="2" cellpadding="1" class="areaFiltro">
					<tr>      				
						<td width="15%" align="right" nowrap class="fileLabel" >
							<label for="SNcodigo"><strong>Del Comprador:&nbsp;</strong></label>
						</td>
						<td width="1%" nowrap>																									
							<cf_conlis 
								campos="CMCid,CMCcodigo,CMCnombre"
								asignar="CMCid,CMCcodigo,CMCnombre"
								size="0,10,25"
								desplegables="N,S,S"
								modificables="N,S,N"						
								title="Lista de Compradores"
								tabla="CMCompradores a "
								columnas="CMCid,CMCcodigo,CMCnombre"
								filtro="a.Ecodigo = #Session.Ecodigo# "
								filtrar_por="CMCcodigo,CMCnombre"
								desplegar="CMCcodigo,CMCnombre"
								etiquetas="C&oacute;digo, Nombre"
								valuesArray="#ValuesComprador#"
								formatos="S,S"
								align="left,left"								
								asignarFormatos="S,S,S"
								form="form1"
								showEmptyListMsg="true"
								EmptyListMsg=" --- No se encontraron registros --- "
							/> 						             
						</td>
						<td width="1%">&nbsp;</td>
						<td width="15%" align="right" nowrap><label for="fESnumeroH"><strong>Del N&uacute;mero:&nbsp;</strong></label></td>
						<td nowrap width="15%">		
							<input type="text" name="fEsnumeroD" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroD')><cfoutput>#form.fESnumeroD#</cfoutput></cfif>" onBlur="javascript:fm(this,0)" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" > &nbsp;<!---</td>--->
						</td>
						<td width="5%" align="right" nowrap><label for="fESnumeroH"><strong>Al N&uacute;mero:&nbsp;</strong></label></td>
						<td nowrap width="15%">
							<input type="text" name="fEsnumeroH" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroH')><cfoutput>#form.fESnumeroH#</cfoutput></cfif>" onBlur="javascript:fm(this,0)" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> &nbsp;
						</td>	
						<td width="50">&nbsp;</td>						
					</tr>	
					<tr>
						<td nowrap align="right" class="fileLabel" width="5%"><label for="fTipoSolicitud"><strong>Tipo:</strong></label></td>
						<td nowrap width="15%">	
							<cf_conlis 
								campos="CMTOcodigo, CMTOdescripcion"
								asignar="CMTOcodigo, CMTOdescripcion"
								size="10,25"
								desplegables="S,S"
								modificables="S,N"						
								title="Lista de Tipos de Orden de Compra"
								tabla="CMTipoOrden a "
								columnas="CMTOcodigo, CMTOdescripcion"
								filtro="a.Ecodigo = #Session.Ecodigo# "
								filtrar_por="CMTOcodigo, CMTOdescripcion"
								desplegar="CMTOcodigo, CMTOdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"								
								asignarFormatos="S,S"
								form="form1"
								valuesArray="#ValuesTipoOC#"
								showEmptyListMsg="true"
								EmptyListMsg=" --- No se encontraron registros --- "
							/>              						
						</td>
						<td width="1%">&nbsp;</td>
						<td  nowrap align="right" width="5%"><strong>Fecha Desde:&nbsp;</strong></td>
						<td width="15%" align="left">
							<cfif isdefined('form.fechaD')>
								<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="#form.fechaD#">
							<cfelse>
								<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="">
							</cfif>
						</td>
						<td nowrap align="right" width=""><strong>Fecha Hasta:&nbsp;</strong></td>
						<td width="15%" align="left" nowrap>
							<cfif isdefined('form.fechaH')>
								<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="#form.fechaH#">
							<cfelse>
								<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="">
							</cfif>
						</td>
						<!---<td align="center" rowspan="3" valign="top" width="5%"><input type="submit" name="btn_consultar"  value="Consultar"></td>--->
						<td width="1%">&nbsp;</td>	
					</tr>				
					<tr>					
						<td align="right"  nowrap width="5%"><label for="CMCid"><strong>Proveedor:&nbsp;</strong></label></td>					
						<td colspan="2" width="15%">
							<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
								<cf_sifsociosnegocios2 idquery="#form.SNcodigo#" form="form1">
							<cfelse>
								<cf_sifsociosnegocios2 form="form1">
							</cfif>							
						</td>					
						<td align="center" colspan="3" valign="top" width="5%"><input type="submit" name="btn_consultar"  value="Consultar"></td>
					</tr>			
				</table>
			</form>			
		<cf_web_portlet_end>
	<cf_templatefooter>

