<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" default="RHPcodigo" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.nameExt" default="RHPcodigoext" type="string"> <!--- Nombre del Código Externo--->
<cfparam name="Attributes.frame" default="frpuesto" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="RHPdescpuesto" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="1" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.empresa" default="#Session.Ecodigo#" type="string"> <!--- empresa --->
<cfparam name="Attributes.AgregarEnLista" default="false" type="boolean"><!--- permite agregar empleados a una lista por medio del boton (+) --->

<!----===================== TRADUCCION ======================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_puestos"
	Default="Lista de puestos"
	returnvariable="LB_Lista_de_puestos"/>


<cfif Attributes.AgregarEnLista>
	<cf_importJquery>
</cfif>

<!---<cf_dump var="#Attributes.query#">--->
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
	function doConlisPuesto<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&name=#Attributes.name#&nameExt=#Attributes.nameExt#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&empresa=#Attributes.empresa#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/rh/Utiles/ConlisPuesto.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código
	function TraePuesto<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&name=#Attributes.name#&nameExt=#Attributes.nameExt#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&ecodigo=#Attributes.empresa#</cfoutput>";
		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhpuestoquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.nameext#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.desc#</cfoutput>.value = '';
		}
		return;
	}

	<cfif Attributes.AgregarEnLista>
		function AgregarPuestosLista<cfoutput>#Attributes.tabindex#</cfoutput>(){
				var existe = 0;

				if($('#ListaRHPcodigoTag<cfoutput>#Attributes.tabindex#</cfoutput>').length){
					$('input.ListaRHPcodigoTag<cfoutput>#Attributes.tabindex#</cfoutput>').each(function() {
						if($('#<cfoutput>#Attributes.name#</cfoutput>').val() == $(this).val()){ existe=1;}
					});
				}
				if(existe == 1){
					alert("<cf_translate key='MSG_EstePuestoYaSeEncuentraAgregado'>Este Puesto ya se encuentra agregado</cf_translate>");
				}
				else{
					if($('#<cfoutput>#Attributes.name#</cfoutput>').val() == ''){
						alert("<cf_translate key='MSG_DebeSeleccionarUnPuesto'>Debe seleccionar un Puesto</cf_translate>");
					}
					else{
					   $('#ListaPuestos<cfoutput>#Attributes.tabindex#</cfoutput>').append("<tr><td nowrap='nowrap'><input class='<cfoutput>ListaRHPcodigoTag#Attributes.tabindex#</cfoutput>' type='hidden' id='<cfoutput>ListaRHPcodigoTag#Attributes.tabindex#</cfoutput>' name='<cfoutput>ListaRHPcodigoTag#Attributes.tabindex#</cfoutput>' value="+$('#<cfoutput>#Attributes.name#</cfoutput>').val()+"><td>"+$('#<cfoutput>#Attributes.nameExt#</cfoutput>').val()+" - " +$('#<cfoutput>#Attributes.desc#</cfoutput>').val()+ "</td><td><img src='/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif' onclick='QuitarPuestoLista<cfoutput>#Attributes.tabindex#</cfoutput>(this)' ></td></tr>");
					   $('#<cfoutput>#Attributes.name#</cfoutput>').val("");
					   $('#<cfoutput>#Attributes.desc#</cfoutput>').val("");
					   $('#<cfoutput>#Attributes.nameExt#</cfoutput>').val("");
					}
				}
		}
		function QuitarPuestoLista<cfoutput>#Attributes.tabindex#</cfoutput>(elemento){
			$(elemento).parent().parent().remove();
		}
	</cfif>

</script>
<table border="0" cellspacing="0" cellpadding="0">

	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset nameExt = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.nameExt')#')#')">
		<cfset desc = "#Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')#">
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="hidden"
				name="#Attributes.name#" id="#Attributes.name#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>"
				size="0">
		<input type="text"
				name="#Attributes.nameExt#" id="#Attributes.nameExt#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined ('name') and Len(Trim(#Evaluate('#name#')#)) gt 0 and Len(Trim(#Evaluate('#nameExt#')#))  eq 0  and isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#
				<cfelseif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#nameExt#')#</cfif>"
				onBlur="javascript: TraePuesto#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.nameExt')#.value);
						if (window.func#Attributes.name#) {func#Attributes.name#();}"
				onFocus="this.select()"
				size="10"
				maxlength="10">

		</td>
		<td nowrap>
			<cfoutput>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#desc#</cfif>"
				size="#Attributes.size#"
				maxlength="80">
			</cfoutput>
		</td>
		<td>
			<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_puestos#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisPuesto#Attributes.name#();'></a>
		</td>
		<cfif Attributes.AgregarEnLista>
		<td>
			<input type="button" onclick="AgregarPuestosLista<cfoutput>#Attributes.tabindex#</cfoutput>()" value="+" class="btnNormal" />
		</td>
		</cfif>
	</tr>
	</cfoutput>
	<cfif Attributes.AgregarEnLista>
	<tr>
		<td colspan="5">
			<table id="ListaPuestos<cfoutput>#Attributes.tabindex#</cfoutput>">
			</table>
		</td>
	</tr>
	</cfif>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>










<!---<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" default="RHPcodigo" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.nameExt" default="RHPcodigoext" type="string"> <!--- Nombre del Código Externo--->
<cfparam name="Attributes.frame" default="frpuesto" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="RHPdescpuesto" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.empresa" default="#Session.Ecodigo#" type="string"> <!--- empresa --->

<!----===================== TRADUCCION ======================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_puestos"
	Default="Lista de puestos"
	returnvariable="LB_Lista_de_puestos"/>


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
	function doConlisPuesto<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&name=#Attributes.name#&nameExt=#Attributes.nameExt#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&empresa=#Attributes.empresa#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/rh/Utiles/ConlisPuesto.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código
	function TraePuesto<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&name=#Attributes.name#&nameExt=#Attributes.nameExt#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&ecodigo=#Attributes.empresa#</cfoutput>";
		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhpuestoquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.nameext#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.desc#</cfoutput>.value = '';
		}
		return;
	}
</script>
<table border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset nameExt = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.nameExt')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="hidden"
				name="#Attributes.name#" id="#Attributes.name#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>"
				size="0">
		<input type="text"
				name="#Attributes.nameExt#" id="#Attributes.nameExt#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1 and len(trim(#Evaluate('Attributes.query.#Evaluate('Attributes.nameExt')#')#)) eq 0>
				#Evaluate('#attributes.name#')#
				<cfelse>
				#Evaluate('#attributes.nameExt#')#
				</cfif>"
				onBlur="javascript: TraePuesto#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.nameExt')#.value);
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
		</td>
		<td>
			<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_puestos#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisPuesto#Attributes.name#();'></a>
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>



--->