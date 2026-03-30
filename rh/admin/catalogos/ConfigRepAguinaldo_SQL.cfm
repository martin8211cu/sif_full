<cfif isdefined("form.AgregarC")>
	<cfquery name="rsexiste" datasource="#session.DSN#">
		select 1
		from RHDrpt
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and rptid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rptid#">
		  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	</cfquery>
	<cfif rsexiste.recordcount eq 0 >
		<cfquery name="InsertCP" datasource="#session.DSN#">
			insert into RHDrpt (rptid, Ecodigo, CIid, Factor, Excluir)
			values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rptid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
					0,
					0
			)
		</cfquery>
	</cfif>
<cfelseif isdefined("ModificarC")>
	<cfloop collection="#Form#" item="i">
		<cfif FindNoCase("FactorC_", i) NEQ 0>
			<cfset vCIid = Mid(i, 9, Len(i))>
			<cfquery name="UpdateCP" datasource="#session.DSN#">
				update RHDrpt
				set Factor 	 = <cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.FactorC_'&vCIid)#">
					,Excluir =<cfif isdefined('form.ExcluirC_#vCIid#')>1<cfelse>0</cfif>
				where rptid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rptid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and CIid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCIid#">
			</cfquery>
		</cfif>
	</cfloop>
<cfelseif isdefined('form.EliminarC') and form.EliminarC EQ 1>
	<cfquery name="DeleteCP" datasource="#session.DSN#">
		delete from RHDrpt
		where rptid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rptid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and CIid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	</cfquery>
<cfelseif isdefined("form.AgregarA")>
	<cfquery name="InsertA" datasource="#session.DSN#">
		insert into RHDrpt (rptid, Ecodigo, RHTid, Factor, Excluir)
		values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rptid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">,
				0,
				0
		)
	</cfquery>
<cfelseif isdefined("ModificarA")>
	<cfloop collection="#Form#" item="i">
		<cfif FindNoCase("FactorA_", i) NEQ 0>
			<cfset vRHTid = Mid(i, 9, Len(i))>
			<cfquery name="UpdateA" datasource="#session.DSN#">
				update RHDrpt
				set Factor 	 = <cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.FactorA_'&vRHTid)#">
					,Excluir =<cfif isdefined('form.ExcluirA_#vRHTid#')>1<cfelse>0</cfif>
				where rptid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rptid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and RHTid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHTid#">
			</cfquery>
		</cfif>
	</cfloop>
<cfelseif isdefined('form.EliminarA') and form.EliminarA EQ 1>
	<cfquery name="DeleteCP" datasource="#session.DSN#">
		delete from RHDrpt
		where rptid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rptid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and RHTid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._RHTid#">
	</cfquery>
</cfif>
<cflocation url="ConfigRepAguinaldo.cfm">