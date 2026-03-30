<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG Puestos por Empresa Encuestadora --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="EPid" type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.name" default="EPcodigo" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.frame" default="frPuestoEnc" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="EPdescripcion" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.empresa" default="#Session.Ecodigo#" type="string"> <!--- empresa --->
<cfparam name="Attributes.EEid" type="string"> <!--- Empresa Encuestadora --->

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisPuestoEnc<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&EEid=#Attributes.EEid#&id=#Attributes.id#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/rh/Utiles/ConlisPuestoEnc.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código
	function TraePuestoEnc<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&id=#Attributes.id#&EEid=#Attributes.EEid#</cfoutput>";
		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhPuestoEncquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		return;
	}	
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">		
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
	</cfif>
	<cfoutput>
		<input type="hidden"
			name="#Attributes.id#" id="#Attributes.id#"
			value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>">	
	<tr>
		<td>
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				onBlur="javascript: TraePuestoEnc#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); 
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
			<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de puestos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisPuestoEnc#Attributes.name#();'></a>
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
