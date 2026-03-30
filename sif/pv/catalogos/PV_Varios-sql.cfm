 <cfif IsDefined("form.Cambio")>
 
		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAP000"
				redirect="Parametros.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo"
				type1="integer"
				value1="#Session.Ecodigo#">
				
					
	<cfquery name="update" datasource="#session.DSN#">
	
		update FAP000 
		set
			FAGENERNC = <cfif isdefined("Form.FAGENERNC")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPREVPRE = <cfif isdefined("Form.FAPREVPRE")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			AUTCAMPRE = <cfif isdefined("Form.AUTCAMPRE")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPAGAD	  = <cfif isdefined("Form.FAPAGAD")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			AUTCAMDES = <cfif isdefined("Form.AUTCAMDES")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPDEMON  = <cfif isdefined("Form.FAPDEMON")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPBACO   = <cfif isdefined("Form.FAPBACO")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPCDOF   = <cfif isdefined("Form.FAPCDOF")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPPASREI = <cfif isdefined("Form.FAPPASREI")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPINTCXC = <cfif isdefined("Form.FAPINTCXC")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FPAGOMUL  = <cfif isdefined("Form.FPAGOMUL")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPINTDXC = <cfif isdefined("Form.FAPINTDXC")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPDOCPOR = <cfif isdefined("Form.FAPDOCPOR")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPCOLBOD = <cfif isdefined("Form.FAPCOLBOD")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPMULPG  = <cfif isdefined("Form.FAPMULPG")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FAPNCA    = <cfif isdefined("Form.FAPNCA")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			FABNCSUG  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FABNCSUG#">,
			FAPMSIMP  = <cfif isdefined("Form.FAPMSIMP")><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.FAPMSIMP#"><cfelse>null</cfif>
			<cfif isdefined("Form.BTid") and len(trim(form.BTid))>
				,BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">
				<cfelse> 
				,BTid = null
			</cfif>
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery> 

	<cflocation url="Parametros.cfm?o=2">

</cfif>