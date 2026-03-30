<cfif IsDefined("form.Cambio") or  IsDefined("form.Alta")>
	<!--- Proceso para crear la hora --->

	<cfset HORAF 	= FORM.HORAFIN>
	<cfset MINUTOF 	= FORM.MINUTOSFIN>
	<cfif FORM.PMAMFIN eq 'PM' and compare(HORAF,'12') neq 0>
		<cfset HORAF = HORAF + 12 >
	<cfelseif FORM.PMAMFIN eq 'AM' and compare(HORAF,'12') eq 0 >
		<cfset HORAF = 0 >
	</cfif>

    <CFSET HORADEFIN = CreateDateTime(#YEAR(LSParseDateTime(Form.FechaC))#,#MONTH(LSParseDateTime(Form.FechaC))#,#DAY(LSParseDateTime(Form.FechaC))#, HORAF,MINUTOF,0)>
</cfif>

    <!---ljimenez se crea esta seccion de codigo para actualizar la informacion ya registrada en la tabla RHConcursos para la hora fin
    ya esta se modifico a la hora que se regitra
    <cfquery name="xxx" datasource="#Session.DSN#">
	    select RHCconcurso,RHCfcierre,year(RHCfcierre) as aa,month(RHCfcierre) as mes,day(RHCfcierre) as dd,datepart(Hh,horafin) as hh, datepart(Mi,horafin) as mm
    	from RHConcursos
    </cfquery>
    <cfloop query="xxx">
    	<CFSET HORADEFIN = 	CreateDateTime(#YEAR(xxx.RHCfcierre)#,#MONTH(xxx.RHCfcierre)#,#DAY(xxx.RHCfcierre)#, #xxx.hh#,#xxx.mm#,0)>
        <cfquery name="updRHConcursos" datasource="#Session.DSN#">
				update RHConcursos set
					horafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#HORADEFIN#">
				where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#xxx.RHCconcurso#">
			</cfquery>
    </cfloop>
    <cf_dump var="#xxx#">
    --->


<cfif isdefined ("Form.flag") and isdefined("Anterior")>
	<cfset Form.paso = 0>
	<cfset Form.flag = 1>
</cfif>

<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfset estado = 15>
			<cfquery name="insConcursos" datasource="#Session.DSN#">
				insert INTO RHConcursos (Ecodigo, RHCcodigo, RHCdescripcion, CFid, RHCfecha, RHPcodigo, RHCcantplazas,
										RHCfapertura, RHCfcierre, RHCmotivo, RHCotrosdatos,
										<cfif not isdefined("Form.flag")>RHCestado,</cfif>Usucodigo, BMUsucodigo,horafin
                                        ,RHCexterno<!--- ,RHCsedetrabajo,RHCtipocontrato --->)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHCcodigo#">)),
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCdescripcion#">)),
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#Form.INFecha#">,
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">)),
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCcantplazas#">,
					 <cfif not isdefined("Form.flag")>
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaA)#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaC)#">,
					 <cfelse>
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 </cfif>
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mot#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCotrosdatos#">,
					 <cfif not isdefined("Form.Flag")><cfqueryparam cfsqltype="cf_sql_integer" value="#estado#">,</cfif>
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#HORADEFIN#">
                     ,<cfif isdefined('form.RHCexterno')> 1 <cfelse> 0 </cfif>
                     <!--- ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCsedetrabajo#">
                     ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCtipocontrato#"> --->
                     )
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insConcursos">

			<cf_translatedata name="set" tabla="RHConcursos" col="RHCdescripcion" valor="#form.RHCdescripcion#" filtro="RHCconcurso = #insConcursos.identity#">
			<!---
			<cf_translatedata name="set" tabla="RHConcursos" col="RHCsedetrabajo" valor="#form.RHCsedetrabajo#" filtro="RHCconcurso = #insConcursos.identity#">
			<cf_translatedata name="set" tabla="RHConcursos" col="RHCtipocontrato" valor="#form.RHCtipocontrato#" filtro="RHCconcurso = #insConcursos.identity#">
			--->
			<cf_translatedata name="set" tabla="RHConcursos" col="RHCotrosdatos" valor="#form.RHCotrosdatos#" filtro="RHCconcurso = #insConcursos.identity#">

			<cfset Form.RHCconcurso = insConcursos.identity>
			<cfquery name="rsRHHabilidadesConcursoIns" datasource="#session.DSN#">
				insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin, Usucodigo,
													RHCPpeso, BMUsucodigo)
				select #insConcursos.identity#, RHHid, 'H' as tipocompetencia, #session.Ecodigo#,
						coalesce (RHNnotamin,0)as RHNnotamin,
					   #Session.Usucodigo#, coalesce(RHHpeso,0) as RHHpeso, #Session.Usucodigo#
				from RHHabilidadesPuesto
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.RHPcodigo)#">
			</cfquery>
			<cfquery name="rsRHConocimientosConcursoIns" datasource="#session.DSN#">
				insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin, Usucodigo,
													RHCPpeso, BMUsucodigo)
				select #insConcursos.identity#, RHCid, 'C' as tipocompetencia, #session.Ecodigo#,
				coalesce (RHCnotamin,0) as RHCnotamin,
				#Session.Usucodigo#, coalesce (RHCpeso,0) as RHCpeso, #Session.Usucodigo#
				from RHConocimientosPuesto
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.RHPcodigo)#">
			</cfquery>

			<cfquery name="rsPruebasComp" datasource="#session.DSN#">
				select  distinct RHPcodigopr, count (RHPcodigopr) as cant
				from RHCompetenciasConcurso a inner join  RHPruebasCompetencia b
					on  a.Ecodigo 		  = b.Ecodigo
					and a.Idcompetencia   = b.id
					and a.tipocompetencia = b.RHPCtipo
				where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				group by b.RHPcodigopr
			</cfquery>
			<cfif isdefined("rsPruebasComp") and rsPruebasComp.RecordCount GT 0>
				<cfquery name="rsPeso" dbtype="query">
					select sum(cant) as total
					from rsPruebasComp
				</cfquery>
				<cfset peso = (1/rsPeso.total) * 100>
				<cfquery name="insRHPruebasConcurso" datasource="#session.DSN#">
					<cfloop query="rsPruebasComp">
						insert into RHPruebasConcurso (RHCconcurso, Ecodigo, RHPcodigopr, Cantidad, Peso, BMUsucodigo)
						values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsPruebasComp.RHPcodigopr#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPruebasComp.cant#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#(peso * rsPruebasComp.cant)#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
					</cfloop>
				</cfquery>
			</cfif>

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delRHCalificaCompPrueOfer" datasource="#Session.DSN#">
				delete from RHCalificaCompPrueOfer
				where exists (
					select 1
					from RHConcursantes a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
					  and a.Ecodigo = RHCalificaCompPrueOfer.Ecodigo
					  and a.RHCPid = RHCalificaCompPrueOfer.RHCPid
				)
			</cfquery>

			<cfquery name="delRHCalificaPrueConcursante" datasource="#Session.DSN#">
				delete from RHCalificaPrueConcursante
				where exists (
					select 1
					from RHConcursantes a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
					  and a.Ecodigo = RHCalificaPrueConcursante.Ecodigo
					  and a.RHCPid = RHCalificaPrueConcursante.RHCPid
				)
			</cfquery>

			<cfquery name="delRHCalificaAreaConcursante" datasource="#Session.DSN#">
				delete from RHCalificaAreaConcursante
				where exists (
					select 1
					from RHConcursantes a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
					  and a.Ecodigo = RHCalificaAreaConcursante.Ecodigo
					  and a.RHCPid = RHCalificaAreaConcursante.RHCPid
				)
			</cfquery>

			<cfquery name="delRHConcursantes" datasource="#Session.DSN#">
				delete from RHConcursantes
				where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>
			<cfquery  datasource="#Session.DSN#">
				delete from RHPaisesConcurso
				where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			<cfquery  datasource="#Session.DSN#">
				delete from RHEmpresasCorpConcurso
				where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			<cfquery  datasource="#Session.DSN#">
				delete from RHAcciones
				where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			<cfquery  datasource="#Session.DSN#">
				delete from DLaboralesEmpleado
				where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			<cfquery name="delRHCompetenciasConcurso" datasource="#Session.DSN#">
				delete from RHCompetenciasConcurso
				where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			<cfquery name="delRHPlazasConcurso" datasource="#Session.DSN#">
				delete from RHPlazasConcurso
				where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			 <cfquery name="delRHAreasEvalConcurso" datasource="#Session.DSN#">
				delete from RHAreasEvalConcurso
				where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			<cfquery name="delRHPruebasConcurso" datasource="#session.DSN#">
				delete from RHPruebasConcurso
				where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			<cfquery name="delRHConcursos" datasource="#Session.DSN#">
				delete from RHConcursos
				where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>
			<cfset Form.RHCconcurso = 0>
			<cfset Form.paso = 0>

		<cfelseif isdefined("Form.Cambio")>
			 <cfquery name="rsBuscaPuestoActual" datasource="#Session.DSN#">
				select RHPcodigo
				from RHConcursos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			<cf_dbtimestamp
				datasource="#session.DSN#"
				table="RHConcursos"
				redirect="ConcursosMng.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
				field2="RHCconcurso" type2="numeric" value2="#Form.RHCconcurso#">

			<cfquery name="updRHConcursos" datasource="#Session.DSN#">
				update RHConcursos set
					RHCcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHCcodigo#">,
					RHCdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCdescripcion#">,
					CFid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
					RHCfecha		= <cfqueryparam cfsqltype="cf_sql_date" value="#Form.INFecha#">,
					RHPcodigo		= rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">)),
					RHCcantplazas 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCcantplazas#">,
					<cfif not isdefined("form.flag")>
					RHCfapertura	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaA)#">,
					RHCfcierre		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaC)#">,
					</cfif>
					RHCmotivo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mot#">,
					RHCotrosdatos	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCotrosdatos#">,
					BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					horafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#HORADEFIN#">
					,RHCexterno 	= <cfif isdefined('form.RHCexterno')> 1 <cfelse> 0 </cfif>
                    <!---
                    ,RHCsedetrabajo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCsedetrabajo#">
                    ,RHCtipocontrato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCtipocontrato#"> --->
                    where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

			<cf_translatedata name="set" tabla="RHConcursos" col="RHCdescripcion" valor="#form.RHCdescripcion#" filtro="RHCconcurso = #form.RHCconcurso#">
			<!--- <cf_translatedata name="set" tabla="RHConcursos" col="RHCsedetrabajo" valor="#form.RHCsedetrabajo#" filtro="RHCconcurso = #form.RHCconcurso#">
			<cf_translatedata name="set" tabla="RHConcursos" col="RHCtipocontrato" valor="#form.RHCtipocontrato#" filtro="RHCconcurso = #form.RHCconcurso#"> --->
			<cf_translatedata name="set" tabla="RHConcursos" col="RHCotrosdatos" valor="#form.RHCotrosdatos#" filtro="RHCconcurso = #form.RHCconcurso#">

			<cfif rtrim(rsBuscaPuestoActual.RHPcodigo) NEQ rtrim(form.RHPcodigo)>
			<!--- Al poder modificarse el puesto deben borrarse las competencias del concurso y volverlas a insertar para aegurarse
				  de tener actualizados los datos en el paso 3 --->
				<cfquery name="delRHPlazasConcurso" datasource="#session.DSN#">
					delete from RHPlazasConcurso
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				</cfquery>
				<cfquery name="delRHAreasEvalConcurso" datasource="#Session.DSN#">
					delete from RHAreasEvalConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
				<cfquery name="delRHCompetenciasPlaza" datasource="#Session.DSN#">
					delete from RHCompetenciasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
				<cfquery name="rsRHHabilidadesConcursoIns" datasource="#session.DSN#">
					<!--- preguntar si se pueden inicializar peso, notamin en 0 si no están para que no MFT el insert --->
					insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin, Usucodigo,
														RHCPpeso, BMUsucodigo)
					select #form.RHCconcurso#, RHHid, 'H' as tipocompetencia, #session.Ecodigo#, coalesce (RHNnotamin,0) as RHNnotamin,
					#Session.Usucodigo#, coalesce (RHHpeso,0) as RHHpeso, #Session.Usucodigo#
					from RHHabilidadesPuesto
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.RHPcodigo)#">
				</cfquery>
				<cfquery name="rsRHConocimientosConcursoIns" datasource="#session.DSN#">
					insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin,
														Usucodigo, RHCPpeso, BMUsucodigo)
					select #form.RHCconcurso#, RHCid, 'C' as tipocompetencia, #session.Ecodigo#, coalesce (RHCnotamin,0) as RHCnotamin,
					#Session.Usucodigo#, coalesce (RHCpeso,0) as RHCpeso, #Session.Usucodigo#
					from RHConocimientosPuesto
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.RHPcodigo)#">
				</cfquery>
			</cfif>

		<cfelseif isdefined("Form.Publicar")>
			<cf_dbtimestamp
				datasource="#session.DSN#"
				table="RHConcursos"
				redirect="ConcursosMng.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
				field2="RHCconcurso" type2="numeric" value2="#Form.RHCconcurso#">

			<cfquery name="updRHConcursos" datasource="#Session.DSN#">
				update RHConcursos set
					RHCestado 	 = 50,
					BMUsucodigo	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>

		<cfelseif isdefined("Form.Aplicar")>
			<cf_dbtimestamp
				datasource="#session.DSN#"
				table="RHConcursos"
				redirect="ConcursosMng.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
				field2="RHCconcurso" type2="numeric" value2="#Form.RHCconcurso#">

			<!---
				Validar que todos los concursantes externos no se hayan convertido en empleados
				Si el oferente ya se convirtió en empleado por algún proceso anterior, entonces se actualiza el
				código de empleado en el concurso para que ya no se siga utilizando el código del oferente
			--->
			<cfquery name="rsOferentes" datasource="#Session.DSN#">
				select a.RHCPid, b.DEid
				from RHConcursantes a, DatosOferentes b
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				and b.RHOid = a.RHOid
				and b.DEid is not null
			</cfquery>

			<cfloop query="rsOferentes">
				<cfquery name="updConcursante" datasource="#Session.DSN#">
					update RHConcursantes set
						RHCPtipo = 'I',
						DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOferentes.DEid#">
					where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
					and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOferentes.RHCPid#">
				</cfquery>
			</cfloop>
			<cfquery name="rsCPlazas" datasource="#session.dsn#">
				select count(1) as cantidad from RHPlazasConcurso where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2115" default="" returnvariable="Lvar"/>
			<cfif isdefined ('rsCPlazas') and rsCPlazas.cantidad gt 0>
				<cfquery name="updRHConcursos" datasource="#Session.DSN#">
					update RHConcursos set
						RHCestado 	 = 70,
						BMUsucodigo	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
			<cfelseif Lvar eq 1>
				<cfquery name="updRHConcursos" datasource="#Session.DSN#">
					update RHConcursos set
						RHCestado 	 = 70,
						BMUsucodigo	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
			<cfelse>
				<cfquery name="updRHConcursos" datasource="#Session.DSN#">
					update RHConcursos set
						RHCestado 	 = 80,
						BMUsucodigo	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
			</cfif>

		<form name="form1" method="post" action="ConcursoMng-lista.cfm">
        </form>
        <HTML>
          <head>
          </head>
          <body>
            <script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
          </body>
        </HTML>
	</cfif>
	</cfif>
</cftransaction>
