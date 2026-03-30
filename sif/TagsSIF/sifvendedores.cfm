<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.id" 				default="" 				type="string">  <!--- valor de la llave en Cambio --->
<cfparam name="Attributes.FAX04CVD"			default="FAX04CVD" 		type="string"> <!--- Nombre del id del Vendedor --->
<cfparam name="Attributes.FAM21NOM" 		default="FAM21NOM"	 	type="string"> <!--- Nombre del Vendedor --->
<cfparam name="Attributes.excluir" 			default="" 				type="string"> 
<cfparam name="Attributes.frame" 			default="frVendedor" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >
	<cfset queryName = "rsVendedores_#trim(Attributes.FAX04CVD)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		Select FAX04CVD, FAM21NOM
		from  FAM021
		where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and FAX04CVD=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.id#">
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

function doConlisVendedores<cfoutput>#Attributes.FAX04CVD#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.FAX04CVD#&codigo=#Attributes.FAX04CVD#&desc=#Attributes.FAM21NOM#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	popUpWindow("/cfmx/sif/Utiles/ConlisVendedores.cfm"+params,250,200,650,400);
}

function TraeVendedor<cfoutput>#Attributes.FAX04CVD#</cfoutput>(valor) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.FAX04CVD#&desc=#Attributes.FAM21NOM#&codigo=#Attributes.FAX04CVD#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (valor!="") {
		//document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifOficinaquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
		fr.src = "/cfmx/sif/Utiles/sifVendedorquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAX04CVD#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAM21NOM#</cfoutput>.value = '';
		<cfoutput>if (window.func#Attributes.FAX04CVD#) {window.func#Attributes.FAX04CVD#()}</cfoutput>
	}
	return;
}
</script>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap width="1%">
			<input type="text" name="#Attributes.FAX04CVD#" id="#Attributes.FAX04CVD#" maxlength="15" size="10" onblur="javascript:TraeVendedor#Attributes.FAX04CVD#(document.#Attributes.form#.#Evaluate('Attributes.FAX04CVD')#.value);" onfocus="this.select()"	tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).FAX04CVD)#</cfif>">
		</td>
	
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.FAM21NOM#" id="#Attributes.FAM21NOM#" maxlength="255" size="#Attributes.size#" disabled 
				value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).FAM21NOM)#</cfif>">
		</td>
	
		<td width="98%" nowrap>
			<a href="##" tabindex="-1"><img id="Almimagen" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Vendedores" name="Almimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisVendedores#Attributes.FAX04CVD#();'></a>
			<!--- <input type="hidden" name="#Attributes.FAX04CVD#" id="#Attributes.FAX04CVD#" value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).FAX04CVD)#</cfif>"> --->
		</td>
	</tr>
</table>
</cfoutput>

	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>