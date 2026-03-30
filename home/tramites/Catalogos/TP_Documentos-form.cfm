<cfif isdefined("Form.id_documento") AND Len(Trim(Form.id_documento)) GT 0 >
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select * 
		from TPDocumento 
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
	</cfquery>
	
	<cfquery name="tipoident" datasource="#session.tramites.dsn#">
		select id_tipoident, codigo_tipoident, nombre_tipoident
		from TPTipoIdent
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
	</cfquery>
	
	
	<cfquery name="rsEstePuedeSer" datasource="#session.tramites.dsn#">
		select c.id_campo, id_tipocampo, nombre_campo
		from TPDocumento a
		  inner join DDTipo b
		  on b.id_tipo = a.id_tipo
		  inner join DDTipoCampo c
		  on c.id_tipo = b.id_tipo
		  inner join DDTipo d
		  on d.id_tipo = c.id_tipocampo
		  and d.tipo_dato = 'N'
		where a.id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
	</cfquery>
	
	<cfset modo = 'CAMBIO'>
</cfif>

<SCRIPT LANGUAGE='Javascript'  SRC="/cfmx/sif/js/utilesMonto.js"> </SCRIPT>
<SCRIPT LANGUAGE='Javascript'  SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</SCRIPT>

<cfoutput>
<form method="post" name="form1" action="TP_DocumentosSQL.cfm" >
	<table width="100%"  border="0" cellpadding="2">
	  <tr>
		<td valign="top" width="60%">
			<table align="center" width="100%" cellpadding="2" cellspacing="0">
				<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="3"><font size="1"><cfif modo neq 'ALTA'>
				  Modificar<cfelse>Agregar
				</cfif>&nbsp;Documento</font></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr valign="baseline"> 
					<td width="21%" align="right" nowrap>C&oacute;digo:</td>
					<td colspan="2">
						<input type="text" name="codigo_documento" style="text-transform:uppercase;" 
						value="<cfif modo NEQ "ALTA">#trim(rsDatos.codigo_documento)#</cfif>" 
						size="13" maxlength="10" onFocus="javascript:this.select();" >					</td>
				</tr>
				<tr valign="baseline"> 
					<td nowrap align="right">Nombre:</td>
					<td colspan="2">
					  <input type="text" name="nombre_documento" 
						value="<cfif modo NEQ "ALTA">#rsDatos.nombre_documento#</cfif>" 
						size="60" maxlength="100" onFocus="javascript:this.select();" >					</td>
				</tr>
				<tr valign="baseline"> 
					<td nowrap align="right">Tipo de Documento:</td>
					<td colspan="2">
						<select name="id_tipodoc">
							<cfloop query="rstipos">
								<option value="#rstipos.id_tipodoc#" <cfif modo NEQ "ALTA" and  isdefined('rsDatos.id_tipodoc') and rsDatos.id_tipodoc eq rstipos.id_tipodoc>selected</cfif>>#rstipos.codigo_tipodoc#-#rstipos.nombre_tipodoc#</option>
							</cfloop>
						</select>					</td>
				</tr>
				<tr valign="baseline">
				  <td nowrap align="right">Instituci&oacute;n Resposable</td>
				  <td colspan="2"><select name="id_inst" >
                    <option value="">- seleccionar -</option>
                    <cfloop query="rsInstitucion">
                      <option value="#rsInstitucion.id_inst#" <cfif modo NEQ "ALTA" and  isdefined('rsDatos.id_inst') and rsDatos.id_inst eq rsInstitucion.id_inst>selected</cfif>>#rsInstitucion.codigo_inst#-#rsInstitucion.nombre_inst#</option>
                    </cfloop>
                  </select></td>
			  </tr>
			  <cfif modo NEQ "ALTA" and rsEstePuedeSer.RecordCount>
			  <tr><td colspan="3">&nbsp;</td></tr>
	<tr >
	  <td colspan="4" align="left" valign="middle" nowrap bgcolor="##ECE9D8">
	  Informaci&oacute;n sobre el pago	de documentos </td>
  </tr>
				<tr valign="baseline">
				  <td nowrap align="right"><input type="checkbox" name="es_pago" id="es_pago" value="es_pago" <cfif isdefined('rsDatos.es_pago') and rsDatos.es_pago EQ 1>checked</cfif> /></td>
				  <td colspan="2">			    <label for="es_pago"> 
				  Este documento representa un cobro 
				  o factura y se debe poder pagar como parte de un requisito de un trámite. <br />
			     <em> En este caso, deberá especificar la moneda en que se
				   debe efectuar el pago, y cuál es el campo del documento
				   que contendrá el monto que se debe pagar. </em></label> </td>
			    </tr>
				<tr valign="baseline">
			      <td>&nbsp;</td>
				  <td width="28%" nowrap valign="top">Moneda del pago requerido </td>
				  <td width="51%" valign="top">
				  	<cfquery name="rsMonedas" datasource="asp">
						select Miso4217, Mnombre || ' (' || rtrim(Msimbolo) || ')' as Mnombre
						from Moneda
					</cfquery>
				  	<select name="moneda_pago">
					  	<cfloop query="rsMonedas">
							<option value="#Miso4217#" <cfif isdefined('rsDatos.moneda_pago') and rsDatos.moneda_pago EQ Miso4217>selected</cfif>>#Mnombre#</option>
						</cfloop>
			      	</select>				  </td>
				</tr>
				<tr valign="baseline">
			      <td>&nbsp;</td>
				  <td nowrap valign="top">Campo en el documento  que <br />
			      indica el monto por pagar </td>
				  <td valign="top">
				  	<select name="id_campo_pago">
					<cfif rsEstePuedeSer.RecordCount EQ 0>
						<option value="">-No hay campos num&eacute;ricos en el documento-</option>
					</cfif>
					
						<cfloop query="rsEstePuedeSer">
							<option value="#id_campo#" <cfif isdefined('rsDatos.id_campo_pago') and rsDatos.id_campo_pago EQ id_campo>selected</cfif>>#nombre_campo#</option>
						</cfloop>
			      	</select>				  </td>
			    </tr>
			  </cfif>
				<cfif modo neq 'ALTA' and tipoident.RecordCount>
				<tr valign="baseline">
				  <td nowrap align="right">&nbsp;</td>
				  <td colspan="2">
				  
				  	Este documento corresponde al tipo de
					identificaci&oacute;n:<br>
				  <a href="tipo-identificacion-tabs.cfm?id_tipoident=#URLEncodedFormat(tipoident.id_tipoident)#">
					<strong>#HTMLEditFormat(tipoident.codigo_tipoident)# -
					#HTMLEditFormat(tipoident.nombre_tipoident)#</strong>
			  		
					<br />
					<em><strong><img src="../images/edit.gif" alt="Editar documento" width="19" 
			height="17" border="0">						Editar
		            		</strong></em></a>				  </td>
			  </tr>
			  </cfif>
			  
			  

				<tr valign="baseline">
				  <td colspan="3" align="left" nowrap>
				  	<cfif modo NEQ 'ALTA'>
						<cf_vigente form="form1" desde="#rsDatos.vigente_desde#" hasta="#rsDatos.vigente_hasta#">
					<cfelse>
						<cf_vigente form="form1">
					</cfif>				  </td>
			  </tr>
			</table>
		</td>
		<td valign="top" width="40%">&nbsp;
			
		</td>
	  </tr>
		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<cfinclude template="../../../sif/portlets/pBotones.cfm">
				<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='Tp_DocumentosList.cfm';">
			</td>
		</tr>
		<tr valign="baseline"> 
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
				</cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
			<input type="hidden" name="id_documento" value="<cfif modo NEQ "ALTA">#rsDatos.id_documento#</cfif>">
		</tr>	  
	</table>
</form>
</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.codigo_documento.required = true;
	objForm.codigo_documento.description="Código";				
	objForm.nombre_documento.required = true;
	objForm.nombre_documento.description="Nombre";				
	objForm.id_inst.required = true;
	objForm.id_inst.description="Institución";				
	objForm.vigente_desde.required = true;
	objForm.vigente_desde.description="Desde";				
	objForm.vigente_hasta.required = true;
	objForm.vigente_hasta.description="Hasta";				

	
	function deshabilitarValidacion(){
		objForm.codigo_documento.required = false;
		objForm.nombre_documento.required = false;
		objForm.vigente_desde.required = false;
		objForm.vigente_hasta.required = false;
		
	}
</SCRIPT>

