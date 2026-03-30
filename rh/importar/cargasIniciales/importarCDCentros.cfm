	<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
		<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	</cf_dbtemp>

	<cfquery datasource="#session.DSN#" name="datos">
		select codigo, descripcion, oficina, departamento, responsable, #session.Ecodigo#
		from #table_name#		
	</cfquery>


<cfset currentrow=0>
 <cftransaction>
	<cfloop query="datos">

		<cfset currentrow=currentrow+1>

		<!--- verifica los datos repetidos --->

			<cfquery datasource="#session.DSN#" name="datosRepetidos">
				select codigo, descripcion, oficina, departamento,
				 responsable, #session.Ecodigo#
				from #table_name#		
			</cfquery>

			<!--- verifica que no este Repetidos los Registros de la tabla temporal  Respecto a Oficinas--->

			<cfquery datasource="#session.DSN#" name="ExisteOfiTemp">

				select  CDRHHCFcodigo,CDRHHCFdescripcion,CDRHHOficodigo,CDRHHDptoCodigo,CDRHHCFcodigoPadre,Ecodigo
				 from CDRHHCFuncional 
					where CDRHHOficodigo = '#oficina#'
					and Ecodigo = #session.Ecodigo#
				
			</cfquery>


			<!--- verifica que no este Repetidos los Registros de la tabla temporal  Respecto a Departamento--->

			<cfquery datasource="#session.DSN#" name="ExisteDptoTemp">

				select  CDRHHCFcodigo,CDRHHCFdescripcion,CDRHHOficodigo,CDRHHDptoCodigo,CDRHHCFcodigoPadre,Ecodigo
				 from CDRHHCFuncional 
					where CDRHHDptoCodigo = '#departamento#'
					and Ecodigo = #session.Ecodigo#
				
			</cfquery>

			<!--- verifica que no este Repetidos los Registros de la tabla temporal  el centro funcional --->

			<cfquery datasource="#session.DSN#" name="ExisteCFTemp">

				select  CDRHHCFcodigo
				 from CDRHHCFuncional 
					where CDRHHCFcodigo = '#codigo#'
					and Ecodigo = #session.Ecodigo#
				
			</cfquery>

			<!--- verifica  Existencia del Departemento  --->
			<cfquery datasource="#session.DSN#" name="ExisteDepartamento">

				select Deptocodigo from Departamentos
				where Deptocodigo = '#departamento#'
				and Ecodigo = #session.Ecodigo#
			</cfquery>

			<!--- verifica Existencia de la Oficina --->
			<cfquery datasource="#session.DSN#" name="ExistenOficina">

				select * from Oficinas
				where Ocodigo = '#oficina#'
				and Ecodigo = #session.Ecodigo#
			</cfquery>

			<!--- verifica Existencia del Centro Funcional --->

			<cfquery datasource="#session.DSN#" name="ExistenCResponsable">

				select CFpath from CFuncional
				where CFpath = '#responsable#'
				and Ecodigo = #session.Ecodigo#
			</cfquery>

			<!---verifica existencia en el en el entro funcional  --->
			<cfquery datasource="#session.DSN#" name="ExisteCF">

				select CFcodigo from CFuncional
				where CFcodigo = '#codigo#'
				and Ecodigo = #session.Ecodigo#
			</cfquery>

			<cfif ExisteOfiTemp.recordcount GT 0>
				<cfquery name = "ERR" datasource = "#session.dsn#" >
				insert into #errores# (Error)
		     	 values ('Error. El codigo de la Oficina (#ExisteOfiTemp.CDRHHOficodigo#) que desea Cargar ya fue Registrado, el Error se genero en la  linea #currentrow#')
		     	</cfquery>

			<cfelseif ExisteDptoTemp.recordcount GT 0>
				<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
			     	 values ('Error. El codigo del Departemento (#ExisteDptoTemp.CDRHHDptoCodigo#) que desea Cargar ya fue Registrado, el Error se genero en la  linea #currentrow#')
			    </cfquery>
		    <cfelseif ExisteCFTemp.recordcount GT 0>
		    	<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
			     	 values ('Error. El codigo del Centro Funcional (#ExisteCFTemp.CDRHHCFcodigo#) que desea Cargar ya fue Registrado, el Error se genero en la  linea #currentrow#')
			    </cfquery>
			<cfelseif ExisteDepartamento.recordCount EQ 0>

				<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
			     	 values ('Error. El codigo del Departemento (#departamento#) no Existe en catalogo de Departamentos, el Error se genero en la  linea  #currentrow#')
			    </cfquery>
			<cfelseif ExistenOficina.recordCount EQ 0>
				<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
			     	 values ('Error. El codigo de la Oficina (#oficina#) no Existe en catalogo de Oficinas, el Error 
			     	 	#currentrow#')
			    </cfquery>
			<cfelseif ExistenCResponsable.recordCount EQ 0>

				<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
			     	 values ('Error. El codigo del Centro Funcional Padre (#responsable#) no Existe en el modulo de Centro Funcional, el Error se genero en la  linea 
			     	 	#currentrow#')
			    </cfquery>
			<cfelseif ExisteCF.CFcodigo GT 0 >
				<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
			     	 values ('Error. El codigo del Centro Funcional (#codigo#)  Existe en el modulo de Centro Funcional, no puede ingresar un codigo Existe el Error se genero en #currentrow#')
			    </cfquery>
			<cfelse>
				<cfquery datasource="#session.DSN#">
						insert into CDRHHCFuncional 
							(CDRHHCFcodigo,CDRHHCFdescripcion,CDRHHOficodigo,CDRHHDptoCodigo,CDRHHCFcodigoPadre,Ecodigo)			
							values 
							('#codigo#','#descripcion#','#oficina#','#departamento#','#responsable#', #session.Ecodigo#)
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



<!--- insert implementado por costa rica

<!---<cfquery datasource="#session.DSN#">
	insert into CDRHHCFuncional( CDRHHCFcodigo,CDRHHCFdescripcion,CDRHHOficodigo,CDRHHDptoCodigo,CDRHHCFcodigoPadre,Ecodigo )
	select codigo, descripcion, oficina, departamento, responsable, #session.Ecodigo#
	from #table_name#	
</cfquery> --->