<cfset modo = "ALTA">
	<!---====================ANhomologacionFmts=======================--->		
	<cfif isdefined("Form.AgregarFmts1")>
		<cfquery datasource="#Session.DSN#">
			insert into ANhomologacionFmts(
						ANHCid, 
						Cmayor,  
						AnexoCelFmt,
						AnexoSigno, 
						Ecodigo,  
						BMUsucodigo
					  )
				values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHCid1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txt_Cmayor1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnAjustaMascara1()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoSigno1#">,
						#Session.Ecodigo#,
						#session.Usucodigo#
					) 
		</cfquery>
				<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid1=#form.ANHCid1#">
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.ModificarFmts1")>
		<cfquery datasource="#Session.DSN#">
			update ANhomologacionFmts
			   set Cmayor		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txt_Cmayor1#">
			     , AnexoCelFmt	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#fnAjustaMascara1()#">
				 , AnexoSigno	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoSigno1#">
				 , BMUsucodigo	= #session.Usucodigo#
			 where ANHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHFid1#">
		</cfquery>
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid1=#form.ANHCid1#">
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.EliminarFmts1")>		
		<cfquery datasource="#Session.DSN#">
			delete from ANhomologacionFmts
			 where ANHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHFid1#">
		</cfquery>
		
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid1=#form.ANHCid1#">
		<cfset modo="CAMBIO">
		
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid1=#form.ANHCid1#">
	</cfif>
	<!---====================ANhomologacionFmts=======================--->		
	<cfif isdefined("Form.AgregarFmts2")>
		<cfquery datasource="#Session.DSN#">
			insert into ANhomologacionFmts(
						ANHCid, 
						Cmayor,  
						AnexoCelFmt,
						AnexoSigno, 
						Ecodigo,  
						BMUsucodigo
					  )
				values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHCid2#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txt_Cmayor2#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnAjustaMascara2()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoSigno2#">,
						#Session.Ecodigo#,
						#session.Usucodigo#
					) 
		</cfquery>
				<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid2=#form.ANHCid2#">
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.ModificarFmts2")>
		<cfquery datasource="#Session.DSN#">
			update ANhomologacionFmts
			   set Cmayor		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txt_Cmayor2#">
			     , AnexoCelFmt	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#fnAjustaMascara2()#">
				 , AnexoSigno	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoSigno2#">
				 , BMUsucodigo	= #session.Usucodigo#
			 where ANHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHFid2#">
		</cfquery>
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid2=#form.ANHCid2#">
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.EliminarFmts2")>		
		<cfquery datasource="#Session.DSN#">
			delete from ANhomologacionFmts
			 where ANHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ANHFid2#">
		</cfquery>
		
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid2=#form.ANHCid2#">
		<cfset modo="CAMBIO">
		
		<cflocation url="modificaHomologacion.cfm?ANHid=#form.ANHid#&ANHCid2=#form.ANHCid2#">
	</cfif>
    
<form action="modificaHomologacion.cfm" method="post" name="sql">
	<input name="modo"  type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="ANHid" type="hidden" value="<cfoutput>#form.ANHid#</cfoutput>">
	<input name="ANHCid1" type="hidden" value="<cfif isdefined("form.ANHCid1") and modo neq 'ALTA'><cfoutput>#form.ANHCid1#</cfoutput></cfif>">
    <input name="ANHCid2" type="hidden" value="<cfif isdefined("form.ANHCid2") and modo neq 'ALTA'><cfoutput>#form.ANHCid2#</cfoutput></cfif>">
</form>
	
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
<cffunction name="fnAjustaMascara1" output="no" returntype="string">
	<cfset var LvarCta = replace(trim(form.CtaFinal1),"%","_","ALL")>
	<cfset var i = len(LvarCta)>
	<cfloop condition="true">
		<cfif mid(LvarCta,i,1) NEQ "_" or i EQ 0>
			<cfbreak>
		</cfif>
		<cfset i=i-1>
	</cfloop>
	<cfif mid(LvarCta,i,1) EQ "-">
		<cfset i=i-1>
	</cfif>
	<cfreturn mid(LvarCta,1,i) & "%">
</cffunction>
<cffunction name="fnAjustaMascara2" output="no" returntype="string">
	<cfset var LvarCta = replace(trim(form.CtaFinal2),"%","_","ALL")>
	<cfset var i = len(LvarCta)>
	<cfloop condition="true">
		<cfif mid(LvarCta,i,1) NEQ "_" or i EQ 0>
			<cfbreak>
		</cfif>
		<cfset i=i-1>
	</cfloop>
	<cfif mid(LvarCta,i,1) EQ "-">
		<cfset i=i-1>
	</cfif>
	<cfreturn mid(LvarCta,1,i) & "%">
</cffunction>
