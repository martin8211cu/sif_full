<cfset def = QueryNew("dato")>

<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRBeneficioEmp" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del beneficio --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
	function doConlisBeneficiosEmp<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var params = "";
		<cfoutput>
		params += "?f=#Attributes.form#&p1=BElinea#index#&p2=Bcodigo#index#&p3=Bdescripcion#index#&p4=Mcodigo#index#";
		params += "&p5=HIBmonto#index#&p6=HIBporcemp#index#&p7=Btercero#index#&p8=SNcodigo#index#&p9=SNnumero#index#&p10=SNnombre#index#";
		<!--- Parametro de Empleado --->
		if (document.#Attributes.form#.DEid#index# != null) {
			if (document.#Attributes.form#.DEid#index#.value == '') {
				alert('Debe seleccionar un empleado antes de continuar');
				return;
			}
			params += "&DEid#index#="+document.#Attributes.form#.DEid#index#.value;
			var nuevo = window.open('/cfmx/rh/Utiles/ConlisBeneficioEmpleado.cfm'+params,'ListaBeneficioEmpleado','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
		} else {
			alert('Falta parámetro de Empleado')
		}
		</cfoutput>
	}
	
	function ClearBeneficioEmpleado<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#</cfoutput>.BElinea<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.Bcodigo<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.Bdescripcion<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.Mcodigo<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.HIBmonto<cfoutput>#index#</cfoutput>.value = "0.00";
		document.<cfoutput>#Attributes.form#</cfoutput>.HIBporcemp<cfoutput>#index#</cfoutput>.value = "0.00";
		document.<cfoutput>#Attributes.form#</cfoutput>.Btercero<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.SNcodigo<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.SNnumero<cfoutput>#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#</cfoutput>.SNnombre<cfoutput>#index#</cfoutput>.value = "";
	}
	
	function TraeBeneficioEmpleado<cfoutput>#index#</cfoutput>(dato) {
		window.p1 = document.<cfoutput>#Attributes.form#</cfoutput>.BElinea<cfoutput>#index#</cfoutput>;
		window.p2 = document.<cfoutput>#Attributes.form#</cfoutput>.Bcodigo<cfoutput>#index#</cfoutput>;
		window.p3 = document.<cfoutput>#Attributes.form#</cfoutput>.Bdescripcion<cfoutput>#index#</cfoutput>;
		window.p4 = document.<cfoutput>#Attributes.form#</cfoutput>.Mcodigo<cfoutput>#index#</cfoutput>;
		window.p5 = document.<cfoutput>#Attributes.form#</cfoutput>.HIBmonto<cfoutput>#index#</cfoutput>;
		window.p6 = document.<cfoutput>#Attributes.form#</cfoutput>.HIBporcemp<cfoutput>#index#</cfoutput>;
		window.p7 = document.<cfoutput>#Attributes.form#</cfoutput>.Btercero<cfoutput>#index#</cfoutput>;
		window.p8 = document.<cfoutput>#Attributes.form#</cfoutput>.SNcodigo<cfoutput>#index#</cfoutput>;
		window.p9 = document.<cfoutput>#Attributes.form#</cfoutput>.SNnumero<cfoutput>#index#</cfoutput>;
		window.p10 = document.<cfoutput>#Attributes.form#</cfoutput>.SNnombre<cfoutput>#index#</cfoutput>;
		if (document.<cfoutput>#Attributes.form#.Bcodigo#index#</cfoutput>.value != "") {
			<!--- Parametro de Empleado --->
			<cfoutput>
			if (document.#Attributes.form#.DEid#index# != null) {
				if (document.#Attributes.form#.DEid#index#.value == '') {
					alert('Debe seleccionar un empleado antes de continuar');
					return;
				}
				var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
				fr.src = "/cfmx/rh/Utiles/rhbeneficioempleadoquery.cfm?Bcodigo="+dato+"&DEid="+document.#Attributes.form#.DEid#index#.value;
			} else {
				alert('Falta parámetro de Empleado')
			}
			</cfoutput>
		} 
		else {
			ClearBeneficioEmpleado<cfoutput>#index#</cfoutput>();
		}
		return true;
	}
</script>

<cfoutput>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<input type="hidden" name="BElinea#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.BElinea#index#")>#Evaluate("Attributes.query.BElinea#index#")#</cfif>">
				<input type="text"
					name="Bcodigo#index#" id="Bcodigo#index#"
					value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Bcodigo#index#")>#Evaluate("Attributes.query.Bcodigo#index#")#</cfif>"
					maxlength="4"
					size="4"
					onblur="javascript: TraeBeneficioEmpleado#index#(document.#Attributes.form#.Bcodigo#index#.value);">
			</td>
			<td nowrap>
				<input type="text"
					name="Bdescripcion#index#" id="Bdescripcion#index#"
					tabindex="-1"
					value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Bdescripcion#index#")>#Evaluate("Attributes.query.Bdescripcion#index#")#</cfif>" 
					maxlength="80"
					size="#Attributes.size#"
					readonly="true">
				<a href="javascript: doConlisBeneficiosEmp#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Tipos de Acciones" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
			</td>
		</tr>
	</table>
</cfoutput>

<cfif not isdefined("Request.BeneficioEmpTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	<cfset Request.BeneficioEmpTag = True>
</cfif>
