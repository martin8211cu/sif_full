<!---mcz--->
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery name="rsImportador" datasource="#session.dsn#">
	select * from #table_name#
</cfquery>

<!--- Validar que no existan duplicados en el archivo --->
	<cfquery name="check1" datasource="#session.dsn#">
		select  count(1) as check1
		from #table_name#
		group by Ccodigoclas
		having count(1) > 1
	</cfquery>
	<!--- <cfdump var="#check1.check1#"> --->
	<cfif check1.check1 gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El codigo de clasificacion aparece duplicado en el archivo!')
		</cfquery>
	</cfif>	

<cfloop query="rsImportador">
	<!---  Validar si ya existe el codigo de clasificacion en el sistema --->
	<cfquery name="rs" datasource="#session.dsn#">
		select count(1) as total
		from #table_name# a, Clasificaciones b
		where '#right(('00000' & Ccodigoclas), 5)#'= b.Ccodigoclas
		and b.Ecodigo = #session.Ecodigo#
		and a.Ccodigoclas='#Ccodigoclas#'
	</cfquery>
	<cfif rs.total gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El codigo de clasificacion ya existe en el sistema(#Ccodigoclas#)!')
		</cfquery>
	</cfif>	

  <!--- Validar que exista el codigo del padre --->
  <cfif len(trim(rsImportador.Ccodigoclaspadre)) gt 0>
	  <cfquery name="rs" datasource="#session.dsn#">
		select count(1) as total  
		from #table_name# a 
		where a.Ccodigoclas='#Ccodigoclas#'
		and a.Ccodigoclaspadre  is not null
		and  not exists ( select 1 
				   from #table_name# b
				   where a.Ccodigoclaspadre = b.Ccodigoclas)
		</cfquery>
		<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!El codigo del padre no existe!(#Ccodigoclaspadre#)!')
			</cfquery>
		</cfif>	
	</cfif>
</cfloop>

<cfquery name="rsErr" datasource="#session.dsn#">
	select count(1) as cantidad from #errores# 
</cfquery>
		

<!--- Inserciones --->
<cfif rsErr.cantidad eq 0>
<cfquery name="maxi" datasource="#session.dsn#">
		select max(Ccodigo) as maxi from Clasificaciones where Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfset maxid=maxi.maxi>
<cfloop query="rsImportador">
	<cfquery name="rsCC" datasource="#session.dsn#">
		 select Ccodigoclaspadre , Ccodigoclas 
		   from #table_name# where id = #id#
   </cfquery>

	<cfif len(trim(rsCC.Ccodigoclaspadre)) eq 0>
		<cfset vCcodigoclaspadre=''>
	<cfelse>
		<cfset vCcodigoclaspadre=rsCC.Ccodigoclaspadre>
	</cfif>

	
	<cfif len(trim(rsCC.Ccodigoclas)) eq 0>
		<cfset vCcodigoclas=''>
	<cfelse>
		<cfset vCcodigoclas=rsCC.Ccodigoclas>
	</cfif>			  
		<cfif len(trim(Ccodigoclaspadre)) eq 0>
			<cfset vCnivel=0>
			<cfset vCpath=right(('00000' & vCcodigoclas), 5)>
			<cfset vCcodigopadre=''>
			
		<cfelse>
			
			<cfquery name="rsS" datasource="#session.dsn#">
				select id from #table_name# 
				where Ccodigoclas='#vCcodigoclaspadre#'				
			</cfquery>
			
			<cfset vCcodigopadre = rsS.id+maxid>
	
			<cfset ciclo = true > 
			<cfset vCpath=right(('00000' & vCcodigoclas), 5)>
				
				<cfset i = 0 >
				<cfset x = rsImportador.Ccodigoclas >

					<cfloop condition="#ciclo#"  >
						<cfset vCpath =  right(('00000' & vCcodigoclaspadre), 5) & '/' & vCpath > 					
						<cfset vCnivel=vCnivel+1>
					
						<cfquery name="rsPadre" datasource="#session.dsn#">
							select Ccodigoclaspadre from #table_name#
							where Ccodigoclas = '#vCcodigoclaspadre#'
						</cfquery>
							
						<cfset vCcodigoclaspadre = rsPadre.Ccodigoclaspadre >
						
						<cfif len(trim(vCcodigoclaspadre)) eq 0 >
							<cfset ciclo = false >
						</cfif>
						<cfset i = i+1 >
						<!--- truco pa ke no se encicle, tomado de dani --->
						<cfif i eq 50000>
						<cf_errorCode	code = "50277" msg = "Error en procesamiento datos">
						</cfif>	
					</cfloop>
					
		</cfif>	


			<cftry>
     		<cfquery name="rsI" datasource="#session.dsn#">
				 insert into Clasificaciones
				(Ecodigo, Ccodigo, Ccodigopadre, Ccodigoclas, Cdescripcion, Cpath, Cnivel, Ccomision, cuentac)
				select 
					#session.Ecodigo#, 
					#maxid# + #rsImportador.id#, 
					<cfif len(trim(vCcodigopadre)) gt 0>
					#vCcodigopadre#,
					<cfelse>
					null,
					</cfif>
					'#right(('00000' & vCcodigoclas), 5)#',	
					Cdescripcion,
					'#vCpath#', 
					#vCnivel#,
					0, 
					cuentac
				from #table_name# a
				where a.id = #rsImportador.id#
			</cfquery>
			<cfcatch type="any">
			</cfcatch>
			</cftry>
</cfloop>
		 
<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
		</cfquery>
		<cfreturn>		
</cfif>
		 

