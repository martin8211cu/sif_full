<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
<style type="text/css">
	.DocsFrame {
	  visibility: hidden;
	}
</style>
<!---
<cfquery name="def" datasource="asp">
	select 1 as dato
</cfquery>
--->
<cfset def = QueryNew("dato") >

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String">
<cfparam name="Attributes.Conlis" default="S" type="String">
<cfparam name="Attributes.query" default="#def#" type="query">
<cfparam name="Attributes.Cformato" default="Cformato" type="string">
<cfparam name="Attributes.Cdescripcion" default="Cdescripcion" type="string">
<cfparam name="Attributes.Ccuenta" default="Ccuenta" type="string">
<cfparam name="Attributes.form" default="form1" type="string">
<cfparam name="Attributes.movimiento" default="N" type="string">
<cfparam name="Attributes.auxiliares" default="N" type="string">
<cfparam name="Attributes.frame" default="frcuentas" type="string">
<cfparam name="Attributes.descwidth" default="32" type="string">


<cfquery name="rsFmt" datasource="#Attributes.Conexion#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 10
</cfquery>

<cfset longitud = len(Trim(rsFmt.Pvalor))>
<script language="JavaScript">
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
	if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function doConlis<cfoutput>#Attributes.Ccuenta#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.Ccuenta#&desc=#Attributes.Cdescripcion#&fmt=#Attributes.Cformato#&movimiento=#Attributes.movimiento#&auxiliares=#Attributes.auxiliares#</cfoutput>";
	popUpWindow("/cfmx/sif/Utiles/ConlisCuentasContables.cfm"+params,250,200,650,350);
}

function TraeCuenta<cfoutput>#Attributes.Ccuenta#</cfoutput>(dato) {
	var params ="";
	var arrfmt = '<cfoutput>#Ucase(rsfmt.Pvalor)#</cfoutput>'.split('-');
	var arrdato = dato.split('-');
	var cant = 0;
	for (i=0;i<arrdato.length;i++) {
		if (arrdato[i].length < arrfmt[i].length)
		{
			cant = arrfmt[i].length - arrdato[i].length;
			for (j=0; j < cant; j++) 
			{
				arrdato[i] = '0' + arrdato[i];
			}
		}
	}
	dato = arrdato.join('-');
	<cfoutput>#Attributes.form#.#Attributes.Cformato#.value=dato;</cfoutput>
	params = "<cfoutput>&id=#Attributes.Ccuenta#&desc=#Attributes.Cdescripcion#&fmt=#Attributes.Cformato#&movimiento=#Attributes.movimiento#&auxiliares=#Attributes.auxiliares#</cfoutput>";
	if (dato!="") {
		document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/cuentasquery.cfm?Cformato="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	return;
}

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

//Permite solamente digitar numeros (se usa en el evento onKeyUp)
function snumber2(obj,e,d)
{
	str= new String("")
	str= obj.value
	var tam=obj.size
	var t=Key(e)
	var ok=false
	 
	if(tam>d) {tam=tam-d}
	//if(tam>1) {tam=tam-1}
	 
	if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;
	if(t>=16 && t<=20) return false;
	if(t>=33 && t<=40) return false;
	if(t>=112 && t<=123) return false;
	if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
	if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)
	 
	if(t>=48 && t<=57)  ok=true
	if(t>=96 && t<=105) ok=true
	if(t==109 || t==189) ok=true
	//if(d>=0) {if(t==188) ok=true} //LA COMA
	if(d>0)
	{
	if(t==110) ok=true
	if(t==190) ok=true
	}
	 
	if(!ok) 
	{    
		//str=fm(str,d)
		str = str.substring(0,str.length-1);
		obj.value=str
	}
	return true
}

</script>

<cfoutput>
  <table border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td nowrap> 
        <input name="#Attributes.Cformato#" maxlength="#longitud#" size="#longitud#" onBlur="javascript:TraeCuenta#Attributes.Ccuenta#(document.#Attributes.form#.#Evaluate('Attributes.Cformato')#.value);" onFocus="this.select()"
		onKeyUp="javascript:if(snumber2(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Cformato)#</cfif>">
	</td>
      <td nowrap>
	<input type="text" name="#Attributes.Cdescripcion#" maxlength="80" size="#Attributes.descwidth#" disabled tabindex="-1"
	value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Cdescripcion)#</cfif>">
	<cfif ucase(Attributes.Conlis) EQ "S">
		<a href="##" tabindex="-1"><img class="imgIconConlist" alt="Lista de Cuentas Contables" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis#Attributes.Ccuenta#();"></a>		
	</cfif>
	</td>
  </tr>
</table>
	<input type="hidden" name="#Attributes.Ccuenta#" value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Ccuenta)#</cfif>">

<iframe name="#Attributes.frame#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="no" src="/cfmx/sif/Utiles/cuentasquery.cfm" class="DocsFrame"></iframe>
</cfoutput>	