<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" type="String" default=""> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" default="RHPcodigopr" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.frame" default="frPruebas" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="RHPdescripcionpr" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.empresa" type="string" default=""> <!--- empresa --->

<cfif len(trim(Attributes.Conexion)) LT 1>
	<cfset Attributes.Conexion = Session.DSN>
</cfif>
<cfif len(trim(Attributes.Empresa)) LT 1>
	<cfset Attributes.Empresa = Session.Ecodigo>
</cfif>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisprueba<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&empresa=#Attributes.empresa#</cfoutput>";

		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/rh/Utiles/Conlispruebas.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código
	function TraePrueba<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&ecodigo=#Attributes.empresa#</cfoutput>";
		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhpruebasquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			limpiarPrueba();
		}
		return;
	}
	function limpiarPrueba(){
	<cfoutput>
		document.#Attributes.form#.#Attributes.name#.value="";
		document.#Attributes.form#.#Attributes.desc#.value="";
	</cfoutput>
	}
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<!--- <input type="hidden"
				name="#Attributes.id#" id="#Attributes.id#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" > --->
		
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				onBlur="javascript: TraePrueba#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); 
						if (window.func#Attributes.name#) {func#Attributes.name#();}" 
				onFocus="this.select()"
				size="10" 
				maxlength="10">
		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80">
			<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Pruebas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisprueba#Attributes.name#();'></a>
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
