<!-- Establecimiento del modo -->
<cfif (isdefined("form.Cambio") and Len(Trim(form.Cambio)) gt 0  ) or ( isdefined("form.FMT01COD") and Len(Trim(form.FMT01COD)) gt 0 ) >
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
<!--- ===============================================================================================  	--->
<!--- 												CONSULTAS 											--->
<!--- ===============================================================================================  	--->
<!--- Form--->
<cfquery name="rsForm" datasource="#session.DSN#">
	select a.FMT01COD, a.FMT01DES, a.FMT01TOT, a.FMT01LIN, a.FMT01DET, a.FMT01PDT, a.FMT01USR, a.FMT01FEC,
		   a.FMT01LAR, a.FMT01ANC, a.FMT01ORI, a.FMT01LFT, a.FMT01RGT, a.FMT01TOP, a.FMT01BOT, a.FMT01SPC,
		   a.FMT01CPS, b.FMT01SP1, b.FMT01SP2,
		   a.FMT01COP, a.FMT01TIP, a.FMT01ENT, a.FMT01PRV, a.FMT01REF, a.FMT01SQL, 
		   a.FMT01tipfmt, a.FMT01cfccfm, a.ts_rversion, a.Ecodigo,
		   <!---a.FMT01imgfpre,--->
		   (select FMT11NOM from FMT011 c where c.FMT00COD = a.FMT01TIP and FMT11CNT = 1) as FMT01CNT
	from FMT001 a
		left join FMT000 b
			on a.FMT01TIP = b.FMT00COD
	where (Ecodigo is null or Ecodigo = #session.Ecodigo#)
	<cfif isdefined("form.FMT01COD") and #Len(Trim(form.FMT01COD))# gt 0 >
		and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT01COD#">
	</cfif>	
</cfquery>

<!--- Tipos de Formato--->
<cfquery name="rsTiposFormato" datasource="#session.DSN#">
	select FMT00COD, FMT00DES 
	from FMT000
</cfquery>

<cfquery name="rsCodigos" datasource="#session.DSN#">
	select upper(FMT01COD) as FMT01COD
	from FMT001
	where (Ecodigo is null or Ecodigo = #session.Ecodigo#)
</cfquery>

<!--- ===============================================================================================  	--->
<!--- 												JS 											        --->
<!--- ===============================================================================================  	--->
<script  language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	function combo( phasta ){
	// RESULTADO:
	// Llena el combo de esapcio entre lineas del detalle
		var i = 0 
		var seleccion = 0;
		var valor = new Number(0);
		var hasta = new Number(phasta); 

		<cfif modo neq 'ALTA'>
			seleccion = new Number('<cfoutput>#rsForm.FMT01SPC#</cfoutput>')
		</cfif>
		
		document.form1.FMT01SPC.length = 0;
		while ( valor <= hasta ){
			document.form1.FMT01SPC.length = i+1;
			document.form1.FMT01SPC.options[i].value = valor;
			document.form1.FMT01SPC.options[i].text  = valor;

			if ( valor == seleccion ){
				document.form1.FMT01SPC.options[i].selected = true;
			}

			valor = valor + 0.5;
			i++;
		}
	}

	var boton = "";
	function setBtn(obj){
		boton = obj.name;
	}
	
	function habilitar(){
	// RESULTADO
	// Quita el formato numerico a los campos numericos

		document.form1.FMT01TOT.value = qf(document.form1.FMT01TOT.value);
		document.form1.FMT01LIN.value = qf(document.form1.FMT01LIN.value);
		document.form1.FMT01DET.value = qf(document.form1.FMT01DET.value);
		document.form1.FMT01PDT.value = qf(document.form1.FMT01PDT.value);
		document.form1.FMT01LAR.value = qf(document.form1.FMT01LAR.value);
		document.form1.FMT01ANC.value = qf(document.form1.FMT01ANC.value);
		document.form1.FMT01LFT.value = qf(document.form1.FMT01LFT.value);
		document.form1.FMT01TOP.value = qf(document.form1.FMT01TOP.value);
		document.form1.FMT01RGT.value = qf(document.form1.FMT01RGT.value);
		document.form1.FMT01BOT.value = qf(document.form1.FMT01BOT.value);
	}

	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}
	
	function MM_swapImage() { //v3.0
	  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
	
	function validar(){
		var error   = false;
		var mensaje = 'Se presentaron los siguientes errores:\n';
		
		if ( trim(document.form1.FMT01COD.value) == '' ){
			error = true;
			mensaje += ' - El campo Código de Formato es requerido.\n'
		}
		if ( trim(document.form1.FMT01DES.value) == '' ){
			error = true;
			mensaje += ' - El campo Descripción es requerido.\n'
		}
		if ( trim(document.form1.FMT01TOT.value) == '' ){
			error = true;
			mensaje += ' - El campo Líneas en el formato es requerido.\n'
		}
		if ( trim(document.form1.FMT01LIN.value) == '' ){
			error = true;
			mensaje += ' - El campo Líneas en el encabezado es requerido.\n'
		
		}
		if ( trim(document.form1.FMT01DET.value) == '' ){
			error = true;
			mensaje += ' - El campo Líneas en el detalle es requerido. \n'
		
		}
		if ( trim(document.form1.FMT01PDT.value) == '' ){
			error = true;
			mensaje += ' - El campo Líneas en el postdetalle es requerido. \n'
		
		}
		if ( trim(document.form1.FMT01SPC.value) == '' ){
			error = true;
			mensaje += ' - El campo Espacio entre líneas del detalle es requerido.\n'
		
		}
		if ( trim(document.form1.FMT01TIP.value) == '' ){
			error = true;
			mensaje += ' - El campo Tipo de formato.\n'
		
		}
		if ( trim(document.form1.FMT01LAR.value) == '' ){
			error = true;
			mensaje += ' - El campo Alto es requerido.\n'
		
		}
		if ( trim(document.form1.FMT01ANC.value) == '' ){
			error = true;
			mensaje += ' - El campo Ancho es requerido.\n'
		
		}
		if ( trim(document.form1.FMT01LFT.value) == '' ){
			error = true;
			mensaje += ' - El campo Margen izquierdo es requerido.\n'
		
		}
		if ( trim(document.form1.FMT01TOP.value) == '' ){
			error = true;
			mensaje += ' - El campo Margen superior es requerido.\n'
		
		}
		if ( trim(document.form1.FMT01RGT.value) == '' ){
			error = true;
			mensaje += ' - El campo Margen derecho es requerido.\n'
		
		}
		if ( trim(document.form1.FMT01BOT.value) == '' ){
			error = true;
			mensaje += ' - El campo Margen inferior es requerido.\n'
		}
		
		if ( document.form1.FMT01tipfmt.checked ){
			if ( trim(document.form1.FMT01cfccfm.value) == '' ){
				error = true;
				mensaje += ' - El campo Archivo es requerido.\n'
			}
		}
		
		if ( error ){
			alert(mensaje);
			return false;
		}
		
		document.form1.FMT01COD.disabled = false;
		return true;
		
	}
	
	function detalle(){
	// RESULTADO
		location.href='formatos/editor.cfm?FMT01COD='+escape(document.form1.FMT01COD.value);
	}
	
	function lineas2(){
	// RESULTADO
	// Redirecciona, mediante submit hacia el mantenimiento de detalles
		document.form1.action = "FMTLineas.cfm";
		document.form1.FMT01COD.disabled = false;
		document.form1.submit();
	}

	function imagenes(){
	// RESULTADO
	// Redirecciona, mediante submit hacia el mantenimiento de detalles
		document.form1.action = "ImagenesFormato.cfm";
		document.form1.FMT01COD.disabled = false;
		document.form1.submit();
	}

	function niveles(){}
	
	function valida_codigo( codigo ){
		codigo = codigo.toUpperCase();
		var valor = ""
		<cfoutput query="rsCodigos">
			valor = '#Trim(rsCodigos.FMT01COD)#';
			if ( valor == codigo ){
				alert("Código de Formato ya existe.");
				document.form1.FMT01COD.value = "";
				document.form1.FMT01COD.focus();
			}
		</cfoutput>
	}
	
	function nuevo(){
		document.form1.action = "EFormatosImpresion.cfm";
		document.form1.submit();
	}
	
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function copiar(){
		popUpWindow("CopiarFormatos.cfm?form=form1&FMT01COD="+document.form1.FMT01COD.value,250,200,500,150);
	}

	function compilar(){
		popUpWindow("compilar.cfm?FMT01COD="+document.form1.FMT01COD.value,300,300,600,200);
	}

	function exportar(dbms){
		location.href="formatos/exportar.cfm?FMT01COD="+document.form1.FMT01COD.value+"&dbms="+dbms;
	}

	function lineas(){
		var total = ( new Number(qf(document.form1.FMT01LIN.value)) ) + ( new Number(qf(document.form1.FMT01DET.value)) ) + ( new Number(qf(document.form1.FMT01PDT.value)) );
		document.form1.FMT01TOT.value = total;
		return total;
	}
	
	function parametros(){
	// RESULTADO
	// Redirecciona, mediante submit hacia el mantenimiento de detalles
		document.form1.action = "FMTParametros.cfm";
		document.form1.FMT01COD.disabled = false;
		document.form1.submit();
	}
	
	function pagina(obj){
		obj.value = obj.value.
				replace(/\\/g, '/').
				replace(/^https?:\/\/([A-Za-z0-9._]+)(:[0-9]{1,5})?/,'').
				replace(/^\/cfmx/, '').
				replace(/^[A-Za-z]:/,'');
		if (trim(obj.value) != '' && obj.value.charAt(0) != '/') {
			obj.value = "/" + obj.value;
		}
	}

	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}

	function conlisFilesSelect(filename){
		document.form1.FMT01cfccfm.value = filename;
		closePopup();
		window.focus();
		document.form1.FMT01cfccfm.focus();
	}

	function conlisFiles(){
		closePopup();
		window.gPopupWindow = window.open('/cfmx/sif/Utiles/files.cfm?p='+escape(document.form1.FMT01cfccfm.value),'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}
	function sbFormularioPreimpresoHelp(){
		closePopup();
		window.gPopupWindow = window.open('formularioPreimpresoHelp.htm','_blank',
			'left=50,top=50,width=500,height=600,status=no,toolbar=no,title=no,scrollbars=yes');
		window.onfocus = closePopup;
	}
</script>	

<!--- ===============================================================================================  	--->
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

<form name="form1"  method="post" onSubmit="return validar();" action="SQLEFormatosImpresion.cfm" enctype="multipart/form-data">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" >
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td valign="top" colspan="2">
				<div align="center" class="subTitulo">
					<font size="3">
						<strong>
							<cfoutput>
							<cfif modo eq "CAMBIO">
								#Request.Translate('BotonCambiar','Modificar', '/sif/Utiles/Generales.xml')#
							<cfelse>
								#Request.Translate('BotonAgregar','Agregar', '/sif/Utiles/Generales.xml')#
							</cfif> 
								#Request.Translate('TituloPortlet','Encabezado de Formato de Impresion')#
							</cfoutput>
						</strong>
					</font>
				</div>	
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>

		<tr >
			<td valign="top">
				<!--- Tabla para campos de la derecha --->	
				<table width="100%">
					<!--- Codigo de Formato--->
					<tr>
					  <td align="right" nowrap>&nbsp;</td>
					  <td><input name="esglobal" id="esglobal" type="checkbox" value="1" <cfif modo neq 'ALTA' and Len(rsForm.Ecodigo) is 0>checked</cfif>>
				      <label for="esglobal">Es com&uacute;n a todas las empresas </label></td>
				  </tr>
					<tr>
						<td align="right" nowrap>C&oacute;digo del Formato:&nbsp;</td>
						<td><input type="text" size="10" maxlength="10" name="FMT01COD" <cfif modo neq 'ALTA'>disabled</cfif>  value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01COD#</cfoutput></cfif>" onBlur="javascript:valida_codigo( this.value )" onfocus="javascript:this.select();" alt="El Código de Formato" ></td>
					</tr>
					
					<!--- Descripcion de Formato --->
					<tr> 
						<td align="right" nowrap>Descripción:&nbsp;</td>
						<td><input type="text" name="FMT01DES" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01DES#</cfoutput></cfif>" size="30" maxlenght="50" onfocus="javascript:this.select();" alt="La Descripción"></td>	
					</tr>
					
					<!--- Tipo de Formato --->
					<tr>
						<td align="right" nowrap>Tipo de Formato:&nbsp;</td>
						<td>
							<select name="FMT01TIP">
								<cfoutput query="rsTiposFormato">
									<cfif modo EQ 'ALTA'>
										<option value="#rsTiposFormato.FMT00COD#">#rsTiposFormato.FMT00DES#</option>
									<cfelseif modo NEQ 'ALTA'>
										<option value="#rsTiposFormato.FMT00COD#" <cfif rsForm.FMT01TIP EQ rsTiposFormato.FMT00COD>selected</cfif>  >#rsTiposFormato.FMT00DES#</option>
									</cfif>
								</cfoutput>						
							</select>
						</td>
					</tr>
					
					<!--- Lineas del formato --->
					<tr> 
						<td align="right" nowrap>L&iacute;neas en el Formato:&nbsp;</td>
						<td> 
							<input type="text" name="FMT01TOT" size="10" readonly maxlength="5" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01TOT#</cfoutput><cfelse>0</cfif>" style="text-align: right;" onblur="fm(this,0);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Las l&iacute;neas del Formato" >
						</td>
					</tr>

					<!--- Lineas del Encabezado --->
					<tr> 
						<td align="right" nowrap>L&iacute;neas en el Encabezado:&nbsp;</td>
						<td> 
							<input type="text" name="FMT01LIN" size="10" maxlength="5" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01LIN#</cfoutput><cfelse>0</cfif>" style="text-align: right;" onblur="fm(this,0); lineas();" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Las l&iacute;neas del Encabezado" >
						</td>
					</tr>
					
					<!--- Lineas del Detalle --->
					<tr>
						<td align="right" nowrap>L&iacute;neas en el Detalle:&nbsp;</td>
						<td><input type="text" name="FMT01DET" size="10" maxlength="5" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01DET#</cfoutput><cfelse>0</cfif>" style="text-align: right;" onblur='fm(this,-1); lineas();' onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Las l&iacute;neas del Detalle" ></td>
					</tr>
					
					<!--- Lineas del PostDetalle --->
					<tr>
						<td align="right" nowrap>L&iacute;neas en el PostDetalle:&nbsp;</td>
						<td><input type="text" name="FMT01PDT" size="10" maxlength="5" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01PDT#</cfoutput><cfelse>0</cfif>" style="text-align: right;" onBlur='fm(this,-1); lineas();' onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Las l&iacute;neas del PostDetalle" ></td>
					</tr>

					<!--- Espacios entre lineas del detalle--->
					<tr>
						<td align="right" nowrap>Espacio entre l&iacute;neas del Detalle:&nbsp;</td>
						<td>
							<select name="FMT01SPC" >
							</select>cm
						</td>
						<script language="JavaScript1.2" type="text/javascript">
							combo(5);
						</script>
					</tr>
					
					<tr>
						<td align="right" nowrap></td>
						<td nowrap>
							<input name="FMT01ENT" id="FMT01ENT" type="checkbox" value="chk" <cfif modo neq 'ALTA' and rsForm.FMT01ENT eq 1>checked</cfif>>&nbsp;<label for="FMT01ENT">Mantener retorno de l&iacute;nea</label>
						</td>
					</tr>
					
					<tr>
						<td nowrap align="right">Referencia:&nbsp;</td>
						<td><input type="text" size="10" maxlength="10" name="FMT01REF" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01REF#</cfoutput></cfif>" onfocus="javascript: this.select();" ></td>
					</tr>

				</table>
			</td>	

			<!--- Columna 2--->
			<td valign="top">
				<table width="100%" border="0">
					<!--- Formato estatico --->
					<tr>
						<td>
							<table width="100%" class="cuadro">
								<tr bgcolor="#FAFAFA">
									<td align="center" colspan="7"><b>Tipo de Formato</b></td></tr>
								<tr>
									<td width="1%" colspan="3" nowrap>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tipo:&nbsp;&nbsp;<select name="FMT01tipfmt" 
												onChange="
													document.getElementById('tdArchivo').style.display='none';
													document.getElementById('tdControl').style.display='none';
													if (this.value == '0' || this.value == '1' || this.value == '4') document.getElementById('tdArchivo').style.display='';
													else if (this.value == '2' || this.value == '3') document.getElementById('tdControl').style.display='';
												"
										>
											<option value="0" <cfif modo neq 'ALTA' and rsForm.FMT01tipfmt eq 0>selected</cfif>>Jasper</option>
											<option value="1" <cfif modo neq 'ALTA' and rsForm.FMT01tipfmt eq 1>selected</cfif>>Estático (Archivo.cfm)</option>
											<option value="2" <cfif modo neq 'ALTA' and rsForm.FMT01tipfmt eq 2>selected</cfif>>ActiveX soinPrintDocs.ocx</option>
											<option value="3" <cfif modo neq 'ALTA' and rsForm.FMT01tipfmt eq 3>selected</cfif>>Formato Carta</option>
											<option value="4" <cfif modo neq 'ALTA' and rsForm.FMT01tipfmt eq 4>selected</cfif>>ColdFusion (Archivo.cfr)</option>
										</select>&nbsp;
									</td>
									<td width="10%" height="25px">&nbsp;
										
									</td>
								</tr>
								
								<tr>
									<td width="90%" height="25px" id="tdArchivo"  <cfif modo eq 'CAMBIO' and (rsForm.FMT01tipfmt neq 0 AND rsForm.FMT01tipfmt neq 1 AND rsForm.FMT01tipfmt neq 4)>style="display:none;"</cfif>>
										Archivo:&nbsp;
										<input type="text" name="FMT01cfccfm" size="50" maxlength="255" onBlur="javascript:pagina(this);" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01cfccfm#</cfoutput></cfif>">&nbsp;<a href="javascript:conlisFiles()" ><img width="16" height="16" src="../../imagenes/foldericon.png" border="0">&nbsp;
									</td>

									<cfif rsForm.FMT01CNT EQ "">
										<cfset rsForm.FMT01CNT = "<font color='##FF0000'>UN DOCUMENTO POR REGISTRO SIN DETALLES (Tipos de Formatos)</font>">
									<cfelse>
										<cfset rsForm.FMT01CNT = "<font color='##0000FF'>UN DOCUMENTO POR '#rsForm.FMT01CNT#' CON DETALLES	</font>">
									</cfif>
									<td colspan="5" width="90%" height="25px" id="tdControl" <cfif modo eq 'ALTA' or (rsForm.FMT01tipfmt neq 2 and rsForm.FMT01tipfmt neq 3)>style="display:none;"</cfif>>
										Campo Control:&nbsp;
										<strong><cfoutput>#rsForm.FMT01CNT#</cfoutput></strong>
									</td>
								</tr>
								
							</table>
						</td>
					</tr>
					<tr>
						<td align="center">
							<!--- tamaño del papel, orientacion --->
							<table class="cuadro" align="center" width="100%">

								<tr bgcolor="#FAFAFA">
									<td colspan="3" align="center"><b>Tamaño del Papel</b></td>
									<td colspan="3" align="center"><b>Orientaci&oacute;n</b></td>
								</tr>
								
								<tr>
									<!--- alto, vertical --->	
									<td align="right" nowrap>Alto:&nbsp;</td>
									<td nowrap> 
										<input type="text" maxlength="10" name="FMT01LAR" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT01LAR, 'none')#</cfoutput><cfelse>0.00</cfif>" size="10" style="text-align: right;" onblur="fm(this,2);" onfocus="this.value=qf(this); this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El alto del papel"   >
										&nbsp;
									</td>
									<td><img src="../../imagenes/Alto.gif" ></td>
				
									<td><input type="radio" id="FMT01ORI_1" name="FMT01ORI" value="1" <cfif modo neq 'ALTA'><cfif rsform.FMT01ORI eq '1'>checked</cfif><cfelse>checked</cfif> ></td>
									<td ><label for="FMT01ORI_1">Vertical</label></td>
									<td><label for="FMT01ORI_1"><img src="../../imagenes/Vertical.gif" border="0" ></label></td>
								</tr>
								
								<!--- ancho, horizontal--->
								<tr> 
									<td align="right" nowrap>Ancho:&nbsp;</td>
									<td nowrap> 
										<input type="text" maxlength="10" name="FMT01ANC" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT01ANC, 'none')#</cfoutput><cfelse>0.00</cfif>" size="10" style="text-align: right;" onblur="fm(this,2);" onfocus="this.value=qf(this); this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El ancho del papel"   >
									</td>
									<td><img src="../../imagenes/Ancho.gif" ></td>
									
									<td><input type="radio" id="FMT01ORI_0" name="FMT01ORI" value="0" <cfif modo neq 'ALTA' and rsform.FMT01ORI eq '0'>checked</cfif>></td>
									<td ><label for="FMT01ORI_0">Horizontal</label></td>
									<td><label for="FMT01ORI_0"><img src="../../imagenes/Horizontal.gif" border="0" ></label></td>
								</tr>
							</table>
						</td>	
					</tr>
					
					<!--- Margenes --->
					<tr>
						<td>
							<table width="100%" class="cuadro" >
								<tr bgcolor="#FAFAFA"><td align="center" colspan="4"><b>Márgenes</b></td></tr>
								
								<tr> 
									<td align="right" nowrap>Margen Izquierdo:&nbsp;</td>
									<td> 
										<input type="text" maxlength="10" name="FMT01LFT" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT01LFT, 'none')#</cfoutput><cfelse>0.00</cfif>" size="10" style="text-align: right;" onblur="fm(this,2);" onfocus="this.value=qf(this); this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Margen Izquierdo" >
									</td>
									<td align="right" nowrap>Margen Superior:&nbsp;</td>
									<td> 
										<input type="text" maxlength="10" name="FMT01TOP" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT01TOP, 'none')#</cfoutput><cfelse>0.00</cfif>" size="10" style="text-align: right;" onblur="fm(this,2);" onfocus="this.value=qf(this); this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Margen Superior" >
									</td>
								</tr>
								
								<tr> 
									<td align="right" nowrap>Margen Derecho:&nbsp;</td>
									<td> 
										<input type="text" maxlength="10" name="FMT01RGT" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT01RGT, 'none')#</cfoutput><cfelse>0.00</cfif>" size="10" style="text-align: right;" onblur="fm(this,2);" onfocus="this.value=qf(this); this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Margen Derecho" >
									</td>
									<td align="right" nowrap>Margen Inferior:&nbsp;</td>
									<td> 
										<input type="text" maxlength="10" name="FMT01BOT" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT01BOT, 'none')#</cfoutput><cfelse>0.00</cfif>" size="10" style="text-align: right;" onblur="fm(this,2);" onfocus="this.value=qf(this); this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Margen Inferior" >
									</td>
								</tr>
							</table>	
						</td>
					</tr>
					
					<!--- Imagen de Formulario Preimpreso --->
					<cfoutput>
					<tr>
						<td>
							<table width="100%" class="cuadro" >
								<tr bgcolor="##FAFAFA">
									<td align="center" colspan="4">
										<b>Formulario Preimpreso</b>
										<a href="javascript:sbFormularioPreimpresoHelp()" ><img width="18" height="18" src="../../imagenes/info.gif" border="0"></a>
									</td>
								</tr>
								<tr>
									<td width="1%" align="right">Imagen.jpg:&nbsp;</td>
									<td width="1%"><input type="file" name="FMT01imgfpre" size="50" maxlength="255" onBlur="javascript:pagina(this);" value="<cfif modo neq 'ALTA'>#rsForm.FMT01cfccfm#</cfif>"></td>
									<td>
									Formato=jpg<BR>Resolucion=28&nbsp;pix/cm<BR>
											<cfif modo eq 'ALTA'>
												Alto X Ancho
											<cfelseif rsForm.FMT01ORI EQ "1">
												Alto=#rsForm.FMT01LAR#&nbsp;cm<BR>Ancho=#rsForm.FMT01ANC#&nbsp;cm
											<cfelse>
												Alto=#rsForm.FMT01ANC#&nbsp;cm<BR>Ancho=#rsForm.FMT01LAR#&nbsp;cm
											</cfif>
									</td>
									<td width="50">
									<cfif modo neq 'ALTA' AND rsForm.FMT01LAR NEQ 0 AND rsForm.FMT01ANC NEQ 0>
										<img 
											<cfif rsForm.FMT01ORI EQ "1">
												<cfif rsForm.FMT01LAR GT rsForm.FMT01ANC>
													height="50" 
													width="#50/rsForm.FMT01LAR*rsForm.FMT01ANC#" 
												<cfelse>
													height="#50/rsForm.FMT01ANC*rsForm.FMT01LAR#"
													width="50" 
												</cfif>
											<cfelse>
												<cfif rsForm.FMT01LAR LT rsForm.FMT01ANC>
													height="50" 
													width="#50/rsForm.FMT01ANC*rsForm.FMT01LAR#"
												<cfelse>
													height="#50/rsForm.FMT01LAR*rsForm.FMT01ANC#" 
													width="50" 
												</cfif>
											</cfif>
										src="formatos/flash-FMT01imgfpre.cfm?FMT01COD=#rsForm.FMT01COD#">
									</cfif>
									</td>
								</tr>
							</table>
						</td>
					</tr>

					</cfoutput>
				</table>
			</td>
		</tr>
		
		<!--- Botones--->
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" valign="baseline" colspan="2">
				<cfif modo EQ "ALTA">
					<input type="submit" name="btnAgregar"  	class="btnGuardar" value="Agregar" onclick="javascript:setBtn( this );" >
				<cfelse>	
					<input type="submit" name="btnModificar" 	class="btnGuardar"  value="Modificar" 		 	onclick="javascript:setBtn( this );" >
					<input type="submit" name="btnEliminar" 	class="btnEliminar" value="Eliminar"     	 	onclick="javascript:setBtn( this );">
					<input type="button" name="btnDetalle"   	class="btnNormal"   value="Diseño"          	onClick="javascript:detalle();" >
					<input type="button" name="btnLineas"    	class="btnNormal"   value="L&iacute;neas"   	onClick="javascript:lineas2();" >
					<input type="button" name="btnImagen"    	class="btnNormal"   value="Im&aacute;genes" 	onClick="javascript:imagenes();" >
					<input type="button" name="btnCopiar"    	class="btnNormal"   value="Copiar"          	onClick="javascript:copiar();" >
					<input type="button" name="btnCompilar"  	class="btnNormal"	value="Compilar" 		 	onClick="compilar();">
					<input type="button" name="btnExportarSYB"  class="btnNormal" 	value="Exportar (sybase)" 	onClick="exportar('syb');">
					<input type="button" name="btnExportarORA"  class="btnNormal" 	value="Exportar (oracle)" 	onClick="exportar('ora');">
					<input type="button" name="btnExportarDB2"  class="btnNormal" 	value="Exportar (db2)" 		onClick="exportar('db2');">
					<input type="button" name="btnNuevo"     	class="btnNuevo" 	value="Nuevo"     			onClick="javascript:nuevo();"    >
				</cfif>
					<input type="reset"  class="btnLimpiar" name="Limpiar" value="Limpiar" >
					<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">				
		</tr>
		
		<!--- Ocultos--->
		<tr><td></td></tr>
		<tr><td>
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
		<input type="hidden" name="FMT01USR"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.FMT01USR#</cfoutput><cfelse><cfoutput>#session.usuario#</cfoutput></cfif>">
		<input type="hidden" name="FMT01FEC"  value="<cfif modo NEQ 'ALTA'><cfoutput>#DateFormat(rsForm.FMT01FEC,'dd/mm/yyyy')#</cfoutput></cfif>">
		</td></tr>
	</table>
</form>