<!---mcz--->
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfset check1=0>
<cfset check2=0>
<cfset check3=0>
<cfset mini=0>
<cfset vCCcodigopadre=''>
<cfset vCCcodigo=''>
<cfset vCCidpadre=0>
<cfset vCnivel=0>
<cfset vCpath=''>
<cfset maxid=0>
<cfset vCpath=''>
<cfset Afecha=now()>

<cfquery name="rsImportador" datasource="#session.dsn#">
select * from #table_name#
</cfquery>

	<!---Validar que no existan duplicados en el archivo--->
	<cfquery name="check1" datasource="#session.dsn#">
		select count (1) as check1 
		from #table_name#
		group by CCcodigo
		having count(1) > 1
	</cfquery>
	<cfif check1.check1 gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error!Codigo de Clasificacion aparece duplicado en el archivo!')
		</cfquery>
	</cfif>	

<cfloop query="rsImportador">
	<!---Validar lineas en blanco--->
	<cfif len(trim(rsImportador.CCcodigo)) eq 0 and len(trim(rsImportador.CCcodigopadre)) eq 0 and len(trim(rsImportador.cuentac)) eq 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!Existen lineas en blanco!')
		</cfquery>	
	</cfif>
  <cfset cc=right(('00000' & rsImportador.CCcodigo), 5)>
   <!---Validar si ya existe el codigo de clasificacion en el sistema---> 
   <cfquery name="check2" datasource="#session.dsn#">
		select count(1) as check2
		from #table_name# a, 
		CConceptos b
		where '#right(('00000' & CCcodigo), 5)#' = b.CCcodigo		
		and b.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif check2.check2 gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!Codigo de Clasificacion ya existe en el sistema(#CCcodigo#)!')
		</cfquery>
	</cfif>	


  	<!---Validar que exista el codigo del padre--->
	 <cfquery name="check3" datasource="#session.dsn#">
		select count(1) as check3 
		from #table_name# a 
		where a.CCcodigopadre is not null
		and CCcodigo='#rsImportador.CCcodigo#'
		and a.CCcodigopadre is not null
		and not exists (select 1
						from #table_name# b
						where  b.CCcodigo = a.CCcodigopadre)
	</cfquery>
	<cfif check3.check3 gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!No existe el codigo del padre para #cc#!')
		</cfquery>
	</cfif>

</cfloop>

<cfquery name="rsERR" datasource="#session.dsn#">
	select count(1) as cantidad from #errores#
</cfquery>
<!--- <cf_dump var="#rsERR#"> --->
<cfif rsERR.cantidad eq 0>
	
<cfloop query="rsImportador">
	<cfquery name="rsCC" datasource="#session.dsn#">
		 select CCcodigopadre , CCcodigo 
		   from #table_name# where id = #rsImportador.id#
   </cfquery>
			   
	<cfif len(trim(rsCC.CCcodigopadre)) eq 0>
		<cfset vCCcodigopadre=''>
	<cfelse>
		<cfset vCCcodigopadre=rsCC.CCcodigopadre>
	</cfif>
	
	<cfif len(trim(rsCC.CCcodigo)) eq 0>
		<cfset vCCcodigo=''>
	<cfelse>
		<cfset vCCcodigo=rsCC.CCcodigo>
	</cfif>			  
			   
   <cfif not len(trim(vCCcodigopadre)) >
		<cfset vCnivel=0>
		<cfset vCpath=right(('00000' & vCCcodigo), 5)>
   <cfelse>
		<cfset ciclo = true > 
		<cfset vCpath=right(('00000' & vCCcodigo), 5)>
		<cfset i = 0 >
		<cfset x = rsImportador.CCcodigo >
			<cfloop condition="#ciclo#"  >
				<cfset vCpath =  right(('00000' & CCcodigopadre), 5) & '/' & vCpath > 
				<cfset vCnivel=vCnivel+1>
				
				<cfquery name="rsPadre" datasource="#session.dsn#">
					select CCcodigopadre from #table_name#
					where CCcodigo = '#vCCcodigopadre#'
				</cfquery>
					
				<cfset vCCcodigopadre = rsPadre.CCcodigopadre >
				
				<cfif len(trim(vCCcodigopadre)) eq 0 >
					<cfset ciclo = false >
				</cfif>
				<cfset i = i+1 >
				<!--- truco pa ke no se encicle, tomado de dani --->
				<cfif i eq 50000>
				<cf_errorCode	code = "50277" msg = "Error en procesamiento datos">
				</cfif>	
			</cfloop>
	</cfif>
	

	 <cfquery name="rsInsert" datasource="#session.dsn#">
		insert into CConceptos
			( Ecodigo,
			CCcodigo,
			CCdescripcion,
			Usucodigo,
			CCfalta,
			CCnivel,
			CCpath,
			cuentac)
		select
			#session.Ecodigo#,				
			'#right(('00000' & vCCcodigo), 5)#',
			a.CCdescripcion, 
			#session.usucodigo#,
			#Afecha#,
			#vCnivel#,
			'#vCpath#',				
			a.cuentac
			from #table_name# a	
			where CCcodigo = '#vCCcodigo#'						
	 </cfquery>	

</cfloop>
	
<cfquery name="rsPad" datasource="#session.dsn#">			
	select CCcodigopadre ,CCcodigo
	from #table_name# 
	where CCcodigopadre is not null
</cfquery>
		
<cfloop query="rsPad">
	<cfquery name="rs" datasource="#session.dsn#">				
		select CCid 
		from CConceptos a 
		where a.CCcodigo='#right(('00000' & rsPad.CCcodigopadre), 5)#'
		and Ecodigo=#session.Ecodigo#
	</cfquery>						
	<cfif len(trim(rs.CCid))>
		<cfquery name="up" datasource="#session.dsn#">
			update CConceptos 
			set CCidpadre=#rs.CCid#
			where CCcodigo='#right(('00000' & rsPad.CCcodigo), 5)#'
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cfif>
</cfloop>
		 
<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
		</cfquery>
		<cfreturn>		
</cfif>
		 

	
	
			 





