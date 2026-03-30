<cfset def = QueryNew('dato')>

<cfparam name="Attributes.TipoId" default="" type="string"> <!--- Indica si el Tipo de Identificación que se va a manejar, cuando no se indica se coloca un combo --->
<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Oferentes --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FROferente" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Oferente --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.conlis" default="true" 			type="boolean"> <!--- muestra conlis o no --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>


<script language="JavaScript" type="text/javascript">
	<cfif Attributes.Conlis>
	function doConlisOferentes<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		<cfoutput>
			<cfif Attributes.TipoId EQ "-1">
					var nuevo = window.open('/cfmx/rh/Utiles/ConlisOferentes.cfm?f=#Attributes.form#&p1=RHOid#index#&p3=RHOidentificacion#index#&p4=NombreOferente#index#','ListaOferentes','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			<cfelse>
					var nuevo = window.open('/cfmx/rh/Utiles/ConlisOferentes.cfm?f=#Attributes.form#&p1=RHOid#index#&p3=RHOidentificacion#index#&p4=NombreOferente#index#','ListaOferentes','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfif>
		</cfoutput>
		
		nuevo.focus();
	}
	
	function ResetEmployee<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.RHOid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHOidentificacion#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.NombreOferente#index#</cfoutput>.value = "";
	}
	</cfif>

	function TraeOferente<cfoutput>#index#</cfoutput>(Ident) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.RHOid<cfoutput>#index#</cfoutput>;
		window.ctlident = document.<cfoutput>#Attributes.form#</cfoutput>.RHOidentificacion<cfoutput>#index#</cfoutput>;
		window.ctlemp = document.<cfoutput>#Attributes.form#</cfoutput>.NombreOferente<cfoutput>#index#</cfoutput>;
		if (document.<cfoutput>#Attributes.form#.RHOidentificacion#index#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhoferentequery.cfm?RHOidentificacion="+Ident;
		} else {
			ResetEmployee<cfoutput>#index#</cfoutput>();
		}
		return true;
	}

</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="hidden" name="RHOid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHOid#index#")>#Evaluate("Attributes.query.RHOid#index#")#</cfif>">
			<input type="text"
				name="RHOidentificacion#index#" id="RHOidentificacion#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHOidentificacion#index#")>#Evaluate("Attributes.query.RHOidentificacion#index#")#</cfif>"
				onblur="javascript: TraeOferente#index#(document.#Attributes.form#.RHOidentificacion#index#.value);"
				<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
		</td>
	    <td nowrap>
			<input type="text"
				name="NombreOferente#index#" id="NombreOferente#index#"
				tabindex="-1"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.NombreOferente#index#")>#Evaluate("Attributes.query.NombreOferente#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly='true'>
			<cfif Attributes.Conlis><a href="javascript: doConlisOferentes#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Oferentes" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
		</td>
	</tr>
</table>
</cfoutput>

<!--- <cfif not isdefined("Request.EmployeeTag")> --->
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	<cfset Request.EmployeeTag = True>
<!--- </cfif> --->
