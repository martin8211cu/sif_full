<cfif isdefined('form.ALTA')>
	<cfinvoke component="conavi.Componentes.registroMovimientos"
		method="VERIFICARMOVIMIENTO"
		Pid="#form.selectPeaje#"
		PTid="#form.selectTurno#"
		DEid="#form.DEid#"
		fecha="#form.fecha#"
		Ecodigo="#form.Ecodigo#"
		MBUsucodigo="#form.MBUsucodigo#"
		returnvariable="LvarExiste"
	/>
	<cfif LvarExiste>
		<cfset msg="Los valores ingresados ya pertenecen a un registro de movimientos">
		<cflocation url="registroMovimientos.cfm?modo=ALTA&msgError=#msg#">
	<cfelse>
		<cftransaction>
			<cfinvoke component="conavi.Componentes.registroMovimientos"
				method="ALTA"
				Pid="#form.selectPeaje#"
				PTid="#form.selectTurno#"
				DEid="#form.DEid#"
				fecha="#form.fecha#"
				Ecodigo="#form.Ecodigo#"
				MBUsucodigo="#form.MBUsucodigo#"
				returnvariable="LvarId"
			/>
			
			<cfinvoke component="conavi.Componentes.peajes"
				method="OBTENER_Peaje"
				Pid="#form.selectPeaje#"
				Ecodigo="#form.Ecodigo#"
				returnvariable="LvarPeaje"
			/>
			<cfloop from="1" to="#LvarPeaje.Pcarriles#" index="p">
				<cfquery name="rsPVehiculos" datasource="#session.dsn#">
					select pv.PVid
					from PVehiculos pv
						inner join PPrecio pp on pp.PVid = pv.PVid
							inner join Peaje p on p.Pid = pp.Pid and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
					where pv.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
						and p.Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.selectPeaje#">
				</cfquery>
				<cfloop query="rsPVehiculos">
					<cfinvoke component="conavi.Componentes.registroMovimientos"
						method="ALTA_PDTVehiculos"
						PETid="#LvarId#"
						PVid="#rsPVehiculos.PVid#"
						carril="#p#"
						cantidad="0"
						MBUsucodigo="#form.MBUsucodigo#"
						returnvariable="LvarIdV"
					/>
				</cfloop>
			</cfloop>
		</cftransaction>
		<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#LvarId#">
	</cfif>
<cfelseif isdefined('form.CAMBIO')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PETransacciones"
		redirect="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#"
		timestamp="#form.ts_rversion#"
		field1="PETid" 
		type1="numeric" 
		value1="#form.PETid#"
		field2="Ecodigo" 
		type2="numeric" 
		value2="#form.Ecodigo#">
	<cfinvoke component="conavi.Componentes.registroMovimientos"
		method="CAMBIO"
		PETid="#form.PETid#"
		Pid="#form.selectPeaje#"
		PTid="#form.selectTurno#"
		DEid="#form.DEid#"
		fecha="#form.fecha#"
		Ecodigo="#form.Ecodigo#"
		MBUsucodigo="#form.MBUsucodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#LvarId#">
<cfelseif isdefined('form.BAJA')>
	<cftransaction>
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="BAJA_PDTVehiculosConPet"
			PETid="#form.PETid#"
			Ecodigo="#form.Ecodigo#"
			returnvariable="LvarIdM"
		/>
		
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="BAJA_PDTCerradoConPETid"
			PETid="#form.PETid#"
			returnvariable="LvarId"
		/>
		
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="BAJA_PDTDepositoConPETid"
			PETid="#form.PETid#"
			returnvariable="LvarId"
		>
		
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="BAJA"
			PETid="#form.PETid#"
			Ecodigo="#form.Ecodigo#"
			returnvariable="LvarId"
		/>
	</cftransaction>
	<cflocation url="listaRegistroMovimientos.cfm">

<cfelseif isdefined('form.ALTACIERRE')>
	
	<cfinvoke component="conavi.Componentes.registroMovimientos"
		method="VERIFICARHORACIERRE"
		PTid="#form.selectTurno#"
		horaini="#form.horaDesde#"
		horafin="#form.horaHasta#"
		Ecodigo="#form.Ecodigo#"
		returnvariable="LvarPermitidoHORA"
	/>
	<cfif not LvarPermitidoHORA>
		<cfset msg="No coiciden la hora de inicio o final con el turno correspondientes.">
		<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=2&msgError=#msg#">
	<cfelse>
		<cfif form.selectCarril eq 'all'><!---  Si todos los carrilles estan cerrados, a cada uno se les ingresa la misma hora y comentario  --->
			<cfquery name="rsCarriles" datasource="#session.DSN#">
				select p.Pcarriles
				from Peaje p 
					inner join PETransacciones pet 
						on p.Pid = pet.Pid 
				where
					pet.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#">
					and pet.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cftransaction>
			<cfloop from="1" to="#rsCarriles.Pcarriles#" index="c">
				<cfinvoke component="conavi.Componentes.registroMovimientos"
					method="VERIFICARCIERRE"
					PETid="#form.PETid#"
					carril="#c#"
					horaini="#form.horaDesde#"
					horafin="#form.horaHasta#"
					Ecodigo="#form.Ecodigo#"
					returnvariable="LvarExisteCIERRE"
				/>
				<cfif LvarExisteCIERRE><!--- Msj para avisar que existe los datos ingresados --->
					<cftransaction action="rollback">
					<cfset msg="Los valores ingresados ya pertenecen a un registro de cierre de carill, no se insertaron los registros.">
					<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=2&msgError=#msg#">
				<cfelse>
					<cfinvoke component="conavi.Componentes.registroMovimientos"
						method="ALTA_PDTCerrado"
						PETid="#form.PETid#"
						carril="#c#"
						horaini="#form.horaDesde#"
						horafin="#form.horaHasta#"
						comentario="#form.comentario#"
						Ecodigo="#form.Ecodigo#"
						MBUsucodigo="#form.MBUsucodigo#"
						returnvariable="LvarId"
					/>
				</cfif>
			</cfloop>
			</cftransaction>
			<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=2">
		<cfelse>
			<cfinvoke component="conavi.Componentes.registroMovimientos"
				method="VERIFICARCIERRE"
				PETid="#form.PETid#"
				carril="#form.selectCarril#"
				horaini="#form.horaDesde#"
				horafin="#form.horaHasta#"
				Ecodigo="#form.Ecodigo#"
				returnvariable="LvarExisteCIERRE"
			/>
			<cfif LvarExisteCIERRE>
				<cfset msg="Los valores ingresados ya pertenecen a un registro de cierre de carill.">
				<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=2&msgError=#msg#">
			<cfelse>
				<cfinvoke component="conavi.Componentes.registroMovimientos"
					method="ALTA_PDTCerrado"
					PETid="#form.PETid#"
					carril="#form.selectCarril#"
					horaini="#form.horaDesde#"
					horafin="#form.horaHasta#"
					comentario="#form.comentario#"
					Ecodigo="#form.Ecodigo#"
					MBUsucodigo="#form.MBUsucodigo#"
					returnvariable="LvarId"
				/>
				<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&PDTCid=#LvarId#&tab=2">
			</cfif>
		</cfif>
	</cfif>
<cfelseif isdefined('form.CAMBIOCIERRE')>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="PDTCerrado"
			redirect="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&PDTCid=#form.PDTCid#&tab=2"
			timestamp="#form.ts_rversion#"
			field1="PDTCid" 
			type1="numeric" 
			value1="#form.PDTCid#">
			
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="VERIFICARHORACIERRE"
			PTid="#form.selectTurno#"
			horaini="#form.horaDesde#"
			horafin="#form.horaHasta#"
			Ecodigo="#form.Ecodigo#"
			returnvariable="LvarPermitidoHORA"
		/>
		
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="VERIFICARCIERRE"
			PDTCid="#form.PDTCid#"
			PETid="#form.PETid#"
			carril="#form.selectCarril#"
			horaini="#form.horaDesde#"
			horafin="#form.horaHasta#"
			Ecodigo="#form.Ecodigo#"
			returnvariable="LvarExisteCIERRE"
		/>
		<cfif not LvarPermitidoHORA>
			<cfset msg="No coiciden la hora de inicio o final con el turno correspondientes.">
			<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=2&msgError=#msg#">
		<cfelseif LvarExisteCIERRE>
			<cfset msg="Los valores ingresados ya pertenecen a un registro de cierre de carill.">
			<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&PDTCid=#form.PDTCid#&tab=2&msgError=#msg#">
		<cfelse>
				<cfinvoke component="conavi.Componentes.registroMovimientos"
					method="CAMBIO_PDTCerrado"
					PDTCid="#form.PDTCid#"
					PETid="#form.PETid#"
					carril="#form.selectCarril#"
					horaini="#form.horaDesde#"
					horafin="#form.horaHasta#"
					comentario="#form.comentario#"
					MBUsucodigo="#form.MBUsucodigo#"
					returnvariable="LvarId"
				/>
		</cfif>
	<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&PDTCid=#form.PDTCid#&tab=2">
<cfelseif isdefined('form.BAJACIERRE')>
	<cfinvoke component="conavi.Componentes.registroMovimientos"
		method="BAJA_PDTCerrado"
		PDTCid="#form.PDTCid#"
		returnvariable="LvarId"
	/>
	<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=2">
<cfelseif isdefined('form.ALTADEPOSITO')>
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select count(1) as existe from PDTDeposito 
		where PDTDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.documento#">
			and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#">
	</cfquery>
	<cfquery name="PETransacciones" datasource="#session.dsn#">
		select Ecodigo from PETransacciones 
			where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#">
	</cfquery>
	<cfquery name="rsInsertar" datasource="#session.DSN#">
		select 1
		from MLibros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#PETransacciones.Ecodigo#">
			and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	</cfquery>	
	<cfquery name="rsInsertarEM" datasource="#session.DSN#">
		select 1
		from EMovimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#PETransacciones.Ecodigo#">
			and EMdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">		
	</cfquery>	
	<cfif rsExiste.existe gt 0 or rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			alert("El documento digitado ya pertenece a un registro. Digite otros datos.");
			history.back(-1);
		</script>
		</cfoutput>
	<cfelse>
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="ALTA_PDTDeposito"
			PETid="#form.PETid#"
			CBid="#form.CBid#"
			Mcodigo="#form.Mcodigo#"
			BTid="#form.BTid#"
			monto="#replace(form.monto,',','','ALL')#"
			documento="#form.documento#"
			descripcion="#form.descripcion#"
			tipoCambio="#replace(form.EMtipocambio,',','','ALL')#"
			MBUsucodigo="#form.MBUsucodigo#"
			returnvariable="LvarId"
		>
		<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=3&PDTDid=#LvarId#">
	</cfif>
<cfelseif isdefined('form.CAMBIODEPOSITO')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PDTDeposito"
		redirect="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=3&PDTDid=#form.PDTDid#"
		timestamp="#form.ts_rversion#"
		field1="PDTDid" 
		type1="numeric" 
		value1="#form.PDTDid#">
	<cfquery name="PETransacciones" datasource="#session.dsn#">
		select Ecodigo from PETransacciones 
			where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#">
	</cfquery>
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select count(1) as existe from PDTDeposito 
			where PDTDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.documento#">
			and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#">
			and PDTDid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PDTDid#">
	</cfquery>
	<cfquery name="rsInsertar" datasource="#session.DSN#">
		select 1
		from MLibros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#PETransacciones.Ecodigo#">
			and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	</cfquery>
	<cfquery name="rsInsertarEM" datasource="#session.DSN#">
		select 1
		from EMovimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#PETransacciones.Ecodigo#">
			and EMdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">		
	</cfquery>	
	<cfif rsExiste.existe gt 0 or rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			alert("El documento digitado ya pertenece a un registro. Digite otros datos.");
			history.back(-1);
		</script>
		</cfoutput>
	<cfelse>
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="CAMBIO_PDTDeposito"
			PDTDid="#form.PDTDid#"
			PETid="#form.PETid#"
			CBid="#form.CBid#"
			Mcodigo="#form.Mcodigo#"
			BTid="#form.BTid#"
			monto="#replace(form.monto,',','','ALL')#"
			documento="#form.documento#"
			descripcion="#form.descripcion#"
			tipoCambio="#replace(form.EMtipocambio,',','','ALL')#"
			MBUsucodigo="#form.MBUsucodigo#"
			returnvariable="LvarId"
		>
		<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=3&PDTDid=#LvarId#">
	</cfif>
<cfelseif isdefined('form.BAJADEPOSITO')>
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="BAJA_PDTDeposito"
			PDTDid="#form.PDTDid#"
			returnvariable="LvarId"
		>
	<cflocation url="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=3">

<cfelseif isdefined('form.Aplicar')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PETransacciones"
		redirect="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#"
		timestamp="#form.ts_rversion#"
		field1="PETid" 
		type1="numeric" 
		value1="#form.PETid#"
		field2="Ecodigo" 
		type2="numeric" 
		value2="#form.Ecodigo#">
	<cfinvoke component="conavi.Componentes.registroMovimientos"
		method="APLICA"
		PETid="#form.PETid#"
		PETestado="2"
		returnvariable="LvarId"
	>
	<cflocation url="listaRegistroMovimientos.cfm">

<cfelse>
	<cfif isdefined('url.PDTVid') and isdefined('url.PETid') and isdefined('url.PETid') and isdefined('url.MBUsucodigo')>
	
		<cfinvoke component="conavi.Componentes.registroMovimientos"
			method="CAMBIO_PDTVehiculos"
			PDTVid="#url.PDTVid#"
			PETid="#url.PETid#"
			cantidad="#url.PDTVcantidad#"
			MBUsucodigo="#url.MBUsucodigo#"
			returnvariable="LvarIdM"
		/>
		<cfquery name="rsTotalPorCarril" datasource="#session.dsn#">
			select enc.PETfecha Dia,tur.PTcodigo turno, pea.Pcodigo Peaje,cat.PDTVcarril carril, Sum(coalesce(cat.PDTVcantidad * (pre.PPrecio * coalesce(TCcompra,1)) * case when veh.PVoficial = '1' then 0 else 1 end,0)) Dinero
			from PPrecio pre
				 inner join PVehiculos veh 
        			on pre.PVid = veh.PVid 
				inner join Peaje pea 
					on pre.Pid = pea.Pid 
				inner join Monedas m
					on m.Mcodigo = pre.Mcodigo
				 inner join PETransacciones enc 
				 	inner join PTurnos tur 
						on tur.PTid = enc.PTid 
				on enc.Pid = pea.Pid 
				left outer join Htipocambio htc 
           			on htc.Mcodigo = m.Mcodigo   
           			and htc.Ecodigo = #session.Ecodigo#  
           			and enc.PETfecha BETWEEN htc.Hfecha and htc.Hfechah 
 				inner join PDTVehiculos cat 
					on cat.PETid = enc.PETid and cat.PVid = veh.PVid
			where enc.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PETid#">
			group by enc.PETfecha,tur.PTcodigo, pea.Pcodigo,cat.PDTVcarril     
			order by enc.PETfecha,tur.PTcodigo, pea.Pcodigo,cat.PDTVcarril 
		</cfquery>
		<cfquery name="rsTotalDepositos" datasource="#session.dsn#">
		select coalesce(sum( PDTDmonto * PDTDtipocambio),0) Total
		from PDTDeposito
		where PETid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PETid#">
	  </cfquery>
		<cfquery name="rsTotalPorVehiculo" datasource="#session.dsn#">
			select enc.PETfecha Dia,tur.PTcodigo turno, pea.Pcodigo Peaje,veh.PVid vehiculo, Sum(coalesce(cat.PDTVcantidad * (pre.PPrecio * coalesce(TCcompra, 1)) * case when veh.PVoficial = '1' then 0 else 1 end,0)) Dinero
			from PPrecio pre
				inner join PVehiculos veh
					on pre.PVid = veh.PVid
				inner join Peaje pea
					on pre.Pid = pea.Pid
				inner join Monedas m
				  on m.Mcodigo = pre.Mcodigo
				inner join PETransacciones enc
					inner join PTurnos tur
						on tur.PTid = enc.PTid 
				  on enc.Pid = pea.Pid
				left outer join Htipocambio htc 
					   on htc.Mcodigo = m.Mcodigo 
					   and htc.Ecodigo = #session.Ecodigo# 
					   and enc.PETfecha  BETWEEN htc.Hfecha and  htc.Hfechah
				inner join PDTVehiculos cat
					on cat.PETid = enc.PETid
					and cat.PVid = veh.PVid
			where enc.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PETid#">
			group by enc.PETfecha,tur.PTcodigo, pea.Pcodigo,veh.PVid     
			order by enc.PETfecha,tur.PTcodigo, pea.Pcodigo,veh.PVid  
		</cfquery>
		<cfset montoTotal=0>
		<cfloop query="rsTotalPorCarril">
			<cfset montoTotal+=Dinero>
		</cfloop>
		<cfquery name="rsTotalVehiculos" datasource="#session.dsn#">
		select coalesce(sum(cat.PDTVcantidad * (pre.PPrecio * coalesce(TCcompra, 1)) * case when veh.PVoficial = '1' then 0 else 1 end),0) Total
			from PPrecio pre
				inner join PVehiculos veh
					on pre.PVid = veh.PVid
				inner join Peaje pea
					on pre.Pid = pea.Pid
				inner join Monedas m
				  on m.Mcodigo = pre.Mcodigo
				inner join PETransacciones enc
					inner join PTurnos tur
						on tur.PTid = enc.PTid 
				  on enc.Pid = pea.Pid 
				 left outer join Htipocambio htc 
					   on htc.Mcodigo = m.Mcodigo 
					   and htc.Ecodigo = #session.Ecodigo# 
					   and enc.PETfecha  BETWEEN htc.Hfecha and  htc.Hfechah
				inner join PDTVehiculos cat
					on cat.PETid = enc.PETid
					and cat.PVid = veh.PVid
			where enc.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PETid#"> 
	    </cfquery>
	    <cfset dif=rsTotalVehiculos.Total-rsTotalDepositos.Total>
		
		<cfoutput>
			<!--- Modifica los valores de los input de detalles de vehiculo--->
			<script language="javascript1.2" type="text/javascript">
				<cfloop query="rsTotalPorCarril">
					window.parent.document.getElementById('TV_#carril#').value=num2money(#Dinero#);
				</cfloop>
				<cfloop query="rsTotalPorVehiculo">
					window.parent.document.getElementById('TH_#vehiculo#').value=num2money(#Dinero#);
				</cfloop>
				window.parent.document.getElementById('TT').value=num2money(#montoTotal#);
				window.parent.document.getElementById('tdiferienciah').value=#dif#;
				window.parent.document.getElementById('TVehiculo').value=#rsTotalVehiculos.Total#;
				window.parent.document.getElementById('TDeposito').value=#rsTotalDepositos.Total#;
								
				function num2money(n_value) {	
					// validate input
					if (isNaN(Number(n_value)))
					return 'ERROR';	
					// save the sign
					var b_negative = Boolean(n_value < 0);
					n_value = Math.abs(n_value);
					// round to 1/100 precision, add ending zeroes if needed
					var s_result = String(Math.round(n_value*1e2)%1e2 + '00').substring(0,2);
					// separate all orders
					var b_first = true;
					var s_subresult;
					while (n_value > 1) {
					s_subresult = (n_value >= 1e3 ? '00' : '') + Math.floor(n_value%1e3);
					s_result = s_subresult.slice(-3) + (b_first ? '.' : ',') + s_result;
					b_first = false;
					n_value = n_value/1e3;
					}
					// add at least one integer digit
					if (b_first)
					s_result = '0.' + s_result;
					// apply formatting and return
					return b_negative ? '(' + s_result + ')' : s_result;
				}
			</script>
		</cfoutput>
	<cfelse>
		<cflocation url="registroMovimientos.cfm?modo=ALTA">
	</cfif>
</cfif>