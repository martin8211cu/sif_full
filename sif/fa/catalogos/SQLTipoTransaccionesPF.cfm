<cfset params = "">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select PFTcodigo from FAPFTransacciones
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and PFTcodigo = <cfqueryparam value="#Form.PFTcodigo#" cfsqltype="cf_sql_char">
		</cfquery>

		<cfif rsExiste.RecordCount eq 0>
			<cfquery name="Transacciones" datasource="#Session.DSN#">
				insert into FAPFTransacciones (Ecodigo, PFTcodigo, PFTdescripcion, PFTtipo,
                			FMT01COD, BMUsucodigo, PFTcodigoext, CCTcodigoRef,CCTcodigoCan,
                            CCTcodigoEst,PFTcodigoRef
							<cfif isdefined("form.esContado")>
								,esContado
							</cfif>
							)
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.PFTcodigo)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.PFTdescripcion)#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.PFTtipo#">,
		 				 <cfif isdefined("form.FMT01COD") and len(trim(form.FMT01COD))><cfqueryparam cfsqltype="char" value="#trim(form.FMT01COD)#"><cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PFTcodigoext#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CCTCodigoRef)#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CCTCodigoCan)#">,
                         <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CCTCodigoEst)#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.PFTCodigoRef)#">
						 <cfif isdefined("form.esContado")>
							,1
						</cfif>
				 		)
			</cfquery>
			<cfquery name="rsPagina" datasource="#session.DSN#">
			 	select PFTcodigo
				from FAPFTransacciones
				where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				order by PFTcodigo
			</cfquery>
			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.PFTcodigo EQ form.PFTcodigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfset params=params&"&PFTcodigo="&form.PFTcodigo>
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			delete from FAPFTransacciones
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  	and PFTcodigo  = <cfqueryparam value="#Form.PFTcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select PFTcodigo
			from FAPFTransacciones
			where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by PFTcodigo
		</cfquery>
		<cfif rsPagina.RecordCount eq 0>
			<cflocation url="TipoTransaccionesPF.cfm?">
		</cfif>
		<cfset pag = Ceiling(rsPagina.RecordCount / form.MaxRows)>
		<cfif form.Pagina GT pag>
			<cfset form.Pagina = pag>
		</cfif>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="FAPFTransacciones"
			redirect="TipoTransaccionesPF.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo"
			type1="integer"
			value1="#session.Ecodigo#"
			field2="PFTcodigo"
			type2="char"
			value2="#form.PFTcodigo#">

		<cfquery name="Transacciones" datasource="#Session.DSN#">
			update FAPFTransacciones set
				PFTdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PFTdescripcion#">)),
				PFTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.PFTtipo#">,
				FMT01COD = <cfif isdefined("form.FMT01COD") and len(trim(form.FMT01COD))><cfqueryparam cfsqltype="char" value="#trim(form.FMT01COD)#"><cfelse>null</cfif>,
				PFTcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PFTcodigoext#">,
				CCTcodigoRef  = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CCTcodigoRef)#">,
                CCTcodigoCan  = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CCTcodigoCan)#">,
                CCTcodigoEst  = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CCTcodigoEst)#">,
				 PFTcodigoRef  = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.PFTcodigoRef)#">,
				 esContado = <cfqueryparam cfsqltype="cf_sql_integer" value="1" null="#not isdefined('form.esContado')#">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and PFTcodigo = <cfqueryparam value="#Form.PFTcodigo#" cfsqltype="cf_sql_char">
			  <!---and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)---->
		</cfquery>
		<cfset params=params&"&PFTcodigo="&form.PFTcodigo>
	</cfif>
</cfif>

<cflocation url="TipoTransaccionesPF.cfm?Pagina=#form.Pagina##params#" >