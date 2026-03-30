
<cfset def = QueryNew("dato")>

<cfparam name="Attributes.tipo" type="numeric"> <!--- Tipo de Tabla (RHTTid) --->
<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis --->
<cfparam name="Attributes.id" default="RHVTid" type="string"> <!--- RHVTid --->
<cfparam name="Attributes.codigo" default="RHVTcodigo" type="string"> <!--- RHVTcodigo --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FR#Attributes.id#" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="20" type="numeric"> <!--- Tamaño del campo --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del campo --->

<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript">
	<cfif Attributes.Conlis>
	function doConlis<cfoutput>#Attributes.id#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
			var nuevo = window.open('/cfmx/rh/Utiles/ConlisVigenciasTablas.cfm?RHTTid=#Attributes.tipo#&f=#Attributes.form#&p1=#Attributes.id#&p2=#Attributes.codigo#','ListaVigencias','menu=no, scrollbars=yes, top=' + top + ',left=' + left + ',width=' + width + ',height=' + height);
		</cfoutput>
		nuevo.focus();
	}
	
	function Reset<cfoutput>#Attributes.id#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.#Attributes.id#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.#Attributes.codigo#</cfoutput>.value = "";
	}
	</cfif>

	function Trae<cfoutput>#Attributes.id#</cfoutput>(codigo) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.id#</cfoutput>;
		window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.codigo#</cfoutput>;
		if (document.<cfoutput>#Attributes.form#.#Attributes.codigo#</cfoutput>.value != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			<cfoutput>
			fr.src = "/cfmx/rh/Utiles/rhvigentabquery.cfm?tipo=#Attributes.tipo#&codigo="+codigo;
			</cfoutput>
		} else {
			Reset<cfoutput>#Attributes.id#</cfoutput>();
		}
		return true;
	}
</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="hidden" name="#Attributes.id#" id="#Attributes.id#"
			value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.#Attributes.id#")>#Evaluate('Attributes.query.#Attributes.id#')#</cfif>">
			<input type="text"
				name="#Attributes.codigo#" id="#Attributes.codigo#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.#Attributes.codigo#")>#Evaluate('Attributes.query.#Attributes.codigo#')#</cfif>"
				onblur="javascript: Trae#Attributes.id#(document.#Attributes.form#.#Attributes.codigo#.value);"
				onKeyPress="return acceptNum(event)" 
				onFocus="javascript:this.select();"
				maxlength="10"
				size="#Attributes.size#"
				tabindex="<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>#Attributes.tabindex#</cfif>">
			<cfif Attributes.Conlis><a href="javascript: doConlis#Attributes.id#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Vigencias" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
		</td>
	</tr>
</table>
</cfoutput>
<cfif not isdefined("Request.VigenTabTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	<cfset Request.VigenTabTag = True>
</cfif>
