	
	<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
		<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	</cf_dbtemp>


	<cfquery datasource="#session.DSN#" name="datos">
			select codigo, descripcion, informacion, #session.Ecodigo#, 0,0
			from #table_name#		
	</cfquery>

	<cfset currentrow=0>
 		<cftransaction>
			<cfloop query="datos">
				<cfset currentrow=currentrow+1>

					<cfquery datasource="#session.DSN#" name="Existe">
					
					select  CDRHHTPcodigo,CDRHHTPdescripcion,CDRHHTPinfo,Ecodigo,CDPcontrolv,	CDPcontrolg from CDRHHTiposPuesto
					where CDRHHTPcodigo = '#codigo#'
					and Ecodigo = #session.Ecodigo#
					
					</cfquery>

					<cfquery datasource="#session.DSN#" name="ExisteTblpuesto">

					select RHTPcodigo,RHTPdescripcion from RHTPuestos
				 	where rtrim(RHTPdescripcion) =<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(descripcion)#">	
					and Ecodigo = #session.Ecodigo#

					</cfquery>


				<cfif Existe.recordcount GT 0>

						<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
							insert into #errores# (Error)
					     	 values ('Error. El codigo del tipo de puesto (#Existe.CDRHHTPcodigo#) YA Existe en catalogo de carga tipo de puestos,el Error se genero en la  linea 
					     	 	#currentrow#')
						</cfquery>

				<cfelseif ExisteTblpuesto.recordcount gt 0>

						<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
							insert into #errores# (Error)
					     	 values ('Error. El codigo del tipo de puesto (#ExisteTblpuesto.RHTPdescripcion#) YA Existe en catalogo de tipo de puestos,el Error se genero en la  linea 
					     	 	#currentrow#')
						</cfquery>

				<cfelse>
						<cfquery datasource="#session.DSN#">
							insert into CDRHHTiposPuesto(CDRHHTPcodigo,CDRHHTPdescripcion,CDRHHTPinfo,Ecodigo,CDPcontrolv,	CDPcontrolg)
								values
								('#codigo#', '#descripcion#', '#informacion#', #session.Ecodigo#, 0,0)
						</cfquery>
				</cfif>
			</cfloop>

	<cfquery name="rsErrores" datasource="#session.DSN#">
    	select count(1) as cantidad
    	from #errores#
    </cfquery>

	<cfif rsErrores.cantidad GT 0>
		<cfquery name="ERR" datasource="#session.DSN#">
				select Error as MSG
				from #errores#
				group by Error
		</cfquery>
		<cfreturn>
 	</cfif>
	<cftransaction action="commit"/>
</cftransaction>


			<!--- version de costa rica para insertar 


			select codigo, descripcion, informacion, #session.Ecodigo#, 0,0
							from #table_name#	



			--->



