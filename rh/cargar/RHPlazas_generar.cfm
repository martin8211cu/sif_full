<!--- 
	******************************************
	* CARGA INICIAL DE RHPLAZAS
	* FECHA DE CREACIÓN:	09/04/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de generaraciÃ³n final
	* Este archivo requiere es para
	* realizar la copia final de la
	* tabla temporal a la tabla real.
	******************************************
--->

<cfquery datasource="#Gvar.Conexion#">
	insert into RHPlazas (
		Ecodigo, 
		RHPcodigo, 
		RHPdescripcion, 
		RHPpuesto, 
		CFid, 
		Dcodigo, 
		Ocodigo,
		CFidconta )	 
	select 	#Gvar.Ecodigo#, 
			#Gvar.table_name#.CDRHHPLcodigo, 
			#Gvar.table_name#.CDRHHPLdescripcion, 
			#Gvar.table_name#.CDRHHPcodigo, 
			b.CFid, 
			null,
			null, 
			null		
	from  #Gvar.table_name#
		inner join CFuncional b
			on #Gvar.table_name#.CDRHHCFcodigo = b.CFcodigo
			and b.Ecodigo = #Gvar.Ecodigo#
		inner join RHPuestos c
			on #Gvar.table_name#.CDRHHPcodigo = c.RHPcodigo
			and c.Ecodigo = #Gvar.Ecodigo#				   
	where CDPcontrolv = 1
		and CDPcontrolg = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#				   	
		
</cfquery>


<cfquery name="rsPlazas" datasource="#Gvar.Conexion#">
	select count(1) 
	from  RHPlazas 
	where Ecodigo = #Gvar.Ecodigo#
</cfquery>		   

<cfif rsPlazas.recordcount GT 0>


    <!--- RRiettie: Actualizar la Oficina y el Departmamento del Centro Funcional --->
	<cfquery name="rsUpdateOficinaDepto" datasource="#Gvar.Conexion#">
	update RHPlazas 
    set Dcodigo=(select Dcodigo 
			 	from CFuncional cf 
                where cf.CFid=RHPlazas.CFid
             	and cf.Ecodigo=RHPlazas.Ecodigo),

		 Ocodigo=(select Ocodigo 
			      from CFuncional cf 
                  where cf.CFid=RHPlazas.CFid
                  and cf.Ecodigo=RHPlazas.Ecodigo)
                   
    where RHPlazas.Dcodigo is null 
    and RHPlazas.Ocodigo is null
    and RHPlazas.Ecodigo =  #Gvar.Ecodigo#	
	</cfquery>	
	
	 <!--- RRiettie: Actualizar el centro funcional para contabilidad --->
	<cfquery name="rsUpdateCentroFuncionalparaConta" datasource="#Gvar.Conexion#">
	update RHPlazas
    set CFidconta = CFid
    where CFidconta is null
    and Ecodigo =  #Gvar.Ecodigo#	
    </cfquery>	
    
	
	<!--- Variable de Fecha --->
	<cfset Lvar_Fecha = createDate(1900,01,01)>
	
	<!--- Inserta en la tabla RHPlazaPresupuestaria --->
	<cfquery datasource="#Gvar.Conexion#">
		insert into RHPlazaPresupuestaria (
			Ecodigo, 
			RHPPcodigo, 
			RHPPdescripcion, 
			RHPPfechav, 
			Mcodigo, 
			BMfecha, 
			BMUsucodigo )  
		select 
			b.Ecodigo,  
			b.RHPcodigo, 
			b.RHPdescripcion, 
			#Lvar_Fecha#, 
			c.Mcodigo, 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			#session.usucodigo#
		from RHPlazas b
			inner join Empresas c
				on b.Ecodigo = c.Ecodigo
				and b.Ecodigo = #Gvar.Ecodigo#
		where not exists (	select 1 
							from RHPlazaPresupuestaria a
							where a.Ecodigo = b.Ecodigo
							and a.RHPPcodigo = b.RHPcodigo )
		and b.Ecodigo = #Gvar.Ecodigo#					
	</cfquery>
	
		
</cfif>	

<!---  Inserta las Movimientos de Plazas --->

<!---  Verifica Si el Tipo de Movimiento para la Carga de Datos ya fue creado --->
	<cfquery datasource="#Gvar.Conexion#" name="rsTipoMovCreado">
		select * 
		from RHTipoMovimiento
		where RHTMcodigo = 'CRE'
		and RHTMcomportamiento = 10
		and Ecodigo = #Gvar.Ecodigo#
	</cfquery>

<cfif rsTipoMovCreado.recordcount EQ 0>

<!--- Inserta un Tipo de Movimiento de Comportamiento = 10 (creaciÃ³n de plaza) --->
<cfquery datasource="#Gvar.Conexion#">
	insert into RHTipoMovimiento (
		Ecodigo,			RHTMcodigo, 		RHTMdescripcion, 		
		modtabla, 			modcategoria, 		modestadoplaza, 	
		modcfuncional, 		modcentrocostos, 	modcomponentes,
		modindicador, 		modpuesto, 			modfechahasta, 
		RHTMcomportamiento, BMfecha, 			BMUsucodigo )
	values(	
		#Gvar.Ecodigo#, 	'CRE', 				'Creación de Plaza', 
		0, 					0, 					0, 
		0, 					0, 					0, 
		0, 					0, 					0, 
		10, 				
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		0  ) 
</cfquery>

</cfif>

<!--- Variables de Fechas Ini y Fin --->
<cfset FechaIni = createDate(1900,01,01)>
<cfset FechaFin = createDate(6100,01,01)>

<cfquery datasource="#Gvar.Conexion#">
	insert into RHMovPlaza (
		Ecodigo, 		RHPPid, 		RHPPcodigo, 		RHPPdescripcion, 
		RHMPPid, 		RHCid, 			RHTTid, 			RHTMid, 
		RHMPfdesde, 	RHMPfhasta, 	RHMPestado, 		RHMPnegociado, 
		RHMPmonto, 		Mcodigo, 		id_tramite, 		RHMPestadoplaza, 
		CFidant, 		CFidnuevo, 		CFidcostoant, 		CFidcostonuevo, 
		BMfecha, 		BMUsucodigo, 	CPcuenta, 			CFcuenta )

	select 	
		a.Ecodigo, 		a.RHPPid, 		a.RHPPcodigo, 		a.RHPPdescripcion,  
		null, 			null, 			null, 				d.RHTMid, 
		#FechaIni#, 	#FechaFin#, 	'A', 				'T', 
		1000000, 		b.Mcodigo, 		null, 				'A', 
		null, 			null, 			null, 				null, 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,			
		a.BMUsucodigo, 	null, 				null
		
	from RHPlazaPresupuestaria a
		inner join Empresas b
			on a.Ecodigo = b.Ecodigo
			and a.Ecodigo = #Gvar.Ecodigo#
		inner join RHPlazas c
			on a.Ecodigo = c.Ecodigo
			and a.RHPPcodigo = c.RHPcodigo
		inner join RHTipoMovimiento d
			on a.Ecodigo = d.Ecodigo
			and d.RHTMcodigo = 'CRE'
			and d.RHTMcomportamiento = 10
			
	where not exists (	select 1 
						from RHMovPlaza x 
						where x.Ecodigo = a.Ecodigo 
							and x.RHPPid = a.RHPPid )
	and a.Ecodigo = #Gvar.Ecodigo#						
</cfquery>

<!--- Crea la Linea del Tiempo de las Plazas --->
<cfquery datasource="#Gvar.Conexion#">
	insert into RHLineaTiempoPlaza (
		Ecodigo, 		RHPPid, 		RHCid, 				RHMPPid, 
		RHTTid, 		RHMPid, 		RHPid, 				CFidautorizado, 
		RHLTPfdesde, 	RHLTPfhasta, 	CFcentrocostoaut, 	RHMPestadoplaza, 
		RHMPnegociado, 	RHLTPmonto, 	Mcodigo, 			BMfecha, 
		BMUsucodigo )

	select 
		a.Ecodigo, 		a.RHPPid, 		null, 				a.RHMPPid, 
		null, 			d.RHMPid, 		c.RHPid, 			c.CFid, 
		#FechaIni#, 	#FechaFin#, 	null, 				'A', 
		'T', 			1000000, 		b.Mcodigo, 			
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
		a.BMUsucodigo
	
	from RHPlazaPresupuestaria a
		inner join Empresas b
			on a.Ecodigo = b.Ecodigo
			and b.Ecodigo = #Gvar.Ecodigo#
		inner join RHPlazas c
			on a.Ecodigo = c.Ecodigo
			and a.RHPPcodigo = c.RHPcodigo
		inner join RHMovPlaza  d
			on a.Ecodigo = d.Ecodigo
			and a.RHPPid= d.RHPPid
			
	where not exists (	select 1 
						from RHLineaTiempoPlaza x 
						where x.RHPPid = a.RHPPid )
	and a.Ecodigo = #Gvar.Ecodigo#					
</cfquery>

<!--- <cfquery name="prb" datasource="#Gvar.Conexion#">
  select 	*
  from RHLineaTiempoPlaza
  where Ecodigo=#Gvar.Ecodigo#				
</cfquery> 
<cf_dump var="#prb#"> --->
<!--- Actualiza  la Plaza con la Plaza Presupuestaria --->
<cfquery datasource="#Gvar.Conexion#">
	update RHPlazas
	set RHPPid = (	select max(RHPPid) 
					from RHLineaTiempoPlaza pp 
					where RHPlazas.RHPid = pp.RHPid )
	where RHPPid is null
	and Ecodigo = #Gvar.Ecodigo#
</cfquery>



