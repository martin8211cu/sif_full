<cfset def = QueryNew('RHCcodigo')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"		type="String"> 	<!--- Nombre de la conexión --->
<cfparam name="Attributes.form"     		default="form1" 			type="String">	<!--- Nombre del form --->
<cfparam name="Attributes.query" 			default="#def#" 			type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.name" 			default="RHCcodigo" 		type="string">	<!--- Nombre del Código --->
<cfparam name="Attributes.desc" 			default="RHCdescripcion" 	type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.id"    			default="RHCid" 			type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.frame" 			default="frcategorias" 		type="string">	<!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" 		default="" 					type="string">	<!--- número del tabindex --->
<cfparam name="Attributes.size" 			default="25" 				type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.codigosize"		default="10" 				type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.excluir" 			default="-1" 				type="string">	<!--- centro funcional que no debe salir en la lista --->
<cfparam name="Attributes.titulo" 			default="" 			    	type="string">	<!--- leyenda para el conlis --->
<cfparam name="Attributes.index" 			default="" 			    	type="string">	<!--- indice que se utiliza para tener más de un tag en una misma pantalla --->
<cfparam name="Attributes.empresa" 			default="#Session.Ecodigo#" type="string">	<!--- Empresa a la que pertenecen las categorías --->
<cfparam name="Attributes.tablasalarial" 	default="RHTTid" 			type="string">	<!--- Nombre del campo de la tabla salarial --->
<cfparam name="Attributes.maestropuesto" 	default="RHMPPid" 			type="string">	<!--- Nombre del campo del maestro puesto --->
<cfparam name="Attributes.ValidaCatPuesto" 	default="false" 			type="boolean">	<!--- Indica si requiere validar la existencia del puesto en Categorias Puesto --->

<cfoutput>
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;

	function popUpWindow#Attributes.name##Attributes.index#(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis#Attributes.name##Attributes.index#() {
		var params ="";
		params = "?ARBOL_POS="+escape(document.#Attributes.form#.#Attributes.id##Attributes.index#.value)+"&form=#Attributes.form#&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&excluir=#Attributes.excluir#&titulo=#JSStringFormat(Attributes.titulo)#&empresa=#JSStringFormat(Attributes.empresa)#";
		<cfif attributes.ValidaCatPuesto>
		<cfoutput>
			if (document.#attributes.form#.#attributes.tablasalarial##Attributes.index#.value != '' ) {
				params = params + '&RHTTid#Attributes.index#=' + document.#attributes.form#.#attributes.tablasalarial##Attributes.index#.value;
			}
			if (document.#attributes.form#.#attributes.maestropuesto##Attributes.index#.value != '' ) {
				params = params + '&RHMPPid=' + document.#attributes.form#.#attributes.maestropuesto##Attributes.index#.value;
			}
		</cfoutput>
		</cfif>
		popUpWindow#Attributes.name##Attributes.index#("/cfmx/rh/Utiles/conlisCategorias.cfm"+params,250,200,650,460);
		window.onfocus=closePopup;
	}
	function closePopup() {
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
			popUpWin = null;
		}
	}

	//Obtiene la descripción con base al código
	function Trae#Attributes.name##Attributes.index#(dato) {
		var params ="";
		params = "&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&ecodigo=#Attributes.empresa#&excluir=#Attributes.excluir#";
		<cfif attributes.ValidaCatPuesto>
		<cfoutput>
			if (document.#attributes.form#.#attributes.tablasalarial##Attributes.index#.value != '' ) {
				params = params + '&RHTTid#Attributes.index#=' + document.#attributes.form#.#attributes.tablasalarial##Attributes.index#.value;
			}
			if (document.#attributes.form#.#attributes.maestropuesto##Attributes.index#.value != '' ) {
				params = params + '&RHMPPid=' + document.#attributes.form#.#attributes.maestropuesto##Attributes.index#.value;
			}
		</cfoutput>
		</cfif>

		if (dato != "") {
			document.getElementById("#Attributes.frame##Attributes.index#").src="/cfmx/rh/Utiles/rhcategoriasquery.cfm?dato="+dato+"&form="+"#Attributes.form#"+params;
		}
		else{
			document.#Attributes.form#.#Attributes.id##Attributes.index#.value   = "";
			document.#Attributes.form#.#Attributes.name##Attributes.index#.value = "";
			document.#Attributes.form#.#Attributes.desc##Attributes.index#.value = "";
			if (window.parent.func#trim(Attributes.name)#) {window.parent.func#trim(Attributes.name)#();}		
		}
		return;
	}	
</script>
<!----================ TRADUCCION =====================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_Categorias"
	Default="Lista de Categorías"	
	returnvariable="LB_Lista_de_Categorias"/>

<table width="" border="0" cellspacing="0" cellpadding="0">
<cfif Attributes.index neq 1 and isdefined('Attributes.query.RHCid2') and len(trim(Attributes.query.RHCid2)) gt 0>

	<cfset id=#Evaluate('Attributes.query.#Evaluate('Attributes.id')##Evaluate('Attributes.index')#')#>
		<cfquery name="rsDato" datasource="#session.dsn#">
			select RHCcodigo,RHCdescripcion,RHCid from RHCategoria
			where RHCid=#id#
		</cfquery>
			<cfset id   = "Trim('#Evaluate('rsDato.RHCid')#')">
			<cfset name = "Trim('#Evaluate('rsDato.RHCcodigo')#')">
			<cfset desc = "Trim('#Evaluate('rsDato.RHCdescripcion')#')">
<cfelseif Attributes.index eq 1 or len(trim(Attributes.index)) eq 0>	
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id   = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">
	</cfif>
<cfelse>
		<cfset id   = ''>
		<cfset name = ''>
		<cfset desc = ''>
</cfif>

	<tr>
		<td>
			<input type="text"
				name="#Attributes.name##Attributes.index#" id="#Attributes.name##Attributes.index#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#name#'))#</cfif>"
				onBlur="javascript: Trae#Attributes.name##Attributes.index#(document.#Attributes.form#.#Attributes.name##Attributes.index#.value); " 
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
		<td nowrap="nowrap">
			<a href="##" tabindex="-1">
				<img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_Categorias#" name="imagen" 
					 width="18" height="14" border="0" align="absmiddle" 
					 <cfif attributes.ValidaCatPuesto>
					 onClick='javascript: if (document.#attributes.form#.#attributes.maestropuesto##Attributes.index#.value != "" ) {doConlis#Attributes.name##Attributes.index#();}else{alert("Debe seleccionar el puesto."); return false;}'
					 <cfelse>
					 onClick='javascript: doConlis#Attributes.name##Attributes.index#();'
					 </cfif>
					 id="img#Attributes.name##Attributes.index#">
			</a>
				<input type="hidden" name="#Attributes.id##Attributes.index#" 
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#id#'))#</cfif>" >
		</td>
	</tr>
</table>
<iframe name="#Attributes.frame##Attributes.index#" id="#Attributes.frame##Attributes.index#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility:hidden;"></iframe>

</cfoutput>
