<!--- valida que siempre exista el codifo de encabezado, que por fuerza debe existir --->
<cfif isdefined("form.FMT01COD") and Len(Trim("form.FMT01COD")) eq 0 >
	<cflocation addtoken="no" url="listaFormatos.cfm">
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

<!--- ===============================================================================================  	--->
<!--- 												FUNCIONES 											--->
<!--- ===============================================================================================  	--->
<cffunction name="codigo" returntype="string">
	<cfargument name="posic" type="string" required="true" default="">
	<cfargument name="campo" type="string" required="true" default="">
	<cfset blancos = 4 - Len(posic)>
	<cfset blanco = trim(posic) >
	<cfset blanco2 = "" >
	<cfset value = blanco & ' - ' & trim(campo) >
	<cfreturn #value# >
</cffunction>
<!--- ===============================================================================================  	--->

<!--- ===============================================================================================  	--->
<!--- 												CONSULTAS 											--->
<!--- ===============================================================================================  	--->

<!--- Form--->
<cfquery name="rsForm" datasource="#session.DSN#">
	select FMT02LIN, FMT02CAM, FMT02DES, FMT07NIV, FMT02TOT, FMT02STS, FMT02FMT, FMT02LON, FMT02DEC, 
		   FMT02TPL, FMT02BOL, FMT02TAM, FMT02UND, FMT02CLR, FMT02ITA, FMT02POS, FMT02FIL, FMT02COL,
		   FMT02JUS, FMT02PRE, FMT02SUF, FMT02TIP, FMT02PAG, FMT02SQL, FMT02AJU, ts_rversion 
	from FMT002
	<cfif isdefined("form.FMT01COD") and #Len(Trim("form.FMT01COD"))# gt 0 and isdefined("form.FMT02LIN") and #Len(Trim("form.FMT02LIN"))# gt 0>
		where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01COD#">
		  and FMT02LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT02LIN#">
	</cfif>	
</cfquery>

<!--- Niveles --->
<cfquery name="rsNiveles" datasource="#session.DSN#">
	select FMT07NIV
	from FMT007
	where Ecodigo  =  #session.Ecodigo# 
	  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_char"    value="#form.FMT01COD#">
</cfquery>

<!--- Linea --->
<cfquery name="rsLinea" datasource="#session.DSN#">
	select coalesce(max(FMT02LIN)+1,1) as FMT02LIN
	from FMT002 a, FMT001 b
	where a.FMT01COD=b.FMT01COD
	  and a.FMT01COD=<cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01COD#">
 	  and b.Ecodigo= #session.Ecodigo# 
</cfquery>

<!--- ejecucion del sp de campos --->
<cfset error = false>
<cftry>
	<cfquery name="rsCampos" datasource="#session.DSN#">
		declare @sp varchar(30)
		select @sp = rtrim(ltrim(FMT01SP2))
		from FMT001
		where Ecodigo  =  #session.Ecodigo# 
		  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_char"    value="#form.FMT01COD#">
	
		exec @sp
	</cfquery>
<cfcatch type="any">
	<cfset error = true >
</cfcatch>
</cftry>
<!--- ===============================================================================================  	--->
<!--- 												JS 											        --->
<!--- ===============================================================================================  	--->
<script language="JavaScript1.2" type="text/javascript">

	var boton = "";
	function setBtn(obj){
		boton = obj.name;
	}

	function traercolor( obj, tabla, color ){
		if ( color != '' && color.length == 6 ){
			var tablita = document.getElementById("colorBox");
			tablita.bgColor = "#" + color;
			document.form1.FMT02CLR.value = color;
		}
	}

	function mostrarpaleta(){
	// RESULTADO
	// Muestra una paleta de colores.
		window.open("/cfmx/sif/ad/catalogos/color.cfm?obj=FMT02CLR&tabla=colorBox","Paleta",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,height=60,width=308,left=375, top=250');
	}
	
	function descripcion( value ){
	// RESULTADO
	// Pone la descripcion, segun el campo seleccionado
	
		// recupera la descripcion
		var i = value.indexOf("-", 0);
		
		// recupera el numero
		var num = trim(value.substring(0, i));
		document.form1.FMT02SQL.value = trim(value.substring(0, i));

		if ( trim(value.substring(0, i)) != '0' ){
			document.form1.FMT02DES.value = value.substring(i+2, value.length);
		}
	}
	
	function habilitar(){
	// RESULTADO
	// Quita el formato numerico a los campos numericos

		document.form1.FMT02LON.value = qf(document.form1.FMT02LON.value);
		document.form1.FMT02DEC.value = qf(document.form1.FMT02DEC.value);
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
			if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
		  } else if (test!='R') { num = parseFloat(val);
			if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
			if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
			  min=test.substring(8,p); max=test.substring(p+1);
			  if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
		} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
	  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
	  document.MM_returnValue = (errors == '');
	}

	function validar(){
		switch ( boton ) {
		   case 'btnEliminar' :
				if ( confirm('Va a eliminar esta L&iacute;nea . Desea continuar?') ){
					document.form1.FMT01COD.disabled = false;
					document.form1.FMT02LIN.disabled = false;
					return true;
				}
			    break;
		   case 'btnAgregar' :
				MM_validateForm('FMT01COD','','R', 'FMT01LIN','','R', 'FMT02CAM','','R', 'FMT02DES','','R', 'FMT01NIV','','R', 'FMT02FMT','','R', 'FMT02LON','','R', 'FMT02DEC','','R', 'FMT02TPL','','R', 'FMT02TAM','','R', 'FMT02CLR','','R', 'FMT02POS','','R', 'FMT02FIL','','R', 'FMT02COL','','R', 'FMT02JUS','','R', 'FMT02TIP','','R');
				if (document.MM_returnValue){
					habilitar();
					document.form1.FMT01COD.disabled = false;
					document.form1.FMT02LIN.disabled = false;
				}
				return document.MM_returnValue;
			    break;
	
		   case 'btnModificar' :
				MM_validateForm('FMT01COD','','R', 'FMT01LIN','','R', 'FMT02CAM','','R', 'FMT02DES','','R', 'FMT01NIV','','R', 'FMT02FMT','','R', 'FMT02LON','','R', 'FMT02DEC','','R', 'FMT02TPL','','R', 'FMT02TAM','','R', 'FMT02CLR','','R', 'FMT02POS','','R', 'FMT02FIL','','R', 'FMT02COL','','R', 'FMT02JUS','','R', 'FMT02TIP','','R');
				if (document.MM_returnValue){
					habilitar();
					document.form1.FMT01COD.disabled = false;
					document.form1.FMT02LIN.disabled = false;
				}
				return document.MM_returnValue;
			    break;
		}
		
		return false;
	}

	function nuevo(){
		document.form1.FMT01COD.disabled = false;
		document.form1.FMT02LIN.value    = "";
		document.form1.action            = "DFormatosImpresion.cfm";
		document.form1.submit();
	}
	
	function regresar(){
		document.form1.FMT01COD.disabled = false;
		document.form1.FMT01COD.value    = '<cfoutput>#form.FMT01COD#</cfoutput>';
		document.form1.FMT02LIN.value    = "";
		document.form1.action            = "EFormatosImpresion.cfm";
		document.form1.submit();
	}

</script>
<!--- =============================================================================================== --->

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

<form name="form1" method="post" onSubmit="return validar();" action="SQLDFormatosImpresion.cfm" >
	<table width="100%" border="0" cellpadding="0" cellspacing="0">

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
								#Request.Translate('TituloPortlet','Detalle de Formato de Impresion')#
							</cfoutput>
						</strong>
					</font>
				</div>	
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>

		<!--- Columna 1--->
		<tr>
			<td>
				<!--- tabla principal columna1--->
				<table width="100%">
					<!--- Formato de Impresion --->
					<tr>
						<td align="right" nowrap>Formato:&nbsp;</td>
						<td>
							<input type="text" name="FMT01COD" size="12" disabled value="<cfoutput>#form.FMT01COD#</cfoutput>">
							<input name="FMT02STS" type="checkbox" value="chk" <cfif modo neq 'ALTA' and rsForm.FMT02STS eq 1>checked</cfif>>&nbsp;Desactivar Campo
						</td>
					</tr>
	
					<!--- Linea --->
					<tr>
						<td align="right" nowrap>L&iacute;nea:&nbsp;</td>				
						<td><input type="text" name="FMT02LIN" size="12" disabled value="<cfoutput><cfif modo neq 'ALTA' >#form.FMT02LIN#<cfelse>#rsLinea.FMT02LIN#</cfif></cfoutput>" style="text-align: right;" ></td>
					</tr>
	
					<!--- Campo --->
					<tr>
						<td align="right" nowrap>Campo:&nbsp;</td>
						<td nowrap>
							<select name="FMT02CAM" onChange="descripcion(this.value);">
								<option value="0 - Ninguno">0 - Ninguno</option>
								<cfif not error >
									<cfoutput query="rsCampos">
										<cfset valor = #trim(codigo(rsCampos.posic, rsCampos.Campo))# >
										<option value="#valor#" <cfif modo neq 'ALTA' and rsForm.FMT02CAM eq valor>selected</cfif> >#valor#</option>
									</cfoutput>
								</cfif>
							</select>
							<cfif error>
								<font color="#FF0000">Error en Proc. Almacenado para datos</font>
							</cfif>
							<script language="JavaScript1.2" type="text/javascript">document.form1.FMT02CAM.alt='El Campo'</script>
						</td>
					</tr>
	
					<!--- Descripcion --->
					<tr>
						<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>				
						<td><input type="text" name="FMT02DES" size="50" maxlength="80" value="<cfoutput><cfif modo neq 'ALTA' >#rsForm.FMT02DES#</cfif></cfoutput>" onFocus="this.select();" alt="La Descripci&oacute;n" ></td>
					</tr>
	
					<!--- Nivel de Corte --->
					<tr>
						<td align="right" nowrap>Nivel de Corte:&nbsp;</td>
						<td>
							<select name="FMT07NIV">
								<option value="0">0 - Sin Corte</option>
								<cfoutput query="rsNiveles">
									<cfif modo neq 'ALTA'  >
										<option value="#rsNiveles#" <cfif rsNiveles.FMT07NIV eq rsForm.FMT07NIV>selected</cfif> >#rsNiveles.FMT07NIV#</option>
									<cfelse>
										<option value="#rsNiveles#" >#rsNiveles.FMT07NIV#</option>
									</cfif>
								</cfoutput>
							</select>
						</td>
					</tr>
	
					<!--- checks --->
					<tr>
						<td align="right" nowrap></td>
						<td nowrap>
							<input name="FMT02TOT" type="checkbox" value="chk" <cfif modo neq 'ALTA' and rsForm.FMT02TOT eq 1>checked</cfif>>&nbsp;Totaliza&nbsp;
						</td>
					</tr>
	
					<tr>
						<td align="right" nowrap></td>
						<td nowrap>
							<input name="FMT02AJU" type="checkbox" value="chk" <cfif modo neq 'ALTA' and rsForm.FMT02AJU eq 1>checked</cfif>>&nbsp;Ajustar L&iacute;nea&nbsp;
						</td>
					</tr>

					<!--- Formato --->
					<tr>
						<td align="right" nowrap>Formato:&nbsp;</td>
						<td>
							<select name="FMT02FMT">
								<option value="-1" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq '-1'>selected</cfif> >No Aplicar</option>
								<option value="#" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq "##">selected</cfif>>#</option>
								<option value="#0.00" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq '##0.00'>selected</cfif>>#0.00</option>
								<option value="#0.000" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq '##0.000'>selected</cfif>>#0.000</option>
								<option value="###" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq '######'>selected</cfif>>###</option>
								<option value="###,###,###,###,##0.00" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq '######,######,######,######,####0.00'>selected</cfif>>###,###,###,###,##0.00</option>
								<option value="###,###,###,###,##0.0000" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq '######,######,######,######,####0.0000'>selected</cfif>>###,###,###,###,##0.0000</option>
								<option value="DD/MMM/YYYY" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq 'DD/MMM/YYYY'>selected</cfif>>DD/MMM/YYYY</option>
								<option value="MMM/DD/YYYY" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq 'MMM/DD/YYYY'>selected</cfif>>MMM/DD/YYYY</option>
								<option value="Currency" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq 'Currency'>selected</cfif>>Currency</option>
								<option value=">" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq '>'>selected</cfif>>&gt;</option>
								<option value="<" <cfif modo neq 'ALTA' and rsForm.FMT02FMT eq '<'>selected</cfif>>&gt;</option>
							</select>
						</td>
					</tr>
	
					<!--- Longitud --->
					<tr>
						<td align="right" nowrap>Longitud:&nbsp;</td>
						<td><input type="text" name="FMT02LON" maxlength="10" size="10" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT02LON,'none')#</cfoutput></cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Longitud" ></td>
					</tr>
	
					<!--- Decimales --->
					<tr>
						<td align="right" nowrap>Decimales:&nbsp;</td>
						<td><input type="text" name="FMT02DEC" maxlength="3" size="3" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT02DEC#</cfoutput></cfif>" style="text-align: right;" onblur="fm(this,-1);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Los Decimales" ></td>
					</tr>
				
				
				</table> <!--- tabla principal columna1--->
			</td>	<!--- Columna 1--->

			<!--- Columna 2--->
			<td valign="top">
					<!--- Tabla principal Columna 2--->
					<table width="100%" border="0">
						<!--- seccion de letra --->
						<tr>
							<td>
								<!--- tabla letra --->
								<table class="cuadro" width="100%" >
									<!--- Titulo --->
									<tr bgcolor="#FAFAFA"><td align="center" colspan="5"><b>Letra</b></td></tr>
									
									<!--- Fuente, Negrita --->
									<tr>
										<td align="right" nowrap>Fuente:&nbsp;</td>
										<td width="1%">
											<select name="FMT02TPL" >
												<option value="Arial" <cfif modo neq 'ALTA' and rsForm.FMT02TPL eq 'Arial'>selected</cfif> >Arial</option>
												<option value="Courier" <cfif modo neq 'ALTA' and rsForm.FMT02TPL eq 'Courier'>selected</cfif> >Courier</option>
												<option value="sans-serif" <cfif modo neq 'ALTA' and rsForm.FMT02TPL eq 'sans-serif'>selected</cfif> >sans-serif</option>
											</select>	
										</td>
										<td>&nbsp;</td>
										<td align="right" nowrap><input type="checkbox" name="FMT02BOL" <cfif modo neq 'ALTA' and rsForm.FMT02BOL eq 1 >checked</cfif> ></td>
										<td align="left"><b>Negrita</b></td>
									</tr>

									<!--- Alineacion, Subrayado --->
									<tr>
										<td align="right" nowrap>Tama&ntilde;o:&nbsp;</td>
										<td>
											<select name="FMT02TAM" >
												<option value="6" <cfif modo neq 'ALTA' and rsForm.FMT02TAM eq 6>selected</cfif> >6</option>
												<option value="8" <cfif modo neq 'ALTA' and rsForm.FMT02TAM eq 8>selected</cfif> >8</option>
												<option value="9" <cfif modo neq 'ALTA' and rsForm.FMT02TAM eq 9>selected</cfif> >9</option>
												<option value="10" <cfif modo neq 'ALTA' and rsForm.FMT02TAM eq 10>selected</cfif> >10</option>
												<option value="11" <cfif modo neq 'ALTA' and rsForm.FMT02TAM eq 11>selected</cfif> >11</option>
												<option value="12" <cfif modo neq 'ALTA' and rsForm.FMT02TAM eq 12>selected</cfif> >12</option>
												<option value="14" <cfif modo neq 'ALTA' and rsForm.FMT02TAM eq 14>selected</cfif> >14</option>
												<option value="16" <cfif modo neq 'ALTA' and rsForm.FMT02TAM eq 16>selected</cfif> >16</option>
											</select>	
										</td>
										<td></td>
										<td align="right" nowrap><input type="checkbox" name="FMT02UND" <cfif modo neq 'ALTA' and rsForm.FMT02UND eq 1 >checked</cfif> ></td>
										<td align="left"><u>Subrayado</u></td>
									</tr>

									<!--- Color, Italica --->
									<tr>
										<td align="right" nowrap>Color:&nbsp;</td>
										<td nowrap>
											<input type="text" size="10" maxlength="6" name="FMT02CLR" value="<cfoutput><cfif modo neq 'ALTA'>#Trim(rsForm.FMT02CLR)#<cfelse>000000</cfif></cfoutput>" onblur="javascript:traercolor('FMT02CLR', 'colorBox', document.form1.FMT02CLR.value )" style="text-transform: uppercase;" onFocus="javascript:this.select();" alt="El Color">
										</td>											
										<!--- Tabla para color --->
										<td>
											<table id="colorBox" width="18" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000" class="cuadro">
												<tr>
													<td align="center" valign="middle" style="color: #FFFFFF;cursor:hand;">
														<a href="javascript:mostrarpaleta()" style="text-decoration:none;">
															<font size="1">&nbsp;&nbsp;&nbsp;&nbsp;</font>
														</a>
													</td>
												</tr>
											</table> <!--- tabla color --->
										</td>
										<script language="JavaScript1.2" type="text/javascript">traercolor( 'FMT02CLR', 'colorBox', document.form1.FMT02CLR.value );</script>
										<td align="right" nowrap><input type="checkbox" name="FMT02ITA" <cfif modo neq 'ALTA' and rsForm.FMT02ITA eq 1 >checked</cfif> ></td>
										<td align="left"><i>It&aacute;lica</i></td>
									</tr>
								</table>  <!--- tabla letra --->
							</td>
						</tr>

						<!--- Texto --->
						<tr>
							<td>
								<!--- tabla de texto --->
								<table width="100%" class="cuadro">
									<tr bgcolor="#FAFAFA"><td align="center" colspan="6"><b>Texto</b></td></tr>
									<tr>
										<!--- Posicion --->
										<td align="right" nowrap>Posici&oacute;n:&nbsp;</td>
										<td>
											<select name="FMT02POS" >
												<option value="1" <cfif modo neq 'ALTA' and rsForm.FMT02POS eq '1'>selected</cfif> >1 - Encabezado</option>
												<option value="2" <cfif modo neq 'ALTA' and rsForm.FMT02POS eq '2'>selected</cfif> >2 - Detalle</option>
												<option value="3" <cfif modo neq 'ALTA' and rsForm.FMT02POS eq '3'>selected</cfif> >3 - PostDetalle</option>
											</select>	
										</td>
										<!--- Pos.x --->
										<td align="right" nowrap>Pos. X (cm):&nbsp;</td>
										<td><input type="text" name="FMT02FIL" maxlength="5" size="5" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT02FIL#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Posici&oacute;n X" ></td>
										<!--- Pos.y --->
										<td align="right" nowrap>Pos. Y (cm):&nbsp;</td>
										<td><input type="text" name="FMT02COL" maxlength="5" size="5" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT02COL#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Posici&oacute;n Y" ></td>
									</tr>
									
									<!--- Alineacion, Prefijo, Sufijo --->
									<tr>
										<td align="right" nowrap>Alineaci&oacute;n:&nbsp;</td>
										<td>
											<select name="FMT02JUS">
												<option value="1" <cfif modo neq 'ALTA' and rsForm.FMT02JUS eq '1'>selected</cfif> >1 - Izquierda</option>
												<option value="2" <cfif modo neq 'ALTA' and rsForm.FMT02JUS eq '2'>selected</cfif> >2 - Centrado</option>
												<option value="3" <cfif modo neq 'ALTA' and rsForm.FMT02JUS eq '3'>selected</cfif> >3 - Derecha</option>
											</select>
										</td>
										<td align="right" nowrap>Prefijo:&nbsp;</td>
										<td>
											<input type="text" name="FMT02PRE" size="10" maxlength="20" value="<cfif modo neq 'ALTA'><cfoutput>#trim(rsForm.FMT02PRE)#</cfoutput></cfif>" onFocus="this.select();" alt="El Prefijo" >
										</td>
										<td align="right" nowrap>Sufijo:&nbsp;</td>
										<td><input type="text" name="FMT02SUF" size="10" maxlength="20" value="<cfif modo neq 'ALTA'><cfoutput>#trim(rsForm.FMT02SUF)#</cfoutput></cfif>" onFocus="this.select();" alt="El Sufijo" ></td>
									</tr>
									
									<!--- Tipo del campo, salto de pagina --->
									<tr>
										<td align="right" nowrap>Tipo del Campo:&nbsp;</td>
										<td>
											<select name="FMT02TIP">
												<option value="1" <cfif modo neq 'ALTA' and rsForm.FMT02TIP eq '1'>selected</cfif> >1 - Etiqueta</option>
												<option value="2" <cfif modo neq 'ALTA' and rsForm.FMT02TIP eq '2'>selected</cfif> >2 - Dato</option>
												<option value="3" <cfif modo neq 'ALTA' and rsForm.FMT02TIP eq '3'>selected</cfif> >3 - Sin Definir</option>
											</select>
										</td>
										<td>&nbsp;</td>
										<td colspan="3"><input type="checkbox" name="FMT02PAG" <cfif modo neq 'ALTA' and rsForm.FMT02PAG eq 1>checked</cfif> >&nbsp;Salto de P&aacute;gina</td>
									</tr>
									
								</table><!--- tabla de texto --->
							</td>
						</tr>
					</table>
			</td><!--- Columna 2--->
		</tr> 

		<!--- Botones--->
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" valign="baseline" colspan="2">
				<cfif modo EQ "ALTA">
							<input type="submit" name="btnAgregar" value="Agregar" onclick="javascript:setBtn( this );" >
				<cfelse>	
							<input type="submit" name="btnModificar" value="Modificar" onclick="javascript:setBtn( this );" >
							<input type="submit" name="btnEliminar"  value="Eliminar"  onclick="javascript:setBtn( this );">
							<input type="button" name="btnNuevo"     value="Nuevo"     onClick="javascript:nuevo();"  >
				</cfif>
				<input type="button" name="btnRegresar"  value="Regresar"  onClick="javascript:regresar();"  >
				<input type="reset" name="Limpiar" value="Limpiar" >
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">				
		</tr>
		
		<!--- Ocultos--->
		<tr><td></td></tr>
		<tr><td><input type="hidden" name="FMT02SPC" value="0" ></td></tr>
		<tr><td><input type="hidden" name="FMT02SQL" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT02SQL#</cfoutput></cfif>" ></td></tr>
		<cfif modo eq 'ALTA'>
			<script language="JavaScript1.2" type="text/javascript">
				descripcion(document.form1.FMT02CAM.value);	
			</script>
		</cfif>
		
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
		</td></tr>
	</table> <!--- tabla principal --->
</form>