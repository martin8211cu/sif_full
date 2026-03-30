<!--- valida que siempre exista el codigo de encabezado, que por fuerza debe existir --->
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
<!--- 												CONSULTAS 											--->
<!--- ===============================================================================================  	--->
<cfquery name="rsFormato" datasource="emperador">
	select FMT01DES from FMT001 where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
</cfquery>

<!--- Form--->
<cfquery name="rsForm" datasource="emperador">
	select FMT09LIN, FMT09COL, FMT09FIL, FMT09CLR, FMT09HEI, FMT09WID, FMT09GRS, FMT09CFN, timestamp
	from FMT009
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01COD#">
	<cfif isdefined("form.FMT09LIN") and #Len(Trim("form.FMT09LIN"))# gt 0>
		  and FMT09LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT09LIN#">
	</cfif>	
</cfquery>

<!--- Linea --->
<cfquery name="rsLinea" datasource="emperador">
	select isnull(max(FMT09LIN)+1,1) as FMT09LIN
	from FMT009 a, FMT001 b
	where a.FMT01COD=b.FMT01COD
	  and a.FMT01COD=<cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01COD#">
 	  and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- ===============================================================================================  	--->

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
			var tablita = document.getElementById(tabla);
			tablita.bgColor = "#" + color;
			eval('document.form1.'+obj).value = color
		}
	}

	function mostrarpaleta(obj, tabla){
	// RESULTADO
	// Muestra una paleta de colores.
		window.open("color.cfm?obj="+obj+"&tabla="+tabla,"Paleta",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,height=60,width=308,left=375, top=250');
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

	function formato(){
		document.form1.FMT09COL.value = qf(document.form1.FMT09COL);
		document.form1.FMT09FIL.value = qf(document.form1.FMT09FIL);
		document.form1.FMT09HEI.value = qf(document.form1.FMT09HEI);
		document.form1.FMT09WID.value = qf(document.form1.FMT09WID);
		document.form1.FMT09GRS.value = qf(document.form1.FMT09GRS);
	}
	
	function validar(){
		switch ( boton ) {
		   case 'btnEliminar' :
				if ( confirm('Va a eliminar este registro . Desea continuar?') ){
					document.form1.FMT09LIN.disabled = false;
					return true;
				}
			    break;
		   case 'btnAgregar' :
				MM_validateForm('FMT01COD','','R', 'FMT09LIN','','R', 'FMT09COL','','R', 'FMT09FIL','','R', 'FMT09CLR','','R', 'FMT09HEI','','R', 'FMT09WID','','R', 'FMT09GRS','','R' );
				if (document.MM_returnValue){
					document.form1.FMT09LIN.disabled = false;
					formato();
				}
				return document.MM_returnValue;
			    break;
	
		   case 'btnModificar' :
				MM_validateForm('FMT01COD','','R', 'FMT09LIN','','R', 'FMT09COL','','R', 'FMT09FIL','','R', 'FMT09CLR','','R', 'FMT09HEI','','R', 'FMT09WID','','R', 'FMT09GRS','','R' );
				if (document.MM_returnValue){
					document.form1.FMT09LIN.disabled = false;
					formato();
				}
				return document.MM_returnValue;
			    break;
		}
		
		return false;
	}

	function nuevo(){
		document.form1.FMT01COD.disabled = false;
		document.form1.FMT09LIN.value    = "";
		document.form1.action            = "FMTLineas.cfm";
		document.form1.submit();
	}
	
	function regresar(){
		document.form1.FMT01COD.disabled = false;
		document.form1.FMT01COD.value    = '<cfoutput>#form.FMT01COD#</cfoutput>';
		document.form1.FMT09LIN.value    = "";
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

<form name="form1" method="post" onSubmit="return validar();" action="SQLFMTLineas.cfm" >
	<table width="100%" border="0" cellpadding="0" cellspacing="0">

		<tr><td colspan="3">&nbsp;</td></tr>

		<tr>
			<td align="right" nowrap>Formato:&nbsp;</td>
		  	<td colspan="2">
				<cfoutput>#trim(form.FMT01COD)# - #rsFormato.FMT01DES#</cfoutput>
				<input type="hidden" name="FMT01COD" value="<cfoutput>#trim(form.FMT01COD)#</cfoutput>" >
			</td>
		</tr>

		<!--- Linea --->
		<tr>
			<td align="right" nowrap>L&iacute;nea:&nbsp;</td>				
			<td colspan="2"><input type="text" name="FMT09LIN" size="12" disabled value="<cfoutput><cfif modo neq 'ALTA' >#form.FMT09LIN#<cfelse>#rsLinea.FMT09LIN#</cfif></cfoutput>" style="text-align: right;" ></td>
		</tr>			


		<tr>
			<td align="right" width="50%" nowrap>Color de L&iacute;nea:&nbsp;</td>
			<td width="1%" nowrap>
				<input type="text" size="10" maxlength="6" name="FMT09CLR" value="<cfoutput><cfif modo neq 'ALTA'>#Trim(rsForm.FMT09CLR)#<cfelse>000000</cfif></cfoutput>" onblur="javascript: if(trim(this.value) == ''){ this.value = '000000' }; traercolor('FMT09CLR', 'colorBox1', this.value)" style="text-transform: uppercase;" onFocus="javascript:this.select();" alt="El Color de L&iacute;nea">
			</td>											
			<!--- Tabla para color --->
			<td valign="middle">
				<table id="colorBox1" width="18" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000" class="cuadro">
					<tr>
						<td align="center" valign="middle" style="color: #FFFFFF;cursor:hand;">
							<a href="javascript:mostrarpaleta('FMT09CLR','colorBox1')" style="text-decoration:none;">
								<font size="1">&nbsp;&nbsp;&nbsp;&nbsp;</font>
							</a>
						</td>
					</tr>
				</table> <!--- tabla color --->
			</td>
			<script language="JavaScript1.2" type="text/javascript">traercolor( 'FMT09CLR', 'colorBox1', document.form1.FMT09CLR.value );</script>
		</tr>

		<tr>
			<td align="right" width="50%" nowrap>Color de Fondo:&nbsp;</td>
			<td width="1%" nowrap>
				<input type="text" size="10" maxlength="6" name="FMT09CFN" value="<cfoutput><cfif modo neq 'ALTA'>#Trim(rsForm.FMT09CFN)#<cfelse>FFFFFF</cfif></cfoutput>" onblur="javascript:if(trim(this.value) == ''){ this.value = 'FFFFFF' }; traercolor('FMT09CFN', 'colorBox2', this.value)" style="text-transform: uppercase;" onFocus="javascript:this.select();" alt="El Color de Fondo">
			</td>											
			<!--- Tabla para color --->
			<td valign="middle">
				<table id="colorBox2" width="18" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000" class="cuadro">
					<tr>
						<td align="center" valign="middle" style="color: #FFFFFF;cursor:hand;">
							<a href="javascript:mostrarpaleta('FMT09CFN', 'colorBox2')" style="text-decoration:none;">
								<font size="1">&nbsp;&nbsp;&nbsp;&nbsp;</font>
							</a>
						</td>
					</tr>
				</table> <!--- tabla color --->
			</td>
			<script language="JavaScript1.2" type="text/javascript">traercolor( 'FMT09CFN', 'colorBox2', document.form1.FMT09CFN.value );</script>
		</tr>

		<tr>
			<!--- Pos.x --->
			<td align="right" nowrap>Fila:&nbsp;</td>
			<td><input type="text" name="FMT09FIL" maxlength="5" size="7" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT09FIL,'none')#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Fila" ></td>
		</tr>
		<tr>
			<!--- Pos.y --->
			<td align="right" nowrap>Columna:&nbsp;</td>
			<td><input type="text" name="FMT09COL" maxlength="5" size="7" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT09COL, 'none')#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Columna" ></td>
		</tr>

		<tr>
			<!--- Pos.x --->
			<td align="right" nowrap>Alto:&nbsp;</td>
			<td><input type="text" name="FMT09HEI" maxlength="5" size="7" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT09HEI,'none')#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Alto" ></td>
		</tr>
		<tr>
			<!--- Pos.y --->
			<td align="right" nowrap>Ancho:&nbsp;</td>
			<td><input type="text" name="FMT09WID" maxlength="5" size="7" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT09WID, 'none')#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Ancho" ></td>
		</tr>
		<tr>
			<!--- Pos.y --->
			<td align="right" nowrap>Grosor de la L&iacute;nea:&nbsp;</td>
			<td><input type="text" name="FMT09GRS" maxlength="7" size="7" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT09GRS#</cfoutput><cfelse>0.0001</cfif>" style="text-align: right;" onblur="fm(this,4);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" alt="El Grosor" ></td>
			<script language="JavaScript1.2" type="text/javascript">fm( document.form1.FMT09GRS, 4 );</script>
		</tr>



		<!--- Botones--->
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr>
			<td align="center" valign="baseline" colspan="3">
				<link href="estilos.css" rel="stylesheet" type="text/css">
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
		<tr><td colspan="3"></td></tr>

		<tr><td colspan="3">
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
		</td></tr>
				

	</table> 
	<!--- tabla principal --->
</form>

