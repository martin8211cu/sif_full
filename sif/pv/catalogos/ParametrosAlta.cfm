<!--- Alta de la FAP000 --->
<cfquery datasource="#session.dsn#">
	INSERT FAP000(CFcuenta, CFcuenta1, CFcuenta2,  BTid, Ecodigo,FAPTRANS, FAAUTOR, FACALIMP, FATIPORED, 
	PORMPRIM, MAXDESCP, NOMPROPV, MONMINADE, FAUNIRED, MONMPRIM, MONMINCR, 
	FAPIMPSU,  FAPFOPG, LBLIMP, FABNCSUG, AUTCAMPRE, AUTCAMDES, FAPAGAD,FAP00LANG,
	FAPVICOT, FAPVIAPA, FAPVINC, FAPVICR, FAPCLF, FAPDEMON, FPAGOMUL, 	
	FAGENERNC, FAPREVPRE, FAPBACO, FAPCDOF, FAPDOCPOR, FAPINTCXC, FAPINTDXC, 	
	FAPPASREI, FAPMULPG, FAPCOLBOD, FAPMONCHK, FAPMSIMP, FAPNCA, 
	BMUsucodigo, fechaallta)
	values(			
			
			<cfif isdefined("Form.CFcuenta") and Form.CFcuenta NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.CFcuenta#">,
			<cfelse>
				null,
			</cfif>
			
			<cfif isdefined("Form.CFcuenta1") and Form.CFcuenta1 NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.CFcuenta1#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("Form.CFcuenta2") and Form.CFcuenta2 NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.CFcuenta2#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("Form.BTid") and Form.BTid NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.BTid#">,
			<cfelse>
				null,
			</cfif>
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAPTRANS#">,
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAAUTOR#">,
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FACALIMP#">, 
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FATIPORED#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#form.PORMPRIM#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#form.MAXDESCP#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="x">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.MONMINADE#">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.FAUNIRED#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.MONMPRIM#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.MONMINCR#">,
			<cfif isdefined("Form.FAPIMPSU") and Form.FAPIMPSU NEQ "">
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.FAPIMPSU#">,
			<cfelse>
				null,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAPFOPG#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.LBLIMP#">, 			
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FABNCSUG#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.AUTCAMPRE#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.AUTCAMDES#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPAGAD#">,
			
			<cfif isdefined("Form.FAP00LANG") and Form.FAP00LANG NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_integer" value="#Form.FAP00LANG#">,
			<cfelse>
				null,
			</cfif>
			
			<cfif isdefined("Form.FAPVICOT") and Form.FAPVICOT NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_integer" value="#Form.FAPVICOT#">,
			<cfelse>
				null,
			</cfif>
			
			<cfif isdefined("Form.FAPVIAPA") and Form.FAPVIAPA NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_integer" value="#Form.FAPVIAPA#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("Form.FAPVINC") and Form.FAPVINC NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_integer" value="#Form.FAPVINC#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("Form.FAPVICR") and Form.FAPVICR NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_integer" value="#Form.FAPVICR#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("Form.FAPCLF") and Form.FAPCLF NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_integer" value="#Form.FAPCLF#">,
			<cfelse>
				null,
			</cfif>
<!--- Asi lo tenia Aaron
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FAP00LANG#">
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FAPVICOT#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FAPVIAPA#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FAPVINC#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FAPVICR#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FAPCLF#">,--->
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPDEMON#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FPAGOMUL#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAGENERNC#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPREVPRE#">,			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPBACO#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPCDOF#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPDOCPOR#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPINTCXC#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPINTDXC#">,			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPPASREI#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPMULPG#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPCOLBOD#">,			
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.FAPMONCHK#">,
			
			<cfif isdefined("Form.FAPMSIMP") and Form.FAPMSIMP NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_integer" value="#Form.FAPMSIMP#">,
			<cfelse>
				null,
			</cfif>
			<!---<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.FAPMSIMP#">,--->			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.FAPNCA#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
</cfquery>

<cflocation url="Parametros.cfm">