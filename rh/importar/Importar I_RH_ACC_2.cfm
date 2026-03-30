<!---  Graba el Detalle de la Accion
 Verifica que NO exista ese componente en la accion--->

<cftransaction>
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1
		from  #table_name# a, 
				DatosEmpleado b,
				RHAcciones c,
				RHDAcciones d,
				ComponentesSalariales e, 
				RHTipoAccion g
		where a.cedula = b.DEidentificacion
		   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and b.DEid = c.DEid
		   and b.Ecodigo = c.Ecodigo
		   and a.desde = c.DLfvigencia
		   and coalesce(a.hasta, '61000101') = coalesce(c.DLffin, '61000101')
		   and a.tipo_accion = g.RHTcodigo
		   and g.RHTid = c.RHTid
		   and c.RHAlinea = d.RHAlinea
		   and d.CSid = e.CSid
	</cfquery>
	<cfset Vcheck1 = rsCheck1.check1>
	
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2
		from  #table_name# a
		where not exists (select 1 from 
						   DatosEmpleado b,
						   RHAcciones c,
						   RHTipoAccion e
					where a.cedula = b.DEidentificacion 
					  and b.DEid = c.DEid
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and a.desde = c.DLfvigencia
					  and coalesce(a.hasta, '61000101') = coalesce(c.DLffin, '61000101')
					  and c.Ecodigo = b.Ecodigo
					  and a.tipo_accion = e.RHTcodigo
					  and e.RHTid = c.RHTid
					  and e.Ecodigo = b.Ecodigo)
	</cfquery>
	<cfset Vcheck2 = rsCheck2.check2>
	
	
	<cfif  (Vcheck1 EQ 0) and (Vcheck2 EQ 0) >
		<cfquery datasource="#Session.DSN#">
			insert INTO RHDAcciones
				 (Usucodigo, Ulocalizacion, RHAlinea, CSid, RHDAtabla, 
				 RHDAunidad, RHDAmontobase, RHDAmontores) 
			select 
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, '00', RHAlinea, CSid, null, 1, 
				 <cf_dbfunction name="to_number" args="monto">, <cf_dbfunction name="to_number" args="monto">
			from 
				#table_name# a, 
				DatosEmpleado b,
				RHAcciones c,
				RHTipoAccion d,
				ComponentesSalariales e 
			where a.cedula = b.DEidentificacion 
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and b.DEid = c.DEid
			  and c.Ecodigo = b.Ecodigo
			  and a.desde = c.DLfvigencia
			  and coalesce(a.hasta, '61000101') = coalesce(c.DLffin, '61000101')
			  and a.tipo_accion = d.RHTcodigo
			  and c.RHTid = d.RHTid
			  and d.Ecodigo = b.Ecodigo
			  and a.componente = e.CScodigo
			  and e.Ecodigo = b.Ecodigo
		</cfquery>	  
	<cfelse>
		<cfif Vcheck1 GT 0>
			<cfquery  name="ERR" datasource="#Session.DSN#">
				select 'Datos ya existen', cedula, tipo_accion, componente, desde, hasta
				from  #table_name# a, 
					DatosEmpleado b,
					RHAcciones c,
					RHDAcciones d,
					ComponentesSalariales e, 
					RHTipoAccion g
				where a.cedula = b.DEidentificacion
				   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and b.DEid = c.DEid
				   and b.Ecodigo = c.Ecodigo
				   and a.desde = c.DLfvigencia
				   and coalesce(a.hasta, '61000101') = coalesce(c.DLffin, '61000101')
				   and a.tipo_accion = g.RHTcodigo
				   and g.RHTid = c.RHTid
				   and c.RHAlinea = d.RHAlinea
				   and d.CSid = e.CSid
			</cfquery>
		</cfif>
		<cfif Vcheck2 GT 0>
			<cfquery  name="ERR" datasource="#Session.DSN#">
			  select 'Detalle no concuerda con encabezados', cedula, tipo_accion, componente, desde, hasta
			  from   #table_name# a
			  where not exists (select 1 from 
						   DatosEmpleado b,
						   RHAcciones c,
						   RHTipoAccion e
					where a.cedula = b.DEidentificacion 
					  and b.DEid = c.DEid
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and a.desde = c.DLfvigencia
					  and coalesce(a.hasta, '61000101') = coalesce(c.DLffin, '61000101')
					  and c.Ecodigo = b.Ecodigo
					  and a.tipo_accion = e.RHTcodigo
					  and e.RHTid = c.RHTid
					  and e.Ecodigo = b.Ecodigo)
			</cfquery>   
		</cfif>
	</cfif>
</cftransaction>

