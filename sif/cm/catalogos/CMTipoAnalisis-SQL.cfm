<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">						
			insert into CMTipoAnalisis(Ecodigo,CMTdesc,CMTentregaefec,CMTgestiorec,CMTeestiorecp,CMTefecentrega,fechaalta, BMUsucodigo)
				values(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CMTdesc#">,
						<cfif isdefined("form.CMTentregaefec") and len(trim(form.CMTentregaefec))><cfqueryparam cfsqltype="cf_sql_float" value="#Form.CMTentregaefec#"><cfelse>0.00</cfif>,
						<cfif isdefined("form.CMTgestiorec") and len(trim(form.CMTgestiorec))><cfqueryparam cfsqltype="cf_sql_float" value="#Form.CMTgestiorec#"><cfelse>0.00</cfif>,
						<cfif isdefined("form.CMTeestiorecp") and len(trim(form.CMTeestiorecp))><cfqueryparam cfsqltype="cf_sql_float" value="#Form.CMTeestiorecp#"><cfelse>0.00</cfif>,
						0.00,
						<!---<cfif isdefined("form.CMTefecentrega") and len(trim(form.CMTefecentrega))><cfqueryparam cfsqltype="cf_sql_float" value="#Form.CMTefecentrega#"><cfelse>0.00</cfif>,---->						
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)			
		</cfquery>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from CMTipoAnalisis
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CMTid = <cfqueryparam value="#Form.CMTid#" cfsqltype="cf_sql_numeric">
		</cfquery>  
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="CMTipoAnalisis"
			 			redirect="CMTipoAnalisis.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="CMTid" 
						type2="numeric" 
						value2="#trim(form.CMTid)#">					
		<cfquery name="update" datasource="#Session.DSN#">
			update CMTipoAnalisis 
			set CMTdesc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CMTdesc#">,
				CMTentregaefec=<cfif isdefined("form.CMTentregaefec") and len(trim(form.CMTentregaefec))><cfqueryparam cfsqltype="cf_sql_float" value="#Form.CMTentregaefec#"><cfelse>0.00</cfif>,
				CMTgestiorec=<cfif isdefined("form.CMTgestiorec") and len(trim(form.CMTgestiorec))><cfqueryparam cfsqltype="cf_sql_float" value="#Form.CMTgestiorec#"><cfelse>0.00</cfif>,
				CMTeestiorecp=<cfif isdefined("form.CMTeestiorecp") and len(trim(form.CMTeestiorecp))><cfqueryparam cfsqltype="cf_sql_float" value="#Form.CMTeestiorecp#"><cfelse>0.00</cfif>,
				CMTefecentrega=0.00
				<!---CMTEfecEntraga=<cfif isdefined("form.CMTEfecEntraga") and len(trim(form.CMTEfecEntraga))><cfqueryparam cfsqltype="cf_sql_float" value="#Form.CMTEfecEntraga#"><cfelse>0.00</cfif>---->
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CMTid =  <cfqueryparam value="#Form.CMTid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="CMTipoAnalisis.cfm" method="post" name="sql">
	<cfif isdefined("form.Cambio")>
		<input name="CMTid" type="hidden" value="#Form.CMTid#">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>