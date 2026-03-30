 <cfif IsDefined("form.Cambio")>
 
		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAM021"
				redirect="vendedores.cfm"
				timestamp="#form.ts_rversion#"
				field1="FAX04CVD"
				type1="integer"
				value1="#form.FAX04CVD#">
				
					
	<cfquery name="update" datasource="#session.DSN#">
		update FAM021
		set			
			DEid 		= <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">,
			<!--- Usucodigo = <cfqueryparam value="##" cfsqltype="cf_sql_numeric">,			 --->
			CFid 		= <cfqueryparam value="#CFid#" cfsqltype="cf_sql_numeric">,
			FAM21NOM	= <cfqueryparam value="#FAM21NOM#" cfsqltype="cf_sql_varchar">,
			FAM21PUE	= <cfqueryparam value="#FAM21PUE#" cfsqltype="cf_sql_varchar">,
			<cfif isdefined('form.FAM21PAD') and form.FAM21PAD NEQ ''>
				FAM21PAD = 1,
			<cfelse>
				FAM21PAD = 0,
			</cfif>			
			<cfif isdefined('form.FAM21PCP') and form.FAM21PCP NEQ ''>
				FAM21PCP = 1,
			<cfelse>
				FAM21PCP = 0,
			</cfif>
			FAM21PCO	= <cfqueryparam value="#FAM21PCO#" cfsqltype="cf_sql_money">,
			FAM21CDI	= <cfqueryparam value="#FAM21CDI#" cfsqltype="cf_sql_smallint">,
			FAM21CED	= <cfqueryparam value="#FAM21CED#" cfsqltype="cf_sql_varchar">,
			FAM21SUP	= <cfqueryparam value="#FAM21SUP#" cfsqltype="cf_sql_varchar">,	
			BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	      and FAX04CVD = <cfqueryparam value="#form.FAX04CVD#" cfsqltype= "cf_sql_varchar">
		
	</cfquery> 

	<cflocation url="vendedores.cfm?FAX04CVD=#form.FAX04CVD#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete FAM021
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAX04CVD = <cfqueryparam value="#form.FAX04CVD#" cfsqltype= "cf_sql_varchar">
	</cfquery>
 	
	<!--- suma 1 al max de cod identity char --->
	<cfelseif IsDefined("form.Alta")>

		<cfquery datasource="#session.dsn#">
		   insert into FAM021 ( Ecodigo,  FAX04CVD, DEid,     Usucodigo, CFid,    FAM21NOM,   
		   						FAM21PSW, FAM21PUE, FAM21PAD, FAM21PCP,  FAM21PCO,FAM21CDI, 
								FAM21CED, FAM21SUP, BMUsucodigo, fechaalta)
		   values(	
		   		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAX04CVD#">,
			    <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21NOM#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21PUE#">,
				<cfqueryparam cfsqltype= "cf_sql_bit" value="#form.FAM21PAD#">,
				<cfqueryparam cfsqltype= "cf_sql_bit" value="#form.FAM21PCP#">,
				<cfqueryparam cfsqltype= "cf_sql_money" value="#form.FAM21PCO#">,
				<cfqueryparam cfsqltype= "cf_sql_smallint" value="#form.FAM21CDI#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21CED#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21SUP#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
		</cfquery>
	
</cfif>

<cflocation url="vendedores.cfm">