<!-- Establecimiento del modo -->

<cfdump var="#form#">
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined('Form.NuevoL')>
		<cfset modo="ALTA">
</cfif>
<!-- modo para el detalle -->
<cfif isdefined("Form.DAlinea")>
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.DAlinea")>
		<cfset dmodo="ALTA">
	<cfelseif #Form.dmodo# EQ "CAMBIO">
		<cfset dmodo="CAMBIO">
	<cfelse>
		<cfset dmodo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->

<!--- 1. Form --->
<cfquery datasource="#session.DSN#" name="rsForm">

	select EAid, Aid, convert(varchar ,EAfecha,103) as EAfecha, rtrim(EAdocumento) as EAdocumento, EAusuario, EAdescripcion, timestamp
	from EAjustes 
	<cfif isdefined("Form.EAid") and Form.EAid NEQ "" >
		where EAid = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
	</cfif>

</cfquery>

<!--- 2. Combo Almacen --->
<cfquery datasource="#session.DSN#" name="rsAlmacen">

	select Aid, Bdescripcion
	from Almacen 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
	order by Bdescripcion

</cfquery>

<!--- 3. Consulta de documentos --->
<cfquery datasource="#session.DSN#" name="rsDocumentos">

	select rtrim(EAdocumento) as EAdocumento
	from EAjustes ea, Almacen a
	where ea.Aid=a.Aid and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
	<cfif isdefined("Form.EAid") and Form.EAid NEQ "" >
		and EAdocumento not in ( select EAdocumento 
								   from EAjustes 
								   where EAid = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric"> 
								  )
	</cfif>

</cfquery>

<!--- Seccion del detalle --->

<!--- 1. Form --->
<cfquery datasource="#session.DSN#" name="rsFormDetalle">

	select da.EAid, da.Aid, da.DAcantidad, da.DAcosto, da.DAtipo, da.DALinea, a.Adescripcion, da.timestamp 
	from DAjustes da,  Articulos a
	where da.Aid=a.Aid
	<cfif isdefined("Form.EAid") and Form.EAid NEQ "" and isdefined("Form.DAlinea") and Form.DAlinea NEQ "" >
		and da.EAid    = <cfqueryparam value="#Form.EAid#"    cfsqltype="cf_sql_numeric">
		and da.DALinea = <cfqueryparam value="#Form.DALinea#" cfsqltype="cf_sql_numeric">
	</cfif>

</cfquery>

<!--- 2. Cantidad de lineas de detalle--->
<cfquery datasource="#session.DSN#" name="rsFormLineas">

	select count(*) as lineas from DAjustes
	<cfif isdefined("Form.EAid") and Form.EAid NEQ "" >
		where EAid = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
	</cfif>

</cfquery>

<script language="JavaScript" type="text/JavaScript">

	// ==================================================================================================
	// 								Usadas para conlis de fecha
	// ==================================================================================================
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
	// ==================================================================================================
	// ==================================================================================================	
	
	// ==================================================================================================
	//											Validaciones
	// ==================================================================================================	
	var boton = "";
	
	function setBtn(obj){
		boton = obj.name;
	}
	
	// ==================================================================================================
	// ==================================================================================================	
	

</script>
<script language="JavaScript" type="text/JavaScript">

function MM_validateForm() { //v4.0
	var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;

	if ( ( boton != 'btnBorrarE' ) && ( boton != 'btnBorrarD' )  && ( boton != 'btnAplicar' ) ) {
		for (i=0; i<(args.length-2); i+=3) { 
			test=args[i+2]; 
			val=MM_findObj(args[i]);
			if (val) { 
				if (val.alt!="") 
					nm=val.alt; 
				else 
					nm=val.name; 
				
				if ((val=val.value)!="") {
					if (test.indexOf('isEmail')!=-1) { 
						p=val.indexOf('@');
						if (p<1 || p==(val.length-1)) 
							errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
					} 
					else if (test!='R') { 
						num = parseFloat(val);
						if (isNaN(val)) 
							errors+='- '+nm+' debe ser numérico.\n';
					
						if (test.indexOf('inRange') != -1) { 
							p=test.indexOf(':');
							min=test.substring(8,p); 
							max=test.substring(p+1);
							if (num<min || max<num) 
								errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
						} 
					} 
				} 
				else if (test.charAt(0) == 'R') 
					errors += '- '+nm+' es requerido.\n'; 
			}
		} 

		if ( boton != 'btnAgregarE'){
			if ( parseFloat(document.ajuste.DAcantidad.value) == 0 ){
				errors += '- La Cantidad debe ser diferente de cero.\n';
			}
			
			if ( parseFloat(document.ajuste.DAcosto.value) == 0 ){
				errors += '- El Costo debe ser diferente de cero.\n';
			}
		}	
		
		if (errors) {
			alert('Se presentaron los siguientes errores:\n\n'+errors);
		}	
		document.MM_returnValue = (errors == '');
	}
	else{
		if ( boton == 'btnBorrarD'){
			if ( confirm('Va a eliminar este detalle de Ajuste. Desea continuar?') ){
				document.MM_returnValue = true;
			}
			else{
				document.MM_returnValue = false;
			}
		}

		if ( boton == 'btnBorrarE'){
			if ( confirm('Va a eliminar este Ajuste y todas sus lineas de detalle. Desea continuar?') ){
				document.MM_returnValue = true;
			}
			else{
				document.MM_returnValue = false;
			}
		}
		
		if ( boton == 'btnAplicar'){
			if ( confirm('Desea aplicar este documento?') ){
				document.MM_returnValue = true;
			}
			else{
				document.MM_returnValue = false;
			}
		}
	}	
}


function documento(obj){
// RESULTADO
// Valida la existencia del codigo de documento, pues no debe ser repetido
	if ( (obj.value != "") ){
		<cfloop query="rsDocumentos">
			if ( '<cfoutput>#rsDocumentos.EAdocumento#</cfoutput>' == obj.value) {
				alert('El código de Documento ya existe.')
				obj.value = "";
				obj.focus();
				return false;
			}
		</cfloop>
	}	
}

function cambiar_almacen(form){
	document[form.name].Adescripcion.value = "";
	document[form.name].aAid.value         = "";	
	document[form.name].DAtipo.value       = 1;
	document[form.name].DAcantidad.value   = "0.00";
	document[form.name].DAcosto.value      = "0.00";	
}

</script>


<form action   = "SQLAjustes.cfm" 
      method   = "post" 
      name     = "ajuste" 
      onSubmit = " <cfif modo EQ 'ALTA' >
 				       	MM_validateForm('EAdocumento','','R','EAdescripcion','','R','EAfecha','','R','Aid','','R');  
				   <cfelse>
				   		MM_validateForm('EAdescripcion','','R','ERfecha','','Aid','','R','R','Adescripcion','','R','DAcantidad','','R','DAcosto','','R'); 
                   </cfif> 
				   return document.MM_returnValue" 
>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0">

		<tr><td class="tituloAlterno" colspan="8">Encabezado de Ajuste</td></tr>
		<tr>
			<td align="right">Documento:&nbsp;</td>
			<td>
				<input type="text" name="EAdocumento" size="20" maxlength="20" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EAdocumento#</cfoutput></cfif>" onBlur = "javascript: documento(this)" alt="El Documento" onfocus="javascript:this.select();" >

				<cfif modo EQ 'CAMBIO'>
					<input type="hidden" name="bdEAdocumento" value="<cfoutput>#rsForm.EAdocumento#</cfoutput>">
				</cfif>

			</td>

			<td align="right">Descripci&oacute;n:&nbsp;</td>
			<td>
				<input type="text" name="EAdescripcion" size="50" maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EAdescripcion#</cfoutput></cfif>" alt="La Descripci&oacute;n del Ajuste" onfocus="javascript:this.select();" >
				<input type="hidden" name="EAid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EAid#</cfoutput></cfif>" >

				<cfif modo EQ 'CAMBIO'>
					<input type="hidden" name="bdEAdescripcion" value="<cfoutput>#rsForm.EAdescripcion#</cfoutput>">
				</cfif>
			</td>

		    <td align="right">Fecha:&nbsp;</td>
		    <td>
				<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','<cfoutput>#session.rutaImagenes#</cfoutput>date_d.GIF',1)"> 
					<input name="EAfecha" type="text" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsForm.EAfecha#</cfoutput><cfelse><cfoutput>#DateFormat(Now(),'DD/MM/YYYY')#</cfoutput></cfif>" size="10" maxlength="10"  readonly="" alt="El campo Fecha" onfocus="javascript:this.select();">
					<img src="<cfoutput>#session.rutaImagenes#</cfoutput>date_d.GIF" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.ajuste.EAfecha');">
				</a>

				<cfif modo EQ 'CAMBIO'>
					<input type="hidden" name="bdEAfecha" value="<cfoutput>#rsForm.EAfecha#</cfoutput>" alt="La Fecha del Ajuste" >
				</cfif>
			</td>

			<td align="right">Almac&eacute;n:&nbsp;</td>
			<td>
				<select name="Aid" onChange="javascript:cambiar_almacen(this.form);" >
					<cfoutput query="rsAlmacen">					
						<cfif modo EQ 'ALTA'>
							<option value="#rsAlmacen.Aid#">#rsAlmacen.Bdescripcion#</option>
						<cfelse>
							<option value="#rsAlmacen.Aid#" <cfif #rsForm.Aid# EQ #rsAlmacen.Aid#>selected</cfif> >#rsAlmacen.Bdescripcion#</option>
						</cfif>
					</cfoutput>						
				</select>

				<cfif modo EQ 'CAMBIO'>
				<input type="hidden" name="bdAid" value="<cfoutput>#rsForm.Aid#</cfoutput>">
				</cfif>
			</td>

		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.timestamp#"/>
			</cfinvoke>
		</cfif>
		<tr><td><input type="hidden" name="timestamp" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
	  
		<tr><td><br><br></td></tr>

		<!-- ============================================================================================================ -->
		<!-- Seccion del detalle -->
		<!-- Solo se pinta si estamos en el modo cambio del encabezado -->
		<!-- ============================================================================================================ -->		

		<cfif modo NEQ 'ALTA'>
		<tr><td class="tituloAlterno" colspan="8">Detalle de Ajuste</td></tr>

		<tr><td colspan="8"> 
			<table width="100%" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td align="right">Art&iacute;culo:&nbsp;</td>

				<td width="30%">
					<input name="Adescripcion" disabled type="text" value="<cfif dmodo NEQ "ALTA"><cfoutput>#rsFormDetalle.Adescripcion#</cfoutput></cfif>" size="50" maxlength="80" alt="El Artículo"> 
					<a href="#">
						<img src="../../Imagenes/Description.gif" alt="Lista de Cuentas Contables" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
					</a> 
					<input type="hidden" name="aAid" value="<cfif dmodo NEQ "ALTA"><cfoutput>#rsFormDetalle.Aid#</cfoutput></cfif>">
				</td>
				
				<td align="right">Tipo:&nbsp;</td>
				<td>
					<select name="DAtipo" >
						<cfif modo EQ 'ALTA'>
							<option value="1">Salida</option>
							<option value="0">Entrada</option>
						<cfelse>
							<option value="1" <cfif #rsFormdetalle.DAtipo# EQ 1>selected</cfif> >Salida</option>
							<option value="0" <cfif #rsFormDetalle.DAtipo# EQ 0>selected</cfif> >Entrada</option>
						</cfif>
					</select>
				</td>	

				<td align="right">Cantidad:&nbsp;</td>
				<td>
					<input type="text" name="DAcantidad" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsFormDetalle.DAcantidad, 'none')#</cfoutput><cfelse>0.00</cfif>"  size="8" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Cantidad" >
				</td>
				
				<td align="right">Costo Total:&nbsp;</td>

				<td>
					<input type="text" name="DAcosto" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsFormDetalle.DAcosto, 'none')#</cfoutput><cfelse>0.00</cfif>"  size="8" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Costo" >
				</td>
					
			</tr>
			
			<cfif dmodo EQ 'CAMBIO'>
				<tr>
					<td colspan="4">
						<input type="hidden" name="DAlinea" value="<cfoutput>#rsFormDetalle.DAlinea#</cfoutput>">
					</td>
				</tr>
			</cfif>

			<!-- Requeridos por el conlis ??? -->
			<tr>
				<td colspan="4">
					<input type="hidden" name="cant"     value="">
					<input type="hidden" name="cantTemp" value="">
				</td>
			</tr>
		</cfif>
		
		<cfset dts = "">	
		<cfif dmodo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="dts">
				<cfinvokeargument name="arTimeStamp" value="#rsFormDetalle.timestamp#"/>
			</cfinvoke>
		</cfif>
		<tr><td><input type="hidden" name="dtimestamp" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#dts#</cfoutput></cfif>"></td></tr>
		
		</table>
		</td></tr>

		<!-- ============================================================================================================ -->
		<!-- ============================================================================================================ -->		

		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		

		<!-- Caso 1: Alta de Encabezados -->
		<cfif modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline" colspan="8">
					<input type="submit" name="btnAgregarE" value="Agregar" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="btnLimpiar"  value="Limpiar" >
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->
		<cfif modo NEQ 'ALTA' and dmodo EQ 'ALTA' >
		<tr><td colspan="2">&nbsp;</td></tr>						
			<tr>
				<td align="center" valign="baseline" colspan="8">
					<input type="submit" name="btnAgregarD"  value="Agregar" onClick="javascript: setBtn(this);" >
					<cfoutput query="rsFormLineas">
						<cfif #rsFormLineas.lineas# GT 0 >
							<input type="submit" name="btnAplicar"  value="Aplicar" onClick="javascript: setBtn(this);" >
						</cfif>
					</cfoutput>
					<input type="submit" name="btnBorrarE"   value="Borrar Ajuste" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="btnLimpiar"   value="Limpiar" >
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->		
		<cfif modo NEQ 'ALTA' and dmodo NEQ 'ALTA' >
		<tr><td colspan="2">&nbsp;</td></tr>						
			<tr>
				<td align="center" valign="baseline" colspan="8">
					<input type="submit" name="btnCambiarD" value="Cambiar" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnAplicar"  value="Aplicar" onClick="javascript: setBtn(this);" >					
					<input type="submit" name="btnBorrarD"  value="Borrar Detalle" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnBorrarE"  value="Borrar Ajuste" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnNuevoD"   value="Nuevo Detalle" onClick="javascript: setBtn(this);" >					
					<input type="reset"  name="btnLimpiar"  value="Limpiar" >				
				</td>	
			</tr>
		</cfif>

		<!-- ============================================================================================================ -->
		<!-- ============================================================================================================ -->		

	</table>

</form>

<script language="JavaScript1.2">	
	
	// ===========================================================================================
	//								Conlis de Articulos
	// ===========================================================================================
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("ConlisArticulos.cfm?form=ajuste&id=aAid&desc=Adescripcion&cant=cant&cantTemp=cantTemp&AlmIni=" + document.ajuste.Aid.value ,250,200,650,350);
	}
	// ===========================================================================================


	// ===========================================================================================
	//								Validacion de campos numericos
	// ===========================================================================================

	//Devuelve el codigo ASCII de una tecla en el evento keyUp
	function Key(evento)
	 {
	 var version4 = window.Event ? true : false;
	 if (version4) { // Navigator 4.0x 
	  var whichCode = evento.which 
	 } else {// Internet Explorer 4.0x
	  if (evento.type == "keyup") { // the user entered a character
	   var whichCode = evento.keyCode
	  } else {
	   var whichCode = evento.button;
	  }
	 }
	return (whichCode)
	}
	 
	//elimina el formato numerico de una hilera, retorna la hilera
	function qf(Obj)
	{
	var VALOR=""
	var HILERA=""
	var CARACTER=""
	if(Obj.name)
	  VALOR=Obj.value
	else
	  VALOR=Obj
	for (var i=0; i<VALOR.length; i++) { 
	 CARACTER =VALOR.substring(i,i+1);
	 if (CARACTER=="," || CARACTER==" ") {
	  CARACTER=""; //CAMBIA EL CARACTER POR BLANCO
	 }  
	 HILERA+=CARACTER;
	}
	return HILERA
	}
	 
	//Formato por Randall Vargas
	//Formatea como float un valor de un campo
	//Recibe como parametro el campo y la cantidad de decimales a mostrar
	function fm(campo,ndec) {
	   var s = "";
	   if (campo.name)
		 s=campo.value
	   else
		 s=campo
	 
	   if(s=='' && ndec>0) 
	  s='0'
	 
	   var nc=""
	   var s1=""
	   var s2=""
	   if (s != '') {
		  str = new String("")
		  str_temp = new String(s)
		  t1 = str_temp.length
		  cero_izq=true
		  if (t1 > 0) {
			 for(i=0;i<t1;i++) {
				c=str_temp.charAt(i)
				if ((c!="0") || (c=="0" && ((i<t1-1 && str_temp.charAt(i+1)==".")) || i==t1-1) || (c=="0" && cero_izq==false)) {
				   cero_izq=false
				   str+=c
				}
			 }
		  }
		  t1 = str.length
		  p1 = str.indexOf(".")
		  p2 = str.lastIndexOf(".")
		  if ((p1 == p2) && t1 > 0) {
			 if (p1>0)
				str+="00000000"
			 else
				str+=".0000000"
			 p1 = str.indexOf(".")
			 s1=str.substring(0,p1)
			 s2=str.substring(p1+1,p1+1+ndec)
			 t1 = s1.length
			 n=0
			 for(i=t1-1;i>=0;i--) {
				 c=s1.charAt(i)
				 if (c == ".") {flag=0;nc="."+nc;n=0}
				 if (c>="0" && c<="9") {
					if (n < 2) {
					   nc=c+nc
					   n++
					}
					else {
					   n=0
					   nc=c+nc
					   if (i > 0)
						  nc=","+nc
					}
				 }
			 }
			 if (nc != "" && ndec > 0)
				nc+="."+s2
		  }
		  else {ok=1}
	   }
	   
	   if(campo.name) {
		if(ndec>0) {
	   campo.value=nc
		} else {
	   campo.value=qf(nc)
	  }
	   } else {
		 return nc
	   }
	}
	 
	//Funcion para validar los numeros, Autor: Ricardo Soto
	 
	function snumber(obj,e,d)
	{
	str= new String("")
	str= obj.value
	var tam=obj.size
	var t=Key(e)
	var ok=false
	 
	if(tam>d) {tam=tam-d}
	if(tam>1) {tam=tam-1}
	 
	if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;
	if(t>=16 && t<=20) return false;
	if(t>=33 && t<=40) return false;
	if(t>=112 && t<=123) return false;
	 
	if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
	if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)
	 
	if(t>=48 && t<=57)  ok=true
	if(t>=96 && t<=105) ok=true
	//if(d>=0) {if(t==188) ok=true} //LA COMA
	 
	if(d>0)
	{
	if(t==110) ok=true
	if(t==190) ok=true
	}
	 
	if(!ok) 
	{    
		str=fm(str,d)
		obj.value=str
	}
	return true
	}
	 
	////////////////////
	function decimals(str,d)
	{
	var largo=str.length      
	var punto=-1
	for(var i=0;i<str.length;i++)
	  {punto=str.indexOf('.')}
	punto++
	if(punto>0 && largo-punto>d)
	  return false
	else
	  return true 
	}
	 
	////////////////////
	function ints(str,ints)
	{
	 var largo=str.length      
	 var punto=-1
	 for(var i=0;i<str.length;i++)
	   {punto=str.indexOf('.')}
	 punto++
	 if(punto>0)
	   {str=str.substring(0,punto-1)}
	 str=strReplace(str,',','');
	 if(str.length>ints) {
	   return false;
	 } else {
	   return true;
	 }
	}
	 
	//reemplaza un string por otro dentro de una hilera, devuelve la hilera reemplazada
	function strReplace(str,oldc,newc) 
	{
	   var HILERA=""
	   var CARACTER=""
	   for (var i=0; i<str.length; i++) 
	   {
		  CARACTER=str.substring(i,i+1)
		  if (CARACTER==oldc)  
			{CARACTER=newc}
		  HILERA=HILERA+CARACTER;
	   }
	   return HILERA;
	}
	   
	// ===========================================================================================
	// ===========================================================================================
	
</script>

<script language="JavaScript1.2" type="text/javascript">
	document.ajuste.Aid.alt      = "El Almacén"
</script>

