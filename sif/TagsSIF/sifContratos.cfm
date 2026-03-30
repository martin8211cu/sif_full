<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.ECid" 			default="ECid"	 		type="string"> <!--- Nombres del código  --->
<cfparam name="Attributes.Ecodigo" 			default="Ecodigo"	 	type="string"> <!--- Nombre Ecodigo --->
<cfparam name="Attributes.ECdesc" 			default="ECdesc" 		type="string"> <!--- Nombres de la descripción  --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.excluir" 			default="" 				type="string">
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.frame" 			default="frOficina" 	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.SNcodigo" 		default="" 				type="string"> <!--- P  --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery))>
	<cfset queryName = "rsContratos_#trim(Attributes.ECid)#">
	<cfquery name="#queryName#" datasource="#Attributes.Conexion#">
		select ECid, ECdesc
			from EcontratosCM
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idquery#">			
	</cfquery>
</cfif>



<script language="JavaScript">
	<!--//
	var popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput>=0;
	function popUpWindow<cfoutput>#Attributes.ECid#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput>.close();
		}
		popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput> = open(URLStr, 'popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp<cfoutput>#Attributes.ECid#</cfoutput>;
	}
	function closePopUp<cfoutput>#Attributes.ECid#</cfoutput>(){
		if(popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput>) {
			if(!popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput>.closed) popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput>.close();
			popUpWinSN<cfoutput>#Attributes.ECid#</cfoutput>=null;
		}
	}
	function doConlisContratos<cfoutput>#Attributes.ECid#</cfoutput>() {
		<cfif isdefined("Attributes.FuncJSalAbrir") and Len(Trim(Attributes.FuncJSalAbrir))>
			<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		</cfif>
		<cfoutput>
		<cfif isdefined("Attributes.SNcodigo") and len(trim(Attributes.SNcodigo))>
			if (document.#Attributes.form#.#Attributes.SNcodigo#.value != '') {
		</cfif>
			var params ="";
			var codSNcodigo = "";
			<cfif isdefined("Attributes.SNcodigo") and len(trim(Attributes.SNcodigo))>
				codSNcodigo = eval("document.<cfoutput>#Attributes.form#.#Attributes.SNcodigo#.value</cfoutput>");			
			</cfif>			

			if(codSNcodigo != '')
				params = "?formulario=#Attributes.form#&id=#Attributes.ECid#&desc=#Attributes.ECdesc#&prov=" + codSNcodigo + "&excluir=#Attributes.excluir#";
			else
				params = "?formulario=#Attributes.form#&id=#Attributes.ECid#&desc=#Attributes.ECdesc#&excluir=#Attributes.excluir#";			
			
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>
			popUpWindow<cfoutput>#Attributes.ECid#</cfoutput>("/cfmx/sif/Utiles/ConlisContratos.cfm"+params,250,200,650,400);
		<cfif isdefined("Attributes.SNcodigo") and len(trim(Attributes.SNcodigo))>
			} else {
				alert('Debe seleccionar un proveedor primero');
			}
		</cfif>
		</cfoutput>
		
	}
	function TraeContratos<cfoutput>#Attributes.ECid#</cfoutput>(valor) {
		<cfoutput>
		<cfif isdefined("Attributes.SNcodigo") and len(trim(Attributes.SNcodigo))>
			if (document.#Attributes.form#.#Attributes.SNcodigo#.value != '') {
		</cfif>
			var params ="";
			
			var codSNcodigo = "";
			<cfif isdefined("Attributes.SNcodigo") and len(trim(Attributes.SNcodigo))>
				codSNcodigo = eval("document.<cfoutput>#Attributes.form#.#Attributes.SNcodigo#.value</cfoutput>");			
			</cfif>			
			if(codSNcodigo != '')
				params = "?formulario=#Attributes.form#&id=#Attributes.ECid#&desc=#Attributes.ECdesc#&prov=" + codSNcodigo + "&excluir=#Attributes.excluir#";
			else
				params = "?formulario=#Attributes.form#&id=#Attributes.ECid#&desc=#Attributes.ECdesc#&excluir=#Attributes.excluir#";			
			
			<cfif Len(Trim("#Attributes.FuncJSalCerrar#")) GT 0 > 
				params = params + "&FuncJSalCerrar=#Attributes.FuncJSalCerrar#";
			</cfif>	
		
			if (valor!='') {
				document.all["#Attributes.frame#"].src="/cfmx/sif/Utiles/sifContratosquery.cfm"+params+"&valor="+valor;
			
			}
			else{
				document.#Attributes.form#.#Attributes.ECid#.value = '';
				document.#Attributes.form#.#Attributes.ECdesc#.value = '';
				<cfif isdefined("Attributes.SNcodigo") and len(trim(Attributes.SNcodigo))>
				document.#Attributes.form#.#Attributes.SNcodigo#.value  = '';
				</cfif>
			}
			
			if (window.func#Attributes.ECid#) {
					window.func#Attributes.ECid#()
			}
			return;
		<cfif isdefined("Attributes.SNcodigo") and len(trim(Attributes.SNcodigo))>
		}
		</cfif>
		</cfoutput>	
	}
	//-->
</script>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput>
<tr>
	<td nowrap width="1%">
		<input tabindex="#Attributes.tabindex#"
		type="text" name="#Attributes.ECid#" id="#Attributes.ECid#"
		maxlength="9" size="10" style="text-align: right;" 
		onBlur="javascript: fm(this,-1); TraeContratos#Attributes.ECid#(document.#Attributes.form#.#Evaluate('Attributes.ECid')#.value);" 
		onFocus="javascript: this.select(); this.value=qf(this);"  
		onKeyUp="javascript: if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).ECid)#</cfif>">
   </td>
   <td nowrap width="1%">
		<input tabindex="-1" type="text" name="#Attributes.ECdesc#" id="#Attributes.ECdesc#" maxlength="50" size="#Attributes.size#" disabled 
		value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).ECdesc)#</cfif>">
	</td>
	<td width="98%">
		<a  href="##" tabindex="-1"><img id="ECid" src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Contratos" name="BidImagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisContratos#Attributes.ECid#();"></a>
	</td>
</tr>
</table>
</cfoutput>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>

