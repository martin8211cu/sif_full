 	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM001"
		redirect="apertura_cajas.cfm"
		timestamp="#form.ts_rversion#"
		field1="FAM01COD"
		type1="char"
		value1="#form.FAM01COD#">

	
	<cfquery name="DeterminaProc" datasource="#session.DSN#">
		select FAM01STP
		from FAM001
		where FAM01COD = <cfqueryparam value="#form.FAM01COD#" cfsqltype= "cf_sql_char">
	</cfquery>

	<cfif DeterminaProc.FAM01STP EQ 50>
		<cfquery name="update" datasource="#session.DSN#">
			update FAM001
			set 
			FAM01STS=1,
			FAM01STP=0
			where FAM01COD = <cfqueryparam value="#form.FAM01COD#" cfsqltype= "cf_sql_char">
			  and FAM01STP = 50
		</cfquery> 
	<cfelse>
		<cfquery name="update" datasource="#session.DSN#">
			update FAM001
			set FAM01STS=1
			where FAM01COD = <cfqueryparam value="#form.FAM01COD#" cfsqltype= "cf_sql_char">
		</cfquery> 
	</cfif>
	  
<form action="apertura_cajas.cfm" method="post" name="sql">
	<cfoutput>
		<input name="FAM01COD" type="hidden" value="#form.FAM01COD#"> 
		
	</cfoutput>
</form>


<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
