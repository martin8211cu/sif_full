<cfset modo = "ALTA">
<cfif isdefined("Form.SScodigo")>
	<cfset modo = "CAMBIO">
</cfif>

<!--- codigos que ya existen --->
<cfquery name="rsCodigos" datasource="asp">
	select SScodigo 
	from SSistemas
	<cfif modo neq 'ALTA'>
		where SScodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
	</cfif>
	order by SScodigo
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="asp">
		select SScodigo, SSdescripcion, SShomeuri, SSmenu, SSorden, SShablada, SSlogo, ts_rversion as SStimestamp
		from SSistemas
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
		order by SScodigo, SSdescripcion
	</cfquery>

	<!--- Averiguar si un sistema puede ser borrado --->
	<cfquery name="rsDependencias1" datasource="asp">
		select count(1) as cant 
		from SRoles
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
	</cfquery>

	<cfquery name="rsDependencias2" datasource="asp">
		select count(1) as cant 
		from STablas
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
	</cfquery>

	<cfquery name="rsDependencias3" datasource="asp">
		select count(1) as cant 
		from SModulos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
	</cfquery>
</cfif>

<SCRIPT src="/cfmx/sif/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script type="text/javascript" language="javascript1.2">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<cfoutput>
<form name="frmSistemas" action="sistemas-sql.cfm" method="post" enctype="multipart/form-data">
	<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="Pagina" value="#Form.PageNum#">
	</cfif>
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td align="right" class="etiquetaCampo" width="50%">C&oacute;digo:</td>
		<td align="left">
			<cfif modo EQ "CAMBIO">
				#rsData.SScodigo#
				<input name="SScodigo" type="hidden" id="SScodigo" value="#rsData.SScodigo#">
			<cfelse>
				<input name="SScodigo_text" type="text" id="SScodigo_text" size="10" maxlength="10"  onBlur="codigos(this);" onFocus="this.select();">
			</cfif>
		</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td align="right" class="etiquetaCampo">Descripci&oacute;n: </td>
		<td align="left" colspan="3"><input name="SSdescripcion" type="text" id="SSdescripcion" value="<cfif modo EQ 'CAMBIO'>#rsData.SSdescripcion#</cfif>" size="30" maxlength="50" onFocus="this.select();"></td>
	  </tr>

	  <tr>
		<td align="right" class="etiquetaCampo">P&aacute;gina Inicial: </td>
		<td colspan="3" align="left"><input name="SShomeuri" type="text" id="SShomeuri" value="<cfif modo EQ 'CAMBIO'>#rsData.SShomeuri#</cfif>" size="60" maxlength="255" onBlur="javascript:pagina(this);" onFocus="this.select();"></td>
	  </tr>

	  <tr>
	  	<td>&nbsp;</td>
		<td align="left"><input style="border:0;" type="checkbox" name="SSmenu" id="SSmenu" value="" <cfif modo neq 'ALTA' and rsData.SSmenu eq 1 >checked</cfif>><label for="SSmenu">Mostrar en men&uacute;</label></td>
		<td rowspan="3">
			<!---
			<cfif modo neq 'ALTA'>
				<cf_leerimagen autosize="true" border="false" tabla="SSistemas" campo="SSlogo" condicion="SScodigo = '#form.SScodigo#' and datalength(SSlogo) > 1" conexion="asp" imgname="img" >
			</cfif>
			--->
		</td>
	</tr>
	
	<tr>
		<td align="right" class="etiquetaCampo">Orden: </td>
		<td align="left">
			<input name="SSorden" type="text" style="text-align: right;" onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#rsData.SSorden#</cfif>" size="5" maxlength="4" >
			<input name="SSorden_2" type="hidden" value="<cfif modo EQ 'CAMBIO'>#rsData.SSorden#</cfif>" >
		</td>
	</tr>
	
	<tr>
		<td align="right" class="etiquetaCampo">Logo: </td>
		<td align="left">
			<input name="logo" type="file" id="logo" onChange="previewLogo(this.value)">
		</td>
	</tr>

	<tr>
		<td align="right" valign="top" class="etiquetaCampo">Informaci&oacute;n: </td>
		<td align="left" colspan="2">
			<textarea class="textarea" name="SShablada" cols="33" rows="8" onFocus="this.select();"><cfif modo neq 'ALTA'>#rsData.SShablada#</cfif></textarea>
			<br><b>El texto ingresado aqu&iacute;, ser&aacute; mostrado en el men&uacute;.</b>
		</td>
	</tr>

	  <tr>
	    <td colspan="3">&nbsp;</td>
      </tr>
	  <tr>
	    <td colspan="3" align="center">
			<cfif modo EQ "CAMBIO">
				<input type="submit" name="btnCambiar" value="Guardar">
				<cfif rsDependencias1.cant EQ 0 and rsDependencias2.cant EQ 0 and rsDependencias3.cant EQ 0>
				<input type="submit" name="btnEliminar" value="Eliminar" onClick="javascript: if (confirm('¿Está seguro de que desea eliminar este sistema?')) { deshabilitarValidacion(); return true; } else return false;">
				</cfif>
				<input type="button" name="btnNuevo" value="Nuevo" onClick="location.href='sistemas.cfm'">
				<input type="submit" name="btnModulos" value="M&oacute;dulos" onClick="javascript:deshabilitarValidacion();">
			<cfelse>
				<input type="submit" name="btnAgregar" value="Agregar">
			</cfif>
		</td>
      </tr>

	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td colspan="3" align="center" valign="top">
			<!--- <cf_leerimagen autosize="true" border="false" tabla="SSistemas" campo="SSlogo" condicion="SScodigo = '#form.SScodigo#' and datalength(SSlogo) > 1" conexion="asp" imgname="img" > --->
		  <cfset imagesrc = "blank.gif">
		  <cfif (modo neq 'ALTA') and Len(rsData.SSlogo) GT 1>
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="tsurl">
				<cfinvokeargument name="arTimeStamp" value="#rsData.SStimestamp#"/>
			</cfinvoke>
			<cfset imagesrc = "/cfmx/home/public/logo_sistema.cfm?s="&URLEncodedFormat(rsData.SScodigo)&"&ts="&tsurl>
		</cfif>
			<img src="#imagesrc#" name="logo_preview" id="logo_preview" border="0" width="245" height="155">
		</td>
	</tr>

	</table>
</form>

</cfoutput>

<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("frmSistemas");

	<cfif modo EQ "ALTA">
		objForm.SScodigo_text.required = true;
		objForm.SScodigo_text.description = "Código";
	</cfif>
	objForm.SSdescripcion.required = true;
	objForm.SSdescripcion.description = "Descripción";
	
	objForm.SShomeuri.required = false;
	objForm.SShomeuri.description = "Página Inicial";


	function deshabilitarValidacion() {
		objForm.SSdescripcion.required = false;
		objForm.SShomeuri.required = false;
	}

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.SScodigo#</cfoutput>';
				if (dato.toUpperCase() == temp.toUpperCase()){
					alert('El Código de Sistema ya existe.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}
	
	function pagina(obj){
		if (trim(obj.value) != '' && obj.value.charAt(0) != '/') {
			obj.value = "/" + obj.value;
		}
	}
	
	function previewLogo(value) {
		var logo = document.all ? document.all.logo_preview : document.getElementById('logo_preview');
		logo.src = value;
	}
	
</script>
