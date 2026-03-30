<!---
<cfquery name="def" datasource="asp">
	select '' as TDcodigo
</cfquery>
--->
<cfset def = QueryNew("TDcodigo")>
<cfset newRow = QueryAddRow(def, 1)>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 	default="#Session.DSN#" type="String"> 	<!--- Nombre de la conexión --->
<cfparam name="Attributes.form"     	default="form1" 		type="String">	<!--- Nombre del form --->
<cfparam name="Attributes.query" 		default="#def#" 		type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.name" 		default="TDcodigo" 		type="string">	<!--- Nombre del Código --->
<cfparam name="Attributes.desc" 		default="TDdescripcion" type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.id"    		default="TDid" 			type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.frame" 		default="frTDeduccion" 	type="string">	<!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" 	default="" 				type="string">	<!--- número del tabindex --->
<cfparam name="Attributes.pageindex"	default="" 				type="string">	<!--- este se usara para indicar el id unico si existen varios en form --->
<cfparam name="Attributes.size" 		default="40" 			type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.validate" 	default="0"				type="numeric">	<!--- validar seguridad 0:false 1:true --->
<cfparam name="Attributes.financiada" 	default="0"				type="numeric">	<!--- mostrar solo de tipo financianada 0:false 1:true --->
<cfparam name="Attributes.readOnly" 	default="false"			type="boolean">
<cfparam name="Attributes.onChange" 	default="" 				type="string">	<!--- Funcion a ser llamada desde el onChange--->
<cfparam name="Attributes.AgregarEnLista" default="false" 		type="boolean"><!--- permite agregar Tipos de ACcion a una lista por medio del boton (+) --->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TiposDeduccion"
	Default="Tipos de Deducci&oacute;n"
	returnvariable="LB_TiposDeduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml"
	Key="MSG_EsteTipodeDeduccionYaSeEncuentraAgregado"
	Default="Este Tipo de Deducción ya se encuentra Agregada"
	returnvariable="MSG_EsteTipodeDeduccionYaSeEncuentraAgregado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml"
	Key="MSG_DebeSeleccionarUnTipoDeDeduccion"
	Default="Debe seleccionar un Tipo de Deducción"
	returnvariable="MSG_DebeSeleccionarUnTipoDeDeduccion"/>

	
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;

	function popUpWindow<cfoutput>#Attributes.name##Attributes.pageindex#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisTDeduccion<cfoutput>#Attributes.name##Attributes.pageindex#</cfoutput>() {
		var w = 650;
		var h = 500;
		var l = (screen.width-w)/2;
		var t = (screen.height-h)/2;
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id##Attributes.pageindex#&onChange=#Attributes.onChange#&name=#Attributes.name##Attributes.pageindex#&desc=#Attributes.desc##Attributes.pageindex#&conexion=#Attributes.conexion#&val=#Attributes.validate#&financiada=#Attributes.financiada#</cfoutput>";
		popUpWindow<cfoutput>#Attributes.name##Attributes.pageindex#</cfoutput>("/cfmx/rh/Utiles/ConlisTDeduccion.cfm"+params,l,t,w,h);
	}

	//Obtiene la descripción con base al código
	function TraeTDeduccion<cfoutput>#Attributes.name##Attributes.pageindex#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id##Attributes.pageindex#&name=#Attributes.name##Attributes.pageindex#&desc=#Attributes.desc##Attributes.pageindex#&conexion=#Attributes.conexion#&ecodigo=#Session.Ecodigo#&val=#Attributes.validate#&financiada=#Attributes.financiada#</cfoutput>";

		if (dato != "") {
			var frame = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			frame.src = "/cfmx/rh/Utiles/rhtipodeduccionquery.cfm?dato="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
		}
		else{
			document.<cfoutput>#Attributes.form#.#Attributes.id##Attributes.pageindex#</cfoutput>.value   = "";
			document.<cfoutput>#Attributes.form#.#Attributes.name##Attributes.pageindex#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#.#Attributes.desc##Attributes.pageindex#</cfoutput>.value = "";
		}
		<cfoutput>
			<cfif len(trim(Attributes.onChange))>
				eval('#Attributes.onChange#') //funcion que simula ejecutarse en el onchange.
			</cfif>
		</cfoutput>
		return;
	}	

	<cfif Attributes.AgregarEnLista>
		function AgregarTipoDeduccionLista<cfoutput>#attributes.pageindex#</cfoutput>(){
				var existe = 0;

				if($('#tableListaTipoDeduccion<cfoutput>#attributes.pageindex#</cfoutput>').length){
					$('input.ListaTipoDeduccion<cfoutput>#attributes.pageindex#</cfoutput>').each(function() {
						if($('#TDid<cfoutput>#attributes.pageindex#</cfoutput>').val() == $(this).val()){ existe=1;}
					});
				}
				if(existe == 1){
					alert("<cfoutput>#MSG_EsteTipodeDeduccionYaSeEncuentraAgregado#</cfoutput>");
				}
				else{	
					if($('#TDcodigo<cfoutput>#attributes.pageindex#</cfoutput>').val() == ''){
						alert("<cfoutput>#MSG_DebeSeleccionarUnTipoDeDeduccion#</cfoutput>");
					}	
					else{	
					   $('#tableListaTipoDeduccion<cfoutput>#attributes.pageindex#</cfoutput>').append("<tr><td nowrap='nowrap'><input class='<cfoutput>ListaTipoDeduccion#attributes.pageindex#</cfoutput>' type='hidden' id='<cfoutput>ListaTipoDeduccion#attributes.pageindex#</cfoutput>' name='<cfoutput>ListaTipoDeduccion#attributes.pageindex#</cfoutput>' value="+$('#TDid<cfoutput>#attributes.pageindex#</cfoutput>').val()+">"+$('#<cfoutput>TDcodigo#attributes.pageindex#</cfoutput>').val()+" - " +$('#TDdescripcion<cfoutput>#attributes.pageindex#</cfoutput>').val()+ "<img src='/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif' onclick='QuitarTipoDeduccionLista<cfoutput>#attributes.pageindex#</cfoutput>(this)' ></td></tr>");
					   $('#TDcodigo<cfoutput>#attributes.pageindex#</cfoutput>').val(""); 
					   $('#TDdescripcion<cfoutput>#attributes.pageindex#</cfoutput>').val(""); 
					}
				}
		}
		function QuitarTipoDeduccionLista<cfoutput>#attributes.pageindex#</cfoutput>(elemento){
			$(elemento).parent().parent().remove(); 
		}
	</cfif>	

</script>

<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id   = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
	</cfif>

	<cfoutput>
	<tr>
		<td>
			<input type="text"
				name="#Attributes.name##Attributes.pageindex#" id="#Attributes.name##Attributes.pageindex#"
				id="#Attributes.name##Attributes.pageindex#" id="#Attributes.name##Attributes.pageindex#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#name#'))#</cfif>" 
				onblur="javascript: TraeTDeduccion#Attributes.name##Attributes.pageindex#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); " 
				size="7" 
				maxlength="5"
				<cfif Attributes.readOnly>disabled</cfif>
				onfocus="javascript:this.select();">
		</td>

		<td nowrap>
			<input type="text"
				name="#Attributes.desc##Attributes.pageindex#" id="#Attributes.desc##Attributes.pageindex#"
				id="#Attributes.desc##Attributes.pageindex#" id="#Attributes.desc##Attributes.pageindex#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80">
				<input type="hidden" name="#Attributes.id##Attributes.pageindex#" id="#Attributes.id##Attributes.pageindex#" value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" >
			<cfif Not Attributes.readOnly><a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de #LB_TiposDeduccion#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisTDeduccion#Attributes.name##Attributes.pageindex#();'></a></cfif>
		</td>
		<cfif Attributes.AgregarEnLista>
		<td>
			<input type="button" onclick="AgregarTipoDeduccionLista<cfoutput>#attributes.pageindex#</cfoutput>()" value="+" class="btnNormal" />
		</td>				
		</cfif>
	</tr>
	<cfif Attributes.AgregarEnLista>
	<tr>
		<td colspan="5">
			<table id="tableListaTipoDeduccion<cfoutput>#attributes.pageindex#</cfoutput>">
			</table>
		</td>
	</tr>
	</cfif>
	</cfoutput>
</table>
<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>