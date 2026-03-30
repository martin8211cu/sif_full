
<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.CDCcodigo" 		default="CDCcodigo"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.CDCidentificacion" default="CDCidentificacion"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.Ecodigo" 			default="Ecodigo"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.CDCnombre"    	default="CDCnombre"     type="string"> <!--- Nombres de la descripción de la maquina --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.excluir" 			default="" 				type="string">
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.frame" 			default="frOficina" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.modificable"      default="true"          type="boolean"><!--- Parámetros para impedir la modificación del dato --->
<cfparam name="Attributes.Nuevo"            default="false"         type="boolean"><!--- Parámetro para incluir boton de nuevo --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsSocioCorp_#trim(Attributes.CDCcodigo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select CDCcodigo, CDCidentificacion, CDCnombre
		from ClientesDetallistasCorp
		where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
		  and CDCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
	<!--//
	var popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>=0;
	function popUpWindow<cfoutput>#Attributes.CDCcodigo#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>.close();
		}
		popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp<cfoutput>#Attributes.CDCcodigo#</cfoutput>;
	}
	function closePopUp<cfoutput>#Attributes.CDCcodigo#</cfoutput>(){
		if(popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>.close();
			popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>=null;
		}
	}
	function doConlisClienteDetCorp2<cfoutput>#Attributes.CDCidentificacion#</cfoutput>() {
		<cfif Attributes.modificable>
			<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
			var params ="";
			params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.CDCcodigo#&codigo=#Attributes.CDCidentificacion#&desc=#Attributes.CDCnombre#&excluir=#Attributes.excluir#&Nuevo=#Attributes.Nuevo#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
			popUpWindow<cfoutput>#Attributes.CDCcodigo#</cfoutput>("/cfmx/sif/Utiles/ConlisClienteDetCorp2.cfm"+params,250,200,650,410);
		</cfif>
	}
	function TraeClienteCorporativo<cfoutput>#Attributes.CDCidentificacion#</cfoutput>(valor) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.CDCcodigo#&desc=#Attributes.CDCnombre#&codigo=#Attributes.CDCidentificacion#&excluir=#Attributes.excluir#&frame=#Attributes.frame#</cfoutput>";
		
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
	
		if (valor!='') {
			document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifClienteDetCorp2query.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		
		}
		else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCcodigo#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCidentificacion#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCnombre#</cfoutput>.value = '';
		}
		
		<cfoutput>
			if (window.func#Attributes.CDCidentificacion#) {
				window.func#Attributes.CDCidentificacion#()
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
		type="text" name="#Attributes.CDCidentificacion#" id="#Attributes.CDCidentificacion#"
		maxlength="9" size="10"  <cfif not Attributes.modificable>disabled</cfif> style="text-align: right;" 
		onBlur="javascript: fm(this,-1); TraeClienteCorporativo#Attributes.CDCidentificacion#(document.#Attributes.form#.#Evaluate('Attributes.CDCidentificacion')#.value);" 
		onFocus="javascript: this.select(); this.value=qf(this);"  
		onKeyUp="javascript: if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).CDCidentificacion)#</cfif>">
   </td>
   <td nowrap width="1%">
		<input tabindex="-1" type="text" name="#Attributes.CDCnombre#" id="#Attributes.CDCnombre#" maxlength="50" size="#Attributes.size#" disabled 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).CDCnombre)#</cfif>">
	</td>
	<td width="98%">
		<a  href="##" tabindex="-1"><img id="CDCidentificacion" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Clientes Detallistas Corporativos" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisClienteDetCorp2#Attributes.CDCidentificacion#();'></a>
	</td>
	<input type="hidden" name="#Attributes.CDCcodigo#" id="#Attributes.CDCcodigo#" 
	value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).CDCcodigo)#</cfif>">
</tr>
</table>
</cfoutput>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>
