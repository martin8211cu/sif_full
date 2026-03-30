<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select CCTcodigo from CCTransacciones
			where Ecodigo = #Session.Ecodigo#
			  and CCTcodigo = <cfqueryparam value="#Form.CCTcodigo#" cfsqltype="cf_sql_char">
		</cfquery>

		<cfif rsExiste.RecordCount eq 0>
			<cfquery name="Transacciones" datasource="#Session.DSN#">
				insert into CCTransacciones (Ecodigo, CCTcodigo, CCTdescripcion, CCTtipo, CCTvencim, CCTpago, BTid, CCTcktr, CCTafectacostoventas, CCTnoflujoefe, FMT01COD, BMUsucodigo, CCTcodigoext, cuentac, CCTtranneteo, CCTCompensacion,CCTcolrpttranapl,CCTestimacion,CCTCodigoRef,ClaveSAT)
				values ( #session.Ecodigo#,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CCTcodigo)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CCTdescripcion)#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTtipo#">,
						 <cfif isdefined('Form.chkContado')>
							-1,<cfelse>
						 <cfif isdefined("Form.CCTvencim") and Len(Trim(Form.CCTvencim)) NEQ 0>
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CCTvencim#">,
						 <cfelse>
							 null,
						 </cfif>
					 </cfif>
					 <cfif Form.CCTtipo EQ 'C' and isdefined("Form.CCTpago")>
						1,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcktr#">,
					 <cfelse>
						0,
						null,
						null,
					 </cfif>
					<cfif isdefined("form.CCTafectacostoventas")>1<cfelse>0</cfif>,
					<cfif isdefined("form.CCTnoflujoefe")>1<cfelse>0</cfif>,
					<cfif isdefined("form.FMT01COD") and len(trim(form.FMT01COD))><cfqueryparam cfsqltype="char" value="#trim(form.FMT01COD)#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigoext#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">,
					<cfif isdefined ("form.CCTtranneteo") and len(trim(form.CCTtranneteo))>
						1,
					<cfelse>
						0,
					</cfif>
					<cfif isdefined ("form.CCTCompensacion") and len(trim(form.CCTCompensacion))>
						1,
					<cfelse>
						0,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTcolrpttranapl#">,
					 <cfif not isdefined("Form.CCTestimacion")>
					 	0,
						null,
					<cfelse>
						1,
						<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CCTCodigoRef)#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSATcodigo#">
				 )
			</cfquery>
			<cfquery name="rsPagina" datasource="#session.DSN#">
			 	select CCTcodigo
				from CCTransacciones
				where Ecodigo =  #session.Ecodigo#
				order by CCTcodigo
			</cfquery>
			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.CCTcodigo EQ form.CCTcodigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfset params=params&"&CCTcodigo="&form.CCTcodigo>
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
		delete from CCTransacciones
		where Ecodigo = #Session.Ecodigo#
		  and CCTcodigo  = <cfqueryparam value="#Form.CCTcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cf_sifcomplementofinanciero action='delete'
				tabla="CCTransacciones"
				form = "form1"
				llave="#form.CCTcodigo#" />
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select CCTcodigo
			from CCTransacciones
			where Ecodigo =  #session.Ecodigo#
			order by CCTcodigo
		</cfquery>
		<cfset pag = Ceiling(rsPagina.RecordCount / form.MaxRows)>
		<cfif form.Pagina GT pag>
			<cfset form.Pagina = pag>
		</cfif>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="CCTransacciones"
			redirect="TipoTransacciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo"
			type1="integer"
			value1="#session.Ecodigo#"
			field2="CCTcodigo"
			type2="char"
			value2="#form.CCTcodigo#">

		<cfquery name="Transacciones" datasource="#Session.DSN#">
			update CCTransacciones set
				CCTdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CCTdescripcion)#">,
				CCTtipo        = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTtipo#">,
				BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
		<cfif isdefined('Form.chkContado')>
				CCTvencim = -1,
		<cfelse>
		   <cfif isdefined("Form.CCTvencim") and Len(Trim(Form.CCTvencim)) NEQ 0>
				CCTvencim = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CCTvencim#">,
			<cfelse>
				CCTvencim =  null,
			</cfif>
		</cfif>
		<cfif Form.CCTtipo EQ 'C' and isdefined("Form.CCTpago")>
				CCTpago = 1,
				BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">,
				CCTcktr = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcktr#">,
		<cfelse>
				CCTpago = 0,
				BTid = null,
				CCTcktr = null,
		</cfif>
				CCTafectacostoventas = <cfif isdefined("form.CCTafectacostoventas")>1<cfelse>0</cfif>,
				CCTnoflujoefe = <cfif isdefined("form.CCTnoflujoefe")>1<cfelse>0</cfif>,
				FMT01COD = <cfif isdefined("form.FMT01COD") and len(trim(form.FMT01COD))><cfqueryparam cfsqltype="char" value="#trim(form.FMT01COD)#"><cfelse>null</cfif>,
				CCTcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigoext#">,
				cuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">,
				CCTtranneteo = <cfif isdefined ("form.CCTtranneteo") and len(trim(form.CCTtranneteo))>1<cfelse>0</cfif>,
				CCTCompensacion = <cfif isdefined ("form.CCTCompensacion") and len(trim(form.CCTCompensacion))>1<cfelse>0</cfif>,
			<cfif not isdefined("Form.CCTestimacion")>
				CCTestimacion = 0,
				CCTCodigoRef  = null
			<cfelse>
				CCTestimacion = 1,
				CCTCodigoRef  = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CCTCodigoRef)#">
			</cfif>
				,CCTcolrpttranapl=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTcolrpttranapl#">
				,ClaveSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSATcodigo#">
			where Ecodigo = #Session.Ecodigo#
			  and CCTcodigo = <cfqueryparam value="#Form.CCTcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cf_sifcomplementofinanciero action='update'
				tabla="CCTransacciones"
				form = "form1"
				llave="#form.CCTcodigo#" />
		<cfset params=params&"&CCTcodigo="&form.CCTcodigo>
	</cfif>
</cfif>

<cflocation url="TipoTransacciones.cfm?Pagina=#form.Pagina##params#" >