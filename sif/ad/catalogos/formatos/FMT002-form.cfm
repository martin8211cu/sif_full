<cfif isdefined('session.FMT01COD') and len(trim(session.FMT01COD))>
	<cfset url.FMT01COD = session.FMT01COD>
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Detalle</title>
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cf_templatecss>
<cfsavecontent variable="dummy">
<cfinclude template="flash-update-campos.cfm"></cfsavecontent>
<cfoutput>

<cfparam name="url.FMT01COD" >
<cfparam name="url.linea" type="numeric">

<!--- Encabezado --->
<cfquery name="encabezado" datasource="#session.DSN#">
	select FMT01TIP, c.FMT01SP1, c.FMT01SP2, b.FMT01tipfmt
	from FMT001 b
		left join FMT000 c
			on b.FMT01TIP = c.FMT00COD
	where b.FMT01COD=<cfqueryparam cfsqltype="cf_sql_char" value="#session.FMT01COD#">
 	  and (b.Ecodigo is null or b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
</cfquery>
<cfif encabezado.FMT01tipfmt EQ 2 or encabezado.FMT01tipfmt EQ 3>
	<cfset LvarFmtOCX = 1>
<cfelse>
	<cfset LvarFmtOCX = 0>
</cfif>

<!--- Form--->
<cfquery name="rsForm" datasource="#session.DSN#">
	select FMT01COD, FMT02LIN, FMT02CAM, FMT02DES, FMT07NIV, FMT02TOT, FMT02STS, FMT02FMT, FMT02LON, FMT02DEC, 
		   FMT02TPL, FMT02BOL, FMT02TAM, FMT02UND, FMT02CLR, FMT02ITA, FMT02POS, FMT02FIL, FMT02COL,
		   FMT02JUS, FMT02TIP, FMT02PAG, FMT02SQL, FMT02AJU, ts_rversion 
		   , rtrim(FMT02PRE) as FMT02PRE, rtrim(FMT02SUF) as FMT02SUF
	from FMT002
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#session.FMT01COD#">
	  and FMT02LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.linea#">
</cfquery>

<!--- Niveles --->
<cfquery name="rsNiveles" datasource="#session.DSN#">
	select FMT07NIV
	from FMT007
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.FMT01COD#">
</cfquery>


<!--- ejecucion del sp de campos --->
<cfquery name="rsCampos" datasource="sifcontrol">
	select FMT11NOM, FMT11DES, FMT02SQL, upper(FMT11NOM) AS FMT11NOM_UPPERCASE
	from FMT011
	where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer"    value="#encabezado.FMT01TIP#">
	order by 4
</cfquery>

<cfif rsCampos.RecordCount is 0 and Len(Trim(encabezado.FMT01SP2))>
	<cftransaction>
		<cftry>
			<cfquery datasource="#session.dsn#" name="exec_sp">
				exec #Trim(encabezado.FMT01SP2)#
			</cfquery>
			<cfloop query="exec_sp">
				<cfquery datasource="sifcontrol">
					insert into FMT011 (FMT00COD, FMT02SQL, FMT10TIP, FMT11NOM, FMT11DES)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#encabezado.FMT01TIP#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#exec_sp.posic#">,
						1, <!--- no se que poner, todavía --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#NumberFormat(exec_sp.posic,'00')# - #exec_sp.campo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#NumberFormat(exec_sp.posic,'00')# - #exec_sp.campo#">)
				</cfquery>
			</cfloop>
			<cfquery name="rsCampos" datasource="sifcontrol">
				select FMT11NOM, FMT11DES, FMT02SQL
				from FMT011
				where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer"    value="#encabezado.FMT01TIP#">
			</cfquery>
		<cfcatch type="any">
		<div style="color:red">
		Error Ejecuntado el Stored Procedure '#Trim(encabezado.FMT01SP2)#' : #cfcatch.Message# #cfcatch.Detail#</div>
		</cfcatch>
		<!--- si es oracle, no va a servir nunca el sp --->
		</cftry>
	</cftransaction>
</cfif>

<!--- ===============================================================================================  	--->

<!--- ===============================================================================================  	--->
<!--- 												JS 											        --->
<!--- ===============================================================================================  	--->
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>	
<script language="JavaScript1.2" type="text/javascript">

	var boton = "";
	function setBtn(obj){
		boton = obj.name;
	}

	function traercolor( obj, tabla, color ){
		if ( color != '' && color.length == 6 ){
			var tablita = document.getElementById("colorBox");
			tablita.style.backgroundColor = "##" + color;
			document.form1.FMT02CLR.value = color;
		}
	}

	function mostrarpaleta(){
	// RESULTADO
	// Muestra una paleta de colores.
		window.open("/cfmx/sif/ad/catalogos/color.cfm?obj=FMT02CLR&tabla=colorBox","Paleta",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,height=60,width=308,left=375, top=250');
	}
	
	function descripcion( f ){
	// RESULTADO
	// Pone la descripcion, segun el campo seleccionado
		f.FMT02DES.value = f.FMT02CAM.options[f.FMT02CAM.selectedIndex].text;
	}
	
	function cambio_fmt02tip(f){
		if (f.FMT02TIP.value == 1){
			// 1-etiqueta
			f.FMT02DES.style.display='inline';
			f.FMT02CAM.style.display='none';
		} else {
			// 2-campo
			f.FMT02DES.style.display='none';
			f.FMT02CAM.style.display='inline';
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
				if ( confirm('Va a eliminar esta Linea. Desea continuar?') ){
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

</script>
<!--- =============================================================================================== --->

<style type="text/css">
	.cuadro{
		border: 1px solid ##999999;
	}

	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: ##CCCCCC;
	}
</style>

<form name="form1" method="post" onSubmit="return validar();" target="_parent" action="FMT002-sql.cfm" >
	<table border="0" cellpadding="0" cellspacing="0">
	  <!--DWLayoutTable-->

		<tr>
		  <td width="96">&nbsp;</td>
		  <td width="16">&nbsp;</td>
		  <td width="309">&nbsp;</td>
	  </tr>
		<tr><td>&nbsp;</td>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
	    </tr>
		<tr>
		  <td colspan="3" valign="top">
			  <div align="center" class="subTitulo">
				  <font size="3">
							  <cfset Translate_Modificar=Request.Translate('BotonCambiar','Modificar', '/sif/Utiles/Generales.xml')>
					  <strong>#Translate_Modificar#
					  </strong>
				  </font>
		      </div></td>
	  </tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
		  <td colspan="3" align="center" valign="top"><b>Comportamiento del Campo a Imprimir</b></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
		  <td align="right" valign="top" nowrap>Posici&oacute;n</td>
              <td>&nbsp;</td>
              <td valign="top"><select name="FMT02POS" >
                <option value="1" <cfif rsForm.FMT02POS eq '1'>selected</cfif> >1 - Encabezado</option>
                <option value="2" <cfif rsForm.FMT02POS eq '2'>selected</cfif> >2 - Detalle</option>
                <option value="3" <cfif rsForm.FMT02POS eq '3'>selected</cfif> >3 - PostDetalle</option>
                                            </select>              </td>
      </tr>
		<tr>
		  <td align="right" valign="top" nowrap>Tipo de Campo</td>
              <td>&nbsp;</td>
		      <td valign="top"><select name="FMT02TIP" onchange="cambio_fmt02tip(this.form)" onclick="cambio_fmt02tip(this.form)">
            <option value="1" <cfif rsForm.FMT02TIP eq '1'>selected</cfif> >1 - Etiqueta</option>
            <option value="2" <cfif rsForm.FMT02TIP eq '2'>selected</cfif> >2 - Dato</option>
                        </select>          </td>
      </tr>
		<tr>
		  <td rowspan="2" align="right" valign="top" nowrap>Valor</td>
			<td></td>
		  <td rowspan="2" valign="top" nowrap>
			  <select name="FMT02CAM" onChange="descripcion(this.form);" <cfif rsForm.FMT02TIP is 1>style="display:none"</cfif>>
				  <cfloop query="rsCampos">
					  <option value="#rsCampos.FMT02SQL#" <cfif  rsForm.FMT02SQL eq rsCampos.FMT02SQL>selected</cfif> >#FMT11NOM#</option>
				  </cfloop>
			  </select>
			  <script language="JavaScript1.2" type="text/javascript">document.form1.FMT02CAM.alt='El Campo'</script>
		      <input type="text" name="FMT02DES" size="30" maxlength="80" value="#rsForm.FMT02DES#" onFocus="this.select();" alt="La Descripci&oacute;n"
			    <cfif rsForm.FMT02TIP is 2>style="display:none"</cfif>    ></td>
	  </tr>
		<tr>
		  <td height="6"></td>
	  </tr>
		<tr>
		<cfif LvarFmtOCX NEQ 1>
			<td align="right" valign="top" nowrap>Nivel de Corte</td>
			<td></td>
			<td valign="top">
			  	<select name="FMT07NIV">
				  	<option value="0">0 - Sin Corte</option>
				  	<cfloop query="rsNiveles">
					  	<option value="#rsNiveles#" <cfif rsNiveles.FMT07NIV eq rsForm.FMT07NIV>selected</cfif> >#rsNiveles.FMT07NIV#</option>
				  	</cfloop>
			  	</select>
				<input name="FMT02TOT" type="checkbox" value="chk" <cfif rsForm.FMT02TOT eq 1>checked</cfif>>&nbsp;Totaliza&nbsp;
		<cfelse>
			<td>
				<input name="FMT07NIV" type="hidden" value="#rsForm.FMT07NIV#">
				<input name="FMT02TOT" type="hidden" value="#rsForm.FMT02TOT#">
			</td>
		</cfif>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>
				Ubicación en cm
			</td>
			<td></td>
			<td align="left" valign="top" nowrap>
				&nbsp;
				X=
				<input type="text" name="FMT02FIL" maxlength ="5" size="4" value="#LSCurrencyFormat(rsForm.FMT02FIL,'none')#" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" title="Posición Horizontal" >
				Y=
				<input type="text" name="FMT02COL" maxlength ="5" size="4" value="#LSCurrencyFormat(rsForm.FMT02COL,'none')#" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" title="Posición Vertical" >
				Lon=
				<input type="text" name="FMT02LON" maxlength ="5" size="4" value="#LSCurrencyFormat(rsForm.FMT02LON,'none')#" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" title="La Longitud" >
			</td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td valign="top" nowrap>
				<input name="FMT02STS" type="checkbox" value="chk" <cfif rsForm.FMT02STS eq 1>checked</cfif>>
				&nbsp;Desactivar Campo </td>
			</td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td valign="top" nowrap>
				<input name="FMT02AJU" type="checkbox" value="chk" <cfif rsForm.FMT02AJU eq 1>checked</cfif>>
			  	&nbsp;Ajustar L&iacute;nea&nbsp;
				<input type="checkbox" name="FMT02PAG" <cfif rsForm.FMT02PAG eq 1>checked</cfif>>
				&nbsp;Salto de P&aacute;gina
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
		  <td colspan="3" align="center" valign="top"><b>Formato del Valor a Imprimir</b></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="right" nowrap>
				Formato
			</td>
			<td></td>
			<td align="left" valign="top" nowrap>
			<cfif LvarFmtOCX EQ 1>
				<input type="text" name="FMT02PRE" value="#rsForm.FMT02PRE#" size="2" style="text-align:right;" title="Prefijo: caracteres antes del dato formateado">
			<cfelse>
				<input type="hidden" name="FMT02PRE" value="#rsForm.FMT02PRE#">
				<input type="hidden" name="FMT02SUF" value="#rsForm.FMT02SUF#">
			</cfif>
				<select name="FMT02FMT" 
						onchange="
							if (this.selectedIndex == 1) 
								this.selectedIndex = 2;
							else if (this.selectedIndex == #9+LvarFmtOCX#) 
								this.selectedIndex = #10+LvarFmtOCX#;
						"
				>
					<option value="-1" <cfif rsForm.FMT02FMT eq '-1'>selected</cfif> >No Aplicar</option>
					<option disabled>--VALOR NUMERICO:--</option>
					<option value="##" <cfif rsForm.FMT02FMT eq "##" or rsForm.FMT02FMT eq '######'>selected</cfif>>##</option>
					<option value="##0" <cfif rsForm.FMT02FMT eq '##0'>selected</cfif>>##0</option>
					<option value="##,####0" <cfif rsForm.FMT02FMT eq '##,####0'>selected</cfif>>##,####0</option>
					<option value="##0.00" <cfif rsForm.FMT02FMT eq '##0.00'>selected</cfif>>##0.00</option>
					<option value="######,######,######,######,####0.00" <cfif rsForm.FMT02FMT eq '######,######,######,######,####0.00'>selected</cfif>>##,####0.00</option>
					<option value="##0.0000" <cfif rsForm.FMT02FMT eq '##0.000' or rsForm.FMT02FMT eq '##0.0000'>selected</cfif>>##0.0000</option>
					<option value="######,######,######,######,####0.0000" <cfif rsForm.FMT02FMT eq '######,######,######,######,####0.0000'>selected</cfif>>##,####0.0000</option>
				<cfif LvarFmtOCX EQ 1>
					<option value="MONTOENLETRAS" <cfif rsForm.FMT02FMT eq 'MONTOENLETRAS'>selected</cfif>>Monto en Letras</option>
				</cfif>
					<option disabled>--VALOR FECHA:--</option>
					<option value="dd/MM/yyyy" <cfif rsForm.FMT02FMT eq 'dd/MM/yyyy'>selected</cfif>>dd/MM/yyyy</option>
					<option value="dd/MMM/yyyy" <cfif rsForm.FMT02FMT eq 'dd/MMM/yyyy'>selected</cfif>>dd/MMM/yyyy</option>
					<option value="MMM/dd/yyyy" <cfif rsForm.FMT02FMT eq 'MMM/dd/yyyy'>selected</cfif>>MMM/dd/yyyy</option>
					<option value="MM/dd/yyyy" <cfif rsForm.FMT02FMT eq 'MM/dd/yyyy'>selected</cfif>>MM/dd/yyyy</option>
				<cfif LvarFmtOCX EQ 1>
					<option value="FECHAENLETRAS" <cfif rsForm.FMT02FMT eq 'FECHAENLETRAS'>selected</cfif>>Fecha en Letras</option>
				</cfif>
					<option value="hh:mm:ss" <cfif rsForm.FMT02FMT eq 'hh:mm:ss'>selected</cfif>>hh:mm:ss</option>
					<option value="hh:mm" <cfif rsForm.FMT02FMT eq 'hh:mm'>selected</cfif>>hh:mm</option>
				</select>		  
			<cfif LvarFmtOCX EQ 1>
				<input type="text" name="FMT02SUF" value="#rsForm.FMT02SUF#" size="2" title="Sufijo: caracteres despues del dato formateado">
			</cfif>
			</td>
		</tr>
		<tr>
          <td align="right" nowrap>Alineaci&oacute;n</td>
          <td>&nbsp;</td>
          <td valign="top"><select name="FMT02JUS">
              <option value="1" <cfif rsForm.FMT02JUS eq '1'>selected</cfif> >1 - Izquierda</option>
              <option value="2" <cfif rsForm.FMT02JUS eq '2'>selected</cfif> >2 - Centrado</option>
              <option value="3" <cfif rsForm.FMT02JUS eq '3'>selected</cfif> >3 - Derecha</option>
            </select>
          </td>
	  </tr>
		<tr>
		  <td align="right" nowrap>Fuente</td>
            <td>&nbsp;</td>
            <td nowrap>
				<select name="FMT02TPL" >
					<option value="Arial" <cfif rsForm.FMT02TPL eq 'Arial'>selected</cfif> >Arial</option>
					<option value="Courier" <cfif rsForm.FMT02TPL eq 'Courier'>selected</cfif> >Courier</option>
					<option value="sans-serif" <cfif rsForm.FMT02TPL eq 'sans-serif'>selected</cfif> >sans-serif</option>
				</select>
				&nbsp;&nbsp;&nbsp;
				Tama&ntilde;o
				<select name="FMT02TAM" >
					<option value="6" <cfif rsForm.FMT02TAM eq 6>selected</cfif> >6</option>
					<option value="8" <cfif rsForm.FMT02TAM eq 8>selected</cfif> >8</option>
					<option value="9" <cfif rsForm.FMT02TAM eq 9>selected</cfif> >9</option>
					<option value="10" <cfif rsForm.FMT02TAM eq 10>selected</cfif> >10</option>
					<option value="11" <cfif rsForm.FMT02TAM eq 11>selected</cfif> >11</option>
					<option value="12" <cfif rsForm.FMT02TAM eq 12>selected</cfif> >12</option>
					<option value="14" <cfif rsForm.FMT02TAM eq 14>selected</cfif> >14</option>
					<option value="16" <cfif rsForm.FMT02TAM eq 16>selected</cfif> >16</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>Color</td>
			<td>&nbsp;</td>
            <td>
				<input type="text" size="10" maxlength="6" name="FMT02CLR" value="#Trim(rsForm.FMT02CLR)#" onblur="javascript:traercolor('FMT02CLR', 'colorBox', document.form1.FMT02CLR.value )" style="text-transform: uppercase;" onFocus="javascript:this.select();" alt="El Color">
				<span id="colorBox" onClick="mostrarpaleta()" style="background-color:###Trim(rsForm.FMT02CLR)#;width:16px;height:10px;cursor:pointer">&nbsp;&nbsp;&nbsp;&nbsp;</span>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<input type="checkbox" name="FMT02BOL" <cfif rsForm.FMT02BOL eq 1 >checked</cfif> >
				<b>Negrita</b>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<input type="checkbox" name="FMT02UND" <cfif rsForm.FMT02UND eq 1 >checked</cfif> >
		  		<u>Subrayado</u>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><input type="checkbox" name="FMT02ITA" <cfif rsForm.FMT02ITA eq 1 >checked</cfif> >
				<i>It&aacute;lica</i>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr>
		  <td colspan="3" align="center" valign="baseline">
			<input type="submit" name="btnModificar" value="Modificar" onclick="javascript:setBtn( this );" >
			<input type="submit" name="btnEliminar"  value="Eliminar"  onclick="javascript:setBtn( this );">
			
			<input type="reset" name="Limpiar" value="Limpiar" >
			<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">		
			  </td>		
		</tr>

				
		<tr>
			<!---
			<td align="right" valign="top" nowrap>Decimales</td>
			<td></td>
			--->
			<td valign="top">
			  <input type="hidden" name="FMT02DEC" maxlength="3" size="3" value="#rsForm.FMT02DEC#" style="text-align: right;" onblur="fm(this,-1);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Los Decimales" >
			</td>
		</tr>

	</table> 
	<!--- tabla principal --->
<input type="hidden" name="FMT01COD" value="#rsForm.FMT01COD#">
<input type="hidden" name="FMT02LIN" value="#rsForm.FMT02LIN#">

<input type="hidden" name="FMT02SPC" value="0" >

<cfset ts = "">	
<cfinvoke 
	component="sif.Componentes.DButils"
	method="toTimeStamp"
	returnvariable="ts">
	<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
</cfinvoke>
<input type="hidden" name="ts_rversion" value="#ts#">
</form>
</cfoutput>
</body>
</html>