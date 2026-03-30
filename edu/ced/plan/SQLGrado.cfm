<cfset params="">
<cfif not isdefined("Form.Nuevo")>

		<cfif isdefined("Form.Alta")>
			
			<cfset promo = ListToArray(Form.GradoPromo,"|")>
			<cftransaction>
					<cfquery name="rsInsert" datasource="#Session.Edu.DSN#">
		
						if not exists ( select 1 from Grado a, Nivel b
							where a.Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
							  and b.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
							  and rtrim(ltrim(a.Gdescripcion)) = <cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">
							  and a.Ncodigo = b.Ncodigo
						)
						begin
							declare @cont int
							select @cont = isnull(max(a.Gorden),0)+10 
							from Grado a, Nivel b
							where a.Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
							  and b.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
							  and a.Ncodigo = b.Ncodigo
						
							insert into Grado (Ncodigo, Gdescripcion, Gorden, Gngrupos, Gnalumnos, Gtiponum, Gpromogrado, Gpromonivel)
							values
								(
									<cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">,
									<cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">,
									<!--- <cfqueryparam value="#Form.Ganual#" cfsqltype="cf_sql_smallint">, --->
									<cfif #len(trim(Form.Gorden))# NEQ 0 >
										<cfqueryparam value="#Form.Gorden#" cfsqltype="cf_sql_smallint">,
									<cfelse>
										@cont,	
									</cfif>
									<cfif isdefined("Form.Gngrupos") and Len(Trim(form.Gngrupos)) NEQ 0>
										<cfqueryparam value="#Form.Gngrupos#" cfsqltype="cf_sql_numeric">,
									<cfelse>
										0,
									</cfif>
									<cfif isdefined("Form.Gnalumnos") and Len(Trim(form.Gnalumnos)) NEQ 0>
										<cfqueryparam value="#Form.Gnalumnos#" cfsqltype="cf_sql_numeric">,
									<cfelse>
										0,
									</cfif>							
									<cfqueryparam value="#Form.Gtiponum#" cfsqltype="cf_sql_varchar">,
									<cfif Form.GradoPromo NEQ "|">
										<cfqueryparam value="#promo[2]#" cfsqltype="cf_sql_numeric">,
										<cfqueryparam value="#promo[1]#" cfsqltype="cf_sql_numeric">
									<cfelse>
										null,
										null
									</cfif>
								)
								<cf_dbidentity1 conexion="#Session.Edu.DSN#">
						end
							
					</cfquery>
					<cfif  isdefined("rsInsert")>
						<cf_dbidentity2 conexion="#Session.Edu.DSN#" name="rsInsert">
					</cfif>
				<cfquery name="rsPagina" datasource="#Session.Edu.DSN#">
					SELECT Gcodigo
					from Grado a
						inner join Nivel b 
						on b.Ncodigo = a.Ncodigo
						and b.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
					where 1=1
						<cfif isdefined("Form.Filtro_Gdescripcion") and len(trim(Form.Filtro_Gdescripcion))>
							 and a.Gdescripcion like '%#Form.Filtro_Gdescripcion#%'
						</cfif>
						<cfif isdefined("Form.Filtro_Gorden") and len(trim(Form.Filtro_Gorden))>
							and a.Gorden >= #Form.Filtro_Gorden#
						</cfif>
				</cfquery>
				<cfif rsPagina.RecordCount LT 500>
					<cfloop query="rsPagina">
						<cfif rsPagina.Gcodigo EQ rsInsert.identity>
							<cfset row = rsPagina.currentrow>
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>
				<cfset pagina = Ceiling(row / form.MaxRows)>
				<cfset params = params&"&Gcodigo="&rsInsert.identity>
			</cftransaction>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="del_Grado" datasource="#Session.Edu.DSN#">

				delete from Grado
				where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
				  and Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">

			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfset promo = ListToArray(Form.GradoPromo,"|")>
			
			<cfquery name="upd_Grado" datasource="#Session.Edu.DSN#">
				declare @cont int
				select @cont = isnull(max(a.Gorden),0)+10 
				from Grado a, Nivel b
				where a.Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
				  and b.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and a.Gcodigo  = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
				  and a.Ncodigo = b.Ncodigo

				if not exists ( select 1 from Grado a, Nivel b, Grupo c
						where a.Ncodigo = <cfqueryparam value="#Form._Ncodigo#" cfsqltype="cf_sql_numeric">
						  and b.CEcodigo =  <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
						  and c.Gcodigo  = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
						  and a.Ncodigo = b.Ncodigo
						  and b.Ncodigo = c.Ncodigo
						  and a.Gcodigo = c.Gcodigo
					)
				begin
					if not exists ( select 1 from Materia 
									where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">	
					)
					begin
						if not exists ( select 1 from HorarioAplica  
										where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">	
						 )
						 begin
					     	update Grado set
								Gdescripcion = <cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">,
								Ganual = <cfqueryparam value="#Form.Ganual#" cfsqltype="cf_sql_smallint">,
								Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">,
								<cfif #len(trim(Form.Gorden))# NEQ 0 >
									Gorden = <cfqueryparam value="#Form.Gorden#" cfsqltype="cf_sql_smallint">,
								<cfelse>
									Gorden = @cont,	
								</cfif>
								<cfif isdefined("Form.Gngrupos") and Len(Trim(form.Gngrupos)) NEQ 0>
									Gngrupos=<cfqueryparam value="#Form.Gngrupos#" cfsqltype="cf_sql_numeric">,
								<cfelse>
									Gngrupos=0,
								</cfif>
								<cfif isdefined("Form.Gnalumnos") and Len(Trim(form.Gnalumnos)) NEQ 0>
									Gnalumnos=<cfqueryparam value="#Form.Gnalumnos#" cfsqltype="cf_sql_numeric">,
								<cfelse>
									Gnalumnos=0,
								</cfif>
								Gtiponum=<cfqueryparam value="#Form.Gtiponum#" cfsqltype="cf_sql_varchar">,
								<cfif Form.GradoPromo NEQ "|">
									Gpromogrado = <cfqueryparam value="#promo[2]#" cfsqltype="cf_sql_numeric">,
									Gpromonivel = <cfqueryparam value="#promo[1]#" cfsqltype="cf_sql_numeric">
								<cfelse>
									Gpromogrado = null,
									Gpromonivel = null
								</cfif>
							where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
							  and Ncodigo = <cfqueryparam value="#Form._Ncodigo#" cfsqltype="cf_sql_numeric">
						 end
						 else
						 begin
								update Grado set
									Gdescripcion = <cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">,
									Ganual = <cfqueryparam value="#Form.Ganual#" cfsqltype="cf_sql_smallint">,
									<cfif #len(trim(Form.Gorden))# NEQ 0 >
										Gorden = <cfqueryparam value="#Form.Gorden#" cfsqltype="cf_sql_smallint">,
									<cfelse>
										Gorden = @cont,	
									</cfif>
									<cfif isdefined("Form.Gngrupos") and Len(Trim(form.Gngrupos)) NEQ 0>
										Gngrupos=<cfqueryparam value="#Form.Gngrupos#" cfsqltype="cf_sql_numeric">,
									<cfelse>
										Gngrupos=0,
									</cfif>
									<cfif isdefined("Form.Gnalumnos") and Len(Trim(form.Gnalumnos)) NEQ 0>
										Gnalumnos=<cfqueryparam value="#Form.Gnalumnos#" cfsqltype="cf_sql_numeric">,
									<cfelse>
										Gnalumnos=0,
									</cfif>
									Gtiponum=<cfqueryparam value="#Form.Gtiponum#" cfsqltype="cf_sql_varchar">,
									<cfif Form.GradoPromo NEQ "|">
										Gpromogrado = <cfqueryparam value="#promo[2]#" cfsqltype="cf_sql_numeric">,
										Gpromonivel = <cfqueryparam value="#promo[1]#" cfsqltype="cf_sql_numeric">
									<cfelse>
										Gpromogrado = null,
										Gpromonivel = null
									</cfif>
								where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
								  and Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">						 	
						 end
					 end
					 else
					 begin
						update Grado set
							Gdescripcion = <cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">,
							Ganual = <cfqueryparam value="#Form.Ganual#" cfsqltype="cf_sql_smallint">,
							<cfif #len(trim(Form.Gorden))# NEQ 0 >
								Gorden = <cfqueryparam value="#Form.Gorden#" cfsqltype="cf_sql_smallint">,
							<cfelse>
								Gorden = @cont,	
							</cfif>
							<cfif isdefined("Form.Gngrupos") and Len(Trim(form.Gngrupos)) NEQ 0>
								Gngrupos=<cfqueryparam value="#Form.Gngrupos#" cfsqltype="cf_sql_numeric">,
							<cfelse>
								Gngrupos=0,
							</cfif>
							<cfif isdefined("Form.Gnalumnos") and Len(Trim(form.Gnalumnos)) NEQ 0>
								Gnalumnos=<cfqueryparam value="#Form.Gnalumnos#" cfsqltype="cf_sql_numeric">,
							<cfelse>
								Gnalumnos=0,
							</cfif>
							Gtiponum=<cfqueryparam value="#Form.Gtiponum#" cfsqltype="cf_sql_varchar">,
							<cfif Form.GradoPromo NEQ "|">
								Gpromogrado = <cfqueryparam value="#promo[2]#" cfsqltype="cf_sql_numeric">,
								Gpromonivel = <cfqueryparam value="#promo[1]#" cfsqltype="cf_sql_numeric">
							<cfelse>
								Gpromogrado = null,
								Gpromonivel = null
							</cfif>
						where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
						  and Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
					 end
				end
				else
				begin
					update Grado set
						Gdescripcion = <cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">,
						Ganual = <cfqueryparam value="#Form.Ganual#" cfsqltype="cf_sql_smallint">,
						<cfif #len(trim(Form.Gorden))# NEQ 0 >
							Gorden = <cfqueryparam value="#Form.Gorden#" cfsqltype="cf_sql_smallint">,
						<cfelse>
							Gorden = @cont,	
						</cfif>
						<cfif isdefined("Form.Gngrupos") and Len(Trim(form.Gngrupos)) NEQ 0>
							Gngrupos=<cfqueryparam value="#Form.Gngrupos#" cfsqltype="cf_sql_numeric">,
						<cfelse>
							Gngrupos=0,
						</cfif>
						<cfif isdefined("Form.Gnalumnos") and Len(Trim(form.Gnalumnos)) NEQ 0>
							Gnalumnos=<cfqueryparam value="#Form.Gnalumnos#" cfsqltype="cf_sql_numeric">,
						<cfelse>
							Gnalumnos=0,
						</cfif>
						Gtiponum=<cfqueryparam value="#Form.Gtiponum#" cfsqltype="cf_sql_varchar">,
						<cfif Form.GradoPromo NEQ "|">
							Gpromogrado = <cfqueryparam value="#promo[2]#" cfsqltype="cf_sql_numeric">,
							Gpromonivel = <cfqueryparam value="#promo[1]#" cfsqltype="cf_sql_numeric">
						<cfelse>
							Gpromogrado = null,
							Gpromonivel = null
						</cfif>
					where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
					  and Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">

				end
				</cfquery>
				<cfset params=params&"&Gcodigo="&Form.Gcodigo>
				<cfset params=params&"&Ncodigo="&Form.Ncodigo>
				<cfset pagina = form.Pagina>
	
	</cfif>
</cfif>
<cflocation url="Grado.cfm?Pagina=#pagina#&Filtro_Gdescripcion=#Form.Filtro_Gdescripcion#&Filtro_Gorden=#Form.Filtro_Gorden#&HFiltro_Gdescripcion=#Form.Filtro_Gdescripcion#&HFiltro_Gorden=#Form.Filtro_Gorden##params#">

<!--- <form action="Grado.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Ncodigo" type="hidden" value="<cfif isdefined("Form.Ncodigo")><cfoutput>#Form.Ncodigo#</cfoutput></cfif>">
	<input name="Gcodigo" type="hidden" value="<cfif isdefined("Form.Gcodigo")><cfoutput>#Form.Gcodigo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
 --->
