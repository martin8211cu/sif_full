<cfquery name="query" datasource="#session.Fondos.dsn#">
	select '' as vacio
</cfquery>
<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 	default="#session.Fondos.dsn#" 	type="String"> 	<!--- Nombre de la conexión --->
<cfparam name="Attributes.form"      	default="form1"   			  	type="String">	<!--- Nombre del form --->
<cfparam name="Attributes.query" 	 	default="#query#"				type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.name" 						 				type="string">	<!--- Nombre del Código --->
<cfparam name="Attributes.desc" 								 		type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.id"    		default="#Attributes.name#" 	type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.name2"   		default="#Attributes.desc#" 	type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.desc2"   		default="#Attributes.desc#" 	type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.frame" 		default="frConlis" 				type="string">	<!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" 	default="" 						type="string">	<!--- número del tabindex --->
<cfparam name="Attributes.size" 		default="40" 					type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.cjcConlisT" 	default="cjc_traeEmp" 			type="string">	<!--- cfm que rae descripcion --->
<cfparam name="Attributes.filtro" 	 	default=""						type="string"> 	<!--- filtro especial--->
<cfparam name="Attributes.onfocus" 	 	default=""						type="string"> 	<!--- funcion del focus--->

<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;

	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doCJC_Conlis<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&filtro=#Attributes.filtro#&name2=#Attributes.name2#&name=#Attributes.name#&desc=#Attributes.desc#&desc2=#Attributes.desc2#&conexion=#Attributes.conexion#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/sif/fondos/Utiles/<cfoutput>#Attributes.cjcConlisT#</cfoutput>.cfm"+params,250,200,650,400);
	}

	//Obtiene la descripción con base al código
	function TraeDescripcion<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&filtro=#Attributes.filtro#&name=#Attributes.name#&desc=#Attributes.desc#&name2=#Attributes.name2#&desc2=#Attributes.desc2#</cfoutput>";
		if (dato != "") {
			var frame = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			frame.src = "/cfmx/sif/fondos/Utiles/<cfoutput>#Attributes.cjcConlisT#</cfoutput>query.cfm?dato="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
			
		}
		else{
			document.<cfoutput>#Attributes.form#.#Attributes.id#</cfoutput>.value   = "";
			document.<cfoutput>#Attributes.form#.#Attributes.name#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#.#Attributes.desc#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#.#Attributes.name2#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#.#Attributes.desc2#</cfoutput>.value = "";
		}
		return;
	}	
</script>

<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfif isdefined('Attributes.id')>
			<cfset id   = "('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		</cfif>
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
		<!---  
		<cfif isdefined('Attributes.name2')>
			<cfset name2 = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name2')#')#')">
		</cfif>
		<cfif isdefined('Attributes.desc2')>
			<cfset desc2 = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc2')#')#')">		
		</cfif>		
		--->
	</cfif>

	<cfoutput>
	<tr>
		<td>
			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				<cfif Len(Trim(Attributes.onfocus)) GT 0> ONFOCUS="#Attributes.onfocus#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#name#'))#</cfif>" 
				onblur="javascript: TraeDescripcion#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); " 
				size="20" 
				maxlength="20"
				onfocus="javascript:this.select();"
				style="visibility:visible;">
		</td>

		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80"
				style="border: medium none; visibility:visible;">
		
			<a id="#Attributes.name#IMG" href="##" tabindex="-1" style="visibility:visible"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de selección" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doCJC_Conlis#Attributes.name#();'></a>
			<cfif Attributes.id neq Attributes.name >
				<input type="hidden" name="#Attributes.id#" value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" >
			</cfif>
		</td>
	</tr>
	</cfoutput>
</table>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""  style="visibility:hidden"></iframe>
