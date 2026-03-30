<cfif isdefined("form.BTNGuardar")>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select b.CFid
		from RHGruposRegistroE a
		inner join RHCFGruposRegistroE b
		on b.GREid = a.GREid
		inner join CFuncional cf
		   on cf.CFid = b.CFid
		  and cf.Ecodigo = a.Ecodigo
		inner join RHNotasIndicadoresCF icf
		   on icf.REid = a.REid
		  and icf.CFid = cf.CFid
		  and icf.Ecodigo = cf.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfloop query="rsCFuncional">
		<cfif isdefined('form.Nota_#CFid#')>
			<cfquery name="UpdateNotas" datasource="#session.DSN#">
				update RHNotasIndicadoresCF
				set Nota = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.Nota_'&rsCFuncional.CFid)#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFuncional.CFid#">
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<cflocation url="NotasIndicadoresCF.cfm?REid=#form.REid#">
