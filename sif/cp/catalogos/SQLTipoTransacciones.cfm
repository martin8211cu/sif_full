<cfset params="">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select CPTcodigo from CPTransacciones
			where Ecodigo =  #Session.Ecodigo#
			  and CPTcodigo = <cfqueryparam value="#Form.CPTcodigo#" cfsqltype="cf_sql_char">
		</cfquery>

			<cfif rsExiste.recordcount eq 0>
				<cfquery datasource="#Session.DSN#">
					insert into CPTransacciones ( Ecodigo, CPTcodigo, CPTdescripcion, CPTtipo, CPTvencim, CPTpago, BTid, CPTcktr, CPTanticipo,CPTafectacostoventas, CPTnoflujoefe, FMT01COD, BMUsucodigo, CPTcodigoext, cuentac, CPTestimacion, CPTCodigoRef, CPTremision, CPTCompensacion )
					values(	 #session.Ecodigo# ,
							<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CPTcodigo)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CPTdescripcion)#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTtipo#">,
							<cfif isdefined("Form.CPTvencim") and Len(Trim(Form.CPTvencim)) NEQ 0><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPTvencim#"><cfelse>null</cfif>,
							<cfif Form.CPTtipo EQ 'D' and isdefined("Form.CPTpago") and trim(Form.CPTpago) EQ 1>
								1,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcktr#">,
                                0,
                            <cfelseif Form.CPTtipo EQ 'D' and isdefined("Form.CPTpago") and trim(Form.CPTpago) EQ 2>
                            	0,
								null,
								null,
                                1,
							<cfelse>
								0,
								null,
								null,
                                0,
							</cfif>
							<cfif isdefined("form.CPTafectacostoventas")>1<cfelse>0</cfif>,
							<cfif isdefined("form.CPTnoflujoefe")>1<cfelse>0</cfif>,
							<cfif isdefined("form.FMT01COD") and len(trim(form.FMT01COD))><cfqueryparam cfsqltype="char" value="#trim(form.FMT01COD)#"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPTcodigoext#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">,
							<cfif not isdefined("Form.CPTestimacion")>
								0,
								null
							<cfelse>
								1,
								<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CPTCodigoRef)#">
							</cfif>
                            <cfif not isdefined("Form.CPTremision")>
                            	, 0
                            <cfelse>
                            	, 1
                            </cfif>
							<cfif not isdefined("Form.CPTCompensacion")>
                            	, 0
                            <cfelse>
                            	, 1
                            </cfif>
						  )
					</cfquery>
			</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#Session.DSN#">
			delete from CPTransacciones
			where Ecodigo =  #Session.Ecodigo#
			  and CPTcodigo  = <cfqueryparam value="#Form.CPTcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cf_sifcomplementofinanciero action='delete'
				tabla="CPTransacciones"
				form = "form1"
				llave="#form.CPTcodigo#" />
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="CPTransacciones"
			redirect="TipoTransacciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo"
			type1="integer"
			value1="#session.Ecodigo#"
			field2="CPTcodigo"
			type2="char"
			value2="#form.CPTcodigo#">

		<cfquery datasource="#Session.DSN#">
			update CPTransacciones set
				CPTdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CPTdescripcion)#">,
				CPTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTtipo#">,
				CPTvencim = <cfif isdefined("Form.CPTvencim") and Len(Trim(Form.CPTvencim)) NEQ 0><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPTvencim#"><cfelse>null</cfif>,
				<cfif Form.CPTtipo EQ 'D' and isdefined("Form.CPTpago") and trim(Form.CPTpago) EQ 1>
					CPTpago = 1,
					BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">,
					CPTcktr = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcktr#">,
                    CPTanticipo = 0,
                <cfelseif Form.CPTtipo EQ 'D' and isdefined("Form.CPTpago") and trim(Form.CPTpago) EQ 2>
                	CPTpago = 0,
					BTid = null,
					CPTcktr = null,
                    CPTanticipo = 1,
				<cfelse>
					CPTpago = 0,
					BTid = null,
					CPTcktr = null,
                    CPTanticipo = 0,
				</cfif>
				<cfif not isdefined("Form.CPTestimacion")>
					CPTestimacion = 0,
					CPTCodigoRef  = null,
				<cfelse>
					CPTestimacion = 1,
					CPTCodigoRef  = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CPTCodigoRef)#">,
				</cfif>
				CPTafectacostoventas = <cfif isdefined("form.CPTafectacostoventas")>1<cfelse>0</cfif>,
				CPTnoflujoefe = <cfif isdefined("form.CPTnoflujoefe")>1<cfelse>0</cfif>,
				FMT01COD = <cfif isdefined("form.FMT01COD") and len(trim(form.FMT01COD))><cfqueryparam cfsqltype="char" value="#trim(form.FMT01COD)#"><cfelse>null</cfif>,
				CPTcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPTcodigoext#">,
				cuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">
                <cfif not isdefined("Form.CPTremision")>
                	, CPTremision = 0
                <cfelse>
                	, CPTremision = 1
                </cfif>
				<cfif not isdefined("Form.CPTCompensacion")>
                	, CPTCompensacion = 0
                <cfelse>
                	, CPTCompensacion = 1
                </cfif>

			where Ecodigo =  #Session.Ecodigo#
			  and CPTcodigo = <cfqueryparam value="#Form.CPTcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cf_sifcomplementofinanciero action='update'
				tabla="CPTransacciones"
				form = "form1"
				llave="#form.CPTcodigo#" />
		<cfset params= params&'&CPTcodigo='&form.CPTcodigo>
	</cfif>
</cfif>

<cfif isdefined('form.filtro_CPTcodigo') and form.filtro_CPTcodigo NEQ ''>
	<cfset params= params&'&filtro_CPTcodigo='&form.filtro_CPTcodigo>
	<cfset params= params&'&hfiltro_CPTcodigo='&form.filtro_CPTcodigo>
</cfif>
<cfif isdefined('form.filtro_CPTdescripcion') and form.filtro_CPTdescripcion NEQ ''>
	<cfset params= params&'&filtro_CPTdescripcion='&form.filtro_CPTdescripcion>
	<cfset params= params&'&hfiltro_CPTdescripcion='&form.filtro_CPTdescripcion>
</cfif>
<cfif isdefined('form.filtro_CPTtipo') and form.filtro_CPTtipo NEQ ''>
	<cfset params= params&'&filtro_CPTtipo='&form.filtro_CPTtipo>
	<cfset params= params&'&hfiltro_CPTtipo='&form.filtro_CPTtipo>
</cfif>

<cflocation url="TipoTransacciones.cfm?Pagina=#Form.Pagina##params#">