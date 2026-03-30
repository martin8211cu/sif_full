<cfif IsDefined("form.CambioD")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM019"
		redirect="comisiones_banc.cfm"
		timestamp="#form.ts_rversion#"
			
		field1="FAM19LIN"
		type1="numeric"
		value1="#form.FAM19LIN#" 
				
		field2="Bid"
		type2="numeric"
		value2="#form.Bid#" >
						
	<cfquery name="update" datasource="#session.DSN#">
		update FAM019 set
		FAM19INF = <cfqueryparam value="#Form.FAM19INF#" cfsqltype="cf_sql_money">,
		FAM19SUP = <cfqueryparam value="#Form.FAM19SUP#" cfsqltype="cf_sql_money">,
		FAM19MON = <cfqueryparam value="#Form.FAM19MON#" cfsqltype="cf_sql_money">,
		FAM19PRI = <cfqueryparam value="#Form.FAM19PRI#" cfsqltype="cf_sql_money">,
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM19LIN = <cfqueryparam value="#form.FAM19LIN#" cfsqltype="cf_sql_numeric">
		and Bid = <cfqueryparam value="#form.Bid#" cfsqltype="cf_sql_numeric">
	</cfquery> 
	
<cfelseif IsDefined("form.BajaD")>
	<cfquery datasource="#session.dsn#">
      delete from FAM019
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM19LIN = <cfqueryparam value="#form.FAM19LIN#" cfsqltype="cf_sql_numeric">
		and Bid = <cfqueryparam value="#form.Bid#" cfsqltype="cf_sql_numeric">
	</cfquery>
 	
<cfelseif IsDefined("form.AltaD")>
	<cfquery datasource="#session.dsn#">
		insert into FAM019( Ecodigo, Bid, FAM19INF, FAM19SUP, FAM19MON, FAM19PRI, BMUsucodigo, fechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Bid#">, 
		        <cfqueryparam cfsqltype="cf_sql_money" value="#form.FAM19INF#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.FAM19SUP#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.FAM19MON#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.FAM19PRI#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
</cfif>

<form action="bancos.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.CambioD')>
			<input name="FAM19LIN" type="hidden" value="#form.FAM19LIN#">	
		</cfif>
		
		<input name="Bid" type="hidden" value="#form.Bid#"> 
		
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
