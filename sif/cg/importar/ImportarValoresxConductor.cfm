<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 	type="integer" 		mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="CGParamConductores_TEMP" returnvariable="CGParamConductores_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Ecodigo" 	 type="integer"      mandatory="yes">
	<cf_dbtempcol name="CGCperiodo"  type="integer" 	 mandatory="yes">
	<cf_dbtempcol name="CGCmes" 	 type="integer" 	 mandatory="yes">
	<cf_dbtempcol name="CGCid" 		 type="numeric" 	 mandatory="yes">
	<cf_dbtempcol name="PCCDclaid" 	 type="numeric" 	 mandatory="no">
	<cf_dbtempcol name="PCDcatid" 	 type="numeric" 	 mandatory="no">
	<cf_dbtempcol name="CGCvalor" 	 type="float" 	 	 mandatory="yes">
	<cf_dbtempcol name="BMUsucodigo" type="numeric" 	 mandatory="yes">		
</cf_dbtemp>

<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO VENGA VACIO --->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select 1
	from #table_name#
</cfquery>

<cfif isdefined("rsCheck1") and  rsCheck1.recordcount EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('El archivo de importaci&oacute;n no tiene l&iacute;neas',1)
	</cfquery>
<cfelse>

	<!--- 0- Valida que no esten los datos repetidos dentro del mismo archivo --->
	<cfquery name="rsCheck0" datasource="#Session.Dsn#">
	Select 	CGCcodigo,
			CGCperiodo,
			CGCmes,
			Codcat,
			CGCvalor,
			CGCmodo,
			count(1) as total
	from #table_name#
	group by CGCcodigo,
			CGCperiodo,
			CGCmes,
			Codcat,
			CGCvalor,
			CGCmodo
	having count(1) > 1
	</cfquery>
	<cfif isdefined("rsCheck0") and  rsCheck0.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('Existen lineas repetidas en el archivo. Por favor verifique. ',3)
		</cfquery>
	</cfif>	
	<!--- 1- Valida que no existan campos nulos --->
	<cfquery name="rsCheck2" datasource="#Session.Dsn#">
		select count(1) as total
		from #table_name#
		where (CGCcodigo is null
 	  	   or CGCperiodo is null
 	  	   or CGCmes is null
 	  	   or Codcat is null
 	  	   or CGCvalor is null
 	  	   or CGCmodo is null)
	</cfquery>
	<cfif isdefined("rsCheck2") and  rsCheck2.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo tiene campos en nulo o en blanco. Todos los campos son requeridos ',3)
		</cfquery>
	<cfelse>
		<cfquery name="rsCheck2" datasource="#Session.Dsn#">
			select count(1) as total
			from #table_name#
			where (CGCcodigo = ''
			   or Codcat  = ''
			   or CGCmodo  = '')
		</cfquery>
		<cfif isdefined("rsCheck2") and  rsCheck2.total gt 0>
			<cfquery name="INS_Error" datasource="#session.DSN#">
				insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
				values('El archivo tiene campos en nulo o en blanco. Todos los campos son requeridos ',3)
			</cfquery>
		</cfif>
	</cfif>		
	
	<!--- 2- Valida que el Conductor exista --->
	<cfquery name="rsCheck3" datasource="#Session.Dsn#">
		Select count(1) as total
		from #table_name# a
		where not exists(Select 1
						from CGConductores b
						where a.CGCcodigo = b.CGCcodigo
						  and b.Ecodigo = #session.ecodigo#)
	</cfquery>	
	<cfif isdefined("rsCheck3") and  rsCheck3.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo tiene conductores definidos que no existen en el catálogo ',3)
		</cfquery>
	</cfif>
	
	<!--- 3- Valida que el Periodo y Mes sean válidos --->
	<cfquery name="rsCheck4" datasource="#Session.Dsn#">
		Select count(1) as total
		from #table_name# a
		where (a.CGCmes < 1 
		   or a.CGCmes > 12)
	</cfquery>	
	<cfif isdefined("rsCheck4") and  rsCheck4.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo tiene definidos meses inválidos ',3)
		</cfquery>
	<cfelse>
    	<cf_dbfunction name='to_char' args="a.CGCperiodo" returnvariable='LvarCGCperiodo'>
		<cfquery name="rsCheck4" datasource="#Session.Dsn#">
			Select count(1) as total
			from #table_name# a
			where datalength(#LvarCGCperiodo#) != 4
		</cfquery>		
		<cfif isdefined("rsCheck4") and  rsCheck4.total gt 0>
			<cfquery name="INS_Error" datasource="#session.DSN#">
				insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
				values('El archivo tiene definidos periodos inválidos ',3)
			</cfquery>		
		</cfif>
	</cfif>
		
	<!--- 4- Valida que el valor sea mayor que cero --->
	<cfquery name="rsCheck5" datasource="#Session.Dsn#">
		Select count(1) as total
		from #table_name# a
		where a.CGCvalor <= 0
	</cfquery>	
	<cfif isdefined("rsCheck5") and  rsCheck5.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo tiene definidos valores en cero o negativos',3)
		</cfquery>
	</cfif>	
	<!--- 5- Valida que el Modo tenga un valor igual a C o U --->
	<cfquery name="rsCheck6" datasource="#Session.Dsn#">
		Select count(1) as total
		from #table_name# a
		where a.CGCmodo not in ('C','U')
	</cfquery>	
	<cfif isdefined("rsCheck6") and  rsCheck6.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo tiene definido un modo inválido. Solo se permite: (C-Catalogo, U-Clasificacion)',3)
		</cfquery>
	</cfif>
	<!--- 5- Valida que el Modo concuerda con el modo del conductor TIPO:Catalogo--->
	<cfquery name="rsCheck6" datasource="#Session.Dsn#">
		Select count(1) as total
		from #table_name# a
		where a.CGCmodo = 'C'
		  and not exists(Select 1
		  				from CGConductores b
						where b.CGCcodigo = a.CGCcodigo
						  and b.Ecodigo = #session.ecodigo#
						  and b.CGCmodo = 1)
	</cfquery>	
	<cfif isdefined("rsCheck6") and  rsCheck6.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('A. Existen conductores definidos en el archivo que no estan parametrizados con el modo indicado ',3)
		</cfquery>
	</cfif>
	<!--- 5- Valida que el Modo concuerda con el modo del conductor TIPO:Clasificacion--->
	<cfquery name="rsCheck6" datasource="#Session.Dsn#">
		Select count(1) as total
		from #table_name# a
		where a.CGCmodo = 'U'
		  and not exists(Select 1
		  				from CGConductores b
						where b.CGCcodigo = a.CGCcodigo
						  and b.Ecodigo = #session.ecodigo#
						  and b.CGCmodo = 2)
	</cfquery>	
	<cfif isdefined("rsCheck6") and  rsCheck6.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('B. Existen conductores definidos en el archivo que no estan parametrizados con el modo indicado ',3)
		</cfquery>
	</cfif>	
		
	<!--- 6- Valida que en caso de clasificación el detalle pertenezca y este asociado al catálogo definido en el conductor --->	
	<cfquery name="rsCheck7" datasource="#Session.Dsn#">
		Select count(1) as total, a.Codcat
		from #table_name# a
				inner join CGConductores b
					on a.CGCcodigo = b.CGCcodigo
					and b.Ecodigo = #session.ecodigo#
		where a.CGCmodo ='C'
		  and not exists(Select 1
		  				 from PCECatalogo c
						 		inner join PCDCatalogo d
									on c.PCEcatid = d.PCEcatid
						 where c.PCEcatid = b.CGCidc
						   and d.PCDvalor = a.Codcat)
       group by a.Codcat
	</cfquery>
	<cfif isdefined("rsCheck7") and  rsCheck7.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El catálogo indicado, no pertenece a un catálogo asociado al conductor (#rsCheck7.Codcat#)',3)
		</cfquery>
	</cfif>
	<!--- 7- Valida que en caso de clasificación el detalle tenga parametrizadas las oficinas y estas sumen el 100% --->	
	<cfquery name="rsCheck8" datasource="#Session.Dsn#">
		Select count(1) as total
		from #table_name# a
				inner join CGConductores b
					on a.CGCcodigo = b.CGCcodigo
					and b.Ecodigo = #session.ecodigo#
		where a.CGCmodo ='U'
		  and not exists(Select 1
		  				 from PCClasificacionE c
						 		inner join PCClasificacionD d
									on c.PCCEclaid = d.PCCEclaid
						 where c.PCCEclaid = b.CGCidc
						   and d.PCCDvalor = a.Codcat)
	</cfquery>
	<cfif isdefined("rsCheck8") and  rsCheck8.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('La Clasificación indicada, no pertenece a una clasificación asociada al conductor',3)
		</cfquery>
	</cfif>
	
</cfif>

<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum
</cfquery>

<cfif (err.recordcount) EQ 0>

	<cfquery name="RSregistros" datasource="#session.dsn#">		
		insert into #CGParamConductores_TEMP#
		(
			Ecodigo,
			CGCperiodo,
			CGCmes,
			CGCid,
			PCCDclaid,
			PCDcatid,
			CGCvalor,
			BMUsucodigo
		)
		select  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				a.CGCperiodo,
				a.CGCmes,
				b.CGCid,
				case when a.CGCmodo = 'C' then
					null
				else
				
					(Select Max(d.PCCDclaid)
					 from PCClasificacionE c
				 			inner join PCClasificacionD d
								on c.PCCEclaid = d.PCCEclaid
								and CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
					 where c.PCCEclaid = b.CGCidc
					   and d.PCCDvalor = a.Codcat)
					   
				end as PCCDclaid,
				
				case when a.CGCmodo = 'C' then
				
					(Select Max(f.PCDcatid)
					 from PCECatalogo e 
					 		inner join PCDCatalogo f
								on e.PCEcatid = f.PCEcatid
					 where e.PCEcatid = b.CGCidc
					   and f.PCDvalor = a.Codcat)
				
				else
					null
				end	as PCDcatid,
				
				CGCvalor,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">

		from #table_name# a
				inner join CGConductores b
					on a.CGCcodigo = b.CGCcodigo
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">								
	</cfquery>
	
	<!--- Inserta en CGParamConductores lo que no existe --->
	<cfquery name="RSregistros" datasource="#session.dsn#">	
	INSERT into CGParamConductores(	Ecodigo,
								CGCperiodo,
								CGCmes,
								CGCid,
								PCCDclaid,
								PCDcatid,
								CGCvalor,
								BMUsucodigo	)
	Select  					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
								CGCperiodo,
								CGCmes,
								CGCid,
								PCCDclaid,
								PCDcatid,
								CGCvalor,
								BMUsucodigo	
	from #CGParamConductores_TEMP# a
	where not exists (Select 1
					 from CGParamConductores b
					 where a.Ecodigo 	= b.Ecodigo
					   and a.CGCid   	= b.CGCid
					   and a.CGCperiodo = b.CGCperiodo
					   and a.CGCmes  	= b.CGCmes
					   and coalesce(a.PCCDclaid,-1)= coalesce(b.PCCDclaid,-1)
					   and coalesce(a.PCDcatid,-1) = coalesce(b.PCDcatid,-1)
					   )
	</cfquery>
	<!--- Actualiza en CGParamConductores lo que existe --->
	<cfquery name="RSregistros" datasource="#session.dsn#">	
	UPDATE CGParamConductores
	set CGCvalor = a.CGCvalor
	from #CGParamConductores_TEMP# a
	where a.Ecodigo 	= CGParamConductores.Ecodigo
	  and a.CGCid   	= CGParamConductores.CGCid
	  and a.CGCperiodo  = CGParamConductores.CGCperiodo
	  and a.CGCmes  	= CGParamConductores.CGCmes
	  and coalesce(a.PCCDclaid,-1)= coalesce(CGParamConductores.PCCDclaid,-1)
	  and coalesce(a.PCDcatid,-1) = coalesce(CGParamConductores.PCDcatid,-1)
	</cfquery>
	
</cfif>