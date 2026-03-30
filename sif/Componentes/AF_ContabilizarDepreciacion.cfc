<cfcomponent>
	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
		</cfif>
	</cffunction>
	
	<cffunction name="AplicarMascara" access="public" output="true" returntype="string">
		<cfargument name="cuenta"   type="string" required="true">
		<cfargument name="objgasto" type="string" required="true">

		<cfset vCuenta = arguments.cuenta >
		<cfset vObjgasto = arguments.objgasto >

		<cfif len(trim(vCuenta))>
			<cfloop condition="Find('?',vCuenta,0) neq 0">
				<cfif len(trim(vObjgasto))>
					<cfset caracter = mid(vObjgasto, 1, 1) >
					<cfset vObjgasto = mid(vObjgasto, 2, len(vObjgasto)) >
					<cfset vCuenta = replace(vCuenta,'?',caracter) >
				<cfelse>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn vCuenta >
	</cffunction>
	
	<cffunction name="AF_ContabilizarDepreciacion" access="public" returntype="boolean" output="true">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no"  	default="0">	<!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 			type="numeric" 	required="no"  	default="0">	<!--- Código de Usuario (asp) --->
		<cfargument name="Usuario" 				type="string" 	required="no"  	default="">		<!--- Login de Usuario (asp) --->
		<cfargument name="Conexion" 			type="string" 	required="no"	default="">		<!--- Conexion para consulta la BD --->
		<cfargument name="IPaplica" 			type="string" 	required="no"	default="">		<!--- IP de PC de Usuario --->
		<cfargument name="AGTPid" 				type="numeric" 	required="yes">
		<cfargument name="Programar" 			type="boolean" 	required="no"	default="false" ><!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" 	type="date" 	required="no"	default="#CreateDate(1900,01,01)#" >
		<cfargument name="Periodo" 				type="numeric" 	required="no"	default="0">	<!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 					type="numeric" 	required="no"	default="0">	<!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" 				type="boolean" 	required="no"	default="false"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="contabilizar" 		type="boolean" 	required="no"	default="true"><!--- si se apaga no contabiliza peroi si aplica la depreciación, por ahora solo se utiliza para las pruebas iniciales del sistema --->
		<cfargument name="descripcion" 			type="string" 	required="no"	default="Activo Fijo: Depreciación"><!--- Descripción de la transacción --->

		<!---Variables locales --->
		<cfset var lVarCuentaDep = ''>
		<cfset var lVarCuentaRev = ''>
		<cfset var lVarErrorCta = 0>
		<cfset var lVarCtasError = ''>

		<!---Valida Fecha de Programación Vrs Programar--->
		<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq -1)>
			<cfset Arguments.Programar = false>
		</cfif>
		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.Ecodigo eq 0>
			<cfset Arguments.Ecodigo 	= session.Ecodigo >
			<cfset Arguments.Conexion 	= session.dsn >
			<cfset Arguments.Usucodigo 	= session.Usucodigo >
			<cfset Arguments.Usuario 	= session.Usuario >
			<cfset Arguments.IPaplica 	= session.sitio.ip >
		</cfif>
		<!---Valida que el AGTPid corresponda a un Proceso Válido--->
		<cfquery name="rsAGTProceso" datasource="#Arguments.Conexion#">
			select count(1) as cuantos from AGTProceso
			where AGTPid = #Arguments.AGTPid#
			and AGTPestadp in (0,2)
		</cfquery>
		<cfif rsAGTProceso.cuantos is not 1>
			<cf_errorCode	code = "50911" msg = "El Grupo de Transacciones seleccionado es inválido!, Proceso Cancelado!">
		</cfif>
		<!---===Elimina los Activos que deprecian cero en los tres montos (adquisición, Mejora, Revaluación)===--->
		<cfquery datasource="#Arguments.Conexion#">
			delete from ADTProceso 
			  where AGTPid = #Arguments.AGTPid# 
			    and TAmontolocadq = 0
		   	    and TAmontolocmej = 0
		   	    and TAmontolocrev = 0
		</cfquery>
		<!---====Verifican si tienen lineas de detalle======--->
		<cfquery name="rsADTProceso" datasource="#Arguments.Conexion#">
			select count(1) as cuantos from ADTProceso
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfif rsADTProceso.cuantos EQ 0>
			<cfthrow message="La transacción no tienen líneas de detalle.">
		</cfif>
		<!--- Obtiene el Periodo y Mes de Auxiliares --->
		<cfif Arguments.Periodo neq 0>
			<cfset rsPeriodo.value = Arguments.Periodo>
		<cfelse>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.value"/>
		</cfif>
		<cfif Arguments.Mes neq 0>
			<cfset rsMes.value = Arguments.Mes>
		<cfelse>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux"     returnvariable="rsMes.value"/>
		</cfif>
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		
		<!--- Verifica el parametro que define si el asiento es detallado --->
		<cfquery name="rsAstDet" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#Arguments.Conexion#"> as value
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
				and Pcodigo = 930
				and Mcodigo = 'AF'
		</cfquery>
		
		<cfif rsAstDet.recordcount eq 0>
			<cfset asientodet = 0>			
		<cfelse>
			<cfset asientodet = rsAstDet.value>
		</cfif>
		
		<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
		<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
		<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
		<cfif Arguments.debug>
			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<h1>DEBUG</h1><br>
				<p>
				<strong>Periodo</strong> = #rsPeriodo.value#<br>
				<strong>Mes</strong> = #rsMes.value#<br>
				<strong>Moneda</strong> = #rsMoneda.value#<br>
				<strong>FechaAux</strong> = #rsFechaAux.value#<br>
				<strong>Fecha del Sistema</strong> = #Now()#<br>
				</p>
			</cfoutput>
			<cfdump var="#Arguments#" label="Arguments">
		</cfif>
		<!--- Obtiene el número de Documento --->
		<cfquery name="rsAGTProcesoDoc" datasource="#Arguments.Conexion#">
			select AGTPdocumento 
			from AGTProceso 
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfif rsAGTProcesoDoc.recordcount eq 0 or (rsAGTProcesoDoc.recordcount and len(trim(rsAGTProcesoDoc.AGTPdocumento)) eq 0) or rsAGTProcesoDoc.AGTPdocumento eq 0>
			<cf_errorCode	code = "50912" msg = "Error obteniendo el Documento, No se pudo obtener el documento de la transacción de depreciación, Proceso Cancelado!">
		</cfif>
		
		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>

		<cfquery name="rsValidaMontos" datasource="#Arguments.Conexion#" maxrows="10">		
			select 
				a.Aplaca, 
				a.Adescripcion
			from AGTProceso e
				inner join ADTProceso d
				on d.AGTPid = e.AGTPid
				
				inner join Activos a
				on a.Aid = d.Aid

				inner join AFSaldos s
				on  s.Aid = d.Aid
				and s.AFSperiodo = e.AGTPperiodo 
				and s.AFSmes     = e.AGTPmes

			where e.AGTPid = #Arguments.AGTPid#
			and e.IDtrans = 4
			and 
			( 
				<!---Cuando el valor es Positivo y el monto a depreciar es Negativo: El Valor Obsoluto del monto a depreciar no puede superar la depreciacion Acumulada--->  
                 (TAvaladq  > 0 and d.TAmontolocadq < 0 and ABS(d.TAmontolocadq) >  d.TAdepacumadq)  or
                 (TAvalmej  > 0 and d.TAmontolocmej < 0 and ABS(d.TAmontolocmej) >  d.TAdepacummej)  or
                 (TAvalrev  > 0 and d.TAmontolocrev < 0 and ABS(d.TAmontolocrev) >  d.TAdepacumrev)  or
				<!---Cuando el valor es Positivo y el monto a depreciar es Positivo: El valor de la depreciacion no puede superar el Valor en Libros--->
				 (TAvaladq  > 0 and d.TAmontolocadq > 0 and d.TAmontolocadq > (d.TAvaladq - d.TAdepacumadq - d.TAvalrescate))or
				 (TAvalmej  > 0 and d.TAmontolocmej > 0 and d.TAmontolocmej > (d.TAvalmej - d.TAdepacummej)) or
				 (TAvalrev  > 0 and d.TAmontolocrev > 0 and d.TAmontolocrev > (d.TAvalrev - d.TAdepacumrev)) or
				 <!---Cuando el valor es Negativo: el Monto a depreciar no puede ser Mejor que el Valor en Libros--->
				 (TAvaladq  < 0 and d.TAmontolocadq < (d.TAvaladq - d.TAdepacumadq - d.TAvalrescate))or
				 (TAvalmej  < 0 and d.TAmontolocmej < (d.TAvalmej - d.TAdepacummej))<!---or
				 (TAvalrev  < 0 and d.TAmontolocrev < (d.TAvalrev - d.TAdepacumrev)) 
				 CUANDO EL ACTIVO TIENEN REV. Y DEP ACUM REV NEGATIVA, AL RESTAR DA POSITIVO Y ES MAYOR A LA DEP.MENSUAL QUE ES NEGATIVA, POR ESO SE COMENTA--->
			)
		</cfquery>
				<cfset Placas = "">
        <cfloop query="rsValidaMontos">
        		<cfset Placas = Placas & rsValidaMontos.Aplaca>
            <cfif rsValidaMontos.RecordCount NEQ rsValidaMontos.CurrentRow>
            	<cfset Placas = Placas & ",">
            </cfif>
        </cfloop>
		<cfif LEN(TRIM(Placas))>
			<cfthrow message="Los Siguiente Activos tienen datos Incorrectos:#Placas#">
		</cfif>

		<!--- Si programar --->
		<cfif (Arguments.Programar)>
			<cfquery name="rsActualizaProceso" datasource="#Arguments.Conexion#">
				Update AGTProceso 
				set AGTPestadp = 2,
					AGTPfechaprog = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaProgramacion#" null="#DateCompare(Arguments.FechaProgramacion, Now()) eq -1#">,
					AGTPipaplica = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IPaplica#">
				where AGTPid = #Arguments.AGTPid#
			</cfquery>
		<cfelse>		 
			<!--- Actualizar las cuentas en nulo para que sirvan de control --->
			<cfquery datasource="#Arguments.Conexion#">
				update ADTProceso
				set Ccuenta = -1, Ccuentarev = -1
				where AGTPid = #Arguments.AGTPid#				
			</cfquery>
			
			<cfquery name="rsParamGD" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				and Pcodigo = '1360'
			</cfquery>

			<cfif rsParamGD.Pvalor EQ 1>
				<!--- ANGELES si el parametro esta activo--->
				<cfquery name="rsTADTProceso" datasource="#Arguments.Conexion#">
					select distinct 
						p.CFid, cf.CFcodigo, 
						coalesce(c.ACfgastodepreciacion, '') as FormatoCta, 
						ACgastodep, ACgastorev, 
						c.ACcodigo, c.ACid, 
						c.ACcodigodesc as Clase, ct.ACcodigodesc as Categoria, 
						cf.Ocodigo, cf.CFComplementoCtaGastoCS, c.ACdescripcion
					from ADTProceso p
						inner join Activos a
							inner join AClasificacion c
								 on c.ACcodigo	= a.ACcodigo
								and c.ACid		= a.ACid
								and c.Ecodigo	= a.Ecodigo
							inner join ACategoria ct
								 on ct.Ecodigo	= a.Ecodigo
								and ct.ACcodigo	= a.ACcodigo
							 on a.Aid     = p.Aid
							and a.Ecodigo = p.Ecodigo
						inner join CFuncional cf
							 on cf.CFid = p.CFid
					where p.AGTPid = #Arguments.AGTPid#			
				</cfquery>	
				
				<cfquery name="ValidaComple" dbtype="query">
					select distinct FormatoCta, ACid, CFcodigo, CFComplementoCtaGastoCS, ACdescripcion
					from rsTADTProceso
				</cfquery>					
				
				<cfloop query="ValidaComple">
					<cfif ValidaComple.FormatoCta EQ ''>
						<cfthrow message="Debe definir la cuenta de Gastos por Depreciación en la Clasificación del Activo Fijo: #ValidaComple.ACdescripcion#">
					</cfif>
				
					<cfif ValidaComple.CFComplementoCtaGastoCS EQ ''>
						<cfthrow message="No se ha definido el complemento contable del Centro Funcional #ValidaComple.CFcodigo#">
					</cfif>
				</cfloop>
			<cfelse>
				<cfquery name="rsTADTProceso" datasource="#Arguments.Conexion#">
					select distinct 
						p.CFid, cf.CFcodigo, 
						coalesce(cf.CFcuentaaf, cf.CFcuentac) as FormatoCta, 
						ACgastodep, ACgastorev, 
						c.ACcodigo, c.ACid, 
						c.ACcodigodesc as Clase, ct.ACcodigodesc as Categoria, 
						cf.Ocodigo
					from ADTProceso p
						inner join Activos a
							inner join AClasificacion c
								 on c.ACcodigo	= a.ACcodigo
								and c.ACid		= a.ACid
								and c.Ecodigo	= a.Ecodigo
							inner join ACategoria ct
								 on ct.Ecodigo	= a.Ecodigo
								and ct.ACcodigo	= a.ACcodigo
							 on a.Aid     = p.Aid
							and a.Ecodigo = p.Ecodigo
						inner join CFuncional cf
							 on cf.CFid = p.CFid
					where p.AGTPid = #Arguments.AGTPid#
				</cfquery>
			</cfif>

			<!--- Procesar los distintos codigos de categoria --->
			<cfquery name="rsADTProceso" dbtype="query">
				select distinct CFid, CFcodigo, FormatoCta, ACgastodep, ACgastorev, 
				<cfif rsParamGD.Pvalor EQ 1>
					CFComplementoCtaGastoCS,
				</cfif>
				Ocodigo
				from rsTADTProceso
			</cfquery>
			
			<cfloop query="rsADTProceso">
				<cfset lVarCFid			= #rsADTProceso.CFid#>
				<cfset lVarCFcodigo		= #rsADTProceso.CFcodigo#>
				<cfset lVarACgastodep	= #rsADTProceso.ACgastodep#>
				<cfset lVarACgastorev	= #rsADTProceso.ACgastorev#>
				<cfif rsParamGD.Pvalor EQ 0>			
					<cfset lVarCuentaDep	= AplicarMascara(rsADTProceso.FormatoCta,rsADTProceso.ACgastodep)>
					<cfset lVarCuentaRev	= AplicarMascara(rsADTProceso.FormatoCta,rsADTProceso.ACgastorev)>
				<cfelse>
					<cfset lVarCuentaDep	= AplicarMascara(rsADTProceso.FormatoCta,rsADTProceso.CFComplementoCtaGastoCS)>
					<cfset lVarCuentaRev	= AplicarMascara(rsADTProceso.FormatoCta,rsADTProceso.CFComplementoCtaGastoCS)>
				</cfif>
				<cfset lVarOcodigo		= #rsADTProceso.Ocodigo#>

				<cftransaction>

				<cfinvoke component="PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
					<cfinvokeargument name="Lprm_Cmayor" 			value="#Left(lVarCuentaDep,4)#"/>							
					<cfinvokeargument name="Lprm_Cdetalle" 			value="#mid(lVarCuentaDep,6,100)#"/>
					<cfinvokeargument name="Lprm_Ocodigo" 			value="#lVarOcodigo#"/>
					<cfinvokeargument name="Lprm_TransaccionActiva"	value="true"/>
					<cfinvokeargument name="Lprm_DSN" 				value="#Arguments.Conexion#"/>
					<cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
				</cfinvoke>
				</cftransaction>

				<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
					<cfquery name="rsClaseCategoria" dbtype="query">
						select distinct Categoria, Clase, ACcodigo, ACid
						from rsTADTProceso
						where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lVarCFid#">
						<cfif len(trim(lVarACgastodep)) eq 0>
						  and ACgastodep is null 
						<cfelse>
						  and ACgastodep = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarACgastodep#">
						</cfif>
					</cfquery>
					<cfloop query="rsClaseCategoria">
						<cfset lVarCtasError = lVarCtasError & "<li>Cuenta Centro Funcional: " & #lVarCFcodigo# & ' Cat/Clase ' & #rsClaseCategoria.Categoria# & '-' & #rsClaseCategoria.Clase# & ' Cuenta:' & lVarCuentaDep & " no es correcta: " & LvarError & "</li>">
						<cfquery name="rsPlacas" datasource="#Arguments.Conexion#">
							select distinct a.Aplaca
							from ADTProceso p
								inner join Activos a
									 on a.Aid		= p.Aid
									and a.Ecodigo	= p.Ecodigo
									and a.ACcodigo	= #rsClaseCategoria.ACcodigo#
									and a.ACcodigo	= #rsClaseCategoria.ACid#
							where p.AGTPid = #Arguments.AGTPid#
						</cfquery>
						<cfset lVarCtasError = lVarCtasError & "<li>&nbsp;&nbsp;&nbsp;Placas: " & valueList(rsPlacas.Aplaca) & "</li>">
					</cfloop>
					<cfset lVarErrorCta = 1>
				<cfelseif LvarCuentaDep neq LvarCuentaRev>
					<cftransaction>
					<cfinvoke component="PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
						<cfinvokeargument name="Lprm_Cmayor" 			value="#Left(lVarCuentaRev,4)#"/>							
						<cfinvokeargument name="Lprm_Cdetalle" 			value="#mid(lVarCuentaRev,6,100)#"/>
						<cfinvokeargument name="Lprm_Ocodigo" 			value="#lVarOcodigo#"/>
						<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
						<cfinvokeargument name="Lprm_DSN" 				value="#Arguments.Conexion#"/>
						<cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
					</cfinvoke>		
					</cftransaction>

					<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
						<cfquery name="rsClaseCategoria" dbtype="query">
							select distinct Categoria, Clase, ACcodigo, ACid
							from rsTADTProceso
							where CFid = #lVarCFid#
							<cfif len(trim(lVarACgastorev)) eq 0>
							  and ACgastorev is null 
							<cfelse>
							  and ACgastorev = '#lVarACgastorev#'
							</cfif>
						</cfquery>
						<cfloop query="rsClaseCategoria">
							<cfset lVarCtasError = lVarCtasError & "<li>Cuenta Centro Funcional: " & #lVarCFcodigo# & ' Cat/Clase: ' & #rsClaseCategoria.Categoria# & '-' & #rsClaseCategoria.Clase# & ' Cuenta:' & lVarCuentaRev & " no es correcta: " & LvarError & "</li>">
							<cfquery name="rsPlacas" datasource="#Arguments.Conexion#">
								select distinct a.Aplaca
								from ADTProceso p
									inner join Activos a
										 on a.Aid		= p.Aid
										and a.Ecodigo	= p.Ecodigo
										and a.ACcodigo	= #rsClaseCategoria.ACcodigo#
										and a.ACcodigo	= #rsClaseCategoria.ACid#
								where p.AGTPid = #Arguments.AGTPid#
							</cfquery>
							<cfset lVarCtasError = lVarCtasError & "<li>&nbsp;&nbsp;&nbsp;Placas: " & valueList(rsPlacas.Aplaca) & "</li>">
						</cfloop>
						<cfset lVarErrorCta = 1>
					</cfif>
				</cfif>

				<cfif lVarErrorCta EQ 0>
					<cfquery datasource="#Arguments.Conexion#">
						Update ADTProceso
							set Ccuenta = 
								coalesce((select Ccuenta 
									from CFinanciera 
									where Ecodigo = #Arguments.Ecodigo#
									  and CFformato = <cfqueryparam value="#lVarCuentaDep#" cfsqltype="cf_sql_varchar">),-1),
									Ccuentarev = 
								coalesce((select Ccuenta 
									from CFinanciera 
									where Ecodigo = #Arguments.Ecodigo#
									  and CFformato = <cfqueryparam value="#lVarCuentaRev#" cfsqltype="cf_sql_varchar">),-1)	
						where ADTProceso.AGTPid = #Arguments.AGTPid#
							and ADTProceso.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lVarCFid#">
							and exists(select 1 
									from Activos a, AClasificacion c 
									where a.Aid = ADTProceso.Aid
									  and c.ACcodigo = a.ACcodigo
									  and c.ACid     = a.ACid
									  and c.Ecodigo  = a.Ecodigo
									  and c.ACgastodep = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarACgastodep#">
									  and c.ACgastorev = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarACgastorev#">)
					</cfquery>
				</cfif>
			</cfloop>
			
			<cfif Lvarerrorcta eq 1>
				<p><h3>Error A! Existen Cuentas inválidas! Proceso Cancelado!</h3></p>
				<cfoutput>
				<ul>
				#Replace(lVarCtasError,'<br>','</li><li>','all')#
				</ul>
				</cfoutput>
				<cf_abort errorInterfaz="">
			</cfif>
			
			<!--- Validaciones Previas al Posteo --->
			<cfquery name="rsCount" datasource="#Arguments.Conexion#">
				select count(1) as cont 
				from ADTProceso 
				where AGTPid = #Arguments.AGTPid#
				and Ccuenta < 1
			</cfquery>
			
			<cfif rsCount.cont GT 0>
				<p><h3>Error B! No se pudo crear la cuenta para los siguientes Centros Funcionales / Categorías / Clases! Proceso Cancelado!</h3></p>
				<cfquery name="rsCount" datasource="#Arguments.Conexion#">
					select distinct p.CFid, cf.CFcodigo, coalesce(cf.CFcuentaaf, cf.CFcuentac) as FormatoCta, 
					c.ACcodigo, c.ACid, ACgastodep, ACgastorev, c.ACcodigodesc as Clase, ct.ACcodigodesc as Categoria
					from ADTProceso p
						inner join Activos a
							 on a.Aid     = p.Aid
							and a.Ecodigo = p.Ecodigo
						inner join AClasificacion c
							 on c.ACcodigo = a.ACcodigo
							and c.ACid     = a.ACid
							and c.Ecodigo  = a.Ecodigo
							inner join ACategoria ct
							   on ct.Ecodigo = c.Ecodigo
								 and ct.ACcodigo = c.ACcodigo
						inner join CFuncional cf
							 on cf.CFid = p.CFid
					where p.AGTPid = #Arguments.AGTPid#
					and Ccuenta < 1
				</cfquery>
				<cfoutput query="rsCount">
					<ul>
					<li>Centro Funcional #CFcodigo#, Categoria #Categoria#, Clase #Clase#.</li><br>
					</ul>
				</cfoutput>
				<cf_abort errorInterfaz="">
			</cfif>
			
			<!---Inicio Aplicación de la Depreciación--->
			<cfif Arguments.contabilizar is true>
				<!--- Crea tabla temportal TAG para crear tablas temporales, devuelve un string con el nombre de la tabla creada en la variable "temp_table"--->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
						<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
				</cfinvoke>
                
               <cf_dbtemp name="dbMAM" returnvariable="dbMAM_NAME" datasource="#Arguments.Conexion#">
                    <cf_dbtempcol name="Aid"		    	type="numeric"	mandatory="yes">
                    <cf_dbtempcol name="Mcodigo"		    type="numeric"	mandatory="yes">
                    <cf_dbtempcol name="ADQ_ORI"            type="money" 	mandatory="yes">
			     	<cf_dbtempcol name="ADQ_LOC" 			type="money" 	mandatory="yes">
				    <cf_dbtempcol name="MEJ_ORI"			type="money" 	mandatory="yes">
				    <cf_dbtempcol name="MEJ_LOC"			type="money" 	mandatory="yes">                    
                    <cf_dbtempkey cols="Aid,Mcodigo">
                </cf_dbtemp>
                
                <cf_dbtemp name="dbMAT" returnvariable="dbMAT_NAME" datasource="#Arguments.Conexion#">
                    <cf_dbtempcol name="Aid"		    	type="numeric"	mandatory="yes">                    
			     	<cf_dbtempcol name="ADQ_LOC" 			type="money" 	mandatory="yes">
				    <cf_dbtempcol name="MEJ_LOC"			type="money" 	mandatory="yes">                    
                    <cf_dbtempkey cols="Aid">
                </cf_dbtemp>
				
                <cfquery name="rsInsertaMAM" datasource="#Session.dsn#">
				 insert into #dbMAM_NAME#(
                 Aid,
                 Mcodigo,
                 ADQ_ORI,
	             ADQ_LOC,
				 MEJ_ORI,
				 MEJ_LOC 
                 )
                 select t.Aid, t.Mcodigo,
                    sum(coalesce(t.TAmontooriadq,0)) as ADQ_ORI, 
                    sum(coalesce(t.TAmontolocadq,0)) as ADQ_LOC, 
                    sum(coalesce(t.TAmontoorimej,0)) as MEJ_ORI,
                    sum(coalesce(t.TAmontolocmej,0)) as MEJ_LOC               
                 from ADTProceso a
                    inner join TransaccionesActivos t
                         on t.Ecodigo = a.Ecodigo
                        and t.Aid = a.Aid
                        and t.IDtrans in (1,2,3)
                where a.AGTPid = #Arguments.AGTPid# 
                and round(a.TAmontolocadq + a.TAmontolocmej, 2) <> 0.00 
                group by t.Aid, t.Mcodigo
                </cfquery>
                
                <cfquery name="rsInsertaMAT" datasource="#Session.dsn#">
                 insert into #dbMAT_NAME#(
                 Aid,                
	             ADQ_LOC,
				 MEJ_LOC 
                 )
                 select t.Aid,
                    sum(coalesce(t.TAmontolocadq,0)) as ADQ_LOC, 
                    sum(coalesce(t.TAmontolocmej,0)) as MEJ_LOC               
                 from ADTProceso a
                    inner join TransaccionesActivos t
                         on t.Ecodigo = a.Ecodigo
                        and t.Aid = a.Aid
                        and t.IDtrans in (1,2,3)
                where a.AGTPid = #Arguments.AGTPid# 
                and round(a.TAmontolocadq + a.TAmontolocmej, 2) <> 0.00 
                group by t.Aid
                </cfquery>
                 
				<!--- ****************** C O N T A B I L I Z A C I O N ****************** --->
				<!--- Débito al Gasto por Depreciación de la Adquisicion --->	
					<cf_dbfunction name="string_part"   args="d.CFdescripcion,1,38" returnvariable="CFdescripcion" >
					<cf_dbfunction name="string_part"   args="b.Adescripcion,1,38"  returnvariable="Adescripcion" >
					<cf_dbfunction name="concat" 		args="'Gasto Deprec: '+ rtrim(d.CFcodigo)+'-'+rtrim(#PreserveSingleQuotes(CFdescripcion)#)"   				returnvariable="INTDES01" delimiters="+">			
					<cf_dbfunction name="concat" 		args="'Gasto Deprec: '+ rtrim(b.Aplaca)  +'-'+rtrim(#PreserveSingleQuotes(Adescripcion)#)"   				returnvariable="INTDES02" delimiters="+">			
					<cf_dbfunction name="concat" 		args="'Gasto Deprec. Revaluación: '+ rtrim(d.CFcodigo)+'-'+rtrim(#PreserveSingleQuotes(CFdescripcion)#)"   	returnvariable="INTDES03" delimiters="+">			
					<cf_dbfunction name="concat" 		args="'Gasto Deprec. Revaluación: '+ rtrim(b.Aplaca)  +'-'+rtrim(#PreserveSingleQuotes(Adescripcion)#)"   	returnvariable="INTDES04" delimiters="+">			
					<cf_dbfunction name="concat" 		args="'Depreciación Adquisición: '+ rtrim(d.CFcodigo)+'-'+rtrim(#PreserveSingleQuotes(CFdescripcion)#)"   	returnvariable="INTDES05" delimiters="+">			
					<cf_dbfunction name="concat" 		args="'Depreciación Adquisición: '+ rtrim(b.Aplaca)  +'-'+rtrim(#PreserveSingleQuotes(Adescripcion)#)"   	returnvariable="INTDES06" delimiters="+">			
					<cf_dbfunction name="concat" 		args="'Depreciación Revaluacion: '+ rtrim(d.CFcodigo)+'-'+rtrim(#PreserveSingleQuotes(CFdescripcion)#)"   	returnvariable="INTDES07" delimiters="+">			
					<cf_dbfunction name="concat" 		args="'Depreciación Revaluacion: '+ rtrim(b.Aplaca)  +'-'+rtrim(#PreserveSingleQuotes(Adescripcion)#)"   	returnvariable="INTDES08" delimiters="+">			
				<cfquery name="rstemp" datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, CFid,
                    						Mcodigo, INTMOE, INTCAM, INTMON)
					select 
							'AFDP',
							1,
							<cfif asientodet neq 1>
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">,
							<cfelse>
								b.Aplaca,
							</cfif>
							d.CFcodigo,
							'D',
							<cfif asientodet neq 1>
								#PreserveSingleQuotes(INTDES01)#,
							<cfelse>
								#PreserveSingleQuotes(INTDES02)#,
							</cfif>
								'#DateFormat(now(),'YYYYMMDD')#',
							#rsPeriodo.value#, 
							#rsMes.value#,
							a.Ccuenta,
							d.Ocodigo,
                            a.CFid,                            
							m.Mcodigo,
							<!--- Moneda Origen: Proporcion por moneda MontoLocalDep / TipoCambio, Tipo Cambio = Local/Origen --->
							<cfif asientodet neq 1>
								sum(round(case when m.ADQ_LOC=0 then 0 else a.TAmontolocadq * m.ADQ_LOC/mm.ADQ_LOC * m.ADQ_ORI/m.ADQ_LOC end + case when m.MEJ_LOC=0 then 0 else a.TAmontolocmej*m.MEJ_LOC/mm.MEJ_LOC*m.MEJ_ORI/m.MEJ_LOC end,2)),
							<cfelse>
								round(case when m.ADQ_LOC=0 then 0 else a.TAmontolocadq * m.ADQ_LOC/mm.ADQ_LOC * m.ADQ_ORI/m.ADQ_LOC end + case when m.MEJ_LOC=0 then 0 else a.TAmontolocmej*m.MEJ_LOC/mm.MEJ_LOC*m.MEJ_ORI/m.MEJ_LOC end,2),
							</cfif>
							-1.0,
							<!--- Moneda Local: MontoLocalDep * TotalOri/TotalLocal --->
							<cfif asientodet neq 1>
            				sum(round(case when mm.ADQ_LOC = 0 then 0 else a.TAmontolocadq * m.ADQ_LOC/mm.ADQ_LOC end + case 
							when mm.MEJ_LOC=0 then 0 else a.TAmontolocmej * m.MEJ_LOC/mm.MEJ_LOC end, 2))
							<cfelse>
								sum(round(case when mm.ADQ_LOC = 0 then 0 else  a.TAmontolocadq * m.ADQ_LOC/mm.ADQ_LOC 
end + case when mm.MEJ_LOC=0 then 0 else a.TAmontolocmej * m.MEJ_LOC/mm.MEJ_LOC end,2))
							</cfif>                      
					from ADTProceso a
						inner join Activos b
							on b.Aid = a.Aid
						inner join CFuncional d
							on d.CFid = a.CFid
						inner join AGTProceso g
							on g.AGTPid = a.AGTPid
                        inner join #dbMAM_NAME# m
                            on m.Aid = a.Aid
                        inner join #dbMAT_NAME# mm
                            on mm.Aid = a.Aid
					where a.AGTPid = #Arguments.AGTPid#
					  and round(a.TAmontolocadq + a.TAmontolocmej, 2) <> 0.00
					<cfif asientodet neq 1>
						group by g.AGTPdocumento, a.Ccuenta, d.Ocodigo, d.CFcodigo, d.CFdescripcion, a.CFid, m.Mcodigo
					</cfif>
				</cfquery>
                              
				<!--- Débito al Gasto por Depreciación de la Revaluación --->
				<cfquery name="rstemp" datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFDP',
							1,
							<cfif asientodet neq 1>
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">,
							<cfelse>
								b.Aplaca,
							</cfif>
							d.CFcodigo,
							<cfif asientodet neq 1>
								sum(round(a.TAmontolocrev, 2)),
							<cfelse>
								round(a.TAmontolocrev, 2),
							</cfif>	
							'D',
							<cfif asientodet neq 1>
								#PreserveSingleQuotes(INTDES03)#,
							<cfelse>
								#PreserveSingleQuotes(INTDES04)#,
							</cfif>	
								'#DateFormat(now(),'YYYYMMDD')#',
							1.00,
							#rsPeriodo.value#, 
							#rsMes.value#,
							a.Ccuentarev,
							#rsMoneda.value#,
							d.Ocodigo,
							<cfif asientodet neq 1>
								sum(round(a.TAmontolocrev,2))
							<cfelse>
								round(a.TAmontolocrev,2)
							</cfif>,
                            a.CFid
					from ADTProceso a
						inner join Activos b
							on b.Aid = a.Aid
						inner join CFuncional d
							on d.CFid = a.CFid
						inner join AGTProceso g
							on g.AGTPid = a.AGTPid
					where a.AGTPid = #Arguments.AGTPid#
					  and a.TAmontolocrev <> 0.00
					<cfif asientodet neq 1>
						group by g.AGTPdocumento, a.Ccuentarev, d.Ocodigo, d.CFcodigo, d.CFdescripcion, a.CFid
					</cfif>
				</cfquery>        
                                

				<!--- ****************** C R E D I T O S ****************** --->
				<!--- Crédito a la Depreciación Acumulada de la Adquisicion --->
				<cfquery name="rstemp" datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, CFid,
											Mcodigo, INTMOE, INTCAM, INTMON)
					select 
							'AFDP',
							1,
							<cfif asientodet neq 1>
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">,
							<cfelse>
								b.Aplaca,
							</cfif>
							d.CFcodigo,
							'C',
							<cfif asientodet neq 1>
								#PreserveSingleQuotes(INTDES05)#,
							<cfelse>
								#PreserveSingleQuotes(INTDES06)#,
							</cfif>								
							   '#DateFormat(now(),'YYYYMMDD')#',
							#rsPeriodo.value#, 
							#rsMes.value#,
							c.ACcdepacum,
							d.Ocodigo,
                            a.CFid,
							m.Mcodigo,
							<!--- Moneda Origen: Proporcion por moneda MontoLocalDep / TipoCambio, Tipo Cambio = Local/Origen --->
							<cfif asientodet neq 1>
								sum(round(case when m.ADQ_LOC=0 then 0 else a.TAmontolocadq * m.ADQ_LOC/mm.ADQ_LOC * m.ADQ_ORI/m.ADQ_LOC end + case when m.MEJ_LOC=0 then 0 else a.TAmontolocmej*m.MEJ_LOC/mm.MEJ_LOC*m.MEJ_ORI/m.MEJ_LOC end,2)),
							<cfelse>
								round(case when m.ADQ_LOC=0 then 0 else a.TAmontolocadq * m.ADQ_LOC/mm.ADQ_LOC * m.ADQ_ORI/m.ADQ_LOC end + case when m.MEJ_LOC=0 then 0 else a.TAmontolocmej*m.MEJ_LOC/mm.MEJ_LOC*m.MEJ_ORI/m.MEJ_LOC end,2),
							</cfif>
							-1.0,
							<!--- Moneda Local: MontoLocalDep * TotalOri/TotalLocal --->
							<cfif asientodet neq 1>
								sum(round(case when mm.ADQ_LOC = 0 then 0 else a.TAmontolocadq * m.ADQ_LOC/mm.ADQ_LOC end + case 
when mm.MEJ_LOC=0 then 0 else a.TAmontolocmej * m.MEJ_LOC/mm.MEJ_LOC end, 2))
							<cfelse>
								round(a.TAmontolocadq * m.ADQ_LOC/mm.ADQ_LOC + case when mm.MEJ_LOC=0 then 0 else a.TAmontolocmej * m.MEJ_LOC/mm.MEJ_LOC end, 2)
							</cfif>                      
                     from ADTProceso a
                        inner join Activos b 
                            on b.Ecodigo = a.Ecodigo 
                            and b.Aid = a.Aid
                         inner join AClasificacion c
                             on c.Ecodigo = b.Ecodigo 
                            and c.ACid = b.ACid 
                            and c.ACcodigo = b.ACcodigo
                         inner join CFuncional d
                             on d.CFid = a.CFid
                         inner join AGTProceso g 
                            on g.AGTPid = a.AGTPid
                        inner join #dbMAM_NAME# m
                            on m.Aid = a.Aid
                        inner join #dbMAT_NAME# mm
                            on mm.Aid = a.Aid
                    where a.AGTPid = #Arguments.AGTPid# 
                    and round(a.TAmontolocadq + a.TAmontolocmej, 2) <> 0.00 
                      
                      
                      
					<cfif asientodet neq 1>
						group by g.AGTPdocumento, c.ACcdepacum, d.Ocodigo, d.CFcodigo, d.CFdescripcion, a.CFid, m.Mcodigo
					</cfif>
				</cfquery>
				
                <!--- Crédito a la Depreciación Acumulada de la Revaluación --->
				<cfquery name="rstemp" datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFDP',
							1,
							<cfif asientodet neq 1>
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">,
							<cfelse>
								b.Aplaca,
							</cfif>
							d.CFcodigo,
							<cfif asientodet neq 1>
								sum(round(a.TAmontolocrev,2)),
							<cfelse>
								round(a.TAmontolocrev,2),
							</cfif>
							'C',
							<cfif asientodet neq 1>
								#PreserveSingleQuotes(INTDES07)#,
							<cfelse>
								#PreserveSingleQuotes(INTDES08)#,
							</cfif>
								'#DateFormat(now(),'YYYYMMDD')#',
							1,
							#rsPeriodo.value#, 
							#rsMes.value#,
							c.ACcdepacumrev,
							#rsMoneda.value#,
							d.Ocodigo,
							<cfif asientodet neq 1>
								sum(round(a.TAmontolocrev,2))
							<cfelse>
								round(a.TAmontolocrev,2)
							</cfif>,
                            a.CFid
					from ADTProceso a
						inner join Activos b
							on b.Ecodigo = a.Ecodigo
							and b.Aid = a.Aid
						inner join AClasificacion c
							on c.Ecodigo = b.Ecodigo
							and c.ACid = b.ACid
							and c.ACcodigo = b.ACcodigo
						inner join CFuncional d
							on d.CFid = a.CFid
						inner join AGTProceso g
							on g.AGTPid = a.AGTPid
					where a.AGTPid = #Arguments.AGTPid#
					  and round(a.TAmontolocrev, 2) <> 0.00
					<cfif asientodet neq 1>
						group by g.AGTPdocumento, c.ACcdepacumrev, d.Ocodigo, d.CFcodigo, d.CFdescripcion, a.CFid
					</cfif>	
				</cfquery>
                
				<cfquery name="rstemp" datasource="#Arguments.Conexion#">
					update #intarc#
					   set INTCAM = INTMON / INTMOE where INTCAM = -1.0
				</cfquery>

				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="BalanceoMonedaOficina" 
                			returnvariable="res_GeneraAsiento"
                            Ecodigo="#Arguments.Ecodigo#"
                            conexion="#Arguments.Conexion#">


				

				<!---==Obtiene la minima oficina del Asiento, si no tienen entonces la minina Oficina para la empresa==---> 
				<!---==============La oficina se le manda al genera asiento para que agrupe)===========================--->
				<cfquery name="rsMinOficinaINTARC" datasource="#session.dsn#">
					Select Min(Ocodigo) as MinOcodigo
						from #INTARC#
				</cfquery>
				<cfquery name="rsMinOficina" datasource="#session.dsn#">
					Select Min(Ocodigo) as MinOcodigo
						from Oficinas
						where Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				<cfif isdefined("rsMinOficinaINTARC") and rsMinOficinaINTARC.recordcount GT 0>
					<cfset LvarOcodigo = rsMinOficinaINTARC.MinOcodigo>
				<cfelseif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
					<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
				<cfelse>
					<cfset LvarOcodigo = -100>
				</cfif>								
			</cfif>					

			<cftransaction>

				<!---Inserta en TransaccionesActivos--->
				<cfquery name="rsTransaccionesActivos" datasource="#Arguments.Conexion#">
					insert into TransaccionesActivos(
						Ecodigo,
						Aid,
						IDtrans,
						CFid,
						TAperiodo,
						TAmes,
						TAfecha,
						TAfalta,
						TAmontooriadq,
						TAmontolocadq,
						TAmontoorimej,
						TAmontolocmej,
						TAmontoorirev,
						TAmontolocrev,
						
						TAmontodepadq,
						TAmontodepmej,
						TAmontodeprev,

						TAvaladq,
						TAvalmej,
						TAvalrev,
						
						TAdepacumadq,
						TAdepacummej,
						TAdepacumrev,
							
						Mcodigo,
						TAtipocambio,
						Ccuenta,
						AGTPid,
						Usucodigo,
						TAfechainidep,
						TAvalrescate,
						TAvutil,
						TAsuperavit,
						TAfechainirev,
						TAmeses
					)
					select 
						a.Ecodigo,
						a.Aid,
						a.IDtrans,
						a.CFid,
						a.TAperiodo,
						a.TAmes,
						a.TAfecha,
						a.TAfalta,
						a.TAmontolocadq,
						a.TAmontolocadq,
						a.TAmontolocmej,
						a.TAmontolocmej,
						a.TAmontolocrev,
						a.TAmontolocrev,
						
						a.TAmontodepadq,
						a.TAmontodepmej,
						a.TAmontodeprev,

						a.TAvaladq,
						a.TAvalmej,
						a.TAvalrev,
						
						a.TAdepacumadq,
						a.TAdepacummej,
						a.TAdepacumrev,
						
						#rsMoneda.value#,
						1.00,
						a.Ccuenta,
						a.AGTPid,
						#Arguments.Usucodigo#,
						b.Afechainidep,
						b.Avalrescate,
						a.TAvutil,
						0.00,
						b.Afechainirev,
						a.TAmeses				
					from ADTProceso a
						inner join Activos b 
							on b.Aid = a.Aid
					where a.AGTPid = #Arguments.AGTPid#
				</cfquery>
	
				<!--- Actualiza AFSaldos --->
				<cfquery name="PorActualizar" datasource="#Arguments.Conexion#">
					select p.TAmeses,p.TAmontolocadq,p.TAmontolocmej,p.TAmontolocrev,c.ACmetododep,p.Aid,p.TAperiodo,p.TAmes
						from ADTProceso p
						inner join Activos a
							inner join ACategoria c
							on c.ACcodigo = a.ACcodigo
							and c.Ecodigo = a.Ecodigo
						on a.Aid = p.Aid
					where p.AGTPid = #Arguments.AGTPid#

				</cfquery>
				<cfloop query="PorActualizar">
				<cfquery name="rsAFSaldos" datasource="#Arguments.Conexion#">
								Update AFSaldos
									set 
									AFSsaldovutiladq  = case when AFSsaldovutiladq > #PorActualizar.TAmeses# then AFSsaldovutiladq - #PorActualizar.TAmeses# else 0 end,
									AFSsaldovutilrev = case when AFSsaldovutilrev > #PorActualizar.TAmeses#  then AFSsaldovutilrev- #PorActualizar.TAmeses# else 0 end,
									AFSdepacumadq = AFSdepacumadq + #PorActualizar.TAmontolocadq#,
									AFSdepacummej = AFSdepacummej + #PorActualizar.TAmontolocmej#,
									AFSdepacumrev = AFSdepacumrev + #PorActualizar.TAmontolocrev#,
									AFSmetododep = #PorActualizar.ACmetododep#
							
								where Aid        = #PorActualizar.Aid#
								  and AFSperiodo = #PorActualizar.TAperiodo#
								  and AFSmes     = #PorActualizar.TAmes#
							</cfquery>

				</cfloop>               
				
				<cfif Arguments.contabilizar is true>
					<!--- Genera Asiento --->
					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
						<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#"/>
						<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#"/>
						<cfinvokeargument name="Usucodigo" 		value="#Arguments.Usucodigo#"/>
						<cfinvokeargument name="IP" 			value="#Arguments.IPaplica#"/>
						<cfinvokeargument name="Usuario" 		value="#Arguments.Usuario#"/>
						<cfinvokeargument name="Oorigen" 		value="AFDP"/>						
						<cfinvokeargument name="Eperiodo" 		value="#rsPeriodo.value#"/>
						<cfinvokeargument name="Emes" 			value="#rsMes.value#"/>
						<cfinvokeargument name="Efecha" 		value="#rsFechaAux.value#"/>
						<cfinvokeargument name="Edescripcion" 	value="#Arguments.descripcion#"/>
						<cfinvokeargument name="Edocbase" 		value="#rsAGTProcesoDoc.AGTPdocumento#"/>
						<cfinvokeargument name="Ereferencia" 	value="DP"/>
						<cfinvokeargument name="Ocodigo" 		value="#LvarOcodigo#"/>
						<cfinvokeargument name="Debug" 			value="#Arguments.Debug#"/>

						<cfinvokeargument name="pintaAsiento" 			value="false"/>
					</cfinvoke>
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						update TransaccionesActivos 
						set IDcontable = #res_GeneraAsiento#
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
					</cfquery>
				</cfif>
				
				<!---Borra ADTProceso--->
				<cfquery name="rsDelteADTProceso" datasource="#Arguments.Conexion#">
					delete from ADTProceso
					where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
				</cfquery>
				
				<!---Actualiza estado a AGTProceso--->
				<cfquery name="rsUpdateAGTProceso" datasource="#Arguments.Conexion#">
					Update AGTProceso
					set AGTPestadp = 4,
					AGTPfaplica = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					AGTPipaplica = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.IPaplica#">,
					Usuaplica = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
					where AGTPid = #Arguments.AGTPid#
				</cfquery>
				
				<cfif Arguments.debug>
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from TransaccionesActivos 
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="TransaccionesActivos">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from AFSaldos
						where Ecodigo = #Arguments.Ecodigo#
						and AFSperiodo = #rsPeriodo.value#
						and AFSmes = #rsMes.value#
					</cfquery>
					<cfdump var="#rsTemp#" label="AFSaldos">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from ADTProceso
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="ADTProceso">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from AGTProceso
						where AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="AGTProceso">
					<cftransaction action="rollback"/>
					<cf_abort errorInterfaz="">
				</cfif>
			</cftransaction>
		</cfif>
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn true>
	</cffunction>
</cfcomponent>