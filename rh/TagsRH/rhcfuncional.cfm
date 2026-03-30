<cfset def = QueryNew('CFcodigo')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 	default="#Session.DSN#"	type="String"> 	<!--- Nombre de la conexión --->
<cfparam name="Attributes.form"     	default="form1" 		type="String">	<!--- Nombre del form --->
<cfparam name="Attributes.query" 		default="#def#" 		type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.name" 		default="CFcodigo" 		type="string">	<!--- Nombre del Código --->
<cfparam name="Attributes.desc" 		default="CFdescripcion" type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.id"    		default="CFid" 			type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.frame" 		default="frcfuncional" 	type="string">	<!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" 	default="" 				type="string">	<!--- número del tabindex --->
<cfparam name="Attributes.size" 		default="30" 			type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.codigosize"	default="10" 			type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.excluir" 		default="-1" 			type="string">	<!--- centro funcional que no debe salir en la lista --->
<cfparam name="Attributes.titulo" 		default="" 			    type="string">	<!--- leyenda para el conlis --->
<cfparam name="Attributes.index" 		default="" 			    type="string">	<!--- indice que se utiliza para tener más de un tag en una misma pantalla --->
<cfparam name="Attributes.Ecodigo" 		default="#session.Ecodigo#" type="numeric">	<!--- indice que se utiliza para tener más de un tag en una misma pantalla --->
<cfparam name="Attributes.EcodigoName" 	default="" 				type="string">	<!--- indice que se utiliza para tener más de un tag en una misma pantalla --->
<cfparam name="Attributes.readonly" 	default="no" 			type="boolean"> <!--- Sólo lectura --->
<cfparam name="Attributes.width" 		default="650" 			type="numeric">
<cfparam name="Attributes.height" 		default="460" 			type="numeric">
<cfparam name="Attributes.contables" 	default="-1" 			type="string">	<!--- centro funcional que posee definido la cuenta de gasto o compra de servicios --->
<cfparam name="Attributes.AgregarEnLista" default="false" 		type="boolean"><!--- permite agregar un centro funcional a una lista por medio del boton (+) --->
<cfparam name="Attributes.onchange" 	default="" 				type="string"><!---indica qué funcion javascript ejecutar despues del change --->

<!----========== TRADUCCION =============----->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_Centros_Funcionales"
	Default="Lista de Centros Funcionales"	
	returnvariable="LB_Lista_de_Centros_Funcionales"/>
	
<cfif Attributes.AgregarEnLista>
	<cf_importJquery>
	<cfif len(trim(Attributes.index)) eq 0>
		<cfset Attributes.index=0>
	</cfif>
</cfif>	


<cfoutput>
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	<cfif Attributes.EcodigoName NEQ "">
		<cfif find("document.",Attributes.EcodigoName) EQ 1>
			<cfset LvarEcodigoName = Attributes.EcodigoName>
		<cfelseif find(".",Attributes.EcodigoName) GT 0>
			<cfset LvarEcodigoName = "document.#Attributes.EcodigoName#">
		<cfelse>
			<cfset LvarEcodigoName = "document.#Attributes.form#.#Attributes.EcodigoName#">
		</cfif>
	</cfif>
	
	function popUpWindow#Attributes.name##Attributes.index#(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
<cfif not Attributes.readOnly>
	function doConlisCFuncional#Attributes.name##Attributes.index#() {
		var params ="";
	<cfif Attributes.EcodigoName EQ "">
		params = "?ARBOL_POS="+escape(document.#Attributes.form#.#Attributes.id##Attributes.index#.value)+"&form=#Attributes.form#&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&onchange=#Attributes.onchange#&excluir=#Attributes.excluir#&contables=#Attributes.contables#&titulo=#JSStringFormat(Attributes.titulo)#&Ecodigo=#attributes.Ecodigo#";
	<cfelse>
		if (! #LvarEcodigoName#)
		{
			alert("Campo de Empresa '#LvarEcodigoName#' no existe");
			return;
		}
		if (#LvarEcodigoName#.value.replace(/\s*/,"") == "")
		{
			alert("Empresa no puede estar en blanco");
			return;
		}
		params = "?ARBOL_POS="+escape(document.#Attributes.form#.#Attributes.id##Attributes.index#.value)+"&form=#Attributes.form#&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&onchange=#Attributes.onchange#&conexion=#Attributes.conexion#&excluir=#Attributes.excluir#&titulo=#JSStringFormat(Attributes.titulo)#&Ecodigo=" + #LvarEcodigoName#.value;
	</cfif>
		popUpWindow#Attributes.name##Attributes.index#("/cfmx/rh/Utiles/ConlisCFuncional.cfm"+params,250,200,#Attributes.width#,#Attributes.height#);
		window.onfocus=closePopup;
	}
	</cfif>
	function closePopup() {
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
			popUpWin = null;
		}
	}
	
	function conlis_keyup_#Attributes.name##Attributes.index#(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisCFuncional#Attributes.name##Attributes.index#();
		}
	}
	
<cfif not Attributes.readOnly>
	//Obtiene la descripción con base al código
	function TraeCFuncional#Attributes.name##Attributes.index#(dato) { 
		window.CFid = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.id#</cfoutput><cfoutput>#Attributes.index#</cfoutput>;
		window.CFcodigo = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.name#</cfoutput><cfoutput>#Attributes.index#</cfoutput>;
		window.CFdescripcion = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.desc#</cfoutput><cfoutput>#Attributes.index#</cfoutput>;
		var params ="";
	<cfif Attributes.EcodigoName EQ "">
		params = "&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&onchange=#Attributes.onchange#&excluir=#Attributes.excluir#&Ecodigo=#attributes.Ecodigo#";
	<cfelse>
		if (! #LvarEcodigoName#)
		{
			alert("Campo de Empresa '#LvarEcodigoName#' no existe");
			return;
		}
		if (#LvarEcodigoName#.value.replace(/\s*/,"") == "")
		{
			alert("Empresa no puede estar en blanco");
			return;
		}
		params = "&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&onchange=#Attributes.onchange#&excluir=#Attributes.excluir#&Ecodigo=" + #LvarEcodigoName#.value;
	</cfif>
		if (dato != "") {
			<cfoutput>
				var fr = document.getElementById("#Attributes.frame##Attributes.index#");
		/*Aqui se cae*/	fr.src="/cfmx/rh/Utiles/rhcfuncionalquery.cfm?dato="+dato+"&form="+"#Attributes.form#"+params;
			</cfoutput>
			<cfif isdefined("Attributes.onchange") and len(trim(Attributes.onchange))>	
				#Attributes.onchange#();
			</cfif>
		}
		else{
			document.#Attributes.form#.#Attributes.id##Attributes.index#.value   = "";
			document.#Attributes.form#.#Attributes.name##Attributes.index#.value = "";
			document.#Attributes.form#.#Attributes.desc##Attributes.index#.value = "";
		}
		return;
	}	

	
</cfif>
	
</script>

<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<!--- <cfset id   = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')##Evaluate('Attributes.index')#')#')"> --->
		<!--- <cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')##Evaluate('Attributes.index')#')#')"> --->
		<!--- <cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')##Evaluate('Attributes.index')#')#')"> --->

		<!--- Se modifican estos dos por que dan problemas cuando se les digita # en el nombre o descripcion --->
		<cfset id   = Trim(Evaluate('Attributes.query.#Attributes.id##Attributes.index#'))>
		<cfset name = Trim(Evaluate('Attributes.query.#Attributes.name##Attributes.index#'))>
		<cfset desc = Trim(Evaluate('Attributes.query.#Attributes.desc##Attributes.index#'))>
	</cfif>

	
	<tr>
		<td>
			<input type="text"
				name="#Attributes.name##Attributes.index#" id="#Attributes.name##Attributes.index#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#name#</cfif>"
				size="#attributes.codigosize#" 
				maxlength="10"
				<cfif Attributes.readOnly>
					tabindex="-1"
					readonly
					style="border:solid 1px ##CCCCCC; background:inherit;"
				<cfelse>
					<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
					onBlur="javascript: TraeCFuncional#Attributes.name##Attributes.index#(document.#Attributes.form#.#Attributes.name##Attributes.index#.value); " 
					onkeyup="javascript:conlis_keyup_#Attributes.name##Attributes.index#(event);"
					onFocus="javascript:this.select();">
				</cfif>
		</td>

		<td nowrap>
			<input type="text"
				name="#Attributes.desc##Attributes.index#" id="#Attributes.desc##Attributes.index#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#desc#</cfif>" 
				size="#Attributes.size#" maxlength="80"

				tabindex="-1"
				readonly
				>
		</td>
		<td>
        	<cfif not Attributes.readOnly>
			<a href="##" tabindex="-1">
				<img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_Centros_Funcionales#" name="imagen" id="imagen" 
					 width="18" height="14" border="0" align="absmiddle" 
					 onClick='javascript: doConlisCFuncional#Attributes.name##Attributes.index#();'>
			</a>
				<input type="hidden" name="#Attributes.id##Attributes.index#" id="#Attributes.id##Attributes.index#" 
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#id#</cfif>" >


<iframe name="#Attributes.frame##Attributes.index#" id="#Attributes.frame##Attributes.index#" 
		marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" 
		style="display:none;"></iframe>
			</cfif>
		</td>
		<cfif Attributes.AgregarEnLista>
		<td>
			<input type="button" onclick="AgregarCFuncionalLista<cfoutput>#Attributes.index#</cfoutput>()" value="+" class="btnNormal" />
		</td>				
		</cfif>
	</tr>
	<cfif Attributes.AgregarEnLista>
	<tr>
		<td colspan="4">
			<table id="ListaCFuncional<cfoutput>#Attributes.index#</cfoutput>">
			</table>
		</td>
	</tr>
	</cfif>
</table>
</cfoutput>


<cfif Attributes.AgregarEnLista>
	<script language="javascript">	
		function AgregarCFuncionalLista<cfoutput>#Attributes.index#</cfoutput>(){
				var existe = 0;
	
				if($('#ListaCFuncional<cfoutput>#Attributes.index#</cfoutput>').length){
					$('input.ListaCFuncional<cfoutput>#Attributes.index#</cfoutput>').each(function() {
						if($('#<cfoutput>#Attributes.id##Attributes.index#</cfoutput>').val() == $(this).val()){ existe=1;}
					});
				}
				if(existe == 1){
					alert("Este Centro Funcional ya se encuentra agregado");
				}
				else{	
					if($('#<cfoutput>#Attributes.id##Attributes.index#</cfoutput>').val() == ''){
						alert("Debe seleccionar un Centro Funcional");
					}	
					else{	
					 $('#ListaCFuncional<cfoutput>#Attributes.index#</cfoutput>').append("<tr><td nowrap='nowrap'><input class='<cfoutput>ListaCFuncional#Attributes.index#</cfoutput>' type='hidden' id='<cfoutput>ListaCFuncional#Attributes.index#</cfoutput>' name='<cfoutput>ListaCFuncional#Attributes.index#</cfoutput>' value="+$('#<cfoutput>#Attributes.id##Attributes.index#</cfoutput>').val()+">"+$('#<cfoutput>CFcodigo#Attributes.index#</cfoutput>').val()+" - " +$('#<cfoutput>#Attributes.desc##Attributes.index#</cfoutput>').val()+ "<img src='/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif' onclick='QuitarCFuncionalLista<cfoutput>#Attributes.index#</cfoutput>(this)' ></td></tr>");
					   $('#<cfoutput>#Attributes.id##Attributes.index#</cfoutput>').val(""); 
					   $('#<cfoutput>#Attributes.name##Attributes.index#</cfoutput>').val(""); 
					   $('#<cfoutput>#Attributes.desc##Attributes.index#</cfoutput>').val("");  
					} 
				}	
		}
		function QuitarCFuncionalLista<cfoutput>#Attributes.index#</cfoutput>(elemento){
			$(elemento).parent().parent().remove(); 
		}
	</script>
</cfif>
