<cfif IsDefined("form.Cambio")>
 	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAX009" redirect="sec_doc_imp.cfm" timestamp="#form.ts_rversion#"
		field1="FAM12COD"    type1="numeric" value1="#form.FAM12COD#"
		field2="FAX01ORIGEN" type2="char"    value2="#form.FAX01ORIGEN#">
	<cfset a = ValidarConcecutivos(#session.dsn#,#session.Ecodigo#,#form.FAX01ORIGEN#,#form.FAX09DIN#,#form.FAX09DFI#,#form.FAM12COD#)>
	<cfquery name="update" datasource="#session.DSN#">
		update FAX009
		set			
			FAX09DIN	= <cfqueryparam value="#form.FAX09DIN#" cfsqltype="cf_sql_integer">,
			FAX09DFI	= <cfqueryparam value="#form.FAX09DFI#" cfsqltype="cf_sql_integer">,
			FAX01ORIGEN	= <cfqueryparam value="#form.FAX01ORIGEN#" cfsqltype="cf_sql_char">,
		<cfif isdefined('form.FAX09SER') and form.FAX09SER NEQ ''>
			FAX09SER = <cfqueryparam cfsqltype= "cf_sql_char" value="#form.FAX09SER#">,
		<cfelse>
			FAX09SER = null,
		</cfif>		
			FAX09NXT	= <cfqueryparam value="#form.FAX09NXT#" cfsqltype="cf_sql_integer">,	
			BMUsucodigo = #session.Usucodigo#
		where Ecodigo     = #session.Ecodigo#
	      and FAM12COD    = <cfqueryparam value="#form.FAM12COD#" cfsqltype= "cf_sql_numeric">
		  and FAX01ORIGEN = <cfqueryparam value="#form.FAX01ORIGEN#" cfsqltype= "cf_sql_char">
	</cfquery> 
	
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from FAX009
		where Ecodigo   = #session.Ecodigo#
		and FAM12COD    = <cfqueryparam value="#form.FAM12COD#" cfsqltype= "cf_sql_numeric">
		and FAX01ORIGEN = <cfqueryparam value="#form.FAX01ORIGEN#" cfsqltype= "cf_sql_char">
	</cfquery>
			
<cfelseif IsDefined("form.Alta")>
	<cfset a = ValidarConcecutivos(#session.dsn#,#session.Ecodigo#,#form.FAX01ORIGEN#,#form.FAX09DIN#,#form.FAX09DFI#,#form.FAM12COD#)>
	<cfquery datasource="#session.dsn#">
	   insert into FAX009 ( Ecodigo,  FAM12COD, FAX09DIN, FAX09DFI, FAX09SER,FAX01ORIGEN, FAX09NXT, BMUsucodigo, fechaalta)
	   values(	
		   		#session.Ecodigo#,
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#form.FAM12COD#">,
			    <cfqueryparam cfsqltype="cf_sql_integer"  value="#FAX09DIN#">,
				<cfqueryparam cfsqltype="cf_sql_integer"  value="#FAX09DFI#">,
				<cfqueryparam cfsqltype="cf_sql_char" 	  value="#FAX09SER#">,
				<cfqueryparam cfsqltype="cf_sql_char" 	  value="#FAX01ORIGEN#">,
				<cfqueryparam cfsqltype="cf_sql_integer"  value="#FAX09NXT#">,
				#Session.Usucodigo#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
		</cfquery>
</cfif>

<form action="sec_doc_imp.cfm" method="post" name="sql">
	<cfoutput>
		<cfif (isdefined('form.Alta') or isdefined('form.Cambio')) and isdefined('form.FAM12COD') and form.FAM12COD NEQ '' and isdefined('form.FAX01ORIGEN') and form.FAX01ORIGEN NEQ '' and not isdefined('form.Baja')>
			<input name="FAM12COD" type="hidden" value="#form.FAM12COD#"> 	
			<input name="FAX01ORIGEN" type="hidden" value="#form.FAX01ORIGEN#"> 	
		</cfif>
		<cfif isdefined('form.FAM12COD_F') and len(trim(form.FAM12COD_F))>
			<input type="hidden" name="FAM12COD_F" value="#form.FAM12COD_F#">	
		</cfif>
	</cfoutput>
</form>
<cffunction access="public" name="ValidarConcecutivos">
	<cfargument name="Coneccion" 	  type="string"   required="no" default="#session.dsn#">
	<cfargument name="Ecodigo"   	  type="numeric"  required="no" default="#session.Ecodigo#">
	<cfargument name="FAX01ORIGEN"    type="string"   required="yes">
	<cfargument name="FAX01DOC_INI"   type="numeric"  required="yes">
	<cfargument name="FAX01DOC_FINI"  type="numeric"  required="yes">
	<cfargument name="FAM12COD"    type="numeric"  required="yes">
	
	<cftry>
		<cfquery name="Documentos" datasource="#Arguments.Coneccion#">
			select FAX01DOC 
			   from FAX001 
			 where isnumeric(FAX01DOC) = 1
			 	AND <cf_dbfunction name="to_integer"	args="FAX01DOC"> between #Arguments.FAX01DOC_INI# AND #Arguments.FAX01DOC_FINI# 
				AND Ecodigo = #Arguments.Ecodigo#
				AND CCTcodigo in (select CCTcodigo 
									FROM FAM014 
								   WHERE FAM12COD    = #Arguments.FAM12COD# 
									 AND FAX01ORIGEN = '#Arguments.FAX01ORIGEN#'
								   )
				AND FAX01ORIGEN =  '#Arguments.FAX01ORIGEN#'
				
		</cfquery>
		<cfcatch type="any">
			<cfthrow message="No se puedo verificar los Consecutivos #cfcatch.Message# #cfcatch.Detail#">
		</cfcatch>
	</cftry>
	<cfif Documentos.Recordcount GT 0>
			<cfset listFAX01DOC=''>
		<cfloop query="Documentos" >
			<cfif Documentos.currentrow GT 10>
				<cfbreak>
			</cfif>
			<cfset listFAX01DOC =listFAX01DOC & Documentos.FAX01DOC>
			<cfif Documentos.currentrow LT Documentos.Recordcount and Documentos.currentrow LT 10>
				<cfset listFAX01DOC =listFAX01DOC & ','>
			</cfif>
		</cfloop>
		<cfthrow message="Existen #Documentos.Recordcount# Documentos entre los Rangos:#listFAX01DOC#">
	</cfif>
</cffunction>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>