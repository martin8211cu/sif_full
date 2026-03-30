<!---mcz--->
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores01" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery name="rsCheck0" datasource="#Session.DSN#">
	select count(1) as check0 from #table_name#
</cfquery>

<cfif rsCheck0.Recordcount eq 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error!No se pudieron cargar bien los datos, por favor revise el archivo!')
	</cfquery>	
</cfif>

<cfquery name="rsImportador" datasource="#session.dsn#">
	select * from #table_name#
</cfquery>

<!--- Validar que no existan duplicados en el archivo --->
	<cfquery name="check1" datasource="#session.dsn#">
		select  count(1) as check1
		from #table_name#
		group by Acodigo
		having count(1) > 1
	</cfquery>
	<cfif check1.check1 gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!Codigo del Articulo aparece duplicado en el archivo!')
		</cfquery>
	</cfif>	

<cfloop query="rsImportador">
	<cfset Acodigo=#rsImportador.Acodigo#>
	<cfset AFMid='#rsImportador.AFMid#'>
	<cfset AFMMid='#rsImportador.AFMMid#'>
	<cfset CAid='#rsImportador.CAid#'>
	<cfset Ucodigo='#rsImportador.Ucodigo#'>
	<cfset Ccodigoclas='#rsImportador.Ccodigoclas#'>
	<cfset Acosto='#rsImportador.Acosto#'>
	
	
	<!--- Validacion del tipo de costeo --->

	<cfif not (Acosto eq 0 or Acosto eq 1 or Acosto eq 2)>
		<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('prueba de error')
		</cfquery>
	</cfif>
	
	<cfif not (Acosto eq 0 or Acosto eq 1 or Acosto eq 2)>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!Tipo de costeo inconsistente debe ser (0,1,2)(#Acosto#)!')
		</cfquery>
	</cfif>
	
	<!--- Existencia del codigo del articulo --->
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count (1) as cantidad from Articulos 
		where Acodigo='#Acodigo#'
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif rsCheck1.cantidad gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!El codigo del articulo ya existe en el sistema(#Acodigo#)!')
			</cfquery>
		</cfif>
	<!--- Chequear Validez de las Unidades --->
		<cfquery name="rsCheck1" datasource="#Session.DSN#">
			select a.Ucodigo
			from #table_name# a
			where  not exists
			(
				select b.Ucodigo
				from Unidades b
				where b.Ucodigo = '#Ucodigo#'
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">			
			)
			and a.Acodigo='#Acodigo#'
		</cfquery>
		<cfif rsCheck1.recordcount gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!La Unidad no existe(#Ucodigo#)!')
			</cfquery>
		</cfif>
	
	<!--- Chequear Validez de las Clasificaciones --->
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select a.Ccodigoclas
		from #table_name# a
		where not exists(
									select c.Ccodigoclas
									from Clasificaciones c
									where c.Ccodigoclas = '#Ccodigoclas#'
									and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
									)
		and a.Acodigo='#Acodigo#'
	</cfquery>
	<cfif rsCheck2.recordcount gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!La Clasificaci&oacute;n no existe(#Ccodigoclas#)!')
		</cfquery>
	</cfif>
	
	<!--- Chequear Validez las Marcas --->
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select a.AFMid
		from #table_name# a
		where 
		 not exists(
							select c.AFMid
							from AFMarcas c
							where c.AFMcodigo='#AFMid#'
							and c.Ecodigo = #Session.Ecodigo#
							) 					
	and a.Acodigo='#Acodigo#'
	</cfquery>	
	<cfif rsCheck2.recordcount gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!La marca no existe(#AFMid#)!')
		</cfquery>
	</cfif>
	
	<!--- Chequear Validez las Modelos --->
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select a.AFMMid
		from #table_name# a
		where not exists(
								select c.AFMid
								from AFMModelos c
								where c.AFMMcodigo = '#AFMMid#'
								and c.Ecodigo = #Session.Ecodigo#
							)
		and a.Acodigo='#Acodigo#'		
	</cfquery>	
	<cfif rsCheck2.recordcount gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El modelo no existe(#AFMMid#)!')
		</cfquery>
	</cfif>
	
	<!--- Chequear Validez del codigo Aduanal --->
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
	select a.CAid
	from #table_name# a
	where  not exists(
						select c.CAid
						from CodigoAduanal c
						where c.CAcodigo = '#CAid#'
						and c.Ecodigo = #Session.Ecodigo#
						)
	and a.Acodigo='#Acodigo#'		
	</cfquery>
		
	<cfif rsCheck2.recordcount gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error!El codigo aduanal no existe(#CAid#)!')
		</cfquery>
	</cfif>
</cfloop>


<cfquery name="rsErr" datasource="#session.dsn#">
	select count(1) as cantidad from #errores# 
</cfquery>
		

<!--- Inserciones --->
<cfif rsErr.cantidad eq 0>

	<cfloop query="rsImportador">
		<cfset Acodigo=#rsImportador.Acodigo#>
		<cfset AFMid='#rsImportador.AFMid#'>
		<cfset AFMMid='#rsImportador.AFMMid#'>
		<cfset CAid='#rsImportador.CAid#'>
		<cfset Ccodigoclas='#rsImportador.Ccodigoclas#'>
		<cfquery name="marcas" datasource="#Session.DSN#">
			select AFMid from AFMarcas where AFMcodigo='#AFMid#'
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		
		<cfquery name="modelos" datasource="#Session.DSN#">
			select AFMMid from AFMModelos where AFMMcodigo='#AFMMid#'
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		
		<cfquery name="clasif" datasource="#Session.DSN#">
			select Ccodigo from  Clasificaciones c where c.Ccodigoclas = '#Ccodigoclas#'
			and c.Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfquery name="aduana" datasource="#Session.DSN#">
			select max(CAid) as CAid from CodigoAduanal where CAcodigo = '#CAid#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			insert INTO Articulos 
				(Ecodigo,
				Acodigo,
				Ucodigo, 
				Ccodigo,
				Adescripcion,
				Afecha,
				AFMid,
				AFMMid,
				Atipocosteo,
				CAid)
			values( 
				#session.Ecodigo#,
				'#rsImportador.Acodigo#',
				'#rsImportador.Ucodigo#',
				#clasif.Ccodigo#,
				'#rsImportador.Adescripcion#',
				<cf_dbfunction name="now">,
				#marcas.AFMid#,
				#modelos.AFMMid#,
				#rsImportador.Acosto#,
				#aduana.CAid#)
		</cfquery> 				
	
	</cfloop>
<cfelse>

	<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
	</cfquery>
	<cfreturn>	
</cfif>

