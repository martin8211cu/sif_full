<cf_errorCode	code = "50003" msg = "Ya no se usa">
<cfinclude template="../../Utiles/sifConcat.cfm">
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

	<cfquery name="rsZonasCobro" datasource="#Session.DSN#">
		select ZCSNcodigo, ZCSNdescripcion, ZCSNid 
		from ZonaCobroSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsCategoriaSNegocios" datasource="#Session.DSN#">
		select CSNid, CSNcodigo, CSNdescripcion, CSNidPadre, CSNpath
		from CategoriaSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsGrupoSNegocios" datasource="#Session.DSN#">
		select GSNid, GSNcodigo, GSNdescripcion 
		from GrupoSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsEstadoSNegocios" datasource="#Session.DSN#">
		select ESNid, ESNcodigo, ESNdescripcion, ESNfacturacion
		from EstadoSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsMonedas" datasource="#session.DSN#">
		select a.Mcodigo, a.Mnombre
		from Monedas a, Empresas b 
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Ecodigo = b.Ecodigo
	</cfquery>
	
	<!--- Formato de Cedula Juridica de Socio de Negocio 
	<cfquery name="rsMaskCedJur" datasource="#Session.DSN#">
		select Pvalor, Mcodigo   
		from Parametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 620
	</cfquery>--->
	
	<!--- Formato de Cedula Fisica de Socio de Negocio 
	<cfquery name="rsMaskCedFis" datasource="#Session.DSN#">
		select Pvalor, Mcodigo 
		from Parametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo =630
	</cfquery>--->

	<cfquery name="rsMasks" datasource="#Session.dsn#">
		select J.Pvalor Juridica, F.Pvalor Fisica, E.Pvalor Extranjera
		from Parametros J, Parametros F, Parametros E
		where J.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and J.Pcodigo = 620
		  and F.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and F.Pcodigo = 630
          and E.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and E.Pcodigo = 5600
	</cfquery>
	
	
<cfif modo neq 'ALTA'>
	<cfquery name="rsSocios" datasource="#Session.DSN#" >
		select SNplazoentrega,SNplazocredito,LOCidioma,Ecodigo, SNcodigo, SNidentificacion, SNtiposocio, SNnombre, SNdireccion,
		 CSNid, GSNid, ESNid, DEidEjecutivo, DEidVendedor, DEidCobrador,
		 SNtelefono, SNFax, SNemail, SNFecha, SNtipo, SNvencompras, SNvenventas, SNinactivo, coalesce (ZCSNid,-1) as ZCSNid,
		 Mcodigo, SNmontoLimiteCC, SNdiasVencimientoCC, SNdiasMoraCC, SNdocAsociadoCC,
		 coalesce(SNactivoportal, 0) as SNactivoportal, SNnumero, ts_rversion, Ppais, SNcertificado, SNcodigoext, cuentac
		from SNegocios 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
		order by SNnombre asc
	</cfquery>
		
	<cfquery datasource="#session.DSN#" name="rsForm1">
		select a.SNcuentacxc as Ccuenta, b.Cdescripcion, b.Cformato
		from SNegocios a, CContables b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >
		  and a.SNcuentacxc=b.Ccuenta
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsForm2">
		select a.SNcuentacxp as Ccuenta, b.Cdescripcion, b.Cformato
		from SNegocios a, CContables b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
		  and a.SNcuentacxp=b.Ccuenta
	</cfquery>
	
	<cfquery name="rsUsuario" datasource="#Session.DSN#" >
		select EUcodigo
		from SNegocios 
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
	</cfquery>
	
	<cfquery name="rsCuentasSocios" datasource="#Session.DSN#">
		select b.CCTcodigo, b.CCTdescripcion, c.Ccuenta, c.Cdescripcion, c.Cformato
		from CuentasSocios a, CCTransacciones b, CContables c
		Where a.CCTcodigo = b.CCTcodigo
		and a.Ecodigo = b.Ecodigo
		and a.Ccuenta = c.Ccuenta
		and a.Ecodigo = c.Ecodigo
		and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
	</cfquery>	
	<cfquery name="rsListaPrecios" datasource="#Session.DSN#">
		select 
			b.LPid, 
			b.LPdescripcion,
			a.SNcodigo, 
			a.ts_rversion
		from EListaPrecios b
			left outer join SNegocios a
				on a.Ecodigo = b.Ecodigo
				and a.LPid = b.LPid
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by b.LPdescripcion
	</cfquery>	
<cfelse>
	<cfquery name="rsListaPrecios" datasource="#Session.DSN#">
		select 
			b.LPid, 
			b.LPdescripcion,
			null as SNcodigo
		from EListaPrecios b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by b.LPdescripcion
	</cfquery>	
</cfif> <!--- modo cambio --->
<!--- Listas de Precios del Socio --->

<cfquery name="rsNumero" datasource="#session.DSN#">
    select SNnumero 
	from SNegocios
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) gt 0>
		and SNcodigo <> #form.SNcodigo#
	</cfif>
</cfquery>

<cfquery name="rsIdiomas" datasource="sifcontrol">
	select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>

<cfquery name="rsIdentificacion" datasource="#session.DSN#">
    select SNidentificacion 
	from SNegocios
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) gt 0>
		and SNcodigo <> #form.SNcodigo#
	</cfif>
</cfquery>
<!--- ****** Lista de paises **********************************  --->
<cfquery name="rsPaises" datasource="asp">
	select Ppais, Pnombre
	from Pais
</cfquery>

<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--

function doConlisTransacciones(sncod){
		popUpWindow("conlisTransacciones.cfm?form=form&cctdesc=CCTdescripcion&cctcod=CCTcodigo&sncod="+sncod,250,200,650,350);
}

function validar_numeros(obj){
	obj.value = trim(obj.value);
	<cfoutput query="rsNumero">
		var valor = '#Trim(rsNumero.SNnumero)#'
		if (obj.value == valor){
			alert("Número de Socio ya existe.");
			obj.focus();
			return false;
		}
	</cfoutput>
	return true;
}

function validar_identificacion(obj){
	obj.value = trim(obj.value);
	<cfoutput query="rsIdentificacion">
		var valor = '#Trim(rsIdentificacion.SNidentificacion)#'
		if (obj.value == valor){
			alert("Identificación ya existe.");
			obj.focus();
			return false;
		}
	</cfoutput>
	return true;
}

function Contactos(data) {
	if (data!="") {
		document.form.action='Contactos.cfm';
		document.form.submit();
	}
	return false;
}

function TipoSocio(){
 	 if((!document.form.SNtiposocioC.checked) && (!document.form.SNtiposocioP.checked)){
	 	 alert ("Debe indicar el tipo de Socio de Negocios.")    
		 return false;    	
	 }
}
 
function botones( pdiv, ver ){
	if ( MM_findObj(pdiv) ){
		var div = document.getElementById(pdiv)
		div.style.display  = (ver == 0 ? 'none' : '');
	}
}

// ========================================================================================================
var valor = ""

function valido(origen){
	for(var i=0; i<origen.length-1; i++){
		if ( origen.charAt(i)=='-' && i != 3 ){
			return false;
		}
	}
	return true;
}

function formato(obj){
	if (obj.value != ""){
		var origen = new String(obj.value);
		if (origen.length < 8 || origen.charAt(3) != '-' || !valido(origen) ){
			alert('El Numero de Socio debe tener el formato XXX-XXXX');
			obj.focus();
			return false;
		}
		validar_numeros(obj);
	}	
}

function anterior(obj, e, d){
	valor = obj.value;
}

//Permite solamente digitar numeros (se usa en el evento onKeyUp)
function mascara(obj,e,d){
	str= new String("")
	str= obj.value
	var tam=obj.size
	var t=Key(e)
	var ok=false
	
	if(tam>d) {tam=tam-d}
	if(tam>1) {tam=tam-1}
	 
	/* ============================================ */
	// valida que no pueda borrar el '-'
	if ( (t==46 || t==8) && obj.value.length != 0 ){
	//alert('1')
		if ( obj.value.charAt(3) != '-' ){
			obj.value = valor;
		}
	}
	/* ============================================ */

	if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;
	if(t>=16 && t<=20) return false;
	if(t>=33 && t<=40) return false;
	if(t>=112 && t<=123) return false;

	if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
	if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)
	 
	if(t==109) ok = false;  // nuevo por jgr
	if(t>=48 && t<=57)  ok=true
	if(t>=96 && t<=105) ok=true

	if(t==189) ok=true

	if(d>0){
		if(t==110) ok=true
		if(t==190) ok=true
	}
	 
	// validaciones para mascara XXX-XXXX

	// inserta un '-' cuando la posicio es 3
	if (obj.value.length == 3 ){
		obj.value = obj.value + '-';

		if ( obj.value.charAt(2) == '-' ){
			obj.value = valor;
		}
	}

	if (obj.value.length < 3 ){
		if ( obj.value.charAt(1) == '-' || obj.value.charAt(2) == '-' ){
			obj.value = valor;
		}
	}
	
	if (obj.value.length > 3 ){
		if ( obj.value.charAt(3) != '-' ){
			obj.value = valor;
		}
	}

	if(!ok){
		obj.value = valor;
	}
	return true
}

function set_visibility(nombre,visible){
	var objref = document.all ? document.all[nombre] : document.getElementById(nombre);
	if (objref) {
		//objref.style.visibility = visible ? 'visible' : 'hidden';
		objref.style.display = visible ? 'inline' : 'none';
	}
}
function click_tiposocio(f){
	set_visibility('trCuentaCC1', f.SNtiposocioC.checked);
	set_visibility('trCuentaCC2', f.SNtiposocioC.checked);
	set_visibility('trCuentaCC3', f.SNtiposocioC.checked);
	set_visibility('trCuentaCC4', f.SNtiposocioC.checked);
	set_visibility('trCuentaCC5', f.SNtiposocioC.checked);
	set_visibility('trCuentaCP1', f.SNtiposocioP.checked);
	set_visibility('trCuentaCP2', f.SNtiposocioP.checked);
}

//-->
</script>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
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
  } 
  
  // modificado para que valide que los checks de tipo vengan marcados
  if (!(document.form.SNtiposocioC.checked || document.form.SNtiposocioP.checked)){
  	errors +=  '- Debe indicar el Tipo de Socio.\n';
  }
  
  if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->

function socio_generico(){
	// no se puede borrar el SN generico
	<cfif modo neq 'ALTA'>
		<cfif rsSocios.SNcodigo eq '9999' >
			return true;
		<cfelse>
			return false;
		</cfif>
	<cfelse>
		return false;
	</cfif>	
}

function validar(form){
	if ( form.botonSel.value != 'Baja' && form.botonSel.value != 'Nuevo' ){
		MM_validateForm('SNnumero', '', 'R', 'SNidentificacion','','R','SNnombre','','R','SNemail','','NisEmail','SNvencompras','','RisNum','SNvenventas','','RisNum','SNFecha','','R');
		return document.MM_returnValue
	}
	else{ 
		if (form.botonSel.value == 'Baja' && socio_generico() ) {
			alert('El Socio de Negocios Genérico no puede ser eliminado.');
			return false;
		}
		else{
			return true;
		}
	}
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

<cf_templatecss>
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>

<body>

<form action="SQLSocios.cfm" method="post" name="form" onSubmit="return validar(this);">

<table width="464" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
	  <td colspan="3" align="left" valign="baseline" class="tituloListas subTitulo" nowrap>Datos Generales </td>
	  <td width="9">&nbsp;</td>
    </tr>
	<tr>
	  <td width="12" align="right" valign="baseline" nowrap>&nbsp;</td>
	  <td width="172">N&uacute;mero de Socio:&nbsp;</td>
      <td width="271">&nbsp;</td>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="baseline" nowrap>&nbsp;</td>
		
		<td><cfoutput>
			<input type="text" size="10" maxlength="8" name="SNnumero" value="<cfif modo neq 'ALTA'>#Trim(rsSocios.SNnumero)#</cfif>"
				   onFocus="javascript:this.select();"	
				   onBlur="javascript:formato(this);"
				   onKeyDown="javascript:anterior(this,event,0);"
				   onKeyUp="javascript:mascara(this,event,0);"
				   alt="El N&uacute;mero de Socio" >&nbsp; <b>XXX-XXXX</b>	
		</td>
	    <td><input type="checkbox" name="SNinactivo" id="SNinactivo" <cfif modo NEQ "ALTA" and rsSocios.SNcodigo eq 9999 >disabled</cfif> value="1" 
			<cfif modo NEQ "ALTA" and rsSocios.SNinactivo EQ 1>checked</cfif>>
          <label for="SNinactivo">Inactivo</label></td>
	    <td>&nbsp;</td>
	</tr>

	<tr>
	  <td align="right" valign="baseline" nowrap>&nbsp;</td>
	  <td colspan="2" valign="baseline" >Nombre:&nbsp;</td>
      <td valign="baseline" >&nbsp;</td>
	</tr>
	<tr> 
		<td align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline">
			<input type="text" name="SNnombre" size="75" style="width:400px" maxlength="255" <cfif #modo# NEQ "ALTA">readonly</cfif> value="<cfif modo NEQ "ALTA">#Trim(rsSocios.SNnombre)#</cfif>" onFocus="javascript:this.select();"  alt="El campo Nombre del Socio">
			</td></cfoutput>
		
      <td valign="baseline" >&nbsp;</td>
	</tr>

	<tr>
	  <td valign="baseline" nowrap>&nbsp;</td>
	  <td valign="baseline" >Tipo&nbsp;de<br>persona:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C&eacute;dula o Identificaci&oacute;n:</td>
      <td valign="baseline" >&nbsp;</td>
	</tr>
	<tr>
		<td valign="baseline" nowrap><div align="right"></div></td>
		
		<cfoutput>
	    <td valign="baseline" colspan="2">
		<cfif #modo# EQ "ALTA"> <!--- se manda el campo como hiden para poder deshabilitarlo en cambio --->
			<cfset LvarSNtipo = rsMasks.Fisica>
			<select name="SNtipo" onFocus="this.blur()" onChange="javascript: cambiarMascara(this.value);">
				<option value="F" <cfif (isDefined("rsSocios.SNtipo") AND "F" EQ rsSocios.SNtipo)>selected</cfif>>F&iacute;sico</option>
				<option value="J" <cfif (isDefined("rsSocios.SNtipo") AND "J" EQ rsSocios.SNtipo)>selected</cfif>>Jur&iacute;dico</option>
				<option value="E" <cfif (isDefined("rsSocios.SNtipo") AND "E" EQ rsSocios.SNtipo)>selected</cfif>>Extranjero</option>
	        </select>
		<cfelse>
			<cfif (isDefined("rsSocios.SNtipo") AND "F" EQ rsSocios.SNtipo)>
				<cfset LvarSNtipo = rsMasks.Fisica>
				<input type="hidden" value="F" name="SNtipo">
				<strong>F&iacute;sico&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>
			<cfelseif (isDefined("rsSocios.SNtipo") AND "J" EQ rsSocios.SNtipo)>
				<cfset LvarSNtipo = rsMasks.Juridica>
				<input type="hidden" value="J" name="SNtipo">
				<strong>Jur&iacute;dico&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>
			<cfelseif (isDefined("rsSocios.SNtipo") AND "E" EQ rsSocios.SNtipo)>
				<cfset LvarSNtipo = rsMasks.Extranjera>
				<input type="hidden" value="E" name="SNtipo">
				<strong>Extranjero&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>
			</cfif>
		</cfif>
		&nbsp;&nbsp;
		<cfoutput>
		<input type="text" name="SNidentificacion" size="50" <cfif #modo# NEQ "ALTA">readonly</cfif>  value="<cfif #modo# NEQ "ALTA">#trim(rsSocios.SNidentificacion)#</cfif>" onFocus="javascript:this.select();" >
		<input type="text" name="SNmask" size="50" readonly value="#LvarSNtipo#" style="border:none;">
		</cfoutput>  
		</td>
		
	    <td valign="baseline" >&nbsp;</td>
	</tr>

	<tr>
	  <td valign="baseline" align="right" nowrap>&nbsp;</td>
	  <td valign="baseline">Tel&eacute;fono:</td>
      <td valign="baseline">Fax:&nbsp;</td>
      <td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
		<td valign="baseline" align="right" nowrap>&nbsp;</td>
		<td valign="baseline"> 
			<input name="SNtelefono" type="text" size="30" maxlength="30" value="<cfif #modo# NEQ "ALTA">#trim(rsSocios.SNtelefono)#</cfif>" onFocus="javascript:this.select();" alt="El campo Teléfono del Socio">
		</td>
	    <td valign="baseline"><input name="SNFax" type="text" onFocus="javascript:this.select();" value="<cfif modo NEQ "ALTA">#trim(rsSocios.SNFax)#</cfif>" size="30" maxlength="30" alt="El campo Fax del Socio "></td>
	    <td valign="baseline">&nbsp;</td>
	</tr>

	<tr>
	  <td align="right" valign="baseline" nowrap>&nbsp;</td>
	  <td colspan="2" valign="baseline">Correo electr&oacute;nico </td>
      <td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
		<td height="26" align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline"> 
			<input name="SNemail" type="text" size="75" style="width:400px"  maxlength="100" onBlur="return document.MM_returnValue" value="<cfif modo NEQ "ALTA">#Trim(rsSocios.SNemail)#</cfif>" onFocus="javascript:this.select();" alt="El campo E-Mail del Socio ">
		</td>
	    <td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="baseline" nowrap>&nbsp;</td>
	  <td colspan="2" valign="baseline">C&oacute;digo Externo </td>
      <td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
		<td height="26" align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline"> 
			<input name="SNcodigoext" type="text" size="30"  maxlength="25" value="<cfif modo NEQ "ALTA">#Trim(rsSocios.SNcodigoext)#</cfif>" ><!---- onFocus="javascript:this.select();" ----->
		</td>
	    <td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
	  	<td align="right" valign="baseline" nowrap>&nbsp;</td>
	  	<td colspan="2" valign="baseline">Pa&iacute;s </td>
      	<td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
		<td height="26" align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline"> 
			<select name="LPaises" id="LPaises">
            	<option value="">- No especificado -</option> 
            		<cfloop query="rsPaises">
              			<option value="#rsPaises.Ppais#" <cfif modo NEQ 'ALTA' and rsPaises.Ppais EQ rsSocios.Ppais>selected</cfif>>#HTMLEditFormat(rsPaises.Pnombre)#</option></cfloop>
          	</select></td>			
	    <td valign="baseline">&nbsp;</td>
	</tr>
	
	<tr>
		<td height="26" align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline"> 	
			<input type="checkbox" name="SNcertificado" id="SNcertificado" <cfif modo NEQ "ALTA" and rsSocios.SNcertificado eq 9999 >disabled</cfif> value="1" 
			<cfif modo NEQ "ALTA" and rsSocios.SNcertificado EQ 1>checked</cfif>>
          <label for="SNinactivo">Certificado ISO </label></td>
		 </td>
	</tr>
	
	<cfif modo neq 'ALTA'>
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"/>
		<cfset usuario_existente = sec.getUsuarioByRef(form.SNcodigo, Session.EcodigoSDC, 'SNegocios')>
	  <cfif usuario_existente.RecordCount>
	  	<cfif usuario_existente.Utemporal>
			<cfset el_login='Temporal'>
		<cfelseif not usuario_existente.Uestado>
			<cfset el_login='Inactivo. Consulte con el administrador de la seguridad'>
		<cfelse>
			<cfset el_login=usuario_existente.Usulogin>
		</cfif>
	  <cfelse>
	  	<cfset el_login='No se ha asignado usuario'>
	  </cfif>
	  
	  <tr>
	    <td valign="middle" nowrap align="right">&nbsp;</td>
	    <td height="24" valign="middle">Usuario asignado:</td>
        <td height="24" valign="middle">&nbsp;#HTMLEditFormat(el_login)#</td>
        <td valign="middle">&nbsp;</td>
	  </tr>
    </cfif>

	<tr>
	  <td valign="baseline" align="right">&nbsp;</td>
	  <td colspan="2" valign="baseline">Fecha:&nbsp;</td>
      <td valign="baseline">&nbsp;</td>
	</tr>
	<tr> 
		<td valign="baseline" align="right">&nbsp;</td>
		<td colspan="2" valign="baseline"> 
			<input type="text" name="SNFecha" readonly="" size="12" value="<cfif #modo# NEQ "ALTA">#LSDateFormat(rsSocios.SNFecha, 'dd/mm/yyyy')#<cfelse>#LSDateFormat(Now(),"DD/MM/YYYY")#</cfif>" alt="El campo Fecha de inclusión del Socio">
		</td>
	    <td valign="baseline">&nbsp;</td>
	</tr>
	
	<tr>
	  <td align="right" nowrap>&nbsp;</td>
	  <td>Vencimiento para Compras:</td>
      <td>Vencimiento para Ventas:</td>
      <td>&nbsp;</td>
	</tr>
	<tr> 
		<td align="right" nowrap>&nbsp;</td>
		<td> 
			<input type="text" name="SNvencompras" value="<cfif #modo# NEQ "ALTA">#rsSocios.SNvencompras#</cfif>" size="5"  style="text-align: right;" onBlur="javascript:fm(this,-1); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo Vencimiento Compras del Socio">&nbsp;(d&iacute;as)
		</td>
	    <td><input type="text" name="SNvenventas" value="<cfif #modo# NEQ "ALTA">#rsSocios.SNvenventas#</cfif>" size="5" style="text-align: right;" onBlur="javascript:fm(this,-1); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo Vencimiento Ventas del Socio">
        &nbsp;(d&iacute;as) </td>
	    <td>&nbsp;</td>
	</tr>	
	<tr>
	  <td align="right" nowrap>&nbsp;</td>
	  <td>Plazo de Entrega :</td>
      <td>Plazo de Cr&eacute;dito :</td>
      <td>&nbsp;</td>
	</tr>	
	<tr> 
		<td align="right" nowrap>&nbsp;</td>
		<td> 
			<input type="text" name="SNplazoentrega" value="<cfif #modo# NEQ "ALTA">#rsSocios.SNplazoentrega#</cfif>" size="5"  style="text-align: right;" onBlur="javascript:fm(this,-1); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Plazo de entrega">&nbsp;(d&iacute;as)
		</td>
	    <td><input type="text" name="SNplazocredito" value="<cfif #modo# NEQ "ALTA">#rsSocios.SNplazocredito#</cfif>" size="5" style="text-align: right;" onBlur="javascript:fm(this,-1); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Plazo de Cr&eacute;dito">
        &nbsp;(d&iacute;as) </td>
	    <td>&nbsp;</td>
	</tr>					
	<tr>
	  <td align="right" valign="baseline" nowrap>&nbsp;</td>
	  <td colspan="2" valign="baseline" >Idioma:&nbsp;</td>
      <td valign="baseline" >&nbsp;</td>
	</tr>
	<tr> 
		<td align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline" >
			<select name="LOCIdioma" id="LOCIdioma">
				<option value="-1">-- Ninguno --</option>			
            	<cfloop query="rsIdiomas">
              		<option value="#rsIdiomas.LOCIdioma#" <cfif modo NEQ 'ALTA' and rsIdiomas.LOCIdioma EQ rsSocios.LOCIdioma>selected</cfif>>#HTMLEditFormat(rsIdiomas.LOCIdescripcion)#</option>
				</cfloop>
          	</select>
		</td>
      <td valign="baseline" >&nbsp;</td>
	</tr>	
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td colspan="2">Direcci&oacute;n:&nbsp;</td>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td colspan="2">
			<textarea name="SNdireccion" cols="75" rows="3"  alt="El campo Dirección del Socio" style="width:400px;font-family:Arial, Helvetica, sans-serif;font-size:10px " onFocus="javascript:this.select();"><cfif #modo# NEQ "ALTA">#trim(rsSocios.SNdireccion)#</cfif></textarea>
		</td>
	    <td>&nbsp;</td>
	</tr><!--- 0 --->
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td colspan="2">Categoría del Socio de Negocios:&nbsp;</td>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td colspan="2"> 
			<cfif modo neq 'ALTA' and rsSocios.CSNid gt 0>
			
			<cfquery name="rsClasificacion" datasource="#session.DSN#">
				select CSNid as CSNid, CSNcodigo, CSNdescripcion, CSNpath as path
				from CategoriaSNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and CSNid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.CSNid#">
			</cfquery>
				<cf_sifcategoriassn form ="form" query="#rsClasificacion#" id="CSNid" name="CSNcodigo" 
						desc="CSNdescripcion" catalogo="1"  >
			<cfelse>
				<cf_sifcategoriassn form ="form" id="CSNid" name="CSNcodigo" desc="CSNdescripcion" catalogo="1">
			</cfif>
		</td>
	    <td>&nbsp;</td>
	</tr><!--- * --->
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td colspan="1">Grupo Socio de Negocios:&nbsp;</td>
      <td>Estado Socio de Negocios:&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td colspan="1"> 
		<cfif modo neq 'ALTA' and rsSocios.GSNid gt 0>
			<cfquery name="rsGrupoSNCon" datasource="#session.DSN#">
				select a.GSNid, a.GSNcodigo, a.GSNdescripcion 
				from GrupoSNegocios a, GrupoSNegocios b
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and b.GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.GSNid#">
					and a.Ecodigo = b.Ecodigo
					and a.GSNid = b.GSNid			
			</cfquery>

			<cf_sifGrupoSN form ="form" query =#rsGrupoSNCon#>		
		<cfelse>
			<cf_sifGrupoSN form ="form">
		</cfif>
		</td>
	    <td><select name="ESNid" id="ESNid">
				<option value="-1">-- Ninguno --</option>			
            	<cfloop query="rsEstadoSNegocios">
              		<option value="#rsEstadoSNegocios.ESNid#" <cfif modo NEQ 'ALTA' and rsEstadoSNegocios.ESNid EQ rsSocios.ESNid>selected</cfif>>#HTMLEditFormat(rsEstadoSNegocios.ESNdescripcion)#</option>
				</cfloop>
          	</select>
		</td>
	</tr><!--- ** --->
	<!--- *** --->
	<tr><!---  --->
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td colspan="2">Zona de Cobro:&nbsp;</td>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td colspan="2"> 
		<cfif modo neq 'ALTA' and rsSocios.ZCSNid gt 0>
			<cfquery name="rsZonaCobroCon" datasource="#session.DSN#">
				select a.ZCSNcodigo, a.ZCSNdescripcion, a.ZCSNid 
				from ZonaCobroSNegocios a, SNegocios b
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and b.ZCSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.ZCSNid#">
					and a.Ecodigo= b.Ecodigo
					and a.ZCSNid = b.ZCSNid
			</cfquery>
			
			<cf_sifZonaCobro form="form" query =#rsZonaCobroCon#>
		<cfelse>
			<cf_sifZonaCobro form="form">
		</cfif>
		</td>
	    <td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td colspan="1">Cobrador:&nbsp;</td>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td>
		 	<cfif modo neq 'ALTA' and rsSocios.DEidCobrador gt 0>	
				
				<cfquery name="rsEmpleado1" datasource="#session.DSN#">
				 select a.DEid as DEid1, a.NTIcodigo as NTIcodigo1, a.DEidentificacion as DEidentificacion1, 
						a.DEapellido1 #_Cat# ' ' #_Cat# a.DEapellido2 #_Cat# ', ' #_Cat# a.DEnombre as NombreEmp1
					from DatosEmpleado a, RolEmpleadoSNegocios b
					where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.DEidCobrador#">
					<!---   and a.DEid = b.DEid --->
					  and a.Ecodigo = b.Ecodigo
				</cfquery>
				
				<cf_rhempleadoCxC rol=1 form='form' size=45 index=1 query=#rsEmpleado1#>
			<cfelse>
				 <cf_rhempleadoCxC rol=1 form='form' index=1 size=45>
			</cfif>	
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td colspan="1">Vendedor:&nbsp;</td>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td>
		 	<cfif modo neq 'ALTA' and rsSocios.DEidVendedor gt 0>	
				<cfquery name="rsEmpleado2" datasource="#session.DSN#">
				select a.DEid as DEid2, a.NTIcodigo as NTIcodigo2, a.DEidentificacion as DEidentificacion2, 
					a.DEapellido1 #_Cat# ' ' #_Cat# a.DEapellido2 #_Cat# ', ' #_Cat# a.DEnombre as NombreEmp2
				from DatosEmpleado a, RolEmpleadoSNegocios b
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.DEidVendedor#">
					<!--- and a.DEid = b.DEid --->
					and a.Ecodigo = b.Ecodigo
				</cfquery>
				<cf_rhempleadoCxC rol=2 form='form' index=2 size=45 query=#rsEmpleado2#>
			<cfelse>
				<cf_rhempleadoCxC rol=2 form='form' index=2 size=45>
			</cfif>	
		</td>
		<td>&nbsp;</td>
	</tr><!---  --->
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td colspan="1">Ejecutivo de Cuenta:&nbsp;</td>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td>
		 	<cfif modo neq 'ALTA' and rsSocios.DEidEjecutivo gt 0>	
				<cfquery name="rsEmpleado3" datasource="#session.DSN#">
				 select a.DEid as DEid3, a.NTIcodigo as NTIcodigo3, a.DEidentificacion as DEidentificacion3, 
					a.DEapellido1 #_Cat# ' ' #_Cat# a.DEapellido2 #_Cat# ', ' #_Cat# a.DEnombre as NombreEmp3
				from DatosEmpleado a, RolEmpleadoSNegocios b
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.DEidEjecutivo#">
					<!--- and a.DEid = b.DEid --->
					and a.Ecodigo = b.Ecodigo
				</cfquery>
				<cf_rhempleadoCxC rol=3 form='form' index=3 size=45 query=#rsEmpleado3#>
			<cfelse>
				<cf_rhempleadoCxC rol=3 form='form' index=3 size=45>
			</cfif>	
		</td>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
	  <td valign="baseline" align="right">&nbsp;</td>
	  <td colspan="2" valign="baseline">Complemento para Compras/Ventas con Servicios:&nbsp;</td>
      <td valign="baseline">&nbsp;</td>
	</tr>
	<tr> 
		<td valign="baseline" align="right">&nbsp;</td>
		<td colspan="2" valign="baseline"> 
			<input type="text" name="cuentac" size="12" maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsSocios.cuentac#</cfif>" alt="Complemento para Compras/Ventas con Servicios">
		</td>
	    <td valign="baseline">&nbsp;</td>
	</tr>
		<tr>
		  <td colspan="3" class="subTitulo tituloListas">
			<input type="checkbox" name="SNtiposocioC" id="SNtiposocioC" value="1" onClick="click_tiposocio(this.form)"
				<cfif modo is "ALTA" or ListFind('A,C', rsSocios.SNtiposocio)> checked </cfif> >
			<label for="SNtiposocioC">Este Socio es Cliente de #session.Enombre# </label></td>
		  <td>&nbsp;</td>
    </tr>
		<tr id="trCuentaCC1" <cfif modo neq "ALTA" and rsSocios.SNtiposocio is 'P'> style='display:none' </cfif> >
		  <td align="right">&nbsp;</td>
		  <td>Lista de Precios </td>
		  <td><select name="LPid" id="LPid">
            <option value="">- Usar predeterminada del sistema -</option>
            <cfloop query="rsListaPrecios">
              <option value="#rsListaPrecios.LPid#" <cfif Len(rsListaPrecios.SNcodigo)>selected</cfif>>#HTMLEditFormat(rsListaPrecios.LPdescripcion)#</option>
            </cfloop>
          </select></td>
		  <td>&nbsp;</td>
    </tr>
		<tr id="trCuentaCC2" <cfif modo neq "ALTA" and rsSocios.SNtiposocio is 'P'> style='display:none' </cfif> >
		  <td align="right">&nbsp;</td>
		  <td colspan="2">Cuenta predeterminada para Cuentas por Cobrar:&nbsp;</td>
          <td>&nbsp;</td>
	</tr>
		<tr id="trCuentaCC3" <cfif modo neq "ALTA" and rsSocios.SNtiposocio is 'P'> style='display:none' </cfif> >
			<td align="right">&nbsp;</td>
			<td colspan="2">
				<cfif modo NEQ 'ALTA' and rsForm1.RecordCount gt 0 >
					<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame1" auxiliares="N" movimiento="S" form="form" ccuenta="SNcuentacxc" cdescripcion="DSNcuentacxc" cformato="FSNcuentacxc" query="#rsForm1#">
				<cfelse>
					<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame1" auxiliares="N" movimiento="S" form="form" ccuenta="SNcuentacxc" cdescripcion="DSNcuentacxc" cformato="FSNcuentacxc">
				</cfif>
			</td>
		    <td>&nbsp;</td>
		</tr>
		<tr id="trCuentaCC4" <cfif modo neq "ALTA" and rsSocios.SNtiposocio is 'P'> style='display:none' </cfif> >
		  <td align="right">&nbsp;</td>
		  <td colspan="2" class="subTitulo tituloListas">Contabilizaci&oacute;n de Transacciones de CxC</td>
		  <td>&nbsp;</td>
    </tr>
		<tr id="trCuentaCC5" <cfif modo neq "ALTA" and rsSocios.SNtiposocio is 'P'> style='display:none' </cfif> >
		  <td align="right">&nbsp;</td>
		  <td colspan="2" ><cfif modo NEQ "ALTA" >
<table width="433" border="0" align="center" cellpadding="0" cellspacing="0" id="trAsignar">

<tr><td width="18"></td><td width="400"><cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Asignaci&oacute;n de Cuentas'>
<cfinclude template="SocioCuentas.cfm">
<cf_web_portlet_end>	</td>
  <td width="10">&nbsp;</td>
</tr>
</table>

	</cfif> <!--- Modo ---></td>
		  <td>&nbsp;</td>
    </tr>
	<tr>
	  	<td colspan="3" class="subTitulo tituloListas">
			<input type="checkbox" name="SNtiposocioP" id="SNtiposocioP" value="1" onClick="click_tiposocio(this.form)"
				<cfif modo is "ALTA" or ListFind('A,P', rsSocios.SNtiposocio)> checked </cfif> >
			<label for="SNtiposocioP">Este Socio es Proveedor de #session.Enombre# </label></td>
	 	 <td>&nbsp;</td>
    </tr>
	<tr id="trCuentaCP1" <cfif modo neq "ALTA" and rsSocios.SNtiposocio is 'C'> style='display:none' </cfif> >
	  	<td align="right">&nbsp;</td>
	  	<td colspan="2">Cuenta predeterminada para Cuentas por Pagar:&nbsp;</td>
	  	<td>&nbsp;</td>
	</tr>
	<tr id="trCuentaCP2" <cfif modo neq "ALTA" and rsSocios.SNtiposocio is 'C'> style='display:none' </cfif> >
		<td align="right">&nbsp;</td>
		<td colspan="2">
			<cfif modo NEQ 'ALTA' and rsForm2.RecordCount gt 0 >
				<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame2" auxiliares="N" movimiento="S" form="form" ccuenta="SNcuentacxp" cdescripcion="DSNcuentacxp" cformato="FSNcuentacxp" query="#rsForm2#">
			<cfelse>
				<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame2" auxiliares="N" movimiento="S" form="form" ccuenta="SNcuentacxp" cdescripcion="DSNcuentacxp" cformato="FSNcuentacxp">
			</cfif>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<fieldset><legend>L&iacute;mite Financiero</legend> 
			<table border="0" width="100%" cellpadding="0" cellspacing="0">
				<tr>
				  <td align="right" valign="middle" nowrap>&nbsp;</td>
				  <td colspan="1">Moneda:&nbsp;</td>
				  <td>&nbsp;</td>
				</tr>
				<tr>
					<td align="right">&nbsp;</td>
					<td>
						<select name="Mcodigo" id="Mcodigo">
							<option value="-1">-- Ninguno --</option>			
							<cfloop query="rsMonedas">
								<option value="#rsMonedas.Mcodigo#"<cfif modo NEQ 'ALTA' and rsMonedas.Mcodigo EQ rsSocios.Mcodigo>selected</cfif>>#HTMLEditFormat(rsMonedas.Mnombre)#</option>
							</cfloop>
						</select>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
				  	<td align="right" valign="middle" nowrap>&nbsp;</td>
				  	<td colspan="1">Monto L&iacute;mite:&nbsp;</td>
				  	<td>&nbsp;</td>
				</tr>
	
				<tr>
					<td align="right">&nbsp;</td>
					<td>
						<input name="SNmontoLimiteCC" type="text" size="20" maxlength="20" value="<cfif modo NEQ 'ALTA' and rsSocios.SNmontoLimiteCC GT 0>#HTMLEditFormat(rsSocios.SNmontoLimiteCC)#</cfif>">
					</td>
					<td>&nbsp;</td>
				</tr>
				
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
				  	<td align="right" valign="middle" nowrap>&nbsp;</td>
				  	<td colspan="1">D&iacute;a(s)&nbsp;Mora:&nbsp;</td>
				  	<td>D&iacute;a(s)&nbsp;Vencimiento:&nbsp;</td>
				</tr>
	
				<tr>
					<td align="right">&nbsp;</td>
					<td>
						<input name="SNdiasMoraCC" type="text" size="10" maxlength="5" value="<cfif modo NEQ 'ALTA' and rsSocios.SNdiasMoraCC GT 0>#HTMLEditFormat(rsSocios.SNdiasMoraCC)#</cfif>">
					</td>
					<td>
						<input name="SNdiasVencimientoCC" type="text" size="10" maxlength="5" value="<cfif modo NEQ 'ALTA' and rsSocios.SNdiasVencimientoCC GT 0>#HTMLEditFormat(rsSocios.SNdiasVencimientoCC)#</cfif>">
					</td>
				</tr>
			
			</table>
			</fieldset>
		</td>
		<td valign="bottom" align="center"><cfif modo neq 'ALTA'><input name="AlmObjecto" type="button" value="Almacenar Objetos" onClick="javascript:AlmacenarObjetos('rsSocios.SNcodigo');"></cfif></td>
	</tr>

<tr><td colspan="4" align="right" valign="baseline" nowrap>&nbsp;</td></tr>

	<!--- Botones --->
	<tr> 
		<td colspan="4" align="right" valign="baseline" nowrap> 
			<div align="center"> 
				<!--- Sustituye al portlet de botones, para agregar un boton mas --->
					<cfinclude template="/sif/portlets/pBotones.cfm">
					<cfif modo neq 'ALTA'>
					<input name="btnContactos" type="button" value="Contactos" onClick="javascript:Contactos('#JSStringFormat(rsSocios.SNcodigo)#')">
					<input name="btnActivarUsuario" type="button" value="Activar como Usuario" onClick="location.href='SociosActivar.cfm?SNcodigo=#rsSocios.SNcodigo#'">
<!---  *************************************************************************** --->				
					<input name="btnAnotaciones" type="button" value="Anotaciones" onClick="location.href='Anotaciones.cfm?SNcodigo=#rsSocios.SNcodigo#'">
<!---  *************************************************************************** --->
					</cfif>
				<!--- portlet botones--->
			</div>
		</td>
	</tr>
	<tr>
	  <td colspan="4" align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsSocios.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
    	</cfif>
  	<input type="hidden" name="SNcodigo" value="<cfif modo NEQ "ALTA">#rsSocios.SNcodigo#</cfif>">
	
</table>
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">
	var f = document.form;
	<cfoutput>
	var oCedulaMask = new Mask("#replace(LvarSNtipo,'X','##','ALL')#", "string");
	oCedulaMask.attach(document.form.SNidentificacion, oCedulaMask.mask, "string");

	function cambiarMascara(v) 
	{
		document.form.SNidentificacion.value = "";
		if (v == 'F')
		{
			oCedulaMask.mask = "#replace(rsMasks.Fisica,'X','##','ALL')#";
			document.form.SNmask.value = "#rsMasks.Fisica#";
		}
		else if (v == 'J')
		{
			oCedulaMask.mask = "#replace(rsMasks.Juridica,'X','##','ALL')#";
			document.form.SNmask.value = "#rsMasks.Juridica#";
		}
		else if (v == 'E')
		{
			oCedulaMask.mask = "#replace(rsMasks.Extranjera,'X','##','ALL')#";
			document.form.SNmask.value = "#rsMasks.Extranjera#";
		}
	}
	</cfoutput>

	<cfif modo neq 'ALTA'>
		//usuario(f.SNtiposocioP);

		<cfif rsSocios.SNtiposocio NEQ "P"> 
			function Editar(data) {
				f.datos.value = data;
			}
			function Editar2(data) {
				f.datos2.value = data;
			}
			f.CCTcodigo.alt = "El campo Transacción";
			f.Ccuenta.alt = "El campo Cuenta";
			f.LPid.alt = "El campo Lista de Precio";
		</cfif>
	</cfif>
	
	function AlmacenarObjetos(valor){
		if (valor != "") {
			document.form.action = 'ObjetosSN.cfm';
			document.form.submit();
		}
			return false;
	}	
</script>


