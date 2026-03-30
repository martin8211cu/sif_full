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
		select  count(count(1)) as check1
		from #table_name#
		group by Ccodigo
		having count(1) > 1
	</cfquery>
	<cfif check1.check1 gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!Codigo del Servicio aparece duplicado en el archivo!')
		</cfquery>
	</cfif>	
	
<cfloop query="rsImportador">
<cfset Ccodigo=#rsImportador.Ccodigo#>
<!---  Validar si ya existe el codigo de Servicio en el sistema --->
	<cfquery name="check2" datasource="#session.dsn#">
		select count(1) as check2,a.Ccodigo
		from #table_name# a,
		Conceptos b
		where a.Ccodigo = b.Ccodigo
		and b.Ecodigo = #session.Ecodigo#
		and a.Ccodigo='#Ccodigo#'
		and a.CCcodigo='#rsImportador.CCcodigo#'
	</cfquery>	
	<cfif check2.check2 gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error!El servicio ya se encuentra registrado en el sistema(#Ccodigo#)!')
		</cfquery>
	</cfif>

	<!--- Validar existencia de Unidades --->
		<cfquery name="check3" datasource="#session.dsn#">
			  select count(1) as check3,a.Ucodigo 
			   from #table_name# a
			   where ltrim(rtrim(a.Ucodigo)) <>''
				 and a.Ucodigo is not null
				 and a.Ucodigo='#rsImportador.Ucodigo#'
				 and not exists( select 1 from Unidades b
									   where b.Ucodigo = a.Ucodigo
										  and b.Ecodigo =  #session.Ecodigo#)
				and a.Ccodigo='#Ccodigo#'
			</cfquery>
		<cfif check3.check3 gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Codigo de Unidad no esta registrado en el sistema(#check3.Ucodigo#)!')
			</cfquery>
		</cfif>
				 
	<!--- Validar existencia de Clasificaciones de Servicio --->
		<cfquery name="check4" datasource="#session.dsn#">
			select  count(1) as check4 ,a.CCcodigo
			  from #table_name# a
			 where ltrim(rtrim(a.CCcodigo )) <> ''
				and a.CCcodigo is not null
				and a.Ccodigo='#Ccodigo#'
				and not exists( select 1 from CConceptos b
								where b.CCcodigo = a.CCcodigo
								and b.Ecodigo =  #session.Ecodigo#)
		</cfquery>
		
		<cfif check4.check4 gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Clasificacion de servicio no esta registrada en el sistema(#check4.CCcodigo#)!')
			</cfquery>
		</cfif>		
</cfloop>

		<cfquery name="rsErr" datasource="#session.dsn#">
			select count(1) as cantidad from #errores#
		</cfquery>
		
		<cfif rsERR.cantidad eq 0>
		<cfquery name="rsIns" datasource="#session.dsn#">		
			insert into Conceptos
			 ( Ecodigo, Ccodigo, Cdescripcion, Ctipo, Ucodigo, CCid)
			select  
				#session.Ecodigo#,
				a.Ccodigo,
				a.Cdescripcion,
				a.Ctipo,
				a.Ucodigo, 
				b.CCid
			from #table_name# a, CConceptos b
			where a.CCcodigo *= b.CCcodigo
			and b.Ecodigo = #session.Ecodigo#
		</cfquery>
							  
				 
<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
		</cfquery>
		<cfreturn>		
</cfif>		 
		
					
   	
							
	