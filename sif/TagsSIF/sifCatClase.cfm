<cfset def = QueryNew("ACcodigo") >
<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 	type="String"	default="#Session.DSN#" > 	<!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 		type="String"	default="form1" > 			<!--- Nombre del form --->
<cfparam name="Attributes.query" 		type="query"	default="#def#" > 			<!--- consulta por defecto --->
<cfparam name="Attributes.nameCat" 		type="string"	default="Categoria"	> 		<!--- Nombre del Código de la Categoría --->
<cfparam name="Attributes.nameClas" 	type="string"	default="Clasificacion" > 	<!--- Nombre del Código de la Clasificación --->
<cfparam name="Attributes.keyCat" 		type="string"	default="ACcodigo" > 		<!--- Nombre de la llave identity de la tabla de Categoría --->
<cfparam name="Attributes.keyClas" 		type="string"	default="ACid" > 			<!--- Nombre de la llave identity de la tabla de Clasificaciones --->
<cfparam name="Attributes.descCat" 		type="string"	default="Categoriadesc" > 	<!--- Nombre de la Descripción de la Categoria --->
<cfparam name="Attributes.descClas" 	type="string"	default="Clasificaciondesc" > <!--- Nombre de la Descripción del Clasificaciones --->
<cfparam name="Attributes.orientacion" 	type="string"	default="V" > 				<!--- Orientacion V=Vertical, <> V = Horizontal --->
<cfparam name="Attributes.frameCat" 	type="string"	default="frCat" > 			<!--- Nombre del frame --->
<cfparam name="Attributes.tabindexCat" 	type="string"	default="" > 				<!--- número del tabindex para el campo de Categoría --->
<cfparam name="Attributes.tabindexClas" type="string"	default="" > 				<!--- número del tabindex para el campo del Clasificación --->
<cfparam name="Attributes.size" 		type="string"	default="30" > 				<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.altCat" 		type="string"	default="" > 				<!--- Mensaje para el evento de MouseOver para la Categoría --->
<cfparam name="Attributes.altClas" 		type="string"	default="" > 				<!--- Mensaje para el evento de MouseOver para el Clasificación --->
<cfparam name="Attributes.Modificable" 	type="boolean"	default="true" >


<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.nameCat#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) 
				popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.nameCat#</cfoutput>(e,opc) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisCatClase<cfoutput>#Attributes.nameCat#</cfoutput>(opc);
		}
	}
	//Llama el conlis
	function doConlisCatClase<cfoutput>#Attributes.nameCat#</cfoutput>(opc) {
		<cfoutput>	
			var params ="";	
			if(opc == 1){	// Conlis de Categorías
				params = "?form=#Attributes.form#&name=#Attributes.nameCat#&desc=#Attributes.descCat#&key=#Attributes.keyCat#&conexion=#Attributes.conexion#&nameClas=#Attributes.nameClas#&descClas=#Attributes.descClas#&keyClas=#Attributes.keyClas#";
				popUpWindow#Attributes.nameCat#("/cfmx/sif/Utiles/ConlisCategorias.cfm"+params,250,200,650,400);
			}else{	//Conlis de Clasificaciones
				params = "?form=#Attributes.form#&nameClas=#Attributes.nameClas#&descClas=#Attributes.descClas#&keyClas=#Attributes.keyClas#&conexion=#Attributes.conexion#&descCat=" + escape(document.#Attributes.form#.#Evaluate('Attributes.descCat')#.value) + "&keyCat=" + escape(document.#Attributes.form#.#Evaluate('Attributes.keyCat')#.value);
				popUpWindow#Attributes.nameCat#("/cfmx/sif/Utiles/ConlisClase.cfm"+params,250,200,650,400);			
			}
		</cfoutput>			
	}
	//TraeCategoria
	function TraeCategoria<cfoutput>#Attributes.nameClas#</cfoutput>(dato) {
		<cfoutput>
			if (dato!="") {
				if(document.#Attributes.form#.#Evaluate('Attributes.nameCat')#.value == ''){
					alert('Primero debe elegir la Categoria');
					document.#Attributes.form#.#Evaluate('Attributes.nameClas')#.value = '';
					document.#Attributes.form#.#Evaluate('Attributes.nameCat')#.focus();
				}else{
					TraeClaseCat#Attributes.nameCat#(dato, 2);
				}
			}else{
				eval("document.#Attributes.form#.#Attributes.keyClas#.value = ''");
				eval("document.#Attributes.form#.#Attributes.nameClas#.value = ''");					
				eval("document.#Attributes.form#.#Attributes.descClas#.value = ''");				
			}
		</cfoutput>
		
		return
	}	
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.nameClas#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			validaDoConlis<cfoutput>#Attributes.nameClas#</cfoutput>();
		}
	}
	function validaDoConlis<cfoutput>#Attributes.nameClas#</cfoutput>(){
		<cfoutput>
			if(document.#Attributes.form#.#Evaluate('Attributes.nameCat')#.value == ''){
				alert('Primero debe elegir la Categoría');
				document.#Attributes.form#.#Evaluate('Attributes.nameClas')#.value = '';
				document.#Attributes.form#.#Evaluate('Attributes.nameCat')#.focus();
			}else{
				doConlisCatClase#Attributes.nameCat#(2);
			}
		</cfoutput>
	}
	
	//Obtiene la descripción según código
	function TraeClaseCat<cfoutput>#Attributes.nameCat#</cfoutput>(dato, opc) {
		<cfoutput>	
			var params ="";		
			
			if(opc == 1){	//Categorias
				params = "&keyClas=#Attributes.keyClas#&nameClas=#Attributes.nameClas#&descClas=#Attributes.descClas#&key=#Attributes.keyCat#&name=#Attributes.nameCat#&desc=#Attributes.descCat#&conexion=#Attributes.conexion#&ecodigo=#Session.Ecodigo#";				
				if (dato!="") {
					document.all["#Attributes.frameCat#"].src="/cfmx/sif/Utiles/sifCatClaseQuery.cfm?dato="+escape(dato)
							+ "&form="+'#Attributes.form#'
							+ "&opc=1"
							+ params;
				}else{
					eval("document.#Attributes.form#.#Attributes.keyCat#.value = ''");
					eval("document.#Attributes.form#.#Attributes.nameCat#.value = ''");					
					eval("document.#Attributes.form#.#Attributes.descCat#.value = ''");					
					
					eval("document.#Attributes.form#.#Attributes.keyClas#.value = ''");
					eval("document.#Attributes.form#.#Attributes.nameClas#.value = ''");					
					eval("document.#Attributes.form#.#Attributes.descClas#.value = ''");					
				}
			}else{	//Clases
				params = "&keyClas=#Attributes.keyClas#&nameClas=#Attributes.nameClas#&descClas=#Attributes.descClas#&conexion=#Attributes.conexion#&ecodigo=#Session.Ecodigo#";
				document.all["#Attributes.frameCat#"].src="/cfmx/sif/Utiles/sifCatClaseQuery.cfm?dato="+escape(dato)
						+ "&datoPadre="+ eval('document.#Attributes.form#.#Attributes.keyCat#.value')
						+ "&form="+'#Attributes.form#'
						+ "&opc=2"							
						+ params;
			}
		</cfoutput>
		
		return;
	}	
</script>

<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<!--- Para la Categoria --->	
	<cfset nameCat = "#Evaluate('Attributes.query.#Evaluate('Attributes.nameCat')#')#">
	<cfset descCat = "#Evaluate('Attributes.query.#Evaluate('Attributes.descCat')#')#">
	
	
	<cfset keyCat = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.keyCat')#')#')">				
	<!--- Para la clase --->
	<cfset nameClas = "#Evaluate('Attributes.query.#Evaluate('Attributes.nameClas')#')#">
	<cfset descClas = "#Evaluate('Attributes.query.#Evaluate('Attributes.descClas')#')#">		
	
	<cfset keyClas = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.keyClas')#')#')">		
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="50%" nowrap>
		<cfoutput>
			<table width="" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td nowrap>
					<input 
						<cfif Attributes.altCat NEQ ''>
							alt="#Attributes.altCat#"
						</cfif>
						type="hidden"
						name="#Attributes.keyCat#" 
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#keyCat#')#</cfif>">
						
					<input 	type="text"
							name="#Attributes.nameCat#" id="#Attributes.nameCat#2"
						<cfif len(trim(Attributes.tabindexCat)) GT 0> tabindex="#Attributes.tabindexCat#" </cfif>
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#nameCat#</cfif>" 
						<cfif Attributes.Modificable>
							onkeyup="javascript:conlis_keyup_#Attributes.nameCat#(event,1);"
							onBlur="javascript: TraeClaseCat#Attributes.nameCat#(document.#Attributes.form#.#Evaluate('Attributes.nameCat')#.value,1); " onFocus="this.select()"
						<cfelse>
							readonly="true" class="cajasinbordeb"
						</cfif>
						size="10" 
						maxlength="10">
				</td>
				<td nowrap>
					<input type="text"
						name="#Attributes.descCat#" id="#Attributes.descCat#"
						tabindex="-1" readonly="true" 
						<cfif not Attributes.Modificable> class="cajasinbordeb"</cfif>
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#descCat#</cfif>" 
						size="#Attributes.size#" 
						maxlength="80">
					<cfif Attributes.Modificable>
				</td>
				<td>
					<a href="##" tabindex="-1">
						<img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Marcas" name="imagen" 
							width="18" height="14" border="0" align="absmiddle" 
							onClick='javascript: doConlisCatClase#Attributes.nameCat#(1);'>
					</a>
					</cfif>
				</td>
			</tr>
			</table>
	</td>
	<cfif Attributes.orientacion EQ 'V'>
		</tr>
		<tr>
	</cfif>
    <td width="50%" nowrap>
		<table width="" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td nowrap>
					<input 
						<cfif Attributes.altClas NEQ ''>
							alt="#Attributes.altClas#"
						</cfif>
						type="hidden"
						name="#Attributes.keyClas#" 
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#keyClas#')#</cfif>">
      				
					<input type="text"
						name="#Attributes.nameClas#" id="#Attributes.nameClas#2"
						<cfif len(trim(Attributes.tabindexClas)) GT 0> tabindex="#Attributes.tabindexClas#" </cfif>					
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#nameClas#</cfif>"
						<cfif Attributes.Modificable>
							onkeyup="javascript:conlis_keyup_#Attributes.nameClas#(event);"
							onBlur="javascript: TraeCategoria#Attributes.nameClas#(document.#Attributes.form#.#Evaluate('Attributes.nameClas')#.value);"  onFocus="this.select()"
						<cfelse>
							readonly="true" class="cajasinbordeb"
						</cfif>
						size="10" 
						maxlength="10">
				</td>
				<td nowrap>
				<input type="text"
					name="#Attributes.descClas#" id="#Attributes.descClas#"
					tabindex="-1" readonly="true" <cfif not Attributes.Modificable> class="cajasinbordeb"</cfif>
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#descClas#</cfif>" 
					size="#Attributes.size#" 
					maxlength="80">
				</td>
				<cfif Attributes.Modificable>
				<td>
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Modelos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: validaDoConlis#Attributes.nameClas#();'></a>					
				</td>
				</cfif>
				
				</tr>
			</table>				
    	</td></cfoutput>
	
  </tr>
</table>

<iframe 
		name="<cfoutput>#Attributes.frameCat#</cfoutput>" 
		marginheight="0" 
		marginwidth="0" 
		frameborder="0" 
		height="0" 
		width="0" 
		scrolling="auto" 
		src=""
		style="display:none;">
</iframe>

