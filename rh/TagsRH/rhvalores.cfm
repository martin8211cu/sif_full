<!---
<cfquery name="def" datasource="asp">
	select 1 as dato
</cfquery>--->
<cfset def = QueryNew("dato")>

<cfparam name="Attributes.encabezado" default="true" type="boolean"> <!--- Indica si se va a pintar el encabezado o el detalle de los valores --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRValor" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Empleado --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
	<cfif Attributes.Encabezado>
	function doConlis_ValoresE<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		<cfoutput>
			var nuevo = window.open('/cfmx/rh/Utiles/ConlisValoresE.cfm?f=#Attributes.form#&p1=RHECGid#index#&p2=RHECGcodigo#index#&p3=RHECGdescripcion#index#','ListaValores','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#index#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlis_ValoresE<cfoutput>#index#</cfoutput>();
		}
	}
	
	function ResetValorE<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.RHECGid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHECGcodigo#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHECGdescripcion#index#</cfoutput>.value = "";
		ResetValorD<cfoutput>#index#</cfoutput>();
	}

	function TraeValorE<cfoutput>#index#</cfoutput>(Cod) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.RHECGid<cfoutput>#index#</cfoutput>;
		window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.RHECGcodigo<cfoutput>#index#</cfoutput>;
		window.ctldesc = document.<cfoutput>#Attributes.form#</cfoutput>.RHECGdescripcion<cfoutput>#index#</cfoutput>;
		window.ctlidd = document.<cfoutput>#Attributes.form#</cfoutput>.RHDCGid<cfoutput>#index#</cfoutput>;
		window.ctlcodd = document.<cfoutput>#Attributes.form#</cfoutput>.RHDCGcodigo<cfoutput>#index#</cfoutput>;
		window.ctldescd = document.<cfoutput>#Attributes.form#</cfoutput>.RHDCGdescripcion<cfoutput>#index#</cfoutput>;

		if (document.<cfoutput>#Attributes.form#.RHECGcodigo#index#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhvaloresequery.cfm?codigo="+Cod;
		} else {
			ResetValorE<cfoutput>#index#</cfoutput>();
		}
		return true;
	}
	<cfelse>
	function doConlis_ValoresD<cfoutput>#index#</cfoutput>(code) {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		if (document.<cfoutput>#Attributes.form#.RHECGcodigo#index#</cfoutput> && document.<cfoutput>#Attributes.form#.RHECGcodigo#index#</cfoutput>.value != "") {
		<cfoutput>
			var nuevo = window.open('/cfmx/rh/Utiles/ConlisValoresD.cfm?f=#Attributes.form#&p1=RHDCGid#index#&p2=RHDCGcodigo#index#&p3=RHDCGdescripcion#index#&code='+code,'ListaValores','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		
		nuevo.focus();
		}
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#index#</cfoutput>D(e,code) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlis_ValoresD<cfoutput>#index#</cfoutput>(code);
		}
	}
	
	function ResetValorD<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.RHDCGid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHDCGcodigo#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHDCGdescripcion#index#</cfoutput>.value = "";
	}

	function TraeValorD<cfoutput>#index#</cfoutput>(code, cod) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.RHDCGid<cfoutput>#index#</cfoutput>;
		window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.RHDCGcodigo<cfoutput>#index#</cfoutput>;
		window.ctldesc = document.<cfoutput>#Attributes.form#</cfoutput>.RHDCGdescripcion<cfoutput>#index#</cfoutput>;
		if (document.<cfoutput>#Attributes.form#.RHECGcodigo#index#</cfoutput> && document.<cfoutput>#Attributes.form#.RHECGcodigo#index#</cfoutput>.value != "") {
			if (document.<cfoutput>#Attributes.form#.RHDCGcodigo#index#</cfoutput>.value != "") {
				var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
				fr.src = "/cfmx/rh/Utiles/rhvaloresdquery.cfm?codigo="+cod+"&codigoe="+code;
			} else {
				ResetValorD<cfoutput>#index#</cfoutput>();
			}
		}
		return true;
	}	
	</cfif>
</script>

<cfoutput>
<cfif Attributes.Encabezado>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="hidden" name="RHECGid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHECGid#index#")>#Evaluate("Attributes.query.RHECGid#index#")#</cfif>">
			<input type="text"
				name="RHECGcodigo#index#" id="RHECGcodigo#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHECGcodigo#index#")>#Evaluate('Attributes.query.RHECGcodigo#index#')#</cfif>"
				onblur="javascript: TraeValorE#index#(document.#Attributes.form#.RHECGcodigo#index#.value);"
				onchange="javascript: ResetValorD#index#();"
				onkeyup="javascript:conlis_keyup_#index#(event);"
				<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>
				maxlength="10"
				size="10">
		</td>
	    <td>
			<input type="text"
				name="RHECGdescripcion#index#" id="RHECGdescripcion#index#"
				tabindex="-1"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHECGdescripcion#index#")>#Evaluate("Attributes.query.RHECGdescripcion#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly='true'>
			<a href="javascript: doConlis_ValoresE#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Valores" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
		</td>
	</tr>
</table>
<cfelse>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="hidden" name="RHDCGid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHDCGid#index#")>#Evaluate("Attributes.query.RHDCGid#index#")#</cfif>">
			<input type="text"
				name="RHDCGcodigo#index#" id="RHDCGcodigo#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHDCGcodigo#index#")>#Evaluate('Attributes.query.RHDCGcodigo#index#')#</cfif>"
				onkeyup="javascript:conlis_keyup_#index#D(event,document.#Attributes.form#.RHECGid#index#.value);"
				onblur="javascript: TraeValorD#index#(document.#Attributes.form#.RHECGid#index#.value, document.#Attributes.form#.RHDCGcodigo#index#.value);"
				<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>
				maxlength="10"
				size="10">
		</td>
	    <td>
			<input type="text"
				name="RHDCGdescripcion#index#" id="RHDCGdescripcion#index#"
				tabindex="-1"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHDCGdescripcion#index#")>#Evaluate("Attributes.query.RHDCGdescripcion#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly='true'>
			<a href="javascript: doConlis_ValoresD#index#(document.#Attributes.form#.RHECGid#index#.value);" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Valores" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
		</td>
	</tr>
</table>
</cfif>
</cfoutput>
<cfif not isdefined("Request.ValorTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	<cfset Request.ValorTag = True>
</cfif>
