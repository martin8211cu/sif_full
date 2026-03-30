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
<cfparam name="Attributes.size" 		default="40" 			type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.codigosize"	default="10" 			type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.excluir" 		default="-1" 			type="string">	<!--- centro funcional que no debe salir en la lista --->
<cfparam name="Attributes.titulo" 		default="" 			    type="string">	<!--- leyenda para el conlis --->
<cfparam name="Attributes.index" 		default="" 			    type="string">	<!--- indice que se utiliza para tener más de un tag en una misma pantalla --->

<cfoutput>
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;

	function popUpWindow#Attributes.name##Attributes.index#(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisCFuncional#Attributes.name##Attributes.index#() {
		var params ="";
		params = "?ARBOL_POS="+escape(document.#Attributes.form#.#Attributes.id##Attributes.index#.value)+"&form=#Attributes.form#&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&excluir=#Attributes.excluir#&titulo=#JSStringFormat(Attributes.titulo)#";
		popUpWindow#Attributes.name##Attributes.index#("/cfmx/rh/Utiles/ConlisCFuncionalCorp.cfm"+params,250,200,650,460);
		window.onfocus=closePopup;
	}
	function closePopup() {
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
			popUpWin = null;
		}
	}

	//Obtiene la descripción con base al código
	function TraeCFuncional#Attributes.name##Attributes.index#(dato) {
		var params ="";
		params = "&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&excluir=#Attributes.excluir#";
		if (dato != "") {
			document.getElementById("#Attributes.frame##Attributes.index#").src="/cfmx/rh/Utiles/rhcfuncionalcorpquery.cfm?dato="+dato+"&form="+"#Attributes.form#"+params;
		}
		else{
			document.#Attributes.form#.#Attributes.id##Attributes.index#.value   = "";
			document.#Attributes.form#.#Attributes.name##Attributes.index#.value = "";
			document.#Attributes.form#.#Attributes.desc##Attributes.index#.value = "";
		}
		return;
	}	
</script>

<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id   = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')##Evaluate('Attributes.index')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')##Evaluate('Attributes.index')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')##Evaluate('Attributes.index')#')#')">
	</cfif>

	
	<tr>
		<td>
			<input type="text"
				name="#Attributes.name##Attributes.index#" id="#Attributes.name##Attributes.index#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#name#'))#</cfif>"
				onBlur="javascript: TraeCFuncional#Attributes.name##Attributes.index#(document.#Attributes.form#.#Attributes.name##Attributes.index#.value); " 
				size="#attributes.codigosize#" 
				maxlength="10"
				onFocus="javascript:this.select();">
		</td>

		<td nowrap>
			<input type="text"
				name="#Attributes.desc##Attributes.index#" id="#Attributes.desc##Attributes.index#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#desc#'))#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80">
		</td>
		<td>
			<a href="##" tabindex="-1">
				<img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Centros Funcionales" name="imagen" 
					 width="18" height="14" border="0" align="absmiddle" 
					 onClick='javascript: doConlisCFuncional#Attributes.name##Attributes.index#();'>
			</a>
				<input type="hidden" name="#Attributes.id##Attributes.index#" 
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#id#'))#</cfif>" >
<iframe name="#Attributes.frame##Attributes.index#" id="#Attributes.frame##Attributes.index#" 
		marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" 
		style="visibility:hidden;"></iframe>

		</td>
	</tr>
</table>
</cfoutput>