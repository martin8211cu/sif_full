<cfif modo EQ "CAMBIO">
	<cfquery name="cantVistas" datasource="#session.tramites.dsn#">
		select count(1) as cant
		from DDVista
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
	</cfquery>
</cfif>

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function show() {
		// Chequea la clase del tipo de dato
		if (arguments[0]) {
			var a = document.getElementById("trTipo");
			var b = document.getElementById("trLongitud");
			var b1 = document.getElementById("trDecimales");
			var c = document.getElementById("trMinimo");
			var c1 = document.getElementById("trMaximo");
			var d = document.getElementById("trNombreConcepto");
			switch (arguments[0]) {
				case 'S': 
				if (a) a.style.display = '';
				if (b) b.style.display = '';
				if (b1) b1.style.display = '';
				if (c) c.style.display = '';
				if (c1) c1.style.display = '';
				if (d) d.style.display = 'none';
				break;
				
				case 'T': 
				if (a) a.style.display = 'none';
				if (b) b.style.display = 'none';
				if (b1) b1.style.display = 'none';
				if (c) c.style.display = 'none';
				if (c1) c1.style.display = 'none';
				if (d) d.style.display = '';
				break;
				
				default: 
				if (a) a.style.display = 'none';
				if (b) b.style.display = 'none';
				if (b1) b1.style.display = 'none';
				if (c) c.style.display = 'none';
				if (c1) c1.style.display = 'none';
				if (d) d.style.display = 'none';
				objForm.longitud.required = false;
			}
			
			// Chequea el tipo
			if (arguments[0] == 'S') {
				if (arguments[1]) {
					var tipo = arguments[1];
				} else {
					var tipo = document.form1.tipo_dato.value;
				}
				switch (tipo) {
					case 'N': 
					if (b) b.style.display = '';
					if (b1) b1.style.display = '';
					if (c) c.style.display = '';
					if (c1) c1.style.display = '';
					objForm.longitud.required = true;
					break;
					
					case 'S': 
					if (b) b.style.display = '';
					if (b1) b1.style.display = 'none';
					if (c) c.style.display = 'none';
					if (c1) c1.style.display = 'none';
					objForm.longitud.required = true;
					break;
					
					default: 
					if (b) b.style.display = 'none';
					if (b1) b1.style.display = 'none';
					if (c) c.style.display = 'none';
					if (c1) c1.style.display = 'none';
					objForm.longitud.required = false;
				}
			}
		}
	}
	
	<cfoutput>
	function funcLista() {
		location.href = '#CurrentPage#?tab=0';
		return false;
	}
	
	<cfif modo EQ "CAMBIO">
		function funcBaja() {
			var msgVistas = "";
			<cfif cantVistas.cant GT 0>
				msgVistas = "Existen #cantVistas.cant# vistas creadas para este tipo de dato. ";
			</cfif>
			if (confirm(msgVistas+'Si elimina el tipo de dato tambien podria estar eliminando las vistas, la lista de valores asociada o la composicion asociada al tipo de dato. Esta seguro de que desea eliminar el tipo de dato?')) {
				objForm.nombre_tipo.required = false;
				objForm.longitud.required = false;
				return true;
			} else {
				return false;
			}
		}
		
		function funcNuevo() {
			location.href = '#CurrentPage#?tab=#Form.tab#';
			return false;
		}
	</cfif>
	</cfoutput>
</script>

<cfoutput>
	<form name="form1" method="post" action="DiccDato-sql-form1.cfm">
		<cfinclude template="DiccDato-hiddens.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td bgcolor="##ECE9D8" align="center" class="tituloIndicacion">
				<strong><cfif modo EQ "ALTA">Agregar<cfelse>Modificar</cfif> Tipo de Dato</strong>
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>
		<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td valign="top" width="50%">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td height="25" width="30%" align="right" nowrap class="fileLabel">Nombre:</td>
					<td height="25" width="70%">
						<input type="text" name="nombre_tipo" size="60" maxlength="100" value="<cfif modo EQ "CAMBIO">#HtmlEditFormat(rsTipoDato.nombre_tipo)#</cfif>">
					</td>
				  </tr>
				  <tr>
					<td height="25" align="right" nowrap class="fileLabel">Clase:</td>
					<td id="tdClase">
						<select name="clase_tipo" onChange="javascript: show(this.value);">
							<option value="S" <cfif modo EQ "CAMBIO" and rsTipoDato.clase_tipo EQ "S">selected</cfif>>Simple</option>
							<option value="L" <cfif modo EQ "CAMBIO" and rsTipoDato.clase_tipo EQ "L">selected</cfif>>Lista Valores</option>
							<option value="T" <cfif modo EQ "CAMBIO" and rsTipoDato.clase_tipo EQ "T">selected</cfif>>Concepto Interno</option>
							<option value="C" <cfif modo EQ "CAMBIO" and rsTipoDato.clase_tipo EQ "C">selected</cfif>>Complejo</option>
						</select>
					</td>
				  </tr>
				  <tr id="trTipo" style="display: none;">
					<td height="25" align="right" nowrap class="fileLabel">Tipo Dato Simple:</td>
					<td height="25">
						<select name="tipo_dato" onChange="javascript: show(this.form.clase_tipo.value, this.value);">
							<option value="F" <cfif modo EQ "CAMBIO" and rsTipoDato.tipo_dato EQ "F">selected</cfif>>Fecha</option>
							<option value="N" <cfif modo EQ "CAMBIO" and rsTipoDato.tipo_dato EQ "N">selected</cfif>>N&uacute;mero</option>
							<option value="B" <cfif modo EQ "CAMBIO" and rsTipoDato.tipo_dato EQ "B">selected</cfif>>S&iacute;/No</option>
							<option value="S" <cfif modo EQ "CAMBIO" and rsTipoDato.tipo_dato EQ "S">selected</cfif>>Alfanum&eacute;rico</option>
						</select>
					</td>
				  </tr>
				  <tr id="trLongitud" style="display: none;">
					<td height="25" align="right" nowrap class="fileLabel">Longitud:</td>
					<td height="25">
						<input name="longitud" id="longitud" type="text" size="8" maxlength="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ "CAMBIO" and Len(Trim(rsTipoDato.longitud))>#LSNumberFormat(rsTipoDato.longitud,'9')#</cfif>">
					</td>
				  </tr>
				  <tr id="trDecimales" style="display: none;">
					<td height="25" align="right" nowrap class="fileLabel">Decimales:</td>
					<td height="25">
						<input name="escala" id="escala" type="text" size="8" maxlength="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ "CAMBIO" and Len(Trim(rsTipoDato.escala))>#LSNumberFormat(rsTipoDato.escala,'9')#</cfif>">
					</td>
				  </tr>
				  <tr id="trMinimo" style="display: none;">
					<td height="25" align="right" nowrap class="fileLabel">M&iacute;nimo:</td>
					<td height="25">
						<input name="valor_minimo" id="valor_minimo" type="text" size="15" maxlength="10" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ "CAMBIO" and Len(Trim(rsTipoDato.valor_minimo))>#LSNumberFormat(rsTipoDato.valor_minimo,'9')#</cfif>">
					</td>
				  </tr>
				  <tr id="trMaximo" style="display: none;">
					<td height="25" align="right" nowrap class="fileLabel">M&aacute;ximo:</td>
					<td height="25">
						<input name="valor_maximo" id="valor_maximo" type="text" size="15" maxlength="10" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ "CAMBIO" and Len(Trim(rsTipoDato.valor_maximo))>#LSNumberFormat(rsTipoDato.valor_maximo,'9')#</cfif>">
					</td>
				  </tr>
				  <tr id="trNombreConcepto" style="display: none;">
					<td height="25" align="right" nowrap class="fileLabel">Concepto Interno:</td>
					<td height="25">
						<select name="nombre_tabla">
							<option value="TPFuncionario" <cfif modo EQ "CAMBIO" and rsTipoDato.nombre_tabla EQ "TPFuncionario">selected</cfif>>Funcionario</option>
							<option value="TPPersona" <cfif modo EQ "CAMBIO" and rsTipoDato.nombre_tabla EQ "TPPersona">selected</cfif>>Persona</option>
							<option value="TPInstitucion" <cfif modo EQ "CAMBIO" and rsTipoDato.nombre_tabla EQ "TPInstitucion">selected</cfif>>Institucion</option>
							<option value="TPSucursal" <cfif modo EQ "CAMBIO" and rsTipoDato.nombre_tabla EQ "TPSucursal">selected</cfif>>Sucursal</option>
						</select>
					</td>
				  </tr>
				  <tr>
				    <td colspan="2" nowrap>&nbsp;</td>
			      </tr>
				  <tr>
					<td height="25" align="center" colspan="2" nowrap>
						<cf_botones modo="#modo#" include="Lista">
					</td>
				  </tr>
            	</table>
			</td>
			<td valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td height="25" nowrap class="fileLabel">Descripci&oacute;n:</td>
			      </tr>
				  <tr>
					<td>
						<cfif modo EQ "CAMBIO">
							<cf_sifeditorhtml name="descripcion_tipo" value="#JSStringFormat(rsTipoDato.descripcion_tipo)#">
						<cfelse>
							<cf_sifeditorhtml name="descripcion_tipo">
						</cfif>
					</td>
				  </tr>
            	</table>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.nombre_tipo.description = "Nombre";
	objForm.nombre_tipo.required = true;
	objForm.longitud.description = "Longitud";

	show(document.form1.clase_tipo.value);
</script>
