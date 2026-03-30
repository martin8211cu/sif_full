<cfif len(url.id_tipoident)>  
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>


<cfquery datasource="#session.tramites.dsn#" name="inst">
	select id_inst,nombre_inst
	from TPInstitucion
	order by nombre_inst
</cfquery>


<cfif isdefined("url.id_tipoident") AND Len(Trim(url.id_tipoident)) GT 0 >
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		SELECT a.id_tipoident, a.codigo_tipoident, a.nombre_tipoident, a.es_fisica, a.ts_rversion,
			d.id_documento, d.codigo_documento, d.nombre_documento, a.mascara, d.id_inst
		FROM TPTipoIdent a
			left join TPDocumento d
				on a.id_documento = d.id_documento
		WHERE a.id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipoident#">
	</cfquery>
</cfif>
<SCRIPT SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</SCRIPT>

<cfoutput>
<form method="post" name="form1" action="tipo-identificacion-sql.cfm">
	<table align="center" width="100%" cellpadding="2" cellspacing="0">
		<tr><td class="tituloMantenimiento" colspan="2"><font size="1"><cfif modo neq 'ALTA'>Modificar<cfelse>Agregar</cfif> Tipo de Identificaci&oacute;n</font></td></tr>
		<tr valign="baseline"> 
			<td nowrap align="right">C&oacute;digo:</td>
			<td>
				<input type="text" name="codigo_tipoident"  style="text-transform:uppercase;" 
				value="<cfif modo NEQ "ALTA">#rsDatos.codigo_tipoident#</cfif>" 
				size="10" maxlength="10" onfocus="javascript:this.select();" >			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Descripci&oacute;n:</td>
			<td>
				<input type="text" name="nombre_tipoident" 
				value="<cfif modo NEQ "ALTA">#rsDatos.nombre_tipoident#</cfif>" 
				size="60" maxlength="100" onfocus="javascript:this.select();" >			</td>
		</tr>
		
		<tr>
		  <td valign="top" align="right">Institución emisora: </td>
		  <td valign="top"><select name="id_inst">
		  <cfloop query="inst">
		  	<option value="#HTMLEditFormat(id_inst)#" <cfif modo neq 'ALTA' and rsdatos.id_inst eq inst.id_inst>selected</cfif>>
				#HTMLEditFormat(nombre_inst)#</option></cfloop >
		  </select></td>
	  </tr>
		<tr>
		  <td valign="top" align="right">M&aacute;scara de captura: </td>
		  <td valign="top"><input type="text" name="mascara" id="mascara" size="30" maxlength="60" onfocus="this.select()"
		  	value="<cfif modo NEQ "ALTA">#rsDatos.mascara#</cfif>" ><br />
		  <em>Utilice ceros u otros n&uacute;meros para indicar n&uacute;meros, <br />
		  equis para alfanum&eacute;ricos,  
			o <br />caracteres literales que sean obligatorios.<br />
		  Ejemplos: 1-0999-0999, XXXX000000XXX.</em>
		  </td>
	  </tr>
	  <cfif modo NEQ 'ALTA'>
		<tr>
		  <td valign="top" align="right">Documento de identificaci&oacute;n:</td>
		  <td valign="top">
			<a href="Tp_Documentos.cfm?id_documento=#URLEncodedFormat(rsdatos.id_documento)#">
			#HTMLEditFormat(rsdatos.codigo_documento)#  -
		#HTMLEditFormat(rsdatos.nombre_documento)#
		
		
		<em><strong>
			<br />
			<img src="../images/edit.gif" alt="Editar documento" width="19" 
				height="17" border="0">		Editar 	</a></strong></em>
		
									</td>
	  </tr></cfif>	
	 
		<tr>
			<td></td>
			<td>
				<table width="30%" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="middle"><input type="checkbox" name="es_fisica" id="es_fisica" <cfif modo neq 'ALTA' and rsdatos.es_fisica eq 1>checked</cfif>></td>
						<td valign="middle" nowrap><label for="es_fisica">Representa persona f&iacute;sica</label></td>
					</tr>
				</table>			</td>
		</tr>
		
		
		<tr><td>&nbsp;</td></tr>
		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<cfinclude template="../../../sif/portlets/pBotones.cfm">			</td>
		</tr>
		<tr valign="baseline"> 
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">				</cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
			<input type="hidden" name="id_tipoident" value="<cfif modo NEQ "ALTA">#rsDatos.id_tipoident#</cfif>">
		</tr>
	</table>
</form>
</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.codigo_tipoident.required = true;
	objForm.codigo_tipoident.description="Código";				
	objForm.nombre_tipoident.required = true;
	objForm.nombre_tipoident.description="Descripción";
	<!---
	if (document.form1.id_documento){
	objForm.id_documento.required = true;
	objForm.id_documento.description="Documento asociado";
	}--->

	function deshabilitarValidacion(){
		objForm.codigo_tipoident.required = false;
		objForm.nombre_tipoident.required = false;
		//objForm.id_documento.required = false;
	}
	function funcNuevo(){
	location.href='?';
	}
</SCRIPT>


