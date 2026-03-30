<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<cfset modo = "CAMBIO">
<cfset modoC = "ALTA">

<cftransaction>
<cfif not isdefined("Form.NuevoContactoD")>
	<cfif isdefined("Form.ALTAContactoD")>
		<cfquery name="RsinsSNContactos" datasource="#Session.DSN#">		
			insert into SNDContactos (id_direccion, Ecodigo, SNcodigo, SNCidentificacion, SNCnombre, 
				SNCdireccion, SNCtelefono, SNCfax, SNCemail, SNCfecha )
			values (
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">, 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNCDidentificacion#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDnombre#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDdireccion#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDtelefono#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDFax#">, 
				 <cfif isdefined('Form.SNCDemail') and Form.SNCDemail NEQ ''>
				 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDemail#">,
				 <cfelse>
				 	null,
				 </cfif>
				<cfqueryparam value="#LSParseDateTime(form.SNCDfecha)#" cfsqltype="cf_sql_timestamp">
			)
		</cfquery>			 
		
		<cfset modo="ALTA">
		<cfset modoC="ALTA">
	<cfelseif isdefined("Form.BajaContactoD")>
		<cfquery name="SNegocios" datasource="#Session.DSN#">		
			delete from SNDContactos
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			  and SNCcodigo = <cfqueryparam value="#Form.SNCcodigolista#" cfsqltype="cf_sql_numeric">
		</cfquery>			  
		
		<cfset modo="ALTA">
		<cfset modoC="ALTA">
	<cfelseif isdefined("Form.CambioContactoD")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="SNDContactos"
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
				update SNDContactos  set 
					SNCidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNCDidentificacion#">, 
					SNCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDnombre#">, 
					SNCdireccion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDdireccion#"> , 
					SNCtelefono =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDtelefono#"> , 
					SNCfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDfax#">, 
					 <cfif isdefined('Form.SNCDemail') and Form.SNCDemail NEQ ''>
						SNCemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDemail#">
					 <cfelse>
						SNCemail=null
					 </cfif>					
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
	<form action="SociosDirecciones_form.cfm" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="modoC" type="hidden" value="<cfif isdefined("modoC")>#modoC#</cfif>">
		<input name="SNcodigo" type="hidden" value="<cfif isdefined("Form.SNcodigo")>#Form.SNcodigo#</cfif>">
	  	<input type="hidden" name="id_direccion" value="#Form.id_direccion#"> 
		<input name="SNCcodigo" type="hidden" value="<cfif isdefined("Form.SNCcodigo")>#Form.SNCcodigo#</cfif>">
		<input name="SNCcodigolista" type="hidden" value="<cfif modoC NEQ 'ALTA' and isdefined("Form.SNCcodigolista")>#Form.SNCcodigolista#</cfif>">
		<input name="tab" type="hidden" value="8">
		<input name="tabs" type="hidden" value="4">
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

