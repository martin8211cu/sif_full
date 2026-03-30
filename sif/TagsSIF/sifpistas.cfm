<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 			default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 				default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.id" 					default="" 				type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.Pista_id" 			default="Pista_id" 		type="string"> <!--- Nombre del id de la Pista --->
<cfparam name="Attributes.Codigo_pista" 		default="Codigo_pista" 	type="string"> <!--- Nombre del codigo de Pista  --->
<cfparam name="Attributes.Descripcion_pista" 	default="Descripcion_pista" 	type="string"> <!--- Nombtre de la descripcion de Pista --->
<cfparam name="Attributes.excluir" 				default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.frame" 				default="frPista" 		type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 		default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"		default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 			default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 				default="30" 			type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >
	<cfset queryName = "rsPista_#trim(Attributes.Codigo_pista)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select Pista_id, Codigo_pista, Descripcion_pista
		from Pistas
		where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and Pista_id=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
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

function doConlisPistas<cfoutput>#Attributes.Codigo_pista#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.Pista_id#&codigo=#Attributes.Codigo_pista#&desc=#Attributes.Descripcion_pista#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	popUpWindow("/cfmx/sif/Utiles/ConlisPistas.cfm"+params,250,200,650,400);
}

function TraePista<cfoutput>#Attributes.Codigo_pista#</cfoutput>(valor) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.Pista_id#&desc=#Attributes.Descripcion_pista#&codigo=#Attributes.Codigo_pista#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (valor!="") {
		document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifPistasquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Pista_id#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Codigo_pista#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Descripcion_pista#</cfoutput>.value = '';
		<cfoutput>if (window.func#Attributes.Codigo_pista#) {window.func#Attributes.Codigo_pista#()}</cfoutput>
	}
	return;
}

	function conlis_keyup_<cfoutput>#Attributes.Codigo_pista#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisPistas<cfoutput>#Attributes.Codigo_pista#</cfoutput>();
		}
	}	

</script>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap width="1%">
			<input type="text" name="#Attributes.Codigo_pista#" id="#Attributes.Codigo_pista#" maxlength="15" size="10" onblur="javascript:TraePista#Attributes.Codigo_pista#(document.#Attributes.form#.#Evaluate('Attributes.Codigo_pista')#.value);" onfocus="this.select()"	tabindex="#Attributes.tabindex#"
		 onKeyUp="javascript:conlis_keyup_#Attributes.Codigo_pista#(event);"	value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).Codigo_pista)#</cfif>">
		</td>
	
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.Descripcion_pista#" id="#Attributes.Descripcion_pista#" maxlength="255" size="#Attributes.size#" disabled 
				value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).Descripcion_pista)#</cfif>">
		</td>
	
		<td width="98%" nowrap>
			<a href="##" tabindex="-1"><img id="Almimagen" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Almac&eacute;nes" name="Almimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisPistas#Attributes.Codigo_pista#();'></a>
			<input type="hidden" name="#Attributes.Pista_id#" id="#Attributes.Pista_id#" value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).Pista_id)#</cfif>">
		</td>
	</tr>
</table>
</cfoutput>

	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>