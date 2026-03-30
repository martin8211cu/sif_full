<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" default="RHTPcodigo" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.id" default="RHTPid" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.frame" default="frpuesto" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.desc" default="RHTPdescripcion" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.empresa" default="#Session.Ecodigo#" type="string"> <!--- empresa --->

<!----===================== TRADUCCION ======================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_puestos"
	Default="Lista de Tipos de Puestos"	
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
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&empresa=#Attributes.empresa#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/rh/Utiles/ConlisTPuesto.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código
	function TraePuesto<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&ecodigo=#Attributes.empresa#</cfoutput>";
		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhtpuestoquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.desc#</cfoutput>.value = '';
		}
		return;
	}	
</script>
<table border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="hidden"
				name="#Attributes.id#" id="#Attributes.id#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" 
				size="0">
				
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				size="0">
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
