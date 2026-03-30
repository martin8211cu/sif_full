<cfset def = QueryNew('dato')>


<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Empleados --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRArea" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Empleado --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.conlis" default="true" 			type="boolean"> <!--- muestra conlis o no --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
<cfif Attributes.Conlis>
	function doConlisArea<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		<cfoutput>
			var nuevo = window.open('/cfmx/asp/admin/encuestas/ConlisEArea.cfm?f=#Attributes.form#&p1=EEid#index#','ListaAreas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}
	
	function ResetArea<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.EAid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.EAdescripcion#index#</cfoutput>.value = "";
	}
	</cfif>

	function TraeArea<cfoutput>#index#</cfoutput>(EEid) {
		window.ctlEAid = document.<cfoutput>#Attributes.form#</cfoutput>.EAid<cfoutput>#index#</cfoutput>;
		window.ctldesc = document.<cfoutput>#Attributes.form#</cfoutput>.EAdescripcion<cfoutput>#index#</cfoutput>;
		if (document.<cfoutput>#Attributes.form#.EAdescripcion#index#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/sif/rh/Utiles/EAreaquery.cfm?EEid="+EEid;
		} else {
			ResetArea<cfoutput>#index#</cfoutput>();
		}
		return true;
	}

</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="text"
				name="EAid#index#" id="EAid#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.EAid#index#")>
							#Evaluate("Attributes.query.EAid#index#")#</cfif>"
				onblur="javascript:	TraeArea#index#(document.#Attributes.form#.EAid#index#.value);"
				<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
		</td>
	    <td nowrap>
			<input type="text"
				name="EAdescripcion#index#" id="EAdescripcion#index#"
				tabindex="-1"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.EAdescripcion#index#")>
							#Evaluate("Attributes.query.EAdescripcion#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly='true'>
			<cfif Attributes.Conlis><a href="javascript: doConlisArea#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Empleados" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
		</td>
	</tr>
</table>
</cfoutput>

