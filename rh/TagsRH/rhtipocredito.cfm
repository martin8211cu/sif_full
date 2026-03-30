<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String">
<cfparam name="Attributes.form" 	default="form1" type="String">
<cfparam name="Attributes.query" 	default="#def#" type="query">
<cfparam name="Attributes.id" 		default="ACCTid" type="string">
<cfparam name="Attributes.name" 	default="ACCTcodigo" type="string">
<cfparam name="Attributes.frame" 	default="frpuesto" type="string">
<cfparam name="Attributes.desc" 	default="ACCTdescripcion" type="string">
<cfparam name="Attributes.tabindex" default="1" type="string">
<cfparam name="Attributes.index" 	default="" type="string">
<cfparam name="Attributes.size" 	default="30" type="string">
<cfparam name="Attributes.readonly"	default="false" type="boolean">

<!----===================== TRADUCCION ======================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_Tipos_de_Credito"
	Default="Lista de Tipos de Cr&eacute;dito"	
	returnvariable="LB_Lista_de_Tipos_de_Credito"/>

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
	function doConlisTipoCredito<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&index=#Attributes.index#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/rh/Utiles/ConlisTipoCredito.cfm"+params,250,200,650,400);
	}
	//Obtiene la descripción con base al código
	function TraeTipoCredito<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&index=#Attributes.index#</cfoutput>";
		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhtipocreditoquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}else{
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.desc#</cfoutput>.value = '';
		}
		return;
	}	
</script>
<table border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="text" onblur="javascript:TraeTipoCredito<cfoutput>#Attributes.name#</cfoutput>(this.value);"
				name="#Attributes.name#" id="#Attributes.name#"
				tabindex="#Attributes.tabindex#" 				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				size="10"  
				maxlength="10">

			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80"	>
		
				<input type="hidden"
					name="#Attributes.id#" id="#Attributes.id#"
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" 
					size="0">
				<input type="hidden" name="_plazo#Attributes.index#" id="_plazo#Attributes.index#" value="">
				<input type="hidden" name="_tasa#Attributes.index#" id="_tasa#Attributes.index#" value="">
				<input type="hidden" name="_tasamora#Attributes.index#" id="_tasamora#Attributes.index#" value="">
				<input type="hidden" name="_modificable#Attributes.index#" id="_modificable#Attributes.index#" value="">
		</td>
		<cfif not Attributes.readonly >
			<td>
				<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_Tipos_de_credito#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisTipoCredito#Attributes.name#();'></a>
			</td>
		</cfif>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
