<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.Conexion" default="tramites" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.seleccionado" default="" type="string"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="id_requisito" type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.codigo" default="codigo_requisito" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.frame" default="frrequisito" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="nombre_requisito" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="25" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.excluir" default="" type="string"> <!--- excluir estos registros --->
<cfparam name="Attributes.otrosdatos" default="NO" type="string"> <!--- envia a form el costo y la moneda --->

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.codigo#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisConceptos<cfoutput>#Attributes.codigo#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.id#&codigo=#Attributes.codigo#&desc=#Attributes.desc#&excluir=#Attributes.excluir#&otrosdatos=#Attributes.otrosdatos#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.codigo#</cfoutput>("/cfmx/sif/Utiles/conlisTPRequisitos.cfm"+params,250,180,650,470);
	}
	//Obtiene la descripción con base al código
	function TraeConcepto<cfoutput>#Attributes.codigo#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&codigo=#Attributes.codigo#&desc=#Attributes.desc#&excluir=#Attributes.excluir#&otrosdatos=#Attributes.otrosdatos#</cfoutput>";

		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/tprequisitoquery.cfm?dato="+dato+"&formulario="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			document.<cfoutput>#Attributes.form#.#Attributes.id#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.codigo#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.desc#</cfoutput>.value = '';
			if (window.funcExtra<cfoutput>#trim(Attributes.codigo)#</cfoutput>) {window.funcExtra<cfoutput>#trim(Attributes.codigo)#</cfoutput>();}			
		}
		return;
	}	
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset codigo = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.codigo')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="hidden"
				name="#Attributes.id#" id="#Attributes.id#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" >
				
			<input type="text" style="text-transform:uppercase;"
				name="#Attributes.codigo#" id="#Attributes.codigo#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#codigo#'))#</cfif>" 
				onBlur="javascript: TraeConcepto#Attributes.codigo#(document.#Attributes.form#.#Evaluate('Attributes.codigo')#.value); if (window.func#Attributes.codigo#) {func#Attributes.codigo#();}" onFocus="this.select()"
				size="15" 
				maxlength="30" >
		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1"  readonly="yes"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="40">
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Conceptos de Servicio" name="img#Attributes.codigo#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisConceptos#Attributes.codigo#();'></a>
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility:hidden;"></iframe>
