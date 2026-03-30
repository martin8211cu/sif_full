<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#" 			type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 					type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" 			default="#def#" 					type="query">  <!--- consulta por defecto --->
<cfparam name="Attributes.id" 				default="Aid" 						type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.name" 			default="Acodigo" 					type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.UcodigoOculto" 	default="_Ucodigo_#Attributes.id#" 	type="string"> <!--- Nombre de la Unidad del Artículo --->
<cfparam name="Attributes.frame" 			default="frarticulo" 				type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" 			default="Adescripcion" 				type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.descAlt" 			default="descalterna" 				type="string"> <!--- Nombre de la Descripción Alterna --->
<cfparam name="Attributes.observacion" 		default="observaciones" 			type="string"> <!--- Nombre de la observacion --->
<cfparam name="Attributes.tabindex" 		default="" 							type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" 			default="30" 						type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.Almacen" 			default="" 							type="string"> <!--- filtro por almacen, solo se usa si valida existencias --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 							type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.filtroextra"		default="" 							type="string"> <!--- filtro adicional para la consulta de articulos --->
<cfparam name="Attributes.IACcampo" 		default="IACinventario">						   <!---Nombre del Campo de tipo impuesto en IAContables --->
<cfparam name="Attributes.SNid" 			default="-1">									   <!---Cuando IACcampo es un Cformato, se requiere SNid --->
<cfparam name="Attributes.verclasificacion" default="true" 						type="boolean"><!--- Parámetro para ver clasificacion --->
<cfparam name="Attributes.readonly"			default="false" 					type="boolean"><!--- Solo lectura --->
<cfparam name="Attributes.style" 			default="" 							type="string"> <!--- style asociado a la caja de texto --->
<cfparam name="Attributes.Existencias"   	default="false" 					type="boolean"><!--- Mostrar Existencias--->
<cfparam name="Attributes.width"   			default="800" 						type="numeric"><!---Width--->
<cfparam name="Attributes.height"   		default="430" 						type="numeric"><!---Height--->
<cfparam name="Attributes.SoloExistentes"   default="false" 					type="boolean"><!---True, muestra solo Articulos con existencia--->
<cfparam name="Attributes.Ecodigo"   		default="#session.Ecodigo#" 		type="numeric">
<cfparam name="Attributes.Ccodigo"   		default="" 							type="string"><!---CCodigo vacio--->
<script language="JavaScript" type="text/javascript">
	var popUpWin=0;

	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisArticulos<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&descAlt=#Attributes.descAlt#&observacion=#Attributes.observacion#&filtroextra=#Attributes.filtroextra#&conexion=#Attributes.conexion#&ucodigo_oculto=#Attributes.UcodigoOculto#&IACcampo=#Attributes.IACcampo#&SNid=#Attributes.SNid#&verclasificacion=#Attributes.verclasificacion#&Existencias=#Attributes.Existencias#&SoloExistentes=#Attributes.SoloExistentes#&Ecodigo=#Attributes.Ecodigo#</cfoutput>";

		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	

		<cfif isdefined("Attributes.Almacen") and len(trim(Attributes.Almacen)) >
			var almacen = <cfoutput>document.#Attributes.form#.#trim(Attributes.Almacen)#.value</cfoutput>;
			params += "&Almacen="+almacen;
		<cfelse>
			params += "&Almacen=";
		</cfif>
		<cfif len(trim("<cfoutput>#Attributes.Ccodigo#</cfoutput>"))>
			params = params + "<cfoutput>&Ccodigo=#Attributes.Ccodigo#</cfoutput>";
		</cfif>
		<cfoutput>popUpWindow#Attributes.name#("/cfmx/sif/Utiles/ConlisArticulos.cfm"+params,160,200,#Attributes.width#,#Attributes.height#);</cfoutput>
	}
	
	function conlis_keyup_<cfoutput>#Attributes.name#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisArticulos<cfoutput>#Attributes.name#</cfoutput>();
		}
	}
	
	//Obtiene la descripción con base al código
	function TraeArticulos<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&descAlt=#Attributes.descAlt#&observacion=#Attributes.observacion#&filtroextra=#Attributes.filtroextra#&conexion=#Attributes.conexion#&ucodigo_oculto=#Attributes.UcodigoOculto#&IACcampo=#Attributes.IACcampo#&SNid=#Attributes.SNid#&SoloExistentes=#Attributes.SoloExistentes#&Ecodigo=#Attributes.Ecodigo#</cfoutput>";


		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	

		<cfif isdefined("Attributes.Almacen") and len(trim(Attributes.Almacen)) gt 0>
			var almacen = <cfoutput>document.#Attributes.form#.#Attributes.Almacen#.value</cfoutput>;
			params += "&Almacen="+almacen;
		<cfelse>
			params += "&Almacen=";
		</cfif>

		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifarticuloquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			document.<cfoutput>#Attributes.form#.#Attributes.id#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.desc#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.descAlt#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.observacion#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.UcodigoOculto#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.cuenta_#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.cuentamayor_#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.cuentaformato_#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.cuentadesc_#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.Eexistencia_#Attributes.name#</cfoutput>.value = '';
			if (window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>) {window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>();}
		}

		return;
	}	
</script>
<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
	<cfset name = Trim(Evaluate('Attributes.query.' & Attributes.name))>
	<cfset desc = Trim(Evaluate('Attributes.query.' & Attributes.desc))>
</cfif>
<cfoutput>
<div style="display: inline-block; white-space: nowrap;">
	<input type="hidden" name="#Attributes.id#" id="#Attributes.id#" value="<cfif isdefined('Attributes.query') and  Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" >
	<input type="text" name="#Attributes.name#" id="#Attributes.name#"
		<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
		value="<cfif isdefined('Attributes.query') and Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#trim(name)#</cfif>" 
		onBlur="javascript: TraeArticulos#Attributes.name#(document.#Attributes.form#.#Attributes.name#.value);" onFocus="this.select()"
		onkeyup="javascript:conlis_keyup_#Attributes.name#(event);"
		size="10" 
		maxlength="20" style="#Attributes.style#"  <cfif Attributes.readonly>readonly</cfif>>
		<input type="text"
		name="#Attributes.desc#" id="#Attributes.desc#"
		tabindex="-1" disabled
		value="<cfif isdefined('Attributes.query')  and  Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#HTMLEditFormat(desc)#</cfif>" 
		size="#Attributes.size#" 
		maxlength="80" style="#Attributes.style#">
				<cfif not Attributes.readonly>
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="img#Attributes.name#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisArticulos#Attributes.name#();'></a>
			</cfif>
			<!--- Estos campos son solo para recuperar mas informacion del articulo --->
			<!--- No interesa ponerles valor en modo cambio, son de paso nadamas --->
			<input type="hidden" name="#Attributes.UcodigoOculto#" 		id="#Attributes.UcodigoOculto#"		 value="" >
			<input type="hidden" name="Icodigo_#Attributes.name#" 		id="Icodigo_#Attributes.name#" 		 value="" >
			<input type="hidden" name="cuenta_#Attributes.name#" 		id="cuenta_#Attributes.name#" 		 value="" >
			<input type="hidden" name="cuentamayor_#Attributes.name#" 	id="cuentamayor_#Attributes.name#" 	 value="" >
			<input type="hidden" name="cuentaformato_#Attributes.name#" id="cuentaformato_#Attributes.name#" value="" >
			<input type="hidden" name="cuentadesc_#Attributes.name#"    id="cuentadesc_#Attributes.name#" 	 value="" >
            <input type="hidden" name="Eexistencia_#Attributes.name#"   id="Eexistencia_#Attributes.name#" 	 value="<cfif isdefined('Attributes.query') and Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1 and isdefined('Attributes.query.Eexistencia')>#HTMLEditFormat(Attributes.query.Eexistencia)#</cfif>">
            <input type="hidden" name="#Attributes.descAlt#" 			id="#Attributes.descAlt#"		 	 value="<cfif isdefined('Attributes.query') and Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1 and isdefined('Attributes.query.descAlt')>#HTMLEditFormat(Attributes.query.descAlt)#</cfif>">
            <input type="hidden" name="#Attributes.observacion#" 		id="#Attributes.observacion#"		 value="<cfif isdefined('Attributes.query') and Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1 and isdefined('Attributes.query.observacion')>#HTMLEditFormat(Attributes.query.observacion)#</cfif>">
			<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" scrolling="auto" 
height="0" width="0" frameborder="0"></iframe>
</div>
</cfoutput>