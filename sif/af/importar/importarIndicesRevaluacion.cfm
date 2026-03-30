<cfset bcheck1 = false>	<!--- Registros repetidos en el archivo de importación --->
<cfset bcheck2 = false>	<!--- Categoría Válida --->
<cfset bcheck3 = false>	<!--- Clase Válida     --->
<cfset bcheck4 = false>	<!--- Relacion Categoría vrs  Clase    --->
<cfset bcheck5 = false>	<!--- Valida la integridad --->
<cfset bcheck6 = false>	<!--- Valida las columnas en blanco --->
<cfset bcheck7 = false>	<!--- Valida las columnas en blanco --->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!--- Revision de columnas para controlar que esten completas --->
<cfquery name="rsCheck6" datasource="#session.DSN#">
Select count(1) as total
from #table_name# 
where (ACcodigodescCat is null 
   or ACcodigodescCla is null 
   or AFIperiodo is null 
   or AFImes is null
   or AFIindice is null)
</cfquery>

<cfif rsCheck6.total EQ 0>
	<cfset bcheck6 = true>
</cfif>

<cfif bcheck6>
<!---	<cf_dbfunction name="to_char" args="AFIperiodo"  returnvariable="AFIperiodo">
--->	
<cf_dbfunction name="to_char" args="AFIperiodo" returnvariable="AFIperiodo">	
<cf_dbfunction name="length"  args="rtrim(ltrim(#AFIperiodo#))" returnvariable="LENAFIperiodo">
	<!--- Revision de que el periodo-mes sea válido --->
	<cfquery name="rsCheck7" datasource="#session.DSN#">
	Select count(1) as total
	from #table_name# 
	where (#PreserveSingleQuotes(LENAFIperiodo)# != 4 
		or AFImes < 1 
		or AFImes > 12)
	</cfquery>
	
	<cfif rsCheck7.total EQ 0>
		<cfset bcheck7 = true>
	</cfif>

	<cfif bcheck7>


		<!--- Registros repetidos en el archivo de importación --->
		<cfquery name="rsCheck1" datasource="#session.DSN#">
			select ACcodigodescCat, ACcodigodescCla, AFIperiodo, AFImes
			from #table_name# 
			group by ACcodigodescCat, ACcodigodescCla, AFIperiodo, AFImes
			having count(1) > 1		
		</cfquery>
		<cfif rsCheck1.RecordCount EQ 0>
			<cfset bcheck1 = true>
		</cfif>
	
		<cfif bcheck1>
			<cfquery name="rsCheckCategoria" datasource="#session.DSN#">
				select x.ACcodigodescCat as cantidad
				from #table_name# x
				where  ltrim(rtrim(x.ACcodigodescCat))  not in (
					select ltrim(rtrim(a.ACcodigodesc))
					from ACategoria a 
					where a.Ecodigo =  #session.Ecodigo# )
			</cfquery>
			
			<cfif rsCheckCategoria.RecordCount eq 0>
				<cfset bcheck2 = true>
			</cfif>
			
			<cfif bcheck2><!--- check2--->
				
				<cfquery name="rsCheckClase" datasource="#session.DSN#"><!--- Código Clase Válida---->
					select x.ACcodigodescCla as cantidad
					from #table_name# x
					where  ltrim(rtrim(x.ACcodigodescCla))  not in (
						select ltrim(rtrim(a.ACcodigodesc)) 
						from AClasificacion a 
						where a.Ecodigo =  #session.Ecodigo# )
				</cfquery>
				
				<cfif rsCheckClase.RecordCount eq 0>
					<cfset bcheck3= true>
				</cfif>
				
				<cfif bcheck3><!--- check3--->
					
					<cfquery name="rsCheckRel" datasource="#session.DSN#"><!--- Relación entre clase y categoría---->
						select ltrim(rtrim(x.ACcodigodescCat)) #_Cat# ',' #_Cat# ltrim(rtrim(x.ACcodigodescCla)) as cantidad
						  from #table_name# x
						where ltrim(rtrim(x.ACcodigodescCat)) #_Cat#',' #_Cat# ltrim(rtrim(x.ACcodigodescCla))
						 not in (
							select ltrim(rtrim(b.ACcodigodesc)) #_Cat#','#_Cat# ltrim(rtrim(a.ACcodigodesc))
							from AClasificacion a
							 inner join ACategoria b 
							  on a.Ecodigo = b.Ecodigo
							 and  b.ACcodigo = a.ACcodigo
							where a.Ecodigo =  #session.Ecodigo# )
					</cfquery>	
					
					<cfif rsCheckRel.RecordCount eq 0>
						<cfset bcheck4 = true>
					</cfif>	
							
					<cfif bcheck4><!--- check4--->
					
						<cfquery name="rsCheckIntegridad" datasource="#session.DSN#"><!--- Relación entre clase y categoría---->
							select ltrim(rtrim(x.ACcodigodescCat)) #_Cat# ',' #_Cat# ltrim(rtrim(x.ACcodigodescCla)) #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="x.AFIperiodo"> #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="x.AFImes"> as cantidad
							  from #table_name# x
							where ltrim(rtrim(x.ACcodigodescCat)) #_Cat# ',' #_Cat# ltrim(rtrim(x.ACcodigodescCla)) #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="x.AFIperiodo"> #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="x.AFImes">
							 in (
								select 
									ltrim(rtrim(aca.ACcodigodesc)) #_Cat# ','#_Cat# ltrim(rtrim(ac.ACcodigodesc))#_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="x.AFIperiodo">#_Cat# ','#_Cat# <cf_dbfunction name="to_char" args="x.AFImes">
								from AFIndices af
									inner join AClasificacion ac
										on ac.Ecodigo = af.Ecodigo
										and ac.ACid =  af.ACid
										and ac.ACcodigo = af.ACcodigo 
									inner join ACategoria aca
										on aca.Ecodigo = af.Ecodigo
										and aca.ACcodigo = af.ACcodigo
								where af.Ecodigo =  #session.Ecodigo#  
								
									 and af.AFIperiodo = x.AFIperiodo
									and af.AFImes = x.AFImes)
						</cfquery>	
										
						<cfif rsCheckIntegridad.RecordCount eq 0>
							<cfset bcheck5 = true>
						</cfif>	
								
						<cfif bcheck5><!--- check5--->
					
							<!--- Periodo--->
							<cfquery name="rsPeriodo" datasource="#session.DSN#">
								select p1.Pvalor as value 
								  from Parametros p1 
								where Ecodigo = #session.Ecodigo#
								and Pcodigo = 50
							</cfquery> 
									
							<!--- **************************************************************************************** --->
							<cftransaction>
							<cfquery name="rstemp" datasource="#session.dsn#">
								insert into AFIndices (Ecodigo, ACcodigo, ACid, AFIperiodo, AFImes, AFIindice, AFIfecha, AFIusuario)
								select 
									 #session.Ecodigo# , 
									(select min(ac.ACcodigo)
										from ACategoria ac
										where ac.Ecodigo =  #session.Ecodigo# 
											and rtrim(ltrim(ac.ACcodigodesc)) = rtrim(ltrim(tn.ACcodigodescCat))
									) as ACcodigo, 
									
									(select min(cl.ACid)
										from AClasificacion cl
										where cl.Ecodigo =  #session.Ecodigo# 
											 and ACcodigo = 
													(select min(ac.ACcodigo)
														from ACategoria ac
														where ac.Ecodigo =  #session.Ecodigo# 
															and rtrim(ltrim(ac.ACcodigodesc)) = rtrim(ltrim(tn.ACcodigodescCat))
													)
											 and rtrim(ltrim(cl.ACcodigodesc)) = rtrim(ltrim(tn.ACcodigodescCla))
									) as ACid,
									tn.AFIperiodo,
									tn.AFImes,
									tn.AFIindice,
									<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
									'#Session.Usuario#'
								from #table_name# tn
							</cfquery>
							
							</cftransaction>
							<!--- **************************************************************************************** --->
						<cfelse> <!--- check5--->
							
							<!--- 
							Ya existen algunos de los indices que vienen en el archivo en la 
							base de datos, por lo que se actualizan con la nueva información.
							--->
							
							<!--- Periodo--->
							<cfquery name="rsPeriodo" datasource="#session.DSN#">
								select p1.Pvalor as value 
								  from Parametros p1 
								where Ecodigo = #session.Ecodigo#
								and Pcodigo = 50
							</cfquery> 
									
							<!--- **************************************************************************************** --->
							<cftransaction>
							
							<!--- INSERTA LO QUE NO EXISTE --->
							<cfquery name="rstemp" datasource="#session.dsn#">
								insert into AFIndices (Ecodigo, ACcodigo, ACid, AFIperiodo, AFImes, AFIindice, AFIfecha, AFIusuario)
								select 
									 #session.Ecodigo# , 
									(select min(ac.ACcodigo)
										from ACategoria ac
										where ac.Ecodigo =  #session.Ecodigo# 
											and rtrim(ltrim(ac.ACcodigodesc)) = rtrim(ltrim(tn.ACcodigodescCat))
									) as ACcodigo, 
									
									(select min(cl.ACid)
										from AClasificacion cl
										where cl.Ecodigo =  #session.Ecodigo# 
											 and ACcodigo = 
													(select min(ac.ACcodigo)
														from ACategoria ac
														where ac.Ecodigo =  #session.Ecodigo# 
															and rtrim(ltrim(ac.ACcodigodesc)) = rtrim(ltrim(tn.ACcodigodescCat))
													)
											 and rtrim(ltrim(cl.ACcodigodesc)) = rtrim(ltrim(tn.ACcodigodescCla))
									) as ACid,
									
									tn.AFIperiodo,
									tn.AFImes,
									tn.AFIindice,
									<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
									'#Session.Usuario#'
								from #table_name# tn
								where not exists(Select 1
												 from AFIndices b
														inner join ACategoria ac
															 on ac.ACcodigo = b.ACcodigo
															and ac.Ecodigo  = b.Ecodigo
															
														inner join AClasificacion acl
															 on acl.ACid = b.ACid
															and acl.ACcodigo = ac.ACcodigo 
															and acl.Ecodigo  = b.Ecodigo
	
												 where b.Ecodigo =  #session.Ecodigo# 
												   and ac.ACcodigodesc	= tn.ACcodigodescCat
												   and acl.ACcodigodesc	= tn.ACcodigodescCla
												   and b.AFIperiodo		= tn.AFIperiodo
												   and b.AFImes			= tn.AFImes)
							</cfquery>
							
							<!--- ACTUALIZA LO QUE EXISTE --->
							<cfquery name="IndicesPorActualizar" datasource="#session.dsn#">
								select tn.AFIindice,tn.AFIperiodo, tn.AFImes,ac.ACcodigo, acl.ACid 
								  from #table_name# tn
									inner join ACategoria ac
										on rtrim(ltrim(ac.ACcodigodesc)) = rtrim(ltrim(tn.ACcodigodescCat))										
									   	and ac.Ecodigo =  #session.Ecodigo# 
									inner join AClasificacion acl
										on rtrim(ltrim(acl.ACcodigodesc)) = rtrim(ltrim(tn.ACcodigodescCla))
									 	and acl.ACcodigo = ac.ACcodigo										
										and acl.Ecodigo =  #session.Ecodigo# 
							</cfquery>
							<cfloop query="IndicesPorActualizar">
								<cfquery name="rstemp" datasource="#session.dsn#">
									UPDATE AFIndices 
									set AFIindice 	 = #IndicesPorActualizar.AFIindice#,
										AFIfecha 	 = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'YYYY/MM/DD')#">,
										AFIusuario	 = '#Session.Usuario#'
									where Ecodigo	 = #session.Ecodigo# 
									  and AFIperiodo = #IndicesPorActualizar.AFIperiodo#
									  and AFImes	 = #IndicesPorActualizar.AFImes#	
									  and ACcodigo 	 = #IndicesPorActualizar.ACcodigo#	
									  and ACid 		 = #IndicesPorActualizar.ACid#	  					  
								</cfquery>
							</cfloop>
							</cftransaction>
								
						</cfif> 
					<cfelse> <!--- check4--->
						<cfquery name="ERR" dbtype="query">
							select 'La siguente categoría y clase no tienen relación :' #_Cat# rsCheckRel.cantidad  as Motivo 
							from rsCheckRel
						</cfquery>			
					</cfif> 
				<cfelse> <!--- check3--->
					<cfquery name="ERR" dbtype="query">
						select 'La siguente clase no existe :' #_Cat# rsCheckClase.cantidad  as Motivo 
						from rsCheckClase
					</cfquery>			
				</cfif> 				
			<cfelse> <!--- check2--->
				<cfquery name="ERR" dbtype="query">
					select 'La siguente categoría no existe :' #_Cat# rsCheckCategoria.cantidad  as Motivo 
					from rsCheckCategoria
				</cfquery>			
			</cfif> 			
		<cfelse> <!--- check1 --->
			<cfquery name="ERR" datasource="#session.dsn#">
					select 'Existen registros repetidos en el archivo de importación' as Motivo 
			</cfquery>
		</cfif>


	<cfelse> <!--- check7 --->
		<cfquery name="ERR" datasource="#session.dsn#">
			select 'Existen valores inválidos en los campos de periodo o mes' as Motivo 
		</cfquery>
	</cfif>

<cfelse> <!--- check6 --->
	<cfquery name="ERR" datasource="#session.dsn#">
		select 'Existen lineas que estan incompletas o en blanco dentro del archivo de importación' as Motivo 
	</cfquery>
</cfif>