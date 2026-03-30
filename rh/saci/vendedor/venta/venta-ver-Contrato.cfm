<cfif isdefined('url.CTid') and len(trim(url.CTid))>
	<!--- Login --->
	<cfquery name="rsLoginContrato" datasource="#session.dsn#">
		Select lo.LGlogin,p.Contratoid
		from ISBlogin lo
			inner join ISBproducto p
				on p.Contratoid = lo.Contratoid 
		where lo.Contratoid in (		
							select a.Contratoid
									from ISBproducto a
										inner join ISBpaquete b
											on b.PQcodigo = a.PQcodigo
												and b.Habilitado=1
									where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTid#">
										and CTcondicion not in ('C','X'))			
		and lo.LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.f_loginPrinc#">
	</cfquery>	
	
	<cfif isdefined('rsLoginContrato') and rsLoginContrato.recordCount GT 0>
		<script language="javascript" type="text/javascript">
			window.opener.document.form1.contrat.value = "<cfoutput>#rsLoginContrato.Contratoid#</cfoutput>";
		</script>
		<cf_formContrato id="#rsLoginContrato.Contratoid#" login="#url.f_loginPrinc#">
	<cfelse>
		<script language="javascript" type="text/javascript">
			alert("Error, el login '<cfoutput>#url.f_loginPrinc#</cfoutput>' digitado no existe en los paquetes de la cuenta.");
			this.window.close();
		</script>			
	</cfif>
<cfelse>
	<cfif isdefined('url.Contratoid') and url.Contratoid NEQ ''>
		<cf_formContrato id="#url.Contratoid#">
	<cfelse>
		<script language="javascript" type="text/javascript">
			alert('Error, debe enviar el id de la cuenta');
			this.window.close();
		</script>
	</cfif>				
</cfif>	


