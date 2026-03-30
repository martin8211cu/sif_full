<cfset def = QueryNew('dato')>

<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Empleados --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRhabilidad" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Empleado --->
<cfparam name="Attributes.name" default="RHHid" type="String"> <!--- Nombre del campo del c[odigo de la Habilidad --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.inactivos" default="0" type="numeric"> <!--- si el valor es 1 quita los inactivos, el valor default muestra todos --->
<cfparam name="Attributes.orderby" default="RHHcodigo" type="string"> <!--- indica campo por el cual se realizara ordenamiento, el valor default ordena por el codigo de la habilidad --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
	<cfif Attributes.Conlis>
	function doConlis_Habiliadades<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		<cfoutput>
			var nuevo = window.open('/cfmx/rh/Utiles/ConlisHabilidades.cfm?f=#Attributes.form#&p1=RHHid#index#&p2=RHHcodigo#index#&p3=RHHdescripcion#index#&name=#Attributes.name##index#&inactivos=#Attributes.inactivos#&orderby=#Attributes.orderby#','ListaHabilidades','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		
		nuevo.focus();
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#index#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlis_Habiliadades<cfoutput>#index#</cfoutput>();
		}
	}
	function ResetHabilidad<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.RHHid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHHcodigo#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHHdescripcion#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.PCid_#Attributes.name##index#</cfoutput>.value="";		
		document.<cfoutput>#Attributes.form#.RHHubicacionB_#Attributes.name##index#</cfoutput>.value="";		
	}
	</cfif>

	function TraeHabilidad<cfoutput>#index#</cfoutput>(Cod) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.RHHid<cfoutput>#index#</cfoutput>;
		window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.RHHcodigo<cfoutput>#index#</cfoutput>;
		window.ctldesc = document.<cfoutput>#Attributes.form#</cfoutput>.RHHdescripcion<cfoutput>#index#</cfoutput>;
		window.ctlpcid = document.<cfoutput>#Attributes.form#.PCid_#Attributes.name##index#</cfoutput>;		
		window.ctlrhubic = document.<cfoutput>#Attributes.form#.RHHubicacionB_#Attributes.name##index#</cfoutput>;		

		if (document.<cfoutput>#Attributes.form#.RHHcodigo#index#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhhabilidadquery.cfm?inactivos=<cfoutput>#Attributes.inactivos#</cfoutput>&codigo="+Cod+"&name=RHHid";
		} else {
			ResetHabilidad<cfoutput>#index#</cfoutput>();
		}
		return true;
	}
</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="hidden" name="RHHid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHHid#index#")>#Evaluate("Attributes.query.RHHid#index#")#</cfif>">
			<input type="text"
				name="RHHcodigo#index#" id="RHHcodigo#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHHcodigo#index#")>#Evaluate('Attributes.query.RHHcodigo#index#')#</cfif>"
				onkeyup="javascript:conlis_keyup_#index#(event);"
				onblur="javascript: TraeHabilidad#index#(document.#Attributes.form#.RHHcodigo#index#.value);"
				<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>
				maxlength="5"
				size="5"
				onfocus="this.select();">
		</td>
	    <td>
			<input type="text"
				name="RHHdescripcion#index#" id="RHHdescripcion#index#"
				tabindex="-1"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHHdescripcion#index#")>#Evaluate("Attributes.query.RHHdescripcion#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly='true'
				onfocus="this.select();">
		</td>
		<td>
			<cfif Attributes.Conlis><a href="javascript: doConlis_Habiliadades#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Habilidades" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>		
		</td>
	</tr>
</table>
	<!--- Estos campos son solo para recuperar mas informacion de la habilidad --->
	<!--- No interesa ponerles valor en modo cambio, son de paso nadamas --->
	<input type="hidden" name="PCid_#Attributes.name##index#" id="PCid_#Attributes.name##index#"	value="" >
	<input type="hidden" name="RHHubicacionB_#Attributes.name##index#" id="RHHubicacionB_#Attributes.name##index#" value="" >
	
</cfoutput>
<cfif not isdefined("Request.HabilidadTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	<cfset Request.HabilidadTag = True>
</cfif>
