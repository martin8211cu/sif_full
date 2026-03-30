
<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.CDCcodigo" 		default="CDCcodigo"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.CDCidentificacion" default="CDCidentificacion"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.Ecodigo" 			default="Ecodigo"	 	type="string"> <!--- Nombres del código de la maquina --->
<cfparam name="Attributes.CDCnombre"    	default="CDCnombre"     type="string"> <!--- Nombres de la descripción de la maquina --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="-1" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.excluir" 			default="" 				type="string">
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.frame" 			default="frOficina" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.modificable" 		default="true" 			type="boolean"><!--- Parámetros para impedir la modificación del dato --->
<cfparam name="Attributes.CDCtipo" 			default="CDCtipo" 		type="string"><!--- Nombres del Tipo de Formato --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >
	<cfset queryName = "rsSocioCorp_#trim(Attributes.CDCcodigo)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select CDCcodigo, CDCidentificacion, CDCnombre, CDCtipo
		from ClientesDetallistasCorp
		where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
		  and CDCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">
	</cfquery>
</cfif>
<!--- query --->
<cfquery name="rsMascaras" datasource="#Session.dsn#">
	select rtrim(J.Pvalor) Juridica, rtrim(F.Pvalor) Fisica
	from Parametros J, Parametros F
	where J.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and J.Pcodigo = 620
	  and F.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and F.Pcodigo = 630
</cfquery>
<cfset LvarCDCtipo = "">

<cfif len(rsMascaras.Juridica) GT len(rsMascaras.Fisica)>
	<cfset LvarSize = len(rsMascaras.Juridica)>
<cfelse>
	<cfset LvarSize = len(rsMascaras.Fisica)>
</cfif>
<cfif Attributes.Size EQ "-1">
	<cfif LvarSize GT 0>
		<cfset Attributes.Size = LvarSize + 5>
	<cfelse>
		<cfset Attributes.Size = "30">
	</cfif>
</cfif>

<script language="JavaScript">
	<!--//
	var popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>=0;
	function popUpWindow<cfoutput>#Attributes.CDCcodigo#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>.close();
		}
		popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onFocus = closePopUp<cfoutput>#Attributes.CDCcodigo#</cfoutput>;
	}
	function closePopUp<cfoutput>#Attributes.CDCcodigo#</cfoutput>(){
		if(popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>.close();
			popUpWinSN<cfoutput>#Attributes.CDCcodigo#</cfoutput>=null;
		}
	}
//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.CDCcodigo#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisClienteDetCorp<cfoutput>#Attributes.CDCidentificacion#</cfoutput>();
		}
	}

	
	
	function doConlisClienteDetCorp<cfoutput>#Attributes.CDCidentificacion#</cfoutput>() {
		<cfif Attributes.modificable>
			<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
			var params ="";
			params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.CDCcodigo#&codigo=#Attributes.CDCidentificacion#&desc=#Attributes.CDCnombre#&tipo=#Attributes.CDCtipo#&excluir=#Attributes.excluir#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
			popUpWindow<cfoutput>#Attributes.CDCcodigo#</cfoutput>("/cfmx/sif/Utiles/ConlisClienteDetCorp.cfm"+params,250,200,650,400);
		</cfif>
	}
	function TraeClienteCorporativo<cfoutput>#Attributes.CDCidentificacion#</cfoutput>(valor) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.CDCcodigo#&desc=#Attributes.CDCnombre#&codigo=#Attributes.CDCidentificacion#&tipo=#Attributes.CDCtipo#&excluir=#Attributes.excluir#&frame=#Attributes.frame#</cfoutput>";
			
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
	
		if (valor!='') {
			document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifClienteDetCorpquery.cfm?valor="+valor+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		}
		else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCcodigo#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCidentificacion#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CDCnombre#</cfoutput>.value = '';
		}
	
		return;
	}
	//-->
</script>

<cfparam name="Request.jsMask" default="false">

<cfif Request.jsMask EQ false>
	<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfset Request.jsMask = true>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput>
<tr>
	<td nowrap width="1%">
	<cfif LvarSize GT 0>
		<select name="#Attributes.CDCtipo#" id="#Attributes.CDCtipo#" onChange="cambiaMasc(this.value);" title="tipo: F='Fiscal', J='Jur&iacute;dico'">
				<option value="O"></option>
		<cfif len(rsMascaras.Fisica) GT 0>
				<option value="F" <cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) and Trim(Evaluate(queryName).CDCtipo) EQ 'F'> selected</cfif>>Fis</option>
		</cfif>
		<cfif len(rsMascaras.Juridica) GT 0>
			<option value="J" <cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) and Trim(Evaluate(queryName).CDCtipo) EQ 'J'> selected</cfif>>Jur</option>
		</cfif>
			<option value="E" <cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) and Trim(Evaluate(queryName).CDCtipo) EQ 'E'> selected</cfif>>Ext</option>
		</select>
	</cfif>
	<input type="text"
			name="#Attributes.CDCidentificacion#" 
			id="#Attributes.CDCidentificacion#"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).CDCidentificacion)#</cfif>"
			size="#Attributes.Size#" 
			maxlength="30"
			onFocus="this.select();"
			onkeyup="javascript:conlis_keyup_#Attributes.CDCcodigo#(event);"
			<cfif not Attributes.modificable>readonly="yes"</cfif>
			<cfif Attributes.tabindex NEQ "">tabindex="#Attributes.tabindex#"</cfif>>   
	</td>
	<td nowrap width="1%">
		<input tabindex="-1" type="text" name="#Attributes.CDCnombre#" id="#Attributes.CDCnombre#" maxlength="255" size="#Attributes.size#" disabled 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>#Trim(Evaluate(queryName).CDCnombre)#</cfif>">
	</td>
	<td width="98%">
		<a  href="##" tabindex="-1"><img id="imgCDCidentificacion" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Clientes Detallistas Corporativos" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisClienteDetCorp#Attributes.CDCidentificacion#();'></a>
	</td>
	<input type="hidden" name="#Attributes.CDCcodigo#" id="#Attributes.CDCcodigo#" 
	value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).CDCcodigo)#</cfif>">
</tr>
</table>
</cfoutput>
<iframe style=" display:none" id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>
<cfif isdefined('rsMascaras') and rsMascaras.recordCount GT 0>
	<cfset LvarCDCtipo = rsMascaras.Fisica>
</cfif>

<script language="javascript" type="text/javascript">
	function sbSelect(obj)
	{
		alert("hola");
	}
	<cfoutput>
		var oCedulaMask = new Mask("#replace(LvarCDCtipo,'X','##','ALL')#", "string");
		eval("oCedulaMask.attach(document.#Attributes.form#.#Attributes.CDCidentificacion#, oCedulaMask.mask, 'string','TraeClienteCorporativo#Attributes.CDCidentificacion#(document.#Attributes.form#.#Evaluate('Attributes.CDCidentificacion')#.value);');"); 

		function cambiaMasc(val){	
			if (val == 'F'){
				eval("document.#Attributes.form#.#Attributes.CDCidentificacion#.value = '';");
				eval("document.#Attributes.form#.#Attributes.CDCnombre#.value = '';");
				eval("document.#Attributes.form#.#Attributes.CDCcodigo#.value = '';");
				oCedulaMask.mask = "#replace(rsMascaras.Fisica,'X','##','ALL')#";
			}else if (val == 'J'){
				eval("document.#Attributes.form#.#Attributes.CDCidentificacion#.value = '';");
				eval("document.#Attributes.form#.#Attributes.CDCnombre#.value = '';");
				eval("document.#Attributes.form#.#Attributes.CDCcodigo#.value = '';");
				oCedulaMask.mask = "#replace(rsMascaras.Juridica,'X','##','ALL')#";
			}else if (val == 'E'){
				eval("document.#Attributes.form#.#Attributes.CDCidentificacion#.value = '';");
				eval("document.#Attributes.form#.#Attributes.CDCnombre#.value = '';");
				eval("document.#Attributes.form#.#Attributes.CDCcodigo#.value = '';");
				oCedulaMask.mask = "#RepeatString("*", 30)#";
			}else{
				eval("document.#Attributes.form#.#Attributes.CDCidentificacion#.value = '';");
				eval("document.#Attributes.form#.#Attributes.CDCnombre#.value = '';");
				eval("document.#Attributes.form#.#Attributes.CDCcodigo#.value = '';");
				oCedulaMask.mask = "";
			}
		}
		
		// eval("cambiaMasc(document.#Attributes.form#.#Attributes.CDCtipo#.value);");
	</cfoutput>	
</script>
