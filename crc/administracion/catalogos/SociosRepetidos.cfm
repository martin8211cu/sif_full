<cfinclude template="SociosModalidad.cfm">


<cftry>

<cfparam name="url.SNcodigo" default="">
<cfparam name="url.SNnumero" default="">

<cfif len(url.SNnumero)>
	<cfquery datasource="#session.dsn#" name="dup">
		select SNnombre
		from SNegocios
		where SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  <cfif Len(url.SNcodigo)>
		    and SNcodigo <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
		  </cfif>
	</cfquery>
	<cfif dup.RecordCount>
		<cfoutput>
		<script type="text/javascript">
			parent.document.getElementById('SNnumeroOK').value=false;
			alert("El numero #JSStringFormat(url.SNnumero)# está siendo utilizado por el cliente #dup.SNnombre#");
		</script>
		</cfoutput>
	<cfelse>
		<script type="text/javascript">
			parent.document.getElementById('SNnumeroOK').value=true;
		</script>
	</cfif>
</cfif>

<cfparam name="url.SNidentificacion" default="">
<cfif len(url.SNidentificacion)>
	<cfquery datasource="#session.dsn#" name="dup">
		select SNnombre
		from SNegocios
		where SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNidentificacion#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  <cfif Len(url.SNcodigo)>
		    and SNcodigo <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
		  </cfif>
	</cfquery>
	
	<cfif dup.RecordCount>
		<cfoutput>
		<script type="text/javascript">
			alert("La identificacion #JSStringFormat(url.SNidentificacion)# está siendo utilizado por el cliente #dup.SNnombre#");
		</script>
		</cfoutput>
	</cfif>
</cfif>

<cfcatch type="any">
<cfoutput>
	<script type="text/javascript">
		alert("Error validando numero: #JSStringFormat(cfcatch.Message)# - #JSStringFormat(cfcatch.Detail)#");
	</script>
</cfoutput>
</cfcatch>

</cftry>
