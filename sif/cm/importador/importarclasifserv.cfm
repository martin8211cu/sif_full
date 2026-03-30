<!---mcz--->
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<!---creo la tabla temporal--->
<cfquery name="rsImportador" datasource="#session.dsn#">
	select * from #table_name#
</cfquery>

<cfdump var="#rsImportador#">


<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

<cfloop query="rsImportador">	
	<!--- Validar que no existan duplicados en el archivo--->
	<cfquery name="check1" datasource="#session.dsn#">
		select count(1) as check1 
		from #table_name#
		group by Ccodigoclas
		having count(1) > 1
	</cfquery>
	
	<cfif check1.check1 gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error! Existen registros duplicados en el archivo!')
		</cfquery>
	</cfif>

	<!--- <!--- Validar que no existan campos obligatorios en el importador--->
	<cfif rsImportador.Ccodigoclas eq '' or rsImportador.Cdescripcion eq '' or rsImportador.Ccomision eq ''>
		<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error! Existen campos obligatorios en blanco!')
		</cfquery>
	</cfif> --->

	
	<!--- Validar la existencia del codigo clase--->
	<cfquery name="check1" datasource="#session.dsn#">
		select count(1) as check1, a.Ccodigoclas
		from #table_name# a
			inner join Clasificaciones c
				on c.Ecodigo = #session.Ecodigo#
				and c.Ccodigoclas = a.Ccodigoclas
		group by a.Ccodigoclas
	</cfquery>
	<cfif check1.check1 gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error! El codigo de clase(#check1.Ccodigoclas#) que desea importar ya existe!')
		</cfquery>
	</cfif>
	
	<!---Validar que exista el codigo del padre--->
	<cfquery name="check3" datasource="#session.dsn#">
		select count(1) as check3  
		from #table_name# a 
		where ltrim(rtrim(a.Ccodigoclaspadre)) <> '' 
			and a.Ccodigoclaspadre  is not null
			and  not exists ( select 1 
								from #table_name# b
								where a.Ccodigoclaspadre = b.Ccodigoclas)
	</cfquery>
	<cfif check3.check3 gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error! El codigo padre no existe en los registros del importador!')
		</cfquery>
	</cfif>



	<!---De aqui en adelante no entiendo--->
	<cfquery name="maxi" datasource="#session.dsn#">
		select coalesce(max(Ccodigo),0) as maxid   from Clasificaciones where Ecodigo = #session.Ecodigo#
	</cfquery>

	<cfset maxid= maxi.maxid+1>
	
	<cfset mini=-1>
	
	<cfquery name="mini" datasource="#session.dsn#">
		select min(id) as mini from #table_name# where id > #mini#
	</cfquery>	

	<cfif len(trim(mini.mini)) gt 0>
		<cfset mini= mini.mini>
		
	</cfif>
	<cfquery name="rsSQL1" datasource="#session.dsn#">
		select Ccodigoclaspadre,Ccodigoclas from #table_name# where id = #mini#
	</cfquery>

	<cfif len(trim(mini)) gt 0>
		<cfset Ccodigoclaspadre=#rsSQL1.Ccodigoclaspadre#>
		<cfset Ccodigoclas=#rsSQL1.Ccodigoclas#>
	<cfelse>
		<cfset Ccodigoclaspadre=''>
		<cfset Ccodigoclas=''>
	</cfif>	

	<cfif len(trim(Ccodigoclaspadre)) eq 0>
		<cfset Cnivel=0>
		<cfset Cpath=right(('00000' + #Ccodigoclas#), 5)>
		<cfset Ccodigopadre=''>
	<cfelse>
		<cfset Cnivel=0>
		<cfset Cpath=right(('00000' + #Ccodigoclas#), 5)>
			<cfquery name="rsSQL2" datasource="#session.dsn#">
				select Ccodigoclaspadre,Ccodigoclas,id from #table_name# a
           		where a.Ccodigoclas = #Ccodigoclaspadre#
			</cfquery>
		<cfset Ccodigopadre=#rsSQL2.id#>
			<cfif len(trim(#Ccodigopadre#)) eq 0>
					<cfset Ccodigopadre=0>
			<cfelse>
				<cfset Ccodigopadre=#Ccodigopadre#+#maxid#>
			</cfif>
	</cfif>
	
</cfloop>		
	<cfquery name="rsPadres" datasource="#session.dsn#">
		select * from #table_name# where Ccodigoclaspadre<>''
	</cfquery>

	<cfloop query="rsPadres">
		<cfset Cpath=right(('00000' + #Ccodigoclas#), 5)  +  '/' +  #Cpath# >
		<cfset Cnivel=#Cnivel#+1>
			<cfset Ccodigopadre=#rsSQL2.Ccodigoclaspadre#>
	</cfloop>

	  			
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>


<!---<cfoutput>
#session.Ecodigo#,
#maxid#, 
#Ccodigoclaspadre#,
'#rsImportador.Ccodigoclas#',
'#rsImportador.Cdescripcion#',
'#Cpath#',
#Cnivel#,
#rsImportador.Ccomision#, 
'#rsImportador.cuentac#'
</cfoutput>
<cfabort>--->
<cfif rsErrores.cantidad eq 0>
	<cfloop query="rsImportador">
		<cfquery name="rsInsert" datasource="#session.dsn#">	
			insert into Clasificaciones
				(Ecodigo,
				Ccodigo,
				Ccodigopadre,
				Ccodigoclas,
				Cdescripcion,
				Cpath,
				Cnivel,
				Ccomision,
				cuentac)		
			values(
				#session.Ecodigo#,
				#maxid#, 
				<cfif len(trim(Ccodigoclaspadre)) NEQ 0>
					#Ccodigoclaspadre#,
				<cfelse>
					null,
				</cfif>			
				'#rsImportador.Ccodigoclas#',
				'#rsImportador.Cdescripcion#',
				'#Cpath#',
				#Cnivel#,
				#rsImportador.Ccomision#, 
				'#rsImportador.cuentac#')			
		</cfquery>
	</cfloop>
</cfif>	


 <cfif rsErrores.cantidad gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select Error as MSG
		from #errores#
		order by Error
	</cfquery>
	<cfreturn>		
</cfif>
