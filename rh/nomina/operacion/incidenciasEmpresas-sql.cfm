<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<!--- Query para determinar si la relacion y el concepto incidente ya fueron procesados --->
<cfset continuar = true >

<cfquery name="rsExiste" datasource="#session.DSN#">
	select coalesce(count(1), 0) as total
	from Incidencias
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
</cfquery>

<cfset params = '&tipo=#form.tipo#' >
<!--- 
	Funcionamiento nuevo: Se pueden re-procesar los datos que ya han sido procesados, solo que se deben eliminar
	los registros que ya existan del procesamiento anterior (para la combinacion RCNid-CIid)
	Funcionamiento anterior: Si la relacion y el concepto incidente no han sido procesados se hacen los calculos.--->
<cfif continuar >
	<cfquery name="rsRelacion" datasource="#session.DSN#">
		select RChasta as fecha

		<cfif isdefined("form.tipo") and form.tipo eq 'A'>
			from RCalculoNomina
		<cfelse>
			from HRCalculoNomina
		</cfif>	

		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	</cfquery>
	
	<cftransaction >

	<cfquery datasource="#session.DSN#" name="DelInci">
		delete from Incidencias
		where RCNid in (Select a.CPid 
						from CalendarioPagos a, CalendarioPagos b
						where b.CPid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
						and b.Tcodigo=a.Tcodigo
						and a.Ecodigo=b.Ecodigo
						)
		and CIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	</cfquery>


	<cfquery datasource="#session.DSN#" name="RSIncidencias">
		 insert into Incidencias(DEid, RCNid, CIid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, BMUsucodigo) <!--- --->
			select ( select se1.DEid  
					 from DatosEmpleadoCorp se1
					 where se1.DEidcorp=dec.DEidcorp
					 and se1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  ) as DEid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#"> as RCNid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#"> as CIid,
				
				Ifecha =	

					 Case When  <cfqueryparam cfsqltype="cf_sql_date" value="#rsRelacion.fecha#"> 
					   < (Select max(LThasta)
						  from LineaTiempo lt
						  where lt.DEid=dec.DEid
						  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoOrigen#">  ) 
					 then 
					   <cfqueryparam cfsqltype="cf_sql_date" value="#rsRelacion.fecha#"> 
					 else 
					   (Select max(LThasta)
						from LineaTiempo lt
						where lt.DEid=dec.DEid
						and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoOrigen#"> ) 
					 end,
					<!--- Salario Bruto (+)--->
					round((((se.SEsalariobruto    
					<!--- INCIDENCIAS A TOMAR EN CUENTA.... --->
					+ coalesce((select sum(a.ICmontores) 
							<cfif isdefined("form.tipo") and form.tipo eq 'A'>
								from IncidenciasCalculo a
							<cfelse>
								from HIncidenciasCalculo a
							</cfif>	
							where a.DEid = ( select se1.DEid  
								from DatosEmpleadoCorp se1
								where se1.DEidcorp=dec.DEidcorp
								and se1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoOrigen#">  )
							and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">   
							and CIid in (select distinct a.CIid
											from RHReportesNomina c
											inner join RHColumnasReporte b
											inner join RHConceptosColumna a
											on a.RHCRPTid = b.RHCRPTid
											on b.RHRPTNid = c.RHRPTNid
											and b.RHCRPTcodigo = 'TransferINC'
											where c.RHRPTNcodigo = 'SA'
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoOrigen#">)),0)
					
					)*-1)/<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#replace(form.tipo_cambio,',','','all')#">),2) 				   
				   
				   
				   as monto,
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> as Ifechasis,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#" > as usucodigo,
				   '00' as ulocalizacion,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#" > as BMusucodigo
			
			<cfif isdefined("form.tipo") and form.tipo eq 'A'>
				from SalarioEmpleado se,
			<cfelse>
				from HSalarioEmpleado se,
			</cfif>	

			DatosEmpleadoCorp dec
			where dec.DEid=se.DEid
			  and dec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoOrigen#">
			  and se.RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
			  and exists(  select 1 
						   from DatosEmpleadoCorp se2
						   where se2.DEidcorp=dec.DEidcorp
						     and se2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) 
	</cfquery>

<cfquery datasource="#session.DSN#" name="RSIncidencias">
		update 	Incidencias
		set Ifecha =  (Select max(LThasta)
					   from LineaTiempo lt
					   where lt.DEid=Incidencias.DEid
					   and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) 
		Where  CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#"> 
		and Ifecha > (Select max(LThasta)
					   from LineaTiempo lt
					   where lt.DEid=Incidencias.DEid
					   and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) 
		and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
</cfquery>
	<!--- <cf_dump var="#RSIncidencias#">  --->
	
	<cfquery datasource="#session.DSN#">
		insert into BMovimientoIncidencias( RCNid, RChasta, BMUsucodigo, BMfechaalta )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#" >,
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsRelacion.fecha#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>	
	</cftransaction>
<!--- Si la relacion y el concepto incidente ya han sido procesados se manda bandera de error.--->
<cfelse>
	<cfset params = '&error=S'>
</cfif>

<cflocation url="incidenciasEmpresas-confirmar.cfm?RCNid=#form.RCNid#&CIid=#form.CIid#&tipo_cambio=#form.tipo_cambio#&EcodigoOrigen=#form.EcodigoOrigen##params#">