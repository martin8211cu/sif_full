<cfset def = QueryNew('RHPEcodigo')>


<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="RHPEid" type="string"> <!--- Nombre del Id del Puesto --->
<cfparam name="Attributes.name" default="RHPEcodigo" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.frame" default="frpuestoexterno" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="RHPEdescripcion" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.id#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisPuestoExterno<cfoutput>#Attributes.id#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.id#</cfoutput>("/cfmx/rh/Utiles/ConlisPuestoExterno.cfm"+params,250,200,650,400);
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.id#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisPuestoExterno<cfoutput>#Attributes.id#</cfoutput>();
		}
	}
	//Obtiene la descripción con base al código
	function TraePuestoExterno<cfoutput>#Attributes.id#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#</cfoutput>";
		document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>").src="/cfmx/rh/Utiles/rhpuestoexternoquery.cfm?dato="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
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
	<tr>
		<td>
			<input type="hidden" name="#Attributes.id#" id="#Attributes.id#" value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>">
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				onkeyup="javascript:conlis_keyup_#Attributes.id#(event);"
				onblur="javascript: TraePuestoExterno#Attributes.id#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); " onfocus="this.select()"
				size="10" 
				maxlength="10">
		</td>
	    <td>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80">
			<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Puestos Externos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisPuestoExterno#Attributes.id#();'></a>
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>