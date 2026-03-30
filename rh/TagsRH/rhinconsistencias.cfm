<cfset def = QueryNew('dato')>

<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Conceptos de Incidencia --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.frame" default="FRCIncidentes" type="String"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño de la Descripción--->
<cfparam name="Attributes.RHIid" default="RHIid" type="String"> <!--- Nombre del Campo RHIid --->
<cfparam name="Attributes.CIdescripcion" default="CIdescripcion" type="String"> <!--- Nombre del Campo CIdescripcion --->
<cfparam name="Attributes.onBlur" default="" type="string"> <!--- Función que se ejecuta en ese evento y al cerrar la ventana del conlis --->


<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
	<cfif Attributes.Conlis>
	function doConlisCIncidentes<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfset params = "f=" & Attributes.form & "&p1=" & Attributes.RHIid & index & "&p2=" & Attributes.CIcodigo & index & "&p3=" & Attributes.CIdescripcion & index>
		<cfif len(trim(Attributes.IncluirTipo)) gt 0>
			<cfset params = params & "&IncluirTipo=" & Attributes.IncluirTipo>
		</cfif>
		<cfif len(trim(Attributes.ExcluirTipo)) gt 0>
			<cfset params = params & "&ExcluirTipo=" & Attributes.ExcluirTipo>
		</cfif>
		<cfif len(trim(Attributes.onBlur)) gt 0>
			<cfset params = params & "&onBlur=" & Attributes.onBlur>
		</cfif>
		<cfoutput>
		var nuevo = window.open('/cfmx/rh/Utiles/ConlisCIncidentes.cfm?#params#','ListaCIncidentes','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}
	</cfif>
	
	function TraeCIncidentes<cfoutput>#index#</cfoutput>(dato) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.RHIid#</cfoutput><cfoutput>#index#</cfoutput>;
		window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CIcodigo#</cfoutput><cfoutput>#index#</cfoutput>;
		window.ctldesc = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.CIdescripcion#</cfoutput><cfoutput>#index#</cfoutput>;
		window.ctlsigno = document.<cfoutput>#Attributes.form#</cfoutput>.negativo<cfoutput>#index#</cfoutput>;
		<cfset params = "">
		<cfif len(trim(Attributes.IncluirTipo)) gt 0>
			<cfset params = params & "&IncluirTipo=" & Attributes.IncluirTipo>
		</cfif>
		<cfif len(trim(Attributes.ExcluirTipo)) gt 0>
			<cfset params = params & "&ExcluirTipo=" & Attributes.ExcluirTipo>
		</cfif>
		<cfif len(trim(Attributes.onBlur)) gt 0>
			<cfset params = params & "&onBlur=" & Attributes.onBlur>
		</cfif>
		var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput><cfoutput>#Attributes.index#</cfoutput>");
		<cfoutput>
		fr.src = "/cfmx/rh/Utiles/rhcincidentesquery.cfm?CIcodigo="+dato+"#params#";
		</cfoutput>
		return true;
	}
</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="hidden" tabindex="-1"
				name="negativo#index#" id="negativo#index#" 
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CInegativo#index#")>#Evaluate("Attributes.query.CInegativo#index#")#<cfelse>1</cfif>">
			<input type="hidden" tabindex="-1"
				name="RHIid#index#" id="RHIid#index#" 
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHIid#index#")>#Evaluate("Attributes.query.RHIid#index#")#</cfif>">
			<input type="text" <cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif> 
				name="CIcodigo#index#" id="CIcodigo#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CIcodigo#index#")>#Evaluate("Attributes.query.CIcodigo#index#")#</cfif>"
				maxlength="3"
				size="3"
				onblur="javascript: TraeCIncidentes#index#(this.value);">
		</td>
	    <td nowrap>
			<input type="text" tabindex="-1"
				name="CIdescripcion#index#" id="CIdescripcion#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CIdescripcion#index#")>#Evaluate("Attributes.query.CIdescripcion#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly="true">
			<cfif Attributes.Conlis><a href="javascript: doConlisCIncidentes#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Conceptos de Incidencias" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
		</td>
	</tr>
</table>
</cfoutput>

<iframe id="<cfoutput>#Attributes.frame#</cfoutput><cfoutput>#Attributes.index#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput><cfoutput>#Attributes.index#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
