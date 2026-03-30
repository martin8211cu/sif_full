<cfset def = QueryNew('dato')>

<!--- ParÃ¡metros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexiÃ³n --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="Ucodigo1" type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.name" default="Ucodigo" type="string"> <!--- Nombre del CÃ³digo --->
<cfparam name="Attributes.UcodigoOculto" default="_Ucodigo_#Attributes.id#" type="string"> <!--- Nombre de la Unidad del ArtÃ­culo --->
<cfparam name="Attributes.frame" default="frrecurso" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="Udescripcion" type="string"> <!--- Nombre de la DescripciÃ³n --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- nÃºmero del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaÃ±o del objeto de la descripcion --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" type="string"> <!--- funciÃ³n .js despuÃ©s de ejecutar la consulta --->
<cfparam name="Attributes.filtroextra"	default="" type="string"> <!--- filtro adicional para la consulta de Recursos --->
<cfparam name="Attributes.readonly"			default="false" 					type="boolean"><!--- Solo lectura --->
<cfparam name="Attributes.style" 			default="" 							type="string">	<!--- style asociado a la caja de texto --->

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
	function doConlisUnidades<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&filtroextra=#Attributes.filtroextra#&conexion=#Attributes.conexion#&ucodigo_oculto=#Attributes.UcodigoOculto#</cfoutput>";

		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/sif/Utiles/ConlisUnidades.cfm"+params,160,200,800,430);
	}
	//Obtiene la descripciÃ³n con base al cÃ³digo
	function TraeUnidades<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&filtroextra=#Attributes.filtroextra#&conexion=#Attributes.conexion#&ecodigo=#Session.Ecodigo#&ucodigo_oculto=#Attributes.UcodigoOculto#</cfoutput>";

		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		
		params += "&cmp_unitario=PRJPIcostoUnitario";

		if (dato!="") {			
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifunidadesquery.cfm?dato="+dato+"&formulario="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			document.<cfoutput>#Attributes.form#.#Attributes.id#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.desc#</cfoutput>.value = '';
			if (window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>) {window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>();}
		}

		return;
	}	
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = Trim(Evaluate('Attributes.query.' & Attributes.name))>
		<cfset desc = Trim(Evaluate('Attributes.query.' & Attributes.desc))>
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="hidden"
				name="#Attributes.id#" id="#Attributes.id#"
				value="<cfif isdefined('Attributes.query') and  Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" >
				
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#trim(name)#</cfif>" 
				onBlur="javascript: TraeUnidades#Attributes.name#(document.#Attributes.form#.#Attributes.name#.value);" onFocus="this.select()"
				size="10" 
				maxlength="10" style="#Attributes.style#" <cfif Attributes.readonly>readonly</cfif>>
		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query')  and  Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#desc#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80" style="#Attributes.style#" <cfif Attributes.readonly>readonly</cfif>>
				<cfif not Attributes.readonly>
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="img#Attributes.name#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisUnidades#Attributes.name#();'></a>				
				</cfif>
		</td>
	</tr>
	
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: ;"></iframe>

