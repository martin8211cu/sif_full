<!--- <cf_dump var="#form#"> --->
<cfset modo = "CAMBIO">
<cfset modoC = "ALTA">
<cfif isdefined("form.snRLegal") >
	<cfset snRepresentaL = 1>
<cfelse>	
	<cfset snRepresentaL = 0>
</cfif>

<cftransaction>
<cfif not isdefined("Form.NuevoContacto")>
	<cfif isdefined("Form.ALTAContacto")>
		<cfquery name="RsinsSNContactos" datasource="#Session.DSN#">		
			insert into SNContactos (Ecodigo, SNcodigo, SNCidentificacion, SNCnombre, 
				SNCdireccion, SNCtelefono, SNCfax, SNCemail, SNCfecha, SNCarea,SNRepresentanteLegal )
			values (
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNCidentificacion#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCnombre#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCdireccion#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCtelefono#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCFax#">, 
				 <cfif isdefined('Form.SNCemail') and Form.SNCemail NEQ ''>
				 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCemail#">,
				 <cfelse>
				 	null,
				 </cfif>
				<cfqueryparam value="#LSParseDateTime(form.SNCfecha)#" cfsqltype="cf_sql_timestamp">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.SNCarea#" voidnull>,
				#snRepresentaL#
			)
		</cfquery>			 
		
		<cfset modo="ALTA">
		<cfset modoC="ALTA">
	<cfelseif isdefined("Form.BajaContacto")>
		<cfquery name="SNegocios" datasource="#Session.DSN#">		
			delete from SNContactos
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			  and SNCcodigo = <cfqueryparam value="#Form.SNCcodigolista#" cfsqltype="cf_sql_numeric">
		</cfquery>			  
		
		<cfset modo="ALTA">
		<cfset modoC="ALTA">
	<cfelseif isdefined("Form.CambioContacto")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="SNContactos"
							redirect="listaSocios.cfm"
							timestamp="#form.ts_rversion#"
							field1="SNcodigo" 
							type1="integer" 
							value1="#form.SNcodigo#"
							field2="SNCcodigo" 
							type2="numeric" 
							value2="#form.SNCcodigolista#"							
							field3="Ecodigo" 
							type3="integer" 
							value3="#session.Ecodigo#" >		
			<cfquery name="SNegocios" datasource="#Session.DSN#">								
				update SNContactos  set 
					SNCidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNCidentificacion#">, 
					SNCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCnombre#">, 
					SNCdireccion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCdireccion#"> , 
					SNCtelefono =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCtelefono#"> , 
					SNCfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCfax#">, 
					 <cfif isdefined('Form.SNCemail') and Form.SNCemail NEQ ''>
						SNCemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCemail#">,
					 <cfelse>
						SNCemail=null,
					 </cfif>
                    SNCarea = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.SNCarea#" voidnull>,
					SNRepresentanteLegal = #snRepresentaL#
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
				  and SNCcodigo = <cfqueryparam value="#Form.SNCcodigolista#" cfsqltype="cf_sql_numeric">
			</cfquery>				  
		  <cfset modo="CAMBIO">
		  <cfset modoC="CAMBIO">
	</cfif>
</cfif>
</cftransaction>
<cfoutput>
	<form action="Socios.cfm" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="modoC" type="hidden" value="<cfif isdefined("modoC")>#modoC#</cfif>">
		<input name="SNcodigo" type="hidden" value="<cfif isdefined("Form.SNcodigo")>#Form.SNcodigo#</cfif>">
		<input name="SNCcodigo" type="hidden" value="<cfif isdefined("Form.SNCcodigo")>#Form.SNCcodigo#</cfif>">
		<input name="SNCcodigolista" type="hidden" value="<cfif modoC NEQ 'ALTA' and isdefined("Form.SNCcodigolista")>#Form.SNCcodigolista#</cfif>">
		<input name="tab" type="hidden" value="4">
		<!--- <cfif modo neq 'ALTA'>
			
			<input name="SNCcodigo" type="hidden" value="<cfif isdefined("Form.SNCcodigo")><cfoutput>#Form.SNCcodigo#</cfoutput></cfif>">
		</cfif>	 --->
		<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">		
	</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

