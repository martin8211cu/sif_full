<!---
<cfquery name="def" datasource="asp">
	select 1 as dato
</cfquery>
--->
<cfset def = QueryNew("dato")>

<cfparam name="Attributes.Conlis" 		default="true" 			type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Tipos de Nomina --->
<cfparam name="Attributes.index" 		default="0" 			type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" 		default="form1" 		type="String"> 	<!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" 		default="#def#" 		type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.frame" 		default="FRTipoNomina" 	type="string"> 	<!--- Nombre del frame --->
<cfparam name="Attributes.size" 		default="30" 			type="numeric"> <!--- Tamaño del Nombre del tipo de acción --->
<cfparam name="Attributes.hidectls" 	default="" 				type="string"> 	<!--- Controles que se van a ocultar despues de la ejecucion --->
<cfparam name="Attributes.autogestion" 	default="false" 		type="boolean"> <!--- Indica si se van a traer únicamente los tipos de Nomina de autogestion --->
<cfparam name="Attributes.combo" 		default="false" 		type="boolean"> <!--- Indica si se pinta un combo en lugar de los campos visibles, y todos los campos quedarían como hiddens --->
<cfparam name="Attributes.tabindex" 	default="1" 			type="string">
<cfparam name="Attributes.onChange" 	default="" 				type="string">	<!--- Funcion a ser llamada desde el onChange--->
<cfparam name="Attributes.excepto" 		default="" 				type="string">	<!--- indica la nomina que se desea exceptuar para no mostrarla al usuario --->
<cfparam name="Attributes.AgregarEnLista" default="false" 		type="boolean"><!--- permite agregar Tipos de Nominas a una lista por medio del boton (+) --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfif Attributes.AgregarEnLista>
	<cf_importJquery>
	<cfif trim(Attributes.index) eq 0>
		<cfset index=1>
	</cfif>
</cfif>


<!-----======================== TRADUCCION ==========================----->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_Tipos_de_Nomina"
	Default="Lista de Tipos de N&oacute;mina"	
	returnvariable="LB_Lista_de_Tipos_de_Nomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnTipodeNomina"
	Default="Debe seleccionar un Tipo de Nómina"	
	xmlFile="/rh/generales.xml"
	returnvariable="MSG_DebeSeleccionarUnTipodeNomina"/>

	<script language="JavaScript" type="text/javascript">
		<cfif Attributes.Conlis>
			function doConlisTipoNomina<cfoutput>#index#</cfoutput>() {
				var width = 600;
				var height = 500;
				var top = (screen.height - height) / 2;
				var left = (screen.width - width) / 2;
				<cfoutput>
				var nuevo = window.open('/cfmx/rh/Utiles/ConlisTipoNomina.cfm?f=#Attributes.form#&p2=Tcodigo#index#&p3=Tdescripcion#index#&onChange=#Attributes.onChange#&excepto=#Attributes.excepto#','ListaTipoNomina','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
				</cfoutput>
				nuevo.focus();
			}
		</cfif>
		
		function ClearTipoNomina<cfoutput>#index#</cfoutput>() {
			//alert('eso2')
			document.<cfoutput>#Attributes.form#</cfoutput>.Tcodigo<cfoutput>#index#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#</cfoutput>.Tdescripcion<cfoutput>#index#</cfoutput>.value = "";
			
		}
		
		function TraeTipoNomina<cfoutput>#index#</cfoutput>(dato) {
			//alert('eso1')
			window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.Tcodigo<cfoutput>#index#</cfoutput>;
			window.ctlacc = document.<cfoutput>#Attributes.form#</cfoutput>.Tdescripcion<cfoutput>#index#</cfoutput>;
			if (document.<cfoutput>#Attributes.form#.Tcodigo#index#</cfoutput>.value != "") {
				var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
				fr.src = "/cfmx/rh/Utiles/rhtipoNominaquery.cfm?Tcodigo="+dato+'&f=<cfoutput>#Attributes.form#</cfoutput>&p2=Tcodigo<cfoutput>#index#</cfoutput>&p3=Tdescripcion<cfoutput>#index#</cfoutput>';
			} 
			else {
				ClearTipoNomina<cfoutput>#index#</cfoutput>();
			}
			<cfoutput>
				<cfif len(trim(Attributes.onChange))>
					eval('#Attributes.onChange#();') //funcion que simula ejecutarse en el onchange.
				</cfif>
			</cfoutput>
			return true;
		}
		
		<cfif Attributes.AgregarEnLista>
			function AgregarTipoNominaLista<cfoutput>#index#</cfoutput>(){
					var existe = 0;
		
					if($('#ListaTipoNomina<cfoutput>#index#</cfoutput>').length){
						$('input.ListaTipoNomina<cfoutput>#index#</cfoutput>').each(function() {
							if($('#Tcodigo<cfoutput>#index#</cfoutput>').val() == $(this).val()){ existe=1;}
						});
					}
					if(existe == 1){
						alert("Este Tipo de Nomina ya se encuentra agregado");
					}
					else{	
						if($('#Tcodigo<cfoutput>#index#</cfoutput>').val() == ''){
							alert("#MSG_DebeSeleccionarUnTipodeNomina#");
						}	
						else{	
						   $('#ListaTipoNominaTable<cfoutput>#index#</cfoutput>').append("<tr><td nowrap='nowrap'><input class='<cfoutput>ListaTipoNomina#index#</cfoutput>' type='hidden' id='<cfoutput>ListaTipoNomina#index#</cfoutput>' name='<cfoutput>ListaTipoNomina#index#</cfoutput>' value="+$('#Tcodigo<cfoutput>#index#</cfoutput>').val()+">"+$('#<cfoutput>Tcodigo#index#</cfoutput>').val()+" - " +$('#Tdescripcion<cfoutput>#index#</cfoutput>').val()+ "<img src='/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif' onclick='QuitarTipoNominaLista<cfoutput>#index#</cfoutput>(this)' ></td></tr>");
						   $('#Tcodigo<cfoutput>#index#</cfoutput>').val(""); 
						   $('#Tdescripcion<cfoutput>#index#</cfoutput>').val(""); 
						}
					}
			}
			function QuitarTipoNominaLista<cfoutput>#index#</cfoutput>(elemento){
				$(elemento).parent().parent().remove(); 
			}
		</cfif>	
		
	</script>
	
	<cfoutput>
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<input type="text"
						name="Tcodigo#index#" id="Tcodigo#index#"
						value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Tcodigo#index#")>#Evaluate("Attributes.query.Tcodigo#index#")#</cfif>"
						maxlength="5"
						size="10"
						onblur="javascript: TraeTipoNomina#index#(document.#Attributes.form#.Tcodigo#index#.value);">
				</td>
				<td nowrap>
					<input type="text"
						name="Tdescripcion#index#" id="Tdescripcion#index#"
						tabindex="-1"
						value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Tdescripcion#index#")>#Evaluate("Attributes.query.Tdescripcion#index#")#</cfif>" 
						maxlength="80"
						size="#Attributes.size#"
						readonly="true">
					<cfif Attributes.Conlis><a href="javascript: doConlisTipoNomina#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_Tipos_de_Nomina#" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
				</td>
				<cfif Attributes.AgregarEnLista>
				<td>
					<input type="button" onclick="AgregarTipoNominaLista<cfoutput>#index#</cfoutput>()" value="+" class="btnNormal" />
				</td>				
				</cfif>
			</tr>

			<cfif Attributes.AgregarEnLista>
			<tr>
				<td colspan="5">
					<table id="ListaTipoNominaTable<cfoutput>#index#</cfoutput>">
					</table>
				</td>
			</tr>
			</cfif>
		</table>
	</cfoutput>
	
	<cfif not isdefined("Request.TipoNominaTag")>
		<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" src="" style="display:none;"></iframe>
		<cfset Request.TipoNominaTag = True>
	</cfif>
