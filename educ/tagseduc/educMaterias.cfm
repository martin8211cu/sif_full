<cfquery name="def" datasource="asp">
	select '' as Mcodigo
</cfquery>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.tipo" default="M" type="String"> <!--- valor del tipo de materia del campo Mtipo de la tala de materias --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.cod" default="Mcodigo" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.quitar" default="" type="string"> <!--- Códigos separados por comas de Materias que no se desea que aparezcan en la lista resultante --->
<cfparam name="Attributes.name" default="Mcodificacion" type="string"> <!--- Nombre del campo de Codificacion --->
<cfparam name="Attributes.frame" default="frMaterias" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="Mnombre" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.filtroExtra" default="" type="string"> <!--- String con el filtro que se agregaria al final del where --->
<cfparam name="Attributes.conSubmit" default="N" type="string"> <!--- Realiza o no el submit en la pagina trasera --->
<cfparam name="Attributes.verDescr" default="S" type="string"> <!--- Pinta el campo de la descripcion (S) o lo pinta pero como un campo oculto (N) --->

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisMateria() {
		var params ="";
		var conSub= "";
		<cfif Attributes.conSubmit EQ 'S'>
			conSub= "<cfoutput>&conSubmit=#Attributes.conSubmit#</cfoutput>";
		</cfif>

		params = "<cfoutput>?form=#Attributes.form#&cod=#Attributes.cod#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&tipo=#Attributes.tipo#&quitar=#Attributes.quitar#&filtroExtra=#Attributes.filtroExtra#</cfoutput>" + conSub;
		popUpWindow("/cfmx/educ/utiles/ConlisMaterias.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código de la Materia
	function TraeMateria(dato) {
		var params ="";
		params = "<cfoutput>&cod=#Attributes.cod#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#session.DSN#&tipo=#Attributes.tipo#&quitar=#Attributes.quitar#&filtroExtra=#Attributes.filtroExtra#</cfoutput>";
		var conSub= "";
		<cfif Attributes.conSubmit EQ 'S'>
			conSub= "&conSubmit=<cfoutput>#Attributes.conSubmit#</cfoutput>";
		</cfif>

		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/educ/Utiles/educMateriasQuery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params+conSub;
		}else{
			<cfoutput>
				document.#Attributes.form#.#Attributes.cod#.value = '';
				document.#Attributes.form#.#Attributes.name#.value = '';				
				document.#Attributes.form#.#Attributes.desc#.value = '';				
			</cfoutput>
		}
		return;
	}	
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset cod = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.cod')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">		
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input 
				type="hidden" 
				name="#Attributes.cod#" 
				id="#Attributes.cod#" 
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#cod#')#</cfif>">
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				onblur="javascript: TraeMateria(this.value); " onfocus="this.select()"
				size="10" 
				maxlength="10">
		</td>
		<td nowrap>
			<cfif Attributes.verDescr EQ 'S'>
				<input type="text"
					name="#Attributes.desc#" id="#Attributes.desc#"
					tabindex="-1" disabled
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
					size="#Attributes.size#" 
					maxlength="50">
			<cfelse>
				<input type="hidden"
					name="#Attributes.desc#" id="#Attributes.desc#"
					tabindex="-1"
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
					size="#Attributes.size#" 
					maxlength="50">
			</cfif>
			<a href="##" tabindex="-1"><img src="/cfmx/educ/imagenes/Description.gif" alt="Lista de materias" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisMateria();'></a>
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>

