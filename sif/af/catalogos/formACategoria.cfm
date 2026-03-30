<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AFDEP" Default= "Iniciar depreciación en mes de adqusici&oacute;n." XmlFile="ACatetoria.xml" returnvariable="LB_AFDEP"/>

<cfif isdefined("form.ACcodigo") and len(trim(form.ACcodigo))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif (modo neq "ALTA")>
	<cfquery name="rsACategoria" datasource="#Session.DSN#">
		select ACcodigo, ACcodigodesc, ACdescripcion, ACvutil, ACcatvutil, ACmetododep, ACmascara,ACdepadq, cuentac,
		ltrim(rtrim(Ucodigo)) as Ucodigo, ts_rversion
		from ACategoria
		where Ecodigo  = #Session.Ecodigo#
		  and ACcodigo = <cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<cfquery name="_dataUnidad" datasource="#session.dsn#">
	select  rtrim(Ucodigo) as Ucodigo, Udescripcion
	 from Unidades
		where Utipo in (0,1,2)<!--- (0 Articulos) (1 Servicios) (2 Ambos)--->
		  and Ecodigo= #session.Ecodigo#
</cfquery>

<!---SML. 25/02/2014 Consulta para obtener el parametro de Generar Placa Automatica --->

<cfquery name="rsGenPlacaAut" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 200050
</cfquery>

<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function funcClasificacion(data) {
		document.form1.action='AClasificacion.cfm';
		document.form1.submit();
		return false;
	}
</script>

<cfoutput>
<form name="form1" method="post" action="SQLACategoria.cfm">
	<table align="center" width="100%" cellpadding="0" cellspacing="0">

		<tr valign="baseline">
			<td colspan="2" class="subTitulo" align="center">
				<cfif modo neq "ALTA">
					Cambio de Categor&iacute;a #rsACategoria.ACcodigodesc# - #rsACategoria.ACdescripcion#
				<cfelse>
					Registro de Nueva Categor&iacute;a
				</cfif>
			</td>
		</tr>

		<tr valign="baseline">
			<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
		  <td>
              <input name="ACcodigodesc" type="text" tabindex="1"
			  	value="<cfif modo NEQ "ALTA">#rsACategoria.ACcodigodesc#</cfif>" size="10" maxlength="10" onFocus="this.select();">
</td>
			<cfif modo eq "CAMBIO">
				<td>
					<input type="hidden" name="ACcodigodescL" id="ACcodigodescL" tabindex="1"
					value="#trim(rsACategoria.ACcodigodesc)#"></td>
			</cfif>
		</tr>

		<tr valign="baseline">
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="ACdescripcion" type="text" tabindex="1"
				value="<cfif modo NEQ "ALTA">#HTMLEditFormat(rsACategoria.ACdescripcion)#</cfif>" size="40" maxlength="50" onFocus="this.select();">
			</td>
		</tr>

		<tr valign="baseline">
			<td align="right" nowrap>Vida &uacute;til:&nbsp;</td>
			<td>
				<input name="ACvutil" type="text" tabindex="1"
				 	value="<cfif modo NEQ "ALTA">#rsACategoria.ACvutil#</cfif>" size="6" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"  >
			</td>
		</tr>

		<tr valign="baseline">
			<td align="right" nowrap>M&eacute;todo de Depreciaci&oacute;n:&nbsp;</td>
			<td>
				<select name="ACmetododep" tabindex="1" onChange="javascript: showChkbox(this.form);">
					<option value="1" <cfif modo neq "ALTA" and rsACategoria.ACmetododep eq "1">selected</cfif>>L&iacute;nea Recta</option>
					<option value="2" <cfif modo neq "ALTA" and rsACategoria.ACmetododep eq "2">selected</cfif>>Suma de D&iacute;gitos</option>
					<option value="3" <cfif modo neq "ALTA" and rsACategoria.ACmetododep eq "3">selected</cfif>>Por Actividad</option>
				</select>
			</td>
		</tr>
		<tr id="TR_UnidadMedida" valign="baseline">
			<td align="right" nowrap>Unidad de Medida</td>
			<td>
				<select name="Ucodigo" tabindex="1" onChange="javascript: showChkbox(this.form);">
					<cfloop query="_dataUnidad">
						<option value="#_dataUnidad.Ucodigo#" <cfif modo neq "ALTA" and rsACategoria.Ucodigo eq #_dataUnidad.Ucodigo#>selected</cfif>>#_dataUnidad.Udescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td nowrap>
				<input 	type="checkbox" tabindex="1"
						name="ACcatvutil"
						value="<cfif modo NEQ "ALTA">#rsACategoria.ACcatvutil#</cfif>" <cfif modo NEQ "ALTA"><cfif rsACategoria.ACcatvutil EQ "S"> checked </cfif></cfif>
						onClick="javascript:if(document.form1.ACcatvutil.value=='N') document.form1.ACcatvutil.value='S'; else document.form1.ACcatvutil.value='N';"
				>Asignar vida &uacute;til a Clasificaci&oacute;n
			</td>
		</tr>
				<tr valign="baseline">
			<td>&nbsp;</td>
			<td nowrap>
				<input type="checkbox" tabindex="1"
					   name="ACdepadq"
					   value="<cfif modo NEQ "ALTA">#rsACategoria.ACdepadq#</cfif>" <cfif modo NEQ "ALTA"><cfif rsACategoria.ACdepadq EQ 1> checked </cfif></cfif>
					   onClick="javascript:if(document.form1.ACdepadq.value==0) document.form1.ACdepadq.value=1; else document.form1.ACdepadq.value=0;"
				>#LB_AFDEP#
			</td>
		</tr>

        <cfif isdefined('rsGenPlacaAut') and rsGenPlacaAut.Pvalor NEQ 1>
		<tr valign="baseline">
			<td align="right" nowrap>M&aacute;scara:&nbsp;</td>
			<td>
				<input name="ACmascara" type="text" tabindex="1"
					value="<cfif modo NEQ "ALTA">#trim(rsACategoria.ACmascara)#</cfif>" size="20" maxlength="20" onFocus="this.select();" onKeyPress="javascript: return acceptX(event);">
			</td>
		</tr>
        <tr valign="baseline" id="trMsjMascara">
			<td align="right" nowrap>&nbsp;</td>
			<td>* Solo se permite agregar el valor X para la m&aacute;scara</td>
		</tr>
        <cfelse>
        <tr valign="baseline">
			<td align="right" nowrap>M&aacute;scara:&nbsp;</td>
			<td>
				<input name="ACmascara" type="text" tabindex="1" value="<cfif modo NEQ "ALTA">#trim(rsACategoria.ACmascara)#</cfif>" size="20" maxlength="20"/>
			</td>
		</tr>
        <tr valign="baseline" id="trMsjMascaraA">
			<td align="right" nowrap>&nbsp;</td>
			<td>* Solo se permite el comodin * para la m&aacute;scara</td>
		</tr>
        </cfif>
		<tr>
			<td align="right" nowrap>Complemento para Inversi&oacute;n:</td>
			<td><input name="cuentac" type="text" tabindex="1"
				value="<cfif modo NEQ "ALTA">#trim(rsACategoria.cuentac)#</cfif>" size="40" maxlength="100" onFocus="this.select();"></td>
		</tr>
		<tr>
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsACategoria.ts_rversion#" returnvariable="ts"></cfinvoke>
			</cfif>

			<td align="right" nowrap>
				<cfif modo NEQ "ALTA">
					<input name="ACcodigo" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA">#rsACategoria.ACcodigo#</cfif>" >
				</cfif>

				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" tabindex="-1">
				<input type="hidden" name="Pagina" tabindex="-1"
					value="
						<cfif isdefined("form.pagenum1") and form.pagenum1 NEQ "">
							#form.pagenum1#
						<cfelseif isdefined("url.PageNum_lista1") and url.PageNum_lista1 NEQ "">
							#url.PageNum_lista1#
						</cfif>">
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr valign="baseline">
			<td colspan="2" align="right" nowrap >
				<cfset Lvar_botones = 'Importar'>
				<cfset Lvar_botonesV = 'Importar Categoria'>

				<cfset Lvar_botons = 'Exportar'>
				<cfset Lvar_botonV = 'Exportar Categoria'>

				<cfset Lvar_botones2 = 'ImportarC'>
				<cfset Lvar_botonesV2 = 'Importar Clase'>

				<cfset Lvar_botones3 = 'ExportarC'>
				<cfset Lvar_botonesV3 = 'Exportar Clase'>

				<cfif modo NEQ 'ALTA'>
					<cfset Lvar_botones = 'Clasificacion'>
					<cfset Lvar_botonesV = 'Clasificación'>
				</cfif>
				<cf_botones modo="#modo#" tabindex="1" include="#Lvar_botones#,#Lvar_botons#,#Lvar_botones2#,#Lvar_botones3#" includevalues="#Lvar_botonesV#,#Lvar_botonV#,#Lvar_botonesV2#,#Lvar_botonesV3#">
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">

	<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfoutput>
		objForm.ACcodigodesc.description="#JSStringFormat('Código')#";
		objForm.ACdescripcion.description="#JSStringFormat('Descripción')#";
		objForm.ACvutil.description="#JSStringFormat('Vida Útil')#";
		objForm.ACmascara.description="#JSStringFormat('Máscara')#";
	</cfoutput>

	function showChkbox(f) {
		var TR_UnidadMedida = document.getElementById("TR_UnidadMedida");
		TR_UnidadMedida.style.display = "none";
		if (f.ACmetododep.value == 3){
			TR_UnidadMedida.style.display = "";
		}
	}
	function habilitarValidacion(){
		objForm.ACcodigodesc.required = true;
		objForm.ACdescripcion.required = true;
		objForm.ACvutil.required = true;
		objForm.ACmascara.required = true;
	}

	function deshabilitarValidacion(){
		objForm.ACcodigodesc.required = false;
		objForm.ACdescripcion.required = false;
		objForm.ACvutil.required = false;
		objForm.ACmascara.required = false;
	}

	habilitarValidacion();

	objForm.ACcodigodesc.obj.focus();

	function acceptX(evt){
		// NOTE: x = 120, X = 88, Enter = 13, - = 45
		var key = nav4 ? evt.which : evt.keyCode;
		return (key == 13 || key == 45 || key == 88 || key == 8 || key == 0);
	}

	function funcImportar(){
		deshabilitarValidacion();
		document.form1.action='/cfmx/sif/af/catalogos/importaCategoria.cfm'
	}

	function funcImportarC(){
		deshabilitarValidacion();
		document.form1.action='/cfmx/sif/af/catalogos/importaClase.cfm'
	}

	function funcExportar(){
		deshabilitarValidacion();
		document.form1.action='/cfmx/sif/af/catalogos/ExportaCategoria.cfm'
	}

	function funcExportarC(){
		deshabilitarValidacion();
		document.form1.action='/cfmx/sif/af/catalogos/ExportaClase.cfm'
	}
	showChkbox(document.form1);
	//-->
</script>