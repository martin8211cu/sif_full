<!--- Parámetros del TAG --->


<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idquery" 			default="" 				type="string"> <!--- consulta por defecto --->

<cfparam name="Attributes.Ccuenta" 			default="Ccuenta" 		type="string"> <!--- Nombres del código de cuenta --->
<cfparam name="Attributes.Cformato" 		default="Cformato" 		type="string"> <!--- Nombres de la Formato Cuenta --->
<cfparam name="Attributes.Cdescripcion" 	default="Cdescripcion"	type="string"> <!--- Nombres de la Descripción Cuenta --->
<cfparam name="Attributes.Ctipo" 			default="" 				type="string"> <!--- Tipo --->

<cfparam name="Attributes.CGICMid" 			default=""		type="string">
<cfparam name="Attributes.CGICCid" 			default="" 				type="string">

<!--- 
SNcodigo, SNnombre, SNnumero, SNtiposocio
Ccuenta, Cformato, Cdescripcion, Ctipo
<cfparam name="Attributes.SNcodigo" 		default="SNcodigo" 		type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.SNnombre" 		default="SNnombre" 		type="string"> <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.SNnumero" 		default="SNnumero"		type="string"> <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.SNtiposocio" 		default="" 				type="string"> <!--- Si es proveedor (no clientes) ó si es cliente (no proveedor) --->
 --->

<cfparam name="Attributes.frame" 			default="frmapeo" 		type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="1" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.conlis" 			default="true" 			type="boolean"> <!--- Bandera para pintar o no la imagencilla que abre el conlis y permitir editar el codigo --->
<cfparam name="Attributes.modificable" default="true" type="boolean"><!--- Parámetros para impedir la modificación del dato --->

<!--- consultas --->
<!--- query --->


<script language="JavaScript">
var popUpWinSN=0;
function popUpWindow<cfoutput>#Attributes.Ccuenta#</cfoutput>(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp<cfoutput>#Attributes.Ccuenta#</cfoutput>;
}
function closePopUp<cfoutput>#Attributes.Ccuenta#</cfoutput>(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}

//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.Ccuenta#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisMapeo<cfoutput>#Attributes.Ccuenta#</cfoutput>();
		}
	}

function doConlisMapeo<cfoutput>#Attributes.Ccuenta#</cfoutput>() {
	<cfif Attributes.modificable>
			<cfif len(trim(Attributes.FuncJSalAbrir))>
				<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
			</cfif>	
			var params ="";
			params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.Ccuenta#&codigo=#Attributes.Cdescripcion#&desc=#Attributes.Cformato#&tipo=#Attributes.Ctipo#&CGICMid=#Attributes.CGICMid#&CGICCid=#Attributes.CGICCid#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0> 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
		
			popUpWindow<cfoutput>#Attributes.Ccuenta#</cfoutput>("/UtilesExt/ConlisMapeoCuentas.cfm"+params,150,100,750,700);
	</cfif>
}

function TraeMapeo<cfoutput>#Attributes.Ccuenta#</cfoutput>(codigo) {
	<cfif Attributes.modificable>
			var params ="";
			params = "<cfoutput>&id=#Attributes.Ccuenta#&desc=#Attributes.Cformato#&numero=#Attributes.Cdescripcion#&tipo=#Attributes.Ctipo#&CGICMid=#Attributes.CGICMid#&CGICCid=#Attributes.CGICCid#</cfoutput>";
			<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0> 
				params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
			</cfif>	
			
			if (codigo!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/UtilesExt/sifMapeoCuentasquery.cfm?codigo="+codigo+"&formulario="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
			}
			else{
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Ccuenta#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Cdescripcion#</cfoutput>.value = '';
				document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Cformato#</cfoutput>.value = '';
			}
			return;
	</cfif>
}
</script>

  <table width="1%" border="0" cellspacing="0" cellpadding="1">
	<cfoutput>
	<tr>
		<td nowrap width="1%">
			<input 
				type="text" 
				name="#Attributes.Cformato#" 
				id="#Attributes.Cformato#" 
				maxlength="15" 
				size="10" 
				<cfif not Attributes.modificable>
					disabled
				</cfif>
				onblur="javascript:TraeMapeo#Attributes.Ccuenta#(document.#Attributes.form#.#Attributes.Cformato#.value);" 
				onfocus="this.select()"	
				<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ false>
					readonly="true"
				</cfif>
				tabindex="#Attributes.tabindex#"
				onkeyup="javascript:conlis_keyup_#Attributes.Ccuenta#(event);"
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Cformato)#</cfif>">
		</td>
		<td nowrap width="1%">
			<input tabindex="-1" type="text" name="#Attributes.Cdescripcion#" id="#Attributes.Cdescripcion#" maxlength="255" size="#Attributes.size#" disabled 
			value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Cdescripcion)#</cfif>">
		</td>
		<td width="98%">
			<cfif isdefined("Attributes.conlis") and Attributes.conlis EQ true>
				<a  href="##" tabindex="-1">
					<img id="Mapeoimagen" src="/imagenes/Description.gif" alt="Lista de Cuentas Contables Sin Mapear" name="Mapeoimagen"
					 width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisMapeo#Attributes.Ccuenta#();'>
					 </a>
			</cfif>
		</td>
		<input type="hidden" name="#Attributes.Ccuenta#" id="#Attributes.Ccuenta#" value="<cfif isdefined("Attributes.idquery") and len(trim(Attributes.idquery)) >#Trim(Evaluate(queryName).Ccuenta)#</cfif>">
	</tr>
	</cfoutput>
	
  </table>
<iframe style="display:none; visibility:hidden" id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" 
	marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>