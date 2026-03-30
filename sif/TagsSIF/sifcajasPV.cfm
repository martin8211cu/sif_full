<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.id" 				default="" 				type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.Ocodigo"			default="Ocodigo" 		type="string"> <!--- Nombre del id de la Oficina --->
<cfparam name="Attributes.FAM01COD"			default="FAM01COD" 		type="string"> <!--- Nombre del id de la caja --->
<cfparam name="Attributes.FAM01CODD" 		default="FAM01CODD" 	type="string"> <!--- Nombre del codigo de la caja  --->
<cfparam name="Attributes.FAM01DES" 		default="FAM01DES" 		type="string"> <!--- Nombtre de la descripcion de la caja --->
<cfparam name="Attributes.excluir" 			default="" 				type="string"> 
<cfparam name="Attributes.frame" 			default="frCaja" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.modificable" 		default="true"			type="boolean"><!--- Parámetros para impedir la modificación del dato --->


<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >
	<cfset queryName = "rsCaja_#trim(Attributes.FAM01CODD)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		Select Ocodigo, FAM01CODD, FAM01DES, FAM01COD
		from FAM001
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

function doConlisCaja<cfoutput>#Attributes.FAM01CODD#</cfoutput>() {
	 <cfif Attributes.modificable>
		<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.Ocodigo#&codigo=#Attributes.FAM01CODD#&desc=#Attributes.FAM01DES#&FAM01COD=#Attributes.FAM01COD#&excluir=#Attributes.excluir#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow("/cfmx/sif/Utiles/ConlisCajas.cfm"+params,250,200,650,400);
	</cfif>
}

function TraeCaja<cfoutput>#Attributes.FAM01CODD#</cfoutput>(valor) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.Ocodigo#&desc=#Attributes.FAM01DES#&codigo=#Attributes.FAM01CODD#&FAM01COD=#Attributes.FAM01COD#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (valor!="") {
		//document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifCajaquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
		fr.src = "/cfmx/sif/Utiles/sifCajaquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;		
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Ocodigo#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAM01CODD#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAM01DES#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAM01COD#</cfoutput>.value = '';
		<cfoutput>if (window.func#Attributes.FAM01CODD#) {window.func#Attributes.FAM01CODD#()}</cfoutput>
	}
	return;
}
</script>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap width="1%">
			<input type="text" name="#Attributes.FAM01CODD#" id="#Attributes.FAM01CODD#" maxlength="15" <cfif not Attributes.modificable>disabled</cfif> size="10" onblur="javascript:TraeCaja#Attributes.FAM01CODD#(document.#Attributes.form#.#Evaluate('Attributes.FAM01CODD')#.value);" onfocus="this.select()"	tabindex="#Attributes.tabindex#"
			value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).FAM01CODD)#</cfif>">
		</td>
	
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.FAM01DES#" id="#Attributes.FAM01DES#" maxlength="255" size="#Attributes.size#" disabled 
				value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id)) >#Trim(Evaluate(queryName).FAM01DES)#</cfif>">
		</td>
	
		<td width="98%" nowrap>
			<a href="##" tabindex="-1"><img id="Almimagen" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cajas" name="Almimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisCaja#Attributes.FAM01CODD#();'></a>
			<input type="hidden" name="#Attributes.Ocodigo#" id="#Attributes.Ocodigo#" value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>#Trim(Evaluate(queryName).Ocodigo)#</cfif>">
			<input type="hidden" name="#Attributes.FAM01COD#" id="#Attributes.FAM01COD#" value="<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>#Trim(Evaluate(queryName).FAM01COD)#</cfif>">
		
		</td>
	</tr>
</table>
</cfoutput>

	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>