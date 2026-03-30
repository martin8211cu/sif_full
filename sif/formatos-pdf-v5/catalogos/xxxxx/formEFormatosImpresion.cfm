<!-- Establecimiento del modo -->
<cfif (isdefined("form.Cambio") and #Len(Trim(form.Cambio))# gt 0  ) or ( isdefined("form.FMT01COD") and #Len(Trim(form.FMT01COD))# gt 0 ) >
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
<cfquery name="rsForm" datasource="emperador">
	select FMT01COD, FMT01DES, FMT01TOT, FMT01LIN, FMT01DET, FMT01PDT, FMT01USR, convert(varchar,FMT01FEC, 103 ) as FMT01FEC,
		   FMT01LAR, FMT01ANC, FMT01ORI, FMT01LFT, FMT01RGT, FMT01TOP, FMT01BOT, FMT01SPC, FMT01CPS, FMT01SP1, FMT01SP2,
		   FMT01COP, FMT01TIP, FMT01ENT, FMT01PRV, FMT01REF, timestamp
	from FMT001
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
	<cfif isdefined("form.FMT01COD") and #Len(Trim(form.FMT01COD))# gt 0 >
		and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FMT01COD#">
	</cfif>	
</cfquery>

<!--- Tipos de Formato--->
<cfquery name="rsTiposFormato" datasource="emperador">
	select FMT00COD, FMT00DES 
	from FMT000
</cfquery>

<cfquery name="rsCodigos" datasource="emperador">
	select upper(FMT01COD) as FMT01COD
	from FMT001
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
</cfquery>

<!--- ===============================================================================================  	--->


<!--- ===============================================================================================  	--->
<!--- 												JS 											--->
<!--- ===============================================================================================  	--->
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
	
	function MM_validateForm() { //v4.0
	  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
	  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
		if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
		  if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
			if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una direccin de correo electrnica vlida.\n';
		  } else if (test!='R') { num = parseFloat(val);
			if (isNaN(val)) errors+='- '+nm+' debe ser numrico.\n';
			if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
			  min=test.substring(8,p); max=test.substring(p+1);
			  if (num<min || max<num) errors+='- '+nm+' debe ser un nmero entre '+min+' y '+max+'.\n';
		} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
	  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
	  document.MM_returnValue = (errors == '');
	}

	function validar(){
	
		switch ( boton ) {
		   case 'btnEliminar' :
				if ( confirm('Va a eliminar el Formato de Impresin y sus lneas de detalle. Desea continuar?') ){
					document.form1.FMT01COD.disabled = false;
					return true;
				}
			    break;
		   case 'btnAgregar' :
				MM_validateForm('FMT01COD','','R', 'FMT01DES','','R', 'FMT01TOT','','R', 'FMT01LIN','','R', 'FMT01DET','','R', 'FMT01PDT','','R', 'FMT01SPC','','R', 'FMT01TIP','','R', 'FMT01LAR','','R', 'FMT01ANC','','R', 'FMT01LFT','','R', 'FMT01TOP','','R', 'FMT01RGT','','R', 'FMT01BOT','','R', 'FMT01SP1','','R', 'FMT01SP2','','R');
				if (document.MM_returnValue){
					habilitar();
				}
				return document.MM_returnValue;
			    break;
	
		   case 'btnModificar' :
				MM_validateForm('FMT01COD','','R', 'FMT01DES','','R', 'FMT01TOT','','R', 'FMT01LIN','','R', 'FMT01DET','','R', 'FMT01PDT','','R', 'FMT01SPC','','R', 'FMT01TIP','','R', 'FMT01LAR','','R', 'FMT01ANC','','R', 'FMT01LFT','','R', 'FMT01TOP','','R', 'FMT01RGT','','R', 'FMT01BOT','','R', 'FMT01SP1','','R', 'FMT01SP2','','R');
				if (document.MM_returnValue){
					habilitar();
					document.form1.FMT01COD.disabled = false;
				}
				return document.MM_returnValue;
			    break;
		}
		
		return false;
	}
	
	function detalle(){
	// RESULTADO
	// Redirecciona, mediante submit hacia el mantenimiento de detalles
		document.form1.action = "DFormatosImpresion.cfm";
		document.form1.FMT01COD.disabled = false;
		document.form1.submit();
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
				alert("Cdigo de Formato ya existe.");
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
	
	function lineas(){
		var total = ( new Number(qf(document.form1.FMT01LIN.value)) ) + ( new Number(qf(document.form1.FMT01DET.value)) ) + ( new Number(qf(document.form1.FMT01PDT.value)) );
		document.form1.FMT01TOT.value = total;
		return total;
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

<form name="form1"  method="post" onSubmit="return validar();" action="SQLEFormatosImpresion.cfm" >
	<table width="100%" border="0" cellpadding="0" cellspacing="0" >
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td valign="top" colspan="2">
				<div align="center" class="tituloMantenimiento">
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
			<td>
				<!--- Tabla para campos de la derecha --->	
				<table width="100%">
					<!--- Codigo de Formato--->
					<tr>
						<td align="right" nowrap>C&oacute;digo del Formato:&nbsp;</td>
						<td><input type="text" size="10" maxlength="10" name="FMT01COD" <cfif modo neq 'ALTA'>disabled</cfif>  value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01COD#</cfoutput></cfif>" onBlur="javascript:valida_codigo( this.value )" onfocus="javascript:this.select();" alt="El Cdigo de Formato" ></td>
					</tr>
					
					<!--- Descripcion de Formato --->
					<tr> 
						<td align="right" nowrap>Descripcin:&nbsp;</td>
						<td><input type="text" name="FMT01DES" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01DES#</cfoutput></cfif>" size="30" maxlenght="50" onfocus="javascript:this.select();" alt="La Descripcin"></td>	
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
					
					<!--- Lineas del PostDetalle --->
					<tr>
						<td align="right" nowrap>L&iacute;neas en el PostDetalle:&nbsp;</td>
						<td><input type="text" name="FMT01PDT" size="10" maxlength="5" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01PDT#</cfoutput><cfelse>0</cfif>" style="text-align: right;" onBlur='fm(this,-1); lineas();' onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Las l&iacute;neas del PostDetalle" ></td>
					</tr>
					
					<tr>
						<td align="right" nowrap></td>
						<td nowrap>
							<input name="FMT01ENT" type="checkbox" value="chk" <cfif modo neq 'ALTA' and rsForm.FMT01ENT eq 1>checked</cfif>>&nbsp;Mantener retorno de l&iacute;nea
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
					<tr>
						<td align="center">
							<!--- tamao del papel, orientacion --->
							<table class="cuadro" align="center" width="100%">

								<tr bgcolor="#FAFAFA">
									<td colspan="3" align="center"><b>Tamao del Papel</b></td>
									<td colspan="3" align="center"><b>Orientaci&oacute;n</b></td>
								</tr>
								
								<tr>
									<!--- largo, vertical --->	
									<td align="right" nowrap>Largo:&nbsp;</td>
									<td nowrap> 
										<input type="text" maxlength="10" name="FMT01LAR" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT01LAR, 'none')#</cfoutput><cfelse>0.00</cfif>" size="10" style="text-align: right;" onblur="fm(this,2);" onfocus="this.value=qf(this); this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El largo del papel"   >
										&nbsp;
									</td>
									<td><img src="../../imagenes/Alto.gif" ></td>
				
									<td><input type="radio" name="FMT01ORI" value="1" <cfif modo neq 'ALTA'><cfif rsform.FMT01ORI eq '1'>checked</cfif><cfelse>checked</cfif> ></td>
									<td >Vertical</td>
									<td><img src="../../imagenes/Vertical.gif" ></td>
								</tr>
								
								<!--- ancho, horizontal--->
								<tr> 
									<td align="right" nowrap>Ancho:&nbsp;</td>
									<td nowrap> 
										<input type="text" maxlength="10" name="FMT01ANC" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT01ANC, 'none')#</cfoutput><cfelse>0.00</cfif>" size="10" style="text-align: right;" onblur="fm(this,2);" onfocus="this.value=qf(this); this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El ancho del papel"   >
									</td>
									<td><img src="../../imagenes/Ancho.gif" ></td>
									
									<td><input type="radio" name="FMT01ORI" value="0" <cfif modo neq 'ALTA' and rsform.FMT01ORI eq '0'>checked</cfif>></td>
									<td >Horizontal</td>
									<td><img src="../../imagenes/Horizontal.gif" ></td>
								</tr>
							</table>
						</td>	
					</tr>
					
					<!--- Margenes --->
					<tr>
						<td>
							<table width="100%" class="cuadro" >
								<tr bgcolor="#FAFAFA"><td align="center" colspan="4"><b>Mrgenes</b></td></tr>
								
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
					
					<!--- Procedimientos --->
					<tr>
						<td>
							<table width="100%" border="0" align="center" class="cuadro">
								<tr bgcolor="#FAFAFA"> 
									<td colspan="4" align="center"><b>Procedimientos Almacenados</b></td>
								</tr>
								<tr> 
									<td nowrap align="center">Datos de la Base de Datos</td>
									<td nowrap align="center">Nombre de los Campos</td>
								</tr>
								<tr> 
									<td align="center"><input type="text" name="FMT01SP1" size="35" maxlength="30" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01SP1#</cfoutput></cfif>" onFocus="javascript:this.select();" alt="El nombre del Procedimiento almacenado de datos"></td>
									<td align="center"><input type="text" name="FMT01SP2" size="35" maxlength="30" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT01SP2#</cfoutput></cfif>" onFocus="javascript:this.select();" alt="El nombre del Procedimiento almacenado de campos"></td>
								</tr>
							</table>
						
						</td>
					</tr>					
				</table>
			</td>
		</tr>
		
		<!--- Botones--->
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" valign="baseline" colspan="2">
				<link href="estilos.css" rel="stylesheet" type="text/css">
				<cfif modo EQ "ALTA">
							<input type="submit" name="btnAgregar" value="Agregar" onclick="javascript:setBtn( this );" >
				<cfelse>	
							<input type="submit" name="btnModificar" value="Modificar" onclick="javascript:setBtn( this );" >
							<input type="submit" name="btnEliminar"  value="Eliminar"  onclick="javascript:setBtn( this );">
							<input type="button" name="btnDetalle"   value="Detalle"   onClick="javascript:detalle();" >
							<input type="button" name="btnCopiar"    value="Copiar"    onClick="javascript:copiar();" >
							<input type="button" name="btnNuevo"     value="Nuevo"     onClick="javascript:nuevo();"    >
							<input type="button" name="btnLineas"    value="L&iacute;neas"     onClick="javascript:lineas2();" >
							<input type="button" name="btnImagen"    value="Im&aacute;genes"   onClick="javascript:imagenes();" >
				</cfif>
				<input type="reset" name="Limpiar" value="Limpiar" >
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
				<cfinvokeargument name="arTimeStamp" value="#rsForm.timestamp#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="timestamp" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
		<input type="hidden" name="FMT01USR"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.FMT01USR#</cfoutput><cfelse><cfoutput>#session.usuario#</cfoutput></cfif>">
		<input type="hidden" name="FMT01FEC"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.FMT01FEC#</cfoutput></cfif>">
		</td></tr>
	</table>

</form>
