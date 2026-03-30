<cffunction  name="fnLocaleListConCambio" output="true">
	<cfargument name="name"      required="true" type="string">
	<cfargument name="value" 	 required="true" type="string">
	<cfargument name="Ppais"     required="true" type="string">
	<cfargument name="Icodigo"   required="true" type="string">
	<cfargument name="LOCcodigo" required="true" type="string">
	<cfargument name="obligatorio" required="true" type="boolean">
<cfoutput>
<cfif obligatorio><cfset obligatorio=1><cfelse><cfset obligatorio=0></cfif>
<input type="text" name="#name#" value="#value#">
<select name="cbo__#name#" id="cbo__#name#" style="display:none;" onchange="javascript:this.form.#name#.value = this.value;"></select>
<iframe name="ifr__#name#" id="ifr__#name#" style="display:none;" src="/cfmx/aspAdmin/Componentes/pLocales.cfm?Ppais=#Ppais#&Icodigo=#Icodigo#&LOCcodigo=#LOCcodigo#&name=#name#&value=#value#&obligatorio=#obligatorio#"></iframe>
<script language="JavaScript">
	var lbl__#name# ="";
	{
		var LvarLabel = document.getElementById("lbl__#name#");
		if (LvarLabel)
			lbl__#name# = LvarLabel.firstChild.nodeValue;
	}
	function #name#_cambioLocale (Ppais, Icodigo)
	{
		if (lbl__#name# == "")
		{
		}
		var LvarValue = document.getElementById("#name#").value;
		document.getElementById("ifr__#name#").src = "/cfmx/aspAdmin/Componentes/pLocales.cfm?Ppais="+Ppais+"&Icodigo="+Icodigo+"&LOCcodigo=#LOCcodigo#&name=#name#&value="+LvarValue+"&obligatorio=#obligatorio#&cambio&lblOriginal="+lbl__#name#+"&PpaisOriginal=#Ppais#";
	}
</script>
</cfoutput>
</cffunction>

