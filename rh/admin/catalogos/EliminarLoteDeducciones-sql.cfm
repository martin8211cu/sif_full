<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso"><!--- Permite validar el acceso según parametrizacion 2526--->
<cfif isdefined("form.chk") and len(trim(form.chk))>
	<cf_dbtemp name="tbl_trabajo" returnvariable="tbl_trabajo">
		<cf_dbtempcol name="lote"				type="numeric" 		mandatory="yes" >
		<cf_dbtempcol name="DEidentificacion"	type="varchar(120)"	mandatory="yes" >
		<cf_dbtempcol name="Did"				type="numeric" 		mandatory="no" 	>
		<cf_dbtempcol name="DEid" 				type="numeric"		mandatory="no" 	>
		<cf_dbtempcol name="desde" 				type="date"			mandatory="no" 	>
		<cf_dbtempcol name="hasta" 				type="date"			mandatory="no" 	>
		<cf_dbtempcol name="TDid"				type="numeric"		mandatory="no" 	>
		<cf_dbtempcol name="RCNid"				type="numeric"		mandatory="no" 	>
		<cf_dbtempcol name="SNcodigo"			type="int"			mandatory="no" 	>
		<cf_dbtempcol name="valor"				type="money"		mandatory="no" 	>
		<cf_dbtempcol name="monto"				type="money"		mandatory="no" 	>
		<cf_dbtempcol name="afecta_saldo"		type="int"			mandatory="no" 	>				
	</cf_dbtemp>

	<!--- 1. Toma todas las deducciones que se generaron a partir de un lote --->
	<cfquery datasource="#session.DSN#">
		insert into #tbl_trabajo#(lote, DEidentificacion, DEid, desde, hasta, TDid, SNcodigo, valor, monto, afecta_saldo)
		select 	a.EIDlote,
				DIDidentificacion,
				de.DEid,
				b.DIDfechaini,
				b.DIDfechafin,
				td.TDid,
				sn.SNcodigo,
				b.DIDvalor,
				b.DIDmonto,
				b.DIDcontrolsaldo
		from EIDeducciones a, DIDeducciones b, TDeduccion td, SNegocios sn, DatosEmpleado de
		where td.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.EIDlote in (#form.chk#)
			and b.EIDlote=a.EIDlote
			and td.TDid=a.TDid
			and sn.Ecodigo=a.Ecodigo
			and sn.SNcodigo=a.SNcodigo
			and de.DEidentificacion=b.DIDidentificacion
			and de.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<!--- 2. obtiene el id de la deduccion generada para el empleado, si ya se genero --->
	<cfquery datasource="#session.DSN#">
		update #tbl_trabajo#
		set Did = ( select min(Did)
					from DeduccionesEmpleado 
					where DEid = #tbl_trabajo#.DEid
					  and TDid = #tbl_trabajo#.TDid
					  <!---and Dfechaini = #tbl_trabajo#.desde--->
					  and Dcontrolsaldo = #tbl_trabajo#.afecta_saldo
					  and SNcodigo = #tbl_trabajo#.SNcodigo
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  )
	</cfquery>

	<!--- 3. obtiene el id de nomina en proceso del empleado y que aun NO esta en recepcion de pagos --->
	<cfquery datasource="#session.DSN#">
		update #tbl_trabajo#
		set RCNid =  (  select min(a.RCNid)
						from SalarioEmpleado a, RCalculoNomina b
						where a.DEid=#tbl_trabajo#.DEid
								and b.RCNid=a.RCNid
						and #tbl_trabajo#.desde <= b.RChasta
							and #tbl_trabajo#.hasta >= b.RCdesde
						and b.RCestado < 3	
			 )
	</cfquery>

	<!--- 4. Procesa los datos obtenidos en la tabla temporal--->
	<cfquery name="rs_datos" datasource="#session.DSN#">
		select DEid, Did, valor, monto, RCNid, afecta_saldo
		from #tbl_trabajo#
	</cfquery>

	<cftransaction>
		<cfloop query="rs_datos">
			<cfif len(trim(rs_datos.DEid)) >
					<!--- 4.1 hay que hacerle algo a la deduccion --->
					<cfif len(trim(rs_datos.Did)) >
						<cfquery datasource="#session.DSN#">
							update DeduccionesEmpleado
							set Dsaldo = Dsaldo - <cfif rs_datos.afecta_saldo eq 1>
													  <cfif len(trim(rs_datos.monto)) ><cfqueryparam cfsqltype="cf_sql_money" value="#rs_datos.monto#"><cfelse>0</cfif>
												  <cfelse>
												  	  0
												  </cfif>
							
								, Dmonto = Dmonto - <cfif len(trim(rs_datos.monto)) ><cfqueryparam cfsqltype="cf_sql_money" value="#rs_datos.monto#"><cfelse>0</cfif>
								
							where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos.Did#">
						</cfquery>						
					</cfif>			
					
					<!--- 4.2. Si el empleado esta en una relacion de calculo abierta y que aun no esta en recepcion de pagos
							 debe marcarse como no calculado el empleado, para obligar a recalcular la nomina con la nueva info
							 de la deduccion
					--->
					<cfif len(trim(rs_datos.RCNid)) >
						<cfquery datasource="#session.DSN#">
							update SalarioEmpleado
							set SEcalculado = 0
							where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos.RCNid#">
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos.DEid#">
						</cfquery>
					</cfif>
			</cfif>
		</cfloop>

		<!--- 4. borra el detalle de los lotes seleccionados --->
		<cfquery datasource="#session.DSN#">
			delete from DIDeducciones
			where EIDlote in (#form.chk#)
		</cfquery>

		<!--- 5. borra los lotes seleccionados --->
		<cfquery datasource="#session.DSN#">
			delete from EIDeducciones
			where EIDlote in (#form.chk#)
		</cfquery>
		
		<!--- 6. pone deducciones en cero si quedaron negativas --->
		<cfquery datasource="#session.DSN#">
			update DeduccionesEmpleado
			set Dsaldo = 0
			where DEid in ( select DEid from #tbl_trabajo# ) 
			  and Dsaldo < 0
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update DeduccionesEmpleado
			set Dmonto = 0
			where DEid in ( select DEid from #tbl_trabajo# ) 
			  and Dmonto < 0
		</cfquery>
	</cftransaction>
</cfif>

<cflocation url="EliminarLoteDeducciones.cfm">