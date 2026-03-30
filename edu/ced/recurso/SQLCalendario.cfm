<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 31 de enero del 2006
	Motivo: Actualizacin de fuentes de educacin a nuevos estndares de Pantallas y Componente de Listas.
 ---> 

<cfset pagina = "1">
<cfset params="">

<cfif not isdefined('form.Nuevo')>
	<!--- Caso 1: Agregar --->
	<cfif isdefined('form.Alta')>
		<cftransaction>
		<cfquery name="rsInsertC" datasource="sdc">
			insert CalendarioDia 
				(Ccodigo, CDferiado, CDfecha, CDtitulo, CDdescripcion, CDabsoluto)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">,
					<cfif isdefined("form.CDferiado") and #form.CDferiado# NEQ "">
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDferiado#">,
					<cfelse>
						0,
					</cfif>
					convert( datetime, <cfqueryparam value="#form.CDfecha#" cfsqltype="cf_sql_varchar">, 103 ),																									
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CDtitulo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CDdescripcion#">,
					<cfif isdefined("form.CDabsoluto") and #form.CDabsoluto# NEQ "">
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDabsoluto#">)							
					<cfelse>
						0)
					</cfif>	
			<cf_dbidentity1 datasource="sdc">
		</cfquery>
		<cf_dbidentity2 datasource="#session.Edu.DSN#" name="rsInsertC">
		<cfset form.CDcodigo = rsInsertC.identity>
		</cftransaction>
		<cfquery name="rsPagina" datasource="sdc">
			SELECT CDcodigo
			FROM  CalendarioDia 
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
			  <cfif isdefined('form.FechaIni') and LEN(TRIM(form.FechaIni))>
			  	and CDfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaIni)#">
			  </cfif>
			  <cfif isdefined('form.FechaFin') and LEN(TRIM(form.FechaFin))>
			  	and CDfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaFin)#">
			  </cfif>
			  <cfif isdefined('form.Filtro_CDfecha') and LEN(TRIM(form.Filtro_CDfecha))>
			  	<cfif isdefined('form.FechasMayores')>
				and CDfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Filtro_CDfecha)#">
				<cfelse>
			    and CDfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Filtro_CDfecha)#">
				</cfif>
			  </cfif>
			  <cfif isdefined('form.Filtro_CDabsolutoicono') and form.Filtro_CDabsolutoicono GTE 0>
			  	and CDabsoluto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Filtro_CDabsolutoicono#">
			  </cfif>
			  <cfif isdefined('form.Filtro_CDferiadoicono') and form.Filtro_CDferiadoicono GTE 0>
			  	and CDferiado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Filtro_CDferiadoicono#">
			  </cfif>
			  <cfif isdefined('form.Filtro_CDtitulo') and LEN(TRIM(form.Filtro_CDtitulo))>
			  	and CDtitulo like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.Filtro_CDtitulo#%">
			  </cfif>
			  order by CDfecha
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.CDcodigo EQ form.CDcodigo>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset pagina = Ceiling(row / form.MaxRows)>
		<cfset params=params&"CDcodigo="&rsInsertC.identity>
	<!--- Caso 2: Cambio --->
	<cfelseif isdefined('form.Cambio')>
		<cfquery name="rsUpdateC" datasource="sdc">
			update CalendarioDia set 
					CDferiado=
								<cfif isdefined("form.CDferiado") and #form.CDferiado# NEQ "">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDferiado#">,
								<cfelse>
									0,
								</cfif>
					CDfecha=convert( datetime, <cfqueryparam value="#form.CDfecha#" cfsqltype="cf_sql_varchar">, 103 ),
					CDtitulo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CDtitulo#">,
					CDdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CDdescripcion#">,
					CDabsoluto=
								<cfif isdefined("form.CDabsoluto") and #form.CDabsoluto# NEQ "">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDabsoluto#">							
								<cfelse>
									0
								</cfif>	
				where CDcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">	
		</cfquery>
		<cfquery name="rsPagina" datasource="sdc">
			SELECT CDcodigo
			FROM  CalendarioDia 
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
			  <cfif isdefined('form.FechaIni') and LEN(TRIM(form.FechaIni))>
			  	and CDfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaIni)#">
			  </cfif>
			  <cfif isdefined('form.FechaFin') and LEN(TRIM(form.FechaFin))>
			  	and CDfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaFin)#">
			  </cfif>
			  <cfif isdefined('form.Filtro_CDfecha') and LEN(TRIM(form.Filtro_CDfecha))>
			  	<cfif isdefined('form.FechasMayores')>
				and CDfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Filtro_CDfecha)#">
				<cfelse>
			    and CDfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Filtro_CDfecha)#">
				</cfif>
			  </cfif>
			  <cfif isdefined('form.Filtro_CDabsolutoicono') and form.Filtro_CDabsolutoicono GTE 0>
			  	and CDabsoluto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Filtro_CDabsolutoicono#">
			  </cfif>
			  <cfif isdefined('form.Filtro_CDferiadoicono') and form.Filtro_CDferiadoicono GTE 0>
			  	and CDferiado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Filtro_CDferiadoicono#">
			  </cfif>
			  <cfif isdefined('form.Filtro_CDtitulo') and LEN(TRIM(form.Filtro_CDtitulo))>
			  	and CDtitulo like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.Filtro_CDtitulo#%">
			  </cfif>
			  order by CDfecha
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 50>
			<cfloop query="rsPagina">
				<cfif rsPagina.CDcodigo EQ form.CDcodigo>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset pagina = Ceiling(row / form.MaxRows)>
		<cfset params=params&"CDcodigo="&form.CDcodigo>
	<cfelseif isdefined('form.Baja')>
		<!--- Caso 4: Borrar --->
		<cfquery name="rsDeleteC" datasource="sdc">
			delete CalendarioDia 
			where CDcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined('form.FechasMayores')><cfset params = params&"&Filtro_FechasMayores=" & form.FechasMayores></cfif>
<cflocation url="calendario.cfm?Pagina=#pagina#&Filtro_CDfecha=#Form.Filtro_CDfecha#&Filtro_CDabsolutoIcono=#Form.Filtro_CDabsolutoIcono#&Filtro_CDferiadoIcono=#Form.Filtro_CDferiadoIcono#&Filtro_CDtitulo=#Form.Filtro_CDtitulo#&HFiltro_CDfecha=#Form.Filtro_CDfecha#&HFiltro_CDabsolutoIcono=#Form.Filtro_CDabsolutoIcono#&HFiltro_CDferiadoIcono=#Form.Filtro_CDferiadoIcono#&HFiltro_CDtitulo=#form.Filtro_CDtitulo#&FechaIni=#form.FechaIni#&FechaFin=#form.FechaFin#&#params#">
<!--- Caso 5: Limpiar Calendario del form = formLimpiaCalendari
			<cfelseif isdefined("Form.btnLimpiaCalendario")>			
				<cfif isdefined("Form.LimpiaCcodigo") AND #Form.LimpiaCcodigo# NEQ "" >
					delete CalendarioDia
					where CDabsoluto=1
						and Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LimpiaCcodigo#">				
						<cfif isdefined("Form.LimpiAnio") AND #Form.LimpiAnio# NEQ "-1" >
							and datepart(yy,CDfecha) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LimpiAnio#">
						</cfif>
						
					<cfset modo="ALTA">									
				</cfif>												
			</cfif>o--->