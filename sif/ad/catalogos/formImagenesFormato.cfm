<!--- valida que siempre exista el codifo de encabezado, que por fuerza debe existir --->
<cfif not (isdefined("Form.FMT01COD") and len(trim(Form.FMT01COD)) GT 0)>
	<cflocation addtoken="no" url="EFormatosImpresion.cfm">
</cfif>

<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfquery name="rsFormato" datasource="#Session.DSN#">
	select FMT01DES from FMT001 where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
</cfquery>

<cfquery name="rsForm" datasource="#Session.DSN#">
	select a.FMT01COD, a.FMT03LIN, a.FMT03IMG, a.FMT03FIL, a.FMT03COL, a.FMT03ALT, a.FMT03ANC, a.FMT03BOR, a.FMT03CFN, a.FMT03CBR, FMT03EMP, a.ts_rversion 
	from FMT003 a, FMT001 b
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and b.FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
	  <cfif modo NEQ "ALTA">
	  and a.FMT03LIN = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.FMT03LIN#">
	  </cfif>
	  and a.FMT01COD = b.FMT01COD
</cfquery>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.4" type="text/javascript">
	var boton = "";
	function setBtn(button){
		boton = button.name;
	}
	
	function validar(form){
		var mensaje = "Se presentaron los siguientes errores:\n\n";
		var salir = false; 
		if ( boton != 'btnEliminar' && boton != 'btnNuevo' && boton != 'btnRegresar'){
			if (!salir && form.FMT03COL.value == ""){
				mensaje = mensaje + "La posición X es requerida.\n";
				salir = true;								
			}
			if (!salir && form.FMT03FIL.value == ""){
				mensaje = mensaje + "La posición Y es requerida.\n";
				salir = true;
			}
			if (!salir && form.FMT03ALT.value == ""){
				mensaje = mensaje + "La altura es requerida.\n";
				salir = true;
			}
			if (!salir && form.FMT03ANC.value == ""){
				mensaje = mensaje + "El ancho es requerido.\n";
				salir = true;
			}
			if (!salir && form.FMT03CFN.value == ""){
				mensaje = mensaje + "El color de Fondo es requerido.\n";
				salir = true;
			}
			if (!salir && form.FMT03CBR.value == ""){
				mensaje = mensaje + "El color de Borde es requerido.\n";				
				salir = true;
			}
			if (boton != 'btnCambiar' ) {
				if (!salir && form.FiletoUpload.value == ""){
					mensaje = mensaje + "La imagen es requerida.";				
					salir = true;				
				}
			}
			if (salir) alert(mensaje);			
			return !salir;			
		}
		return true;
	}

	function traercolor( obj, tabla, color ){
		if ( color != '' && color.length == 6 ){
			var tablita = document.getElementById(tabla);
			tablita.bgColor = "#" + color;
			eval('document.form1.'+obj).value = color
		}
	}

	function mostrarpaleta(obj, tabla){
	// RESULTADO
	// Muestra una paleta de colores.
		window.open("/cfmx/sif/ad/catalogos/color.cfm?obj="+obj+"&tabla="+tabla,"Paleta",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,height=60,width=308,left=375, top=250');
	}
	
	function Formato()	 {
		var f = document.form1;
		f.action='EFormatosImpresion.cfm';
		f.submit();
	}
</script>

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}

	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<form name="form1" action="SQLImagenesFormato.cfm" method="post" onSubmit="javascript: return validar(this);" enctype="multipart/form-data">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr><td>&nbsp;</td></tr>
  <tr>
    <td align="right">Formato:&nbsp;</td>

    <td valign="center"><cfoutput>#trim(Form.FMT01COD)# - #rsFormato.FMT01DES#
          <input type="hidden" name="FMT01COD" value="#Form.FMT01COD#">
		  <cfif modo NEQ "ALTA"><input type="hidden" name="FMT03LIN" value="#Form.FMT03LIN#"></cfif>
    </cfoutput></td>
	
    </tr>
  <tr>
    <td nowrap><div align="right">Posición X:&nbsp;</div></td>
    <td ><input type="text" name="FMT03FIL" maxlength="5" size="5" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT03FIL, 'none')#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Posici&oacute;n X" ></td>
  </tr>
  <tr>
    <td nowrap><div align="right">Posici&oacute;n Y:&nbsp;</div></td>
    <td ><input type="text" name="FMT03COL" maxlength="5" size="5" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT03COL, 'none')#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Posici&oacute;n Y" ></td>
  </tr>
  <tr>
    <td nowrap><div align="right">Alto:&nbsp;</div></td>
    <td ><input type="text" name="FMT03ALT" maxlength="5" size="5" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT03ALT, 'none')#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Altura" ></td>
  </tr>
  <tr>
    <td nowrap><div align="right">Ancho:&nbsp;</div></td>
    <td ><input type="text" name="FMT03ANC" maxlength="5" size="5" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT03ANC, 'none')#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Ancho" ></td>
  </tr>
  <tr>
    <td nowrap></td>
    <td width="9%" valign="middle" nowrap><input type="checkbox" name="FMT03BOR" value="checkbox" <cfif rsForm.FMT03BOR EQ "1">checked</cfif>>Usar borde</td>
  </tr>
  <tr>
    <td nowrap><div align="right">Color de Fondo:&nbsp;</div></td>
	<td valign="middle" >
		<table>
			<tr>
				<td valign="top"><input type="text" size="10" maxlength="6" name="FMT03CFN" value="<cfoutput><cfif modo neq 'ALTA'>#Trim(rsForm.FMT03CFN)#<cfelse>FFFFFF</cfif></cfoutput>" onblur="javascript:traercolor('FMT03CFN', 'colorBox2', this.value);" style="text-transform: uppercase;" onFocus="javascript:this.select();" alt="El Color Del Fondo"></td>
				<td valign="middle">
					<table id="colorBox2" width="18" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000" class="cuadro">
						<tr>
							<td align="center" valign="middle" style="color: #FFFFFF;cursor:hand;">
								<a href="javascript:mostrarpaleta('FMT03CFN','colorBox2')" style="text-decoration:none;">
									<font size="1">&nbsp;&nbsp;&nbsp;&nbsp;</font>
								</a>
							</td>
						</tr>
					</table> <!--- tabla color --->	
				</td>
			</tr>
		</table>
	</td>	
  </tr>

  <tr>
    <td nowrap><div align="right">Color de Borde:&nbsp;</div></td>
		
	<td valign="middle"> 
		<table>
			<tr>
				<td valign="top"><input type="text" size="10" maxlength="6" name="FMT03CBR" value="<cfoutput><cfif modo neq 'ALTA'>#Trim(rsForm.FMT03CBR)#<cfelse>000000</cfif></cfoutput>" onblur="javascript:traercolor('FMT03CBR', 'colorBox3', this.value);" style="text-transform: uppercase;" onFocus="javascript:this.select();" alt="El Color Del Borde"></td>
				<td valign="middle">
					<table id="colorBox3" width="18" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000" class="cuadro">
						<tr>
							<td align="center" valign="middle" style="color: #FFFFFF;cursor:hand;">
								<a href="javascript:mostrarpaleta('FMT03CBR','colorBox3')" style="text-decoration:none;">
									<font size="1">&nbsp;&nbsp;&nbsp;&nbsp;</font>
								</a>
							</td>
						</tr>
					</table> <!--- tabla color --->	
				</td>
			</tr>
		</table>
	</td>
  </tr>

  <tr align="center" nowrap>
	<td align="left" ><div align="right">Imagen:&nbsp;</div></td>
	  <td align="left" >
		  <input type="file" name="FiletoUpload" size="45">
	</td>
  </tr>
  
  <tr>
  	<td>&nbsp;</td>
	<td><input type="checkbox" name="FMT03EMP" value="checkbox" <cfif rsForm.FMT03EMP EQ "1">checked</cfif>>Logo de Empresa</td>
  </tr>

  <tr><td colspan="2">&nbsp;</td></tr>
  <tr>
    <td colspan="2" valign="top" nowrap><div align="center">
		<cfif modo NEQ "CAMBIO">
		  <input type="submit" name="btnAgregar" value="Agregar" onClick="javascript:setBtn(this);">														
		  <cfelse>
		  <input type="submit" name="btnCambiar" value="Modificar" onclick="javascript:setBtn(this);document.form1.FMT03LIN.value='#rsImagenes.FMT03LIN#';return true;"> 																							
		  <input type="submit" name="btnEliminar" value="Eliminar" onclick="javascript:setBtn(this);document.form1.FMT03LIN.value='#rsImagenes.FMT03LIN#';return confirm('¿Desea Eliminar la Imagen?');">							
		  <input type="submit" name="btnNuevo" value="Nuevo" onclick="javascript:setBtn(this);return true;"> 																							
		</cfif>
		<input type="submit" name="btnRegresar" value="Regresar" onclick="javascript:setBtn(this); return Formato();"> 																									  
	</div></td>
    </tr>
  <tr>
    <td colspan="2" valign="top" nowrap><div align="center">&nbsp;
	</div></td>
    </tr>

  <tr>
    <td colspan="2" valign="top" nowrap><div align="center">
		<cfif modo NEQ "ALTA">
			<cf_sifleerimagen autosize="true" border="false"  tabla="FMT003" campo="FMT03IMG" condicion="FMT01COD = '#Form.FMT01COD#' and FMT03LIN = #Form.FMT03LIN#" conexion="#Session.DSN#" imgname="Img#Form.FMT03LIN#" width="80" height="80">
		</cfif>							
	</div></td>
    </tr>
  <tr>
    <td colspan="2"><input type="hidden" name="FMT03LIN" value="">
    </td>
    </tr>
</table>
</form>
<script language="JavaScript1.2" >
	traercolor('FMT03CFN', 'colorBox2', document.form1.FMT03CFN.value);
	traercolor('FMT03CBR', 'colorBox3', document.form1.FMT03CBR.value);
</script>
