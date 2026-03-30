<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM018"
		redirect="bancos.cfm"
		timestamp="#form.ts_rversion#"
		field1="Bid"
		type1="integer"
		value1="#form.Bid#">
		
					
	<cfquery name="update" datasource="#session.DSN#">
		update FAM018 
			set			
				SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">,
				CCTcodigo = <cfqueryparam value="#Form.CCTcodigo#" cfsqltype="cf_sql_char">,			
				FAM18DES = <cfqueryparam value="#Form.FAM18DES#" cfsqltype="cf_sql_varchar">,
				<cfif isdefined('form.CFcuentaComision') and len(trim(form.CFcuentaComision))>
					CFcuentaComision = <cfqueryparam value="#Form.CFcuentaComision#" cfsqltype="cf_sql_numeric">,
				<cfelse>
					CFcuentaComision = null,
				</cfif>
				<cfif isdefined('form.Icodigo') and len(trim(form.Icodigo))>
					Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">,
				<cfelse>
					Icodigo = null,
				</cfif>
				BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				<cfif isdefined('form.id_direccionFact') and form.id_direccionFact NEQ '' and form.id_direccionFact NEQ '-1'>
					id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccionFact#">,
				<cfelse>
					id_direccionFact = null,
				</cfif>				
				<cfif isdefined('form.id_direccionEnvio') and form.id_direccionEnvio NEQ '' and form.id_direccionEnvio NEQ '-1'>
					id_direccionEnvio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccionEnvio#">
				<cfelse>
					id_direccionEnvio = null
				</cfif>				
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    	and Bid = <cfqueryparam value="#form.Bid#" cfsqltype= "cf_sql_numeric">
	</cfquery> 

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from FAM019
		where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		and Bid = <cfqueryparam value="#form.Bid#" cfsqltype="cf_sql_numeric">
				
		delete from FAM018
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  	and Bid = <cfqueryparam cfsqltype= "cf_sql_numeric" value="#form.Bid#">
	</cfquery>

<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FAM018 (Ecodigo,  Bid, SNcodigo, CCTcodigo, FAM18DES,
							CFcuentaComision, Icodigo, BMUsucodigo,  fechaalta,
							id_direccionFact,id_direccionEnvio)
		   values(	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype= "cf_sql_numeric" value="#form.Bid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#" >,				
					<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigo#">,
					<cfqueryparam cfsqltype="varchar" value="#form.FAM18DES#">,
					<cfif isdefined('form.CFcuentaComision') and form.CFcuentaComision NEQ ''> 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaComision#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.Icodigo') and form.Icodigo NEQ ''> 
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfif isdefined('form.id_direccionFact') and form.id_direccionFact NEQ '' and form.id_direccionFact NEQ '-1'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccionFact#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.id_direccionEnvio') and form.id_direccionEnvio NEQ '' and form.id_direccionEnvio NEQ '-1'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccionEnvio#">
					<cfelse>
						null
					</cfif>				
				)
	</cfquery>
</cfif>


<!--- invoca a la pantalla con los parametros correspodientes a cada  proceso--->
<form action="bancos.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') or isdefined('form.Alta') and isdefined('form.Bid') and form.Bid NEQ ''>
			<input name="Bid" type="hidden" value="#form.Bid#"> 	
		</cfif>

		<cfif isdefined('form.Bid_F') and len(trim(form.Bid_F))>
			<input type="hidden" name="Bid_F" value="#form.Bid_F#">	
		</cfif>
		<cfif isdefined('form.FAM18DES_F') and len(trim(form.FAM18DES_F))>
			<input type="hidden" name="FAM18DES_F" value="#form.FAM18DES_F#">	
		</cfif>			
	</cfoutput>
</form>


<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
