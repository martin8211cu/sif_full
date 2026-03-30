<cfparam name="Attributes.Concepto"		type="string">
<cfparam name="Attributes.Name"			type="string">
<cfparam name="Attributes.Value"		type="string" 	Default="">
<cfparam name="Attributes.Pais"			type="string" 	Default="">
<cfparam name="Attributes.Idioma"		type="string" 	Default="">
<cfparam name="Attributes.Obligatorio"	type="boolean" 	Default="false">
<cfparam name="Attributes.ConCambio"	type="boolean" 	Default="false">

<cfif NOT isdefined("request.localeChange")>
	<cfinclude template="/aspAdmin/Componentes/LocaleFunctions.cfm">
</cfif>
<cfoutput>

<cfif Attributes.ConCambio>
	<cfset Request.fnLocaleChange(Attributes.Idioma)>
</cfif>
<cfset Request.fnLocaleConcept(Attributes.Concepto,Attributes.Pais,Attributes.Idioma)>

<cfset LvarLOCtipo = rsLocaleConcept.LOCtipo>
<cfset LvarLocEtiqueta = rsLocaleConcept.LOCetiqueta>
<cfif LvarLOCtipo EQ "N" or LvarLOCtipo EQ "V">
	<input name="#Attributes.Name#" type="text" value="#Attributes.Value#" size="10" maxlength="10">
	<select name="LocCbo__#Attributes.Name#" id="LocCbo__#Attributes.Name#" style="display:none;" onchange="javascript:this.form.#Attributes.Name#.value = this.value;"></select>
<cfelseif LvarLOCtipo EQ "E">
	<input type="text" name="#Attributes.Name#" value="#Attributes.Value#" size="10" maxlength="10" style="display:none;">
	<select name="LocCbo__#Attributes.Name#" id="LocCbo__#Attributes.Name#" style="display:none;" onchange="javascript:this.form.#Attributes.Name#.value = this.value;"></select>
<cfelse>
	<input type="text" name="#Attributes.Name#" value="#Attributes.Value#" size="10" maxlength="10" style="display:none;">
	<select name="LocCbo__#Attributes.Name#" id="LocCbo__#Attributes.Name#" onchange="javascript:this.form.#Attributes.Name#.value = this.value;">
		<option value=""><cfif Attributes.Obligatorio>[Escoja un valor]</cfif></option>
	<cfset LvarSelected = false>
	<cfloop query="rsLocaleConcept">
		<option value="#rsLocaleConcept.LOVvalor#"<cfif rsLocaleConcept.LOVvalor EQ Attributes.Value> selected<cfset LvarSelected = true></cfif>>#rsLocaleConcept.LOVdescripcion#</option>
	</cfloop>
	<cfif NOT LvarSelected and trim(Attributes.Value) NEQ "">
		<option value="" selected>[Escoja un valor para #Attributes.Value#]</option>
	</cfif>
	</select>
</cfif>
<script language="JavaScript">
<cfif LvarLOCtipo EQ "E">
	var LvarDiv = document.getElementById("locDsp__#Attributes.Name#");
	if (LvarDiv)
		LvarDiv.style.display = 'none';
	var LvarLbl = document.getElementById("locLblC__#Attributes.Name#");
	if (LvarLbl)
		LvarLbl.style.display = 'none';
<cfelseif LvarLOCtipo NEQ "N">
	var LvarConceptLabel = "#LvarLocEtiqueta#";
	var LvarLbl = document.getElementById("locLblC__#Attributes.Name#");
	if (LvarLbl)
		LvarLbl.replaceChild(document.createTextNode(LvarConceptLabel),LvarLbl.firstChild);
	else
		document.locLblValC__#Attributes.Name# = LvarConceptLabel;
</cfif>
<cfif Attributes.ConCambio>
	locVar__cambioPais = locVar__cambioPais + "|#Attributes.Concepto#,#Attributes.Name#,<cfif Attributes.Obligatorio>1<cfelse>0</cfif>";
</cfif>
</script>
</cfoutput>

