<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="Ccodigo" type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.name" default="Ccodigoclas" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.nivel" default="Nnivel" type="string"> <!--- Nombre del nivel --->
<cfparam name="Attributes.frame" default="frclasificacion" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="Cdescripcion" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.Cconsecutivo" default="no" type="boolean"> <!--- si se define, genera consecutivo --->

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
	// funcion para el F2
	function conlis_keyup_<cfoutput>#Attributes.name#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisClasificacionArticulo<cfoutput>#Attributes.name#</cfoutput>();
		}
	}
	//Llama el conlis
	function doConlisClasificacionArticulo<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&nivel=#Attributes.nivel#&desc=#Attributes.desc#&conse=#Attributes.Cconsecutivo#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/sif/Utiles/ConlisClasificacionArticulo.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código
	function TraeClasificacionArticulo<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&name=#Attributes.name#&nivel=#Attributes.nivel#&desc=#Attributes.desc#&conse=#Attributes.Cconsecutivo#</cfoutput>";

		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifClasificacionArticuloquery.cfm?dato="+dato+"&formulario="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			document.<cfoutput>#Attributes.form#.#Attributes.id#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.desc#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.nivel#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.Acodigo.value</cfoutput>.value = '';
		}
		return;
	}	
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = Trim(Evaluate('Attributes.query.' & Attributes.id))>
		<cfset name = Trim(Evaluate('Attributes.query.' & Attributes.name))>
		<cfset desc = Trim(Evaluate('Attributes.query.' & Attributes.desc))>
		<cfset nivel = Trim(Evaluate('Attributes.query.' & Attributes.nivel))>
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="hidden"
				name="#Attributes.id#" id="#Attributes.id#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#id#</cfif>" >
				
			<input type="hidden" name="CAid_#Attributes.name#" id="CAid_#Attributes.name#"	value="" >
				
			<input type="hidden"
				name="#Attributes.nivel#" id="#Attributes.nivel#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#nivel#</cfif>" >

			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#name#</cfif>" 
				onBlur="javascript: TraeClasificacionArticulo#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value);" onFocus="this.select()"
				onkeyup="javascript:conlis_keyup_#Attributes.name#(event);"
				size="10" 
				maxlength="5" >
		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#desc#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80">
		</td>
		<td>
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Clasificaciones de Art&iacute;culos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisClasificacionArticulo#Attributes.name#();'></a>
		</td>
	</tr>
	</cfoutput>
</table>
<cfoutput>
<iframe name="#Attributes.frame#" id="#Attributes.frame#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" style="visibility:hidden; display:none" ></iframe>
</cfoutput>