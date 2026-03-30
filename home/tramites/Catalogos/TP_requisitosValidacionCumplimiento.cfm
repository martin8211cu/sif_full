<cfif isdefined("Form.id_requisito") AND Len(Trim(Form.id_requisito)) GT 0 >
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select * 
		from TPRequisito K_V2
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
	</cfquery>	

	<cfquery name="rsWS" datasource="#session.tramites.dsn#">
		select m.id_metodo
		  from TPRequisito r
			inner join WSServicio s
				inner join WSMetodo m
					 on m.id_servicio = s.id_servicio
					and m.activo = 1
				 on s.id_documento = r.id_documento
		 where r.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
	</cfquery>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined("Form.id_requisito") AND Len(Trim(Form.id_requisito)) GT 0 >
	<cfquery name="rsDatosC" datasource="#session.tramites.dsn#">
		select * 
		from TPRequisito 
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
	</cfquery>	
</cfif>

<cfset values_conlisdocumento = "">
<cfset values_conlisvistapopup = "">
<cfif modo NEQ 'ALTA' and Len(Trim(rsDatosC.id_documento))>
	<cfquery name="rsDoc" datasource="#session.tramites.dsn#">
		select id_documento,id_tipo,codigo_documento,nombre_documento
		from TPDocumento
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatosC.id_documento#">
	</cfquery>
	<cfset values_conlisdocumento = "#rsDatosC.id_documento#,#rsDoc.id_tipo#,#rsDoc.codigo_documento#,#rsDoc.nombre_documento#">

	<cfif Len(Trim(rsDatosC.id_vistapopup))>
		<cfquery name="rsDoc" datasource="#session.tramites.dsn#">
			select id_vista,nombre_vista
			from DDVista
			where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDoc.id_tipo#">
			  and id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatosC.id_vistapopup#">
		</cfquery>
		<cfset values_conlisvistapopup = "#rsDatosC.id_vista#,#Replace(rsDoc.nombre_vista,',','','all')# ">
	</cfif>
</cfif>

<cfoutput>
<form method="post" name="formVC" action="Tp_RequisitosSQL.cfm" onsubmit="return validar_reqcumple(this);">
	<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%"><!--DWLayoutTable-->
		<tr>
		  <td height="25" bgcolor="##ECE9D8" style="padding:3px;"><font size="1">Validaci&oacute;n y Cumplimiento</font></td>
		</tr>
		<tr><td height="23">&nbsp;</td>
	    </tr>			
	</table>
	<table align="center" border="0" cellpadding="2" cellspacing="0"><!--DWLayoutTable-->
		<tr>
			<td width="50%" valign="top">
				<table width="100%" border="0" style=" border:1px solid gray; " cellpadding="2" cellspacing="0"> <!--- Documento Relacionado --->
					<tr><td colspan="2" bgcolor="##c8d7e3" style="padding:3px; "><strong>Documento Relacionado</strong></td></tr>
					<tr>
						<td colspan="2" nowrap>
							<table>
								<tr>
									<td>
										<cf_conlis title="Lista de Documentos"
										campos = "id_documento,id_tipodocumento,codigo_documento, nombre_documento" 
										desplegables = "N,N,S,S" 
										size = "0,0,10,50"
										values="#values_conlisdocumento#"
										tabla="TPDocumento"
										columnas="id_documento,id_tipo as id_tipodocumento,codigo_documento, nombre_documento"
										filtro=""
										desplegar="codigo_documento, nombre_documento"
										etiquetas="C&oacute;digo, Nombre"
										formatos="S,S"
										align="left,left"
										conexion="#session.tramites.dsn#"
										form = "formVC">
									</td>
									
									<td><input name="btnLimpiar" value="Limpiar" type="button" onClick="javascript: return Limpiar();"></td>
								</tr>
							</table>
						</td>
					</tr>

					<tr>
						<td width="20" ></td>
						<td width="505"></td>
					</tr>
					
					<tr>
						<td valign="middle">
							<input type="checkbox" name="es_vistapopup" id="es_vistapopup" <cfif modo neq 'ALTA' and Len(rsDatos.id_vistapopup)>checked</cfif>>
						</td>
						<td valign="middle"><label for="es_vistapopup">Permitir captura en ventana emergente</label> </td>
					</tr>

					<tr>
						<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
						<td valign="top">Vista de captura: 
							<cf_conlis title="Lista de Vistas"
							campos = "id_vistapopup,titulo_vistapopup" 
							desplegables = "N,S" 
							size = "0,50"
							values="#values_conlisvistapopup#"
							tabla="DDVista"
							columnas="id_vista as id_vistapopup,titulo_vista as titulo_vistapopup"
							filtro="es_interna=0 and id_tipo=$id_tipodocumento,numeric$"
							desplegar="titulo_vistapopup"
							etiquetas="T&iacute;tulo"
							formatos="S"
							align="left"
							conexion="#session.tramites.dsn#"
							form = "formVC">
						</td>
					</tr>
					
					<tr>
						<td valign="middle">
							<input onClick="javascript: ValidarCustodia();" type="checkbox" name="es_documental" id="es_documental" <cfif modo neq 'ALTA' and rsDatos.es_documental eq 1>checked</cfif>>
						</td>
						<td valign="middle"><label for="es_documental">Requiere presentar Documentaci&oacute;n.</label> </td>
					</tr>
					
					<tr>
						<td ></td>
						<td align="left" valign="top" nowrap > 			
							<input type="radio"  disabled name="es_custodia" id="es_custodia1" <cfif modo NEQ "ALTA" and  isdefined("rsDatos.es_custodia") and  rsDatos.es_custodia> checked </cfif>	 value="1" >
							<label for="es_custodia1">La documentaci&oacute;n se debe recibir y custodiar.</label>
						</td>
					</tr>
					
					<tr>
						<td ></td>
						<td align="left" valign="top" nowrap > 		
							<input type="radio"  disabled name="es_custodia" id="es_custodia2" <cfif modo NEQ "ALTA" and  isdefined("rsDatos.es_custodia") and  not rsDatos.es_custodia> checked <cfelseif modo EQ "ALTA">checked</cfif>	 value="0" >
							<label for="es_custodia2">Solamente cotejar los documentos y regresarlos a su due&ntilde;o.</label>
						</td>
					</tr>
					
					<tr>
						<td valign="middle" ><input type="checkbox" name="es_personal" id="es_personal" <cfif modo neq 'ALTA' and rsDatos.es_personal eq 1>checked</cfif>  ></td>
						<td valign="middle" ><label for="es_personal">El interesado debe presentarse personalmente</label></td>
					</tr>
				</table> <!--- Documento Relacionado --->
			</td>

			<td width="50%" valign="top">
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr>
						<td>
							<table width="100%" border="0" style=" border:1px solid gray; " cellpadding="2" cellspacing="0"> <!--- Fuente Inf. --->
								<tr><td colspan="2" style="padding:3px;"  bgcolor="##c8d7e3"><strong>Fuente de la informaci&oacute;n</strong></td></tr>
								<tr><td ></td><td></td></tr>
								<tr>
									<td align="left" valign="middle" width="20" nowrap >
										<input type="checkbox" name="es_autoverificar" id="es_autoverificar" 
											<cfif modo NEQ "ALTA" and  isdefined("rsDatos.es_autoverificar") and  rsDatos.es_autoverificar>checked
											<cfelseif modo EQ "ALTA">checked</cfif>>
									</td>
									
									<td align="left" valign="middle" nowrap >
										<label for="es_autoverificar">Verificar autom&aacute;ticamente en la ventanilla seg&uacute;n el expediente</label>
									</td>
								</tr>
								
								<tr>
									<td height="23" align="left" valign="middle" nowrap >	
										<input type="checkbox" name="es_conexion" id="es_conexion"
										<cfif modo EQ "ALTA">disabled
										<cfelseif rsWS.id_metodo EQ "">disabled
										<cfelseif modo NEQ "ALTA" and  isdefined("rsDatos.es_conexion") and  rsDatos.es_conexion>checked
										<cfelseif modo EQ "ALTA">checked</cfif>>	      
									</td>
									<td align="left" valign="middle" nowrap ><label for="es_conexion">Puede conectarse a la instituci&oacute;n.</label></td>
								</tr>
								
								<tr>
									<td align="left" valign="middle" nowrap >
										<input type="checkbox" name="es_capturable" id="es_capturable" 
											<cfif modo NEQ "ALTA" and  isdefined("rsDatos.es_capturable") and  rsDatos.es_capturable>checked
											<cfelseif modo EQ "ALTA">checked</cfif>>            
									</td>
									<td align="left" valign="middle" nowrap ><label for="es_capturable">Puede registrarse como parte del tr&aacute;mite.</label></td>
								</tr>
							</table> <!--- Fuente Inf. --->
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="0" style=" border:1px solid gray; " cellpadding="2" cellspacing="0"> <!--- Tipo de Requisito --->
								<tr><td colspan="2" style="padding:0; padding:3px; " bgcolor="##c8d7e3" ><strong>Tipo de Requisito</strong></td></tr>
								<tr>
									<td valign="top" width="1%"><input type="radio" name="es_impedimento" value="0" <cfif modo neq 'ALTA'><cfif rsDatos.es_impedimento eq 0>checked</cfif><cfelse>checked</cfif>></td>
									<td valign="middle">El documento es requerido</td>
								</tr>
			
								<tr>
									<td valign="middle" width="1%"><input type="radio" name="es_impedimento" value="1" <cfif modo neq 'ALTA' and rsDatos.es_impedimento eq 1>checked</cfif>></td>
									<td valign="middle">El documento no debe existir en el expediente</td>
								</tr>
							</table> <!--- Tipo de Requisito --->
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="0" style=" border:1px solid gray; " cellpadding="2" cellspacing="0"> <!--- Texto de Completado --->
								<tr><td colspan="2" style="padding:0; padding:3px;"  bgcolor="##c8d7e3"><strong>Texto de Completado:</strong></td></tr>
								<tr>
									<td colspan="2">
										<input type="text" name="texto_completado" value="<cfif isdefined("rsDatos")>#rsDatos.texto_completado#<cfelse>El requisito ha sido completado</cfif>" size="80" maxlength="255">
									</td>
								</tr>
							</table>
						</td>
					</tr>

				</table>	
			</td>
		</tr>	  

		<tr><td>&nbsp;</td></tr>

		<tr>
			<td colspan="2" align="center">
				<input type="submit" name="ModificarVC" value="Modificar">
				<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='Tp_RequisitosList.cfm';">
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
	</table>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="id_requisito" value="#rsDatos.id_requisito#">

	
</form>
</cfoutput>

<script type="text/javascript" language="javascript1.2">

	function validar_reqcumple(f) {
		if (f.es_vistapopup.checked && f.id_vistapopup.value.length == 0) {
			alert ("Debe especificar la vista de captura");
			return false;
		}
		return true;
	}
	
	function ValidarCustodia ( ) {
		if(document.formVC.es_documental.checked){
			document.formVC.es_custodia1.disabled = false;		
			document.formVC.es_custodia2.disabled = false;		
		}
		else {
			document.formVC.es_custodia1.disabled = true;	
			document.formVC.es_custodia2.disabled = true;	
		}
	}
	function ValidarVistaPopup ( ) {
		/*<!--- para invocar desde el click del check, pero
			cómo deshabilito un conlis ? ---> */
		if(document.formVC.es_vistapopup.checked) {
			document.formVC.id_vistapopup.disabled = false;
		}
		else {
			document.formVC.id_vistapopup.disabled = true;
		}
	}		
	<cfif modo NEQ 'ALTA'>
		ValidarCustodia();
	</cfif>
	function Limpiar(){
		document.formVC.id_documento.value= ' ';
		document.formVC.codigo_documento.value = ' ';
		document.formVC.nombre_documento.value = ' ';
	}
	
</script>
