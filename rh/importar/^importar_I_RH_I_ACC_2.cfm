<!--- Graba el Detalle de la Accion
	Verifica que NO exista ese componente en la accion --->
<cfquery name="rsCheck1" datasource="#session.DSN#">
	select count(1) as check1
	from  #table_name# a, 
			ComponentesSalariales b, 
			RHAcciones c,
			DatosEmpleado d,
			RHTipoAccion e,
			RHDAcciones f
	where   a.cedula = d.DEidentificacion and
			a.tipo_accion  = e.RHTcodigo and
			a.componente = b.CScodigo and
			a.desde = c.DLfvigencia and
			a.hasta = c.DLffin and
			d.DEid = c.DEid and
			e.RHTid = c.RHTid and
			f.CSid = b.CSid
</cfquery>
<cfset bCheck1 = rsCheck1.check1>

<!---- Verifica que exista la accion en las fechas comprendidas--->
<cfquery name="rsCheck2" datasource="#session.DSN#">		
	select count(1) as check2
	from   #table_name# a, 
		   RHAcciones c,
		   DatosEmpleado d,
		   RHTipoAccion e
	where  a.cedula = d.DEidentificacion and
		   a.tipo_accion  = e.RHTcodigo and
		   a.desde = c.DLfvigencia and
		   a.hasta = c.DLffin and		
		   d.DEid = c.DEid and
		   e.RHTid = c.RHTid
		    		
</cfquery>		
<cfset bCheck2 = rsCheck2.check2>


		
<!---if ( (@check1 < 1) and   (@check2 >= 1)  )--->
<cfif (bCheck1 LT 1) and (bCheck2 GTE 1)>
	<cfquery name ="ERR" datasource="#session.DSN#">
		insert into RHDAcciones
				 (Usucodigo, Ulocalizacion, RHAlinea, CSid, RHDAtabla, 
				 RHDAunidad, RHDAmontobase, RHDAmontores) 
		select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, '00', RHAlinea, CSid, null, 1, 
				monto, monto
		from 	#table_name# a, 
				ComponentesSalariales b, 
				RHAcciones c,
				DatosEmpleado d,
				RHTipoAccion e
		where 	a.cedula = d.DEidentificacion and
				a.tipo_accion  = e.RHTcodigo and
				a.componente = b.CScodigo and
				a.desde = c.DLfvigencia and
				a.hasta = c.DLffin and
				d.DEid = c.DEid and
				e.RHTid = c.RHTid
				and b.Ecodigo=1
				
	</cfquery>			
	<!---else--->
<cfelse>
	<!---begin--->
	<!---if ( @check1 >= 1) --->
	<cfif bCheck1 GTE 1>
		<cfquery name ="ERR"datasource="#session.DSN#">
			select  'Datos ya existen', cedula, tipo_accion, componente, desde, hasta
			from  	#table_name# a, 
					ComponentesSalariales b, 
					RHAcciones c,
					DatosEmpleado d,
					RHTipoAccion e,
					RHDAcciones f
			where 	a.cedula = d.DEidentificacion and
					a.tipo_accion  = e.RHTcodigo and
					a.componente = b.CScodigo and
					a.desde = c.DLfvigencia and
					a.hasta = c.DLffin and
					d.DEid = c.DEid and
					e.RHTid = c.RHTid and
					f.CSid = b.CSid		
		</cfquery>
	</cfif>
			
	<!---if ( @check2 < 1)--->
	<cfif bCheck2 LT 1>
		<cfquery name ="ERR" datasource="#session.DSN#">
			select 'La Acción NO existe en esas fechas', cedula, tipo_accion, componente, desde, hasta
			from #table_name#
		</cfquery>
	</cfif>
</cfif>
<!---end--->
