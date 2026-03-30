<!---  
	Modificado por: Ana Villavicencio
	Fecha: 08 de marzo del 2006
	Motivo: Agregar atributo de display en none al iframe del tag
	 		Se corrigió navegacion de tab.
 		   	Se agregó la funcion conlis_keyup, para q funcionara el F2.	
--->


<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.id" 				default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.Ocodigo"			default="Ocodigo" 		type="string"> <!--- Nombre del id de la Oficina --->
<cfparam name="Attributes.Oficodigo" 		default="Oficodigo" 	type="string"> <!--- Nombre del codigo de la Oficina  --->
<cfparam name="Attributes.Odescripcion" 	default="Odescripcion" 	type="string"> <!--- Nombtre de la descripcion de la Oficina --->
<cfparam name="Attributes.excluir" 			default="" 				type="string"> 
<cfparam name="Attributes.frame" 			default="frOficina" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.modificable" 		default="true"			type="boolean"><!--- Parámetros para impedir la modificación del dato --->


<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >
	<cfset queryName = "rsOficina_#trim(Attributes.Oficodigo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		Select Ocodigo, Oficodigo, Odescripcion
		from Oficinas
		where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Ocodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
  	}
  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}
function closePopUp(){
	if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
		popUpWin=null;
  	}
}
//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.Oficodigo#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisOficina<cfoutput>#Attributes.Oficodigo#</cfoutput>();
		}
	}
function doConlisOficina<cfoutput>#Attributes.Oficodigo#</cfoutput>() {
	 <cfif Attributes.modificable>
		<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.Ocodigo#&codigo=#Attributes.Oficodigo#&desc=#Attributes.Odescripcion#&excluir=#Attributes.excluir#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow("/UtilesExt/ConlisOficinas.cfm"+params,250,200,650,400);
	</cfif>
}

function TraeOficina<cfoutput>#Attributes.Oficodigo#</cfoutput>(valor) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.Ocodigo#&desc=#Attributes.Odescripcion#&codigo=#Attributes.Oficodigo#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (valor!="") {
		//document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/UtilesExt/sifOficinaquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
		fr.src = "/UtilesExt/sifOficinaquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;		
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Ocodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Oficodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Odescripcion#</cfoutput>.value = '';
		<cfoutput>if (window.func#Attributes.Oficodigo#) {window.func#Attributes.Oficodigo#()}</cfoutput>
	}
	return;
}
</script>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap width="1%">
			<input type="text" name="#Attributes.Oficodigo#" id="#Attributes.Oficodigo#" 
			maxlength="15" <cfif not Attributes.modificable>disabled</cfif> size="10" 
			onblur="javascript:TraeOficina#Attributes.Oficodigo#(document.#Attributes.form#.#Evaluate('Attributes.Oficodigo')#.value);" 
			onfocus="this.select()"	tabindex="#Attributes.tabindex#"
			onkeyup="javascript:conlis_keyup_#Attributes.Oficodigo#(event);"
			value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>#Trim(Evaluate(queryName).Oficodigo)#</cfif>">
		</td>
	
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.Odescripcion#" id="#Attributes.Odescripcion#" maxlength="255" size="#Attributes.size#" disabled 
				value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>#Trim(Evaluate(queryName).Odescripcion)#</cfif>">
		</td>
	
		<td width="98%" nowrap>
			<a href="##" tabindex="-1"><img id="Almimagen" src="/imagenes/Description.gif" alt="Lista de Oficinas" name="Almimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisOficina#Attributes.Oficodigo#();'></a>
			<input type="hidden" name="#Attributes.Ocodigo#" id="#Attributes.Ocodigo#" value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>#Trim(Evaluate(queryName).Ocodigo)#</cfif>">
		</td>
	</tr>
</table>
</cfoutput>

	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" 
		marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" style="display:none; "></iframe>