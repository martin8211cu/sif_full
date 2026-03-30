<!---  --->
<cfif isDefined("form.btnAgregar")>
	<cfif isDefined("form.CHK")>
		<cftransaction>
			<cfset arreglo = listtoarray(form.CHK,",")>
			<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
				<cfquery name="RSInsert" datasource="#session.DSN#">
					insert  into CRCCCFuncionales (CRCCid,CFid,BMUsucodigo,CRCCfalta)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo[i]#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
					)
				</cfquery>
			</cfloop>
		</cftransaction>
	</cfif>
<cfelseif isDefined("form.eliminar")>
	<cfquery datasource="#session.DSN#">
		delete from CRCCCFuncionales 
		where  CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidD#"> 
		and CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
	</cfquery>
</cfif>

<cfset p = "?tab=2&CRCCid=#form.CRCCid#">
<cflocation url="CentroCustodia.cfm#p#">
