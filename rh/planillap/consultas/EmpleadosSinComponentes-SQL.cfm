<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">	
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	de.DEnombre#LvarCNCT#' '#LvarCNCT#de.DEapellido1#LvarCNCT#' '#LvarCNCT#de.DEapellido2 as Empleado, 
			de.DEidentificacion, 
			convert(varchar,lt.LTdesde,103) as LTdesde, 			
			case lt.LThasta 	when '61000101' then 'Indefinido'
								else convert(varchar,lt.LThasta,103) end as LThasta, 
			coalesce(ts.RHTTdescripcion,' --- ') as TablaSalarial,
			<cfif len(trim(form.fechadesde))>
				convert(varchar,'#form.fechadesde#',103) as FechaDesde,
			<cfelse>	
				'     ------    ' as FechaDesde,
			</cfif>
			<cfif len(trim(form.fechahasta))>
				convert(varchar,'#form.fechahasta#',103) as FechaHasta,
			<cfelse>	
				'     ------    ' as FechaHasta,
			</cfif>	
			<cfif len(trim(form.CSdescripcion))>
				'#form.CSdescripcion#' as Componente
			<cfelse>	
				'Todos' as Componente
			</cfif>			
	from LineaTiempo lt

		inner join DatosEmpleado de
			on lt.DEid = de.DEid
			and lt.Ecodigo = de.Ecodigo

		left outer join RHCategoriasPuesto cp
			on lt.RHCPlinea = cp.RHCPlinea

			left outer join RHTTablaSalarial ts
				on cp.RHTTid = ts.RHTTid
				
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
		<!---Filtro de las fechas ----->
		<cfif isdefined("Form.fechadesde") and len(trim(Form.fechadesde)) and isdefined("Form.fechahasta") and len(trim(Form.fechahasta))>
			<cfif form.fechadesde EQ form.fechahasta>
				and lt.LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechadesde)#">
			<cfelse>
				and lt.LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechadesde)#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechahasta)#">
			</cfif>
		</cfif>
		<cfif isdefined("Form.fechadesde") and len(trim(Form.fechadesde)) and not ( isdefined("Form.fechahasta") and len(trim(Form.fechahasta)) )>
			and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechadesde)#">
		</cfif>
		
		<cfif isdefined("Form.fechahasta") and len(trim(Form.fechahasta)) and not ( isdefined("Form.fechadesde") and len(trim(Form.fechadesde)) )>
			and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechahasta)#">
		</cfif>

		and not exists(select 1
						from DLineaTiempo dlt
						where lt.LTid = dlt.LTid							
						<cfif isdefined("form.CSid") and len(trim(form.CSid))>
							and dlt.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
						</cfif>
					   )
	order by de.DEnombre,de.DEapellido1,de.DEapellido2
</cfquery>

<cfreport format="#form.formato#" template= "EmpleadosSinComponentes.cfr" query="rsDatos">
	<cfreportparam name="Edescripcion" value="#session.enombre#">
</cfreport>
