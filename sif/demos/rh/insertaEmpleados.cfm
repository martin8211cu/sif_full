<!--- 1. Insertar empleados:
	  	1.1. Los todos los empleados de la empresa DATA
	  	1.2. El decimo corresponde al usuario loggeado en session
	  2. Generar un usuario para los nueve empleados generados.
--->

<!--- Crea estructura en session para hacer una relacion entre los empleados de DATA 
      y su correspondiente empleado en la nueva empresa que se esta configurando --->
<cfset session.LvarEmpleados = structnew() >	
<cfset session.LvarEmpleados.lista = '' >		<!--- lista de empleados (DATA) que se van a trabajar --->	 

<!--- 1.1 Empleados de DATA --->
<cfquery name="data" datasource="#session.DSNnuevo#">
	select * 
	from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>

<cfif data.recordcount eq 0>
	<cfquery name="empleados" datasource="#session.DSNnuevo#" ><!----maxrows="9"--->
		select *
		from DatosEmpleado
		where Ecodigo = #vn_Ecodigo#
		order by DEidentificacion
	</cfquery>

	<cfset session.LvarEmpleados.lista = valuelist(empleados.DEid) >
		
	<!--- Banco --->
	<cfquery name="banco" datasource="#session.DSNnuevo#" maxrows="1">
		select Bid from Bancos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
	</cfquery>
	<!--- Tipo de Nomina --->
	<cfquery name="nomina" datasource="#session.DSNnuevo#" maxrows="1">
		select Tcodigo 
		from TiposNomina 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
		  <!---and Tcodigo = 'QUI'--->
	</cfquery>
	<!--- Moneda --->
	<cfquery name="moneda" datasource="#session.DSNnuevo#" maxrows="1">
		select Mcodigo from Monedas where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
	</cfquery>
	
	<!--- inserta cada uno de los empleados y su informacion --->
	<cfloop query="empleados">
		<cfset LvarDEid = empleados.DEid >
		<cfquery name="SelectI_empleado" datasource="#session.DSNnuevo#">
			select  
					<cfif len(trim(banco.Bid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#banco.Bid#"><cfelse>null</cfif> as Bid,
					NTIcodigo, 
					(select x.Tcodigo from TiposNomina x where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
						and x.Tcodigo = DatosEmpleado.Tcodigo) as Tcodigo,
					<!---<cfif len(trim(nomina.Tcodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#nomina.Tcodigo#"><cfelse>null</cfif>,--->
					DEidentificacion, 
					DEnombre, 
					DEapellido1, 
					DEapellido2, 
					CBTcodigo, 
					DEcuenta, 
					CBcc, 
					<cfif len(trim(moneda.Mcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#moneda.Mcodigo#"><cfelse>null</cfif> as Mcodigo,
					DEdireccion, 
					DEtelefono1, 
					DEtelefono2, 
					DEemail, 
					DEcivil, 
					DEfechanac, 
					DEsexo, 
					DEcantdep, 
					DEobs1, 
					DEobs2, 
					DEobs3, 
					DEdato1, 
					DEdato2, 
					DEdato3, 
					DEdato4, 
					DEdato5, 
					DEinfo1, 
					DEinfo2, 
					DEinfo3, 
					Usucodigo, 
					Ulocalizacion, 
					DEsistema,
					null as DEusuarioportal,
					null as DEtarjeta,
					null as DEpassword,
					Ppais
			from DatosEmpleado		
			where Ecodigo = #vn_Ecodigo#
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#">
		</cfquery>
		<cfquery name="i_empleado" datasource="#session.DSNnuevo#">
			insert into DatosEmpleado(	Ecodigo, 
										Bid, 
										NTIcodigo, 
										Tcodigo, 
										DEidentificacion, 
										DEnombre, 
										DEapellido1, 
										DEapellido2, 
										CBTcodigo, 
										DEcuenta, 
										CBcc, 
										Mcodigo, 
										DEdireccion, 
										DEtelefono1, 
										DEtelefono2, 
										DEemail, 
										DEcivil, 
										DEfechanac, 
										DEsexo, 
										DEcantdep, 
										DEobs1, 
										DEobs2, 
										DEobs3, 
										DEdato1, 
										DEdato2, 
										DEdato3, 
										DEdato4, 
										DEdato5, 
										DEinfo1, 
										DEinfo2, 
										DEinfo3, 
										Usucodigo, 
										Ulocalizacion, 
										DEsistema, 
										DEusuarioportal, 
										DEtarjeta, 
										DEpassword, 
										Ppais, 
										BMUsucodigo )
								VALUES(
									   #session.EcodigoNuevo#,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#SelectI_empleado.Bid#"              voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#SelectI_empleado.NTIcodigo#"        voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#SelectI_empleado.Tcodigo#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#SelectI_empleado.DEidentificacion#" voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#SelectI_empleado.DEnombre#"         voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#SelectI_empleado.DEapellido1#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#SelectI_empleado.DEapellido2#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#SelectI_empleado.CBTcodigo#"        voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  value="#SelectI_empleado.DEcuenta#"         voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  value="#SelectI_empleado.CBcc#"             voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#SelectI_empleado.Mcodigo#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#SelectI_empleado.DEdireccion#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#SelectI_empleado.DEtelefono1#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#SelectI_empleado.DEtelefono2#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="120" value="#SelectI_empleado.DEemail#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#SelectI_empleado.DEcivil#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#SelectI_empleado.DEfechanac#"       voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#SelectI_empleado.DEsexo#"           voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#SelectI_empleado.DEcantdep#"        voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#SelectI_empleado.DEobs1#"           voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#SelectI_empleado.DEobs2#"           voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#SelectI_empleado.DEobs3#"           voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#SelectI_empleado.DEdato1#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#SelectI_empleado.DEdato2#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#SelectI_empleado.DEdato3#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#SelectI_empleado.DEdato4#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#SelectI_empleado.DEdato5#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#SelectI_empleado.DEinfo1#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#SelectI_empleado.DEinfo2#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#SelectI_empleado.DEinfo3#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#SelectI_empleado.Usucodigo#"        voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#SelectI_empleado.Ulocalizacion#"    voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#SelectI_empleado.DEsistema#"        voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#SelectI_empleado.DEusuarioportal#"  voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#SelectI_empleado.DEtarjeta#"        voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="65"  value="#SelectI_empleado.DEpassword#"       voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#SelectI_empleado.Ppais#"            voidNull>,
									   #session.UsucodigoNuevo#
								)
						
			<cf_dbidentity1 datasource="#session.DSNnuevo#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSNnuevo#" name="i_empleado">
		
		<cfset structInsert(session.LvarEmpleados, LvarDEid, i_empleado.identity) >

		<!--- Datos Familiares --->			
		<cfquery datasource="#session.DSNnuevo#">
			insert into FEmpleado( DEid, NTIcodigo, FEidentificacion, Pid, FEnombre, FEapellido1, FEapellido2, FEfnac, 
							  FEdir, FEdiscapacitado, FEfinidiscap, FEffindiscap, FEasignacion, FEfiniasignacion, FEffinasignacion, 
							  FEestudia, FEsexo, FEfiniestudio, FEffinestudio, FEdatos1, FEdatos2, FEdatos3, FEobs1, FEobs2, FEinfo1, 
							  FEinfo2, Usucodigo, Ulocalizacion, FEdeducrenta, FEidconcepto, FEdeducdesde, FEdeduchasta, BMUsucodigo )
	
			select #session.LvarEmpleados[LvarDEid]#, NTIcodigo, FEidentificacion, Pid, FEnombre, FEapellido1, FEapellido2, FEfnac, 
				   FEdir, FEdiscapacitado, FEfinidiscap, FEffindiscap, FEasignacion, FEfiniasignacion, FEffinasignacion, 
				   FEestudia, FEsexo, FEfiniestudio, FEffinestudio, FEdatos1, FEdatos2, FEdatos3, FEobs1, FEobs2, FEinfo1, 
				   FEinfo2, Usucodigo, Ulocalizacion, FEdeducrenta, FEidconcepto, FEdeducdesde, FEdeduchasta, BMUsucodigo
			from FEmpleado	   
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#">
		</cfquery>
		
		<!--- Anotaciones --->
		<cfquery datasource="#session.DSNnuevo#" >
			insert into RHAnotaciones(DEid, EFid, RHAfecha, RHAfsistema, RHAdescripcion, Usucodigo, Ulocalizacion, RHAtipo, BMUsucodigo)
			select #session.LvarEmpleados[LvarDEid]#, null, RHAfecha, RHAfsistema, RHAdescripcion, Usucodigo, Ulocalizacion, RHAtipo, BMUsucodigo
			from RHAnotaciones
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#">
		</cfquery>

		<!--- Cargas --->
		<cfquery datasource="#session.DSNnuevo#">
			insert into CargasEmpleado(DEid, DClinea, CEdesde, CEhasta, CEvalorpat, CEvaloremp, BMUsucodigo)
			select #session.LvarEmpleados[LvarDEid]#, DClinea, CEdesde, CEhasta, CEvalorpat, CEvaloremp, BMUsucodigo
			from CargasEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#">
		</cfquery>		
		
		<!--- Deducciones --->
		<cfquery datasource="#session.DSNnuevo#">
			insert into DeduccionesEmpleado ( DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, Dmetodo, Dvalor, Dfechaini, Dfechafin, 
								 			  Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, Usucodigo, Ulocalizacion, Dactivo, 
								 			  Dcontrolsaldo, Dreferencia  )
											  
			select #session.LvarEmpleados[LvarDEid]#, #session.EcodigoNuevo#, SNcodigo, TDid, Ddescripcion, Dmetodo, Dvalor, Dfechaini, Dfechafin, 
	 			   Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, Usucodigo, Ulocalizacion, Dactivo, 
	 			   Dcontrolsaldo, Dreferencia
			from DeduccionesEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#">
			  and Ecodigo=#vn_Ecodigo#
		</cfquery>

		<!--- Datos Laborales --->
		<!--- Se supone que solo inserta un registro, pero no se como hacer eso, es decir no se cual es ese registro. --->
		<!--- Preguntar por los campos que van en nulo ( RHTCid, RHCconcurso, DLidtramite, IEid, TEid, DLreferencia ) --->
		<cfquery name="rs" datasource="#session.DSNnuevo#">						
			insert into DLaboralesEmpleado( DLconsecutivo, 
											DEid, 
											RHTid, 
											Ecodigo, 
											RHPid, 
											RHPcodigo, 
											Tcodigo, 
											RVid, 
											Dcodigo, 
											Ocodigo, 
											RHJid, 
											<!----RHTCid, ---->
											RHCconcurso, 
											DLfvigencia, 
											DLffin, 
											DLsalario, 
											DLobs, 
											DLfechaaplic, 		
											Ecodigoant, 
											Dcodigoant, 
											Ocodigoant, 
											RHPidant, 
											RHPcodigoant, 
											Tcodigoant, 
											DLsalarioant, 
											Usucodigo, 
											Ulocalizacion, 
											DLporcplaza, 
											RVidant, 
											DLporcplazaant, 
											DLestado, 
											DLporcsal, 
											DLporcsalant, 
											RHJidant, 
											DLidtramite, 
											DLvdisf, 
											DLvcomp, 
											IEid, 
											TEid, 
											DLreferencia, 
											BMUsucodigo)										
			select 	dl.DLconsecutivo, 
					#session.LvarEmpleados[LvarDEid]#, 	
					(select RHTid from RHTipoAccion rhta where rhta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#" > and rhta.RHTcodigo=ta.RHTcodigo) as RHTid, 
					#session.EcodigoNuevo#, 
					( select RHPid from RHPlazas rhpl where rhpl.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#" > and rhpl.RHPcodigo = pl.RHPcodigo ) as RHPid, 
					dl.RHPcodigo, 
					'QUI',
					( select RVid from RegimenVacaciones rhrv where rhrv.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#" > and rhrv.RVcodigo=rv.RVcodigo ) as RHVid, 
					dl.Dcodigo, 
					dl.Ocodigo, 
					( select RHJid from RHJornadas rhj where rhj.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#" > and rhj.RHJcodigo=j.RHJcodigo ) as RHJid, 
					<!---null, ---->
					null, 
					dl.DLfvigencia, 
					dl.DLffin, 
					dl.DLsalario, 
					dl.DLobs, 
					dl.DLfechaaplic, 
					dl.Ecodigoant, 
					dl.Dcodigoant, 
					dl.Ocodigoant, 
					dl.RHPidant, 
					dl.RHPcodigoant, 
					dl.Tcodigoant, 
					dl.DLsalarioant, 
					dl.Usucodigo, 
					dl.Ulocalizacion, 
					dl.DLporcplaza, 
					dl.RVidant, 
					dl.DLporcplazaant, 
					dl.DLestado, 
					dl.DLporcsal, 
					dl.DLporcsalant, 
					dl.RHJidant, 
					null, 
					dl.DLvdisf, 
					dl.DLvcomp, 
					null, 
					null, 
					null, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#"> 
			from DLaboralesEmpleado dl 
			
			-- Tipos de accion
			inner join RHTipoAccion ta
			on ta.Ecodigo=dl.Ecodigo
			and ta.RHTid=dl.RHTid
			
			-- Plazas
			left outer join RHPlazas pl
			on pl.Ecodigo=dl.Ecodigo
			and pl.RHPid=dl.RHPid
			
			-- Regimen de vacaciones
			inner join RegimenVacaciones rv
			on rv.Ecodigo=dl.Ecodigo
			and rv.RVid=dl.RVid
			
			-- Jornadas
			inner join RHJornadas j
			on j.Ecodigo=dl.Ecodigo
			and j.RHJid=dl.RHJid
			
			where dl.Ecodigo=#vn_Ecodigo# 
			and dl.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#">
		</cfquery>
		<!--- Linea del Tiempo --->
		<cfquery datasource="#session.DSNnuevo#">
			insert LineaTiempo(	DEid, 
								Ecodigo, 
								Tcodigo, 
								RHTid, 
								Ocodigo, 
								Dcodigo, 
								RHPid, 
								RHPcodigo, 
								RVid, 
								RHJid, 
								<!----RHTCid, --->
								LTdesde, 
								LThasta, 
								LTporcplaza, 
								LTsalario, 
								LTporcsal, 
								CPid, 
								IEid, 
								TEid, 
								BMUsucodigo )
			select 	#session.LvarEmpleados[LvarDEid]#, 
					#session.EcodigoNuevo#, 
					'QUI', 
					(select RHTid from RHTipoAccion rhta where rhta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#" > and rhta.RHTcodigo=ta.RHTcodigo) as RHTid,
					lt.Ocodigo, 
					lt.Dcodigo, 
					( select RHPid from RHPlazas rhpl where rhpl.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#" > and rhpl.RHPcodigo = pl.RHPcodigo ) as RHPid, 
					lt.RHPcodigo, 
					( select RVid from RegimenVacaciones rhrv where rhrv.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#" > and rhrv.RVcodigo=rv.RVcodigo ) as RHVid,
					( select RHJid from RHJornadas rhj where rhj.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#" > and rhj.RHJcodigo=j.RHJcodigo ) as RHJid,
					<!----null, ---->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(year(now()), 1, 1)#">, 
					lt.LThasta, 
					lt.LTporcplaza, 
					lt.LTsalario, 
					lt.LTporcsal, 
					null, 
					null, 
					null, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
			from LineaTiempo lt
			
			-- Tipos de Accion
			inner join RHTipoAccion ta
			on ta.Ecodigo=lt.Ecodigo
			and ta.RHTid=lt.RHTid
			
			-- Plazas
			inner join RHPlazas pl
			on pl.Ecodigo=lt.Ecodigo
			and pl.RHPid=lt.RHPid
			
			-- Regimen de vacaciones
			inner join RegimenVacaciones rv
			on rv.Ecodigo=lt.Ecodigo
			and rv.RVid=lt.RVid
			
			-- Jornadas
			inner join RHJornadas j
			on j.Ecodigo=lt.Ecodigo
			and j.RHJid=lt.RHJid
			
			where lt.Ecodigo=#vn_Ecodigo#
			  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#">
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
		</cfquery>
<!--- 		<cfquery datasource="#session.DSNnuevo#">
			insert RolEmpleadoSNegocios 
				(Ecodigo, DEid, RESNtipoRol, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[LvarDEid]#">, 
				2, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">)
		</cfquery>		 --->
	</cfloop>


	<!--- Inserta el usario actual como empleado de RH --->
	<cfquery name="SelectI_empleado" datasource="#session.DSNnuevo#">
		select 	
				(select min(NTIcodigo) from NTipoIdentificacion ) as NTIcodigo, 
				Pid as DEidentificacion, 
				Pnombre as DEnombre, 
				Papellido1 as DEapellido1, 
				Papellido2 as DEapellido2, 
				(select Mcodigo from Empresas where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#"> ) as Mcodigo, 
				Pid as CBcc,
				direccion1 as DEdireccion, 
				Poficina as DEtelefono1,
				Pcelular as DEtelefono2,
				Pemail1 as DEemail,
				0 as DEcivil,
				coalesce(Pnacimiento,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(1980,1,1)#">) as DEfechanac, 
				coalesce(Psexo,'M') as DEsexo, 
				Usucodigo,
				'00' as Ulocalizacion,
				( select min(Bid) from Bancos where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoNuevo#"> ) as Bid, 
				Ppais
		from Usuario u
		
		inner join DatosPersonales dp
		on dp.datos_personales=u.datos_personales
		
		inner join Direcciones d
		on d.id_direccion=u.id_direccion
		
		where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
	</cfquery>
	<cfquery name="inserta_empl" datasource="#session.DSNnuevo#">
		insert into DatosEmpleado(	Ecodigo,
									NTIcodigo,
									DEidentificacion,
									DEnombre,
									DEapellido1,
									DEapellido2,
									Mcodigo,
									CBcc,
									DEdireccion,
									DEtelefono1,
									DEtelefono2,
									DEemail,
									DEcivil,
									DEfechanac,
									DEsexo,
									Usucodigo,
									Ulocalizacion,
									Bid,
									Ppais )
						VALUES(
									   #session.EcodigoNuevo#,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#SelectI_empleado.NTIcodigo#"        voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#SelectI_empleado.DEidentificacion#" voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#SelectI_empleado.DEnombre#"         voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#SelectI_empleado.DEapellido1#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#SelectI_empleado.DEapellido2#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#SelectI_empleado.Mcodigo#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  value="#SelectI_empleado.CBcc#"             voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#SelectI_empleado.DEdireccion#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#SelectI_empleado.DEtelefono1#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#SelectI_empleado.DEtelefono2#"      voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="120" value="#SelectI_empleado.DEemail#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#SelectI_empleado.DEcivil#"          voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#SelectI_empleado.DEfechanac#"       voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#SelectI_empleado.DEsexo#"           voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#SelectI_empleado.Usucodigo#"        voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#SelectI_empleado.Ulocalizacion#"    voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#SelectI_empleado.Bid#"              voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#SelectI_empleado.Ppais#"            voidNull>
								)			
									
		
		<cf_dbidentity1 datasource="#session.DSNnuevo#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSNnuevo#" name="inserta_empl">
		
	
	<cfquery name="rsExiste" datasource="#session.DSNnuevo#">
		select 1 from UsuarioReferencia
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCNuevo#">
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
	</cfquery>
	
	<cfif isdefined("rsExiste") and rsExiste.RecordCount EQ 0>
		<cfquery datasource="#session.DSNnuevo#">
			insert into UsuarioReferencia( Usucodigo, Ecodigo, STabla, llave, BMfecha, BMUsucodigo )
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCNuevo#">,
					 'DatosEmpleado',
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#inserta_empl.identity#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#"> )
		</cfquery>
	</cfif>	
</cfif>
