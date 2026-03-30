<cfcomponent>
	<cffunction name="getActivo" access="public" returntype="query">
		<cfargument name="Aid" type="numeric" required="no">
		<cfargument name="ecodigo" type="numeric" required="no" default="#session.ecodigo#">
		<!--- validaciones iniciales --->
		<cfif len(trim(arguments.aid)) lte 0 and len(trim(arguments.aplca)) lte 0>
			<cf_errorCode	code = "50810" msg = "Error en getActivo, debe invocar esta función enviando uno de dos parámetros, Aid o Aplaca, Proceso Cancelado.">
		</cfif>

		<!--- Consulta del Periodo Auxiliar --->
		<cfquery name="rsPeriodoAuxiliar" datasource="#session.dsn#">
			select Pvalor as value
			from Parametros
			where Ecodigo =  #session.ecodigo#
				and Pcodigo = 50
		</cfquery>
		<cfif rsPeriodoAuxiliar.RecordCount eq 0>
			<cf_errorCode	code = "50811" msg = "Error en Activo, no se encontró el Periodo de Auxiliares">
		</cfif>
		<cfset periodoAuxiliar = rsPeriodoAuxiliar.value>

		<!--- Consulta del Mes Auxiliar --->
		<cfquery name="rsMesAuxiliar" datasource="#session.dsn#">
			select Pvalor as value
			from Parametros
			where Ecodigo =  #session.ecodigo#
				and Pcodigo = 60
		</cfquery>
		<cfif rsMesAuxiliar.RecordCount eq 0>
			<cf_errorCode	code = "50812" msg = "Error en Activo, no se encontró el Mes de Auxiliares">
		</cfif>
		<cfset mesAuxiliar = rsMesAuxiliar.value>


		<cfquery name="myResult" datasource="#session.dsn#">
			select
				a.Aid, a.Ecodigo, a.SNcodigo, a.ARcodigo, a.Adescripcion,
                <!---Inicia Cambio por Entrada y Salida de Activos 25/06/2014 RVD--->
                case when (a.AEntradaSalida = 1) then 'Devuelto'
	            when (a.AEntradaSalida = 2) then 'Fuera'
	            when (a.AEntradaSalida = 3) then 'Fuera por Comodato'
	            when (a.AEntradaSalida = 4) then 'Devuelto por Comodato'
                when (a.AEntradaSalida = 0) then 'Sin Salidas' end  as TipoMovimiento,
                case when (a.AEntradaSalida <> 0)
                then  (select Max(Fecha) as Fecha from AFEntradaSalidaE a inner join AFEntradaSalidaD b on a.AFESid = b.AFESid
                where b.Aid =  #arguments.aid#
                and a.Ecodigo = b.Ecodigo
                and a.Ecodigo = #arguments.ecodigo#
                and a.Aplicado = 1
                ) end as Fecha,
				<!---Fin Cambio por Entrada y Salida de Activos 25/06/2014 RVD--->
				a.Aserie, a.Aplaca, a.Astatus, a.Aid_padre, a.Areflin,
				a.Afechainidep, a.Afechainirev, a.Avutil, a.Avalrescate, a.Afechaaltaadq, 0.00 as Amontoadq,
				Afechaaltaadq as Afechaadq,
				b.AFMid, b.AFMcodigo, b.AFMdescripcion, b.AFMuso,
				c.AFMMid, c.AFMMcodigo, c.AFMMdescripcion,
				d.AFCcodigo, d.AFCcodigopadre, d.AFCcodigoclas,
				d.AFCdescripcion, d.AFCpath, d.AFCnivel,
				e.ACcodigo, e.ACid, e.ACcodigodesc, e.ACdescripcion, e.ACvutil, e.ACdepreciable, e.ACrevalua,
				e.ACcsuperavit, e.ACcadq, e.ACcdepacum, e.ACcrevaluacion,
				e.ACcdepacumrev, e.ACgastodep, e.ACgastorev, e.ACtipo,
				e.ACvalorres, e.cuentac as ACcuentac,
				f.ACcodigodesc as ACCcodigodesc, f.ACdescripcion as ACCdescripcion,
				f.ACvutil as ACCvutil, f.ACcatvutil as ACCcatvutil,
				f.ACmetododep as ACCmetododep, f.ACmascara as ACCmascara,
				f.cuentac as ACCcuentac,
				((select min(g.SNnombre) from SNegocios g where g.Ecodigo = a.Ecodigo and g.SNcodigo = a.SNcodigo)) as SNnombre,
				<!--- Inicia Cambio  para Inf. General del reporte de Activos para que muestre las Factura RVD--->
				case when a.Factura is null then
				((select min(EAcpdoc) from DSActivosAdq x where x.lin = a.Areflin))
				else a.Factura end as Documento,
				<!--- Inicia Cambio  para Inf. General del reporte de Activos para que muestre las Factura RVD--->
				coalesce((
					select min(s.AFSsaldovutiladq)
					from AFSaldos s <cf_dbforceindex name="AFSaldos01">
					where s.Aid        = a.Aid
					  and s.Ecodigo    = a.Ecodigo
					  and s.AFSperiodo = #periodoAuxiliar#
	  				  and s.AFSmes     = #mesAuxiliar#
				), 0) as AFSsaldovutiladq,

				 coalesce(
				 (Select ec1.Cconcepto
				 from HEContables ec1
						inner join TransaccionesActivos TA
							on ec1.IDcontable = TA.IDcontable
				 where TA.Aid = a.Aid and IDtrans = 1 ),

				 (Select ec1.Cconcepto
				 from EContables ec1
						inner join TransaccionesActivos TA
						   on ec1.IDcontable = TA.IDcontable
				 where TA.Aid = a.Aid and IDtrans = 1)) as ECAsiento,

				 coalesce(
				 (Select ec2.Edocumento
				 from HEContables ec2
						inner join TransaccionesActivos TA
							on ec2.IDcontable = TA.IDcontable
				 where TA.Aid = a.Aid and IDtrans = 1),

				 (Select ec2.Edocumento
				 from EContables ec2
						inner join TransaccionesActivos TA
							on ec2.IDcontable = TA.IDcontable
				 where TA.Aid = a.Aid and IDtrans = 1)) as ECPoliza,

				coalesce(
				(Select ec3.Ereferencia
				 from HEContables ec3
						inner join TransaccionesActivos TA
							on ec3.IDcontable = TA.IDcontable
				 where TA.Aid = a.Aid and IDtrans = 1),

				 (Select ec3.Ereferencia
				 from EContables ec3
						inner join TransaccionesActivos TA
							on ec3.IDcontable = TA.IDcontable
				 where TA.Aid = a.Aid and IDtrans = 1)) as ECReferencia

				<!--- Inclusion de numero de asiento, poliza y referencia --->
			from Activos a
				LEFT OUTER JOIN AFMarcas b
				on b.AFMid = a.AFMid

				LEFT OUTER JOIN AFMModelos c
				on c.AFMMid = a.AFMMid

				LEFT OUTER JOIN AFClasificaciones d
				on d.Ecodigo = a.Ecodigo
				and d.AFCcodigo = a.AFCcodigo
				inner join AClasificacion e
					inner join ACategoria f
						on f.Ecodigo = e.Ecodigo
						and f.ACcodigo = e.ACcodigo
				on e.Ecodigo = a.Ecodigo
				and e.ACid = a.ACid
				and e.ACcodigo = a.ACcodigo
			where
			<cfif len(trim(arguments.aid)) gt 0>
				a.Aid = #arguments.aid#
			</cfif>
			and a.Ecodigo = #arguments.ecodigo#
		</cfquery>
		<cfif myResult.RecordCount eq 0>
			<cf_errorCode	code = "50813" msg = "Error en Activo.getActivo, no se encontró el Activo">
		</cfif>
		<cfquery name="myResult2" datasource="#session.dsn#">
			select coalesce(min(TAfecha),<cf_dbfunction name="now">) as Afechaadq, coalesce(sum(TAmontolocadq),0.00) as Amontoadq
			from TransaccionesActivos
			where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myResult.aid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">
			and IDtrans = 1
		</cfquery>
		<cfif myResult2.RecordCount eq 0>
			<cf_errorCode	code = "50814" msg = "Error en Activo.getActivo, no se encontró la Transacción de Adquisición del Activo">
		</cfif>
		<!---<cfset querysetcell(myResult,"Afechaadq",myResult2.Afechaadq)>--->
		<cfset querysetcell(myResult,"Amontoadq",myResult2.Amontoadq)>
		<!--- resultados--->
		<cfreturn myResult>
	</cffunction>

	<cffunction name="getCurrentAnotacion" access="public" returntype="query">
		<cfargument name="Aid" type="numeric" required="yes">
		<cfargument name="ecodigo" type="numeric" required="no" default="#session.ecodigo#">
		<cfquery name="myResult" datasource="#session.dsn#" maxrows="1">
			select AFAlinea, AFAtipo, AFAfecha, AFAtexto, AFAfecha1, AFAfecha2
			from AFAnotaciones
			where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between AFAfecha1 and AFAfecha2
			order by AFAfecha desc
		</cfquery>
		<!--- resultados--->
		<cfreturn myResult>
	</cffunction>

	<cffunction name="getCurrentSaldos" access="public" returntype="struct">
		<cfargument name="Aid" type="numeric" required="yes">
		<cfargument name="Periodo" type="numeric" required="no" default="-1">
		<cfargument name="Mes" type="numeric" required="no" default="-1">
		<cfargument name="ecodigo" type="numeric" required="no" default="#session.ecodigo#">

		<cfif arguments.Periodo eq -1>
			<cfquery name="myResult" datasource="#session.dsn#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as value
				from Parametros
				where Ecodigo =  #session.ecodigo#
					and Pcodigo = 50
			</cfquery>
			<cfif myResult.RecordCount eq 0>
				<cf_errorCode	code = "50811" msg = "Error en Activo, no se encontró el Periodo de Auxiliares">
			</cfif>
			<cfset arguments.Periodo = myResult.value>
		</cfif>
		<cfif arguments.Mes eq -1>
			<cfquery name="myResult" datasource="#session.dsn#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as value
				from Parametros
				where Ecodigo =  #session.ecodigo#
					and Pcodigo = 60
			</cfquery>
			<cfif myResult.RecordCount eq 0>
				<cf_errorCode	code = "50812" msg = "Error en Activo, no se encontró el Mes de Auxiliares">
			</cfif>
			<cfset arguments.Mes = myResult.value>
		</cfif>
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfquery name="myResultQry" datasource="#session.dsn#">
			select  c.Edescripcion,a.CFid,b.CFcodigo,b.CFdescripcion, a.AFCcodigo, a.ACid, a.ACcodigo, a.AFSperiodourev,
					a.AFSmesurev, a.AFSperiodo, a.AFSmes, a.AFSvutiladq, a.AFSvutilrev,
					a.AFSsaldovutiladq, a.AFSsaldovutilrev, a.AFSvaladq, a.AFSvalmej,
					a.AFSvalrev, a.AFSdepacumadq, a.AFSdepacummej, a.AFSdepacumrev,
					a.AFSmetododep, a.AFSdepreciable, a.AFSrevalua, a.Ocodigo,o.Oficodigo, o.Odescripcion,
				(a.AFSvaladq + a.AFSvalmej + a.AFSvalrev) - (a.AFSdepacumadq + a.AFSdepacummej + a.AFSdepacumrev) as AFSvallibros, '' as AFSmesenletras,

                case when  d.DEid is Not null then de.DEidentificacion #_Cat#' '#_Cat# de.DEnombre #_Cat# ' ' #_Cat# de.DEapellido1 #_Cat# ' ' #_Cat# de.DEapellido2
                	when UltimoDEid.DEid is not null then deUltimo.DEidentificacion #_Cat#' '#_Cat# deUltimo.DEnombre #_Cat# ' ' #_Cat# deUltimo.DEapellido1 #_Cat# ' ' #_Cat# deUltimo.DEapellido2
                else 'No definido' end

                as empleado
			from AFSaldos a
			inner join CFuncional b
				on   a.CFid = b.CFid
				and  a.Ecodigo = b.Ecodigo
			inner join Empresas c
				on  a.Ecodigo = c.Ecodigo
			inner join Oficinas o
				 on a.Ocodigo  = o.Ocodigo
				and a.Ecodigo  = o.Ecodigo
			left outer join AFResponsables d
				on 	a.Ecodigo = d.Ecodigo
				and a.Aid = d.Aid
				and a.CFid = d.CFid
				and (<cf_dbfunction name="now"> >= d.AFRfini and <cf_dbfunction name="now"> <= d.AFRffin)
            <!---Ultimo Responsables--->
            left outer join AFResponsables UltimoDEid
				 on a.Aid = UltimoDEid.Aid
				and UltimoDEid.AFRffin = (select Max(AFRffin) from AFResponsables where Aid = a.Aid)
			left outer join DatosEmpleado deUltimo
				on 	UltimoDEid.DEid = deUltimo.DEid

			left outer join DatosEmpleado de
				on 	d.DEid = de.DEid
			where a.Aid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.aid#">
			and a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">
			and a.AFSperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			and a.AFSmes = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#arguments.mes#">
		</cfquery>
		<cfif myResultQry.recordcount>
			<cfquery name="myResult2" datasource="#session.dsn#">
				select VSdesc
				from VSidioma a
					inner join Idiomas b
					on a.Iid = b.Iid
					and b.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">
				where a.VSgrupo = 1
					and VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.mes#">
			</cfquery>
			<cfset QuerySetCell(myResultQry,"AFSmesenletras",myResult2.VSdesc,1)>
		</cfif>
		<!--- resultados--->
		<cfset myResult = StructNew()>
		<cfset StructInsert(myResult,"query",myResultQry)>
		<cfset StructInsert(myResult,"periodo",Periodo)>
		<cfset StructInsert(myResult,"mes",Mes)>
		<cfreturn myResult>
	</cffunction>

	<cffunction name="getTransaccionesByIDtrans" access="public" returntype="query">
		<cfargument name="Aid" type="numeric" required="yes">
		<cfargument name="IDtrans" type="numeric" required="yes">
		<cfargument name="Periodoini" type="numeric" required="no" default="0"><!--- 0 => todos --->
		<cfargument name="Mesini" type="numeric" required="no" default="0"><!--- 0 => todos --->
		<cfargument name="Periodofin" type="numeric" required="no" default="0"><!--- 0 => todos --->
		<cfargument name="Mesfin" type="numeric" required="no" default="0"><!--- 0 => todos --->
		<cfargument name="ecodigo" type="numeric" required="no" default="#session.ecodigo#">

		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfquery name="myResult" datasource="#session.dsn#">
			select TAid, TAperiodo, TAmes, TAfecha, TAfalta,
				coalesce (TAmontooriadq , 0.00) as TAmontooriadq,
				coalesce (TAmontoorimej , 0.00) as TAmontoorimej,
				coalesce (TAmontoorirev , 0.00) as TAmontoorirev,
				coalesce (<cfif arguments.idtrans eq 8>-1*</cfif>TAmontolocadq , 0.00) as TAmontolocadq,
				coalesce (<cfif arguments.idtrans eq 8>-1*</cfif>TAmontolocmej , 0.00) as TAmontolocmej,
				coalesce (<cfif arguments.idtrans eq 8>-1*</cfif>TAmontolocrev , 0.00) as TAmontolocrev,
				coalesce (<cfif arguments.idtrans eq 8>-1*</cfif>TAmontodepadq , 0.00) as TAmontodepadq,
				coalesce (<cfif arguments.idtrans eq 8>-1*</cfif>TAmontodepmej , 0.00) as TAmontodepmej,
				coalesce (<cfif arguments.idtrans eq 8>-1*</cfif>TAmontodeprev , 0.00) as TAmontodeprev,
				coalesce (<cfif arguments.idtrans eq 8>-1*</cfif>TAsuperavit , 0.00) as TAsuperavit,
				Mcodigo, TAtipocambio, TransaccionesActivos.IDcontable, Ccuenta, TransaccionesActivos.CFid,
				rtrim(cf.CFcodigo) #_Cat# '-' #_Cat# cf.CFdescripcion as CFcodigo, ADTPrazon,TAvutil,
				AplacaAnt, AplacaNueva,
				<!--- Inclusion de numero de asiento, poliza y referencia --->

				coalesce(
					(Select ec1.Cconcepto
           			 from HEContables ec1
           			 where ec1.IDcontable = TransaccionesActivos.IDcontable),
					(Select ec1.Cconcepto
           			 from EContables ec1
          			 where ec1.IDcontable = TransaccionesActivos.IDcontable) )
					 as ECAsiento,

				coalesce(
					(Select ec2.Edocumento
           			 from HEContables ec2
           			 where ec2.IDcontable = TransaccionesActivos.IDcontable),
					(Select ec2.Edocumento
           			 from EContables ec2
          			 where ec2.IDcontable = TransaccionesActivos.IDcontable) )
					 as ECPoliza ,

				coalesce(
					(Select ec3.Ereferencia
           			 from HEContables ec3
           			 where ec3.IDcontable = TransaccionesActivos.IDcontable),
					(Select ec3.Ereferencia
           			 from EContables ec3
          			 where ec3.IDcontable = TransaccionesActivos.IDcontable) )
					 as ECReferencia,
 				 coalesce (
					 (Select max(AFSsaldovutiladq)
					 from AFSaldos afs
					 where afs.Aid=TransaccionesActivos.Aid
					 and afs.Ecodigo=TransaccionesActivos.Ecodigo
					 and afs.AFSperiodo=TransaccionesActivos.TAperiodo
					 and afs.AFSmes=TransaccionesActivos.TAmes),TAvutil) as AFSsaldovutiladq
				<!--- Inclusion de numero de asiento, poliza y referencia --->
			from TransaccionesActivos
				inner join CFuncional cf
					on cf.CFid = TransaccionesActivos.CFid
			where TransaccionesActivos.Aid     = #arguments.aid#
			  and TransaccionesActivos.Ecodigo = #arguments.ecodigo#
			  and TransaccionesActivos.IDtrans = #arguments.idtrans#
			<cfif arguments.periodoini gt 0 and arguments.mesini gt 0>
				and (TAperiodo > #arguments.periodoini#
				or  (TAperiodo = #arguments.periodoini# and TAmes >= #arguments.mesini#))
			</cfif>
			<cfif arguments.periodofin gt 0 and arguments.mesfin gt 0>
				and (TAperiodo < #arguments.periodofin#
				or  (TAperiodo = #arguments.periodofin# and TAmes <= #arguments.mesfin#))
			</cfif>
			<cfif arguments.idtrans eq 8>
			union all
			select
				TAid, TAperiodo, TAmes, TAfecha, TAfalta,
				coalesce (TAmontooriadq, 0.00) as TAmontooriadq,
				coalesce (TAmontoorimej, 0.00) as TAmontoorimej,
				coalesce (TAmontoorirev, 0.00) as TAmontoorirev,
				coalesce (TAmontolocadq, 0.00) as TAmontolocadq,
				coalesce (TAmontolocmej, 0.00) as TAmontolocmej,
				coalesce (TAmontolocrev, 0.00) as TAmontolocrev,
				coalesce (TAmontodepadq, 0.00) as TAmontodepadq,
				coalesce (TAmontodepmej, 0.00) as TAmontodepmej,
				coalesce (TAmontodeprev, 0.00) as TAmontodeprev,
				coalesce (TAsuperavit, 0.00) as TAsuperavit,
				Mcodigo, TAtipocambio, TransaccionesActivos.IDcontable, Ccuenta, TransaccionesActivos.CFid,
				rtrim(cf.CFcodigo) #_Cat# '-' #_Cat# cf.CFdescripcion as CFcodigo, ADTPrazon, TAvutil,
				AplacaAnt, AplacaNueva,
				<!--- Inclusion de numero de asiento, poliza y referencia --->
				coalesce(
					(Select ec1.Cconcepto
           			 from HEContables ec1
           			 where ec1.IDcontable = TransaccionesActivos.IDcontable),
					(Select ec1.Cconcepto
           			 from EContables ec1
          			 where ec1.IDcontable = TransaccionesActivos.IDcontable) )
					 as ECAsiento,

				coalesce(
					(Select ec2.Edocumento
           			 from HEContables ec2
           			 where ec2.IDcontable = TransaccionesActivos.IDcontable),
					(Select ec2.Edocumento
           			 from EContables ec2
          			 where ec2.IDcontable = TransaccionesActivos.IDcontable) )
					 as ECPoliza ,

				coalesce(
					(Select ec3.Ereferencia
           			 from HEContables ec3
           			 where ec3.IDcontable = TransaccionesActivos.IDcontable),
					(Select ec3.Ereferencia
           			 from EContables ec3
          			 where ec3.IDcontable = TransaccionesActivos.IDcontable) )
					 as ECReferencia,

				 coalesce (
					 (Select max(AFSsaldovutiladq)
					 from AFSaldos afs
					 where afs.Aid=TransaccionesActivos.Aid
					 and afs.Ecodigo=TransaccionesActivos.Ecodigo
					 and afs.AFSperiodo=TransaccionesActivos.TAperiodo
					 and afs.AFSmes=TransaccionesActivos.TAmes),TAvutil) as AFSsaldovutiladq
				<!--- Inclusion de numero de asiento, poliza y referencia --->
			from TransaccionesActivos
				inner join CFuncional cf
					on cf.CFid = TransaccionesActivos.CFid
			where TransaccionesActivos.Aiddestino = #arguments.aid#
			  and TransaccionesActivos.Ecodigo = #arguments.ecodigo#
			  and TransaccionesActivos.IDtrans = #arguments.idtrans#
			<cfif arguments.periodoini gt 0 and arguments.mesini gt 0>
				and (TAperiodo > #arguments.periodoini#
				or  (TAperiodo = #arguments.periodoini# and TAmes >= #arguments.mesini#))
			</cfif>
			<cfif arguments.periodofin gt 0 and arguments.mesfin gt 0>
				and (TAperiodo < #arguments.periodofin#
				or  (TAperiodo = #arguments.periodofin# and TAmes <= #arguments.mesfin#))
			</cfif>
			</cfif>
			order by TAperiodo, TAmes asc
		</cfquery>

		<!--- resultados--->
		<cfreturn myResult>
	</cffunction>
</cfcomponent>

