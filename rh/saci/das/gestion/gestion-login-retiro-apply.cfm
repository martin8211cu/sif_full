<cffunction name="eliminaTar" output="false" returntype="void" access="public">
  <cfargument name="contrato" type="numeric" required="Yes"  displayname="IdContrato">
  <cfargument name="cuenta" type="numeric" required="Yes"  displayname="IdContrato">  
  <cfargument name="numLogin" type="numeric" required="Yes"  displayname="IdContrato">  

	<!---Elimimnacion de la tarea programada--->
	<cfquery name="rsTarea" datasource="#session.DSN#">
		select TPid
			, TPdescripcion
		from ISBtareaProgramada 
		where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.contrato#">
				and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cuenta#">
				and LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.numLogin#">
				and TPestado = 'P'
				and TPtipo = 'RL'
	</cfquery>
	<cfif rsTarea.recordCount GT 0>
		<cfinvoke component="saci.comp.ISBtareaProgramada" method="Baja">
			<cfinvokeargument name="TPid" value="#rsTarea.TPid#">
		</cfinvoke>
		
		<!---Datos del login--->
		<cfquery name="rsLog" datasource="#session.DSN#">
			select LGlogin
			from	ISBlogin
			where 	LGnumero= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.numLogin#">
		</cfquery>		
		<cfif rsLog.recordCount GT 0>
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">		<!---registro en la bitacora del borrado realizado --->
				<cfinvokeargument name="LGnumero" value="#Arguments.numLogin#">
				<cfinvokeargument name="LGlogin" value="#rsLog.LGlogin#">
				<cfinvokeargument name="BLautomatica" value="false">				
				<cfinvokeargument name="BLobs" value="Borrado Manual de Tarea Programada en la Administración de cuentas. (#rsTarea.TPdescripcion#)">
				<cfinvokeargument name="BLfecha" value="#now()#">
			</cfinvoke>			
		</cfif>
	</cfif>
</cffunction>


<cfif isdefined("form.Retirar")>
	<!---Valida que si el login es el unico login activo del paquete no pueda ser reprogramado --->
	<cfquery name="rsCantidad" datasource="#session.DSN#">
		select	count(b.LGnumero) as num
		from	ISBproducto a
				inner join ISBlogin b
				on b.Contratoid = a.Contratoid
				and b.Habilitado=1
		where 	a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
	</cfquery>
	<cfif rsCantidad.num EQ 1>
		<cfthrow message="Error: El producto posee un único login activo, para retirarlo debe hacer el retiro de servicio por paquete.">
	</cfif>
	
	<!---Valida que al retirar el login, el paquete aun cumpla con el maximo y minimo de los servicios requeridos, si no los cumple no permite el retiro de login --->
	<cfquery name="rsServicios" datasource="#session.DSN#">
		select	b.TScodigo, b.SVcantidad, b.SVminimo
				,(select count(y.TScodigo) from ISBlogin x
					inner join ISBserviciosLogin y
						on y.LGnumero = x.LGnumero
						and y.Habilitado=1
					where x.Contratoid =a.Contratoid 
					and  x.LGnumero <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
					and x.Habilitado=1
					and y.TScodigo = b.TScodigo ) as cantidad
		from 	ISBproducto a
				inner join ISBservicio b
				on b.PQcodigo = a.PQcodigo
				and b.Habilitado=1
		where 	a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
	</cfquery>
	<cfloop query="rsServicios">
		<cfif rsServicios.SVminimo GT rsServicios.cantidad>
			<cfthrow message="Atención: No es posible realizar la retiro del login, debido a que si se realizara el retiro, el paquete no contaria con los servicios mínimos requeridos.">
		</cfif>
	</cfloop>
	<!---Valida que si existe una fecha de retiro del paquete sea mayor a la fecha de retiro del login --->
	<cfquery name="rsFecha" datasource="#session.DSN#">
		select	TPfecha
		from	ISBtareaProgramada
		where
			CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#"> 
			and Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
			and TPestado ='P'
			and TPtipo ='RS'
	</cfquery>
	<cfif rsFecha.recordCount GT 0>
		<cfif DateCompare(rsFecha.TPfecha,form.fretiro) NEQ 1>
			<cfthrow message="Atención: No es posible realizar la retiro del login, debido a que existe un retiro de paquete programado para un fecha anterior a la fecha en que se desea retirar el login.">
		</cfif>	
	</cfif>
	
	<!---Datos del paquete--->
	<cfquery name="rsPaquete" datasource="#session.DSN#">
		select	distinct PQcodigo
		from	ISBproducto
		where 	Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
	</cfquery>
	<!---Datos del login--->
	<cfquery name="rsLog" datasource="#session.DSN#">
		select LGlogin
		from	ISBlogin
		where 	LGnumero= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
	</cfquery>
	
	<cfif isdefined("form.radio")>		
		<cfif form.radio EQ 1>
			<cfinclude template="gestion-login-retiro-apply-tarea.cfm">	<!---retiro en una fecha determinada--->
		<cfelseif form.radio EQ 2>	<!---retiro en este momento--->					
			<cftransaction>
				<cfset eliminaTar(form.pkg, form.cue, form.logg)>											
				<cfinvoke component="saci.comp.ISBtareaProgramadaRL" method="RetiroLoginProgramado">
					<cfinvokeargument name="LGnumero" 	value="#form.logg#">
					<cfinvokeargument name="Contratoid" value="#form.pkg#">
					<cfinvokeargument name="MRid" 		value="#form.MRid#">
					<cfinvokeargument name="BLobs" 		value="Retiro del login #form.logg#">
				</cfinvoke>
			</cftransaction>				
		</cfif>	
	<cfelse>
		<cfthrow message="Error: no seleccionó si deseaba hacer el retiro en este momento o en un fecha determinada.">
	</cfif>	
<cfelseif isdefined("Eliminar")>
	<cfset eliminaTar(form.pkg, form.cue, form.logg)>
</cfif>

<cfinclude template="gestion-redirect.cfm">
