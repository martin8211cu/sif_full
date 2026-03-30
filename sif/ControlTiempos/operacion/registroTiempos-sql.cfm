<!--- datos del usuario --->
<cfset datos_empleado.DEid = ''>
<cfset datos_empleado.CFid = ''>
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
<cfset data = sec.getUsuarioByCod(session.Usucodigo, session.EcodigoSDC, 'DatosEmpleado') >
<!--- CF del empleado --->
<cfif len(trim(data.llave))>
	<cfset datos_empleado.DEid = data.llave>
	<cfquery name="datosEmpleado" datasource="#session.DSN#">
		select b.CFid 
		from LineaTiempo a
		
		inner join RHPlazas b
		on a.RHPid=b.RHPid
		and a.Ecodigo=b.Ecodigo
		
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
		  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.llave#">
	</cfquery>
	<cfif len(trim(datosEmpleado.CFid))>
		<cfset datos_empleado.CFid = datosEmpleado.CFid >
	</cfif>
</cfif>

<cfloop from="1" to="10" index="i">
	<cfset socio = '' >
	<cfset proyecto = '' >
	<cfset temp = listToarray(form['proyecto_#i#'],'/') >
	<cfif Arraylen(temp) eq 2 >
		<cfset socio = temp[1] >
		<cfset proyecto = temp[2] >
	</cfif>
	<cfset actividad = form['CTAcodigo_#i#'] >

	<cfset fecha = LSParseDateTime(form.fecha_inicio) >

	<cfif len(trim(proyecto)) and len(trim(actividad))>
		<cfloop condition=" fecha lte LSparseDateTime(form.fecha_final) ">
			<cfif isdefined('form.CTTcodigo_#DayOfWeek(fecha)#_#i#') and len(trim(form['CTTcodigo_#DayOfWeek(fecha)#_#i#']))>
				<cfquery datasource="#session.DSN#">
					update CTTiempos
					set CTAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#actividad#">, 
						CTPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#proyecto#">, 
						CTThorasR=<cfif len(trim(form['CTThorasR_#DayOfWeek(fecha)#_#i#'])) ><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form['CTThorasR_#DayOfWeek(fecha)#_#i#'],',','')#"><cfelse>0</cfif>, 
						CTTobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['CTTobs_#DayOfWeek(fecha)#_#i#']#">, 
						SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#socio#">, 
						CTTfacturable=<cfif isdefined("form.CTTfacturable_#DayOfWeek(fecha)#_#i#")>1<cfelse>0</cfif>,
						CFid=<cfif len(trim(datos_empleado.CFid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_empleado.CFid#"><cfelse>null</cfif>,
						DEid=<cfif len(trim(datos_empleado.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_empleado.DEid#"><cfelse>null</cfif>
					where CTTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['CTTcodigo_#DayOfWeek(fecha)#_#i#']#">
				</cfquery>
			<cfelse>
				<cfif len(trim(form['CTThorasR_#DayOfWeek(fecha)#_#i#'])) >
					<cfquery datasource="#session.DSN#">
						insert into CTTiempos(	CTAcodigo, 
												CTPcodigo, 
												CTThorasR, 
												CTTobservacion, 
												Ecodigo, 
												SNcodigo, 
												Usucodigo, 
												Usuario, 
												CTTfecha, 
												CTTfacturable,
												CFid,
												DEid,
												BMUsucodigo )
						values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#actividad#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#proyecto#">,
								 <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form['CTThorasR_#DayOfWeek(fecha)#_#i#'],',','')#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['CTTobs_#DayOfWeek(fecha)#_#i#']#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#socio#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
								 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">,
								 <cfif isdefined("form.CTTfacturable_#DayOfWeek(fecha)#_#i#")>1<cfelse>0</cfif>,
								 <cfif len(trim(datos_empleado.CFid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_empleado.CFid#"><cfelse>null</cfif>,
								 <cfif len(trim(datos_empleado.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_empleado.DEid#"><cfelse>null</cfif>,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
					</cfquery>
				</cfif>
			</cfif>
	
			<cfset fecha = dateadd('d', 1, fecha) >
		</cfloop>
	<cfelse>
		<cfloop condition=" fecha lte LSparseDateTime(form.fecha_final) ">
			<cfif isdefined('form.CTTcodigo_#DayOfWeek(fecha)#_#i#') and len(trim(form['CTTcodigo_#DayOfWeek(fecha)#_#i#']))>
				<cfquery datasource="#session.DSN#">
					delete CTTiempos
					where CTTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['CTTcodigo_#DayOfWeek(fecha)#_#i#']#">
				</cfquery>
			</cfif>	
			<cfset fecha = dateadd('d', 1, fecha) >
		</cfloop>	
	</cfif>
</cfloop>
<cflocation url="registroTiempos.cfm?fecha=#form.fecha#">