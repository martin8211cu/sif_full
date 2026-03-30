<!---
<cfquery name="def" datasource="asp">
	select 1 as dato
</cfquery>
--->
<cfset def = QueryNew("dato")>

<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Tipos de Acciones --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRTipoAccion" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del tipo de acción --->
<cfparam name="Attributes.hidectls" default="" type="string"> <!--- Controles que se van a ocultar despues de la ejecucion --->
<cfparam name="Attributes.autogestion" default="false" type="boolean"> <!--- Indica si se van a traer únicamente los tipos de accion de autogestion --->
<cfparam name="Attributes.combo" default="false" type="boolean"> <!--- Indica si se pinta un combo en lugar de los campos visibles, y todos los campos quedarían como hiddens --->
<cfparam name="Attributes.FiltroExtra" default=""  type="string">
<cfparam name="Attributes.tabindex"    default="1" type="string">
<cfparam name="Attributes.AgregarEnLista" default="false" 		type="boolean"><!--- permite agregar Tipos de ACcion a una lista por medio del boton (+) --->

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
	Key="LB_Lista_de_Tipos_de_Acciones"
	Default="Lista de Tipos de Acciones"	
	returnvariable="LB_Lista_de_Tipos_de_Acciones"/>

<cfif Attributes.combo>
	<cfinclude template="/rh/Utiles/ComboTipoAccion.cfm">
<cfelse>
	<script language="JavaScript" type="text/javascript">
		<cfif Attributes.Conlis>
			function doConlisTipoAcciones<cfoutput>#index#</cfoutput>() {
				var width = 600;
				var height = 500;
				var top = (screen.height - height) / 2;
				var left = (screen.width - width) / 2;
				<cfoutput>
				var nuevo = window.open('/cfmx/rh/Utiles/ConlisTipoAccion.cfm?f=#Attributes.form#&p1=RHTid#index#&p2=RHTcodigo#index#&p3=RHTdesc#index#&p4=RHTpmax#index#&p5=RHTcomportam#index#<cfif Attributes.autogestion>&ag=1</cfif>&tabindex=#Attributes.tabindex#&FiltroExtra=#Attributes.FiltroExtra#','ListaTipoAccion','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
				</cfoutput>
				nuevo.focus();
			}
		</cfif>
		
		function ClearTipoAccion<cfoutput>#index#</cfoutput>() {
			document.<cfoutput>#Attributes.form#</cfoutput>.RHTid<cfoutput>#index#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#</cfoutput>.RHTcodigo<cfoutput>#index#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#</cfoutput>.RHTdesc<cfoutput>#index#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#</cfoutput>.RHTpmax<cfoutput>#index#</cfoutput>.value = "0";
			document.<cfoutput>#Attributes.form#</cfoutput>.RHTcomportam<cfoutput>#index#</cfoutput>.value = "";
		}
		
		function TraeTipoAccion<cfoutput>#index#</cfoutput>(dato) {
			window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.RHTid<cfoutput>#index#</cfoutput>;
			window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.RHTcodigo<cfoutput>#index#</cfoutput>;
			window.ctlacc = document.<cfoutput>#Attributes.form#</cfoutput>.RHTdesc<cfoutput>#index#</cfoutput>;
			window.ctlpmax = document.<cfoutput>#Attributes.form#</cfoutput>.RHTpmax<cfoutput>#index#</cfoutput>;
			window.ctlcompor = document.<cfoutput>#Attributes.form#</cfoutput>.RHTcomportam<cfoutput>#index#</cfoutput>;
			if (document.<cfoutput>#Attributes.form#.RHTcodigo#index#</cfoutput>.value != "") {
				var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
				fr.src = "/cfmx/rh/Utiles/rhtipoaccionquery.cfm?RHTcodigo="+dato<cfif Attributes.autogestion>+"&ag=1"</cfif>+"&FiltroExtra=<cfoutput>#Attributes.FiltroExtra#</cfoutput>";
			} 
			else {
				ClearTipoAccion<cfoutput>#index#</cfoutput>();
			}
			return true;
		}
		
		/**
		 * A esta funcion se le puede pasar indices de los controles en 'hidectls' que se quieren ocultar
		 * si no se mandan argumentos adicionales quiere decir que se quiere ocultar todos los controles 
		 * enviados por el attributo 'hidectls'
		 */
	
		<cfif Len(Trim(Attributes.hidectls)) NEQ 0>
			function hideControls(val) {
				<cfoutput>
					<cfset ctls = ListToArray(Attributes.hidectls, ",")>
					var ctls = new Array();
					<cfloop index="i" from="1" to="#ArrayLen(ctls)#">
						ctls[ctls.length] = "#ctls[i]#";
					</cfloop>
				</cfoutput>

				if (val == "1") {
					// Si vienen más argumentos
					if (arguments[1] != null) {
						for (var i=1; i<arguments.length; i++) {
							var ctl = document.getElementById(ctls[arguments[i]-1]);
							if (ctl) ctl.style.display = "";
						}
					} 
					else {
						for (var i=0; i<ctls.length; i++) {
							var ctl = document.getElementById(ctls[i]);
							if (ctl) ctl.style.display = "";
						}
					}
				} 
				else {
					if (arguments[1] != null) {
						for (var i=1; i<arguments.length; i++) {
							var ctl = document.getElementById(ctls[arguments[i]-1]);
							if (ctl) ctl.style.display = "none";
						}
					} else {
						for (var i=0; i<ctls.length; i++) {
							var ctl = document.getElementById(ctls[i]);
							if (ctl) ctl.style.display = "none";
						}
					}
				}
				// Llama a una funcion de validacion que deberia crearse en la pagina que utiliza este tag 
				// si es que se requiere
				if (window.validateControls) validateControls(val);
				return true;
			}
		</cfif>
		
		<cfif Attributes.AgregarEnLista>
			function AgregarTipoAccionLista<cfoutput>#index#</cfoutput>(){
					var existe = 0;
		
					if($('#tableListaTipoAccion<cfoutput>#index#</cfoutput>').length){
						$('input.ListaTipoAccion<cfoutput>#index#</cfoutput>').each(function() {
							if($('#RHTid<cfoutput>#index#</cfoutput>').val() == $(this).val()){ existe=1;}
						});
					}
					if(existe == 1){
						alert("Este Tipo de Acción ya se encuentra agregado");
					}
					else{	
						if($('#RHTcodigo<cfoutput>#index#</cfoutput>').val() == ''){
							alert("Debe seleccionar un Tipo de Acción");
						}	
						else{	
						   $('#tableListaTipoAccion<cfoutput>#index#</cfoutput>').append("<tr><td nowrap='nowrap'><input class='<cfoutput>ListaTipoAccion#index#</cfoutput>' type='hidden' id='<cfoutput>ListaTipoAccion#index#</cfoutput>' name='<cfoutput>ListaTipoAccion#index#</cfoutput>' value="+$('#RHTid<cfoutput>#index#</cfoutput>').val()+">"+$('#<cfoutput>RHTcodigo#index#</cfoutput>').val()+" - " +$('#RHTdesc<cfoutput>#index#</cfoutput>').val()+ "<img src='/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif' onclick='QuitarTipoAccionLista<cfoutput>#index#</cfoutput>(this)' ></td></tr>");
						   $('#RHTcodigo<cfoutput>#index#</cfoutput>').val(""); 
						   $('#RHTdesc<cfoutput>#index#</cfoutput>').val(""); 
						}
					}
			}
			function QuitarTipoAccionLista<cfoutput>#index#</cfoutput>(elemento){
				$(elemento).parent().parent().remove(); 
			}
		</cfif>	
		
	</script>
	
	<cfoutput>
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<input type="hidden" name="RHTid#index#" id="RHTid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTid#index#")>#Evaluate("Attributes.query.RHTid#index#")#</cfif>">
					<!--- <input type="hidden" name="RHTpfijo#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTpfijo#index#")>#Evaluate("Attributes.query.RHTpfijo#index#")#</cfif>"> --->
					<input type="hidden" name="RHTpmax#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTpmax#index#")>#Evaluate("Attributes.query.RHTpmax#index#")#</cfif>">
					<input type="hidden" name="RHTcomportam#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTcomportam#index#")>#Evaluate("Attributes.query.RHTcomportam#index#")#</cfif>">
					<input type="text"
						name="RHTcodigo#index#" id="RHTcodigo#index#"
						value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTcodigo#index#")>#Evaluate("Attributes.query.RHTcodigo#index#")#</cfif>"
						maxlength="3"
						size="5"
						tabindex="#Attributes.tabindex#"
						onblur="javascript: TraeTipoAccion#index#(document.#Attributes.form#.RHTcodigo#index#.value);">
				</td>
				<td nowrap>
					<input type="text"
						name="RHTdesc#index#" id="RHTdesc#index#"
						tabindex="#Attributes.tabindex#"
						value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTdesc#index#")>#Evaluate("Attributes.query.RHTdesc#index#")#</cfif>" 
						maxlength="80"
						size="#Attributes.size#"
						readonly="true">
					<cfif Attributes.Conlis><a href="javascript: doConlisTipoAcciones#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_Tipos_de_Acciones#" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
				</td>
				<cfif Attributes.AgregarEnLista>
				<td>
					<input type="button" onclick="AgregarTipoAccionLista<cfoutput>#index#</cfoutput>()" value="+" class="btnNormal" />
				</td>				
				</cfif>
			</tr>
			<cfif Attributes.AgregarEnLista>
			<tr>
				<td colspan="5">
					<table id="tableListaTipoAccion<cfoutput>#index#</cfoutput>">
					</table>
				</td>
			</tr>
			</cfif>
		</table>
	</cfoutput>
	
	<cfif not isdefined("Request.TipoAccionTag")>
		<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
		<cfset Request.TipoAccionTag = True>
	</cfif>

</cfif><!--- cfif Attributes.combo --->