<cfif isdefined("Form.btnEliminar") 
	and isdefined("Form.FMT01COD") and Len(Trim(Form.FMT01COD)) GT 0
	and isdefined("Form.FMT03LIN") and Len(Trim(Form.FMT03LIN)) GT 0>
	<cfquery name="rsdelete" datasource="#Session.DSN#">
		delete from FMT003
		where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
		  and FMT03LIN = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.FMT03LIN#">
	</cfquery>
</cfif>

<cfset error = false >
<cfif not isdefined("Form.btnEliminar")>
			
		
		<cfif isDefined("btnAgregar")>
			<cfquery name="siguiente" datasource="#Session.DSN#">
				select coalesce(max(FMT03LIN),0)+1 as siguiente from FMT003 
				where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
			</cfquery>
			<cfquery name="ABCimagen" datasource="#Session.DSN#">
				
				insert into FMT003 
				(FMT01COD, FMT03LIN, FMT03IMG, FMT03FIL, FMT03COL, FMT03ALT, FMT03ANC, FMT03BOR, FMT03CFN, FMT03CBR, FMT03EMP)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#siguiente.siguiente#">, 
					<cf_dbupload filefield="FiletoUpload">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03FIL#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03COL#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03ALT#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03ANC#">,
					<cfif isDefined("Form.FMT03BOR")>1,<cfelse>0,</cfif> 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FMT03CFN#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FMT03CBR#">,
					<cfif isDefined("Form.FMT03EMP")>1<cfelse>0</cfif>
				)			
			</cfquery>
		<cfelseif isDefined("btnCambiar")>
			<cfquery name="ABCimagen" datasource="#Session.DSN#">
				update FMT003
				set <cfif len(trim(form.FileToUpload))>FMT03IMG = <cf_dbupload filefield="FiletoUpload">,</cfif>
					FMT03FIL = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03FIL#">, 
					FMT03COL = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03COL#">, 
					FMT03ALT = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03ALT#">, 
					FMT03ANC = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03ANC#">, 
					FMT03BOR = <cfif isDefined("Form.FMT03BOR")>1,<cfelse>0,</cfif>
					FMT03CFN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FMT03CFN#">, 
					FMT03CBR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FMT03CBR#">,
					FMT03EMP = <cfif isDefined("Form.FMT03EMP")>1<cfelse>0</cfif>
				where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
				  and FMT03LIN = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.FMT03LIN#">

			</cfquery>
		</cfif>

</cfif>		


<!---<form action="ImagenesFormato.cfm?FMT01COD=<cfoutput>#Form.FMT01COD#</cfoutput>" method="post" name="sql">--->
<form action="ImagenesFormato.cfm" method="post" name="sql">
 	<input name="FMT01COD" type="hidden" value="<cfif isdefined("form.FMT01COD")><cfoutput>#form.FMT01COD#</cfoutput></cfif>">	 	
	<cfif not isDefined("Form.btnNuevo")>	
	<input name="FMT03LIN" type="hidden" value="<cfif isdefined("form.FMT03LIN")><cfoutput>#form.FMT03LIN#</cfoutput></cfif>"> 		
	</cfif>
	<input name="modo" type="hidden" 
		value="<cfif not isDefined ("Form.btnNuevo") and not isDefined ("Form.btnEliminar") and isdefined("Form.FMT01COD") and (Len(Trim(Form.FMT01COD)) GT 0) 
					and isdefined("Form.FMT03LIN") and (Len(Trim(form.FMT03LIN)) GT 0)>CAMBIO</cfif>">

</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


