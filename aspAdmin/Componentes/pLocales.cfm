<cfquery name="rsLocaleTipo" datasource="#session.DSN#">
	select LOCtipo
	  from LocaleConcepto2
	 where LOCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.LOCcodigo#">
</cfquery>
<cfquery name="rsLocale" datasource="#session.DSN#">
	<cfif rsLocaleTipo.LOCtipo EQ "P">
		<cfif isdefined("url.cambio") AND url.Ppais NEQ url.PpaisOriginal>
		  <cfset url.value = "">
		</cfif>
	<!---
	Tipo de Locale Pais, cada país tiene una tabla propia de valores, y por lo menos debe estar en español
	Se sigue la siguiente prioridad de busqueda: 
			1-Pais+Idioma+Dialecto, 
			2-Pais+Idioma, 
			3-Pais+Español
	--->
		  if exists(select 1 from LocaleValores2
			 where LOCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.LOCcodigo#">
			   and Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ppais#">
			   and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Icodigo#">)
			select LOCvalor, LOCdescripcion, LOCsecuencia
			  from LocaleValores2
			 where LOCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.LOCcodigo#">
			   and Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ppais#">
			   and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Icodigo#">
		  else
			select LOCvalor, LOCdescripcion, LOCsecuencia
			  from LocaleValores2
			 where LOCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.LOCcodigo#">
			   and Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ppais#">
			   and Icodigo = 'es'
	<cfelse>
	<!---
	Tipo de Locale Idioma, son los mismos valores con diferentes traducciones por Idioma + Pais + Dialecto
	Se sigue la siguiente prioridad de busqueda: 
			1-Idioma+Pais+Dialecto, 
			2-Idioma+Pais, 
			3-Idioma, 
			4-Español
	--->
		  if exists(select 1 from LocaleValores2
			 where LOCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.LOCcodigo#">
			   and Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ppais#">
			   and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Icodigo#">)
			select LOCvalor, LOCdescripcion, LOCsecuencia
			  from LocaleValores2
			 where LOCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.LOCcodigo#">
			   and Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ppais#">
			   and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Icodigo#">
		  else
		  if exists(select 1 from LocaleValores2
			 where LOCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.LOCcodigo#">
			   and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Icodigo#">)
			select LOCvalor, LOCdescripcion, LOCsecuencia
			  from LocaleValores2
			 where LOCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.LOCcodigo#">
			   and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Icodigo#">
		  else
			select LOCvalor, LOCdescripcion, LOCsecuencia
			  from LocaleValores2
			 where LOCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.LOCcodigo#">
			   and Icodigo = 'es'
	</cfif>
</cfquery>
<cfoutput>
<script language="JavaScript">
	if (parent != window)
	{
		var parentText  = parent.document.getElementById("#url.name#");
		var parentCombo = parent.document.getElementById("cbo__#url.name#");
		var parentLabel = parent.document.getElementById("lbl__#url.name#");
		parentText.value = "#url.value#";
		while (parentCombo.length > 0)
			parentCombo.remove(0);
	<cfset LvarLabel = "">
	<cfif rsLocale.recordCount EQ 0>
		parentText.style.display = "";
		parentCombo.style.display = "none";
	<cfelse>
		var newOption;
		<cfif url.obligatorio EQ "1">
		newOption = document.createElement("OPTION"); newOption.value = ""; newOption.text = "[Escoger un valor]"; parentCombo.add (newOption);
		<cfelse>
		newOption = document.createElement("OPTION"); newOption.value = ""; newOption.text = ""; parentCombo.add (newOption);
		</cfif>
		<cfloop query="rsLocale">
			<cfif rsLocale.LOCsecuencia EQ 0>
				<cfset LvarLabel = rsLocale.LOCdescripcion>
			<cfelse>
		newOption = document.createElement("OPTION"); newOption.value = "#rsLocale.LOCvalor#"; newOption.text = "#rsLocale.LOCdescripcion#"; ; parentCombo.add (newOption);
				<cfif rsLocale.LOCvalor EQ url.value>
		newOption.selected = true;	
				</cfif>
			</cfif>
		</cfloop>
		parentText.style.display = "none";
		parentCombo.style.display = "";
	</cfif>
	<cfif LvarLabel EQ "" AND isdefined("url.lblOriginal")>
		<cfset LvarLabel = url.lblOriginal>
	</cfif>
	<cfif LvarLabel NEQ "">
		if (parentLabel)
		{
			var LvarTxt   = parent.document.createTextNode("#LvarLabel#");
			parentLabel.replaceChild(LvarTxt,parentLabel.firstChild);
		}
	</cfif>
	}
</script>
</cfoutput>