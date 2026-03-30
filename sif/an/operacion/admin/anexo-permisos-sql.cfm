<cfinclude template="anexo-validar-permiso.cfm">
<cfset modoPermisos = "ALTA">
<cfif not isdefined("Form.NuevoPerm")>
	<cfif isdefined("Form.AltaPerm")>		 
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into AnexoPermisoDef(Ecodigo, Usucodigo, APnombre,APemail, GAid, AnexoId, APver, APedit, APcalc, APdist, APrecip,BMfecha,BMUsucodigo)
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfif isdefined("form.Usucodigo1") and len(trim(form.Usucodigo1))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo1#"><cfelse>null</cfif>,
					<cfif isdefined("form.APnombre") and len(trim(form.APnombre))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.APnombre#"><cfelse>null</cfif>,
					<cfif isdefined("form.APemail") and len(trim(form.APemail))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.APemail#"><cfelse>null</cfif>,
					null,
					<cfif isdefined("form.AnexoId") and len(trim(form.AnexoId))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#"><cfelse>null</cfif>,
					<cfif isdefined("form.APver")>1<cfelse>0</cfif>,
					<cfif isdefined("form.APedit")>1<cfelse>0</cfif>,
					<cfif isdefined("form.APcalc")>1<cfelse>0</cfif>,
					<cfif isdefined("form.APdist")>1<cfelse>0</cfif>,
					<cfif isdefined("form.APrecip")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					)
		</cfquery>
		<cfset modoPermisos="ALTA">
		
	<cfelseif isdefined("Form.BajaPerm")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from AnexoPermisoDef
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and APDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.APDid#">
		</cfquery>  
		<cfset modoPermisos="ALTA">

	<cfelseif isdefined("Form.CambioPerm")>			
		<cf_dbtimestamp datasource="#session.dsn#"
						table="AnexoPermisoDef"
						redirect="anexo.cfm"
						timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="APDid" 
						type2="numeric" 
						value2="#form.APDid#"
		>			
		<cfquery name="update" datasource="#Session.DSN#">
			update AnexoPermisoDef
			set APnombre = <cfif isdefined("form.APnombre") and len(trim(form.APnombre))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.APnombre#"><cfelse>null</cfif>, 
				APemail = <cfif isdefined("form.APemail") and len(trim(form.APemail))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.APemail#"><cfelse>null</cfif>,	
				APver = <cfif isdefined("form.APver")>1<cfelse>0</cfif>,
				APedit = <cfif isdefined("form.APedit")>1<cfelse>0</cfif>,
				APcalc = <cfif isdefined("form.APcalc")>1<cfelse>0</cfif>,
				APdist = <cfif isdefined("form.APdist")>1<cfelse>0</cfif>,
				APrecip = <cfif isdefined("form.APrecip")>1<cfelse>0</cfif>,
				Usucodigo = <cfif isdefined("form.Usucodigo1") and len(trim(form.Usucodigo1))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo1#"><cfelse>null</cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and APDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.APDid#">
		</cfquery>
		<cfset modoPermisos="CAMBIO">
	</cfif>
</cfif>
<cfoutput>
<form action="anexo.cfm?AnexoId=#form.AnexoId#&tab=3" method="post" name="sqlCurProgram">
	<input name="AnexoId" type="hidden" value="#form.AnexoId#">
	<input type="hidden" name="tab" value="3">
	<cfif isdefined("form.CambioPerm")>
		<input name="APDid" type="hidden" value="#form.APDid#">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
