<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#" 			type="String"> 		<!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 					type="String"> 		<!--- Nombre del form --->
<cfparam name="Attributes.query" 			default="#def#" 					type="query">		<!--- consulta por defecto --->
<cfparam name="Attributes.id" 				default="Cid" 						type="string"> 		<!--- Nombre del id --->
<cfparam name="Attributes.name" 			default="Ccodigo" 					type="string"> 		<!--- Nombre del Código --->
<cfparam name="Attributes.frame" 			default="frconcepto" 				type="string"> 		<!--- Nombre del frame --->
<cfparam name="Attributes.desc" 			default="Cdescripcion" 				type="string"> 		<!--- Nombre de la Descripción --->
<cfparam name="Attributes.cuentac" 			default="cuentac" 					type="string"> 		<!--- Nombre del complemento de cuenta --->
<cfparam name="Attributes.tabindex" 		default="" 							type="string"> 		<!--- número del tabindex --->
<cfparam name="Attributes.size" 			default="30" 						type="string"> 		<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.tipo" 			default="" 							type="string"> 		<!--- filtro por tipo --->
<cfparam name="Attributes.filtroextra"		default="" 							type="string"> 		<!--- filtro adicional para la consulta de servicios --->
<cfparam name="Attributes.verClasificacion"	default="1" 						type="string"> 		<!--- Parámetro para ver clasificacion --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 							type="string"> 		<!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.readonly"			default="false" 					type="boolean">		<!--- Solo lectura --->
<cfparam name="Attributes.style" 			default="" 							type="string">		<!--- style asociado a la caja de texto --->
<cfparam name="Attributes.Ecodigo" 			default="#session.Ecodigo#" 		type="integer">		<!--- Codigo de la empresa --->
<cfparam name="Attributes.isCorp" 			default="false" 					type="boolean">		<!--- Indica si la busqueda es corporativa--->
<cfparam name="Attributes.Empresas" 		default="#session.Ecodigo#" 		type="string">		<!--- Empresas Corporativas --->

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		if (window.screen) {
			top    = window.screen.availWidth  * 10 / 100;
			left   = window.screen.availHeight * 10 / 100;
			width  = window.screen.availWidth  * 80 / 100;
			height = window.screen.availHeight * 60 / 100;
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisConceptos<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&cuentac=#Attributes.cuentac#&filtroextra=#Attributes.filtroextra#&verClasificacion=#Attributes.verClasificacion#&tipo=#Attributes.tipo#&Ecodigo=#Attributes.Ecodigo#&isCorp=#Attributes.isCorp#&Empresas=#Attributes.Empresas#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/sif/Utiles/ConlisConceptos.cfm"+params,250,200,650,400);
	}
	
	function conlis_keyup_<cfoutput>#Attributes.name#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisConceptos<cfoutput>#Attributes.name#</cfoutput>();
		}
	}
	
	//Obtiene la descripción con base al código
	function TraeConcepto<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&cuentac=#Attributes.cuentac#&filtroextra=#Attributes.filtroextra#&verClasificacion=#Attributes.verClasificacion#&tipo=#Attributes.tipo#&Ecodigo=#Attributes.Ecodigo#</cfoutput>";

		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifconceptoquery.cfm?dato="+dato+"&formulario="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			document.<cfoutput>#Attributes.form#.#Attributes.id#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.desc#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.cuentac#</cfoutput>.value = '';

			if (window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>) {window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>();}			
		}
		return;
	}	
</script>
<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id   = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">
	<cfif isdefined ('Attributes.query.cuentac')>
		<cfset cuentac = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.cuentac')#')#')">
	</cfif>
</cfif>
<div style="display: inline-block; white-space: nowrap;">
	<cfoutput>
		<input type="hidden" name="#Attributes.id#" id="#Attributes.id#" value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" >
		<input type="hidden" name="Ucodigo_#Attributes.name#" id="Ucodigo#Attributes.name#" value="" >
		<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#name#'))#</cfif>" 
				onBlur="javascript:TraeConcepto#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); if (window.func#Attributes.name#) {func#Attributes.name#();}" onFocus="this.select()"
				onkeyup="javascript:conlis_keyup_#Attributes.name#(event);"
				size="10" 
				maxlength="20" style="#Attributes.style#"  <cfif Attributes.readonly>readonly</cfif>>
		
		<input type="text" name="#Attributes.desc#" id="#Attributes.desc#" tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80" style="#Attributes.style#"  <cfif Attributes.readonly>readonly</cfif>>
		
		<input type="hidden" name="#Attributes.cuentac#" id="#Attributes.cuentac#"
				value="<cfif isdefined('Attributes.query.cuentac') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#cuentac#')#</cfif>" >

		<cfif not Attributes.readonly>
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Conceptos de Servicio" name="img#Attributes.name#" id="img#Attributes.name#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisConceptos#Attributes.name#();'></a>
		</cfif>
	</cfoutput>
	<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="display: none;"></iframe>
</div>