<!--- Importa Acciones en Proceso Enc --->

	<cfquery name="rsCheck1" datasource="#session.DSN#">
		select count(1) as check1 
		from #table_name# a, DatosEmpleado b, RHAcciones c, RHTipoAccion d
		where a.cedula = b.DEidentificacion 
			  and b.DEid = c.DEid 
			  and a.tipo_accion  = d.RHTcodigo 
			  and c.RHTid = d.RHTid 
			  and a.desde = c.DLfvigencia 
			  and a.hasta = c.DLffin  
			  and c.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1>
	
	<!---if (@check1 < 1)--->
	<cfif bcheck1 LT 1>
	
		<cfquery  name="ERR" datasource="#session.DSN#">
			insert into RHAcciones 
					   (DEid,RHTid,Ecodigo,Tcodigo, RVid, RHJid, RHTCid, 
						Dcodigo, Ocodigo, RHPid, RHPcodigo, DLfvigencia, 
						DLffin, DLsalario, DLobs, Usucodigo, Ulocalizacion,
						RHAporc, RHAporcsal, RHAidtramite, RHAvdisf, 
						RHAvcomp, IEid ,TEid )<!--- 24 --->
			 select DEid, RHTid, <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, nomina, RVid, RHJid, e.RHTCid, 
					departamento, oficina, RHPid, puesto, desde, hasta, 
					salario, descripcion, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, '00',<!---@Ulocalizacion, --->
					porc_plaza, porc_salario, null, disfrutados, compensados,
					null, null <!--- 24 --->
			 from #table_name# a, RegimenVacaciones b, RHJornadas c, 
					RHPlazas d, RHCategoriasTipoTabla e, 
					RHTTablaSalarial f, RHTipoAccion g, DatosEmpleado h
			 where a.cedula = h.DEidentificacion 
					and a.tipo_accion  = g.RHTcodigo 
					and	a.regimen = b.RVcodigo 
					and	a.jornada  = c.RHJcodigo 
					and	a.plaza  = d.RHPcodigo 
					and	a.tabla_salarial  = f.RHTTcodigo 
					and	e.RHTTid  = f.RHTTid 
					and	e.RHMCcodigo  = a.categoria 
					and	e.RHMCpaso  = a.paso 
					and	f.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		          	and g.Ecodigo = f.Ecodigo
		</cfquery>			        
	<cfelse>
		<cfquery name="ERR" datasource="#Session.DSN#">
			select 'Datos ya existen', c.DEid,  c.RHTid, DLfvigencia, DLffin, c.Ecodigo 
			from #table_name# a, DatosEmpleado b, RHAcciones c, RHTipoAccion d
			where a.cedula = b.DEidentificacion 
				  and b.DEid = c.DEid 
				  and a.tipo_accion  = d.RHTcodigo 
				  and c.RHTid = d.RHTid 
				  and a.desde = c.DLfvigencia 
				  and a.hasta = c.DLffin  
				  and c.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>		
