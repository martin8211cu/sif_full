<cfcomponent>
	<cfsetting requesttimeout="3600">
	<cffunction name="actualizarConfigSUM"  access="remote" returnType="array" returnFormat="json" output="false">
		<cfargument name="idColumna" 	type="numeric" required="yes">
		<cfargument name="tipo" 		type="numeric" required="yes"><!---- tipo 1 = acciones----->
		<cfargument name="elementos" 	type="array" 	required="true">
		<cfargument name="conexion" 	type="string" 	required="no" 	default="#session.dsn#">

		<cfif arrayLen(elementos) >
			<cfset elreferencias = IIF(IsJson(elementos), "deserializeJSON(arguments.elementos)", "arguments.elementos") >
		<cfelse>
			<cfreturn null >
		</cfif>
		<cfset data = arrayNew(1) />


		<cfloop from="1" to="#arrayLen(elreferencias)#" index="i">
			<cfset arguments.subtipo = elreferencias[i].subtipo >
			<cfset arguments.referencia = elreferencias[i].referencia >
			<cfif structKeyExists(elreferencias[i], "subvalor")>
				<cfset arguments.subvalor = elreferencias[i].subvalor >
			</cfif>
			<cftry>

				<cftransaction>
					<cfquery datasource="#arguments.conexion#" name="existe">
						select count(1) as valor
						from RHReportesDinamicoCSUM
						where Cid = #arguments.idColumna#
						and CSUMtipo = #arguments.tipo#
						and CSUMreferencia = #arguments.referencia#
						and Ecodigo = #session.Ecodigo#
					</cfquery>

					<!---- si el elemento existe se elimina de la configuracion---->
					<cfif existe.recordcount gt 0 and trim(existe.valor) eq 1>
						<cfquery datasource="#Arguments.conexion#">
							delete
							from RHReportesDinamicoCSUM
							where Cid = #arguments.idColumna#
							and CSUMtipo = #arguments.tipo#
							and CSUMreferencia = #arguments.referencia#
							and Ecodigo = #session.Ecodigo#
						</cfquery>
					<!---- si no existe se inserta----->
					<cfelse>
						<cfquery datasource="#Arguments.conexion#">
							insert into RHReportesDinamicoCSUM (Cid,CSUMreferencia,CSUMtipo,CSUMsubtipo,<cfif isDefined("arguments.subvalor")>CSUMsubvalor,</cfif>Ecodigo,BMUsucodigo,fechaalta)
							values(#arguments.idColumna#,#arguments.referencia#,#arguments.tipo#,#arguments.subtipo#,<cfif isDefined("arguments.subvalor")>#arguments.subvalor#,</cfif>
									#session.Ecodigo#,#session.usucodigo#,<cf_dbfunction name="now">)
						</cfquery>
					</cfif>
					<cfset arrayAppend(data, arguments.referencia)><!--- indica exito---->
					<cftransaction action="commit" />
				</cftransaction>

			<cfcatch type="any">
				<cftransaction action="rollback">
			</cfcatch>
			</cftry>
		</cfloop>

		<cfreturn data>
	</cffunction>


	<cffunction name="actualizarConfigCTE"  access="remote" returnType="array" returnFormat="json" output="false">
		<cfargument name="Cid" 			type="numeric" required="yes">
		<!--- <cfargument name="columna" 		type="string" required="yes"> --->
		<cfargument name="tipo" 		type="numeric" required="yes"><!---- 1 = EMPLEADO,  3= NOMINA ---->
		<!--- <cfargument name="order" 		type="numeric" required="yes"><!---- 1 = ASC ,  2 = DESC ----> --->
		<!--- <cfargument name="agregado" 	type="string" required="yes"><!---- 1 = MAX(), 2=  MIN()----> --->
		<cfargument name="elementos" 	type="array" 	required="true">
		<cfargument name="conexion" 	type="string" 	required="no" 		default="#session.dsn#">

		<cfif arrayLen(elementos) >
			<cfset elreferencias = IIF(IsJson(elementos), "deserializeJSON(arguments.elementos)", "arguments.elementos") >
		<cfelse>
			<cfreturn null >
		</cfif>
		<cfset data = arrayNew(1) />
		<cfloop from="1" to="#arrayLen(elreferencias)#" index="i">
			<cfset arguments.columna = elreferencias[i].columna >
			<cfset arguments.order = elreferencias[i].order >
			<cfset arguments.agregado = elreferencias[i].agregado >
			<cftry>
				<cftransaction>
					<cfquery datasource="#arguments.conexion#" name="existe">
					select count(1) as valor
					from RHReportesDinamicoCCTE
					where Cid = #arguments.Cid#
					and CCTEcampo = '#arguments.columna#'
					</cfquery>

					<!---- si el elemento existe se elimina de la configuracion---->
					<cfif existe.recordcount gt 0 and trim(existe.valor) eq 1>
						<cfquery datasource="#Arguments.conexion#" name="rsORden">
							select CCTEorder
							from RHReportesDinamicoCCTE
							where Cid = #arguments.Cid#
							and CCTEcampo = '#arguments.columna#'
						</cfquery>
						<cfquery datasource="#Arguments.conexion#">
							delete
							from RHReportesDinamicoCCTE
							where Cid = #arguments.Cid#
							and CCTEcampo = '#arguments.columna#'
						</cfquery>
						<cfquery datasource="#Arguments.conexion#"><!---- ordenamiento de los datos----->
							update RHReportesDinamicoCCTE
							set CCTEorder =  CCTEorder - 1
							where Cid = #arguments.Cid#
							and CCTEtipo = #arguments.tipo#<!--- 1  = tipo empleado---->
							and CCTEorder > #rsORden.CCTEorder#
						</cfquery>
					<!---- si no existe se inserta----->
					<cfelse>
						<cfquery datasource="#Arguments.conexion#" name="rsOrdenMax">
							select (max(CCTEorder) + 1) as valor
							from RHReportesDinamicoCCTE
							where Cid = #arguments.Cid#
							and CCTEtipo = #arguments.tipo#<!--- 1  = tipo empleado---->
						</cfquery>
						<cfif not(rsOrdenMax.recordcount gt 0 and len(trim( rsOrdenMax.valor)) gt 0)>
							<cfset rsOrdenMax.valor = 1>
						</cfif>
						<!--- #arguments.tipo#      ->     1  = tipo empleado---->
						<cfquery datasource="#Arguments.conexion#">
							insert into RHReportesDinamicoCCTE (Cid,CCTEtipo,CCTEcampo,CCTEorder,CCTEorderDatos,CCTEagregado,Ecodigo,BMUsucodigo,fechaalta)
							values(#arguments.Cid#,#arguments.tipo#,'#arguments.columna#',#rsOrdenMax.valor#,#arguments.order#,'#arguments.agregado#',0,#session.usucodigo#,<cf_dbfunction name="now">)
						</cfquery>
					</cfif>
					<cfset arrayAppend(data, arguments.columna)><!--- indica exito---->
					<cftransaction action="commit" />
				</cftransaction>
			<cfcatch type="any">
				<cftransaction action="rollback">
			</cfcatch>
			</cftry>
		</cfloop>

		<cfreturn data>
	</cffunction>


	<cffunction name="ValidaAgregada"  access="remote" returnType="struct" returnFormat="json" output="false">
		<cfargument name="Cid" 	type="numeric" required="yes">
		<cfargument name="listaBuscar" 	type="string" required="yes">
		<cfargument name="conexion" 	type="string" required="yes" default="#session.dsn#">

		<cfset var data = structNew() />
		<cfset data[0]["resultado"] = 0><!--- indica falso---->


		<cfquery datasource="#arguments.conexion#" name="existe">
		select count(1) as valor
		from RHReportesDinamicoCCTE
		where Cid = #arguments.Cid#
		and CCTEcampo in (#preservesinglequotes(arguments.listaBuscar)#)
		</cfquery>

		<!---- si el elemento existe se elimina de la configuracion---->
		<cfif existe.recordcount gt 0 and trim(existe.valor) gt 0>
			<cfset data[0]["resultado"] = 1>
		</cfif>

		<cfreturn data>
	</cffunction>


	<cffunction name="ValidaAgregadaInfoSalarial"  access="remote" returnType="struct" returnFormat="json" output="false">
		<cfargument name="Cid" 	type="numeric" required="yes">
		<cfargument name="conexion" 	type="string" required="yes" default="#session.dsn#">

		<cfset var data = structNew() />
		<cfset data[0]["resultado"] = -1><!--- indica falso---->


		<cfquery datasource="#arguments.conexion#" name="existe">
			select max(CSUMsubtipo) as valor, max(CSUMsubvalor) as tsuma, max(CSUMsubvalor) as tvalor
			from RHReportesDinamicoCSUM
			where Cid = #arguments.Cid#
			and Ecodigo = #session.Ecodigo#
		</cfquery>

		<!---- si el elemento existe se elimina de la configuracion---->
		<cfif existe.recordcount gt 0 and len(trim(existe.valor)) gt 0>
			<cfset data[0]["resultado"] = (existe.tsuma*10)+existe.valor>
		</cfif>

		<cfreturn data>
	</cffunction>



	<cffunction name="actualizarConfigCFOR"  access="remote" returnType="struct" returnFormat="json" output="false">
		<cfargument name="Cid" 			type="numeric" required="yes">
		<cfargument name="columnaA" 	type="string" required="no">
		<cfargument name="columnaB" 	type="string" required="no">
		<cfargument name="ValorA" 		type="string" required="no">
		<cfargument name="ValorB" 		type="string" required="no">
		<cfargument name="tipo" 		type="numeric" required="yes"><!---- 1 = X, 2= /, 3 = +, 4 = -   ---->
		<cfargument name="order" 		type="numeric" required="yes"><!---- 1 = ASC ,  2 = DESC ---->
		<cfargument name="conexion" 	type="string" required="yes" default="#session.dsn#">
		<cfargument name="Ecodigo" 		type="numeric" required="yes" default="#session.Ecodigo#">

		<cfset var data = structNew() />
		<cfset data[0]["resultado"] = 0><!--- indica falso---->

		<cfquery datasource="#arguments.conexion#" name="rsExiste">
			select count(1) as valor
			from RHReportesDinamicoCFOR
			where Ecodigo = #arguments.Ecodigo#
			and Cid = #arguments.Cid#
		</cfquery>


		<!---- si el elemento existe se elimina de la configuracion---->
		<cftry>
			<cftransaction>
				<cfif rsExiste.recordcount gt 0 and trim(rsExiste.valor) gt 0><!--- si el elemento existe se borra---->
					<cfquery datasource="#arguments.conexion#">
						delete
						from RHReportesDinamicoCFOR
						where Ecodigo = #arguments.Ecodigo#
						and Cid = #arguments.Cid#
					</cfquery>
				<cfelse><!---- si el elemento no existe se ingresa----->
					<cfquery datasource="#arguments.conexion#" name="rsExiste">
						insert into RHReportesDinamicoCFOR (Cid,CFORcolA,CFORcolB,CFORcteA,CFORcteB,BMUsucodigo,fechaalta,Ecodigo,CFORtipo,CFORorder )
						values (#arguments.Cid#,
							<cfif isdefined("arguments.columnaA") 	and len(trim(arguments.columnaA)) 	gt 0>#arguments.columnaA#<cfelse>null</cfif>,
							<cfif isdefined("arguments.columnaB") 	and len(trim(arguments.columnaB)) 	gt 0>#arguments.columnaB#<cfelse>null</cfif>,
							<cfif isdefined("arguments.ValorA") 	and len(trim(arguments.ValorA)) 	gt 0>#replace(arguments.ValorA,",","","ALL")#<cfelse>null</cfif>,
							<cfif isdefined("arguments.ValorB") 	and len(trim(arguments.ValorB)) 	gt 0>#replace(arguments.ValorB,",","","ALL")#<cfelse>null</cfif>,
							#session.usucodigo#,<cf_dbfunction name="today">,#arguments.Ecodigo#,#arguments.tipo#
							,#arguments.order#
							)
					</cfquery>
				</cfif>

				<cfset data[0]["resultado"] = 1><!--- indica exito---->
			</cftransaction>
				<cfcatch type="any">
					<cftransaction action="rollback">
						<cfset data[0]["resultado"] = 0><!--- indica fallo---->
				</cfcatch>
		</cftry>


		<cfreturn data>
	</cffunction>

	<cffunction name="ClearCol"  access="private" returnType="string"><!----esta funcion quita los elementos especiales un string---->
		<cfargument name="texto" 	type="string" required="yes">
		<cfset textoLimpio=trim(arguments.texto)>
		<cfset textoLimpio = REReplace(textoLimpio," ","_","all")>
		<cfset textoLimpio = REReplace(textoLimpio,"[^0-9A-Za-z_]","","all")>
		<cfset textoLimpio = mid(textoLimpio,1,28)>
		<cfreturn textoLimpio>
	</cffunction>


	<cffunction name="GetOpcionesFiltrado"  access="remote" returnType="struct" returnFormat="json" output="false">
		<cfargument name="RHRDEid"   type="numeric" required="yes">

		<cfset var data = structNew() />

			<cfset data[1]["Tipo"] = 'Empresa'>
			<cfset data[1]["Descripcion"] = 'Empresa'>


		<cfquery name="rsNomina" datasource="#session.dsn#">
			select 1
			from RHReportesDinamicoCCTE a
				inner join RHReportesDinamicoC b
					on a.Cid = b.Cid
			where b.RHRDEid = #arguments.RHRDEid#
			and CCTEcampo = 'Tcodigo'
		</cfquery>

		<cfif rsNomina.recordcount gt 0>
			<cfset data[2]["Tipo"] = 'Tcodigo'>
			<cfset data[2]["Descripcion"] ='Tipo de Nomina'>
		</cfif>

		<cfquery name="rsNominaCalendario" datasource="#session.dsn#">
			select 1
			from RHReportesDinamicoCCTE a
				inner join RHReportesDinamicoC b
					on a.Cid = b.Cid
			where b.RHRDEid = #arguments.RHRDEid#
			and CCTEcampo = 'Tdescripcion'
		</cfquery>

		<cfif rsNominaCalendario.recordcount gt 0>
			<cfset data[3]["Tipo"] = 'Nomina'>
			<cfset data[3]["Descripcion"] ='Calendario Pago'>
		</cfif>

		<cfquery name="rsCFuncional" datasource="#session.dsn#">
			select 1
			from RHReportesDinamicoCCTE a
				inner join RHReportesDinamicoC b
					on a.Cid = b.Cid
			where b.RHRDEid = #arguments.RHRDEid#
			and (CCTEcampo = 'CFcodigo' or CCTEcampo = 'CFdescripcion')
		</cfquery>

		<cfif rsCFuncional.recordcount gt 0>
			<cfset data[4]["Tipo"] = 'CFuncional'>
			<cfset data[4]["Descripcion"] ='Centro Funcional'>
		</cfif>

		<cfquery name="rsPuesto" datasource="#session.dsn#">
			select 1
			from RHReportesDinamicoCCTE a
				inner join RHReportesDinamicoC b
					on a.Cid = b.Cid
			where b.RHRDEid = #arguments.RHRDEid#
			and (CCTEcampo = 'RHRcodigo' or CCTEcampo = 'RHPdescpuesto')
		</cfquery>

		<cfif rsPuesto.recordcount gt 0>
			<cfset data[5]["Tipo"] = 'Puesto'>
			<cfset data[5]["Descripcion"] ='Puesto'>
		</cfif>

		<cfreturn data>
	</cffunction>

	<cffunction name="ReporteDinamico" access="public"  returnType="string">
		<cfargument name="ListaNomina" 	 	type="string" 	required="yes">
		<cfargument name="ListaEmpleados"  	type="string"	required="yes">
		<cfargument name="RHRDEid" 			type="numeric"	required="yes">
		<cfargument name="corporativo" 		type="numeric"	required="yes" default="0">
		<cfargument name="historico"		type="numeric" 	required="yes" default="0">
		<cfargument name="ListaAgrupado" 	type="string"	required="yes" default="">
		<cfargument name="fechaDesde" 		type="date"		required="yes" default="#now()#">
		<cfargument name="fechaHasta" 		type="date"		required="yes" default="#now()#">
		<cfargument name="CPtipo" 			type="numeric"	required="yes" default="-1">
		<cfargument name="MostrarConteo"	type="boolean" 	Required="YES" default="false">
		<cfargument name="GpoOficinas"		type="string" 	Required="yes" default="">

		<cfif listfind(arguments.ListaAgrupado,'Empresa',",")>
			<cfset corporativo=true>
		</cfif>

		<cfif arguments.historico GT 0>
			<cfset historia = "H" >
		<cfelse>
			<cfset historia = "">
		</cfif>

		<cfquery datasource="#session.dsn#" name="rsListaEmpresas">
			select distinct Ecodigo from #historia#RCalculoNomina where RCNid in (#ListaNomina#)
		</cfquery>


		<!--- check, Verifica que todas las columnas tengan un detalle de configuracion  ---->
		<cfquery datasource="#session.dsn#" name="rsValidaConfiguracion">
			select c.Cdescripcion
			from RHReportesDinamicoC c
			where c.RHRDEid = #arguments.RHRDEid#
			and
				(
					(c.Ctipo = 1 and (select count(1) from RHReportesDinamicoCSUM x where x.Cid = c.Cid <cfif not corporativo> and x.Ecodigo =#session.Ecodigo#</cfif>) = 0)<!---- tipo sumarizada---->
					or
					(c.Ctipo in (2,3) and (select count(1) from RHReportesDinamicoCCTE x where x.Cid = c.Cid) = 0)<!---- tipo empleado y nomina---->
					or
					(c.Ctipo = 4 and (select count(1) from RHReportesDinamicoCSUM x where x.Cid = c.Cid <cfif not corporativo> and x.Ecodigo =#session.Ecodigo#</cfif>) = 0)<!---- tipo informacion salarial---->
					or
					(c.Ctipo = 10 and (select count(1) from RHReportesDinamicoCFOR x where x.Cid = c.Cid) = 0)<!---- formulacon ---->
					or
					(c.Ctipo = 20 and (select count(1) from RHReportesDinamicoCSUM x where x.Cid = c.Cid) = 0)<!---- totalizadas---->

				)
		</cfquery>
		<cfif rsValidaConfiguracion.recordcount gt 0>
			<cf_errorCode	code = "52264"
							msg  = 'Falta configuración para las columnas: @errorDat_1@'
							errorDat_1="#valuelist(rsValidaConfiguracion.Cdescripcion,",")#" />
		</cfif>


		<cfquery datasource="#session.dsn#" name="rsColumnas">
			select Cid,Cdescripcion ,Cmostrar,Ctipo,Corden
			from RHReportesDinamicoC
			where RHRDEid = #arguments.RHRDEid#
			order by Corden
		</cfquery>
		<cfif rsColumnas.recordcount eq 0>
			<cf_errorCode	code = "52265"
							msg  = 'El reporte seleccionado no tiene columnas configuradas.' />
		</cfif>

		<cfquery dbtype="query" name="rsExisteNomina">
			SELECT 1 FROM rsColumnas
			WHERE Ctipo = 3 OR CTipo = 2
		</cfquery>
		<cfif rsExisteNomina.recordcount LTE 0>
			<cf_errorCode	code = "52266"
							msg  = 'El reporte seleccionado no tiene columna de nomina o empleado configurada.' />
		</cfif>

		<!-------------- existencia de columnas--------------->
		<cfset existeEmpleado =false>
				<cfquery datasource="#session.dsn#" name="rsHayColumnaEmpleado">
				select 1 from RHReportesDinamicoC a
					inner join RHReportesDinamicoCCTE b
						on a.Cid = b.Cid
				where Ctipo = 2 <!---- columna tipo empleado--->
					and RHRDEid = #arguments.RHRDEid#
				</cfquery>
				<cfif rsHayColumnaEmpleado.recordcount gt 0>
					<cfset existeEmpleado =true>
				</cfif>
				<cfif ListaEmpleados neq -1	><!---- si en la consulta se especifica el empleado se debe filtrar la info----->
					<cfset existeEmpleado =true>
				</cfif>

		<!--------- COLUMNAS ADICIONALES ---------->
			<!--- columnas empleado----->
			<cfquery datasource="#session.dsn#" name="rsColumnaEmpleado">
				 select ltrim(rtrim(CCTEcampo)) as CCTEcampo
				 from RHReportesDinamicoCCTE a
					inner join RHReportesDinamicoC b
						on a.Cid = b.Cid
				 where RHRDEid = #arguments.RHRDEid#
				 and CCTEtipo = 1 <!--- subtipo empleado----->
				<cfif listfind(arguments.ListaAgrupado,'CFuncional',",") >
				and CCTEcampo != 'CFcodigo' and CCTEcampo != 'CFdescripcion'
				</cfif>
				<cfif listfind(arguments.ListaAgrupado,'Puesto',",") >
				 and CCTEcampo != 'RHPcodigo'  and CCTEcampo != 'RHPdescpuesto'
				</cfif>
				<cfif listfind(arguments.ListaAgrupado,'CFuncional',",") >
				 union select 'CFcodigo' from dual
				 union select 'CFdescripcion' from dual
				</cfif>
				<cfif listfind(arguments.ListaAgrupado,'Puesto',",") >
				 union select 'RHPcodigo' from dual
				 union select 'RHPdescpuesto' from dual
				</cfif>
			</cfquery>

			<!---- columnas nomina------>
			<cfset existeNomina =false>
			<cfquery datasource="#session.dsn#" name="rsColumnaNomina">
				 select distinct ltrim(rtrim(CCTEcampo)) as CCTEcampo
				 from RHReportesDinamicoCCTE a
					inner join RHReportesDinamicoC b
						on a.Cid = b.Cid
				 where RHRDEid = #arguments.RHRDEid#
				 and CCTEtipo = 3 <!--- tipo nomina----->
				<cfif listfind(arguments.ListaAgrupado,'Tcodigo',",") >
				and CCTEcampo != 'Tcodigo'
				</cfif>
				<cfif listfind(arguments.ListaAgrupado,'Nomina',",") >
				and CCTEcampo != 'Tdescripcion'
				and CCTEcampo != 'RCdesde'
				and CCTEcampo != 'RChasta'
				and CCTEcampo != 'CPfpago'
				and CCTEcampo != 'CPcodigo'
				</cfif>
				<cfif listfind(arguments.ListaAgrupado,'Tcodigo',",") >
				 union select 'Tcodigo' from dual
				 union select 'Tdescripcion' from dual
				</cfif>
				<cfif listfind(arguments.ListaAgrupado,'Nomina',",") >
				 union select 'Tdescripcion' from dual
				union select 'RCdesde' from dual
				union select 'RChasta' from dual
				union select 'CPfpago' from dual
				union select 'CPcodigo' from dual
				</cfif>
			</cfquery>
				<cfset agrupaNomina = true >
				<cfif rsColumnaNomina.recordcount gt 0>
					<cfset existeNomina =true>
				</cfif>
			<!---- columnas informacion salarial---->
			<cfquery datasource="#session.dsn#" name="ColumnasInfoSalarial">
			 select Cdescripcion,Corden
			 from RHReportesDinamicoC c
			 where c.RHRDEid =#arguments.RHRDEid#
			 and c.Ctipo = 4 <!--- unicamente informacion salarial ---->
			 order by Corden
			</cfquery>

			<!---- columnas formuladas---->
			<cfquery datasource="#session.dsn#" name="ColumnasFormuladas">
			 select distinct Cdescripcion,Corden
			 from RHReportesDinamicoCFOR f
				inner join RHReportesDinamicoC c
					on f.Cid = c.Cid
			 where c.RHRDEid =#arguments.RHRDEid#
			 and c.Ctipo = 10 <!--- unicamente columnas formuladas---->
			 order by Corden
			</cfquery>


			<cfquery datasource="#session.dsn#" name="ColumnasTotalizadas">
			 select Cdescripcion,Corden
			 from RHReportesDinamicoC c
			 where c.RHRDEid =#arguments.RHRDEid#
			 and c.Ctipo = 20 <!--- unicamente columnas Totalizadas---->
			 order by Corden
			</cfquery>


		<!---- se crea temporal para el reporte----->
		<cfset request.temp_nombretabla = right('temp_RepDinamV'&getTickCount(), 20)>

		<cfif len(ListaNomina)>
			<cf_dbtemp name="testnomina" returnvariable="tableNomina">
				<cf_dbtempcol name="idNomina" type="numeric" mandatory="yes">
			</cf_dbtemp>

			<cfset arrNomina = listToArray(ListaNomina,',')>

			<cfloop from="1" to="#ArrayLen(arrNomina)#" index="i">
				<cfquery datasource="#session.dsn#" >
					INSERT INTO #tableNomina#
					VALUES (#arrNomina[i]#)
				</cfquery>
			</cfloop>
			<!--- <cfset existeNomina = true> --->
		</cfif>

		<cfset agrupaNomina = true >
		<cfset colNominaId = 'Tcodigo'>
		<cfset colTcodigo = false >
		<cf_dbtemp name="#request.temp_nombretabla#" returnvariable="tableRD">
					<cf_dbtempcol name="Ecodigo"  				    type="numeric" 	     mandatory="yes">

			<cfloop query="rsColumnas">
					<cfif rsColumnas.CTipo eq 1>
					<cf_dbtempcol name="#ClearCol(rsColumnas.Cdescripcion)#"  type="money" mandatory="no" default="0">
					</cfif>
			</cfloop>
			<cfloop query="rsColumnaEmpleado">
					<cf_dbtempcol name="#rsColumnaEmpleado.CCTEcampo#"  type="varchar(150)" mandatory="no" default="">
			</cfloop>
			<cfloop query="rsColumnaNomina">
					<cfif listfind('RCdesde,RChasta,CPfpago',rsColumnaNomina.CCTEcampo,",")>
						<cfset agrupaNomina = false >
						<cfset colNominaId = 'RCNid'>
						<cf_dbtempcol name="#rsColumnaNomina.CCTEcampo#"  type="datetime)" mandatory="no">
					<cfelse>
						<cf_dbtempcol name="#rsColumnaNomina.CCTEcampo#"  type="varchar(150)" mandatory="no">
					</cfif>
					<cfif listfind('Tcodigo',rsColumnaNomina.CCTEcampo,',')>
						<cfset colTcodigo = true >
					</cfif>
			</cfloop>
			<cfloop query="ColumnasInfoSalarial">
					<cf_dbtempcol name="#ClearCol(ColumnasInfoSalarial.Cdescripcion)#"  type="money" mandatory="no">
			</cfloop>
			<cfloop query="ColumnasFormuladas">
					<cf_dbtempcol name="#ClearCol(ColumnasFormuladas.Cdescripcion)#"  type="money" mandatory="no">
			</cfloop>
			<cfloop query="ColumnasTotalizadas">
					<cf_dbtempcol name="#ClearCol(ColumnasTotalizadas.Cdescripcion)#"  type="money" mandatory="no">
			</cfloop>
					<cfif existeNomina AND !agrupaNomina>
					<cf_dbtempcol name="RCNid"  				    type="numeric" 	     mandatory="yes">
					<cfelse>
						<cfif !colTcodigo >
					<cf_dbtempcol name="Tcodigo"  				    type="varchar(150)" 	mandatory="no">
						</cfif>
					</cfif>
					<cfif existeEmpleado>
						<cf_dbtempcol name="DEid"  				    type="numeric" 		 mandatory="yes">
					</cfif>
			<cfif existeEmpleado and existeNomina>
				<cf_dbtempindex cols="Ecodigo,#colNominaId#,DEid">
			<cfelseif existeNomina>
				<cf_dbtempindex cols="Ecodigo,#colNominaId#">
			<cfelseif existeEmpleado>
				<cf_dbtempindex cols="Ecodigo,DEid">
			</cfif>
		</cf_dbtemp>

		<!---- inserta valores por defecto----->
		<cfquery datasource="#session.dsn#" result="tst">
			INSERT INTO #tableRD# (
									Ecodigo
									<cfif existeNomina>
										,#colNominaId#
									</cfif>
									<cfif existeEmpleado>
										,DEid
									</cfif>)
			SELECT distinct hrcn.Ecodigo
							<cfif existeNomina>
								,hrcn.#colNominaId#
							</cfif>
							<cfif existeEmpleado>
								,hse.DEid
							</cfif>

			FROM <cfif existeEmpleado >
					#historia#RCalculoNomina hrcn
						inner join #historia#SalarioEmpleado hse
							on hrcn.RCNid = hse.RCNid
							<!--- and hse.SEsalariobruto > 0 --->
				 <cfelseif existeNomina>
				 	#historia#RCalculoNomina hrcn
				 </cfif>
				 <cfif arguments.CPtipo neq -1>
				 	inner join CalendarioPagos cp
				 		on hrcn.RCNid = cp.CPid
				 		and cp.CPtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPtipo#"/>
				 </cfif>

			 <!--- cambio en if si existe empleado en ambos casos son iguales
			 	<cfif existeEmpleado and existeNomina>
					#historia#RCalculoNomina hrcn
						inner join #historia#SalarioEmpleado hse
							on hrcn.RCNid = hse.RCNid
				<cfelseif existeNomina>
					#historia#RCalculoNomina hrcn
				<cfelseif existeEmpleado>
					#historia#RCalculoNomina hrcn
						inner join #historia#SalarioEmpleado hse
							on hrcn.RCNid = hse.RCNid
				<cfelse>
					#historia#RCalculoNomina hrcn
				</cfif> --->

			WHERE 	<cfif existeEmpleado and existeNomina>
						hrcn.RCNid in (<cfoutput>#ListaNomina#</cfoutput>)
						<cfif ListaEmpleados neq -1>
						and hse.DEid in (#ListaEmpleados#)
						</cfif>
					<cfelseif existeNomina>
						hrcn.RCNid in (<cfoutput>#ListaNomina#</cfoutput>)
						<cfif ListaEmpleados neq -1>
						and hrcn.RCNid in (select RCNid from #historia#SalarioEmpleado where DEid in (#ListaEmpleados#))
						</cfif>
					<cfelseif existeEmpleado>
						hse.RCNid in (<cfoutput>#ListaNomina#</cfoutput>)
						<cfif ListaEmpleados neq -1>
						and hse.DEid in (#ListaEmpleados#)
						</cfif>
					<cfelse>
						hrcn.RCNid in (<cfoutput>#ListaNomina#</cfoutput>)
					</cfif>
		</cfquery>

		<cfset ArrayColumnas = ArrayNew(1)>

		<!---- columna Ecodigo para cuando el reporte sea Corporativo----->
		<cfif corporativo>
			<cfset ArrayDetalle = ArrayNew(1)>

			<cfsavecontent variable="EmpresaQuery">
			<cfoutput>#tableRD#</cfoutput>.Ecodigo
			</cfsavecontent>

			<cfset ArrayDetalle = ArrayNew(1)>
			<cfset ArrayAppend(ArrayDetalle, EmpresaQuery)>
			<cfset ArrayAppend(ArrayDetalle, 'CodigoEmpresa')>
			<cfset ArrayAppend(ArrayDetalle, 'ASC')>
			<cfset ArrayAppend(ArrayDetalle, 1)>
			<cfset ArrayAppend(ArrayDetalle, 'text')>
			<cfset ArrayAppend(ArrayDetalle, 1)>
			<cfset ArrayAppend(ArrayDetalle, 'CodigoEmpresa')>



			<cfset ArrayAppend(ArrayColumnas, ArrayDetalle)>
			<!---- columna Descripcion de Empresa----->
				<cfset ArrayDetalle = ArrayNew(1)>

				<cfsavecontent variable="EmpresaQuery">
					(select  e.Edescripcion
					 from Empresas e
					where e.Ecodigo = <cfoutput>#tableRD#</cfoutput>.Ecodigo)
				</cfsavecontent>

				<cfset ArrayDetalle = ArrayNew(1)>
				<cfset ArrayAppend(ArrayDetalle, EmpresaQuery)>
				<cfset ArrayAppend(ArrayDetalle, 'DescripcionEmpresa')>
				<cfset ArrayAppend(ArrayDetalle, 'ASC')>
				<cfset ArrayAppend(ArrayDetalle, 1)>
				<cfset ArrayAppend(ArrayDetalle, 'text')>
				<cfset ArrayAppend(ArrayDetalle, 1)>
				<cfset ArrayAppend(ArrayDetalle, 'DescripcionEmpresa')>
			<cfset ArrayAppend(ArrayColumnas, ArrayDetalle)>
		</cfif>
		
		<cfloop query="rsColumnas">
			<!-----------------------------------------------  COLUMNAS TIPO SUMARIZAR ----------------------------------->
			<cfif rsColumnas.Ctipo eq 1>
				<cfloop query="rsListaEmpresas">
						<!---- columnas sumarizadas------>
						<cfquery datasource="#session.dsn#" name="configColumna">
						select CSUMreferencia,CSUMtipo,CSUMsubtipo, CSUMsubvalor
						from RHReportesDinamicoCSUM
						where Cid = #rsColumnas.Cid#
							and CSUMtipo in (1,2,3,4,5)
							and Ecodigo = #rsListaEmpresas.Ecodigo#
						</cfquery>
						<!---- Tipo Accion------>
						<cfquery dbtype="query" name="Acciones">
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 1
						</cfquery>
						<!---- Conceptos de Pago------>
						<cfquery dbtype="query" name="ConceptosPago">
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 2
						</cfquery>
						<!---- Deducciones------>
						<cfquery dbtype="query" name="Deducciones">
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 3
						</cfquery>
						<!---- Cargas------>
						<cfquery dbtype="query" name="CargasEmp"><!---- 1 = Empleado----->
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 4 and CSUMsubtipo = 1
						</cfquery>
						<cfquery dbtype="query" name="CargasPat"><!---- 2 = patrono----->
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 4 and CSUMsubtipo = 2
						</cfquery>
						<cfquery dbtype="query" name="Cargas"><!---- 3 = ambas----->
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 4 and CSUMsubtipo = 3
						</cfquery>
						<!---- Especiales----->
						<cfquery dbtype="query" name="RentaTabla"><!----- 1 = Renta tabla------>
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 5 and CSUMreferencia = 1
						</cfquery>
						<!---- ISPT----->
						<cfquery dbtype="query" name="ISPTTabla"><!----- 1 = Renta tabla------>
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 5 and CSUMreferencia = 4
						</cfquery>
						<cfquery dbtype="query" name="RentaDeduccion"><!----- 2 = Renta deduccion------>
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 5 and CSUMreferencia = 2
						</cfquery>
						<cfquery dbtype="query" name="Liquido"><!----- 3 = liquido------>
						select CSUMreferencia
						from configColumna
						where CSUMtipo = 5 and CSUMreferencia = 3
						</cfquery>

						<cfset listaAcciones 	= valuelist(Acciones.CSUMreferencia,",")>
						<cfset listaConceptos 	= valuelist(ConceptosPago.CSUMreferencia,",")>
						<cfset listaDeducciones = valuelist(Deducciones.CSUMreferencia,",")>
						<cfset listaCargas 		= valuelist(Cargas.CSUMreferencia,",")>
						<cfset listaEmpCargas 	= valuelist(CargasEmp.CSUMreferencia,",")>
						<cfset listaPatCargas 	= valuelist(CargasPat.CSUMreferencia,",")>
						<cfset AccionesQuery = ''>

						<!---- signo para las deducciones---->
						<cfset signoDeduc = '+'>
						<cfif len(trim(listaAcciones)) gt 0 or  len(trim(listaConceptos)) gt 0>
							<cfset signoDeduc = '-'>
						</cfif>
						<cfif len(trim(listaAcciones)) gt 0>
							<cfquery datasource="#session.dsn#">
								update #tableRD#
								set #ClearCol(rsColumnas.Cdescripcion)# =
									#ClearCol(rsColumnas.Cdescripcion)# + coalesce(
										( select coalesce(sum(hpe.PEmontores ), 0)
										  from #historia#PagosEmpleado hpe
										  inner join CalendarioPagos cp on cp.CPid = hpe.RCNid
										  where hpe.RHTid in (#listaAcciones#)
												<cfif existeNomina>
													<cfif !agrupaNomina>
														and hpe.RCNid = #tableRD#.RCNid
													<cfelse>
														and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hpe.RCNid )
														and #tableRD#.Tcodigo = cp.Tcodigo
													</cfif>
												<cfelse>
													and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hpe.RCNid )
												</cfif>
												<cfif existeEmpleado>
													and 	hpe.DEid = #tableRD#.DEid
												</cfif>
										)
									,0)
								where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
							<!--- INICIO: Actualización Finiquitos.. EGS: 08012023 --->
							<!---<cfquery name="rsUpdateFiniquitos" datasource="#session.dsn#">
								update #tableRD#
									set #ClearCol(rsColumnas.Cdescripcion)# =
										#ClearCol(rsColumnas.Cdescripcion)# + coalesce(
											(select COALESCE(SUM(importe), 0)
											FROM
											RHLiquidacionPersonal rhl
											INNER JOIN DLaboralesEmpleado dl ON dl.DEid = rhl.DEid
											AND dl.DLlinea = rhl.DLlinea
											INNER JOIN 
												RHLiqIngresos ri ON rhl.DEid = ri.DEid
												AND ri.Ecodigo = rhl.Ecodigo
											inner join DLaboralesEmpleado dle
												on dle.DEid = ri.DEid
												and ri.Ecodigo = dle.Ecodigo
												and ri.DLlinea = dle.DLlinea
											inner join CIncidentes ci
												on ri.CIid = ci.CIid
											where ri.DEid = #tableRD#.DEid
											and ci.CIafectaISN = 1
											AND dl.DLfvigencia BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaDesde#"> 
											AND <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaHasta#">
										),0)
									where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>--->
							<!--- FIN: Actualización Finiquitos.. EGS: 08012023 --->
						</cfif>

						<cfif len(trim(listaConceptos)) gt 0>
							<cfquery datasource="#session.dsn#">
								update #tableRD#
								set #ClearCol(rsColumnas.Cdescripcion)# =
								#ClearCol(rsColumnas.Cdescripcion)# +  coalesce(
									( select sum(hci.ICmontores)
									  from #historia#IncidenciasCalculo hci
									  inner join CalendarioPagos cp on cp.CPid = hci.RCNid
									  where hci.CIid in (#listaConceptos#)
											<cfif existeNomina>
												<cfif !agrupaNomina>
													and	hci.RCNid = #tableRD#.RCNid
												<cfelse>
													and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hci.RCNid )
													and #tableRD#.Tcodigo = cp.Tcodigo
												</cfif>
											<cfelse>
												and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hci.RCNid )
											</cfif>
											<cfif existeEmpleado>
												and 	hci.DEid = #tableRD#.DEid
												<cfif !existeNomina>
													and hci.RCNid in (#arguments.ListaNomina#)
												</cfif>
											</cfif>
									)
								,0)
								where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
							<!--- INICIO: Actualización Primas.. EGS: 08012023 --->
							<cfquery name="rsUpdatePrimas" datasource="#session.dsn#">
								update #tableRD#
									set #ClearCol(rsColumnas.Cdescripcion)# =
										#ClearCol(rsColumnas.Cdescripcion)# + coalesce(
											(select sum(importe)
											FROM
											RHLiquidacionPersonal rhl
											INNER JOIN DLaboralesEmpleado dl ON dl.DEid = rhl.DEid
											AND dl.DLlinea = rhl.DLlinea
											INNER JOIN  
												RHLiqIngresos ri ON rhl.DEid = ri.DEid
												AND ri.Ecodigo = rhl.Ecodigo
											inner join DLaboralesEmpleado dle
												on dle.DEid = ri.DEid
												and ri.Ecodigo = dle.Ecodigo
												and ri.DLlinea = dle.DLlinea
											inner join CIncidentes ci
												on ri.CIid = ci.CIid
											where ri.DEid = #tableRD#.DEid
											and ci.CIafectaISN = 1
											AND ri.CIid in (#listaConceptos#)
											AND dl.DLfvigencia BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaDesde#"> 
											AND <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaHasta#">
										),0)
									where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
							<!--- FIN: Actualización Primas.. EGS: 08012023 --->
						</cfif>

						<cfif len(trim(listaDeducciones)) gt 0>
							<cfquery datasource="#session.dsn#">
								update #tableRD#
								set #ClearCol(rsColumnas.Cdescripcion)# =
									#ClearCol(rsColumnas.Cdescripcion)# #signoDeduc# coalesce(
											( select sum(hdc.DCvalor)
												from #historia#DeduccionesCalculo hdc
												inner join CalendarioPagos cp on cp.CPid = hdc.RCNid
													inner join DeduccionesEmpleado dedEmpl
														on hdc.Did = dedEmpl.Did
													inner join TDeduccion tdec
														on 	dedEmpl.TDid = tdec.TDid
												where 	tdec.TDid in (<cfoutput>#listaDeducciones#</cfoutput>)
												<cfif existeNomina>
													<cfif !agrupaNomina>
														and hdc.RCNid = #tableRD#.RCNid
													<cfelse>
														and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hdc.RCNid )
														and #tableRD#.Tcodigo = cp.Tcodigo
													</cfif>
												<cfelse>
													and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hdc.RCNid )
												</cfif>
												<cfif existeEmpleado>
													and 	hdc.DEid = #tableRD#.DEid
												</cfif>
											)
									,0)
								where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
							<!--- INICIO: Actualización Deducciones.. EGS: 08012023 --->
							<cfquery name="rsUpdateDeduc" datasource="#session.dsn#">
								update #tableRD#
									set #ClearCol(rsColumnas.Cdescripcion)# =
										#ClearCol(rsColumnas.Cdescripcion)# + coalesce(
											(   SELECT sum(importe)
												FROM
												RHLiquidacionPersonal rhl
												INNER JOIN DLaboralesEmpleado dl ON dl.DEid = rhl.DEid
												AND dl.DLlinea = rhl.DLlinea
												INNER JOIN  
												RHLiqDeduccion rliq ON rhl.DEid = rliq.DEid
												INNER JOIN DeduccionesEmpleado de ON rliq.Did = de.Did
												AND rliq.DEid = de.DEid
												INNER JOIN TDeduccion td ON td.TDid = de.TDid
												AND de.Ecodigo = td.Ecodigo
												WHERE de.Ecodigo = #session.Ecodigo#
												AND rliq.DEid = #tableRD#.DEid
												AND de.TDid in (<cfoutput>#listaDeducciones#</cfoutput>)
												AND dl.DLfvigencia BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaDesde#"> 
												AND <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaHasta#">
										),0)
									where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
							<!--- FIN: Actualización Deducciones.. EGS: 08012023 --->
						</cfif>

						<!---- Update de Cargas----->
						<cfif len(trim(listaCargas)) gt 0>
							<cfquery datasource="#session.dsn#">
								update #tableRD#
								set #ClearCol(rsColumnas.Cdescripcion)# = #ClearCol(rsColumnas.Cdescripcion)# #signoDeduc# coalesce(
										(
											select sum( hcc.CCvaloremp+hcc.CCvalorpat)
											from #historia#CargasCalculo hcc
											inner join CalendarioPagos cp on cp.CPid = hcc.RCNid
											where hcc.DClinea in (<cfoutput>#listaCargas#</cfoutput>)
											<cfif existeNomina >
												<cfif !agrupaNomina>
													and	hcc.RCNid = #tableRD#.RCNid
												<cfelse>
													and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hcc.RCNid )
													and #tableRD#.Tcodigo = cp.Tcodigo
												</cfif>
											<cfelse>
												and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hcc.RCNid )
											</cfif>
											<cfif existeEmpleado>
												and 	hcc.DEid = #tableRD#.DEid
											</cfif>
										)
								,0)
								where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
						</cfif>

						<!----cargas del Empleado----->
						<cfif len(trim(listaEmpCargas)) gt 0>
							<cfquery datasource="#session.dsn#">
								update #tableRD#
								set #ClearCol(rsColumnas.Cdescripcion)# =
									#ClearCol(rsColumnas.Cdescripcion)# #signoDeduc# coalesce(
											(
												select sum(hcc.CCvaloremp)
												from #historia#CargasCalculo hcc
												inner join CalendarioPagos cp on cp.CPid = hcc.RCNid
												where hcc.DClinea in (<cfoutput>#listaEmpCargas#</cfoutput>)
												<cfif existeNomina>
													<cfif !agrupaNomina>
														and	hcc.RCNid = #tableRD#.RCNid
													<cfelse>
														and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hcc.RCNid )
														and #tableRD#.Tcodigo = cp.Tcodigo
													</cfif>
												<cfelse>
													and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hcc.RCNid )
												</cfif>
												<cfif existeEmpleado>
													and 	hcc.DEid = #tableRD#.DEid
												</cfif>
											)
									,0)
								where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
						</cfif>

						<!----- cargas del PATRONO----->
						<cfif len(trim(listaPatCargas)) gt 0>
							<cfquery datasource="#session.dsn#">
								update #tableRD#
								set #ClearCol(rsColumnas.Cdescripcion)# =
									#ClearCol(rsColumnas.Cdescripcion)# #signoDeduc# coalesce(
											(
												select sum(hcc.CCvalorpat)
												from #historia#CargasCalculo hcc
												inner join CalendarioPagos cp on cp.CPid = hcc.RCNid
												where hcc.DClinea in (<cfoutput>#listaPatCargas#</cfoutput>)
												<cfif existeNomina>
													<cfif !agrupaNomina>
														and	hcc.RCNid = #tableRD#.RCNid
													<cfelse>
														and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hcc.RCNid )
														and #tableRD#.Tcodigo = cp.Tcodigo
													</cfif>
												<cfelse>
													and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = hcc.RCNid )
												</cfif>
												<cfif existeEmpleado>
													and 	hcc.DEid = #tableRD#.DEid
												</cfif>
											)
									,0)
								where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
						</cfif>

						<!----- EspecialesQuery------->
						<cfset EspecialesQuery = ''>

						
						<cfif ISPTTabla.recordcount gt 0>
							<!--- INICIO: Actualización ISR Finiquitos.. EGS: 24012023 --->
							<cfquery name="rsUpdateISPTTabla" datasource="#session.dsn#">
								update #tableRD#
									set #ClearCol(rsColumnas.Cdescripcion)# =
										#ClearCol(rsColumnas.Cdescripcion)# + coalesce(
											(select sum(RHLFLisptF)
											from
												RHLiqFL ri
											inner join DLaboralesEmpleado dle
												on dle.DEid = ri.DEid
												and ri.Ecodigo = dle.Ecodigo
												and ri.DLlinea = dle.DLlinea
											where ri.DEid = #tableRD#.DEid
											AND dle.DLfvigencia BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaDesde#"> 
												AND <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaHasta#">
										),0)
									where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
							<!--- FIN: Actualización ISR Finiquitos.. EGS: 24012023 --->
						</cfif>	

						<cfif RentaTabla.recordcount gt 0 or  RentaDeduccion.recordcount gt 0 or  Liquido.recordcount gt 0>
							<cfquery datasource="#session.dsn#">
								update #tableRD#
								set #ClearCol(rsColumnas.Cdescripcion)# =
									#ClearCol(rsColumnas.Cdescripcion)# #signoDeduc# coalesce(
										(
												select sum( 0 <cfif RentaTabla.recordcount gt 0>
																+ salarioSuma.SERenta
															  </cfif>
															  <cfif RentaDeduccion.recordcount gt 0>
																+ salarioSuma.SERentaD
															  </cfif>
															  <cfif Liquido.recordcount gt 0>
																+ salarioSuma.SEliquido
															  </cfif>
																)
												from #historia#SalarioEmpleado salarioSuma
												inner join CalendarioPagos cp on cp.CPid = salarioSuma.RCNid
												where 1=1
												<cfif existeNomina>
													<cfif !agrupaNomina>
														and	salarioSuma.RCNid = #tableRD#.RCNid
													<cfelse>
														and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = salarioSuma.RCNid )
														and #tableRD#.Tcodigo = cp.Tcodigo
													</cfif>
												<cfelse>
													and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = salarioSuma.RCNid )
												</cfif>
												<cfif existeEmpleado>
														and salarioSuma.DEid = #tableRD#.DEid
												</cfif>
										)
								,0)
								where  Ecodigo = #rsListaEmpresas.Ecodigo#
							</cfquery>
						</cfif>
				</cfloop><!----- fin de loop aplicado por empresa----->



				<cfset ArrayDetalle = ArrayNew(1)>
				<cfset ArrayAppend(ArrayDetalle, ClearCol(Cdescripcion))>
				<cfset ArrayAppend(ArrayDetalle, ClearCol(Cdescripcion))>
				<cfset ArrayAppend(ArrayDetalle, 'ASC')>
				<cfset ArrayAppend(ArrayDetalle, Corden)>
				<cfset ArrayAppend(ArrayDetalle, 'money')>
				<cfset ArrayAppend(ArrayDetalle, Cmostrar)>
				<cfset ArrayAppend(ArrayDetalle, Cdescripcion)>

				<cfset ArrayAppend(ArrayColumnas, ArrayDetalle)>

			<!------------------------------------------- COLUMNAS TIPO EMPLEADO ----------------------------------------->
			<cfelseif rsColumnas.Ctipo eq 2>
				<!--------- SUBTIPO EMPLEADO---------->
				<cfquery datasource="#session.dsn#" name="rsColumnaEmpleado">
					 select 1 as pre,CCTEtipo,ltrim(rtrim(CCTEcampo)) as CCTEcampo,CCTEorderDatos,CCTEorder,CCTEagregado
					 from RHReportesDinamicoCCTE
					 where Cid = #rsColumnas.Cid#
					 and CCTEtipo = 1 <!--- tipo empleado----->
						<cfif listfind(arguments.ListaAgrupado,'CFuncional',",") >
						and CCTEcampo != 'CFcodigo' and CCTEcampo != 'CFdescripcion'
						</cfif>
						<cfif listfind(arguments.ListaAgrupado,'Puesto',",") >
						 and CCTEcampo != 'RHPcodigo'  and CCTEcampo != 'RHPdescpuesto'
						</cfif>
						<cfif listfind(arguments.ListaAgrupado,'CFuncional',",") >
						 union select 2 as pre,1,'CFcodigo',1,7,'0'  from dual
						 union select 2 as pre,1,'CFdescripcion',1,7,'0'  from dual
						</cfif>
						<cfif listfind(arguments.ListaAgrupado,'Puesto',",") >
						 union select 2 as pre,1,'RHPcodigo',1,7,'0'  from dual
						 union select 2 as pre,1,'RHPdescpuesto',1,7,'0'  from dual
						</cfif>
				</cfquery>
				<cfquery dbtype="query" name="rsColumnaEmpleado">
				select* from rsColumnaEmpleado order by pre,CCTEorder
				</cfquery>

				<cfloop query="rsColumnaEmpleado">
					<cfloop query="rsListaEmpresas">
						<cfset ArrayDetalle = ArrayNew(1)>
								<cfif listfind('RHPcodigo,RHPdescpuesto,CFcodigo,CFdescripcion,RHCcodigo,RHCdescripcion',trim(rsColumnaEmpleado.CCTEcampo),",")>
										<cfquery datasource="#session.dsn#">
											update #tableRD#
											set #rsColumnaEmpleado.CCTEcampo# =
											(
												select 	<cfif listfind('CFcodigo,CFdescripcion',trim(rsColumnaEmpleado.CCTEcampo),",")>
															max(cf.#rsColumnaEmpleado.CCTEcampo#)
														<cfelseif listfind('RHCcodigo,RHCdescripcion',trim(rsColumnaEmpleado.CCTEcampo),",")>
															max(rhc.#rsColumnaEmpleado.CCTEcampo#)
														<cfelse>
															max(rhp.#rsColumnaEmpleado.CCTEcampo#)
														</cfif>
												from LineaTiempo lt
													 inner join RHPlazas rh
														on lt.RHPid =  rh.RHPid
														<cfif listfind('CFcodigo,CFdescripcion',trim(rsColumnaEmpleado.CCTEcampo),",")>
														 inner join CFuncional cf
															on cf.CFid = rh.CFid
															and cf.Ecodigo = rh.Ecodigo
														<cfelse>
														 inner join RHPuestos rhp
															on rh.RHPpuesto = rhp.RHPcodigo
															and rh.Ecodigo = rhp.Ecodigo
														</cfif>
														<cfif listFind('RHCcodigo,RHCdescripcion',trim(rsColumnaEmpleado.CCTEcampo),',')>
														left join RHCategoriasPuesto rhcp
															on rhcp.RHCPlinea = lt.RHCPlinea
														inner join RHCategoria rhc
															on rhc.RHCid = rhcp.RHCid
														</cfif>

												where lt.DEid=#tableRD#.DEid
												and lt.LThasta = 	(
													select <cfif rsColumnaEmpleado.CCTEagregado eq 1>
															min(ltp.LThasta)
															<cfelse>
															max(ltp.LThasta)
															</cfif>
													from LineaTiempo ltp
														<cfif existeNomina>
														inner join CalendarioPagos cp
															<!---on cp.CPdesde between ltp.LTdesde and ltp.LThasta
															or cp.CPhasta between ltp.LTdesde and ltp.LThasta--->
															on cp.CPdesde  <= ltp.LThasta
                                                            and cp.CPhasta >= ltp.LTdesde
													where  ltp.DEid =  #tableRD#.DEid
															<cfif !agrupaNomina>
																and cp.CPid =  #tableRD#.RCNid
															<cfelse>
																and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = cp.CPid )
															</cfif>
														<cfelse><!---- si no existe nomina, usa las fechas de la consulta---->
														where  ltp.DEid =  #tableRD#.DEid
														and  ltp.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaHasta#">
														and ltp.LThasta	>= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaDesde#">
														</cfif>
													)
											)
											where Ecodigo = #rsListaEmpresas.Ecodigo#
										</cfquery>
										<!--- OPARRALES 2019-02-25 MODIFICACION PARA EMPLEADOS CESADOS --->
										<cfif listfind('CFcodigo,CFdescripcion',trim(rsColumnaEmpleado.CCTEcampo),",")>
											<cfquery datasource="#session.dsn#">
												update #tableRD#
												set #rsColumnaEmpleado.CCTEcampo# =
																					<cfif '#Trim(rsColumnaEmpleado.CCTEcampo)#' eq 'CFcodigo'>
																					(
																						SELECT top 1 cf.CFcodigo
																						FROM DLaboralesEmpleado lt
																						INNER JOIN RHPlazas rh ON lt.RHPid = rh.RHPid
																						INNER JOIN CFuncional cf ON cf.CFid = rh.CFid
																						AND cf.Ecodigo = rh.Ecodigo
																						WHERE lt.DEid = #tableRD#.DEid
																						order by lt.DLfvigencia desc
																					)
																					<cfelseif '#Trim(rsColumnaEmpleado.CCTEcampo)#' eq 'CFdescripcion'>
																					(
																						SELECT top 1 cf.CFdescripcion
																						FROM DLaboralesEmpleado lt
																						INNER JOIN RHPlazas rh ON lt.RHPid = rh.RHPid
																						INNER JOIN CFuncional cf ON cf.CFid = rh.CFid
																						AND cf.Ecodigo = rh.Ecodigo
																						WHERE lt.DEid = #tableRD#.DEid
																						order by lt.DLfvigencia desc
																					)
																					</cfif>
												where #rsColumnaEmpleado.CCTEcampo# is null or #rsColumnaEmpleado.CCTEcampo# = ''
											</cfquery>
										</cfif>

								<cfelse>
										<cfquery datasource="#session.dsn#">
											update #tableRD#
											set #rsColumnaEmpleado.CCTEcampo# = (select de.#rsColumnaEmpleado.CCTEcampo# from DatosEmpleado de where de.DEid = #tableRD#.DEid)
										</cfquery>
								</cfif>
					</cfloop><!---- fin de aplicacion de datos segun empresa---->

					<cfset ArrayDetalle = ArrayNew(1)>
					<cfset ArrayAppend(ArrayDetalle, rsColumnaEmpleado.CCTEcampo)>
					<cfif rsColumnaEmpleado.CCTEcampo eq 'DEidentificacion'>
						<cfset ArrayAppend(ArrayDetalle, 'Identificacion')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'DEtarjeta'>
						<cfset ArrayAppend(ArrayDetalle,  'IdTarjeta')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'DEnombre'>
						<cfset ArrayAppend(ArrayDetalle,  'Nombre')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'DEapellido1'>
						<cfset ArrayAppend(ArrayDetalle, 'PrimerApellido')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'DEapellido2'>
						<cfset ArrayAppend(ArrayDetalle, 'SegundoApellido')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'RHPcodigo'>
						<cfset ArrayAppend(ArrayDetalle, 'CodigoPuesto')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'RHPdescpuesto'>
						<cfset ArrayAppend(ArrayDetalle, 'DescripcionPuesto')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'CFcodigo'>
						<cfset ArrayAppend(ArrayDetalle, 'CodigoCFuncional')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'CFdescripcion'>
						<cfset ArrayAppend(ArrayDetalle, 'DescripcionCFuncional')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'RHCcodigo'>
						<cfset ArrayAppend(ArrayDetalle, 'CodigoCategoria')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'RHCdescripcion'>
						<cfset ArrayAppend(ArrayDetalle, 'DescripcionCategoria')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'RFC'>
						<cfset ArrayAppend(ArrayDetalle, 'RFC')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'CURP'>
						<cfset ArrayAppend(ArrayDetalle, 'CURP')>
					<cfelseif rsColumnaEmpleado.CCTEcampo eq 'DESeguroSocial'>
						<cfset ArrayAppend(ArrayDetalle, 'SeguroSocial')>
					</cfif>

					<cfif CCTEorderDatos eq 1 >
						<cfset ArrayAppend(ArrayDetalle, "ASC")>
					<cfelse>
						<cfset ArrayAppend(ArrayDetalle, "DESC")>
					</cfif>
					<cfset ArrayAppend(ArrayDetalle, CCTEorder)>
					<cfset ArrayAppend(ArrayDetalle, 'text')>
					<cfset ArrayAppend(ArrayDetalle, rsColumnas.Cmostrar)>
					<cfset ArrayAppend(ArrayDetalle,ArrayDetalle[2])><!--- nombre real---->
					<cfset ArrayAppend(ArrayColumnas, ArrayDetalle)>

				</cfloop>

			<!-----------------------------------------------  COLUMNAS TIPOS NOMINA------------------------------------>
			<cfelseif rsColumnas.Ctipo eq 3>
				<cfquery datasource="#session.dsn#" name="rsColumnaNomina">
					 select 1 as pre,CCTEtipo,ltrim(rtrim(CCTEcampo)) as CCTEcampo,CCTEorderDatos,CCTEorder,CCTEagregado
					 from RHReportesDinamicoCCTE
					 where Cid = #rsColumnas.Cid#
					 and CCTEtipo = 3 <!--- tipo nomina----->
						<cfif listfind(arguments.ListaAgrupado,'Tcodigo',",") >
						and CCTEcampo != 'Tcodigo'
						and CCTEcampo != 'Tdescripcion'
						</cfif>
						<cfif listfind(arguments.ListaAgrupado,'Nomina',",") >
						 and CCTEcampo != 'Tdescripcion'
						 and CCTEcampo != 'RCdesde'
						 and CCTEcampo != 'RChasta'
						 and CCTEcampo != 'CPfpago'
						 and CCTEcampo != 'CPcodigo'
						</cfif>
						<cfif listfind(arguments.ListaAgrupado,'Tcodigo',",") >
						 union select 2 as pre,3,'Tcodigo',0,7,'1'  from dual
						 union select 2 as pre,3,'Tdescripcion',0,7,'1'  from dual
						</cfif>
						<cfif listfind(arguments.ListaAgrupado,'Nomina',",") >
						 union select 2 as pre,3,'Tdescripcion',0,7,'1'  from dual
						 union select 2 as pre,3,'RCdesde',0,7,'1'  from dual
						 union select 2 as pre,3,'RChasta',0,7,'1'  from dual
						 union select 2 as pre,3,'CPfpago',0,7,'1'  from dual
						 union select 2 as pre,3,'CPcodigo',0,7,'1'  from dual
						</cfif>
					order by pre,CCTEorder
				</cfquery>

				<!--- <cfquery dbtype="query" name="rsColumnaNomina">
				select* from rsColumnaNomina order by pre,CCTEorder
				</cfquery> --->
				<cfloop query="rsColumnaNomina">
						<cfset ArrayDetalle = ArrayNew(1)>
						<cfquery datasource="#session.dsn#">
							update #tableRD#
							set #rsColumnaNomina.CCTEcampo# =
									(
										select distinct <cfif rsColumnaNomina.CCTEcampo eq 'CPfpago' or rsColumnaNomina.CCTEcampo eq 'CPcodigo'>
												 	cp.#rsColumnaNomina.CCTEcampo#
											   <cfelseif rsColumnaNomina.CCTEcampo eq 'Tdescripcion'>
											   		miTipo.#rsColumnaNomina.CCTEcampo#
											   <cfelse>
											   		miNomina.#rsColumnaNomina.CCTEcampo#
											   </cfif>
										from #historia#RCalculoNomina miNomina
											inner join CalendarioPagos cp
												on miNomina.RCNid = cp.CPid
											inner join	TiposNomina miTipo
												on miTipo.Tcodigo =  cp.Tcodigo
												and miTipo.Ecodigo = cp.Ecodigo
										where
										<cfif existeNomina>
											<cfif !agrupaNomina>
												miNomina.RCNid=#tableRD#.RCNid
											<cfelse>
												miNomina.Tcodigo = #tableRD#.Tcodigo
												and miTipo.Ecodigo = #tableRD#.Ecodigo
												and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = miNomina.RCNid )
											</cfif>
										</cfif>
									)
						</cfquery>

						<cfset ArrayDetalle = ArrayNew(1)>
						<cfset ArrayAppend(ArrayDetalle, rsColumnaNomina.CCTEcampo)>
							<cfswitch expression="#rsColumnaNomina.CCTEcampo#">
								<cfcase value="Tcodigo"><cfset ArrayAppend(ArrayDetalle, 'CodigoNomina')></cfcase>
								<cfcase value="Tdescripcion"><cfset ArrayAppend(ArrayDetalle, 'DescripcionTipoNomina')></cfcase>
								<cfcase value="RCdesde"><cfset ArrayAppend(ArrayDetalle, 'FechaDesdeNomina')></cfcase>
								<cfcase value="RChasta"><cfset ArrayAppend(ArrayDetalle, 'FechaHastaNomina')></cfcase>
								<cfcase value="CPfpago"><cfset ArrayAppend(ArrayDetalle, 'FechaPagoNomina')></cfcase>
								<cfcase value="CPcodigo"><cfset ArrayAppend(ArrayDetalle, 'CodigoCalendario')></cfcase>
							</cfswitch>

						<cfset ArrayAppend(ArrayDetalle, 'ASC')>
						<cfset ArrayAppend(ArrayDetalle, rsColumnaNomina.CCTEorder)>
						<cfif listFind('RCdesde,RChasta,CPfpago', rsColumnaNomina.CCTEcampo,",")>
							<cfset ArrayAppend(ArrayDetalle, 'date')>
						<cfelse>
							<cfset ArrayAppend(ArrayDetalle, 'text')>
						</cfif>
						<cfset ArrayAppend(ArrayDetalle, rsColumnas.Cmostrar)>
						<cfset ArrayAppend(ArrayDetalle,ArrayDetalle[2])><!--- nombre real---->

					<cfset ArrayAppend(ArrayColumnas, ArrayDetalle)>

				</cfloop>

			<!-----------------------------------------------  COLUMNAS TIPO INFORMACION SALARIAL------------------------------------>
			<cfelseif rsColumnas.Ctipo eq 4>
				<cfloop query="rsListaEmpresas">
						<!----- Componentes Salariales----->
						<cfquery datasource="#session.dsn#" name="ComponentesSalariales">
						select CSUMreferencia,CSUMsubtipo,CSUMsubvalor
						from RHReportesDinamicoCSUM
						where Cid = #rsColumnas.Cid#
							and CSUMtipo = 6
							and Ecodigo = #rsListaEmpresas.Ecodigo#
						</cfquery>
							<cfset listaComponentes 		= valuelist(ComponentesSalariales.CSUMreferencia,",")>

							<cfset agrupado='min'>
							<cfset tvalor = 'sum' >

							<cfif ComponentesSalariales.CSUMsubtipo eq 1><cfset agrupado='max'></cfif>
							<cfif ComponentesSalariales.CSUMsubvalor eq 1><cfset tvalor='count'></cfif>

							<cfif len(trim(listaComponentes)) gt 0>
								<cfquery datasource="#session.dsn#">
									update #tableRD#
									set #ClearCol(rsColumnas.Cdescripcion)# = coalesce(
										(select #tvalor#(DLTmonto)
										from LineaTiempo lt
											inner join DLineaTiempo dlt
												on lt.LTid = dlt.LTid
											inner join
														( select ltp.DEid,cp2.CPid,#agrupado#(ltp.LTdesde) as desde
														<cfif existeNomina and agrupaNomina>,cp2.Tcodigo</cfif>
														from LineaTiempo ltp
															inner join CalendarioPagos cp2
																on cp2.CPdesde between ltp.LTdesde and ltp.LThasta
																or cp2.CPhasta between ltp.LTdesde and ltp.LThasta
															inner join #historia#SalarioEmpleado hse2
																on cp2.CPid = hse2.RCNid
																and ltp.DEid = hse2.DEid
														 	where exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = cp2.CPid )
														group by ltp.DEid,cp2.CPid<cfif existeNomina and agrupaNomina>,cp2.Tcodigo</cfif>
														)  workLT
													on lt.LTdesde = workLT.desde
													  and lt.DEid = workLT.DEid
										where dlt.CSid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#listaComponentes#" list="true">)
											<cfif existeNomina>
												<cfif !agrupaNomina>
													and workLT.CPid = #tableRD#.RCNid
												<cfelse>
													and workLT.Tcodigo = #tableRD#.Tcodigo
												</cfif>
											</cfif>
											<cfif existeEmpleado>
												and workLT.DEid =  #tableRD#.DEid
											</cfif>)
										,0)
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsListaEmpresas.Ecodigo#">
								</cfquery>
								<cfquery datasource="#session.dsn#" name="validaInfo">
								select count(1) as cant from #tableRD# where coalesce(#ClearCol(rsColumnas.Cdescripcion)#,0) = 0
								</cfquery>
								<cfif len(trim(validaInfo.cant)) gt 0  and validaInfo.cant gt 0>
									<cfquery datasource="#session.dsn#">
										update #tableRD#
											set #ClearCol(rsColumnas.Cdescripcion)# =
													coalesce(
													(
													select 	#tvalor#(DLTmonto)
													from LineaTiempo lt
														inner join DLineaTiempo dlt
															on lt.LTid = dlt.LTid
														inner join
																	( select ltp.DEid,cp2.CPid,#agrupado#(ltp.LTdesde) as desde
																		<cfif existeNomina and agrupaNomina>,cp2.Tcodigo</cfif>
																	from LineaTiempo ltp
																		inner join CalendarioPagos cp2
																			on cp2.CPdesde between ltp.LTdesde and ltp.LThasta
																			or cp2.CPhasta between ltp.LTdesde and ltp.LThasta
																		inner join #historia#SalarioEmpleado hse2
																			on cp2.CPid = hse2.RCNid
																			and ltp.DEid = hse2.DEid
																	group by ltp.DEid,cp2.CPid<cfif existeNomina and agrupaNomina>,cp2.Tcodigo</cfif>
																	)  workLT
																on lt.LTdesde = workLT.desde
																  and lt.DEid = workLT.DEid

													where dlt.CSid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#listaComponentes#" list="true">)
														<cfif existeNomina>
															<cfif !agrupaNomina>
																and workLT.CPid = #tableRD#.RCNid
															<cfelse>
																and workLT.Tcodigo = #tableRD#.Tcodigo
															</cfif>
														<cfelse>
														 	and exists (Select 1 FROM #tableNomina# t WHERE t.idNomina = workLT.CPid )
														</cfif>
														<cfif existeEmpleado>
															and workLT.DEid =  #tableRD#.DEid
														</cfif>
													)
													,0)
										where 	#ClearCol(rsColumnas.Cdescripcion)# = 0
										and  Ecodigo = #rsListaEmpresas.Ecodigo#
									</cfquery>
								</cfif>
							</cfif>
					</cfloop><!---- fin del ciclo por empresa----->
						<cfset ArrayDetalle = ArrayNew(1)>
							<cfset ArrayAppend(ArrayDetalle, ClearCol(Cdescripcion))>
							<cfset ArrayAppend(ArrayDetalle, ClearCol(Cdescripcion))>
							<cfset ArrayAppend(ArrayDetalle, 'ASC')>
							<cfset ArrayAppend(ArrayDetalle, Corden)>
							<cfset ArrayAppend(ArrayDetalle, 'money')>
							<cfset ArrayAppend(ArrayDetalle, Cmostrar)>
							<cfset ArrayAppend(ArrayDetalle, Cdescripcion)>
					<cfset ArrayAppend(ArrayColumnas, ArrayDetalle)>
			<!-----------------------------------------------  COLUMNAS TIPO FORMULADAS------------------------------------>
			<cfelseif rsColumnas.Ctipo eq 10>
				<!----------- TRATAMIENTO DE LAS COLUMNAS FORMULADAS------->
				<cfquery datasource="#session.dsn#" name="ColumnasFormuladas">
					 select Cdescripcion,
						 CFORtipo,
						(select Cdescripcion from RHReportesDinamicoC where Cid = f.CFORcolA ) as CFORcolA,
						(select Cdescripcion from RHReportesDinamicoC where Cid = f.CFORcolB ) as CFORcolB,
						CFORcteA, CFORcteB,Corden
					 from RHReportesDinamicoCFOR f
						inner join RHReportesDinamicoC c
							on f.Cid = c.Cid
					 where c.RHRDEid =#arguments.RHRDEid#
					 and c.Cid = #rsColumnas.Cid#
					 and c.Ctipo = 10 <!--- unicamente columnas formuladas---->
					 order by Corden
				</cfquery>
				<cfif ColumnasFormuladas.recordcount gt 0>
					<!---- obtiene la columna A----->
					<cfif len(trim(ColumnasFormuladas.CFORcolA)) gt 0>
						<cfset columnaA = ClearCol(ColumnasFormuladas.CFORcolA)>
					<cfelseif len(trim(ColumnasFormuladas.CFORcteA)) gt 0>
							<cfset columnaA = ColumnasFormuladas.CFORcteA>
					</cfif>
					<!---obtiene la columna B------>
					<cfif len(trim(ColumnasFormuladas.CFORcolB)) gt 0>
						<cfset columnaB = ClearCol(ColumnasFormuladas.CFORcolB)>
					<cfelseif len(trim(ColumnasFormuladas.CFORcteB)) gt 0>
							<cfset columnaB = ColumnasFormuladas.CFORcteB>
					</cfif>

					<!---- obtiene el operador------>
					<cfswitch expression="#ColumnasFormuladas.CFORtipo#">
						<cfcase value="1"><cfset operador = '*'></cfcase>
						<cfcase value="2"><cfset operador = '/'></cfcase>
						<cfcase value="3"><cfset operador = '+'></cfcase>
						<cfcase value="4"><cfset operador = '-'></cfcase>
					</cfswitch>


					<cfquery datasource="#session.dsn#">
						update #tableRD#
						set #ClearCol(ColumnasFormuladas.Cdescripcion)# = #ColumnaA&operador&ColumnaB#
					</cfquery>
				</cfif>

				<cfset ArrayDetalle = ArrayNew(1)>


				<cfset ArrayAppend(ArrayDetalle, ClearCol(rsColumnas.Cdescripcion))>
				<cfset ArrayAppend(ArrayDetalle, ClearCol(rsColumnas.Cdescripcion))>

				<cfset ArrayAppend(ArrayDetalle, 'ASC')>
				<cfset ArrayAppend(ArrayDetalle, rsColumnas.Corden)>
				<cfset ArrayAppend(ArrayDetalle, 'money')>
				<cfset ArrayAppend(ArrayDetalle, rsColumnas.Cmostrar)>
				<cfset ArrayAppend(ArrayDetalle, rsColumnas.Cdescripcion)><!--- nombre real--->
				<cfset ArrayAppend(ArrayColumnas, ArrayDetalle)>

			<!-----------------------------------------------  COLUMNAS TIPO TOTALIZADAS ------------------------------------>
			<cfelseif rsColumnas.Ctipo eq 20>
				<cfloop query="rsListaEmpresas">
					<cfquery datasource="#session.dsn#" name="ColumnasTotal">
					 select Cdescripcion
					 from RHReportesDinamicoCSUM f
						inner join RHReportesDinamicoC c
							on f.CSUMreferencia = c.Cid
					 where f.CSUMtipo = 20 <!---- totalizado--->
					  and f.Cid = #rsColumnas.Cid#
					</cfquery>
					<cfif ColumnasTotal.recordcount gt 0>
						<cfquery datasource="#session.dsn#">
							update #tableRD#
							set #ClearCol(rsColumnas.Cdescripcion)# = 0 <cfloop query="ColumnasTotal">+#ClearCol(ColumnasTotal.Cdescripcion)#</cfloop>
						</cfquery>
					</cfif>
				</cfloop>
				<cfset ArrayDetalle = ArrayNew(1)>


				<cfset ArrayAppend(ArrayDetalle, ClearCol(rsColumnas.Cdescripcion))>
				<cfset ArrayAppend(ArrayDetalle, ClearCol(rsColumnas.Cdescripcion))>

				<cfset ArrayAppend(ArrayDetalle, 'ASC')>
				<cfset ArrayAppend(ArrayDetalle, rsColumnas.Corden)>
				<cfset ArrayAppend(ArrayDetalle, 'money')>
				<cfset ArrayAppend(ArrayDetalle, rsColumnas.Cmostrar)>
				<cfset ArrayAppend(ArrayDetalle, rsColumnas.Cdescripcion)>
				<cfset ArrayAppend(ArrayColumnas, ArrayDetalle)>

			</cfif>

		</cfloop>

		<!------------------ carga columnas previas---------------------->
		<cfset ListaColumnas = ''>
		<cfset OrdenColumnas = ''>
		<cfset nombreColumnas = ''>

		<cfset OrderAgrupadoReporte =''><!--- ordena los datos segun los agrupamientos del reporte---->
		<cfloop list="#arguments.ListaAgrupado#" index="i" delimiters=",">
				<cfif i eq 'Empresa'>
					<cfset OrderAgrupadoReporte = OrderAgrupadoReporte&'CodigoEmpresa,'>
				</cfif>
				<cfif  i eq 'Tcodigo'>
					<cfset OrderAgrupadoReporte = OrderAgrupadoReporte&'CodigoNomina,'>
				</cfif>
				<cfif  i eq 'Nomina'>
					<cfset OrderAgrupadoReporte = OrderAgrupadoReporte&'CodigoCalendario,'>
				</cfif>
				<cfif  i eq 'CFuncional'>
					<cfset OrderAgrupadoReporte = OrderAgrupadoReporte&'CodigoCFuncional,'>
				</cfif>
				<cfif  i eq 'Puesto'>
					<cfset OrderAgrupadoReporte = OrderAgrupadoReporte&'CodigoPuesto,'>
				</cfif>
		</cfloop>


		<cfset listaColumnasNoMostrar =''><!--- contine la lista de columnas que no se mostraran dado que se usan como agrupadores---->
			<cfif len(trim(ListaAgrupado)) gt 0>
				<cfif listfind(arguments.ListaAgrupado,'Empresa')>
					<cfset listaColumnasNoMostrar = listaColumnasNoMostrar&'CodigoEmpresa,DescripcionEmpresa,'>
				</cfif>
				<cfif listfind(arguments.ListaAgrupado,'Tcodigo')>
					<cfset listaColumnasNoMostrar = listaColumnasNoMostrar&'CodigoNomina,DescripcionTipoNomina,'>
				</cfif>
				<cfif  listfind(arguments.ListaAgrupado,'Nomina')>
					<cfset listaColumnasNoMostrar = listaColumnasNoMostrar&'CodigoNomina,CodigoCalendario,FechaDesdeNomina,FechaHastaNomina,FechaPagoNomina,'>
				</cfif>
				<cfif  listfind(arguments.ListaAgrupado,'CFuncional')>
					<cfset listaColumnasNoMostrar = listaColumnasNoMostrar&'CodigoCFuncional,DescripcionCFuncional,'>
				</cfif>
				<cfif listfind(arguments.ListaAgrupado,'Puesto')>
					<cfset listaColumnasNoMostrar = listaColumnasNoMostrar&'CodigoPuesto,DescripcionPuesto,'>
				</cfif>
			</cfif>

		<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="i">
				<cfif listfind('CodigoEmpresa,DescripcionEmpresa',ArrayColumnas[i][2],",") eq false>
					<cfset ListaColumnas= ListAppend(ListaColumnas, ClearCol(ArrayColumnas[i][1]) &' as '& ClearCol(ArrayColumnas[i][2]),',')>
				<cfelse>
					<cfset ListaColumnas= ListAppend(ListaColumnas, ArrayColumnas[i][1] &' as '& ArrayColumnas[i][2],',')>
				</cfif>
		</cfloop>

		<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="i">
			<cfif i lte 5>
				<cfif listfind(OrderAgrupadoReporte,ArrayColumnas[i][2],",") eq false><!---- siempre y cuando no exista ya en el agrupado, se agrega como order by--->
					<cfset OrdenColumnas= ListAppend(OrdenColumnas, ClearCol(ArrayColumnas[i][2]) &' '& ArrayColumnas[i][3] ,',')>
				</cfif>
			</cfif>
		</cfloop>

		<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="i">
				<cfset nombreColumnas= ListAppend(nombreColumnas,ArrayColumnas[i][7] ,',')><!--- nombre real---->
		</cfloop>

		<!--- 2019-02-26 Eliminar registros con montos en cero --->
		<cfsavecontent variable="miSQL">
			<cfoutput>
				delete from #tableRD#
				where 1 = 1
				<cfloop query="rsColumnas">
					<cfif rsColumnas.Ctipo eq 1>
						and coalesce(#Ucase(ClearCol(rsColumnas.Cdescripcion))#,0) = 0
					</cfif>
				</cfloop>
			</cfoutput>
		</cfsavecontent>

		<cfif Arguments.GpoOficinas neq ''>	
		
			<cfquery name="rsTableRD" datasource="#session.dsn#">
				delete from #tableRD# where DEid not in (select DISTINCT pe.DEid from HPagosEmpleado pe
													inner join LineaTiempo lt
													on pe.LTid = lt.LTid
													inner join Oficinas o
													on o.Ocodigo = lt.Ocodigo
													and o.Ecodigo = lt.Ecodigo
													inner join AnexoGOficinaDet ofg
													on 	ofg.Ocodigo = o.Ocodigo
													and ofg.Ecodigo = o.Ecodigo	
													where ofg.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GpoOficinas#">
													and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
													and pe.RCNid in (#ListaNomina#))
			</cfquery>
		</cfif>

		<cfquery datasource="#session.dsn#">
			#miSQL#
		</cfquery>

		<!----- query con lo datos consultados-------------->
		<cfquery datasource="#session.dsn#" name="datos">
			SELECT #ListaColumnas#
			FROM #tableRD#
			order by #OrderAgrupadoReporte##OrdenColumnas#
		</cfquery>

		<cfsavecontent variable="salidaReporte">
			<cfinvoke method="PintarReporteDinamico">
				<cfinvokeargument name="ArrayColumnas" 		value="#ArrayColumnas#">
				<cfinvokeargument name="datos" 				value="#datos#">
				<cfinvokeargument name="ListaColumnas" 		value="#ListaColumnas#">
				<cfinvokeargument name="OrdenColumnas" 		value="#OrdenColumnas#">
				<cfinvokeargument name="nombreColumnas" 	value="#nombreColumnas#">
				<cfinvokeargument name="ListaAgrupado"		value="#OrderAgrupadoReporte#">
				<cfinvokeargument name="listasNoMostrar"	value="#listaColumnasNoMostrar#">
				<cfinvokeargument name="MostrarConteo"		value="#Arguments.MostrarConteo#">
			</cfinvoke>
		</cfsavecontent>


		<cfif ucase(application.dsinfo[session.dsn].type) eq 'ORACLE' and isDefined("request.temp_nombretabla")>
			<!-- fcastro 20161028. En el caso de oracle las tablas temporales son fisicas por lo que se deben siempre eliminar antes de --->
			<cftry>
				<cfquery datasource="#session.dsn#">
					truncate table #request.temp_nombretabla#
				</cfquery>
				<cfquery datasource="#session.dsn#">
					drop table #request.temp_nombretabla#
				</cfquery>
				<cfcatch type="any">
				</cfcatch>
			</cftry>
		</cfif>


		<cfreturn salidaReporte>

	</cffunction>


	<cffunction name="PintarReporteDinamico" access="public" output="true">
			<cfargument name="ArrayColumnas" 	type="array" 	required="yes">
			<cfargument name="datos" 			type="query" 	required="yes">
			<cfargument name="ListaColumnas" 	type="string" 	required="yes">
			<cfargument name="OrdenColumnas" 	type="string" 	required="yes">
			<cfargument name="nombreColumnas" 	type="string" 	required="yes">
			<cfargument name="ListaAgrupado" 	type="string"	required="yes" default="">
			<cfargument name="listasNoMostrar" 	type="string"	required="yes" default="">
			<cfargument name="MostrarConteo" 	type="boolean" 	required="yes">
			<cfif len(trim(ListaAgrupado)) eq 0>
				<cfoutput>
				 		<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">

					 		<!--- OPARRALES 2019-02-25 Modificacion para mostar conteo de registros --->
					 		<cfif MostrarConteo>
								<tr class="listaCorte3" >
									<td colspan="10">Total de Registros: #datos.RecordCount#</td>
								</tr>
							</cfif>

							<tr class="listaCorte3">
								<cfset count = 1>
								<cfloop index = "colX" list = "#nombreColumnas#" delimiters = ",">
									<cfif ArrayColumnas[count][6] eq 1><!--- indica si es visible----->
										<td align="center"  width="3%" nowrap="nowrap"><cf_translate  key="LB_#colX#">#replace(colX,"_nbsp_"," ","ALL")#</cf_translate></td>
									</cfif>
									<cfset count = count +1>
								</cfloop>
							</tr>

							<!---- contiene los totales de cada columnas---->
							<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
								<cfif ArrayColumnas[ii][5] eq 'money'>
									<cfset Evaluate( "TotalDinamico_#ArrayColumnas[ii][2]# = 0" ) />
								</cfif>
							</cfloop>
							<cfloop query="datos">
							<tr class="detaller">
								<cfset count = 1>
								<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
										<cfif ArrayColumnas[count][6] eq 1><!--- indica si es visible----->
												<cfif ArrayColumnas[ii][5] eq 'date'>
													<td  align="right"><cf_locale name="date" value='#evaluate("datos."&ArrayColumnas[ii][2])#'/></td>
												<cfelseif ArrayColumnas[ii][5] eq 'money'>
													<td  align="right">#LSNumberFormat( evaluate("datos."&ArrayColumnas[ii][2]) ,',.00')#</td>
													<cfif LEN(evaluate("datos.#ArrayColumnas[ii][2]#")) NEQ 0 >
														<cfset Evaluate('TotalDinamico_#ArrayColumnas[ii][2]# = TotalDinamico_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
													</cfif>
												<cfelseif ArrayColumnas[ii][5] eq 'text'>
													<td  align="left" nowrap="nowrap">#evaluate("datos."&ArrayColumnas[ii][2])#</td>
												</cfif>
										</cfif>
										<cfset count = count +1>
								</cfloop>
							</tr>
							</cfloop>

							<tr class="detaller">
								<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
									<td height="1" bgcolor="000000"></td>
								</cfloop>
							</tr>

							<tr class="total">
							<cfset count = 1>
								<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
										<cfif ArrayColumnas[count][6] eq 1><!--- indica si es visible----->
												<cfif ArrayColumnas[ii][5] eq 'money'>
													<td  align="right"><b>#LSNumberFormat( evaluate("TotalDinamico_"&ArrayColumnas[ii][2]) ,',.00')#</b></td>
												<cfelse>
													<td  align="right">&nbsp;</td>
												</cfif>
										</cfif>
									<cfset count = count +1>
								</cfloop>
							</tr>
						</table>
				</cfoutput>
			<cfelse>
				<!---- pintado por agrupamiento---->

				<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
					<cfif ArrayColumnas[ii][5] eq 'money'>
						<cfset Evaluate( "Total_Final_#ArrayColumnas[ii][2]# = 0" ) />
					</cfif>
				</cfloop>
				<cfloop from="1" to="#ListLen(ListaAgrupado)#" index="i">
					<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
						<cfif ArrayColumnas[ii][5] eq 'money'>
							<cfset Evaluate( "Total_Corte#i#_#ArrayColumnas[ii][2]# = 0" ) />
						</cfif>
					</cfloop>
				</cfloop>
				<!--- OPARRALES 2019-02-26 Se calcula numero de colspan que utilizaran como base cada agrupador --->
				<cfset varCols = ListLen(ListaAgrupado) + (ArrayLen(ArrayColumnas) - ListLen(listasNoMostrar))>

				<table width="100%" align="center" cellpadding="0" cellspacing="0" border="1">
				<!--------------- NIVEL 1---------------------->
				<cfoutput query="datos" group="#ListGetAt(ListaAgrupado, 1)#">
					<tr class="listaCorte3">
						<!---- dependiendo del tipo de agrupado se pinta el encabezado del corte---->
						<cfif ListGetAt(ListaAgrupado, 1) eq 'CodigoEmpresa'>
							<cfset tituloCorte1 = datos.CodigoEmpresa&' - '& datos.DescripcionEmpresa>
						</cfif>
						<cfif  ListGetAt(ListaAgrupado, 1) eq 'CodigoNomina'>
							<cfset tituloCorte1 =datos.CodigoNomina&' - '& datos.DescripcionTipoNomina>
						</cfif>
						<cfif  ListGetAt(ListaAgrupado, 1) eq 'CodigoCalendario'>
							<cfset tituloCorte1 ='<b>'&datos.CodigoCalendario&'</b> - '&datos.DescripcionTipoNomina&' - Desde:'& LSDateFormat(datos.FechaDesdeNomina,'dd-mm-yyyy') &' Hasta:'& LSDateFormat(datos.FechaHastaNomina,'dd-mm-yyyy')>
						</cfif>
						<cfif  ListGetAt(ListaAgrupado, 1) eq 'CodigoCFuncional'>
							<cfset tituloCorte1 = datos.CodigoCFuncional&' - '& datos.DescripcionCFuncional>
						</cfif>
						<cfif  ListGetAt(ListaAgrupado, 1) eq 'CodigoPuesto'>
							<cfset tituloCorte1 = datos.CodigoPuesto&' - '& datos.DescripcionPuesto>
						</cfif>
						#RepeatString('<td>&nbsp;</td>',1)#
						<td colspan="#varCols#">
							#tituloCorte1#
							<!--- OPARRALES 2019-02-25 Modificacion para mostar conteo de registros --->
					 		<cfif MostrarConteo>
						 		<cfquery name="countGroup" dbtype="query">
									select *
									from datos
									where 1=1
									<cfif ListGetAt(ListaAgrupado, 1) eq 'CodigoEmpresa'>
										and CodigoEmpresa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoEmpresa#">
									</cfif>
									<cfif  ListGetAt(ListaAgrupado, 1) eq 'CodigoNomina'>
										and CodigoNomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoNomina#">
									</cfif>
									<cfif  ListGetAt(ListaAgrupado, 1) eq 'CodigoCalendario'>
										and CodigoCalendario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCalendario#">
									</cfif>
									<cfif  ListGetAt(ListaAgrupado, 1) eq 'CodigoCFuncional'>
										and CodigoCFuncional = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCFuncional#">
									</cfif>
									<cfif  ListGetAt(ListaAgrupado, 1) eq 'CodigoPuesto'>
										and CodigoPuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoPuesto#">
									</cfif>
								</cfquery>
								- #countGroup.RecordCount# Registros
							</cfif>
						</td>
					</tr>

					<cfif ListLen(ListaAgrupado) gt 1>
					<!---------------------NIVEL 2 -------------------------------------------------------------------->
								<cfoutput group="#ListGetAt(ListaAgrupado, 2)#">
									<tr class="listaCorte3">
										<!---- dependiendo del tipo de agrupado se pinta el encabezado del corte---->
										<cfif ListGetAt(ListaAgrupado, 2) eq 'CodigoEmpresa'>
											<cfset tituloCorte2 = datos.CodigoEmpresa&' - '& datos.DescripcionEmpresa>
										</cfif>
										<cfif  ListGetAt(ListaAgrupado, 2) eq 'CodigoNomina'>
											<cfset tituloCorte2 =datos.CodigoNomina&' - '& datos.DescripcionTipoNomina>
										</cfif>
										<cfif  ListGetAt(ListaAgrupado, 2) eq 'CodigoCalendario'>
											<cfset tituloCorte2 ='<b>'&datos.CodigoCalendario&'</b> - '&datos.DescripcionTipoNomina&' - Desde:'& LSDateFormat(datos.FechaDesdeNomina,'dd-mm-yyyy') &' Hasta:'& LSDateFormat(datos.FechaHastaNomina,'dd-mm-yyyy')>
										</cfif>
										<cfif  ListGetAt(ListaAgrupado, 2) eq 'CodigoCFuncional'>
											<cfset tituloCorte2 = datos.CodigoCFuncional&' - '& datos.DescripcionCFuncional>
										</cfif>
										<cfif  ListGetAt(ListaAgrupado, 2) eq 'CodigoPuesto'>
											<cfset tituloCorte2 = datos.CodigoPuesto&' - '& datos.DescripcionPuesto>
										</cfif>
										#RepeatString('<td>&nbsp;</td>',2)#
										<td colspan="#varCols-1#">
											#tituloCorte2#
											<!--- OPARRALES 2019-02-25 Modificacion para mostar conteo de registros --->
									 		<cfif MostrarConteo>
										 		<cfquery name="countGroup" dbtype="query">
													select *
													from datos
													where 1=1
													<cfif ListGetAt(ListaAgrupado, 2) eq 'CodigoEmpresa'>
														and CodigoEmpresa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoEmpresa#">
													</cfif>
													<cfif  ListGetAt(ListaAgrupado, 2) eq 'CodigoNomina'>
														and CodigoNomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoNomina#">
													</cfif>
													<cfif  ListGetAt(ListaAgrupado, 2) eq 'CodigoCalendario'>
														and CodigoCalendario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCalendario#">
													</cfif>
													<cfif  ListGetAt(ListaAgrupado, 2) eq 'CodigoCFuncional'>
														and CodigoCFuncional = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCFuncional#">
													</cfif>
													<cfif  ListGetAt(ListaAgrupado, 2) eq 'CodigoPuesto'>
														and CodigoPuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoPuesto#">
													</cfif>
												</cfquery>
												- #countGroup.RecordCount# Registros
											</cfif>
										</td>
									</tr>

									<cfif ListLen(ListaAgrupado) gt 2>
									<!---------------------NIVEL 3---------------------------------------------------------------->
												<cfoutput group="#ListGetAt(ListaAgrupado, 3)#">
													<tr class="listaCorte3">
														<!---- dependiendo del tipo de agrupado se pinta el encabezado del corte---->
														<cfif ListGetAt(ListaAgrupado, 3) eq 'CodigoEmpresa'>
															<cfset tituloCorte3 = datos.CodigoEmpresa&' - '& datos.DescripcionEmpresa>
														</cfif>
														<cfif  ListGetAt(ListaAgrupado, 3) eq 'CodigoNomina'>
															<cfset tituloCorte3 =datos.CodigoNomina&' - '& datos.DescripcionTipoNomina>
														</cfif>
														<cfif  ListGetAt(ListaAgrupado, 3) eq 'CodigoCalendario'>
															<cfset tituloCorte3 ='<b>'&datos.CodigoCalendario&'</b> - '&datos.DescripcionTipoNomina&' - Desde:'& LSDateFormat(datos.FechaDesdeNomina,'dd-mm-yyyy') &' Hasta:'& LSDateFormat(datos.FechaHastaNomina,'dd-mm-yyyy')>
														</cfif>
														<cfif  ListGetAt(ListaAgrupado, 3) eq 'CodigoCFuncional'>
															<cfset tituloCorte3 = datos.CodigoCFuncional&' - '& datos.DescripcionCFuncional>
														</cfif>
														<cfif  ListGetAt(ListaAgrupado, 3) eq 'CodigoPuesto'>
															<cfset tituloCorte3 = datos.CodigoPuesto&' - '& datos.DescripcionPuesto>
														</cfif>
														#RepeatString('<td>&nbsp;</td>',3)#
														<td colspan="#varCols-2#">
															#tituloCorte3#
															<!--- OPARRALES 2019-02-25 Modificacion para mostar conteo de registros --->
													 		<cfif MostrarConteo>
														 		<cfquery name="countGroup" dbtype="query">
																	select *
																	from datos
																	where 1=1
																	<cfif ListGetAt(ListaAgrupado, 3) eq 'CodigoEmpresa'>
																		and CodigoEmpresa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoEmpresa#">
																	</cfif>
																	<cfif  ListGetAt(ListaAgrupado, 3) eq 'CodigoNomina'>
																		and CodigoNomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoNomina#">
																	</cfif>
																	<cfif  ListGetAt(ListaAgrupado, 3) eq 'CodigoCalendario'>
																		and CodigoCalendario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCalendario#">
																	</cfif>
																	<cfif  ListGetAt(ListaAgrupado, 3) eq 'CodigoCFuncional'>
																		and CodigoCFuncional = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCFuncional#">
																	</cfif>
																	<cfif  ListGetAt(ListaAgrupado, 3) eq 'CodigoPuesto'>
																		and CodigoPuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoPuesto#">
																	</cfif>
																</cfquery>
																- #countGroup.RecordCount# Registros
															</cfif>
														</td>
													</tr>

													<cfif ListLen(ListaAgrupado) gt 3>
													<!---------------------NIVEL 4---------------------------------------------------------------->
															<cfoutput group="#ListGetAt(ListaAgrupado, 4)#">
																<tr class="listaCorte3">
																	<!---- dependiendo del tipo de agrupado se pinta el encabezado del corte---->
																	<cfif ListGetAt(ListaAgrupado, 4) eq 'CodigoEmpresa'>
																		<cfset tituloCorte4 = datos.CodigoEmpresa&' - '& datos.DescripcionEmpresa>
																	</cfif>
																	<cfif  ListGetAt(ListaAgrupado, 4) eq 'CodigoNomina'>
																		<cfset tituloCorte4 =datos.CodigoNomina&' - '& datos.DescripcionTipoNomina>
																	</cfif>
																	<cfif  ListGetAt(ListaAgrupado, 4) eq 'CodigoCalendario'>
																		<cfset tituloCorte4 ='<b>'&datos.CodigoCalendario&'</b> - '&datos.DescripcionTipoNomina&' - Desde:'& LSDateFormat(datos.FechaDesdeNomina,'dd-mm-yyyy') &' Hasta:'& LSDateFormat(datos.FechaHastaNomina,'dd-mm-yyyy')>
																	</cfif>
																	<cfif  ListGetAt(ListaAgrupado, 4) eq 'CodigoCFuncional'>
																		<cfset tituloCorte4 = datos.CodigoCFuncional&' - '& datos.DescripcionCFuncional>
																	</cfif>
																	<cfif  ListGetAt(ListaAgrupado, 4) eq 'CodigoPuesto'>
																		<cfset tituloCorte4 = datos.CodigoPuesto&' - '& datos.DescripcionPuesto>
																	</cfif>
																	#RepeatString('<td>&nbsp;</td>',4)#
																	<td colspan="#varCols-3#">
																		#tituloCorte4#
																		<!--- OPARRALES 2019-02-25 Modificacion para mostar conteo de registros --->
																 		<cfif MostrarConteo>
																	 		<cfquery name="countGroup" dbtype="query">
																				select *
																				from datos
																				where 1=1
																				<cfif ListGetAt(ListaAgrupado, 4) eq 'CodigoEmpresa'>
																					and CodigoEmpresa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoEmpresa#">
																				</cfif>
																				<cfif  ListGetAt(ListaAgrupado, 4) eq 'CodigoNomina'>
																					and CodigoNomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoNomina#">
																				</cfif>
																				<cfif  ListGetAt(ListaAgrupado, 4) eq 'CodigoCalendario'>
																					and CodigoCalendario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCalendario#">
																				</cfif>
																				<cfif  ListGetAt(ListaAgrupado, 4) eq 'CodigoCFuncional'>
																					and CodigoCFuncional = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCFuncional#">
																				</cfif>
																				<cfif  ListGetAt(ListaAgrupado, 4) eq 'CodigoPuesto'>
																					and CodigoPuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoPuesto#">
																				</cfif>
																			</cfquery>
																			- #countGroup.RecordCount# Registros
																		</cfif>
																	</td>
																</tr>

																<cfif ListLen(ListaAgrupado) gt 4>
																<!---------------------NIVEL 5---------------------------------------------------------------->
																	<cfoutput group="#ListGetAt(ListaAgrupado, 5)#">
																		<tr class="listaCorte3">
																			<!---- dependiendo del tipo de agrupado se pinta el encabezado del corte---->
																			<cfif ListGetAt(ListaAgrupado, 5) eq 'CodigoEmpresa'>
																				<cfset tituloCorte5 = datos.CodigoEmpresa&' - '& datos.DescripcionEmpresa>
																			</cfif>
																			<cfif  ListGetAt(ListaAgrupado, 5) eq 'CodigoNomina'>
																				<cfset tituloCorte5 =datos.CodigoNomina&' - '& datos.DescripcionTipoNomina>
																			</cfif>
																			<cfif  ListGetAt(ListaAgrupado, 5) eq 'CodigoCalendario'>
																				<cfset tituloCorte5 ='<b>'&datos.CodigoCalendario&'</b> - '&datos.DescripcionTipoNomina&' - Desde:'& LSDateFormat(datos.FechaDesdeNomina,'dd-mm-yyyy') &' Hasta:'& LSDateFormat(datos.FechaHastaNomina,'dd-mm-yyyy')>
																			</cfif>
																			<cfif  ListGetAt(ListaAgrupado, 5) eq 'CodigoCFuncional'>
																				<cfset tituloCorte5 = datos.CodigoCFuncional&' - '& datos.DescripcionCFuncional>
																			</cfif>
																			<cfif  ListGetAt(ListaAgrupado, 5) eq 'CodigoPuesto'>
																				<cfset tituloCorte5 = datos.CodigoPuesto&' - '& datos.DescripcionPuesto>
																			</cfif>
																			#RepeatString('<td>&nbsp;</td>',5)#
																			<td colspan="#varCols-4#">
																				#tituloCorte5#
																				<!--- OPARRALES 2019-02-25 Modificacion para mostar conteo de registros --->
																		 		<cfif MostrarConteo>
																			 		<cfquery name="countGroup" dbtype="query">
																						select *
																						from datos
																						where 1=1
																						<cfif ListGetAt(ListaAgrupado, 5) eq 'CodigoEmpresa'>
																							and CodigoEmpresa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoEmpresa#">
																						</cfif>
																						<cfif  ListGetAt(ListaAgrupado, 5) eq 'CodigoNomina'>
																							and CodigoNomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoNomina#">
																						</cfif>
																						<cfif  ListGetAt(ListaAgrupado, 5) eq 'CodigoCalendario'>
																							and CodigoCalendario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCalendario#">
																						</cfif>
																						<cfif  ListGetAt(ListaAgrupado, 5) eq 'CodigoCFuncional'>
																							and CodigoCFuncional = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoCFuncional#">
																						</cfif>
																						<cfif  ListGetAt(ListaAgrupado, 5) eq 'CodigoPuesto'>
																							and CodigoPuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CodigoPuesto#">
																						</cfif>
																					</cfquery>
																					- #countGroup.RecordCount# Registros
																				</cfif>
																			</td>
																		</tr>

																				<tr  class="listaCorte3">
																					#RepeatString('<td>&nbsp;</td>',6)#
																				<cfset count = 1>
																				<cfloop index = "colX" list = "#nombreColumnas#" delimiters = ",">
																					<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,colX)><!--- indica si es visible----->
																						<td align="center"  width="3%" nowrap="nowrap"><cf_translate  key="LB_#colX#">#replace(colX,"_nbsp_"," ","ALL")#</cf_translate></td>
																					</cfif>
																					<cfset count = count +1>
																				</cfloop>
																				<cfset corteDeColumnas =false>
																				</tr>
																				<cfoutput>
																						<cfset count = 1>
																						<tr  class="detaller">
																							#RepeatString('<td>&nbsp;</td>',6)#
																						<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
																								<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
																										<cfif ArrayColumnas[ii][5] eq 'date'>
																											<td  align="right" nowrap="nowrap" ><cf_locale name="date" value='#evaluate("datos."&ArrayColumnas[ii][2])#'/></td>
																										<cfelseif ArrayColumnas[ii][5] eq 'money'>
																											<td  align="right"  nowrap="nowrap">#LSNumberFormat( evaluate("datos."&ArrayColumnas[ii][2]) ,',.00')#</td>
																												<cfif LEN(evaluate("datos.#ArrayColumnas[ii][2]#")) NEQ 0 >
																													<cfset Evaluate('Total_Corte1_#ArrayColumnas[ii][2]# = Total_Corte1_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																													<cfset Evaluate('Total_Corte2_#ArrayColumnas[ii][2]# = Total_Corte2_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																													<cfset Evaluate('Total_Corte3_#ArrayColumnas[ii][2]# = Total_Corte3_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																													<cfset Evaluate('Total_Corte4_#ArrayColumnas[ii][2]# = Total_Corte4_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																													<cfset Evaluate('Total_Corte5_#ArrayColumnas[ii][2]# = Total_Corte5_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																													<cfset Evaluate('Total_Final_#ArrayColumnas[ii][2]# = Total_Final_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																												</cfif>
																										<cfelseif ArrayColumnas[ii][5] eq 'text'>
																											<td  align="left" nowrap="nowrap">#evaluate("datos."&ArrayColumnas[ii][2])# </td>
																										</cfif>
																								</cfif>
																								<cfset count = count +1>
																						</cfloop>
																						</tr>
																				</cfoutput>

																		<tr class="total">
																			#RepeatString('<td>&nbsp;</td>',5)#
																			<td align="left" nowrap="nowrap">
																				TOTAL #Evaluate('tituloCorte5')#
																			</td>
																			#RepeatString('<td>&nbsp;</td>',listlen(ListaAgrupado)-5)#

																			<cfset count = 1>
																			<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
																				<cfif ArrayColumnas[count][6] eq 1  and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
																						<cfif ArrayColumnas[ii][5] eq 'money'>
																							<td  align="right"><b>#LSNumberFormat( evaluate("Total_Corte5_"&ArrayColumnas[ii][2]) ,',.00')#</b></td>
																						<cfelse>
																							<td  align="right">&nbsp;</td>
																						</cfif>
																				</cfif>
																				<cfset count = count +1>
																			</cfloop>

																			<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
																				<cfif ArrayColumnas[ii][5] eq 'money'>
																					<cfset Evaluate( "Total_Corte5_#ArrayColumnas[ii][2]# = 0" ) />
																				</cfif>
																			</cfloop>
																		</tr>
																	</cfoutput>
																<!---------------------FIN NIVEL 5---------------------------------------------------------------->
																<cfelse>
																		<tr  class="listaCorte3">
																			#RepeatString('<td>&nbsp;</td>',5)#
																		<cfset count = 1>
																		<cfloop index = "colX" list = "#nombreColumnas#" delimiters = ",">
																			<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,colX)><!--- indica si es visible----->
																				<td align="center"  width="3%" nowrap="nowrap"><cf_translate  key="LB_#colX#">#replace(colX,"_nbsp_"," ","ALL")#</cf_translate></td>
																			</cfif>
																			<cfset count = count +1>
																		</cfloop>
																		<cfset corteDeColumnas =false>
																		</tr>
																		<cfoutput>
																				<cfset count = 1>
																				<tr  class="detaller">
																					#RepeatString('<td>&nbsp;</td>',5)#
																				<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
																						<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
																								<cfif ArrayColumnas[ii][5] eq 'date'>
																									<td  align="right" nowrap="nowrap" ><cf_locale name="date" value='#evaluate("datos."&ArrayColumnas[ii][2])#'/></td>
																								<cfelseif ArrayColumnas[ii][5] eq 'money'>
																									<td  align="right"  nowrap="nowrap">#LSNumberFormat( evaluate("datos."&ArrayColumnas[ii][2]) ,',.00')#</td>

																										<cfif LEN(evaluate("datos.#ArrayColumnas[ii][2]#")) NEQ 0 >
																											<cfset Evaluate('Total_Corte1_#ArrayColumnas[ii][2]# = Total_Corte1_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																											<cfset Evaluate('Total_Corte2_#ArrayColumnas[ii][2]# = Total_Corte2_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																											<cfset Evaluate('Total_Corte3_#ArrayColumnas[ii][2]# = Total_Corte3_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																											<cfset Evaluate('Total_Corte4_#ArrayColumnas[ii][2]# = Total_Corte4_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																											<cfset Evaluate('Total_Final_#ArrayColumnas[ii][2]# = Total_Final_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																										</cfif>
																								<cfelseif ArrayColumnas[ii][5] eq 'text'>
																									<td  align="left" nowrap="nowrap">#evaluate("datos."&ArrayColumnas[ii][2])# </td>
																								</cfif>
																						</cfif>
																						<cfset count = count +1>
																				</cfloop>
																				</tr>
																		</cfoutput>
																</cfif>

																<tr class="total">
																	#RepeatString('<td>&nbsp;</td>',4)#
																	<td align="left" nowrap="nowrap">
																		TOTAL #Evaluate('tituloCorte4')#

																	</td>
																	#RepeatString('<td>&nbsp;</td>',listlen(ListaAgrupado)-4)#

																	<cfset count = 1>
																	<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
																		<cfif ArrayColumnas[count][6] eq 1  and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
																				<cfif ArrayColumnas[ii][5] eq 'money'>
																					<td  align="right"><b>#LSNumberFormat( evaluate("Total_Corte4_"&ArrayColumnas[ii][2]) ,',.00')#</b></td>
																				<cfelse>
																					<td  align="right">&nbsp;</td>
																				</cfif>
																		</cfif>
																		<cfset count = count +1>
																	</cfloop>

																	<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
																		<cfif ArrayColumnas[ii][5] eq 'money'>
																			<cfset Evaluate( "Total_Corte4_#ArrayColumnas[ii][2]# = 0" ) />
																		</cfif>
																	</cfloop>
																</tr>
															</cfoutput>

													<!---------------------FIN NIVEL 4---------------------------------------------------------------->
													<cfelse>
															<tr  class="listaCorte3">
																#RepeatString('<td>&nbsp;</td>',4)#
															<cfset count = 1>
															<cfloop index = "colX" list = "#nombreColumnas#" delimiters = ",">
																<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,colX)><!--- indica si es visible----->
																	<td align="center"  width="3%" nowrap="nowrap"><cf_translate  key="LB_#colX#">#replace(colX,"_nbsp_"," ","ALL")#</cf_translate></td>
																</cfif>
																<cfset count = count +1>
															</cfloop>
															<cfset corteDeColumnas =false>
															</tr>
															<cfoutput>
																	<cfset count = 1>
																	<tr  class="detaller">
																		#RepeatString('<td>&nbsp;</td>',4)#
																	<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
																			<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
																					<cfif ArrayColumnas[ii][5] eq 'date'>
																						<td  align="right" nowrap="nowrap" ><cf_locale name="date" value='#evaluate("datos."&ArrayColumnas[ii][2])#'/></td>
																					<cfelseif ArrayColumnas[ii][5] eq 'money'>
																						<td  align="right"  nowrap="nowrap">#LSNumberFormat( evaluate("datos."&ArrayColumnas[ii][2]) ,',.00')#</td>
																							<cfif LEN(evaluate("datos.#ArrayColumnas[ii][2]#")) NEQ 0 >
																								<cfset Evaluate('Total_Corte1_#ArrayColumnas[ii][2]# = Total_Corte1_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																								<cfset Evaluate('Total_Corte2_#ArrayColumnas[ii][2]# = Total_Corte2_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																								<cfset Evaluate('Total_Corte3_#ArrayColumnas[ii][2]# = Total_Corte3_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																								<cfset Evaluate('Total_Final_#ArrayColumnas[ii][2]# = Total_Final_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																							</cfif>
																					<cfelseif ArrayColumnas[ii][5] eq 'text'>
																						<td  align="left" nowrap="nowrap">#evaluate("datos."&ArrayColumnas[ii][2])# </td>
																					</cfif>
																			</cfif>
																			<cfset count = count +1>
																	</cfloop>
																	</tr>
															</cfoutput>
													</cfif>

													<tr class="total">
														#RepeatString('<td>&nbsp;</td>',3)#
													<td align="left" nowrap="nowrap">TOTAL #Evaluate('tituloCorte3')#</td>
													#RepeatString('<td>&nbsp;</td>',listlen(ListaAgrupado)-3)#

													<cfset count = 1>
													<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
															<cfif ArrayColumnas[count][6] eq 1  and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
																	<cfif ArrayColumnas[ii][5] eq 'money'>
																		<td  align="right"><b>#LSNumberFormat( evaluate("Total_Corte3_"&ArrayColumnas[ii][2]) ,',.00')#</b></td>
																	<cfelse>
																		<td  align="right">&nbsp;</td>
																	</cfif>
															</cfif>
														<cfset count = count +1>
													</cfloop>

														<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
															<cfif ArrayColumnas[ii][5] eq 'money'>
																<cfset Evaluate( "Total_Corte3_#ArrayColumnas[ii][2]# = 0" ) />
															</cfif>
														</cfloop>
													</tr>
												</cfoutput>
									<!---------------------FIN NIVEL 3---------------------------------------------------------------->
									<cfelse>
											<tr  class="listaCorte3">
												#RepeatString('<td>&nbsp;</td>',3)#
											<cfset count = 1>
											<cfloop index = "colX" list = "#nombreColumnas#" delimiters = ",">
												<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,colX)><!--- indica si es visible----->
													<td align="center"  width="3%" nowrap="nowrap"><cf_translate  key="LB_#colX#">#replace(colX,"_nbsp_"," ","ALL")#</cf_translate></td>
												</cfif>
												<cfset count = count +1>
											</cfloop>
											<cfset corteDeColumnas =false>
											</tr>
											<cfoutput>
													<cfset count = 1>
													<tr  class="detaller">
														#RepeatString('<td>&nbsp;</td>',3)#
													<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
															<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
																	<cfif ArrayColumnas[ii][5] eq 'date'>
																		<td  align="right" nowrap="nowrap" ><cf_locale name="date" value='#evaluate("datos."&ArrayColumnas[ii][2])#'/></td>
																	<cfelseif ArrayColumnas[ii][5] eq 'money'>
																		<td  align="right"  nowrap="nowrap">#LSNumberFormat( evaluate("datos."&ArrayColumnas[ii][2]) ,',.00')#</td>
																			<cfif LEN(evaluate("datos.#ArrayColumnas[ii][2]#")) NEQ 0 >
																				<cfset Evaluate('Total_Corte1_#ArrayColumnas[ii][2]# = Total_Corte1_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																				<cfset Evaluate('Total_Corte2_#ArrayColumnas[ii][2]# = Total_Corte2_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																				<cfset Evaluate('Total_Final_#ArrayColumnas[ii][2]# = Total_Final_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
																			</cfif>
																	<cfelseif ArrayColumnas[ii][5] eq 'text'>
																		<td  align="left" nowrap="nowrap">#evaluate("datos."&ArrayColumnas[ii][2])# </td>
																	</cfif>
															</cfif>
															<cfset count = count +1>
													</cfloop>
													</tr>
											</cfoutput>
									</cfif>

									<tr class="total">
										#RepeatString('<td>&nbsp;</td>',2)#
									<td align="left" nowrap="nowrap">TOTAL #Evaluate('tituloCorte2')#</td>
									#RepeatString('<td>&nbsp;</td>',listlen(ListaAgrupado)-2)#

									<cfset count = 1>
									<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
											<cfif ArrayColumnas[count][6] eq 1  and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
													<cfif ArrayColumnas[ii][5] eq 'money'>
														<td  align="right"><b>#LSNumberFormat( evaluate("Total_Corte2_"&ArrayColumnas[ii][2]) ,',.00')#</b></td>
													<cfelse>
														<td  align="right">&nbsp;</td>
													</cfif>
											</cfif>
										<cfset count = count +1>
									</cfloop>

										<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
											<cfif ArrayColumnas[ii][5] eq 'money'>
												<cfset Evaluate( "Total_Corte2_#ArrayColumnas[ii][2]# = 0" ) />
											</cfif>
										</cfloop>
									</tr>
								</cfoutput>
					<!---------------------FIN NIVEL 2 -------------------------------------------------------------------->
					<cfelse>
							<tr  class="listaCorte3">
								#RepeatString('<td>&nbsp;</td>',2)#
							<cfset count = 1>
							<cfloop index = "colX" list = "#nombreColumnas#" delimiters = ",">
								<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,colX)><!--- indica si es visible----->
									<td align="center"  width="3%" nowrap="nowrap"><cf_translate  key="LB_#colX#">#replace(colX,"_nbsp_"," ","ALL")#</cf_translate></td>
								</cfif>
								<cfset count = count +1>
							</cfloop>
							<cfset corteDeColumnas =false>
							</tr>
							<cfoutput>
									<cfset count = 1>
									<tr  class="detaller">
										#RepeatString('<td>&nbsp;</td>',2)#
									<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
											<cfif ArrayColumnas[count][6] eq 1 and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
													<cfif ArrayColumnas[ii][5] eq 'date'>
														<td  align="right" nowrap="nowrap"><cf_locale name="date" value='#evaluate("datos."&ArrayColumnas[ii][2])#'/></td>
													<cfelseif ArrayColumnas[ii][5] eq 'money'>
														<td  align="right" nowrap="nowrap">#LSNumberFormat( evaluate("datos."&ArrayColumnas[ii][2]) ,',.00')#</td>
														<cfif LEN(evaluate("datos.#ArrayColumnas[ii][2]#")) NEQ 0 >
															<cfset Evaluate('Total_Corte1_#ArrayColumnas[ii][2]# = Total_Corte1_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
														</cfif>
														<cfif LEN(evaluate("datos.#ArrayColumnas[ii][2]#")) NEQ 0 >
															<cfset Evaluate('Total_Final_#ArrayColumnas[ii][2]# = Total_Final_#ArrayColumnas[ii][2]# + datos.#ArrayColumnas[ii][2]#')/>
														</cfif>
													<cfelseif ArrayColumnas[ii][5] eq 'text'>
														<td  align="left" nowrap="nowrap">#evaluate("datos."&ArrayColumnas[ii][2])# </td>
													</cfif>
											</cfif>
											<cfset count = count +1>
									</cfloop>
									</tr>
							</cfoutput>
					</cfif>

					<tr class="total">
						#RepeatString('<td>&nbsp;</td>',1)#
					<td align="left" nowrap="nowrap">TOTAL #Evaluate('tituloCorte1')#</td>
					#RepeatString('<td>&nbsp;</td>',listlen(ListaAgrupado)-1)#

					<cfset count = 1>
					<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
							<cfif ArrayColumnas[count][6] eq 1  and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
									<cfif ArrayColumnas[ii][5] eq 'money'>
										<td  align="right"><b>#LSNumberFormat( evaluate("Total_Corte1_"&ArrayColumnas[ii][2]) ,',.00')#</b></td>
									<cfelse>
										<td  align="right">&nbsp;</td>
									</cfif>
							</cfif>
						<cfset count = count +1>
					</cfloop>

						<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
							<cfif ArrayColumnas[ii][5] eq 'money'>
								<cfset Evaluate( "Total_Corte1_#ArrayColumnas[ii][2]# = 0" ) />
							</cfif>
						</cfloop>
					</tr>
				</cfoutput>

				<!----- ----------------------------------------------FINAL TOTALIZADO--------------------------------------------------------------->
				<tr class="total">
				<td align="left" nowrap="nowrap">
					<strong>
						TOTAL
					</strong>
				</td>
				<td>
					<!--- OPARRALES 2019-02-26 Se agrega total de registros general --->
					<cfif MostrarConteo>
						<strong>&nbsp;&nbsp;#datos.RecordCount# REGISTROS</strong>
					</cfif>
				</td>
				#RepeatString('<td>&nbsp;</td>',listlen(ListaAgrupado)-1)#

				<cfset count = 1>
				<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
						<cfif ArrayColumnas[count][6] eq 1  and not listfind(arguments.listasNoMostrar,ArrayColumnas[ii][2])><!--- indica si es visible----->
								<cfif ArrayColumnas[ii][5] eq 'money'>
									<td  align="right"><b>#LSNumberFormat( evaluate("Total_Final_"&ArrayColumnas[ii][2]) ,',.00')#</b></td>
								<cfelse>
									<td  align="right">&nbsp;</td>
								</cfif>
						</cfif>
					<cfset count = count +1>
				</cfloop>

					<cfloop from="1" to="#arrayLen(ArrayColumnas)#" index="ii">
						<cfif ArrayColumnas[ii][5] eq 'money'>
							<cfset Evaluate( "Total_Final_#ArrayColumnas[ii][2]# = 0" ) />
						</cfif>
					</cfloop>
				</tr>

				</table>


			</cfif>

	</cffunction>

</cfcomponent>