<cfset def = QueryNew('RHOcodigo')>


<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" default="RHOcodigo" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.frame" default="frocupacion" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="RHOdescripcion" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisOcupacion<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/rh/Utiles/ConlisOcupacion.cfm"+params,250,200,650,400);
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.name#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisOcupacion<cfoutput>#Attributes.name#</cfoutput>();
		}
	}

	//Obtiene la descripción con base al código
	function TraeOcupacion<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#</cfoutput>";
		if (dato!="") {
			document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/rh/Utiles/rhocupacionquery.cfm?dato="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		}
		else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.desc#</cfoutput>.value = '';
		}
		return;
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
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				onkeyup="javascript:conlis_keyup_#Attributes.name#(event);"
				onblur="javascript: TraeOcupacion#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); " onfocus="this.select()"
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
			<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de ocupaciones" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOcupacion#Attributes.name#();'></a>
		</td>
	</tr>
	</cfoutput>
</table>

<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe><!---src="/rh/Utiles/sifocupacionquery.cfm"--->