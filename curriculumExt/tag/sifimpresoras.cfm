<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.FAM12COD" 		default="FAM12COD"	 	type="string"> <!--- Nombres del código de la impresora --->
<cfparam name="Attributes.FAM12CODD" 		default="FAM12CODD"	 	type="string"> <!--- Nombres del código de la impresora --->
<cfparam name="Attributes.Ecodigo" 		default="Ecodigo"	 	type="string"> <!--- Nombres del código de la impresora --->
<cfparam name="Attributes.FAM12DES" 		default="FAM12DES" 		type="string"> <!--- Nombres de la descripción de la impresora --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.frame" 			default="frOficina" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.modificable"      default="true" 		type="boolean"><!--- Parámetros para impedir la modificación del dato --->


<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsImpresora_#trim(Attributes.FAM12COD)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select FAM12COD, FAM12CODD, FAM12DES
		from FAM012
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and FAM12COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">

var popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput>=0;

function popUpWindow<cfoutput>#Attributes.FAM12COD#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput>.close();
  	}
  	popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.FAM12COD#</cfoutput>;
}

function closePopUp<cfoutput>#Attributes.FAM12COD#</cfoutput>(){
	if(popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput>.close();
		popUpWinSN<cfoutput>#Attributes.FAM12COD#</cfoutput>=null;
  	}
}

function doConlisImpresoras<cfoutput>#Attributes.FAM12CODD#</cfoutput>() {
   	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.FAM12COD#&codigo=#Attributes.FAM12CODD#&desc=#Attributes.FAM12DES#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
   		popUpWindow<cfoutput>#Attributes.FAM12COD#</cfoutput>("/UtilesExt/ConlisImpresoras.cfm"+params,250,200,650,400);
   }

<!--- PRUEBA REBECA--->
function TraeImpresora<cfoutput>#Attributes.FAM12CODD#</cfoutput>(valor, descripcion, campo) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.FAM12COD#&desc=#Attributes.FAM12DES#&codigo=#Attributes.FAM12CODD#</cfoutput>";
	
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (valor!="") {
		document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>").src="/UtilesExt/sifImpresoraquery.cfm?valor="+valor+"&descripcion="+descripcion+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+"&campo="+campo+params;
	
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAM12COD#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAM12DES#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAM12CODD#</cfoutput>.value = '';
	}
	
	<cfoutput>
		if (window.func#Attributes.FAM12CODD#) {
			window.func#Attributes.FAM12CODD#()
		}
	</cfoutput>	

	return;
}
<!--------------------------------------->


</script>
<script language="javascript" type="text/javascript" src="/js/utilesMonto.js">//</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput>
<tr>
	<td nowrap width="1%">
		<input tabindex="1"
		type="text" name="#Attributes.FAM12CODD#" id="#Attributes.FAM12CODD#"
		maxlength="9" size="10" style="text-align: right;" 
		onBlur="javascript: fm(this,-1); TraeImpresora#Attributes.FAM12CODD#(document.#Attributes.form#.#Attributes.FAM12CODD#.value, document.#Attributes.form#.#Attributes.FAM12DES#.value, 1);" 
		onFocus="javascript: this.select(); this.value=qf(this);"  
		<cfif not Attributes.modificable>
			disabled
		</cfif>
		onKeyUp="javascript: if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).FAM12CODD)#</cfif>">
		
   </td>
   <td nowrap width="1%">
		<input tabindex="2" type="text" name="#Attributes.FAM12DES#" id="#Attributes.FAM12DES#" maxlength="50" size="#Attributes.size#"
		onBlur="javascript: TraeImpresora#Attributes.FAM12CODD#(document.#Attributes.form#.#Attributes.FAM12CODD#.value, document.#Attributes.form#.#Attributes.FAM12DES#.value, 2);" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).FAM12DES)#</cfif>">
	</td>
	<td width="98%">
		<a  href="##" tabindex="-1"><img id="FAM12CODD" src="/imagenes/Description.gif" alt="Lista de Impresoras" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisImpresoras#Attributes.FAM12CODD#();'></a>
	</td>
	<input type="hidden" name="#Attributes.FAM12COD#" id="#Attributes.FAM12COD#" 
	value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).FAM12COD)#</cfif>">
</tr>
</table>
</cfoutput>

<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
