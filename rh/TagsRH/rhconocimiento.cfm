<cfset def = QueryNew('dato')>

<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Empleados --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRconocimiento" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Empleado --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.inactivos" default="0" type="numeric"> <!--- si el valor es 1 quita los inactivos, el valor default muestra todos --->
<cfparam name="Attributes.orderby" default="RHCcodigo" type="string"> <!--- indica campo por el cual se realizara ordenamiento, el valor default ordena por el codigo del conocimiento --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
	<cfif Attributes.Conlis>
	function doConlis_Conocimientos<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		<cfoutput>
			var nuevo = window.open('/cfmx/rh/Utiles/ConlisConocimientos.cfm?f=#Attributes.form#&p1=RHCid#index#&p2=RHCcodigo#index#&p3=RHCdescripcion#index#&inactivos=#Attributes.inactivos#&orderby=#Attributes.orderby#','<cf_translate key="LB_ListaConocimientos" xmlFile="/rh/generales.xml">Lista de Conocimientos</cf_translate>','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		
		nuevo.focus();
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#index#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlis_Conocimientos<cfoutput>#index#</cfoutput>();
		}
	}
	
	function ResetConocimiento<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.RHCid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHCcodigo#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHCdescripcion#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.PCid_RHCid#index#</cfoutput>.value="";
	}
	</cfif>

	function TraeConocimiento<cfoutput>#index#</cfoutput>(Cod) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.RHCid<cfoutput>#index#</cfoutput>;
		window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.RHCcodigo<cfoutput>#index#</cfoutput>;
		window.ctldesc = document.<cfoutput>#Attributes.form#</cfoutput>.RHCdescripcion<cfoutput>#index#</cfoutput>;
		window.ctlpcid = document.<cfoutput>#Attributes.form#.PCid_RHCid#index#</cfoutput>;	
		if (document.<cfoutput>#Attributes.form#.RHCcodigo#index#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhconocimientoquery.cfm?inactivos=<cfoutput>#Attributes.inactivos#</cfoutput>&codigo="+Cod;
		} else {
			ResetConocimiento<cfoutput>#index#</cfoutput>();
		}
		return true;
	}
</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="hidden" name="RHCid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHCid#index#")>#Evaluate("Attributes.query.RHCid#index#")#</cfif>">
			<input type="text"
				name="RHCcodigo#index#" id="RHCcodigo#index#"
				onkeyup="javascript:conlis_keyup_#index#(event);"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHCcodigo#index#")>#Evaluate('Attributes.query.RHCcodigo#index#')#</cfif>"
				onblur="javascript: TraeConocimiento#index#(document.#Attributes.form#.RHCcodigo#index#.value);"
				<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>
				maxlength="5"
				size="5">
		</td>
	    <td>
			<input type="text"
				name="RHCdescripcion#index#" id="RHCdescripcion#index#"
				tabindex="-1"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHCdescripcion#index#")>#Evaluate("Attributes.query.RHCdescripcion#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly='true'>
		</td>
		<td>
			<cfif Attributes.Conlis><a href="javascript: doConlis_Conocimientos#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Conocimientos" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>		
		</td>
	</tr>
</table>
	<input type="hidden" name="PCid_RHCid#index#" id="PCid_RHCid#index#"	value="" >
</cfoutput>
<cfif not isdefined("Request.ConocimientoTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	<cfset Request.ConocimientoTag = True>
</cfif>
