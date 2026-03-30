<cfset action = "SubPeriodoEscolar.cfm">

<cfif not isdefined("form.Nuevo") and not isdefined("form.NuevoDet")and not isdefined("form.Lista")>
		
		<cfset modo="CAMBIO">
		
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("Form.Alta")>
			
			<cfquery name="rsAgregaE" datasource="#Session.Edu.DSN#">
				declare @cont int, @SPEcodigo numeric
				select @cont = isnull(max(a.SPEorden),0)+10 
				from SubPeriodoEscolar a, PeriodoEscolar b, Nivel c 
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
				  and a.PEcodigo = b.PEcodigo 
				  and b.Ncodigo = c.Ncodigo
				  and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				
				insert SubPeriodoEscolar (PEcodigo, SPEorden, SPEdescripcion, SPEfechafin , SPEfechainicio )
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">,
							<cfif #len(trim(Form.SPEorden))# NEQ 0 >
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#form.SPEorden#">,
							<cfelse>
								@cont,	
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPEdescripcion#">,
							convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPEfechafin#">, 103),
							convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPEfechainicio#">, 103) 
							)
				select @SPEcodigo = @@identity
				
				<!--- Rutina dada por el Ing. Oscar Bonilla, MBA, SOIN Costa Rica, 18/12/2002 --->
				insert into PeriodoOcurrencia (SPEcodigo, PEcodigo, PEevaluacion, POfechainicio,POfechafin,POvigente)
				select sp.SPEcodigo, sp.PEcodigo, pe.PEcodigo,
						-- POfechainicio: inicio+(final-inicio+1)/N*(i-1), donde N=CantidadPeriodos, i=ConsecutivoPeriodo
				dateadd(dd,	convert(int,(datediff(dd,sp.SPEfechainicio,sp.SPEfechafin)+1.0)*1.0 /(select count(*)*1.0
				from PeriodoEvaluacion N
				where N.Ncodigo = p.Ncodigo) * (select count(*)*1.0 
												from PeriodoEvaluacion i
												where i.Ncodigo = p.Ncodigo
												  and (i.PEorden < pe.PEorden
												  or (i.PEorden = pe.PEorden and i.PEcodigo < pe.PEcodigo))
												)
				), 
				sp.SPEfechainicio),
				-- POfechafin: inicio+((final-inicio+1)/N*(i-0) - 1), donde N=CantidadPeriodos, i=ConsecutivoPeriodo
				dateadd(dd, convert(int,(datediff(dd,sp.SPEfechainicio,sp.SPEfechafin)+1.0)*1.0 
				/(select count(*)*1.0
				from PeriodoEvaluacion N
				where N.Ncodigo = p.Ncodigo
				)
				*(select count(*)*1.0
				from PeriodoEvaluacion i
				where i.Ncodigo = p.Ncodigo
				and (i.PEorden < pe.PEorden
				or (i.PEorden = pe.PEorden and i.PEcodigo <=
				pe.PEcodigo))
				)
				) - 1, sp.SPEfechainicio),
				-- POvigente: Para uso futuro
				0
				from PeriodoEscolar p, SubPeriodoEscolar sp, PeriodoEvaluacion pe
				where sp.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">
				and sp.SPEcodigo= @@identity
				and p.Ncodigo = pe.Ncodigo
				and p.PEcodigo = sp.PEcodigo
				order by p.PEcodigo, sp.SPEcodigo, p.Ncodigo, pe.PEorden, pe.PEcodigo
				
				select @SPEcodigo as id
				
			</cfquery>
			<cfif not isdefined("rsAgregaE.id")>
				<cfset Request.Error.Url = "SubPeriodoEscolar.cfm?Pagina=#form.pagina#&Filtro_SPEdescripcion=#Form.Filtro_SPEdescripcion#&Filtro_SPEfechainicio=#Form.Filtro_SPEfechainicio#&Filtro_SPEfechainicio=#Form.Filtro_SPEfechafin#&Filtro_Vigente=#Form.Filtro_Vigente#&Filtro_FechasMayores=#Form.Filtro_FechasMayores#">
				<cfthrow message="Error: Ya existe un Curso Lectivo con la misma descripcion que esta tratando de agregar">	
			</cfif>
		<!--- Caso 1.1: Cambia Encabezado --->
		<cfelseif isdefined("Form.Cambio")>
			<cftransaction>
			<cfquery name="rsCambiarE" datasource="#Session.Edu.DSN#">
				declare @cont int
				select @cont = isnull(max(a.SPEorden),0)+10 
				from SubPeriodoEscolar a, PeriodoEscolar b, Nivel c 
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
				  and b.Ncodigo = c.Ncodigo
				  and a.PEcodigo = b.PEcodigo 
				  and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				  and a.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SPEcodigo#">
				  
				update SubPeriodoEscolar
				set SPEdescripcion = <cfqueryparam value="#form.SPEdescripcion#" cfsqltype="cf_sql_varchar">,
				<cfif #len(trim(Form.SPEorden))# NEQ 0 >
					SPEorden = <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.SPEorden#">,
				<cfelse>
					SPEorden = @cont,
				</cfif>
				SPEfechafin = convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPEfechafin#">, 103),
				SPEfechainicio = convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPEfechainicio#">, 103) 
				where SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SPEcodigo#">
				  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			</cfquery>
			</cftransaction>	
		<!--- Caso 1.2: Borrar un Encabezado del Sub periodo --->
		<cfelseif isdefined("Form.Baja")>	
			<cftransaction>
			<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ "" >
				<cfquery name="rsBorrarE" datasource="#Session.Edu.DSN#">
				  	delete PeriodoVigente
					where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
					  and SPEcodigo = <cfqueryparam value="#form.SPEcodigo#" cfsqltype="cf_sql_numeric">
					  
				  	delete PeriodoOcurrencia
					where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
					  and SPEcodigo= <cfqueryparam value="#form.SPEcodigo#" cfsqltype="cf_sql_numeric">
					  
					delete SubPeriodoEscolar 
					where PEcodigo=<cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">				
					  and SPEcodigo=<cfqueryparam value="#form.SPEcodigo#" cfsqltype="cf_sql_numeric">				
				</cfquery>
			</cfif>
			</cftransaction>
		
		<!--- Caso 2: Agregar Detalle de Sub periodo--->
		<cfelseif isdefined("Form.AltaDet")>
			
			<cfif isdefined("Form.SPEcodigo") AND Form.SPEcodigo NEQ "" >
				<cftransaction>
					<cfquery name="rsAgregarD" datasource="#Session.Edu.DSN#">	
						
						<cfif isdefined("form.POvigente")>
						update PeriodoOcurrencia 
						set POvigente = 0 
						where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">	
						  
						delete PeriodoVigente
						where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
						
						insert PeriodoVigente (Ncodigo,SPEcodigo,PEcodigo, PEevaluacion)
						select Ncodigo, <cfqueryparam value="#form.SPEcodigo#" cfsqltype="cf_sql_numeric">, PEcodigo, <cfqueryparam value="#form.PEevaluacion#" cfsqltype="cf_sql_numeric">
						from PeriodoEscolar 
						where PEcodigo = <cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
						</cfif>
						insert PeriodoOcurrencia (SPEcodigo,PEcodigo, PEevaluacion, POfechainicio, POfechafin, POvigente)
						values (<cfqueryparam value="#form.SPEcodigo#" cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#form.PEevaluacion#" cfsqltype="cf_sql_numeric">,
								convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.POfechainicio#">, 103),
								convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.POfechafin#">, 103),							
								<cfif isdefined("form.POvigente")>
									1)
								<cfelse>
									0)	
								</cfif>
						select  @@identity as id
						
					</cfquery>
				</cftransaction>	
				<cfif not isdefined("rsAgregarD.id")>
					<cfset Request.Error.Url = "SubPeriodoEscolar.cfm?Pagina=#form.pagina#&Filtro_SPEdescripcion=#Form.Filtro_SPEdescripcion#&Filtro_SPEfechainicio=#Form.Filtro_SPEfechainicio#&Filtro_SPEfechainicio=#Form.Filtro_SPEfechafin#&Filtro_Vigente=#Form.Filtro_Vigente#&Filtro_FechasMayores=#Form.Filtro_FechasMayores#">
					<cfthrow message="Error: Ya existe el Periodo de Evaluación que esta tratando de agregar">	
				</cfif>		
			</cfif>
		
		<!--- Caso 2.1: Modificar Detalle del Sub Periodo --->			
		<cfelseif isdefined("Form.CambioDet")>
			<cftransaction>
			<cfquery name="rsCambiarD" datasource="#Session.Edu.DSN#">
				<cfif isdefined("form.POvigente")>
					update PeriodoOcurrencia 
					set POvigente = 0 
					where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">	
					  
				  	delete PeriodoVigente
					where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
					
					insert PeriodoVigente (Ncodigo,SPEcodigo,PEcodigo, PEevaluacion)
					select Ncodigo, <cfqueryparam value="#form.SPEcodigo#" cfsqltype="cf_sql_numeric">, PEcodigo, <cfqueryparam value="#form.PEevaluacion#" cfsqltype="cf_sql_numeric">
					from PeriodoEscolar 
					where PEcodigo = <cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
				</cfif>

				update PeriodoOcurrencia 
				   set POfechainicio=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.POfechainicio#">,
					   POfechafin=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.POfechafin#">
					<cfif isdefined("form.POvigente")>
						, POvigente = 1
					</cfif>
					where SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SPEcodigo#">
					  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
					  and PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEevaluacion#">
			</cfquery>
			</cftransaction>
			
		<!--- Caso 2.2: Borrar detalle de tabla de Evaluacion --->
		<cfelseif isdefined("Form.BajaDet")>
			<cftransaction>
			<cfquery name="rsBorrarD" datasource="#Session.Edu.DSN#">
				delete PeriodoOcurrencia 
				where SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SPEcodigo#">
				  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				  and PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEevaluacion#">
			</cfquery>
			</cftransaction>
		</cfif>				
</cfif>


<!--- En caso de que se agrague un detalle y encabezado, se asigna a la varible form --->
<cfif isdefined("Form.Alta")>
	<cfset Form.SPEcodigo = rsAgregaE.id>
</cfif>
<cfif isdefined("Form.AltaDet")>
	<cfset form.PEevaluacion = rsAgregarD.id>
</cfif>

<!--- Concatena las variables que van a ser enviadas por la URL --->	

<!---Páginas--->
<cfset paramsPagina="">
<cfif isdefined("form.Pagina")>
	<cfset paramsPagina="Pagina="&Form.Pagina>
</cfif>
<cfset paramsPaginaD="">
<cfif isdefined("form.Pagina2")>
	<cfset paramsPaginaD="&Pagina2="&Form.Pagina2>
</cfif>

<!---ids--->
<cfset paramsId="">
<cfif isdefined("form.SPEcodigo")>
	<cfset paramsId= "&SPEcodigo="&Form.SPEcodigo>
</cfif>
<cfif isdefined("form.PEcodigo")>
	<cfset paramsId= paramsId & "&PEcodigo="&Form.PEcodigo>
</cfif>

<cfset paramsIdD="">
<cfif isdefined("form.PEevaluacion")>
	<cfset paramsIdD= "&PEevaluacion="&Form.PEevaluacion>
</cfif>
<!---FILTROS--->
<!--- filtro lista principal--->
<cfset paramsFiltro = "">
<cfif isdefined("form.Filtro_SPEdescripcion") and len(trim(form.Filtro_SPEdescripcion)) neq 0>
	<cfset paramsFiltro="&Filtro_SPEdescripcion="&form.Filtro_SPEdescripcion>
	<cfset paramsFiltro= paramsFiltro & "&HFiltro_SPEdescripcion="&form.Filtro_SPEdescripcion>
</cfif>
<cfif isdefined("form.Filtro_SPEfechainicio") and len(trim(form.Filtro_SPEfechainicio)) neq 0>
	<cfset paramsFiltro= paramsFiltro & "&Filtro_SPEfechainicio="&form.Filtro_SPEfechainicio>
	<cfset paramsFiltro= paramsFiltro & "&HFiltro_SPEfechainicio="&form.Filtro_SPEfechainicio>
</cfif>
<cfif isdefined("form.Filtro_SPEfechafin") and len(trim(form.Filtro_SPEfechafin)) neq 0>
	<cfset paramsFiltro= paramsFiltro & "&Filtro_SPEfechafin="&form.Filtro_SPEfechafin>
	<cfset paramsFiltro= paramsFiltro & "&HFiltro_SPEfechafin="&form.Filtro_SPEfechafin>
</cfif>
<cfif isdefined("form.Filtro_Vigente")and len(trim(form.Filtro_Vigente)) neq 0>
	<cfset paramsFiltro= paramsFiltro & "&Filtro_Vigente="&form.Filtro_Vigente>
	<cfset paramsFiltro= paramsFiltro & "&HFiltro_Vigente="&form.Filtro_Vigente>
</cfif>
<cfif isdefined("form.Filtro_FechasMayores") and len(trim(form.Filtro_FechasMayores)) neq 0>
	<cfset paramsFiltro= paramsFiltro & "&Filtro_FechasMayores="&form.Filtro_FechasMayores>
	<cfset paramsFiltro= paramsFiltro & "&HFiltro_FechasMayores="&form.Filtro_FechasMayores>
</cfif>

<!--- filtro lista detalles--->
<cfset paramsFiltroD = "">
<cfif isdefined("form.Filtro_PEdescripcion") and len(trim(form.Filtro_PEdescripcion)) neq 0>
	<cfset paramsFiltroD="&Filtro_PEdescripcion="&form.Filtro_PEdescripcion>
</cfif>
<cfif isdefined("form.Filtro_FechaInicio") and len(trim(form.Filtro_FechaInicio)) neq 0>
	<cfset paramsFiltroD= paramsFiltroD & "&Filtro_FechaInicio="&form.Filtro_FechaInicio>
</cfif>
<cfif isdefined("form.Filtro_Fechafin") and len(trim(form.Filtro_Fechafin)) neq 0>
	<cfset paramsFiltroD= paramsFiltroD & "&Filtro_Fechafin="&form.Filtro_Fechafin>
</cfif>
<cfif isdefined("form.Filtro_vigente2") and len(trim(form.Filtro_vigente2)) neq 0>
	<cfset paramsFiltroD= paramsFiltroD &"&Filtro_vigente2="&form.Filtro_vigente2>
</cfif>

<!-----------------Redirecciona la pantalla mandaondo los variables segun sea el caso--------------------->	
<cfif isdefined("Form.Cambio") or isdefined("Form.CambioDet") or  isdefined("Form.AltaDet")>
	<cflocation url="SubPeriodoEscolar.cfm?#paramsPagina##paramsPaginaD##paramsId##paramsIdD##paramsFiltro##paramsFiltroD#">
<cfelseif  isdefined("form.BajaDet") or isdefined("form.NuevoDet")>
	<cflocation url="SubPeriodoEscolar.cfm?#paramsPagina##paramsId##paramsPaginaD##paramsFiltro##paramsFiltroD#">
<cfelseif isdefined("Form.Alta")>
	<cflocation url="SubPeriodoEscolar.cfm?#paramsPagina##paramsId##paramsFiltro#">
<cfelseif isdefined("form.Baja")>
	<cflocation url="listaSubPeriodoEscolar.cfm?#paramsPagina##paramsFiltro#">
<cfelseif isdefined("form.Nuevo")>
	<cflocation url="SubPeriodoEscolar.cfm?#paramsPagina##paramsFiltro#">
<cfelseif isdefined("form.Lista")>
	<cflocation url="listaSubPeriodoEscolar.cfm?#paramsPagina##paramsFiltro#">
</cfif>
