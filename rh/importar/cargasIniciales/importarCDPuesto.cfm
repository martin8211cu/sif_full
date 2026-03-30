
	<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
		<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	</cf_dbtemp>

	<cfquery datasource="#session.DSN#" name="datos">
			select codigo, descripcion, codigotipopuesto, ocupacion, codigoexterno, #session.Ecodigo#
			from #table_name#
	</cfquery>

	<cfset currentrow=0>
		<cftransaction>
			<cfloop query="datos">
				<cfset currentrow=currentrow+1>

				<cfquery datasource="#session.DSN#" name="existetemp">
					select CDRHHPcodigo, CDRHHPdescripcion, CDRHHPtipoPuesto, CDRHHPocupacion, CDRHHPcodigoExt, Ecodigo
					from CDRHHPuestos
					where CDRHHPcodigo = '#codigo#'
					and Ecodigo = #session.Ecodigo#
				</cfquery>

				<cfquery datasource="#session.DSN#" name="Existetbl">

					select RHPcodigo from RHPuestos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#(session.Ecodigo)#">
					and RHPcodigo =<cfqueryparam cfsqltype="cf_sql_char" value="#codigo#">

				</cfquery>

				<cfquery datasource="#session.DSN#" name="tblMaestroPadre">

					select RHMPPcodigo,* from RHMaestroPuestoP
					WHERE RHMPPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#codigo#">
					AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#(session.Ecodigo)#">

				</cfquery>


				<cfquery datasource="#session.DSN#" name="ExisteTbltpuesto">

					select RHTPcodigo,RHTPdescripcion from RHTPuestos
				 	where RHTPcodigo  =<cfqueryparam cfsqltype="cf_sql_char" value="#codigotipopuesto#">
					and Ecodigo = #session.Ecodigo#

				</cfquery>


				<cfquery datasource="#session.DSN#" name="ExisteTblOcupacion">

					select RHOcodigo from RHOcupaciones
				 	where RHOcodigo  =<cfqueryparam cfsqltype="cf_sql_char" value="#ocupacion#">
					and Ecodigo = #session.Ecodigo#

				</cfquery>


				<cfquery datasource="#session.DSN#" name="ExisteTblExterno">

					select  RHPEcodigo,* from RHPuestosExternos
					where RHPEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#codigoexterno#">
					and Ecodigo = #session.Ecodigo#

				</cfquery>

				<cfif existetemp.recordcount GT 0>

					<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
						insert into #errores# (Error)
				     	 values ('Error. El codigo del puesto (#existetemp.CDRHHPcodigo#) YA Existe en catalogo de carga  de puestos,el error se genero en la  linea
				     	 	#currentrow#')
					</cfquery>
				<cfelseif Existetbl.recordcount GT 0>
					<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
						insert into #errores# (Error)
				     	 values ('Error. El codigo del puesto (#codigo#) YA Existe en catalogo de puestos,el error se genero en la  linea
				     	 	#currentrow#')
					</cfquery>
				<cfelseif tblMaestroPadre.recordcount GT 0>
					<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
						insert into #errores# (Error)
				     	 values ('Error. El codigo del maestro puesto (#codigo#) YA Existe en catalogo de puestos,el error se genero en la  linea
				     	 	#currentrow#')
					</cfquery>
				<cfelseif ExisteTbltpuesto.recordcount EQ 0>
					<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
						insert into #errores# (Error)
				     	 values ('Error. El codigo de tipo de puesto (#codigotipopuesto#) no Existe, debe de ingresar un codigo existente,el error se genero en la  linea
				     	 	#currentrow#')
					</cfquery>
				<cfelseif ExisteTblOcupacion.recordcount EQ 0>
					<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
						insert into #errores# (Error)
				     	 values ('Error. El codigo de tipo de ocupación (#ocupacion#) no Existe, debe de ingresar un codigo existente,el error se genero en la  linea
				     	 	#currentrow#')
					</cfquery>
				<cfelseif ExisteTblExterno.recordcount EQ 0>
					<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
						insert into #errores# (Error)
				     	 values ('Error. El codigo de tipo  puesto Externo (#codigoexterno#) no Existe, debe de ingresar un codigo existente,el error se genero en la  linea
				     	 	#currentrow#')
					</cfquery>
				<cfelse>
						<cfquery datasource="#session.DSN#">
							insert into CDRHHPuestos(CDRHHPcodigo, CDRHHPdescripcion, CDRHHPtipoPuesto, CDRHHPocupacion, CDRHHPcodigoExt, Ecodigo,CDPcontrolv,	CDPcontrolg)
								values
								('#codigo#', '#descripcion#','#codigotipopuesto#', '#ocupacion#', '#codigoexterno#',
									#session.Ecodigo#, 0,0)
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







<!--- logica de Costa Rica
<cfquery datasource="#session.DSN#">
	insert into CDRHHPuestos(CDRHHPcodigo, CDRHHPdescripcion, CDRHHPtipoPuesto, CDRHHPocupacion, CDRHHPcodigoExt, Ecodigo)
	select codigo, descripcion, codigotipopuesto, ocupacion, codigoexterno, #session.Ecodigo#
	from #table_name#
</cfquery>

 --->