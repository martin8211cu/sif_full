<cfparam name="modo" default="ALTA">
<cfset params="">
<cfset action = "Articulos.cfm">


<cfif not isdefined("Form.Nuevo") and not isdefined("Form.Existencia")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsArticulos" datasource="#session.DSN#">
			select 1
			from Articulos
			where Acodigo=<cfqueryparam value="#Form.Acodigo#" cfsqltype="cf_sql_varchar">
			and Ecodigo= #session.Ecodigo#
		</cfquery>

		<cfif isdefined('rsArticulos') and rsArticulos.recordCount EQ 0>
			<cftransaction>
				<cfquery name="rsA_Articulos" datasource="#session.DSN#">
					insert INTO Articulos (
						Ecodigo,
						Acodigo,
						Acodalterno,
						Ucodigo,
						Ccodigo,
						Adescripcion,
						Afecha,
						Acosto,
						Aconsumo,
						AFMid,
						AFMMid,
						CAid,
						Atipocosteo,
						Ucomprastd,
						Icodigo,
						Areqcert,
						BMUsucodigo,
                        descalterna,
                        Observacion
					<cfif isdefined("form.estado") and len(trim(form.estado))>
					,Aestado
					</cfif>
                    ,codIEPS,afectaIVA,
					ClaveSAT
					)
					values(  #session.Ecodigo# ,
							<cfqueryparam value="#Form.Acodigo#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Form.Acodalterno#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Form.Ucodigo#" cfsqltype="cf_sql_varchar">,
							<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo))><cfqueryparam value="#Form.Ccodigo#" cfsqltype="cf_sql_integer"><cfelse>0</cfif>,
							<cfqueryparam value="#Form.Adescripcion#" cfsqltype="cf_sql_varchar">,
							<cf_dbfunction name="now">,
							<cfqueryparam value="#Form.Acosto#" cfsqltype="cf_sql_money">,
							<cfif isdefined("form.Aconsumo")>1<cfelse>0</cfif>,
							<cfif isdefined("form.AFMid") and len(trim(form.AFMid))><cfqueryparam value="#Form.AFMid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
							<cfif isdefined("form.AFMMid") and len(trim(form.AFMMid))><cfqueryparam value="#Form.AFMMid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
							<cfif isdefined("form.CAid") and len(trim(form.CAid))><cfqueryparam value="#Form.CAid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
							<cfif isdefined("form.LAtipocosteo") and len(trim(form.LAtipocosteo))><cfqueryparam value="#Form.LAtipocosteo#" cfsqltype="cf_sql_integer"><cfelse>0</cfif>,
							<cfif isdefined("form.Ucomprastd") and len(trim(form.Ucomprastd))><cfqueryparam value="#Form.Ucomprastd#" cfsqltype="cf_sql_numeric" scale="2"><cfelse>1</cfif>,
							<cfif isdefined("form.Icodigo") and len(trim(form.Icodigo))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Icodigo#"><cfelse>null</cfif>,
							<cfif isdefined("form.Areqcert")>
								<cfqueryparam cfsqltype="cf_sql_integer" value="1">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_integer" value="0">
							</cfif>
							  ,#session.Usucodigo#
                              ,<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1024" value="#Form.descalterna#"  voidNull>
                              ,<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255"  value="#Form.observacion#"  voidNull>
							<cfif isdefined("form.estado") and len(trim(form.estado))>
								,<cfqueryparam value="#Form.estado#" cfsqltype="cf_sql_numeric">
							</cfif>
                            ,<cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.codIEPS#">,
                            <cfif isdefined("form.afectaIVA") and #LEN(form.codIEPS)#>1<cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CSATCodigo#" null="#len(trim(Form.CSATCodigo)) eq 0#">
						)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsA_Articulos">

                <cfif form.consec eq 1>
                	<cfquery name="rsSelectCla" datasource="#session.DSN#">
                        select coalesce(Cconsecutivo,0) as Cconsecutivo from Clasificaciones where Ccodigo = <cfqueryparam value="#Form.Ccodigo#" cfsqltype="cf_sql_integer">
                        and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                    </cfquery>

                    <cfquery name="rsUpdateCla" datasource="#session.DSN#">
                        update Clasificaciones set Cconsecutivo = (#rsSelectCla.Cconsecutivo# + 1)
                        where Ccodigo = <cfqueryparam value="#Form.Ccodigo#" cfsqltype="cf_sql_integer">
                        and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                    </cfquery>
                </cfif>
			</cftransaction>
		</cfif>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.DSN#">
			delete from ImagenArt
			where Ecodigo= #session.Ecodigo#
			  and Aid = <cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			delete from Articulos
			where Ecodigo =  #Session.Ecodigo#
			  and Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cf_sifcomplementofinanciero action='delete'
					tabla="Articulos"
					form = "Articulos"
					llave="#form.Aid#" />

		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="Articulos"
			redirect="Articulos.cfm?Aid=#Form.Aid#"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#Session.Ecodigo#"
			field2="Aid,numeric,#form.Aid#">

		<cfquery datasource="#session.DSN#">
			 update Articulos
			 set Acodalterno = <cfqueryparam value="#Form.Acodalterno#" cfsqltype="cf_sql_varchar">,
				   Ucodigo = <cfqueryparam value="#Form.Ucodigo#" cfsqltype="cf_sql_varchar">,
				   Ccodigo = <cfqueryparam value="#Form.Ccodigo#" cfsqltype="cf_sql_integer">,
				   Adescripcion = <cfqueryparam value="#Form.Adescripcion#" cfsqltype="cf_sql_varchar">,
				   Acosto = <cfqueryparam value="#Form.Acosto#" cfsqltype="cf_sql_money">,
				   Aconsumo = <cfif isdefined("form.Aconsumo")>1<cfelse>0</cfif>,
				   AFMid = <cfif isdefined("form.AFMid") and len(trim(form.AFMid))><cfqueryparam value="#Form.AFMid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				   AFMMid = <cfif isdefined("form.AFMMid") and len(trim(form.AFMMid))><cfqueryparam value="#Form.AFMMid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				   CAid = <cfif isdefined("form.CAid") and len(trim(form.CAid))><cfqueryparam value="#Form.CAid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				   Atipocosteo = <cfif isdefined("form.LAtipocosteo") and len(trim(form.LAtipocosteo))><cfqueryparam value="#Form.LAtipocosteo#" cfsqltype="cf_sql_integer"><cfelse>0</cfif>,
				   Ucomprastd  = <cfif isdefined("form.Ucomprastd") and len(trim(form.Ucomprastd))><cfqueryparam value="#Form.Ucomprastd#" cfsqltype="cf_sql_numeric" scale="2"><cfelse>1</cfif>,
				   Icodigo = <cfif isdefined("form.Icodigo") and len(trim(form.Icodigo))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Icodigo#"><cfelse>null</cfif>,
				   <cfif isdefined("form.Areqcert")>
				   Areqcert = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				   <cfelse>
				   Areqcert = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				   </cfif>
                   , BMUsucodigo = #session.Usucodigo#
                   ,descalterna  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1024" value="#Form.descalterna#"  voidNull>
                   ,Observacion  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255"  value="#Form.observacion#"  voidNull>
				   , Aestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.estado#" null="#not len(trim(form.estado))#">
                   ,codIEPS   = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.codIEPS#">
                   ,afectaIVA = <cfif isdefined("form.afectaIVA") and #LEN(form.codIEPS)#>1<cfelse>0</cfif>
				   , ClaveSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CSATCodigo#" null="#len(trim(Form.CSATCodigo)) eq 0#">
			 where Ecodigo =  #Session.Ecodigo#
			   and Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cf_sifcomplementofinanciero action='update'
					tabla="Articulos"
					form = "Articulos"
					llave="#form.Aid#" />
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
	<cfif isdefined("Form.Nuevo")>
		<cfset params= params&'&btnNuevo=btnNuevo'>
	</cfif>
	<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>
		<cfset params= params&'&filtro_Acodigo='&form.filtro_Acodigo>
		<cfset params= params&'&hfiltro_Acodigo='&form.filtro_Acodigo>
	</cfif>
	<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>
		<cfset params= params&'&filtro_Acodalterno='&form.filtro_Acodalterno>
		<cfset params= params&'&hfiltro_Acodalterno='&form.filtro_Acodalterno>
	</cfif>
	<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>
		<cfset params= params&'&filtro_Adescripcion='&form.filtro_Adescripcion>
		<cfset params= params&'&hfiltro_Adescripcion='&form.filtro_Adescripcion>
	</cfif>

	<cfif not isdefined('form.Regresar') and not isdefined('form.Baja')>
		<cfif isdefined("rsA_Articulos.identity")>
			<cfset params= params&'&Aid=' & rsA_Articulos.identity>
		<cfelseif isdefined("form.Cambio")>
			<cfset params= params&'&Aid=' & form.Aid>
		</cfif>
	</cfif>

	<cflocation url="articulos-lista.cfm?Pagina=#Form.Pagina##params#">
</cfoutput>