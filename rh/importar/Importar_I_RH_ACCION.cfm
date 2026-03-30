<!---declare @check1 int, @check2 int, @check3 int, @check4 int,
@plaza int, @cedula varchar(12), @puesto varchar(12), @centro_funcional varchar(12), @id numeric--->

<!--- revisa si la accion ya fue cargada --->
<cfquery name="rsCheck1" datasource="#session.DSN#">
	select count(1) as check1
	from  #table_name# a, DatosEmpleado b, RHAcciones c, 
			 RHTipoAccion d
	where	a.cedula = b.DEidentificacion 
			and b.DEid = c.DEid
			and a.tipo_accion  = d.RHTcodigo
			and c.RHTid = d.RHTid
			and a.desde = c.DLfvigencia
			and a.hasta = c.DLffin 
			and c.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset Vcheck1 = rsCheck1.check1>


<!--- revisa si hay Tipos de accion no validos  --->
<cfquery name="rsCheck2" datasource="#session.DSN#">
	select count(1) as check2
	from  #table_name# a
	where not exists (select 1 from RHTipoAccion b
				where a.tipo_accion  = b.RHTcodigo
				and   b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			)
</cfquery>
<cfset Vcheck2 = rsCheck2.check2>

<!--- revisa si hay Plazas que no existen --->
<cfquery name="rsCheck3" datasource="#session.DSN#">
	select 
			 count(1) as check3
	from     #table_name# a
	where    not exists (select 1 from RHPlazas b
				where a.plaza   = b.RHPcodigo
				and   b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			)
</cfquery>
<cfset Vcheck3 = rsCheck3.check3>

<!--- revisa si hay Puestos que no existen --->
<cfquery name="rsCheck4" datasource="#session.DSN#">
	select count(1) as check4
	from   #table_name# a
	where  not exists (select 1 from RHPuestos b
			where a.puesto = b.RHPcodigo
			and   b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			)
</cfquery>
<cfset Vcheck4 = rsCheck4.check4>
		

<!---if (@check1 < 1 and  @check2 < 1  and  @check3 < 1  and  @check4 < 1)
begin--->

<cfif (Vcheck1 LT 1) and  (Vcheck2 LT 1)  and  (Vcheck3 LT 1)  and  (Vcheck4 LT 1)>
	<cfquery name="rsUpdate" datasource="#Session.DSN#">
		update #table_name#
		set departamento = c.Dcodigo,
					oficina = Ocodigo
		from CFuncional c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and   c.CFcodigo = centro_costo
	</cfquery>

	<!---if exists (select 1 
				from ComponentesSalariales 
				where CSusatabla = 1 
				and CSsalariobase = 1)--->
	<cfquery name="rsExiste" datasource="#Session.DSN#">
		select 1 
		from ComponentesSalariales 
		where CSusatabla = 1 
		and CSsalariobase = 1
	</cfquery>		
	<cfif rsExiste.Recordcount GTE 1>
		<cfquery name="rsExiste" datasource="#Session.DSN#">
			insert INTO RHAcciones 
			(DEid,RHTid,Ecodigo,Tcodigo, RVid, RHJid, RHTCid, 
			Dcodigo, Ocodigo, RHPid, RHPcodigo, DLfvigencia, 
			DLffin, DLsalario, DLobs, Usucodigo, Ulocalizacion,
			RHAporc, RHAporcsal, RHAidtramite, RHAvdisf, 
			RHAvcomp, IEid ,TEid )
			select   DEid, RHTid, <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
			nomina, RVid, RHJid, e.RHTCid, 
			departamento, oficina, RHPid, puesto, desde, hasta, 
			convert(money, a.salario), descripcion, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, '00', 
			porc_plaza, porc_salario, null, disfrutados, compensados,
			null, null
			from    #table_name# a, RegimenVacaciones b, RHJornadas c,   <!--- Bien asociado --->
				RHPlazas d, RHCategoriasTipoTabla e, 
				RHTTablaSalarial f, RHTipoAccion g, DatosEmpleado h
			where a.cedula = h.DEidentificacion
				and a.regimen = b.RVcodigo
				and h.Ecodigo = b.Ecodigo
				and a.jornada = c.RHJcodigo
				and h.Ecodigo = c.Ecodigo
				and a.plaza   = d.RHPcodigo
				and h.Ecodigo = d.Ecodigo
				and e.RHTTid  = f.RHTTid
				and h.Ecodigo = f.Ecodigo
				and e.RHMCcodigo  = a.categoria
				and e.RHMCpaso  = a.paso
				and a.tipo_accion  = g.RHTcodigo
				and h.Ecodigo = g.Ecodigo
				and h.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	<cfelse><!---else--->
		<cfquery name="rsExiste" datasource="#Session.DSN#">
			insert INTO RHAcciones 
			(DEid,RHTid,Ecodigo,Tcodigo, RVid, RHJid, RHTCid, 
			Dcodigo, Ocodigo, RHPid, RHPcodigo, DLfvigencia, 
			DLffin, DLsalario, DLobs, Usucodigo, Ulocalizacion,
			RHAporc, RHAporcsal, RHAidtramite, RHAvdisf, 
			RHAvcomp, IEid ,TEid ) 
			select DEid, RHTid, <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			nomina, RVid, RHJid, null, 
			departamento, oficina, RHPid, puesto, desde, hasta, 
			convert(money, a.salario), descripcion, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, '00', 
			porc_plaza, porc_salario, null, disfrutados, compensados,
			null, null
			from #table_name#  a, 
				DatosEmpleado b, 
				RegimenVacaciones c, 
				RHJornadas d, 
				RHPlazas e,
				RHTipoAccion f
			where a.cedula =  b.DEidentificacion
				and b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.regimen = c.RVcodigo
				and b.Ecodigo = c.Ecodigo
				and a.jornada = d.RHJcodigo
				and b.Ecodigo = d.Ecodigo
				and a.plaza   = e.RHPcodigo
				and b.Ecodigo = e.Ecodigo
				and a.tipo_accion = f.RHTcodigo
				and b.Ecodigo = f.Ecodigo
		</cfquery>
	</cfif><!---end--->
<cfelse>
	<cfif (Vcheck1 GTE 1)>
		<cfquery name="ERR" datasource="#Session.DSN#">
			select 'Datos ya existen', c.DEid,  c.RHTid, DLfvigencia, DLffin , c.Ecodigo 
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
	<cfif (Vcheck2 GTE 1)>
		<!--- revisa si hay Tipos de accion no validos --->
		<cfquery name="ERR" datasource="#Session.DSN#">
			select 'Tipo de accion no existe', a.* 
			from  
				#table_name# a
			where 
			  not exists (select 1 from RHTipoAccion b
					where a.tipo_accion  = b.RHTcodigo
					and   b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					)
		</cfquery>		
	</cfif> 
	<cfif (Vcheck3 GTE 1)>
		<!--- Revisa si hay Plazas que no existen --->
		<cfquery name="ERR" datasource="#Session.DSN#">
			select 'Plaza no existe', a.* 
			from  
			#table_name# a
			where 
				not exists (select 1 from RHPlazas b
				where a.plaza   = b.RHPcodigo
				and   b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			)
		</cfquery>
	</cfif>
	<cfif (Vcheck4 GTE 1)>
		<!--- Revisa si hay Puestos que no existen --->
		<cfquery name="ERR" datasource="#Session.DSN#">
			select 'Puesto no existe', a.* 
			from  
				#table_name# a
			where 
				not exists (select 1 from RHPuestos b
				where a.puesto = b.RHPcodigo
				and   b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				)
		</cfquery>
	</cfif>
</cfif>