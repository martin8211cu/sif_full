<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.BTid" 			default="BTid"	 		type="string"> <!--- Nombres del código  --->
<cfparam name="Attributes.BTcodigo" 		default="BTcodigo"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.Ecodigo" 			default="Ecodigo"	 	type="string"> <!--- Nombres de la código de la maquina --->
<cfparam name="Attributes.BTdescripcion" 	default="BTdescripcion" type="string"> <!--- Nombres de la descripción  --->
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
	<cfset queryName = "rsTransaccionesDeposito_#trim(Attributes.BTid)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select BTid, BTcodigo, BTdescripcion
		from BTransacciones
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
	<!--//
	var popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput>=0;
	function popUpWindow<cfoutput>#Attributes.BTid#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput>.close();
		}
		popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp<cfoutput>#Attributes.BTid#</cfoutput>;
	}
	function closePopUp<cfoutput>#Attributes.BTid#</cfoutput>(){
		if(popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput>.close();
			popUpWinSN<cfoutput>#Attributes.BTid#</cfoutput>=null;
		}
	}
	function doConlisTransaccionesDeposito<cfoutput>#Attributes.BTcodigo#</cfoutput>() {
		<cfif isdefined("Attributes.FuncJSalAbrir") and Len(Trim(Attributes.FuncJSalAbrir))>
			<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		</cfif>
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.BTid#&codigo=#Attributes.BTcodigo#&desc=#Attributes.BTdescripcion#&excluir=#Attributes.excluir#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow<cfoutput>#Attributes.BTid#</cfoutput>("/cfmx/sif/Utiles/ConlisTransaccionesDeposito.cfm"+params,250,200,650,400);
		
	}
	function TraeTransaccionesDeposito<cfoutput>#Attributes.BTcodigo#</cfoutput>(valor) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.BTid#&desc=#Attributes.BTdescripcion#&codigo=#Attributes.BTcodigo#&excluir=#Attributes.excluir#&frame=#Attributes.frame#</cfoutput>";
		
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
	
		if (valor!='') {
			document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifTransaccionesDepositoquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		
		}
		else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.BTid#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.BTcodigo#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.BTdescripcion#</cfoutput>.value = '';
		}
		
		<cfoutput>
			if (window.func#Attributes.BTcodigo#) {
				window.func#Attributes.BTcodigo#()
			}
		</cfoutput>	
	
		return;
	}
	//-->
</script>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput>
<tr>
	<td nowrap width="1%">
		<input tabindex="#Attributes.tabindex#"
		type="text" name="#Attributes.BTcodigo#" id="#Attributes.BTcodigo#"
		maxlength="9" size="10" style="text-align: right;" 
		onBlur="javascript: fm(this,-1); TraeTransaccionesDeposito#Attributes.BTcodigo#(document.#Attributes.form#.#Evaluate('Attributes.BTcodigo')#.value);" 
		onFocus="javascript: this.select(); this.value=qf(this);"  
		onKeyUp="javascript: if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).BTcodigo)#</cfif>">
   </td>
   <td nowrap width="1%">
		<input tabindex="-1" type="text" name="#Attributes.BTdescripcion#" id="#Attributes.BTdescripcion#" maxlength="50" size="#Attributes.size#" disabled 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).BTdescripcion)#</cfif>">
	</td>
	<td width="98%">
		<a  href="##" tabindex="-1"><img id="BTcodigo" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Transacciones de Depósito" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTransaccionesDeposito#Attributes.BTcodigo#();"></a>
	</td>
	<input type="hidden" name="#Attributes.BTid#" id="#Attributes.BTid#" 
	value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).BTid)#</cfif>">
</tr>
</table>
</cfoutput>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>

