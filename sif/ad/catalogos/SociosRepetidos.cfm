<cfinclude template="SociosModalidad.cfm">
<cfoutput><#''#script type="text/javascript">
<!#''#--</cfoutput>
<cftry>

var f = window.parent.document.form;
<cfparam name="url.SNcodigo" default="">
<cfparam name="url.SNnumero" default="">
<cfif len(url.SNnumero)>
	<cfquery datasource="#session.dsn#" name="dup">
		select SNnombre
		from SNegocios
		where SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
		  and (Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  <cfif modalidad.modalidad and Len(session.EcodigoCorp) and (Session.Ecodigo Neq session.EcodigoCorp)>
			or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoCorp#">
		  </cfif>)
		  <cfif Len(url.SNcodigo)>
		  and not (Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		       and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">)
		  </cfif>
	</cfquery>
	
	<cfif dup.RecordCount>
		<cfoutput>
		alert("El numero #JSStringFormat(url.SNnumero)# está siendo utilizado por el cliente #dup.SNnombre#");
		f.SNnumero.value = "";
		</cfoutput>
	</cfif>
</cfif>

<cfparam name="url.SNidentificacion" default="">
<cfif len(url.SNidentificacion)>
	<cfquery datasource="#session.dsn#" name="dup">
		select SNnombre
		from SNegocios
		where SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNidentificacion#">
		  and (Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  <cfif modalidad.modalidad and Len(session.EcodigoCorp) and (Session.Ecodigo Neq session.EcodigoCorp)>
			or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoCorp#">
		  </cfif>)
		  <cfif Len(url.SNcodigo)>
		  and not (Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		       and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">)
		  </cfif>
	</cfquery>
	
	<cfif dup.RecordCount>
		<cfoutput>
		alert("La identificacion #JSStringFormat(url.SNidentificacion)# está siendo utilizado por el cliente #dup.SNnombre#");
		f.SNidentificacion.value = "";
		</cfoutput>
	</cfif>
</cfif>

<cfcatch type="any">
<cfoutput>
	alert("Error validando numero: #JSStringFormat(cfcatch.Message)# - #JSStringFormat(cfcatch.Detail)#");
</cfoutput>
</cfcatch>

</cftry>


//-->
</script>