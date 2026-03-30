<cfscript>
	bcheck0 = false; // Chequeo de que hay datos en la tabla temporal
	bcheck1 = false; // Chequeo de Tipo de Identificacion
	bcheck2 = false; // Chequeo de Centro Funcional
	bcheck3 = false; // Chequeo del estado civil
	bcheck4 = false; // Chequeo del sexo
	bcheck5 = false; // Chequeo de la moneda
	bcheck6 = false; // Chequeo del banco
	bcheck7 = false; // Chequeo del pais
	bcheck8 = false; 
</cfscript>

<cfquery name="rsCheck0" datasource="#Session.DSN#">
	select count(1) as check0 from #table_name#
</cfquery>
<cfif rsCheck0.check0 eq 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select distinct 'No se cargaron datos para importar!' as MSG, 0 as Cantidad_Registros from dual
	</cfquery>		
<cfelse>
	<!--- Chequear Validez de los tipos de Identificacion --->
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1
		from #table_name# a
		where not exists(
			select 1
			from NTipoIdentificacion b
			where b.NTIcodigo = a.NTIcodigo
		)
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
	
	<!--- Chequear Validez de los Centros Funcionales --->
	<cfif bcheck1>
		<cfquery name="rsCheck2" datasource="#Session.DSN#">
			select count(1) as check2
			from #table_name# a
			where not exists(
				select 1
				from CFuncional c
				where c.CFcodigo = a.CFcodigo
				and c.Ecodigo =  #Session.Ecodigo# 
			)
		</cfquery>
		<cfset bcheck2 = rsCheck2.check2 LT 1>
	</cfif>
	
	<cfif bcheck2>
		<!--- Chequear Validez del estado civil --->
		<cfquery name="rsCheck3" datasource="#Session.DSN#">
			select count(1) as check3
			from #table_name# a
			where DEcivil not in (0,1,2,3,4,5)
		</cfquery>
		<cfset bcheck3 = rsCheck3.check3 LT 1>
	</cfif>
	
	<cfif bcheck3>
		<!--- Chequear Validez del Sexo --->
		<cfquery name="rsCheck4" datasource="#Session.DSN#">
			select count(1) as check4
			from #table_name# a
			where DEsexo not in ('M','F')
		</cfquery>
		<cfset bcheck4 = rsCheck4.check4 LT 1>
	</cfif>
	
	<cfif bcheck4>
		<!--- Seleccionar el codigo de la moneda de la empresa en session --->
		<cfquery name="rsMoneda" datasource="#Session.DSN#">
			select Mcodigo, EcodigoSDC
			from Empresas
 			where Ecodigo=  #Session.Ecodigo# 
		</cfquery>
		<cfif isdefined('rsMoneda')	and rsMoneda.recordCount GT 0>
			<cfset bcheck5 = true>
		</cfif>
	</cfif>		
	
	<cfif bcheck5>
		<!--- Seleccionar el codigo del banco --->
		<cfquery name="rsBanco" datasource="#Session.DSN#">
			select coalesce(min(Bid),-1) as Bid
			from Bancos
			where Ecodigo=  #Session.Ecodigo# 
		</cfquery>			
		<cfif isdefined('rsBanco') and rsBanco.recordCount GT 0 and rsBanco.Bid NEQ '-1'>
			<cfset bcheck6 = true>
		</cfif>
	</cfif>

	<cfif bcheck6>
		<cfif isdefined('rsMoneda') and rsMoneda.recordCount GT 0>
			<!--- Seleccionar el codigo del Pais --->
			<cfquery name="rsPais" datasource="#Session.DSN#">
				select Ppais
				from Empresa e
					inner join Direcciones d
						on d.id_direccion=e.id_direccion
				where Ecodigo = #rsMoneda.EcodigoSDC#
			</cfquery>	
		</cfif>
		<cfif isdefined('rsPais') and rsPais.recordCount GT 0>
			<cfset bcheck7 = true>
		</cfif>						
	</cfif>

	<cfif bcheck7>
	
		<cfquery name="rsInconsistencias" datasource="#Session.DSN#">
			Select 	count(1) as total
			from AFResponsables a
			
					inner join DatosEmpleado de
						on a.DEid = de.DEid
						and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			
					inner join #table_name# tb2
						on tb2.DEidentificacion = de.DEidentificacion
									
					inner join CFuncional cf
						on cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and tb2.CFcodigo = cf.CFcodigo
						
					inner join CFuncional cfo
						 on cfo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and cfo.CFid    = a.CFid
			
					inner join CRTipoDocumento crt
						on crt.CRTDid != 2
						and crt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						
					inner join CRCentroCustodia crcc
						on crcc.CRCCid = a.CRCCid
						and crcc.Ecodigo = a.Ecodigo
			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.CRTDid = crt.CRTDid
				and a.CFid <> cf.CFid
				and <cf_dbfunction name="now"> between a.AFRfini and a.AFRffin
			
				and not exists(
							Select 1
							from CRCCCFuncionales cc
							where cc.CFid = cf.CFid
								and cc.CRCCid = a.CRCCid
						)
			
				and not exists (
							select 1
							from AFTResponsables aft
							where aft.AFRid = a.AFRid
							and aft.AFTRtipo = 1
						)	
		</cfquery>

		<cfif rsInconsistencias.total eq 0>		
			<cfset bcheck8 = true>
		</cfif>	
		
	</cfif>
	
	<cfif bcheck8>
	<!---************************************SI NO HAY ERRORES******************************************************--->	
	<!---1- Se Copia los empleados a importar 																		--->
	<!---2- Marca los Empleados existentes con marca=1 																--->
	<!---3- Corta la linea de tiempo de los Empleados que no vienen en el Archivo									--->
	<!---4- Inserta los Empleados que no existen																	--->
	<!---5- Crea la Linea del Tiempo para los Empleados que no existen											    --->
	<!---6- Crea una linea de Tiempo para los Empleados que existentes pero inactivos								--->
	<!---7- Crea linea de tiempo para los empledos que existen pero tienen Centro Funcional Diferente al importado	--->  
	<!---7b- Corta la linea para los empledos que existen pero tienen Centro Funcional Diferente al importartado	--->  
	<!---8- Actualiza los datos del los Empleado que ya existen 													--->
		<cf_dbtemp name="TempImportEmp_v1" returnvariable="EmpleImport" datasource="#session.dsn#">
			<cf_dbtempcol name="NTIcodigo"   	   type="varchar(1)"   mandatory="yes">
			<cf_dbtempcol name="DEidentificacion"  type="varchar(60)"  mandatory="yes">
			<cf_dbtempcol name="DEnombre"   	   	type="varchar(100)" mandatory="yes">
			<cf_dbtempcol name="DEapellido1"   	   type="varchar(80)"  mandatory="no">
			<cf_dbtempcol name="DEapellido2"       type="varchar(80)"  mandatory="no">
			<cf_dbtempcol name="DEdireccion"       type="varchar(255)" mandatory="no">
			<cf_dbtempcol name="DEtelefono1"       type="varchar(30)"  mandatory="no">
			<cf_dbtempcol name="DEtelefono2"       type="varchar(30)"  mandatory="no">
			<cf_dbtempcol name="DEemail"  		   type="varchar(120)" mandatory="no">
			<cf_dbtempcol name="DEcivil"  		   type="integer"      mandatory="yes">
			<cf_dbtempcol name="DEfechanac"   	   type="datetime"     mandatory="yes">
			<cf_dbtempcol name="DEsexo"            type="varchar(1)"   mandatory="yes">
			<cf_dbtempcol name="CFcodigo"          type="varchar(10)"  mandatory="yes">
			<cf_dbtempcol name="marca"  		  		type="integer"      mandatory="yes">
		</cf_dbtemp> 
	<cftransaction>
		<cfquery datasource="#Session.dsn#">
			insert into #EmpleImport# (NTIcodigo,DEidentificacion, DEnombre,DEapellido1,DEapellido2, DEdireccion,DEtelefono1, DEtelefono2, DEemail,DEcivil,DEfechanac,DEsexo,CFcodigo, marca)
			select NTIcodigo,DEidentificacion, DEnombre,DEapellido1,DEapellido2, DEdireccion,DEtelefono1, DEtelefono2, DEemail,DEcivil,DEfechanac,DEsexo,CFcodigo,0 from #table_name#
		</cfquery>
		<!---2- Marca los Empleados existentes con marca=1--->
		<cfquery datasource="#Session.dsn#">
		  update #EmpleImport# 
		    set marca = 1  
		  where exists (select 1 from DatosEmpleado where DEidentificacion = #EmpleImport#.DEidentificacion)
		</cfquery>
		<!---Debugeador--->
		<cfif isdefined('debug') and debug EQ true>
			  	<cfquery name= "debug1" datasource="#Session.dsn#"> 
			         select count(1) cant from DatosEmpleado a
			   </cfquery> 
				<cfquery name= "debug2" datasource="#Session.dsn#"> 
			         select count(1) cant 
					  from DatosEmpleado a
					  	inner join EmpleadoCFuncional b
							on a.DEid = b.DEid
							and a.Ecodigo = b.Ecodigo
						where a.Ecodigo = #Session.Ecodigo#
						and <cf_dbfunction name="now"> between b.ECFdesde and b.ECFhasta		
			   </cfquery> 
			  <cfquery name= "debug3" datasource="#Session.dsn#">
			  		select count(1) as cant from #EmpleImport#
			  </cfquery> 
		      <cfquery name= "debug4" datasource="#Session.dsn#"> 
			         select count(1) cant from #EmpleImport# where exists (select 1 from DatosEmpleado where DEidentificacion = #EmpleImport#.DEidentificacion)
			  </cfquery> 
		</cfif>	
		<!--- Traslado de Activos de Empleado con Centro Funcional diferente y mismo Centro de Custodia al guardado en EmpleadoCFuncional y que sea Vale --->

		<cf_dbfunction name="now" returnvariable="fecha">
		<cfquery datasource="#Session.dsn#"> 
			insert into AFTResponsables (AFRid, DEid, CRCCid, AFTRfini, AFTRestado, AFTRtipo, CRTDid, Usucodigo, Ulocalizacion, BMUsucodigo)
			select
				a.AFRid, 
				a.DEid,
				a.CRCCid,
				<cf_dbfunction name="date_format" args="#fecha#,dd/mm/yyyy">,
				30,
				1,
				a.CRTDid,
				#Session.Usucodigo#, 
				'00',
				#Session.Usucodigo#
			from AFResponsables a
				inner join DatosEmpleado de
					on a.DEid = de.DEid
					and de.Ecodigo = #Session.Ecodigo#
				inner join #EmpleImport# tb2
					on tb2.DEidentificacion = de.DEidentificacion
				inner join CFuncional cf
					on cf.Ecodigo = #Session.Ecodigo#
					and tb2.CFcodigo = cf.CFcodigo
				inner join CRCCCFuncionales cc
					on cc.CFid = cf.CFid
					and cc.CRCCid = a.CRCCid
				inner join CRTipoDocumento crt
					<!---on crt.CRTDcodigo = '01'--->
					 on crt.CRTDid != 2 <!--- Cualquiera excepto los vales por CF --->
					and crt.Ecodigo = #Session.Ecodigo#
			where a.Ecodigo = #Session.Ecodigo#
				and a.CRTDid = crt.CRTDid
				and a.CRCCid = cc.CRCCid
				and a.CFid <> cf.CFid
				and <cf_dbfunction name="now"> between a.AFRfini and a.AFRffin
				and a.Ecodigo = #Session.Ecodigo#	
				and not exists (
					select 1
					from AFTResponsables aft
					where aft.AFRid = a.AFRid
					<!----and aft.AFTRtipo = 1----->
				)
				and not exists (
					select 1
					from EmpleadoCFuncional ecf
					where ecf.Ecodigo = #Session.Ecodigo#
						and <cf_dbfunction name="now"> between ecf.ECFdesde and ecf.ECFhasta
						and ecf.DEid = a.DEid
						and ecf.CFid = cf.CFid
				)
		</cfquery>
		<!---3- Corta la linea de tiempo de los Empleados que no vienen en el Archivo--->
		<cfset fechaCorte= DateAdd("d", -1, now())>
		<cfset AnoCorte=   DatePart("yyyy", fechaCorte)>
		<cfset MesCorte=   DatePart("m", fechaCorte)>
		<cfset DiaCorte=   DatePart("d", fechaCorte)>
		<cfset fechaCorte= CreateDateTime(AnoCorte, MesCorte, DiaCorte, 23, 59, 59)>
		<cfquery datasource="#Session.dsn#">
			update EmpleadoCFuncional 
			    set ECFhasta = #fechaCorte#
			where Ecodigo = #Session.Ecodigo#
			and <cf_dbfunction name="now"> between ECFdesde and ECFhasta
			and DEid not in(select a.DEid 
							  from DatosEmpleado a
							     inner join #EmpleImport#  b
								 	on a.DEidentificacion = b.DEidentificacion
							   where a.Ecodigo =  #Session.Ecodigo#)
		</cfquery>
	<!---4- Inserta los Empleados que no existen--->
		<cfquery datasource="#Session.dsn#">
			insert into DatosEmpleado 
			(
				Ecodigo, 
				Bid, 
				NTIcodigo, 
				DEidentificacion, 
				DEnombre, 
				DEapellido1, 
				DEapellido2,
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
				Usucodigo, 
				Ulocalizacion, 
				DEsistema, 
				Ppais, 
				BMUsucodigo
			)
			select 
				#Session.Ecodigo#, 
				#rsBanco.Bid#, 
				a.NTIcodigo, 
				a.DEidentificacion, 
				a.DEnombre, 
				a.DEapellido1, 
				a.DEapellido2, 
				a.DEidentificacion, 
				#rsMoneda.Mcodigo#, 
				a.DEdireccion, 
				a.DEtelefono1, 
				a.DEtelefono2, 
				a.DEemail, 
				a.DEcivil, 
				coalesce(a.DEfechanac,<cf_dbfunction name="now">), 
				a.DEsexo, 
				0, 
				#Session.Usucodigo#, 
				'00', 
				1, 
				'#rsPais.Ppais#', 
				#Session.Usucodigo#
			from #EmpleImport# a
			where a.marca = 0
		</cfquery>
	<!---5- Crea la Linea del Tiempo para los Empleados que no existen --->
		<cfset fechaFin= CreateDateTime(6100, 01, 01, 23, 59, 59)>
		<cfquery datasource="#Session.dsn#">
			insert into EmpleadoCFuncional (DEid, Ecodigo, CFid, ECFdesde, ECFhasta, BMUsucodigo)
			select de.DEid, #Session.Ecodigo#, cf.CFid, <cf_dbfunction name="now">, #fechaFin#, #Session.Usucodigo#
			from #EmpleImport# a
				inner join DatosEmpleado de
					on a.DEidentificacion = de.DEidentificacion
				inner join CFuncional cf
					on de.Ecodigo = cf.Ecodigo
				   and cf.CFcodigo = a.CFcodigo	
			where a.marca = 0
			  and cf.Ecodigo = #Session.Ecodigo#
		</cfquery>
	<!---6-Crea una linea de Tiempo para los Empleados que existen pero no tienen linea de tiempo--->
		<cfquery datasource="#Session.dsn#">
			insert into EmpleadoCFuncional (DEid, Ecodigo, CFid, ECFdesde, ECFhasta, BMUsucodigo)
			select de.DEid, #Session.Ecodigo#, cf.CFid, <cf_dbfunction name="now">, #fechaFin#, #Session.Usucodigo#
			from #EmpleImport# a
				inner join DatosEmpleado de
					on a.DEidentificacion = de.DEidentificacion
				inner join CFuncional cf
					on de.Ecodigo = cf.Ecodigo
				   and a.CFcodigo = cf.CFcodigo
			where a.marca = 1
			  and de.Ecodigo = #Session.Ecodigo#
			  and de.DEid not in (select ecf.DEid 
					                from EmpleadoCFuncional ecf
					                 where ecf.Ecodigo = de.Ecodigo
					                and <cf_dbfunction name="now"> between ECFdesde and ECFhasta)				 			  
		</cfquery>
	   <!--- 7- Crea linea de tiempo para los empledos que existen pero tienen Centro Funcional Diferente al importartado--->  
	   <cfquery datasource="#Session.dsn#">
			insert into EmpleadoCFuncional (DEid, Ecodigo, CFid, ECFdesde, ECFhasta, BMUsucodigo)
			select 
				de.DEid, #Session.Ecodigo#, cf.CFid, 
				<cf_dbfunction name="now">, #fechaFin#, #Session.Usucodigo#
			from #EmpleImport# a
				inner join DatosEmpleado de
				  on a.DEidentificacion = de.DEidentificacion
				inner join CFuncional cf
				  on de.Ecodigo = cf.Ecodigo	
			     and a.CFcodigo = cf.CFcodigo
			where a.marca = 1
			  and de.Ecodigo = #Session.Ecodigo#
			  and cf.CFid not in
					(	select ecf.CFid
						from EmpleadoCFuncional ecf
						where ecf.DEid = de.DEid
						  and ecf.Ecodigo = de.Ecodigo
						  and <cf_dbfunction name="now"> between ecf.ECFdesde and ecf.ECFhasta
					  )
		</cfquery>
		<!--- 7b- Corta la linea para los empledos que existen pero tienen Centro Funcional Diferente al importartado--->  
		<cfquery datasource="#Session.dsn#">
			update EmpleadoCFuncional 
				set ECFhasta = #fechaCorte#
			where exists ( select 1 
							  from #EmpleImport# a
							   inner join DatosEmpleado de
							     on a.DEidentificacion = de.DEidentificacion
							   inner join CFuncional cf 
							       on de.Ecodigo = cf.Ecodigo
								  and a.CFcodigo = cf.CFcodigo
						    where a.marca = 1
							 and de.Ecodigo = #Session.Ecodigo#
							 and de.DEid = EmpleadoCFuncional.DEid
							 and cf.CFid != EmpleadoCFuncional.CFid	
						  )
								   
			and <cf_dbfunction name="now"> between ECFdesde and ECFhasta
			and Ecodigo = #Session.Ecodigo#
		</cfquery>		  
		<!---8- Actualiza los datos del los Empleado que ya existen --->
		<cfquery name="PorActualizar" datasource="#Session.dsn#">
			select DEidentificacion, DEnombre, DEapellido1, DEapellido2, DEdireccion, DEtelefono1, DEtelefono2, DEemail, DEcivil, DEfechanac, DEsexo
		      from #EmpleImport#
			where marca = 1
		</cfquery>
		<cfloop query="PorActualizar">
			<cfquery datasource="#Session.dsn#">
				update DatosEmpleado set
					DEnombre 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#PorActualizar.DEnombre#">, 
					DEapellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PorActualizar.DEapellido1#">, 
					DEapellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PorActualizar.DEapellido2#">,
					DEdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PorActualizar.DEdireccion#">, 
					DEtelefono1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PorActualizar.DEtelefono1#">, 
					DEtelefono2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PorActualizar.DEtelefono2#">, 
					DEemail 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#PorActualizar.DEemail#">, 
					DEcivil 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#PorActualizar.DEcivil#">, 
					DEfechanac 	= <cfqueryparam cfsqltype="cf_sql_date"    value="#PorActualizar.DEfechanac#">, 
					DEsexo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#PorActualizar.DEsexo#">,
					BMUsucodigo = #session.Usucodigo#
				where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PorActualizar.DEidentificacion#">
				  and Ecodigo = #Session.Ecodigo#
			</cfquery>		
		</cfloop>
		<!---Debugeador--->
		<cfif isdefined('debug') and debug EQ true>
			  	<cfquery name= "debug5" datasource="#Session.dsn#"> 
			         select count(1) cant from DatosEmpleado a
			   </cfquery> 
				<cfquery name= "debug6" datasource="#Session.dsn#"> 
			         select count(1) cant 
					  from DatosEmpleado a
					  	inner join EmpleadoCFuncional b
							on a.DEid = b.DEid
							and a.Ecodigo = b.Ecodigo
						where a.Ecodigo = #Session.Ecodigo#
						and <cf_dbfunction name="now"> between b.ECFdesde and b.ECFhasta		
			   </cfquery> 
			<cfquery name="ERR" datasource="#Session.dsn#"> 
			   	  select 'Empleados del Sistema:             #debug1.cant#<br />
				  		  Empleados Activos del Sistema:     #debug2.cant#<br />
				  		  Empleados a Importar:  		     #debug3.cant#<br />
				          Empleados ya Existentes:           #debug4.cant#<br />
						  Nueva cantidad de Empleados:       #debug5.cant#<br />
						  Nueva cantidad de EmpleadosActivos:#debug6.cant#<br />
				     ' as DEBUG from dual
			 </cfquery>
			 <cftransaction action="rollback">
		</cfif>	
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="ProcesarByUsucodigo"
			TransaccionActiva = "true"/>
  </cftransaction>
	
		
	<cfelse>
		<cfif not bcheck1>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'Código del Tipo de Identificacion no existe' as MSG, a.NTIcodigo as CODIGO_TIPO_IDENTIFICADOR
				from #table_name# a
				where not exists(
					select 1
					from NTipoIdentificacion b
					where b.NTIcodigo = a.NTIcodigo
				)
			</cfquery>
			
		<cfelseif not bcheck2>
			<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Código del Centro Funcional no existe para la empresa' as MSG, a.CFcodigo as CODIGO_CENTRO_FUNCIONAL
			from #table_name# a
			where not exists(
					select 1
					from CFuncional c
					where c.CFcodigo = a.CFcodigo
					and c.Ecodigo =  #Session.Ecodigo# 
				)
			</cfquery>
		<cfelseif not bcheck3>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'Código del Estado Civil no existe' as MSG, a.DEcivil as CODIGO_ESTADO_CIVIL
				from #table_name# a
				where a.DEcivil not in (0,1,2,3,4,5)
			</cfquery>		
		<cfelseif not bcheck4>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'Código del Sexo no existe' as MSG, a.DEsexo as CODIGO_SEXO
				from #table_name# a
				where a.DEsexo not in ('M','F')
			</cfquery>			
		<cfelseif not bcheck5>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'No existe la moneda para la empresa actual' as MSG, 'No hay moneda' as MONEDA from dual
			</cfquery>								
		<cfelseif not bcheck6>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'No existe el banco para la empresa actual' as MSG, 'No hay banco' as BANCO from dual
			</cfquery>								
		<cfelseif not bcheck7>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'No existe el pa&iacute;s para la empresa actual' as MSG, 'No hay Pa&iacute;s' as PAIS from dual
			</cfquery>								
		<cfelseif not bcheck8>		
			<cf_dbfunction name="OP_concat" returnvariable="_Cat">		
			<cfquery name="ERR" datasource="#session.DSN#">
				Select 	distinct 
								'El Centro Funcional destino: ' #_Cat# cf.CFcodigo #_Cat# ', no esta asociado al centro de custodia origen: ' #_Cat# crcc.CRCCcodigo as MSG, 
								cfo.CFcodigo as CF_Origen, 
								cf.CFcodigo as CF_Destino, 
								crcc.CRCCcodigo as Centro_Custodia, 
								de.DEidentificacion as Cedula_Emp
				from AFResponsables a
				
						inner join DatosEmpleado de
							on a.DEid = de.DEid
							and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				
						inner join #table_name# tb2
							on tb2.DEidentificacion = de.DEidentificacion
				
						inner join CFuncional cf
							on cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and tb2.CFcodigo = cf.CFcodigo
							
						inner join CFuncional cfo
							 on cfo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and cfo.CFid    = a.CFid
				
						inner join CRTipoDocumento crt
							on crt.CRTDid != 2
							and crt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							
						inner join CRCentroCustodia crcc
							on crcc.CRCCid = a.CRCCid
							and crcc.Ecodigo = a.Ecodigo
				
				where a.CRTDid = crt.CRTDid
				  and a.CFid <> cf.CFid
				  and <cf_dbfunction name="now"> between a.AFRfini and a.AFRffin
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				
				  and not exists(
								Select 1
								from CRCCCFuncionales cc
								where cc.CFid = cf.CFid
									and cc.CRCCid = a.CRCCid
							)
				
					and not exists (
								select 1
								from AFTResponsables aft
								where aft.AFRid = a.AFRid
								and aft.AFTRtipo = 1
							)						
			</cfquery>						
		</cfif>
	</cfif>
</cfif>

