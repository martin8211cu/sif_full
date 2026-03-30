<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #errores# (Error)
	select 'El Centro Funcional ' #_Cat# CFcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by CFcodigo
	having count(1) > 1
</cfquery>

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
</cfquery>

<cfset session.Importador.SubTipo = "2">
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<cfif (rsImportador.currentRow mod 179 EQ 0)>
		<cfoutput>
			<!-- Flush:
				#repeatString("*",1024)#
			-->
		</cfoutput>
		<!--- veamos si hay que cancelar el proceso --->
		<cfflush interval="64">
	</cfif>
	<cfquery name="rsOficinas" datasource="#session.dsn#">
		select Ocodigo, Oficodigo
		  from Oficinas
		 where Ecodigo=#session.Ecodigo# 
		 and Oficodigo = '#rsImportador.Oficodigo#'
	</cfquery>
	<cfif rsOficinas.Ocodigo EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #errores# (Error)
			values ('La Oficina #rsImportador.Oficodigo# no existe')
		</cfquery>
	</cfif>
	<cfquery name="rsDepartamentos" datasource="#session.dsn#">
		select	Dcodigo, Deptocodigo
		from Departamentos
		where Ecodigo=#session.Ecodigo# 
		and Deptocodigo='#rsImportador.Deptocodigo#'
	</cfquery>
	<cfif rsDepartamentos.Dcodigo EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #errores# (Error)
			values ('El Departamento #rsImportador.Deptocodigo# no existe')
		</cfquery>
	</cfif>
	
	<cfquery name="rsCFresponsable" datasource="#session.dsn#">
		select CFid,CFcodigo,CFpath,CFnivel,CFcorporativo
		from CFuncional
		where Ecodigo=#session.Ecodigo# 
		and CFcodigo='#rsImportador.CResponsable#'
	</cfquery>
		<cfset papacorpo =rsCFresponsable.CFcorporativo>
		
	<cfif rsCFresponsable.CFid EQ "" AND rsImportador.CResponsable NEQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #errores# (Error)
			values ('El Centro Responsable #rsImportador.CResponsable# no existe')
		</cfquery>
	</cfif>
	
	<cfquery name="rsUsuResp" datasource="#session.DSN#">
		select Usucodigo, Usulogin
		from Usuario
		where Usulogin='#rsImportador.Usulogin#'
	</cfquery>
	
	<cfif rsUsuResp.Usucodigo EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #errores# (Error)
			values ('El Usuario #rsImportador.Usulogin# no existe')
		</cfquery>
	</cfif>
	
	<cfquery name="rsCompradores" datasource="#session.dsn#">
		select CMCid,CMCcodigo
		from CMCompradores
		where Ecodigo=#session.Ecodigo# 
		and CMCcodigo='#rsImportador.CMCcodigo#'
	</cfquery>
	
	<cfif rsCompradores.CMCid EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #errores# (Error)
			values ('El Comprador #rsImportador.CMCcodigo# no existe')
		</cfquery>
	</cfif>
<!--- Valida si es coorporativa una empresa o no************************************************************--->
	
	<cfset es_corporativo = false >
	<cfset vEcodigoCorp = 0 >
	
	<cfquery name="rsCorporativa" datasource="asp">
		select coalesce(e.Ereferencia, 0) as Ecorporativa
		from CuentaEmpresarial c
				join Empresa e
					on e.Ecodigo = c.Ecorporativa
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	
	<cfif rsCorporativa.recordcount gt 0 and len(trim(rsCorporativa.Ecorporativa))>
		<cfset vEcodigoCorp = rsCorporativa.Ecorporativa >
	</cfif>

	<cfif vEcodigoCorp eq session.Ecodigo >
		<cfset es_corporativo = true >
	</cfif>
<!--- FIN Valida si es coorporativa una empresa o no************************************************************--->

	<!--- querry Oscar *****************************************************************************************************--->
	<cfquery name="rsSQL" datasource="#session.dsn#">
			select CFid, CFpath
			  from CFuncional
			 where CFcodigo	= '#rsImportador.CFcodigo#'
			   and Ecodigo	= #session.Ecodigo#
	</cfquery>
	<cfset myCFid = rsSQL.CFid>
	
	<cfif rsCFresponsable.CFid EQ "">
		<cfif myCFid EQ "">
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #errores# (Error)
				values ('El Centro Funcional #rsImportador.CFcodigo# no corresponde a la RAIZ de la jerarquía, y no se indicó su Centro Responsable')
			</cfquery>
		</cfif>
		<cfset my_Path = rsImportador.CFcodigo>
		<cfset my_Nivel = 0>
	<cfelse>
		<cfif rsSQL.CFpath NEQ "" AND rsSQL.CFpath EQ mid(rsCFresponsable.CFpath,1,len(trim(rsSQL.CFpath)))>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #errores# (Error)
				values ('Se indicó como Centro Responsable #rsCFresponsable.CFcodigo# que es hijo de #rsImportador.CFcodigo#')
			</cfquery>
		</cfif>
		<cfset my_Path = "#rsCFresponsable.CFpath#/#rsImportador.CFcodigo#">
		<cfset my_Nivel = rsCFresponsable.CFnivel + 1>
	</cfif>
	<!--- querry Oscar********************************************************************************************************--->
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif myCFid EQ "">
			<cfquery datasource="#session.dsn#">
				insert into CFuncional
					(
					 	Ecodigo,
						CFcodigo,
						Dcodigo,
						Ocodigo,
						CFdescripcion,
						CFidresp,
						CFuresponsable,
						CFcomprador,
						CFpath,
						CFnivel,
						CFcorporativo,
						CFcuentac,
						CFcuentaaf,
						CFcuentainversion,
						CFcuentainventario,
						CFcuentaingreso,
						CFcuentagastoretaf,
						CFcuentaingresoretaf
					 )
				values(
					 #session.Ecodigo#
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcodigo#">
					 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDepartamentos.Dcodigo#">
					 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOficinas.Ocodigo#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFdescripcion#">
					 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFresponsable.CFid#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUsuResp.Usucodigo#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCompradores.CMCid#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#my_Path#">
					 ,<cfqueryparam cfsqltype="cf_sql_integer" value="#my_Nivel#">
					 ,<cfif es_corporativo eq true> 1 <cfelseif es_corporativo eq false>0</cfif>
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentac#" 			null="#LEN(TRIM(rsImportador.CFcuentac))            EQ 0#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentaaf#" 			null="#LEN(TRIM(rsImportador.CFcuentaaf))           EQ 0#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentainversion#" 	null="#LEN(TRIM(rsImportador.CFcuentainversion))    EQ 0#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentainventario#"  	null="#LEN(TRIM(rsImportador.CFcuentainventario))   EQ 0#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentaingreso#" 		null="#LEN(TRIM(rsImportador.CFcuentaingreso))      EQ 0#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentagastoretaf#" 	null="#LEN(TRIM(rsImportador.CFcuentagastoretaf))   EQ 0#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentaingresoretaf#" 	null="#LEN(TRIM(rsImportador.CFcuentaingresoretaf)) EQ 0#">
				)
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update CFuncional
					set	Dcodigo       	     =<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDepartamentos.Dcodigo#">,
						Ocodigo		  	     =<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficinas.Ocodigo#">,
						CFdescripcion 	     =<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFdescripcion#">,
						CFidresp	   	     =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFresponsable.CFid#" null="#rsCFresponsable.CFid EQ ""#" >,
						CFuresponsable	     =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuResp.Usucodigo#">,
						CFcomprador		     =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompradores.CMCid#">,
						CFpath			     =<cfqueryparam cfsqltype="cf_sql_varchar" value="#my_Path#">,
					 	CFnivel			     =<cfqueryparam cfsqltype="cf_sql_integer" value="#my_Nivel#">,
						CFcorporativo        =<cfif es_corporativo eq true> 1 <cfelseif es_corporativo eq false>0</cfif>,
						CFcuentac      	     =<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentac#" 		   null="#LEN(TRIM(rsImportador.CFcuentac))            EQ 0#">,
						CFcuentaaf		     =<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentaaf#" 		   null="#LEN(TRIM(rsImportador.CFcuentaaf))           EQ 0#">,
						CFcuentainversion	 =<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentainversion#"    null="#LEN(TRIM(rsImportador.CFcuentainversion))    EQ 0#">,
						CFcuentainventario	 =<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentainventario#"   null="#LEN(TRIM(rsImportador.CFcuentainventario))   EQ 0#">,
					 	CFcuentaingreso		 =<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentaingreso#"      null="#LEN(TRIM(rsImportador.CFcuentaingreso))      EQ 0#">,
					 	CFcuentagastoretaf	 =<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentagastoretaf#"   null="#LEN(TRIM(rsImportador.CFcuentagastoretaf))   EQ 0#">,
					 	CFcuentaingresoretaf =<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CFcuentaingresoretaf#" null="#LEN(TRIM(rsImportador.CFcuentaingresoretaf)) EQ 0#">
				where CFid = #myCFid#
			</cfquery>
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>