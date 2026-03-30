<cfset def = QueryNew("RHPcodigo") >

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#"  type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 	default="form1" 		 type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" 	default="#def#" 		 type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" 	default="PCEcatid" 		 type="string"> <!--- Nombre del campo llave --->
<cfparam name="Attributes.frame" 	default="frcatalogo" 	 type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.codigo" 	default="PCEcodigo" 	 type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.desc" 	default="PCEdescripcion" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" 				 type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" 	default="30" 	   		 type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.filtro" 	default="" 				 type="string"> <!---►►Filtro Extra◄◄ --->
<cfparam name="Attributes.funcion" 	default="" 				 type="string"> <!--- funcion js --->
<cfparam name="Attributes.llave" 	default="" 				 type="string"> <!--- si viene filtra para que este registro no aparezca --->
<cfparam name="Attributes.readonly" default="false" 		 type="boolean"> <!--- readonly --->
<cfparam name="Attributes.index" 	default="0" 			 type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;

	function popUpWindow<cfoutput>#Attributes.name##Attributes.index#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	
	function conlis_keyup_<cfoutput>#Attributes.name##Attributes.index#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisCatalogos<cfoutput>#Attributes.name##Attributes.index#</cfoutput>();
		}
	}
	function doConlisCatalogos<cfoutput>#Attributes.name##Attributes.index#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&name=#Attributes.name#&codigo=#Attributes.codigo#&desc=#Attributes.desc#&llave=#Attributes.llave#&conexion=#Attributes.conexion#&funcion=#Attributes.funcion#&filtro=#Attributes.filtro#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name##Attributes.index#</cfoutput>("/cfmx/sif/Utiles/ConlisCatalogos.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código
	function TraeCatalogo<cfoutput>#Attributes.codigo##Attributes.index#</cfoutput>(codigo,llave) {
		var params ="";
		params = "<cfoutput>&name=#Attributes.name#&codigo=#Attributes.codigo#&desc=#Attributes.desc#&valor="+ codigo +"&llave=#Attributes.llave#&conexion=#Attributes.conexion#&ecodigo=#Session.Ecodigo#&funcion=#Attributes.funcion#&filtro=#Attributes.filtro#</cfoutput>";
		if (codigo!="") {
			var fr = document.getElementById('<cfoutput>#Attributes.frame#</cfoutput>');
			fr.src = "/cfmx/sif/Utiles/sifcatalogosquery.cfm?&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		}
		else{
			<cfoutput>
			document.#Attributes.form#.#Attributes.name#.value = '';
			document.#Attributes.form#.#Attributes.codigo#.value = '';
			document.#Attributes.form#.#Attributes.desc#.value = '';
			</cfoutput>
		}
		return;
	}	
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset name   = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset codigo = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.codigo')#')#')">
		<cfset desc   = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="text" 
				name="#Attributes.codigo#" id="#Attributes.codigo#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#codigo#')#</cfif>" 
				onblur="javascript: TraeCatalogo#Attributes.codigo##Attributes.index#(document.#Attributes.form#.#Evaluate('Attributes.codigo')#.value, '#Attributes.llave#' ); " 
				onfocus="this.select()"
				onkeyup="javascript:conlis_keyup_#Attributes.name##Attributes.index#(event);"
				size="10" 
				maxlength="20"
				<cfif Attributes.readonly>readonly</cfif>
				>
		</td>

		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80">
		</td>
		<td>
			<cfif not Attributes.readonly>
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Catálogos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCatalogos#Attributes.name##Attributes.index#();'></a>
			</cfif>
		</td>
		<td>
			<input type="hidden"
				name="#Attributes.name#" id="#Attributes.name#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" >
		</td>
	</tr>
	</cfoutput>
</table>
<iframe style="display:none;" name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="" marginwidth="" frameborder="1" height="0" width="0" scrolling="auto" src=""></iframe>
