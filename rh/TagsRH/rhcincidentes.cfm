<cfset def = QueryNew('dato')>

<cfparam name="Attributes.Conlis" 			default="true" 			type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Conceptos de Incidencia --->
<cfparam name="Attributes.index" 			default="0" 			type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" 			default="form1" 		type="String">	<!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" 			default="#def#" 		type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.frame" 			default="FRCIncidentes" type="String"> 	<!--- Nombre del frame --->
<cfparam name="Attributes.size" 			default="25" 			type="numeric"> <!--- Tamaño de la Descripción del Concepto de Pago --->
<cfparam name="Attributes.tabindex" 		default="" 				type="String"> 	<!--- Tabindex del CIid --->
<cfparam name="Attributes.CIid" 			default="CIid" 			type="String"> 	<!--- Nombre del Campo CIid --->
<cfparam name="Attributes.CIcodigo" 		default="CIcodigo" 		type="String"> 	<!--- Nombre del Campo CIcodigo --->
<cfparam name="Attributes.CIdescripcion" 	default="CIdescripcion" type="String"> 	<!--- Nombre del Campo CIdescripcion --->
<cfparam name="Attributes.IncluirTipo" 		default="" 				type="String"> 	<!--- Incluir únicamente estos tipos (CItipo) SEPARADOS POR "," EJEM "0,1" *** ver Regla para el Campo CItipo--->
<cfparam name="Attributes.ExcluirTipo" 		default="" 				type="String"> 	<!--- Excluir únicamente estos tipos (CItipo) SEPARADOS POR "," EJEM "0,1" *** ver Regla para el Campo CItipo--->
<cfparam name="Attributes.IncluirAnticipo" 	default="" 				type="String">	<!--- indica si el concepto incidente se toma en cuenta en Nominas de Anticipo --->
<cfparam name="Attributes.IncluirChk" 		default="" 				type="string">  <!--- Incluir CHKs, en le fuente que se utilice se debe crear una variables chkLista que es la que contiene la lista de CIid que se seleccionaron --->
<cfparam name="Attributes.CarreraP" 		default="0" 			type="numeric">	<!--- Indica si toma en cuenta los conceptos incidentes de Carrera Profesional --->																	
<cfparam name="Attributes.onBlur" 			default="" 				type="string"> 	<!--- Función que se ejecuta en ese evento y al cerrar la ventana del conlis --->
<cfparam name="Attributes.submit" 			default="" 				type="string">
<cfparam name="Attributes.Omitir"           default=""             	type="string">
<cfparam name="Attributes.IncluirTipoC" 	default="" 				type="String"> 	<!--- Incluir únicamente estos tipos (CItipo) de tipo dinamico un campo tipo select que va variando sus valores--->
<cfparam name="Attributes.FiltroExtra" 		default=""  			type="string">
<cfparam name="Attributes.AgregarEnLista" 	default="false" 		type="boolean"><!--- permite agregar Conceptos de Pago a una lista por medio del boton (+) --->
<cfparam name="Attributes.ListaIdDefault" 	default="" 				type="string"><!--- Se pinta en lista los id indicados en este parametros, siempre que exista AgregarEnlista="true" --->

<!--- Regla para el Campo CItipo

0 = Horas
1 = Días
2 = Importe
3 = Cálculo

--->


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


<script language="JavaScript" type="text/javascript">
	<cfif Attributes.Conlis>
	function doConlisCIncidentes<cfoutput>#index#</cfoutput>() {
		var width = 700;
		var height = 400;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfset params = "f=" & Attributes.form & "&omitir=" & Attributes.Omitir & "&p1=" & Attributes.CIid & index & "&p2=" & Attributes.CIcodigo & index & "&p3=" & Attributes.CIdescripcion & index &"&FiltroExtra="&Attributes.FiltroExtra>
		<cfif len(trim(Attributes.IncluirTipo)) gt 0>
			<cfset params = params & "&IncluirTipo=" & Attributes.IncluirTipo>
		</cfif>		
		<cfif len(trim(Attributes.IncluirTipoC)) gt 0>
			var LvarIncluirTipo = document.<cfoutput>#attributes.form#.#Attributes.IncluirTipoC#</cfoutput>.value;
			if (LvarIncluirTipo == '')
			{
				alert ('Falta digitar el tipo a incluir');
				return false;
			}
			<cfset params = params & "&IncluirTipo=' + LvarIncluirTipo + '">
		</cfif>
	
		<cfif len(trim(Attributes.ExcluirTipo)) gt 0>
			<cfset params = params & "&ExcluirTipo=" & Attributes.ExcluirTipo>
		</cfif>
		<cfif Attributes.IncluirAnticipo gt 0>
			<cfset params = params & "&IncluirAnticipo=" & Attributes.IncluirAnticipo>
		</cfif>
		<cfif len(trim(Attributes.onBlur)) gt 0>
			<cfset params = params & "&onBlur=" & Attributes.onBlur>
		</cfif>
		<cfif len(trim(Attributes.IncluirChk)) gt 0>
			<cfset params = params & "&IncluirChk=" & Attributes.IncluirChk>
		</cfif>
		<cfif len(trim(Attributes.CarreraP)) gt 0>
			<cfset params = params & "&CarreraP=" & Attributes.CarreraP>
		</cfif>
		<cfif len(trim(Attributes.submit)) gt 0>
			<cfset params = params & "&submit=" & Attributes.submit>
		</cfif>
		<cfif len(trim(Attributes.index)) gt 0>
			<cfset params = params & "&index=" & Attributes.index>
		</cfif>
		<cfoutput>
		var nuevo = window.open('/cfmx/rh/Utiles/ConlisCIncidentes.cfm?#params#','ListaCIncidentes','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}
	</cfif>
	
	function TraeCIncidentes<cfoutput>#index#</cfoutput>(dato) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CIid#</cfoutput><cfoutput>#index#</cfoutput>;
		window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CIcodigo#</cfoutput><cfoutput>#index#</cfoutput>;
		window.ctldesc = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CIdescripcion#</cfoutput><cfoutput>#index#</cfoutput>;
		window.ctlsigno = document.<cfoutput>#Attributes.form#</cfoutput>.negativo<cfoutput>#index#</cfoutput>;
		<cfset params = "">
		<cfif len(trim(Attributes.IncluirTipo)) gt 0>
			<cfset params = params & "&IncluirTipo=" & Attributes.IncluirTipo>
		<cfelseif isdefined(Attributes.IncluirTipoC) >
				<cfif len(trim(Attributes.IncluirTipoC)) gt 0>
				var LvarIncluirTipo = document.<cfoutput>#attributes.form#.#Attributes.IncluirTipoC#</cfoutput>.value;
				if (LvarIncluirTipo == '')
				{
					alert ('Falta digitar el tipo a incluir');
					return false;
				}
				<cfset params = params & "&IncluirTipo=' + LvarIncluirTipo + '">
				</cfif>
		</cfif>
		<cfif len(trim(Attributes.ExcluirTipo)) gt 0>
			<cfset params = params & "&ExcluirTipo=" & Attributes.ExcluirTipo>
		</cfif>
		<cfif len(trim(Attributes.IncluirAnticipo)) gt 0>
			<cfset params = params & "&IncluirAnticipo=" & Attributes.IncluirAnticipo>
		</cfif>
		<cfif len(trim(Attributes.IncluirChk)) gt 0>
			<cfset params = params & "&IncluirChk=" & Attributes.IncluirChk>
		</cfif>
		<cfif len(trim(Attributes.CarreraP)) gt 0>
			<cfset params = params & "&CarreraP=" & Attributes.CarreraP>
		</cfif>
		<cfif len(trim(Attributes.onBlur)) gt 0>
			<cfset params = params & "&onBlur=" & Attributes.onBlur>
		</cfif>
		<cfif len(trim(Attributes.index)) gt 0>
			<cfset params = params & "&index=" & Attributes.index>
		</cfif>
		var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput><cfoutput>#Attributes.index#</cfoutput>");
		<cfoutput>
		fr.src = "/cfmx/rh/Utiles/rhcincidentesquery.cfm?CIcodigo="+dato+"#params#";
		</cfoutput>
		return true;
	}
	
	<cfif Attributes.AgregarEnLista>
		function AgregarConceptoPagoLista<cfoutput>#index#</cfoutput>(){
				var existe = 0;
	
				if($('#ListaConceptoPago<cfoutput>#index#</cfoutput>').length){
					$('input.ListaConceptoPago<cfoutput>#index#</cfoutput>').each(function() {
						if($('#CIid<cfoutput>#index#</cfoutput>').val() == $(this).val()){ existe=1;}
					});
				}
				if(existe == 1){
					alert("Este Concepto de Pago ya se encuentra agregado");
				}
				else{	
					if($('#CIcodigo<cfoutput>#index#</cfoutput>').val() == ''){
						alert("Debe seleccionar un Concepto de Pago");
					}	
					else{	
					   $('#ListaConceptoPago<cfoutput>#index#</cfoutput>').append("<tr><td nowrap='nowrap'><input class='<cfoutput>ListaConceptoPago#index#</cfoutput>' type='hidden' id='<cfoutput>ListaConceptoPago#index#</cfoutput>' name='<cfoutput>ListaConceptoPago#index#</cfoutput>' value="+$('#CIid<cfoutput>#index#</cfoutput>').val()+">"+$('#<cfoutput>CIcodigo#index#</cfoutput>').val()+" - " +$('#CIdescripcion<cfoutput>#index#</cfoutput>').val()+ "<img src='/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif' onclick='QuitarConceptoPagoLista<cfoutput>#index#</cfoutput>(this)' ></td></tr>");
					   $('#CIcodigo<cfoutput>#index#</cfoutput>').val(""); 
					   $('#CIdescripcion<cfoutput>#index#</cfoutput>').val(""); 
					}
				}
		}
		function QuitarConceptoPagoLista<cfoutput>#index#</cfoutput>(elemento){
			$(elemento).parent().parent().remove(); 
		}
	</cfif>	
</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="hidden" tabindex="-1"
				name="negativo#index#" id="negativo#index#" 
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CInegativo#index#")>#Evaluate("Attributes.query.CInegativo#index#")#<cfelse>1</cfif>">
			<input type="hidden" tabindex="-1"
				name="CIid#index#" id="CIid#index#" 
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CIid#index#")>#Evaluate("Attributes.query.CIid#index#")#</cfif>">
			<input type="text" <cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif> 
				name="#Attributes.CIcodigo##index#" id="#Attributes.CIcodigo##index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CIcodigo#index#")>#Evaluate("Attributes.query.CIcodigo#index#")#</cfif>"
				maxlength="5"
				size="5"
				onblur="javascript: TraeCIncidentes#index#(this.value);">
		</td>
	    <td nowrap>
			<input type="text" tabindex="-1"
				name="#Attributes.CIdescripcion##index#" id="#Attributes.CIdescripcion##index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CIdescripcion#index#")>#Evaluate("Attributes.query.CIdescripcion#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly="true">
			<cfif Attributes.Conlis><a href="javascript: doConlisCIncidentes#index#();" onmouseover="javascript: window.status=''; return true;" onmouseout="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif"  name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
		</td>
		<cfif Attributes.AgregarEnLista>
		<td>
			<input type="button" onclick="AgregarConceptoPagoLista<cfoutput>#index#</cfoutput>()" value="+" class="btnNormal" />
		</td>				
		</cfif>
	</tr>
	<cfif Attributes.AgregarEnLista>
	<tr>
		<td colspan="5">
			<table id="ListaConceptoPago<cfoutput>#index#</cfoutput>">
				<cfif len(trim(Attributes.ListaIdDefault))>
					<cfquery datasource="#session.dsn#" name="rsListaIncidentes">
						select CIid, CIcodigo, CIdescripcion
						from CIncidentes
						where CIid in (#Attributes.ListaIdDefault#)
					</cfquery>
						<cfloop query="rsListaIncidentes">
						 	<tr>
						 		<td nowrap="nowrap">
						 			<input class="ListaConceptoPago<cfoutput>#index#</cfoutput>" type="hidden" id="ListaConceptoPago<cfoutput>#index#</cfoutput>" name="ListaConceptoPago<cfoutput>#index#</cfoutput>" value="<cfoutput>#CIid#</cfoutput>"><cfoutput>#CIcodigo#- #CIdescripcion#</cfoutput><img src="/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif" onclick="QuitarConceptoPagoLista<cfoutput>#index#</cfoutput>(this)">
						 		</td>
					 		</tr>
				 		</cfloop>
				</cfif>
			</table>
		</td>
	</tr>
	</cfif>
</table>
</cfoutput>

<iframe id="<cfoutput>#Attributes.frame#</cfoutput><cfoutput>#Attributes.index#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput><cfoutput>#Attributes.index#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
