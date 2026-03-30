
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
		<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	</cf_dbtemp>


	<cfquery datasource="#session.DSN#" name="datos">
			select codigo, descripcion, #session.Ecodigo#
			from #table_name#		
	</cfquery>

	<cfset currentrow=0>
 		<cftransaction>
			<cfloop query="datos">
				<cfset currentrow=currentrow+1>}

					<cfquery datasource="#session.DSN#" name="Existe">
						
						select  CDRHHDptoCodigo, CDRHHDdescripcion, Ecodigo from CDRHHDepartamentos
						where CDRHHDptoCodigo = '#codigo#'
						and Ecodigo = #session.Ecodigo#
						
					</cfquery>

						<cfquery datasource="#session.DSN#" name="ExisteTblpuesto">

						select Dcodigo,* from Departamentos
					 	where Dcodigo =<cfqueryparam cfsqltype="cf_sql_varchar" value="#codigo#">	
						and Ecodigo = #session.Ecodigo#

					</cfquery>

				<cfif Existe.recordcount GT 0>

					<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
						insert into #errores# (Error)
				     	 values ('Error. El codigo del tipo de puesto (#Existe.CDRHHDptoCodigo#) YA Existe en el catalogo de carga departamento,el Error se genero en la  linea 
				     	 	#currentrow#')
					</cfquery>

				<cfelseif ExisteTblpuesto.recordcount gt 0>

					<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
						insert into #errores# (Error)
				     	 values ('Error. El codigo de Departamento (#ExisteTblpuesto.Dcodigo#) YA Existe en catalogo departamento,el Error se genero en la  linea 
				     	 	#currentrow#')
					</cfquery>

				<cfelse>

					<cfquery datasource="#session.DSN#">
						insert into CDRHHDepartamentos( CDRHHDptoCodigo, CDRHHDdescripcion, Ecodigo,CDPcontrolv, CDPcontrolg ) values ('#codigo#', '#descripcion#', #session.Ecodigo#,0,0)
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


<!--- proceso de costa rica
<cfquery datasource="#session.DSN#">
	insert into CDRHHDepartamentos( CDRHHDptoCodigo, CDRHHDdescripcion, Ecodigo )
	select codigo, descripcion, #session.Ecodigo#
	from #table_name#	
</cfquery> --->