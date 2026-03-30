<!--- <cf_dump var="#form#"> --->

<cfset params = "">

<cfquery name="rsForm" datasource="#session.dsn#">
			select
				a.Ecodigo,
				a.ID_Firma,
				a.Fcodigo,
				a.Fdescripcion,
				a.NumFilas,
				a.NumColumnas,
	            a.ts_rversion
			from CGEstrCatFirma a
				where a.Ecodigo = #session.Ecodigo#
				and  a.ID_Firma = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Firma#">
	</cfquery>

	<!--- <cfif isdefined("Form.btnEnviar")>
	    <cfquery name="rsForm" datasource="#session.dsn#">
	        select
	            a.Ecodigo,
	            a.ID_Estr,
	            a.EPcodigo,
	            a.EPdescripcion,
	            a.ts_rversion
	        from CGEstrProg a
	        where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	          and a.EPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EVcodigo)#">
	    </cfquery>
	    <cfif rsForm.RecordCount EQ 0>
	    	<cfquery name="rsAltaGen" datasource="#session.dsn#">
				insert into CGEstrProg(Ecodigo,EPcodigo,EPdescripcion,BMUsucodigo)
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EPcodigo)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EPdescripcion)#">,
	                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
	                     1
						)
			</cfquery>
	    <cfelse>
	        <cf_dbtimestamp datasource="#session.dsn#"
	            table="CGEstrProg"
	            redirect="CatFirmas.cfm"
	            timestamp="#form.ts_rversion#"
	            field1="Ecodigo"
	            type1="integer"
	            value1="#session.Ecodigo#"
	            field2="ID_Estr"
	            type2="integer"
	            value2="#form.ID_Estr#">

	        <cfquery name="rsCambioGen" datasource="#session.dsn#">
			update CGEstrProg set
				EPdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPdescripcion#">)),
	            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	        </cfquery>
	    </cfif>
	    <cflocation url="CatFirmas.cfm">
	</cfif> --->

	<cfif isdefined("Form.Alta")>
		<cfloop from="1" to="#rsForm.NumFilas#" index="i">
			<cfloop from="1" to="#rsForm.NumColumnas#" index="j">
				<cfset fieldN = "nombre_">
				<cfset fieldC = "cargo_">
				<cfset valor = i*10+j>
				<cfset vNombre = trim(Form[fieldN & "" & valor])>
				<cfset vCargo = trim(Form[fieldC & "" & valor])>
				<cfquery name="Transacciones" datasource="#Session.DSN#">
					insert into CGEstrCatFirmaD(ID_Firma,Fnombre,Fcargo,Columna,Fila,BMUsucodigo)
					values ( <cfqueryparam value="#form.ID_Firma#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#vNombre#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#vCargo#">,
							 <cfqueryparam value="#j#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
							)
				</cfquery>
			</cfloop>
		</cfloop>
		<cfset params=params&"&ID_Firma="&rsForm.ID_Firma>
	<!---
	<cfelseif isdefined("Form.btneliminar")and isdefined("form.chk") and len(trim(form.chk))>
		<cfloop index="item" list="#form.chk#" delimiters=",">
			<cfset LvarEPcodigo= #item#>

			<!--- falta borrar detalles --->
	        <cfquery name="Transacciones" datasource="#Session.DSN#">
	            delete CGEstrCatFirma
	            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	            and Fcodigo  = <cfqueryparam value="#LvarEPcodigo#" cfsqltype="cf_sql_char">
	        </cfquery>
	    </cfloop> --->

	<cfelseif isdefined("Form.Cambio")>
		<cfloop from="1" to="#rsForm.NumFilas#" index="i">
			<cfloop from="1" to="#rsForm.NumColumnas#" index="j">
				<cfset fieldN = "nombre_">
				<cfset fieldC = "cargo_">
				<cfset fieldF = "firmaid_">
				<cfset valor = i*10+j>
				<cfset vNombre = trim(Form[fieldN & "" & valor])>
				<cfset vCargo  = trim(Form[fieldC & "" & valor])>
				<cfset vFirmaID = trim(Form[fieldF & "" & valor])>

				<cfquery name="reExistPos" datasource="#Session.DSN#">
					select top 1  ID_FirmaD from CGEstrCatFirmaD
					where ID_Firma = #form.ID_Firma#
						and Fila = #i#
						and Columna = #j#
				</cfquery>

				<cfif reExistPos.RecordCount GT 0 >
					<cfquery name="Transacciones" datasource="#Session.DSN#">
						update CGEstrCatFirmaD set
							Fnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vNombre#">,
							Fcargo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vCargo#">,
							BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
							where ID_FirmaD = #vFirmaID#
					</cfquery>
				<cfelse>
					<cfquery name="Transacciones" datasource="#Session.DSN#">
						insert into CGEstrCatFirmaD(ID_Firma,Fnombre,Fcargo,Columna,Fila,BMUsucodigo)
						values ( <cfqueryparam value="#form.ID_Firma#" cfsqltype="cf_sql_integer">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#vNombre#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#vCargo#">,
								 <cfqueryparam value="#j#" cfsqltype="cf_sql_integer">,
								 <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">,
								 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
								)
					</cfquery>
				</cfif>


			</cfloop>
		</cfloop>
		<cfset params=params&"&ID_Firma="&rsForm.ID_Firma>

	</cfif>

	<cflocation url="CatFirmasDet.cfm?#params#" >
