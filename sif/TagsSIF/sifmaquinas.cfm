<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.FAM09MAQ" 		default="FAM09MAQ"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.Ecodigo" 		default="Ecodigo"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.FAM09DES" 		default="FAM09DES" 		type="string"> <!--- Nombres de la descripción de la maquina --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.excluir" 			default="" 				type="string">
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.frame" 			default="frOficina" 	type="string"> <!--- Nombre del frame --->



<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsMaquina_#trim(Attributes.FAM09MAQ)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select FAM09MAQ, FAM09DES
		from FAM009
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and FAM09MAQ = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->


<script language="JavaScript">


var popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput>=0;

function popUpWindow<cfoutput>#Attributes.FAM09MAQ#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput>.close();
  	}
  	popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.FAM09MAQ#</cfoutput>;
}

function closePopUp<cfoutput>#Attributes.FAM09MAQ#</cfoutput>(){
	if(popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput>) {
		if(!popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput>.close();
		popUpWinSN<cfoutput>#Attributes.FAM09MAQ#</cfoutput>=null;
  	}
}

function doConlisMaquinas<cfoutput>#Attributes.FAM09MAQ#</cfoutput>() {
    <cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.FAM09MAQ#&desc=#Attributes.FAM09DES#&excluir=#Attributes.excluir#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
    popUpWindow<cfoutput>#Attributes.FAM09MAQ#</cfoutput>("/cfmx/sif/Utiles/ConlisMaquinas.cfm"+params,250,200,650,400);
    
}

<!--- PRUEBA REBECA--->
function TraeMaquina<cfoutput>#Attributes.FAM09MAQ#</cfoutput>(valor) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.FAM09MAQ#&desc=#Attributes.FAM09DES#&excluir=#Attributes.excluir#&frame=#Attributes.frame#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	if (valor!="") {
		document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifMaquinasquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	
	}
	else{
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAM09MAQ#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.FAM09DES#</cfoutput>.value = '';
		}
	
	<cfoutput>
		if (window.func#Attributes.FAM09MAQ#) {
			window.func#Attributes.FAM09MAQ#()
		}
	</cfoutput>	

	return;
}
<!--------------------------------------->


</script>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput>
<tr>
	<td nowrap width="1%">
<!---<input type="text" name="#Attributes.FAM12CODD#" id="#Attributes.FAM12CODD#" maxlength="9" size="10" onblur="javascript:" onfocus="this.select()"
value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).FAM12CODD)#</cfif>" >
 --->
		<input tabindex="#Attributes.tabindex#"
		type="text" name="#Attributes.FAM09MAQ#" id="#Attributes.FAM09MAQ#"
		maxlength="9" size="10" style="text-align: right;" 
		onBlur="javascript: fm(this,-1); TraeMaquina#Attributes.FAM09MAQ#(document.#Attributes.form#.#Evaluate('Attributes.FAM09MAQ')#.value);" 
		onFocus="javascript: this.select(); this.value=qf(this);"  
		onKeyUp="javascript: if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).FAM09MAQ)#</cfif>">
   </td>
   <td nowrap width="1%">
		<input tabindex="-1" type="text" name="#Attributes.FAM09DES#" id="#Attributes.FAM09DES#" maxlength="50" size="#Attributes.size#" disabled 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).FAM09DES)#</cfif>">
	</td>
	<td width="98%">
		<a  href="##" tabindex="-1"><img id="FAM09MAQ" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Maquinas" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisMaquinas#Attributes.FAM09MAQ#();'></a>
	</td>
	<!---<input type="hidden" name="#Attributes.FAM09MAQ#" id="#Attributes.FAM09MAQ#" 
	value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).FAM09MAQ)#</cfif>">--->
</tr>
</table>
</cfoutput>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>
  
