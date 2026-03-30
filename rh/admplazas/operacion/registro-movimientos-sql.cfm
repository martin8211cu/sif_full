
<!--- Modificar Movimiento --->
<cfif isdefined("form.Guardar") or isdefined("form.Aplicar")>

	<!--- Valida los campos RHTTid, RHCid, RHMPPid para evitar nulos --->
	<cfset vRHTTid = form.RHTTid1 >
	<cfset vRHMPPid = form.RHMPPid1 >
	<cfset vRHCid = form.RHCid1 >
	
	<cfif len(trim(form.RHTTid1)) eq 0 >
		<cfset vRHTTid = 0 >
	</cfif>
	<cfif len(trim(form.RHMPPid1)) eq 0 >
		<cfset vRHMPPid = 0 >
	</cfif>
	<cfif len(trim(form.RHCid1)) eq 0 >
		<cfset vRHCid = 0 >
	</cfif>

	<!--- VALIDACION DE LA TABLA SALARIAL --->
	<cfquery name="validar" datasource="#session.DSN#">
		select 1
		from RHCategoriasPuesto
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHTTid#">
		  and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHCid#">
		  and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHMPPid#">
	</cfquery>
        
	<cfif validar.recordcount eq 0>
		<cfthrow message="Error! La combinaci&oacute;n de los valores seleccionados para la Tabla Salarial, Puesto y Categor&iacute;a no es v&aacute;lida.">
	</cfif>

	<cftransaction>
		<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="modificarMovimiento" > 
			<cfinvokeargument name="RHMPid"  			value="#form.RHMPid#" > 
			<cfinvokeargument name="RHMPPid"  			value="#form.RHMPPid1#" > 
			<cfinvokeargument name="RHCid"  			value="#form.RHCid1#" > 
			<cfinvokeargument name="RHTTid"  			value="#form.RHTTid1#" > 
			<cfinvokeargument name="RHMPfdesde"  		value="#form.RHMPfdesde#" > 
			<cfif isdefined('form.RHMPnegociado')>
			<cfinvokeargument name="RHMPnegociado"  	value="#form.RHMPnegociado#" >
			</cfif>
			<cfinvokeargument name="RHMPestadoplaza"  	value="#form.RHMPestadoplaza#" >
			<cfinvokeargument name="CFidnuevo"  		value="#form.CFidnuevo#" > 
			<cfinvokeargument name="CFidcostonuevo"  	value="#form.CFidnuevo#" > 
			<cfinvokeargument name="CPcuenta"  			value="#form.CPcuenta#" > 	
			<cfinvokeargument name="RHPcodigo"  		value="#form.RHPcodigo#" > 		
			<cfinvokeargument name="RHTMporcentaje"     value="#form.RHTMporcentaje#" > 		

			<cfif isdefined("form.CFidnuevobd") and form.CFidnuevobd neq form.CFidnuevo>
				<cfinvokeargument name="CFidant"  		value="#form.CFidnuevobd#" > 
				<cfinvokeargument name="CFidcostoant" value="#form.CFidnuevobd#" > 
			</cfif>
			
			<cfif isdefined("form.RHPPcodigo")>
				<cfinvokeargument name="RHPPcodigo"  	value="#form.RHPPcodigo#" > 		
			</cfif>
			<cfif isdefined("form.RHPPdescripcion")>
				<cfinvokeargument name="RHPPdescripcion"  	value="#form.RHPPdescripcion#" > 		
			</cfif>
		</cfinvoke>


		<cfif isdefined("form.componentes") and form.componentes eq 1 >
			<cfif isdefined("form.cantcomp") and IsNumeric(form.cantcomp) >
				<cfloop from="1" to="#form.cantcomp#" index="i">
					<cfif isdefined("form.RHCMPid_#i#") >
						<cfset vRHCMPid = IIF( len(trim(form['RHCMPid_#i#'])) is 0, DE(0), DE(form['RHCMPid_#i#']) ) >
						<cfset vMonto =  replace( IIF( len(trim(form['MontoRes_#i#'])) is 0, DE(0), DE(form['MontoRes_#i#']) ), ',', '', 'all' ) >
						<cfset vMontoBase = replace( IIF( len(trim(form['MontoBase_#i#'])) is 0, DE(0), DE(form['MontoBase_#i#']) ), ',', '', 'all' ) >
						<cfset vCantidad = replace( IIF( len(trim(form['Cantidad_#i#'])) is 0, DE(0), DE(form['Cantidad_#i#']) ), ',', '', 'all' ) >
	
						<cfif vRHCMPid neq 0>
							<cfif isdefined('form.RHMPnegociado') and form.RHMPnegociado EQ 'N' >
								<cfset unidades = vCantidad >
								<cfset montobase = 0.00 >
								<cfset monto = vMonto >
							<cfelse>
								<!--- Obtener el componente salarial a calcular --->
								<cfquery name="rsComp" datasource="#Session.DSN#">
									select a.CSid
									from RHCMovPlaza a
									where a.RHCMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHCMPid#">
								</cfquery>
								<cfset vCSid = rsComp.CSid >
						
								<cfinvoke 
								 component="rh.Componentes.RH_EstructuraSalarial"
								 method="calculaComponente"
								 returnvariable="calculaComponenteRet">
									<cfinvokeargument name="CSid" value="#vCSid#"/>
									<cfinvokeargument name="fecha" value="#LSParseDateTime(form.RHMPfdesde)#"/>
									<cfinvokeargument name="RHMPPid" value="#vRHMPPid#"/>
									<cfinvokeargument name="RHTTid" value="#vRHTTid#"/>
									<cfinvokeargument name="RHCid" value="#vRHCid#"/>
									<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
									<cfinvokeargument name="negociado" value="#isdefined('form.RHMPnegociado') and form.RHMPnegociado is 'N'#"/>
									<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
									<cfinvokeargument name="Unidades" value="#vCantidad#"/>
									<cfinvokeargument name="MontoBase" value="#vMontoBase#"/>
									<cfinvokeargument name="Monto" value="#vMonto#"/>
									<cfinvokeargument name="TablaComponentes" value="RHCMovPlaza"/>
									<cfinvokeargument name="CampoLlaveTC" value="RHMPid"/>
									<cfinvokeargument name="ValorLlaveTC" value="#form.RHMPid#"/>
									<cfinvokeargument name="CampoMontoTC" value="Monto"/>
								</cfinvoke>
								
								<cfset unidades = calculaComponenteRet.Unidades>
								<cfset montobase = calculaComponenteRet.MontoBase>
								<cfset monto = calculaComponenteRet.Monto>
							</cfif>
						
							<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="modificarComponente" >
								<cfinvokeargument name="RHCMPid" value="#vRHCMPid#" > 
								<cfinvokeargument name="RHMPid" value="#form.RHMPid#" > 
								<cfinvokeargument name="Cantidad" value="#unidades#" > 
								<cfinvokeargument name="CFormato" value="" > 
								<cfinvokeargument name="Monto" value="#monto#"> 
								<cfinvokeargument name="RHTMporcentaje"     value="#form.RHTMporcentaje#" >  
							</cfinvoke>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cftransaction>
	<cfset id = form.RHMPid >

<!--- Agregar Movimiento --->
<cfelseif isdefined("form.Agregar")>

	<!--- Averigua si va a agregar plaza nueva 
		  ESto segun el tipo de movimiento (comportamiento = 10)
	--->
	<cfquery name="tipo" datasource="#session.DSN#">
		select RHTMcomportamiento
		from RHTipoMovimiento
		where RHTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTMid#">
	</cfquery>
	<cfif tipo.RHTMcomportamiento eq 10 >
		<cfset vRHPPid = '' >
		<cfset vRHPPcodigo = form.RHPPcodigonuevo >
		<cfset vRHPPdescripcion = form.RHPPdescripcionnuevo >
	<cfelse>
		<!--- Acciones de Cambio --->
		<cfset vRHPPid = form.RHPPid >
		<cfset vRHPPcodigo = '' >
		<cfset vRHPPdescripcion = '' >
		
		<cfquery name="validadesde" datasource="#session.DSN#">
			select RHLTPid as id, RHMPnegociado
			from RHLineaTiempoPlaza 
			where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHMPfdesde)#"> between RHLTPfdesde and RHLTPfhasta
		</cfquery>
		<cfif len(trim(validadesde.id)) is 0 >
			<cflocation url="registro-movimientos.cfm?errorfecha=true&RHTMid=#form.RHTMid#&RHPPid=#form.RHPPid#&RHMPfdesde=#form.RHMPfdesde#&RHMPfhasta=#form.RHMPfhasta#">
			<cfabort>
		</cfif>
		<cfset vNegociado = validadesde.RHMPnegociado >
	</cfif>

	<cftransaction>
		<!--- Inserta el movimiento --->
		<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="insertarMovimiento" returnvariable="id" > 
			<cfinvokeargument name="RHTMid" value="#form.RHTMid#">	
			<cfinvokeargument name="RHPPcodigo" 	 value="#vRHPPcodigo#" >
			<cfinvokeargument name="RHPPdescripcion" value="#vRHPPdescripcion#" >
			<cfinvokeargument name="RHMPfdesde" value="#form.RHMPfdesde#" >
			<cfinvokeargument name="RHPPid" value="#vRHPPid#" >
			<cfinvokeargument name="RHPcodigo" value="#form.RHPcodigo#" >
			<cfinvokeargument name="RHTMporcentaje" value="#form.RHTMporcentaje#" >
			
			<cfif isdefined("form.RHMPfhasta") and len(trim(form.RHMPfhasta))>
				<cfinvokeargument name="RHMPfhasta" value="#form.RHMPfhasta#" >
			</cfif>
			<cfif isdefined("vNegociado") and len(trim(vNegociado))>
				<cfinvokeargument name="RHMPnegociado" value="#vNegociado#" >
			</cfif>
		</cfinvoke>

	</cftransaction>

<cfelseif isdefined("form.Eliminar") or ( isdefined("form.EliminaInput") and form.EliminaInput eq 'ok' ) >
	<cfif not isdefined("form.chk") and isdefined("form.RHMPid")>
		<cfparam name="form.chk" default="#form.RHMPid#" >
	</cfif>

	<cfloop list="#form.chk#" delimiters="," index="i">
		<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="eliminarMovimiento" > 
			<cfinvokeargument name="RHMPid" value="#i#">	
		</cfinvoke>
	</cfloop>	

	<cflocation url="movimientos.cfm">

<cfelseif isdefined("form.Nuevo") >
	<cflocation url="registro-movimientos.cfm">
</cfif>

<!--- APLICACION DE MOVIMIENTOS --->
<cfif isdefined("form.Aplicar") or ( isdefined("form.btnAplicar") or ( isdefined("form.AplicarInput") and form.AplicarInput eq 'ok' ) ) >
	<cfif not isdefined("form.chk") and isdefined("form.RHMPid")>
		<cfparam name="form.chk" default="#form.RHMPid#" >
	</cfif>
	<cfloop list="#form.chk#" delimiters="," index="i">
		<!--- movimiento asociado a tramites --->
		<cfquery name="tramite" datasource="#session.DSN#">
			select tm.id_tramite
			from RHTipoMovimiento tm
			
			inner join RHMovPlaza mp
			on mp.RHTMid = tm.RHTMid
			and mp.RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			
			where tm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfif len(trim(tramite.id_tramite))>
			<!--- a quien le vamos a notificar, si es necesario, sobre el avance del trámite --->
			
			<cfset SubjectId = session.Usucodigo >
				
			<!--- Iniciar trámite solamente si no ha sido iniciado --->
			<cfset dataItems = StructNew()>
			<cfset dataItems.RHMPid    = i >
			<cfset dataItems.Ecodigo   = session.Ecodigo >
			<cfset dataItems.Usucodigo = session.Usucodigo >
			<cfset descripcion_tramite = 'Aprobación de Movimiento de Plaza Presupuestaria #i# <br>Solicitada por: #session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#' >
						
			<cfinvoke component="sif.Componentes.Workflow.Management" method="startProcess" returnvariable="processInstanceId">
				<cfinvokeargument name="ProcessId"	value="#tramite.id_tramite#">
				<cfinvokeargument name="RequesterId" value="#session.usucodigo#">
				<cfinvokeargument name="SubjectId"   value="#SubjectId#">
				<cfinvokeargument name="Description" value="#descripcion_tramite#">
				<cfinvokeargument name="DataItems"   value="#dataItems#">
			</cfinvoke>

			<!--- el estado debe ser otro, uno que indique que se fue e tramites --->
			<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="modificarMovimiento" > 
				<cfinvokeargument name="RHMPid"  	value="#i#" > 
				<cfinvokeargument name="RHMPestado" value="T" > 
				<cfinvokeargument name="RHTMporcentaje" value="#form.RHTMporcentaje#" > 
			</cfinvoke>

		<cfelse>
			<cftransaction>
				<cfinvoke component="rh.Componentes.RH_AplicaMovimientoPlaza" method="AplicaMovimientoPlaza" > 
					<cfinvokeargument name="RHMPid" value="#i#">
					<cfinvokeargument name="debug" value="no">
					<cfinvokeargument name="RHTMporcentaje" value="100" > 
				</cfinvoke>
			</cftransaction>
		</cfif>

	</cfloop>	
	
	<cflocation url="movimientos.cfm">

<!--- ELIMINAR COMPONENTES --->	
<cfelseif isdefined("form.btnEliminar.X") and isdefined("form.CSid_Borrar") and len(trim(form.CSid_Borrar)) >
	<cfquery datasource="#session.DSN#">
		delete from RHCMovPlaza
		where RHCMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid_Borrar#">
		  and RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPid#">
	</cfquery>
	
	<!--- Recalcular todos los componentes --->
	<cfquery name="rsComp" datasource="#Session.DSN#">
		select a.RHCMPid, a.CSid, a.Cantidad, a.Monto, c.RHMPid, c.RHMPPid, c.RHTTid, c.RHCid, c.RHMPfdesde, c.RHMPnegociado
		from RHCMovPlaza a
			inner join ComponentesSalariales b
				on b.CSid = a.CSid
			inner join RHMovPlaza c
				on c.RHMPid = a.RHMPid
		where a.RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPid#">
		order by b.CSorden, b.CScodigo, b.CSdescripcion
	</cfquery>
	
	<cfloop query="rsComp">
		<cfinvoke 
		 component="rh.Componentes.RH_EstructuraSalarial"
		 method="calculaComponente"
		 returnvariable="calculaComponenteRet">
			<cfinvokeargument name="CSid" value="#rsComp.CSid#"/>
			<cfinvokeargument name="fecha" value="#rsComp.RHMPfdesde#"/>
			<cfinvokeargument name="RHMPPid" value="#rsComp.RHMPPid#"/>
			<cfinvokeargument name="RHTTid" value="#rsComp.RHTTid#"/>
			<cfinvokeargument name="RHCid" value="#rsComp.RHCid#"/>
			<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
			<cfinvokeargument name="negociado" value="#rsComp.RHMPnegociado is 'N'#"/>
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			<cfinvokeargument name="Unidades" value="#rsComp.Cantidad#"/>
			<cfinvokeargument name="MontoBase" value="0.00"/>
			<cfinvokeargument name="Monto" value="#rsComp.Monto#"/>
			<cfinvokeargument name="TablaComponentes" value="RHCMovPlaza"/>
			<cfinvokeargument name="CampoLlaveTC" value="RHMPid"/>
			<cfinvokeargument name="ValorLlaveTC" value="#form.RHMPid#"/>
			<cfinvokeargument name="CampoMontoTC" value="Monto"/>
		</cfinvoke>

		<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="modificarComponente" >
			<cfinvokeargument name="RHCMPid" value="#rsComp.RHCMPid#"> 
			<cfinvokeargument name="RHMPid" value="#form.RHMPid#"> 
			<cfinvokeargument name="Cantidad" value="#calculaComponenteRet.Unidades#"> 
			<cfinvokeargument name="CFormato" value="" > 
			<cfinvokeargument name="Monto" value="#calculaComponenteRet.Monto#">
		</cfinvoke>
	</cfloop>
	
	<cfset id = form.RHMPid >
</cfif>

<cflocation url="registro-movimientos.cfm?RHMPid=#id#">
