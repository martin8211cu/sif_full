<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Grpmodulos = t.Translate('LB_Grpmodulos','Grupo del modulo.','/home/menu/GrpModulos.xml')>

<cfset modo = "ALTA">
<cfif isdefined("Form.SScodigo") and isdefined("Form.SMcodigo")>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Sistemas Existentes --->
<cfquery name="rsSistemas" datasource="asp">
	select 	SScodigo,
			{fn concat({fn concat(rtrim(SScodigo), ' - ')}, SSdescripcion)} as SSdescripcion	<!--- rtrim(SScodigo) || ' - ' || SSdescripcion as SSdescripcion --->
	from SSistemas

	order by SScodigo, SSdescripcion
</cfquery>

<!--- modulos que ya existen --->
<cfquery name="rsCodigos" datasource="asp">
	select SScodigo, SMcodigo
	from SModulos
	<cfif modo neq 'ALTA'>
		where SMcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
	</cfif>
	order by SScodigo, SMcodigo
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="asp">
		select 	a.SScodigo as SScodigo,
				<!---rtrim(a.SScodigo) || ' - ' || a.SSdescripcion as Sistema,--->
				{fn concat({fn concat(rtrim(a.SScodigo), ' - ')}, a.SSdescripcion)}  as Sistema,
			   	b.SMcodigo as SMcodigo, b.SMdescripcion, b.SMhomeuri, b.SMmenu, b.SMorden, b.SMhablada
			   	, b.SMlogo, b.ts_rversion as SStimestamp
		from SSistemas a, SModulos b
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
		and b.SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
		and a.SScodigo = b.SScodigo
	</cfquery>

	<!--- Averiguar si un sistema puede ser borrado --->
	<cfquery name="rsDependencias1" datasource="asp">
		select count(1) as cant from SProcesos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
		and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
	</cfquery>

	<cfquery name="rsDependencias2" datasource="asp">
		select count(1) as cant from UsuarioProceso
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
		and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
	</cfquery>

</cfif>

<!--- Rs grupo de modulos existentes --->
<cfquery datasource="asp" name="rsGrpmodulos">
 	select SGcodigo,SGdescripcion
	from SGModulos
	<cfif isdefined('form.FSSCodigo')>
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FSSCodigo#">
	<cfelseif isdefined('form.SSCodigo')>
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SSCodigo#">
	</cfif>
</cfquery>

<SCRIPT src="/cfmx/sif/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script type="text/javascript" language="javascript1.2">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>


<form name="frmSistemas" action="modulos-sql.cfm" method="post" enctype="multipart/form-data">
	<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="Pagina" value="<cfoutput>#Form.PageNum#</cfoutput>">
	</cfif>
	<cfif isdefined("Form.FSScodigo")>
		<input type="hidden" name="FSScodigo" value="<cfoutput>#Form.FSScodigo#</cfoutput>">
	</cfif>
	<cfif isdefined("Form.FSMcodigo")>
		<input type="hidden" name="FSMcodigo" value="<cfoutput>#Form.FSMcodigo#</cfoutput>">
	</cfif>
	<cfif isdefined("Form.FSMdescripcion")>
		<input type="hidden" name="FSMdescripcion" value="<cfoutput>#Form.FSMdescripcion#</cfoutput>">
	</cfif>
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
	    <td align="right" nowrap class="etiquetaCampo">Sistema:</td>
	    <td align="left" nowrap colspan="2">
			<cfif modo EQ "CAMBIO">
				<cfoutput>#rsData.Sistema#</cfoutput>
				<input name="SScodigo" type="hidden" id="SScodigo" value="<cfoutput>#rsData.SScodigo#</cfoutput>">
			<cfelse>
				<cfset defaultSScodigo="">
				 <cfif isdefined("form.SScodigo")><cfset defaultSScodigo=form.SScodigo>
				 <cfelseif isdefined("form.fSScodigo")><cfset defaultSScodigo=form.fSScodigo>
				 </cfif>
				<select name="SScodigo_text">
				<cfloop query="rsSistemas">
					<option value="<cfoutput>#SScodigo#</cfoutput>" <cfif Trim(defaultSScodigo) eq Trim(rsSistemas.SScodigo)>selected</cfif>  ><cfoutput>#SSdescripcion#</cfoutput></option>
				</cfloop>
				</select>
		</cfif>
		</td>
      </tr>
	  <tr>
		<td align="right" nowrap class="etiquetaCampo">C&oacute;digo:</td>
		<td align="left" nowrap colspan="2">
			<cfif modo EQ "CAMBIO">
				<cfoutput>#rsData.SMcodigo#</cfoutput>
				<input name="SMcodigo" type="hidden" id="SMcodigo" value="<cfoutput>#rsData.SMcodigo#</cfoutput>">
			<cfelse>
				<input name="SMcodigo_text" type="text" id="SMcodigo_text" size="10" maxlength="10" onBlur="codigos(this);" onFocus="this.select();" >
			</cfif>
		</td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="etiquetaCampo">Descripci&oacute;n: </td>
		<td align="left" nowrap colspan="2">
			<input name="SMdescripcion" type="text" id="SMdescripcion" value="<cfif modo EQ 'CAMBIO'><cfoutput>#rsData.SMdescripcion#</cfoutput></cfif>" onFocus="this.select();" size="40" maxlength="50">
		</td>
	  </tr>

	  <tr>
		<td align="right" class="etiquetaCampo" nowrap>P&aacute;gina Inicial: </td>
		<td align="left" colspan="2"><input name="SMhomeuri" type="text" id="SMhomeuri" value="<cfif modo EQ 'CAMBIO'><cfoutput>#rsData.SMhomeuri#</cfoutput></cfif>" size="60" maxlength="255" onBlur="javascript:pagina(this);" onFocus="this.select();"></td>
	  </tr>

	  <tr>
	  	<td>&nbsp;</td>
		<td align="left"><input style="border:0;" type="checkbox" name="SMmenu" value="" <cfif modo neq 'ALTA' and rsData.SMmenu eq 1 >checked</cfif>>Mostrar en men&uacute;</td>
		<td rowspan="3" align="center" valign="middle">
			<cfif modo neq 'ALTA'>
				<!--- <cf_leerimagen autosize="true" border="false" tabla="SModulos" campo="SMlogo" condicion="SMcodigo = '#trim(form.SMcodigo)#' and datalength(SMlogo) > 1" conexion="asp" imgname="img" > --->
				<cfif Len(rsData.SMlogo) GT 1>
				<cfinvoke
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="tsurl">
					<cfinvokeargument name="arTimeStamp" value="#rsData.SStimestamp#"/>
				</cfinvoke>
				<img src="/cfmx/home/public/logo_modulo.cfm?s=#URLEncodedFormat(rsData.SScodigo)#&m=#URLEncodedFormat(rsData.SMcodigo)#&ts=#tsurl#" border="0" width="245" height="155">
				</cfif>
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right" class="etiquetaCampo"><cfoutput>#LB_Grpmodulos#</cfoutput> : </td>
		<td align="left">
			<select  name="SGcodigo" id="SGcodigo" required>
				<cfif modo EQ 'CAMBIO'>
					<cfif form.SGdescripcion NEQ "">
						<option value="<cfoutput>#form.SGcodigo#</cfoutput>">
							<cfoutput>#form.SGdescripcion#</cfoutput>
						</option>
					<cfelse>
						<option value="">
							Seleccione grupo modulo
						</option>
					</cfif>
				</cfif>
				<cfoutput query="rsGrpmodulos">
				     <option value="#rsGrpmodulos.SGcodigo#">
							#rsGrpmodulos.SGdescripcion#
					</option>
				</cfoutput> <!--Fin del iteracion --->
			</select>
		</td>
	</tr>
	<tr>
		<td align="right" class="etiquetaCampo">Orden: </td>
		<td align="left">
			<input name="SMorden" type="text" style="text-align: right;" onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'><cfoutput>#rsData.SMorden#</cfoutput></cfif>" size="5" maxlength="4" >
		</td>
	</tr>

	<tr>
		<td align="right" class="etiquetaCampo">Logo: </td>
		<td align="left">
			<input name="logo" type="file">
<!---
			<cfif modo neq 'ALTA'>
				<cf_leerimagen autosize="true" border="false" tabla="SModulos" campo="SMlogo" condicion="SMcodigo = '#trim(form.SMcodigo)#' and datalength(SMlogo) > 1" conexion="asp" imgname="img" >
			</cfif>
--->
		</td>
	</tr>

	<tr>
		<td align="right" valign="top" class="etiquetaCampo">Informaci&oacute;n:</td>
		<td align="left" colspan="3">
			<textarea name="SMhablada" cols="33" rows="8" onFocus="this.select();"><cfif modo neq 'ALTA'><cfoutput>#rsData.SMhablada#</cfoutput></cfif></textarea>
			<br><b>El texto ingresado aqu&iacute;, ser&aacute; mostrado en el men&uacute;.</b>
		</td>
	</tr>

	  <tr>
	    <td colspan="2">&nbsp;</td>
      </tr>
	  <tr>
	    <td colspan="3" align="center">
			<cfif modo EQ "CAMBIO">
				<input type="submit" name="btnCambiar" value="Guardar">
				<cfif rsDependencias1.cant EQ 0 and rsDependencias2.cant EQ 0>
				<input type="submit" name="btnEliminar" value="Eliminar" onClick="javascript: if (confirm('¿Está seguro de que desea eliminar este módulo?')) { deshabilitarValidacion(); return true; } else return false;">
				</cfif>
				<input type="submit" name="btnNuevo" value="Nuevo">
				<input type="submit" name="btnProcesos" value="Procesos" onClick="javascript: deshabilitarValidacion(); ">
			<cfelse>
				<input type="submit" name="btnAgregar" value="Agregar">
			</cfif>
		</td>
      </tr>
	</table>
</form>


<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("frmSistemas");

	<cfif modo EQ "ALTA">
	objForm.SScodigo_text.required = true;
	objForm.SScodigo_text.description = "Sistema";
	objForm.SMcodigo_text.required = true;
	objForm.SMcodigo_text.description = "Código";
	</cfif>
	objForm.SMdescripcion.required = true;
	objForm.SMdescripcion.description = "Descripción";
	objForm.SMhomeuri.required = false;
	objForm.SMhomeuri.description = "Página Inicial";

	function deshabilitarValidacion() {
		objForm.SMdescripcion.required = false;
		objForm.SMhomeuri.required = false;
		document.getElementById("SGcodigo").required = false;
	}

	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value + '|' + document.frmSistemas.SScodigo_text.value;
			var temp    = new String();

			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.SMcodigo#|#rsCodigos.SScodigo#</cfoutput>';
				if (dato.toUpperCase() == temp.toUpperCase()){
					alert('El Código de Módulo ya existe.');
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

</script>
