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

<cfif isDefined("session.Ecodigo") and isDefined("Form.SNcodigo") and len(trim(#Form.SNcodigo#)) NEQ 0>
	<cfquery name="rsSocios" datasource="#Session.DSN#" >
		select Ecodigo, SNcodigo, SNidentificacion, SNtiposocio, SNnombre, SNdireccion, SNtelefono,   
		SNFax, SNemail, convert(varchar,SNFecha,103) as SNFecha, SNtipo, SNvencompras, SNvenventas, SNinactivo, 
		isnull(SNactivoportal, 0) as SNactivoportal, SNnumero, timestamp   
		from SNegocios 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
		order by SNnombre asc
	</cfquery>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsUsuario" datasource="#Session.DSN#" >
		select convert(varchar, EUcodigo) as EUcodigo
		from SNegocios 
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
	</cfquery>
	
	<cfquery name="rsCuentasSocios" datasource="#Session.DSN#">
		select b.CCTcodigo, b.CCTdescripcion, convert(varchar,c.Ccuenta) as Ccuenta, c.Cdescripcion, c.Cformato
		from CuentasSocios a, CCTransacciones b, CContables c
		Where a.CCTcodigo = b.CCTcodigo
		and a.Ecodigo = b.Ecodigo
		and a.Ccuenta = c.Ccuenta
		and a.Ecodigo = c.Ecodigo
		and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
	</cfquery>	

	<!--- Listas de Precios del Socio --->
	<cfquery name="rsListaPrecios" datasource="#Session.DSN#">
		select 
			convert(varchar,a.LPid) as LPid, 
			b.LPdescripcion,
			a.SNcodigo, 
			a.timestamp
		from ListaPrecioSocio a, EListaPrecios b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		  and a.Ecodigo = b.Ecodigo
		  and a.LPid = b.LPid
	</cfquery>	

	<!--- Listas de Precios vigentes --->
	<cfquery name="rsListaPreciosVigente" datasource="#Session.DSN#" >
		select convert(varchar,LPid) as LPid, LPdescripcion 
		from EListaPrecios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and getdate() >= LPfechaini
		  and getdate() <= LPfechafin
  		  and LPid not in ( select LPid 
		                    from ListaPrecioSocio 
							where SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
							  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )	
	</cfquery>

	<!--- ============================================================================= --->
	<!--- 						Generacion de Usuario del portal                        --->
	<!--- ============================================================================= --->
	<cfset generado = false >		<!--- se genero el Usuario --->
	<cfset temporal = true  >		<!--- es usuario temporal --->
	<cfif isdefined("rsUsuario.EUcodigo") and Len(Trim(rsUsuario.EUcodigo)) gt 0 >
		<cfset generado = true >
		<cfquery name="rsGenerado" datasource="sdc">
			select Usutemporal from Usuario where Usucodigo=#rsUsuario.EUcodigo# and Ulocalizacion = '00'
		</cfquery>
		<cfif isdefined("rsGenerado.Usutemporal") and rsGenerado.Usutemporal eq 0 >
			<cfset temporal = false>
		</cfif>
	</cfif>	
	<!--- ============================================================================= --->

</cfif> <!--- modo cambio --->

<cfquery name="rsNumero" datasource="#session.DSN#">
    select SNnumero 
	from SNegocios
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) gt 0>
		and SNcodigo <> #form.SNcodigo#
	</cfif>
</cfquery>

<cfquery name="rsIdentificacion" datasource="#session.DSN#">
    select SNidentificacion 
	from SNegocios
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) gt 0>
		and SNcodigo <> #form.SNcodigo#
	</cfif>
</cfquery>

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
			alert("Nmero de Socio ya existe.");
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
			alert("Identificacin ya existe.");
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
 	 if((!document.form.SNtiposocio2.checked) && (!document.form.SNtiposocio3.checked)){
	 	 alert ("Debe indicar el tipo de Socio de Negocios.")    
		  return false;    	
	 }
 	
	 if((!document.form.SNtiposocio2.checked) && (document.form.SNtiposocio3.checked)){
	 	 document.form.SNtiposocio.value='P';        	
	 }
 
 	 if((document.form.SNtiposocio2.checked) && (!document.form.SNtiposocio3.checked)){
	 	 document.form.SNtiposocio.value='C';        	
	 }
 
 	 if((document.form.SNtiposocio2.checked) && (document.form.SNtiposocio3.checked)){
	 	 document.form.SNtiposocio.value='A';        	
	 }
 }
 
 function SocioActivo(){
	 if(!form.SNinactivo1.checked ){
	 	 document.form.SNinactivo.value=0;        	
	 }
 	 else{
	 	 document.form.SNinactivo.value=1;     	
	 }
 }
 
	function botones( pdiv, ver ){
		if ( MM_findObj(pdiv) ){
			var div = document.getElementById(pdiv)
			div.style.display  = (ver == 0 ? 'none' : '');
		}
	}

	function usuario(obj){
	
		<cfif modo neq 'ALTA' and rsSocios.SNcodigo neq 9999 >
			var div_usuario = document.getElementById("genUsuario")
			if (obj.checked==true){
				div_usuario.style.display  = '' ;
				if ( MM_findObj('SNactivoportal') ){
					if (document.form.hSNactivoportal.value == '1' ){
						document.form.SNactivoportal.checked = true
					}
					else{
						document.form.SNactivoportal.checked = false
					}
				}

				// activacion de los botones que deben aparecer
				( MM_findObj('publica')? botones('divPublicar', 1) : botones('divPublicar', 0) );
			}
			else{
				div_usuario.style.display  = 'none' ;
				botones('divPublicar', 0);
				
				if ( MM_findObj('SNactivoportal') ){
					document.form.SNactivoportal.checked = false
				}	
			}
		</cfif>
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

// Cambia los div segn sea Asignacin de Cuentas o de Listas de Precios
function cambiar( value ) {

	var divCuentas = document.getElementById('divCuentas')
	var divListas  = document.getElementById('divListas')
	
	if (value == 'C') {
		divCuentas.style.display = ''
		divListas.style.display  = 'none'
	}
	else{
		divCuentas.style.display = 'none'
		divListas.style.display  = ''
	}

}

function asignar(obj){
	<cfif modo neq 'ALTA' >
		<cfif isdefined("Session.modulo") and Session.modulo EQ "CC">
			var divAsignar = document.getElementById('trAsignar')
			if ( obj.checked ){
				divAsignar.style.display = ''
				cambiar('C');
			}
			else{
				divAsignar.style.display = 'none'
			}
		</cfif>	
	</cfif>

}

// ========================================================================================================

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
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una direccin de correo electrnica vlida.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' debe ser numrico.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' debe ser un nmero entre '+min+' y '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
  } 
  
  // modificado para que valide que los cheks de tipo vengan marcados
  if (!(document.form.SNtiposocio2.checked || document.form.SNtiposocio3.checked)){
  	errors +=  '- Debe indicar el Tipo de Socio.\n';
  }
  
  if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>
<script language="JavaScript" type="text/JavaScript">
<!--

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
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

<link href="sif.css" rel="stylesheet" type="text/css">
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<body onLoad="MM_preloadImages('date_d.GIF');MM_validateForm('Aplaca','','R');return document.MM_returnValue">
<form action="SQLSocios.cfm" method="post" name="form" onSubmit="MM_validateForm('SNnumero', '', 'R', 'SNidentificacion','','R','SNnombre','','R','SNemail','','NisEmail','SNvencompras','','RisNum','SNvenventas','','RisNum','SNFecha','','R');return document.MM_returnValue">

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="40%" align="right" valign="baseline" nowrap>N&uacute;mero de Socio:&nbsp;</td>
		<!---<td><cfoutput>#rsSocios.SNcodigo#</cfoutput></td>--->
		
		<td>
			<input type="text" size="10" maxlength="8" name="SNnumero" value="<cfif modo neq 'ALTA'><cfoutput>#Trim(rsSocios.SNnumero)#</cfoutput></cfif>"
				   onfocus="javascript:this.select();"	
				   onblur="javascript:formato(this);"
				   onKeyDown="javascript:anterior(this,event,0);"
				   onkeyup="javascript:mascara(this,event,0);"
				   alt="El N&uacute;mero de Socio"
			>
			&nbsp; <b>XXX-XXXX</b>	
		</td>
	</tr>

	<tr> 
		<td align="right" valign="baseline" nowrap>Nombre:&nbsp;</td>
		<td valign="baseline" >
			<input type="text" name="SNnombre" size="30" maxlength="255"  value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsSocios.SNnombre)#</cfoutput></cfif>" onFocus="javascript:this.select();"  alt="El campo Nombre del Socio">
			<input type="checkbox" name="SNinactivo1" <cfif modo NEQ "ALTA" and rsSocios.SNcodigo eq 9999 >disabled</cfif> value="<cfif modo NEQ "ALTA"><cfoutput>#rsSocios.SNtiposocio#</cfoutput></cfif>" 
			<cfif modo NEQ "ALTA" and rsSocios.SNinactivo EQ 1>checked</cfif> onClick="javascript:SocioActivo();">Inactivo
		</td>
	</tr>

	<tr>
		<td valign="baseline" nowrap><div align="right">Identificaci&oacute;n:&nbsp;</div></td>
		<td valign="baseline" >
			<input type="text" name="SNidentificacion" size="30"  value="<cfif #modo# NEQ "ALTA"><cfoutput>#trim(rsSocios.SNidentificacion)#</cfoutput></cfif>" onFocus="javascript:this.select();" onblur="javascript:validar_identificacion(this);" alt="El campo Identificacin del socio">
		</td>
	</tr>
	
	<tr>
		<td align="right" valign="baseline" nowrap>Tipo de Socio:&nbsp;</td>
		<td valign="baseline"> 
			<input type="checkbox" name="SNtiposocio2" value="<cfif modo NEQ "ALTA"><cfoutput>#rsSocios.SNtiposocio#</cfoutput></cfif>" 
				<cfif modo NEQ "ALTA"><cfif #rsSocios.SNtiposocio# EQ "C"> checked <cfelseif #rsSocios.SNtiposocio# EQ "A"> checked </cfif></cfif>
				onClick="javascript:TipoSocio(); asignar(this);">Cliente&nbsp; 
        	<input type="checkbox" name="SNtiposocio3" value="<cfif modo NEQ "ALTA"><cfoutput>#rsSocios.SNtiposocio#</cfoutput></cfif>" 
				<cfif modo NEQ "ALTA"><cfif #rsSocios.SNtiposocio# EQ "P"> checked <cfelseif #rsSocios.SNtiposocio# EQ "A"> checked </cfif></cfif>
				onClick="javascript:TipoSocio(); usuario(this);">Proveedor
		</td>
	</tr>
	
	<tr>
		<td valign="baseline" align="right" nowrap>Tel&eacute;fono:&nbsp;</td>
		<td valign="baseline"> 
			<input name="SNtelefono" type="text" size="30" value="<cfif #modo# NEQ "ALTA"><cfoutput>#trim(rsSocios.SNtelefono)#</cfoutput></cfif>" onFocus="javascript:this.select();" alt="El campo Telfono del Socio">
		</td>
	</tr>
	
	<tr>
		<td valign="baseline" align="right">Fax:&nbsp;</td>
      	<td valign="baseline"> 
			<input name="SNFax" type="text" size="30" onBlur="MM_validateForm('Amonto','','RisNum');return document.MM_returnValue" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsSocios.SNFax)#</cfoutput></cfif>" onFocus="javascript:this.select();" alt="El campo Fax del Socio ">
      	</td>
	</tr>
	
	<tr>
		<td align="right" valign="baseline" nowrap>E-Mail:&nbsp;</td>
		<td valign="baseline"> 
			<input name="SNemail" type="text" size="40" maxlength="100" onBlur="return document.MM_returnValue" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsSocios.SNemail)#</cfoutput></cfif>" onFocus="javascript:this.select();" alt="El campo E-Mail del Socio ">
		</td>
	</tr>
	
	<tr>
		<td valign="baseline" nowrap align="right">Tipo:&nbsp;</td>
		<td valign="baseline"> 
			<select name="SNtipo">
			<option value="F" <cfif (isDefined("rsSocios.SNtipo") AND "F" EQ rsSocios.SNtipo)>selected</cfif>>Fisico</option>
			<option value="J" <cfif (isDefined("rsSocios.SNtipo") AND "J" EQ rsSocios.SNtipo)>selected</cfif>>Juridico</option>
			</select>
		</td>
	</tr>

	<tr> 
		<td valign="baseline" align="right">Fecha:&nbsp;</td>
		<td valign="baseline"> 
			<input type="text" name="SNFecha" readonly="" size="12" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsSocios.SNFecha#</cfoutput><cfelse><cfoutput>#LSDateFormat(Now(),"DD/MM/YYYY")#</cfoutput></cfif>" alt="El campo Fecha de inclusin del Socio">
		</td>
	</tr>
	
	<tr> 
		<td align="right" nowrap>Vencimiento para Compras:&nbsp;</td>
		<td> 
			<input type="text" name="SNvencompras" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsSocios.SNvencompras#</cfoutput></cfif>" size="5"  style="text-align: right;" onblur="javascript:fm(this,-1); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo Vencimiento Compras del Socio">&nbsp;(d&iacute;as)
		</td>
	</tr>	
	
	<tr>
		<td align="right">Vencimiento para Ventas:&nbsp;</td>
		<td> 
			<input type="text" name="SNvenventas" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsSocios.SNvenventas#</cfoutput></cfif>" size="5" style="text-align: right;" onblur="javascript:fm(this,-1); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo Vencimiento Ventas del Socio">&nbsp;(d&iacute;as)
		</td>
	</tr>				

	<tr>
		<td align="right" valign="middle" nowrap>Direcci&oacute;n:&nbsp;</td>
		<td>
			<textarea name="SNdireccion" cols="30" rows="3"  alt="El campo Direccin del Socio" onFocus="javascript:this.select();"><cfif #modo# NEQ "ALTA"><cfoutput>#trim(rsSocios.SNdireccion)#</cfoutput></cfif></textarea>
		</td>
	</tr>

    <tr> 
		<td colspan="2" align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>

	<!--- Notificacion de status de generacion del portal, no aplica para el socio generico --->
	<cfif modo NEQ "ALTA" >
			<cfif rsSocios.SNcodigo neq 9999 >
				<tr>
					<td colspan="2" align="center">
					<div id="genUsuario" style="display: none ;" >
						<table width="90%" class="cuadro">
							<tr><td align="center" bgcolor="#FAFAFA"><b>Generaci&oacute;n de Usuario</b></td></tr>
							<tr><td align="center">
							<cfif generado >
								<cfif temporal >
									Se ha creado un Usuario de migestion.net para este Socio de Negocios.<br>
									El proceso de Afiliaci&oacute;n est pendiente.
								<cfelse>
									El proceso de Afiliaci&oacute;n a migestion.net ha sido completado.
								</cfif>
							<cfelse>
								Si desea que el Socio de Negocios tenga acceso al portal, <br>
								presione el bot&oacute;n de <font color="#FF0000">Publicar</font>.
							</cfif>	
							</td></tr>
							<cfif generado and not temporal >
								<tr><td align="center"><input type="checkbox" name="SNactivoportal" value="activo" <cfif rsSocios.SNactivoportal eq 1>checked</cfif> >Autorizar como mi Socio de Negocios</td></tr>
							</cfif>	
						</table>
					</div>	
					<td>
				</tr>
			</cfif>
		    <tr><td colspan="2">&nbsp;</td></tr>

			<cfif isdefined("Session.modulo") and Session.modulo EQ "CC">
				<!---<cfif trim(rsSocios.SNtiposocio) NEQ "P" > --->
				<!--- CuentasSocios.Inicio --->
					<tr id="trAsignar">
						<td nowrap colspan="2" align="center">
						<!--- CuentasSocios.Inicio --->
							<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0"  class="cuadro">		
								<!--- combo de seleccion --->
								<tr> 
									<td nowrap bgcolor="#FAFAFA" align="center"><b>Asignaci&oacute;n de&nbsp;</b> 
										<select name="tipo" onChange="javascript: cambiar(this.value);">
											<option value="C">Cuentas</option>
											<option value="L">Listas de Precios</option>
										</select> 
									</td>
								</tr>
			
								<tr>
									<td nowrap align="center"> 
										<!--- Cuentas --->
										<div id="divCuentas" style="display: none ;" >
											<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" >
												<tr><td>&nbsp;</td></tr>
												<tr> 
													<td width="1%"></td>
													<td nowrap >Transacci&oacute;n:</td>
													<td nowrap >Cuenta:</td>
												</tr>
												
												<tr> 
													<td width="3%"></td>
													<td nowrap> 
														<input name="CCTdescripcion" type="text" size="40" maxlength="80" disabled="true" readonly="true">
														<input name="CCTcodigo" type="hidden">
														<a href="#" tabindex="-1"><img src="../../Imagenes/Description.gif" alt="Lista de Transacciones" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript: doConlisTransacciones(<cfoutput>#Form.SNcodigo#</cfoutput>);"></a> 
													</td>
													<td nowrap> 
														<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form"> 
													</td>
												</tr>
												
												<tr><td nowrap colspan="3">&nbsp;</td></tr>
				
												<tr> 
													<td nowrap colspan="3" align="center">
														<input type="submit" name="btnAceptar" value="Agregar" onClick="MM_validateForm('CCTcodigo','','R','Ccuenta','','R');return document.MM_returnValue;">
													</td>
												</tr>
			
												<tr><td>&nbsp;</td></tr>
												
												<tr>
													<td colspan="3">
														<!--- Lista de cuentas del socio --->
														<table width="70%" border="0" align="center" cellpadding="0" cellspacing="0" id="lista1">
															<tr class="tituloListas2">
																<td nowrap>
																	<div align="center"><strong>Transacci&oacute;n</strong></div>									
																</td>
																<td nowrap>
																	<div align="center"><strong>Cuenta</strong></div>
																</td>
																<td nowrap>&nbsp;
																</td>
															</tr>
															<cfif rsCuentasSocios.RecordCount gt 0>
																<cfoutput query="rsCuentasSocios">
																<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
																	<td nowrap><div align="right">#CCTdescripcion#</div></td>
																	<td nowrap><div align="right">#Cdescripcion#</div></td>
																	<td nowrap>
																		<input  name="btnBorrar" type="image" alt="Eliminar elemento" 
																		onClick="javascript: Editar('#CCTcodigo#');" src="../../Imagenes/Borrar01_T.gif" width="16" height="16">
																	</td>
																</tr>
																</cfoutput>
															<cfelse>
																<tr><td colspan="2" align="center"><strong>No se han asignado Cuentas</strong></td></tr>
															</cfif>
															<tr><td>&nbsp;</td></tr>	
														</table>
														<input name="datos" type="hidden" value="">
													</td>
												</tr>	
											</table>
										</div>	
			
										<!--- Lista de Precios --->
										<div id="divListas" style="display: none ;" >
											<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
												<tr><td colspan="3">&nbsp;</td></tr>
												<tr> 
													<td nowrap align="right">Lista de Precios:&nbsp;</td>
													<td nowrap width="1%"> 
														<select name="LPid" >
															<cfoutput query="rsListaPreciosVigente"><option value="#LPid#">#LPdescripcion#</option></cfoutput> 
														</select>
													</td>
													<td width="1%"></td>
													<td nowrap >
														<input type="submit" name="btnAceptarLista" value="Agregar" onClick="MM_validateForm('LPid','','R');return document.MM_returnValue;">
													</td>
												</tr>
												<tr><td>&nbsp;</td></tr>
												<tr>
													<td colspan="4">
														<!--- Lista de listas de precio --->
														<table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" id="lista2" >
															<tr class="tituloListas2">
																<td width="63%" nowrap >
																	<div align="right"><strong>Lista de Precio</strong></div>
																</td>
																<td width="37%" nowrap>&nbsp;</td>
															</tr>
															<cfif rsListaPrecios.RecordCount gt 0>
																<cfoutput query="rsListaPrecios">
																<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
																	<td nowrap><div align="right">#LPdescripcion#</div></td>
																	<td nowrap>
																		<input  name="btnBorrar2" type="image" alt="Eliminar elemento" 
																		onClick="javascript: Editar2('#LPid#');" src="../../Imagenes/Borrar01_T.gif" width="16" height="16">
																	</td>
																</tr>
																<tr><td>&nbsp;</td></tr>
																</cfoutput>
															<cfelse>
																<tr><td colspan="2" align="center"><strong>No se han asignado Listas de Precios</strong></td></tr>
																<tr><td>&nbsp;</td></tr>
															</cfif>
															<tr><td>&nbsp;</td></tr>	
														</table>
														<input name="datos2" type="hidden" value="">
													</td>
												</tr>
											</table>
										</div>	
									</td>
								</tr>
							</table>
						<!--- CuentasSocios.Fin --->
					</td>
					</tr>
				<!--- CuentasSocios.Fin --->
			
				<!---</cfif>---> <!--- Tipo --->
			</cfif> <!--- Modulo --->
	</cfif> <!--- Modo --->

    <tr> 
      <td colspan="2" align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>

	<!--- Botones --->
    <tr> 
      <td colspan="2" align="right" valign="baseline" nowrap> 
        <div align="center"> 
			<!--- Sustituye al portlet de botones, para agregar un boton mas --->
			<link href="estilos.css" rel="stylesheet" type="text/css">
			<cfoutput>

			<table border="0" align="center">
				<tr>
					<cfif modo EQ "ALTA">
						<td><input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#"></td>
						<td><input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#"></td>
					<cfelse>	
						<td><input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#"></td>
						
						<!--- No se puede borrar el socio generico --->
						<cfif rsSocios.SNcodigo neq 9999 >
							<td><input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onclick="javascript:return confirm('Desea Eliminar el Registro?');"></td>
						</cfif>	
						
						<td><input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" ></td>
						<td><input name="btnContactos" type="button" value="Contactos" onClick="javascript:Contactos('<cfoutput>#rsSocios.SNcodigo#</cfoutput>')"></td>
						<td>
							<div id="divPublicar" style="display: none ;" >
								<input name="Publicar" type="submit" value="Publicar">
							</div>	
						</td>
					</cfif>
				</tr>	
			</table>
			</cfoutput>
			<!--- portlet botones--->
		
			<!--- agrega boton de Contactos y los botones de publicar o de asignar rol--->
			<cfif modo NEQ "ALTA">
					<cfif not generado >
						<input type="hidden" name="publica" value="si">
					</cfif>
			</cfif> <!--- Modo --->
        </div>
     	<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
      </td>
    </tr>
  </table>
<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsSocios.timestamp#"/>
	</cfinvoke>
</cfif>  
  <input type="hidden" name="timestamp" value="<cfif #modo# NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="SNcodigo" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsSocios.SNcodigo#</cfoutput></cfif>">
  <input type="hidden" name="SNtiposocio" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsSocios.SNtiposocio#</cfoutput></cfif>">
  <input type="hidden" name="SNinactivo" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsSocios.SNinactivo#</cfoutput></cfif>">
  <input type="hidden" name="hSNactivoportal" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsSocios.SNactivoportal#</cfoutput></cfif>">
  <cfif modo NEQ "ALTA">	
      <input name="generado" type="hidden" value="<cfif generado>1<cfelse>0</cfif>" >
  </cfif> 
	
 </form>
<script language="JavaScript" type="text/javascript">
	var f = document.form;
	SocioActivo();
	<cfif modo neq 'ALTA'>
		usuario(f.SNtiposocio3);

		<cfif isdefined("Session.modulo") and Session.modulo EQ "CC">			
			asignar(f.SNtiposocio2);
			<cfif rsSocios.SNtiposocio NEQ "P"> 
				cambiar('C');
				function Editar(data) {
					f.datos.value = data;
				}
				function Editar2(data) {
					f.datos2.value = data;
				}
				f.CCTcodigo.alt = "El campo Transaccin"
				f.Ccuenta.alt = "El campo Cuenta"
				f.LPid.alt = "El campo Lista de Precio"
			</cfif>
		</cfif>
	</cfif>
</script>



