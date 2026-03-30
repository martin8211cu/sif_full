<!--- Actualizar la informacion sobre caches en la variable Application.dsinfo --->
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
<cfinvokeargument name="refresh" value="yes">
</cfinvoke>

<cfset er = 0>

<cfif not isdefined("Form.btnNuevo")>
	<cfif isdefined("Form.CidR") and Len(Trim(Form.CidR)) NEQ 0>
		<cfif isdefined("Form.btnEliminar")>
			<cfquery name="rsVal" datasource="asp">
				select IdCR from CacheRepo
				where CidR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CidR#">
			</cfquery>
			<cfif #rsVal.RecordCount# eq 0>
				<cfquery name="rs" datasource="asp">
					delete from CachesRep
					where CidR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CidR#">
				</cfquery>
				<cfelse>
				<cfset er = 1>
			</cfif>

		<cfelse>
			<cfquery name="rs" datasource="asp">
				update CachesRep
				set CDataSource = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CDataSource#" null="#Form.CDataSource eq 0#">
				where CidR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CidR#">
			</cfquery>
		</cfif>

	<cfelse>

		<cfquery name="rs" datasource="asp">
			insert into CachesRep (Ccache, CDataSource, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ccache#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CDataSource#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
		</cfquery>
	</cfif>
</cfif>

<cfparam name="Form.Pagina" default="1">
<cflocation url="cachesRep.cfm?Pagina=#Form.Pagina#&er=#er#">