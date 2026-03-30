<cfif NOT isdefined("request.localeChange")>
	<cfinclude template="/aspAdmin/Componentes/LocaleFunctions.cfm">
</cfif>
<cfdump var="#url#">
<cfoutput>
<script language="JavaScript">
	if (parent != window)
	{
	<cfloop index="Campo" list="#url.Campos#" delimiters="|">
		<cfset LvarCampo = ListToArray(Campo)>
		<cfset LvarLOCnombre = LvarCampo[1]>
		<cfset LvarName = LvarCampo[2]>
		<cfset LvarObligatorio = LvarCampo[3]>
		<cfset Request.fnLocaleConcept(LvarLOCnombre,url.Ppais,url.Icodigo)>
		<cfset LvarLOCtipo = rsLocaleConcept.LOCtipo>
		<cfset LvarLocEtiqueta = rsLocaleConcept.LOCetiqueta>
		var parentText  = parent.document.getElementById("#LvarName#");
		var parentCombo = parent.document.getElementById("locCbo__#LvarName#");
		var parentLabel = parent.document.getElementById("locLblC__#LvarName#");
		while (parentCombo.length > 0)
			parentCombo.remove(0);
		<cfif LvarLOCtipo EQ "N" or LvarLOCtipo EQ "V">
			parentText.style.display = "";
			parentCombo.style.display = "none";
		<cfelseif LvarLOCtipo EQ "E">
			parentText.style.display = "none";
			parentCombo.style.display = "none";
		<cfelse>
			var newOption;
			<cfif LvarObligatorio EQ "1">
				newOption = document.createElement("OPTION"); newOption.value = ""; newOption.text = "[Escoger un valor]"; parentCombo.add (newOption);
			<cfelse>
				newOption = document.createElement("OPTION"); newOption.value = ""; newOption.text = ""; parentCombo.add (newOption);
			</cfif>
			<cfloop query="rsLocaleConcept">
				newOption = document.createElement("OPTION"); newOption.value = "#rsLocaleConcept.LOVvalor#"; newOption.text = "#rsLocaleConcept.LOVdescripcion#"; parentCombo.add (newOption); if (newOption.value == parentText.value) newOption.selected = true;
			</cfloop>
			parentText.style.display = "none";
			parentCombo.style.display = "";
		</cfif>
		if (parentLabel)
		{
			var parentLabelDfl = parent.document.locLblDflC__#LvarName#;
			var parentDiv = parent.document.getElementById("locDsp__#LvarName#");;
			<cfif LvarLOCtipo EQ "E">
			if (parentDiv)
				parentDiv.style.display = "none";
			parentLabel.style.display = "none";
			<cfelse>
			if (parentDiv)
				parentDiv.style.display = "";
			parentLabel.style.display = "";
			<cfif LvarLOCtipo EQ "N">
			var LvarTxt   = parent.document.createTextNode(parentLabelDfl);
			<cfelse>
			var LvarTxt   = parent.document.createTextNode("#LvarLocEtiqueta#");
			</cfif>
			parentLabel.replaceChild(LvarTxt,parentLabel.firstChild);
			</cfif>
		}
	</cfloop>
	}
</script>
</cfoutput>