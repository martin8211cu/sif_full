<cfparam name="form.modo" default="">
<cfif isDefined("form.modo")>
	<cfif form.modo eq "ALTA">
		<cfif isDefined("form.txt_cmayor") and len(trim(form.txt_cmayor)) and isDefined("form.formato") and len(trim(form.formato))>
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select 1
				from CtasMayor
				where Ecodigo =  #Session.Ecodigo# 
				  and Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" value="#form.txt_cmayor#">
			</cfquery>
			<cfif rsVerifica.recordCount eq 0>
				<cf_errorCode	code = "50054" msg = "Cuenta de Mayor Inválida, Proceso Cancelado!">
			</cfif>
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select 1
				from CFinanciera
				where Ecodigo =  #Session.Ecodigo# 
				  and Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" value="#form.txt_cmayor#">
				  and CFformato like <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.formato#%">
			</cfquery>
			<cfif rsVerifica.recordCount eq 0>
				<cf_errorCode	code = "50055" msg = "Cuenta Financiera Inválida, Proceso Cancelado!">
			</cfif>
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select 1
				from GACMayor
				where Ecodigo =  #Session.Ecodigo# 
				  and Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" value="#form.txt_cmayor#">
				  and Cmascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.formato#">
			</cfquery>
			<cfif rsVerifica.recordCount gt 0>
				<cf_errorCode	code = "50056" msg = "La relación ya está definida, Proceso Cancelado!">
			</cfif>
			<cfquery datasource="#session.DSN#">
				insert into GACMayor( Ecodigo, Cmayor, Cmascara, fechaalta, BMUsucodigo )
				values (  #Session.Ecodigo# ,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#form.txt_cmayor#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.formato#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		</cfif>
	<cfelseif form.modo eq "BAJA">
		<cfquery datasource="#session.DSN#">
			delete from GACMayor
			where Ecodigo =  #Session.Ecodigo# 
			  and Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" value="#form.mayor#">
			  and Cmascara = <cfqueryparam cfsqltype="cf_sql_char" value="#form.formato#">
		</cfquery>
	</cfif>
</cfif>
<cflocation url="ctasmayor.cfm">

