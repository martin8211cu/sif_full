<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" type="String" default=""> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="Bid" type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.name" default="BTEcodigo" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.desc" default="BTEdescripcion" type="string">
<cfparam name="Attributes.tipo" default="BTEtipo" type="string"> <!--- Nombre del tipo de la transacción --->
<cfparam name="Attributes.Banco" default="-1" type="numeric"> <!--- Valor del Banco--->
<cfparam name="Attributes.frame" default="frMBTransaccionesBancos" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.sizename" default="10" type="string"> <!--- tamaño del objeto del name--->
<cfparam name="Attributes.empresa" type="string" default=""> <!--- empresa --->
<cfparam name="Attributes.BTEtce" type="integer" default="0"> <!--- FILTRO TARJETAS DE CREDITO EMPRESARIAL --->

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
	function doConlisMBTransaccionesBancos<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&tipo=#Attributes.tipo#&BTEtce=#Attributes.BTEtce#&Banco=#Attributes.Banco#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&empresa=#Attributes.empresa#</cfoutput>";

		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/sif/Utiles/ConlisMBTransaccionesBancos.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código
	function TraeMBTransaccionesBancos<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&tipo=#Attributes.tipo#&BTEtce=#Attributes.BTEtce#&Banco=#Attributes.Banco#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&ecodigo=#Attributes.empresa#</cfoutput>";
		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/Utiles/sifMBTransaccionesBancosquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			limpiarMBTransaccionesBancos<cfoutput>#Attributes.name#</cfoutput>();
		}
		return;
	}
	function limpiarMBTransaccionesBancos<cfoutput>#Attributes.name#</cfoutput>(){
	<cfoutput>
		document.#Attributes.form#.#Attributes.id#.value="";
		document.#Attributes.form#.#Attributes.name#.value="";
		document.#Attributes.form#.#Attributes.desc#.value="";
		document.#Attributes.form#.#Attributes.tipo#.value="";
	</cfoutput>
	}
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">
		<cfset tipo = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.tipo')#')#')">
	</cfif>
	<cfoutput>
	<tr>
		<td>
			  <input type="hidden"
				name="#Attributes.id#" id="#Attributes.id#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>">
			
			<input type="hidden"
				name="#Attributes.tipo#" id="#Attributes.tipo#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#tipo#')#</cfif>">
				
				
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cf_onEnterKey enterAction="tab" onKeyDown="" onKeyPress="">
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				onblur="javascript: TraeMBTransaccionesBancos#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); 
						if (window.func#Attributes.name#) {func#Attributes.name#();}" 
				onfocus="this.select()"
				size="#Attributes.sizename#" 
				maxlength="10">
		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80">
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista Clasificaci&oacute;n Socios de Negocios" name="imagen" width="18" height="14" border="0" align="absmiddle" onclick='javascript: doConlisMBTransaccionesBancos#Attributes.name#();'></a>
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
