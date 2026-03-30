<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
				table="FAM014"
				redirect="cajasProceso_Paso2.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="FAM09MAQ"
				type1="tinyint"
				value1="#form.FAM09MAQ#" 
				
				field2="CCTcodigo"
				type2="char"
				value2="#form.CCTcodigo_ANT#"
				
				field3="FAX01ORIGEN"
				type3="char"
				value3="#form.FAX01ORIGEN_ANT#"
				
				field4="FAM12COD"
				type4="numeric"
				value4="#form.FAM12COD_ANT#" >
				
	<cfquery datasource="#session.dsn#" name="rsVerificaExistencia">
		Select CCTcodigo
		from FAM014
		where CCTcodigo=	<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
		and FAM09MAQ=  <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">
		and FAM12COD=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM12COD#">
		and FAX01ORIGEN=  <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN#">
	</cfquery>
	<!---<cfdump var="#rsVerificaExistencia#">--->
	<cfif rsVerificaExistencia.recordcount gt 0>
		<script>
			alert("Esta definicion ya existe")			
		</script>
	<cfelse>	
	<cfquery name="update" datasource="#session.DSN#">
		update FAM012 set 
		FAM12DES = <cfqueryparam value="#form.FAM12DES#" cfsqltype="cf_sql_char">
		where Ecodigo = #session.Ecodigo#and FAM12COD = <cfqueryparam value="#Form.FAM12COD#" cfsqltype="cf_sql_numeric">
		
		update FAM014 set
		FAM12COD = <cfqueryparam value="#Form.FAM12COD#" cfsqltype="cf_sql_numeric">,
		CCTcodigo= <cfqueryparam value="#Form.CCTcodigo#" cfsqltype="cf_sql_char">,
		FAX01ORIGEN= <cfqueryparam value="#Form.FAX01ORIGEN#" cfsqltype="cf_sql_char">,
		BMUsucodigo= #session.Usucodigo#
		where Ecodigo = #session.Ecodigo#and FAM09MAQ = <cfqueryparam value="#form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">
		and CCTcodigo = <cfqueryparam value="#form.CCTcodigo_ANT#" cfsqltype="cf_sql_char">
		and FAM12COD = <cfqueryparam value="#form.FAM12COD_ANT#" cfsqltype="cf_sql_numeric">
		and FAX01ORIGEN = <cfqueryparam value="#form.FAX01ORIGEN_ANT#" cfsqltype="cf_sql_char">
	</cfquery>
	</cfif> 
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from FAM014
		where Ecodigo = #session.Ecodigo#and FAM09MAQ = <cfqueryparam value="#form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">
		and CCTcodigo = <cfqueryparam value="#form.CCTcodigo#" cfsqltype="cf_sql_char">
		and FAM12COD=  <cfqueryparam  value="#form.FAM12COD#" cfsqltype="cf_sql_numeric">
		and FAX01ORIGEN = <cfqueryparam value="#form.FAX01ORIGEN#" cfsqltype="cf_sql_char">
	</cfquery>	
	
	<cfquery name="rsImpresoraxDoc" datasource="#session.dsn#">
		select 1 from FAM014
		where Ecodigo = #session.Ecodigo#and FAM12COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM12COD#"> 
	</cfquery>

	<cfif rsImpresoraxDoc.recordcount eq 0>
		<cfquery datasource="#session.dsn#">
			delete from FAM012
			where Ecodigo = #session.Ecodigo# and FAM12COD = <cfqueryparam value="#form.FAM12COD#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
			
<cfelseif IsDefined("form.Alta")>
<cfquery datasource="#session.dsn#" name="rsVerificaTransaccion">
		Select CCTcodigo
		from FAM014
		where CCTcodigo=	<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
		and FAM09MAQ=  <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">
		and FAM12COD=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM12COD#">
		and FAX01ORIGEN=  <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN#">
	</cfquery>
	
	<cfif rsVerificaTransaccion.recordcount gt 0>
		<script>
			alert("Esta definicion ya existe")			
		</script>
	<cfelse>
	<cfquery datasource="#session.dsn#">
		insert into FAM014( Ecodigo,FAM09MAQ,FAM12COD, CCTcodigo, BMUsucodigo, fechaalta,FAX01ORIGEN )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		        <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">, 
		        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM12COD#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN#">)
	</cfquery>
	</cfif>
</cfif>
<cfoutput>
	<form name="form1" method="post" action="cajasProceso.cfm">
		<input type="hidden" name="paso" value="2">
		<cfif isdefined("Form.FAM09MAQ") and Len(Trim(Form.FAM09MAQ))>
			<input type="hidden" name="FAM09MAQ" value="#Form.FAM09MAQ#">
		</cfif>
		<cfif isdefined("Form.FAX01ORIGEN") and Len(Trim(Form.FAX01ORIGEN))>
			<input type="hidden" name="FAX01ORIGEN" value="#Form.FAX01ORIGEN#">
		</cfif>
		<cfif isdefined("Form.FAM12COD") and Len(Trim(Form.FAM12COD))>
			<input type="hidden" name="FAM12COD" value="#Form.FAM12COD#">
		</cfif>
		<cfif not isdefined("Form.Nuevo") and not isdefined ("form.Baja") and isdefined("Form.CCTcodigo") and Len(Trim(Form.CCTcodigo))>
			<input type="hidden" name="CCTcodigo" value="#Form.CCTcodigo#">
		</cfif>
	</form>
</cfoutput>

<HTML>
  <head>
  </head>
  <body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
  </body>
</HTML>
