<cfset def = QueryNew("dato")>

<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRBeneficio" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del beneficio --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
	function doConlisBeneficios<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var params = "";
		<cfoutput>
		params += "?f=#Attributes.form#&p1=Bid#index#&p2=Bcodigo#index#&p3=Bdescripcion#index#&p4=Mcodigo#index#";
		params += "&p5=BEmonto#index#&p6=BEporcemp#index#&p7=Btercero#index#&p8=SNcodigo#index#&p9=SNnumero#index#&p10=SNnombre#index#";
		var nuevo = window.open('/cfmx/rh/Utiles/ConlisBeneficio.cfm'+params,'ListaBeneficio','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}
	
	function ClearBeneficio<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#</cfoutput>.Bid<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.Bcodigo<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.Bdescripcion<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.Mcodigo<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.BEmonto<cfoutput>#index#</cfoutput>.value = "0.00";
		document.<cfoutput>#Attributes.form#</cfoutput>.BEporcemp<cfoutput>#index#</cfoutput>.value = "0.00";
		document.<cfoutput>#Attributes.form#</cfoutput>.Btercero<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.SNcodigo<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.SNnumero<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.SNnombre<cfoutput>#index#</cfoutput>.value = "";
	}
	
	function TraeBeneficio<cfoutput>#index#</cfoutput>(dato) {
		window.p1 = document.<cfoutput>#Attributes.form#</cfoutput>.Bid<cfoutput>#index#</cfoutput>;
		window.p2 = document.<cfoutput>#Attributes.form#</cfoutput>.Bcodigo<cfoutput>#index#</cfoutput>;
		window.p3 = document.<cfoutput>#Attributes.form#</cfoutput>.Bdescripcion<cfoutput>#index#</cfoutput>;
		window.p4 = document.<cfoutput>#Attributes.form#</cfoutput>.Mcodigo<cfoutput>#index#</cfoutput>;
		window.p5 = document.<cfoutput>#Attributes.form#</cfoutput>.BEmonto<cfoutput>#index#</cfoutput>;
		window.p6 = document.<cfoutput>#Attributes.form#</cfoutput>.BEporcemp<cfoutput>#index#</cfoutput>;
		window.p7 = document.<cfoutput>#Attributes.form#</cfoutput>.Btercero<cfoutput>#index#</cfoutput>;
		window.p8 = document.<cfoutput>#Attributes.form#</cfoutput>.SNcodigo<cfoutput>#index#</cfoutput>;
		window.p9 = document.<cfoutput>#Attributes.form#</cfoutput>.SNnumero<cfoutput>#index#</cfoutput>;
		window.p10 = document.<cfoutput>#Attributes.form#</cfoutput>.SNnombre<cfoutput>#index#</cfoutput>;
		if (document.<cfoutput>#Attributes.form#.Bcodigo#index#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhbeneficioquery.cfm?Bcodigo="+dato;
		} 
		else {
			ClearBeneficio<cfoutput>#index#</cfoutput>();
		}
		return true;
	}
</script>

<cfoutput>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<input type="hidden" name="Bid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Bid#index#")>#Evaluate("Attributes.query.Bid#index#")#</cfif>">
				<input type="text"
					name="Bcodigo#index#" id="Bcodigo#index#"
					value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Bcodigo#index#")>#Evaluate("Attributes.query.Bcodigo#index#")#</cfif>"
					maxlength="4"
					size="4"
					onblur="javascript: TraeBeneficio#index#(document.#Attributes.form#.Bcodigo#index#.value);">
			</td>
			<td nowrap>
				<input type="text"
					name="Bdescripcion#index#" id="Bdescripcion#index#"
					tabindex="-1"
					value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Bdescripcion#index#")>#Evaluate("Attributes.query.Bdescripcion#index#")#</cfif>" 
					maxlength="80"
					size="#Attributes.size#"
					readonly="true">
				<a href="javascript: doConlisBeneficios#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Tipos de Acciones" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
			</td>
		</tr>
	</table>
</cfoutput>

<cfif not isdefined("Request.BeneficioTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	<cfset Request.BeneficioTag = True>
</cfif>
