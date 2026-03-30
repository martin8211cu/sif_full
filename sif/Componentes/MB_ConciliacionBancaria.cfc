<!---------

	Modificado por: Ana Villavicencio
	Fecha: 23 de noviembre del 2005
	Motivo: corregir insert de datos en la tabla de trabajo CDBancos. No se insertaba el CDBlinref
			y se valida que no este dentro de otro proceso de conciliacion.

	Modificado por: Ana Villavicencio
	Fecha: 16 de noviembre del 2005
	Motivo: corregir la asignacion del grupo en el proceso de actualizacion de CDLibros.
			Debia de ser el maximo + 1 del grupo asignado.
			Correcion en la consulta para el llenado de la tabla de trabajo CDLibros.
			Solo seleccionaba por banco, y no por banco y cuenta.

	Modificado por: Ana Villavicencio
	Fecha: 14 de noviembre del 2005
	Motivo: Agregar en la consulta de aplicación de la conciliación (update MLibros) la actualización del
			campo ECid con el datos del estado de cuenta en proceso.

	Modificado por: Ana Villavicencio
	Fecha: 25 de octubre del 2005
	Motivo: Cambio de todo el proceso de conciliacion bancaria.
			Se hizo una funcion para el inicio de la conciliacion, donde se llenan las tablas de trabajo (CDBancos y CDlibros.)
			Se hizo una sola funcion de conciliacion automatica, se agregó un argumento mas para indicar el tipo de conciliacion

	Modificado por: Ana Villavicencio
	Fecha de modificación: 13 de mayo del 2005
	Motivo:	Creación de una nueva funcion q realiza la conciliacion bancaria ya sea por Transaccion-Fecha-Monto o Transaccion-Monto

	Modificado por: Oscar Bonilla
	Fecha de modificación: 10 de enero del 2007
	Motivo:	Verificar Movimientos en Libros por Conciliar que no estén conciliados

	Creado por: Desconocido
	Fecha: Desconocido
	Motivo: Desconocido
----------->


<cfcomponent>
<!--- JARR Funcion para cargar movimientos de Mlibros con base a los registros actuales de CDLibros --->
<cffunction name="CargaMovAlMesAxuliar" access="public" output="true" returntype="boolean">
	<cfargument name="Ecodigo" type="numeric" required="yes">
	<cfargument name="ECid" type="numeric" required="yes">
	<cfargument name="Bid" type="numeric" required="yes">
	<cfargument name="CBid" type="numeric" required="yes">
	<cfargument name="usuario" type="string" required="no" default="#Session.usuario#">
	<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">

	<cfquery datasource="#session.dsn#" name="Periodo">
		select Pvalor from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 50
	</cfquery>
	<cfquery datasource="#session.dsn#" name="mes">
		select Pvalor from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 60
	</cfquery>
	<cfif mes.Pvalor eq 12>
		<cfset lvarAnoMes = CreateDate((Periodo.Pvalor+1), 1,1)>
	<cfelse>
		<cfset lvarAnoMes = CreateDate((Periodo.Pvalor), (mes.Pvalor+1),1)>
	</cfif>
	<cfset fechaCorte = lvarAnoMes>
	<!--- JARR CArga de los movimientos de MLibros que no se encuentran en CDlibros	 --->
	<cftransaction>
		<cfquery name="ABC_Conciliacion" datasource="#conexion#">
			insert into CDLibros (
				ECid,
				MLid, CDLidtrans, CDLdocumento, CDLmonto,
				CDLconciliado, CDLmanual, CDLtipomov, CDLfecha, CDLusuario)
				select
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.ECid#">,
				MLid,
				BTid,
				RTRIM(LTRIM(COALESCE(MLdocumento,''))),
				MLmonto, MLconciliado, 'S', MLtipomov, MLfecha, MLusuario
				from MLibros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and MLconciliado = 'N'
				and MLfecha <  <cfqueryparam cfsqltype="cf_sql_date" value="#fechaCorte#">
				and Bid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Bid#">
				and CBid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.CBid#">
				and MLid not in (select MLid from CDLibros)
		</cfquery>
	</cftransaction>
	<cfreturn true>
</cffunction>
<cffunction name="IniciaConciliacionBancaria" access="public" output="true" returntype="boolean">
	<cfargument name="Ecodigo" type="numeric" required="yes">
	<cfargument name="ECid" type="numeric" required="yes">
	<cfargument name="Bid" type="numeric" required="no">
	<cfargument name="BTEcodigo" type="string" required="no">
	<cfargument name="Tipo" type="numeric" required="yes" default="0">
	<cfargument name="debug" type="boolean" required="no" default="false">
	<cfargument name="usuario" type="string" required="no" default="#Session.usuario#">
	<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
	<cfargument name="CBesTCE" type="numeric" required="no" default="0">

				<cfquery name="rsEstadoCuenta" datasource="#session.DSN#">
					select EChasta,Bid,CBid
					from ECuentaBancaria
					where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
				</cfquery>

				<cfquery datasource="#session.dsn#" name="Periodo">
					select Pvalor from Parametros
					where Ecodigo = #session.Ecodigo#
					  and Pcodigo = 50
				</cfquery>
				<cfquery datasource="#session.dsn#" name="mes">
					select Pvalor from Parametros
					where Ecodigo = #session.Ecodigo#
					  and Pcodigo = 60
				</cfquery>
				<!--- JARR se recalculo el mes de corte --->
				<!--- <cfset lvarAnoMes = lvarAno*100+lvarMes> --->
				<cfif mes.Pvalor eq 12>
					<cfset lvarAnoMes = CreateDate((Periodo.Pvalor+1), 1,1)>
				<cfelse>
					<cfset lvarAnoMes = CreateDate((Periodo.Pvalor), (mes.Pvalor+1),1)>
				</cfif>
				<!--- <cfset fechaCorte = #rsEstadoCuenta.EChasta#> --->
				<cfset fechaCorte = lvarAnoMes>
				<!--- <cfset fechaCorte = Dateadd('d',1,fechaCorte)> --->
                <cfset LvarAnno = datePart('yyyy', rsEstadoCuenta.EChasta)>
				<cfset LvarMes = datepart('m', rsEstadoCuenta.EChasta)>
 				<!--- 2.a) Insertar los movimientos del Estado de Cuenta en Proceso  --->
				<cfquery name="ABC_Conciliacion" datasource="#conexion#">
					insert into CDBancos (ECid,
										  CDBlinea,
										  CDBdocumento,
										  CDBidtrans,
										  CDBmonto,
										  CDBfechabanco,
										  CDBconciliado,
										  CDBmanual,
										  CDBtipomov,
										  CDBfecha,
										  CDBusuario,
										  CDBecref,
										  Ecodigo,
										  Bid,
										  BTEcodigo,
										  CDBlinref)
							select dc.ECid,
							   dc.Linea,
							   dc.Documento,
							   dc.BTid,
							   dc.DCmontoori,
							   dc.DCfecha,
							   dc.DCconciliado,
							   'S',
							   dc.DCtipo,
							   <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
							   '#arguments.usuario#',
							   dc.ECid,
							   dc.Ecodigo,
							   dc.Bid,
							   dc.BTEcodigo,
							   dc.Linea
							from DCuentaBancaria dc
							inner join ECuentaBancaria ec
							   on dc.ECid 		 = ec.ECid
							  and ec.EChistorico = 'N'
							inner join CuentasBancos cb
							   on ec.CBid 	 = cb.CBid
							  and cb.Ecodigo = #arguments.Ecodigo#
							where ec.ECid 	 = #arguments.ECid#
                            	and cb.CBesTCE = <cfqueryparam value="#Arguments.CBesTCE#" cfsqltype="cf_sql_bit">
				</cfquery>

				<!--- Inserta los movimientos no conciliados de Estados de Cuenta ya procesados que correnspondan
					  a la misma cuenta bancaria --->
				<cfquery name="ABC_Conciliacion" datasource="#conexion#">
					insert into CDBancos (ECid,
										  CDBlinea,
										  CDBdocumento,
										  CDBidtrans,
										  CDBmonto,
										  CDBfechabanco,
										  CDBconciliado,
										  CDBmanual,
										  CDBtipomov,
										  CDBfecha,
										  CDBusuario,
										  CDBecref,
										  CDBlinref,
										  Ecodigo,
										  Bid,
										  BTEcodigo)
						select 	#arguments.ECid#,
								dc.Linea,
								dc.Documento,
								dc.BTid,
								dc.DCmontoori,
								dc.DCfecha,
								dc.DCconciliado,
								'S',
								dc.DCtipo,
								<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
						   		'#arguments.usuario#',
								ec.ECid,
								dc.Linea,
								dc.Ecodigo,
								dc.Bid,
								dc.BTEcodigo
						from ECuentaBancaria ec
						inner join DCuentaBancaria dc
						   on dc.ECid 		  = ec.ECid
						  and dc.DCconciliado = 'N'
						  and ec.EChistorico  = 'S'
						inner join CuentasBancos c
						   on c.CBid 	= ec.CBid
						  and c.Bid 	= ec.Bid
						  and c.Ecodigo = #arguments.Ecodigo#
						where dc.Bid 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.Bid#">
                          and c.CBesTCE = <cfqueryparam value="#Arguments.CBesTCE#" cfsqltype="cf_sql_bit">
						  and ec.CBid 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.CBid#">
						  and dc.DCfecha < <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#fechaCorte#">
						  and not exists(select 1
						  				 from CDBancos cd
										 where cd.CDBecref = dc.ECid
										   and cd.CDBlinref = dc.Linea
										   and cd.CDBgrupo is not null)
				</cfquery>

				<!--- 2.b)Insertar datos de Libros --->

				<!---
					Inserta los documentos No conciliados incluidos antes del corte
				--->
				<cfquery name="ABC_Conciliacion" datasource="#conexion#">
					insert into CDLibros
						(
							ECid,
							MLid, CDLidtrans, CDLdocumento, CDLmonto,
							CDLconciliado, CDLmanual, CDLtipomov, CDLfecha, CDLusuario
						)
					select	#arguments.ECid#,
							MLid, BTid, RTRIM(LTRIM(COALESCE(MLdocumento,''))), MLmonto,
						   	MLconciliado, 'S', MLtipomov, MLfecha, MLusuario
					from MLibros
					where Ecodigo 		= #arguments.Ecodigo#
					  and MLconciliado 	= 'N'
					  and MLfecha 		< <cfqueryparam cfsqltype="cf_sql_date" value="#fechaCorte#">
					  and Bid 			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.Bid#">
					  and CBid 			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.CBid#">
					  and MLid not in (select MLid from CDLibros)
				</cfquery>

				<!---
					Inserta los documentos de Tesorería Anulados incluidos antes del corte
					pero fueron anulados posterior a la fecha del corte
					(Están Conciliados automáticamente pero después de la fecha de corte)
				--->
				<cfquery name="ABC_Conciliacion" datasource="#conexion#">
					insert into CDLibros
						(
							ECid,
							MLid, CDLidtrans, CDLdocumento, CDLmonto,
							CDLconciliado, CDLmanual, CDLtipomov,
							CDLfecha, CDLusuario
						)
					select 	#arguments.ECid#,
							TES_P.MLid, TES_P.BTid, RTRIM(LTRIM(COALESCE(TES_P.MLdocumento,''))), TES_P.MLmonto,
							'N', 'S', TES_P.MLtipomov, TES_P.MLfecha, TES_P.MLusuario
					from MLibros TES_P
						inner join BTransacciones TES_BT_P
							inner join BTransacciones TES_BT_X
							   on TES_BT_X.Ecodigo 	= TES_BT_P.Ecodigo
							  and TES_BT_X.BTcodigo	=
										case
											when TES_BT_P.BTcodigo = 'PC' then 'XC'
											when TES_BT_P.BTcodigo = 'PT' then 'XT'
										end
						   on TES_BT_P.Ecodigo	= TES_P.Ecodigo
						  and TES_BT_P.BTid		= TES_P.BTid
						  and TES_BT_P.BTcodigo in ('PC','PT')
						inner join MLibros TES_X
						   on TES_X.MLdocumento	= TES_P.MLdocumento
						  and TES_X.BTid		= TES_BT_X.BTid
						  and TES_X.CBid		= TES_P.CBid
					where TES_P.Ecodigo 		= #arguments.Ecodigo#
					  and TES_P.MLconciliado 	= 'S'
					  and TES_P.MLfecha 		<  <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#fechaCorte#">
					  and TES_X.MLfecha 		>= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#fechaCorte#">
					  and TES_P.Bid 			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.Bid#">
					  and TES_P.CBid 			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.CBid#">
					  and TES_P.MLid not in (select MLid from CDLibros)
				</cfquery>

				<cfif arguments.debug>
				<!---=====================================================--->
					<cfquery name="ABC_Conciliacion" datasource="#conexion#">
						select CDLibros.ECid, CDLibros.MLid, CDLibros.CDLidtrans, CDLibros.CDLdocumento, CDLibros.CDLmonto,
							   CDLibros.CDLconciliado, CDLibros.CDLmanual, CDLibros.CDLtipomov, CDLibros.CDLfecha, CDLibros.CDLusuario,
							   CDLibros.CDLgrupo, CDLibros.ts_rversion
						from CDLibros
						where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
					</cfquery>
					<cfdump var="#ABC_Conciliacion#" label="CDLibros">
					<cfquery name="ABC_Conciliacion" datasource="#conexion#">
						select CDBancos.ECid, CDBancos.CDBlinea, CDBancos.CDBdocumento, CDBancos.CDBidtrans, CDBancos.CDBmonto,
							   CDBancos.CDBfechabanco, CDBancos.CDBconciliado, CDBancos.CDBmanual, CDBancos.CDBtipomov, CDBancos.CDBecref,
							   CDBancos.CDBfecha, CDBancos.CDBusuario, CDBancos.CDBgrupo, CDBancos.ts_rversion
						from CDBancos
						where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
					</cfquery>
					<cfdump var="#ABC_Conciliacion#" label="CDBancos">
				</cfif>
	<cfreturn true>
</cffunction>

	<cffunction name="ConciliacionBancaria" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="ECid" type="numeric" required="yes">
		<cfargument name="Bid" type="numeric" required="no">
		<cfargument name="BTEcodigo" type="string" required="no">
		<cfargument name="Tipo" type="numeric" required="yes" default="0">
		<cfargument name="debug" type="boolean" required="no" default="false">
		<cfargument name="usuario" type="string" required="no" default="#Session.usuario#">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="preconciliar" type="boolean" required="no" default="true">
		<!---  Tipo:  Tipo de Conciliacion:
					0:  Transaccion / Documento / Monto
					1:  Transaccion / Fecha / Monto
					2:  Transaccion / Monto
		--->

		<cfquery name="rsgrupo" datasource="#Session.DSN#">
			select *
			from CDLibros a
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
		</cfquery>

		<!--- Entra en la preconciliacion --->
		<cfif arguments.preconciliar>
			<!--- Conciliación Automática --->
			<cfquery name="rsgrupo" datasource="#Session.DSN#">
				select coalesce(max(CDLgrupo) + 1, 1) as grupo
				from CDLibros a
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
			</cfquery>

			<cfset grupo = rsgrupo.grupo>

			<!---=============================================--->
			<cfquery name="rsConcilia" datasource="#Session.DSN#">
				select b.CDBlinea as CDBlinea,
					coalesce((
						select min(l.MLid)
						from BTransaccionesEq te
							inner join CDLibros l
								 on l.CDLidtrans = te.BTid
						where te.Bid = b.Bid
						  and te.BTEcodigo = b.BTEcodigo
						  <!--- and  l.ECid       = b.ECid --->
						<cfif arguments.Tipo EQ 0>
						  and l.CDLdocumento = b.CDBdocumento
					    </cfif>
                        <cfif arguments.Tipo EQ 1>
						  and l.CDLfecha = b.CDBfechabanco
						</cfif>
						  and l.CDLmonto   = b.CDBmonto
						  and l.CDLconciliado = 'N'
					), -1)
					as MLid, CDBdocumento
				from CDBancos b
				where b.ECid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
				  and b.Bid       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Bid#">
				  and b.BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char"    value="#arguments.BTEcodigo#">
				  and b.CDBconciliado = 'N'
			</cfquery>
			<cfquery dbtype="query" name="rsConcilia">
            	select * from rsConcilia where MLid > 0
            </cfquery>

			<cfloop query="rsConcilia">
 				<cfif rsConcilia.CDBlinea NEQ -1 and rsConcilia.MLid NEQ -1>

					<cftransaction>
						<!--- JARR 23/07/2018 se quito el filtro del ECid
						and l.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#"> --->
					<cfquery name="rsVerificaMovLibros" datasource="#Session.DSN#">
						select l.MLid as Identificacion
						from CDLibros l
							inner join MLibros ml
								 on ml.MLid	 		= l.MLid
								and ml.MLconciliado = 'N'
						where l.MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcilia.MLid#">
						  and l.CDLconciliado = 'N'
					</cfquery>

					<!--- JARR 23/07/2018 se quito el filtro del ECid
						and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
					 --->
					<cfif rsVerificaMovLibros.recordcount NEQ 0 and len(trim(rsVerificaMovLibros.Identificacion)) NEQ 0>
						<cfquery datasource="#Session.DSN#">
							update CDLibros set
								CDLconciliado 	= 'S',
								CDLmanual		= 'N',
								CDLgrupo		= #grupo#,
								ECid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
							where MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcilia.MLid#">
						</cfquery>

						<!---
							BTid = (
										select min(l.CDLidtrans)
										from CDLibros l
										where l.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
										  and l.MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcilia.MLid#">
										 )
						 --->
						<cfquery datasource="#Session.DSN#">
							update CDBancos set
								CDBconciliado = 'S',
								CDBmanual = 'N',
								CDBgrupo = #grupo#
							where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
							  and CDBlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcilia.CDBlinea#">

						</cfquery>
						<!--- and CDBconciliado = 'S' --->
					</cfif>
					</cftransaction>

				</cfif>
			</cfloop>
			<cfif arguments.debug>
			</cfif>

			<!--- arguments.preconciliar == false --->
		<cfelse>
			<!--- Verifica que los Documentos en Bancos por conciliar no se hayan conciliado ya
			select count(1) as ReConciliados
				  from CDLibros L
					inner join MLibros ml
						 on ml.MLid = L.MLid
						and ml.MLconciliado = 'S'
				 where L.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
				   and L.CDLconciliado = 'S'
				Se cambio la Consulta para obtener los movimientos a Conciliar
			 --->
			<cfquery name="rsSQL" datasource="#conexion#">
				select count(1) as Reconciliados
				from CDLibros L
				where L.ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
				and L.CDLconciliado = 'S'
				and L.CDLPreconciliado = 'N'
				and L.CDLacumular=0
				and exists (
				select M.MLid from MLibros M
				where
				M.MLconciliado ='S'
				and M.MLid =L.MLid
				)
			</cfquery>

			<cfif rsSQL.Reconciliados GT 0>
				<cftransaction>
					<!--- Desconciliar los CDLibros pertenecientes al grupo de los Reconciliados --->
					<cfquery name="rsSQL" datasource="#conexion#">
						update CDLibros
						   set CDLconciliado = 'N'
						 where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
						   and exists (
								select 1
								  from CDLibros L
									inner join MLibros ml
										 on ml.MLid = L.MLid
										and ml.MLconciliado = 'S'
								 where L.ECid = CDLibros.ECid
								   and L.CDLconciliado = 'S'

								   and L.MLid		<> CDLibros.MLid
								   and L.CDLgrupo	= CDLibros.CDLgrupo
						 	)
					</cfquery>

  					<!--- Desconciliar los CDBancos pertenecientes al grupo de los Reconciliados --->

					<cfquery name="rsSQL" datasource="#conexion#">
						update CDBancos
						   set CDBconciliado = 'N'
						 where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
						   and exists (
								select 1
								  from CDLibros L
									inner join MLibros ml
										 on ml.MLid = L.MLid
										and ml.MLconciliado = 'S'
								 where L.ECid = CDBancos.ECid
								   and L.CDLconciliado = 'S'
 								   and L.CDLgrupo	=  CDBancos.CDBgrupo
						 	)
					</cfquery>
					<!--- Obtiene los CDLibros Reconciliados --->
					<cfquery name="rsReconciliados" datasource="#conexion#">
						select 	t.BTdescripcion as DocTipo,
								CDLdocumento	as DocNumero,
								ml.MLreferencia	as DocReferencia,
								CDLfecha		as Fecha,
								CDLmonto		as Monto,
								CDLtipomov		as MontoTipo
						  from CDLibros L
							inner join MLibros ml
								inner join BTransacciones t
									 on t.BTid 		= ml.BTid
									and t.Ecodigo 	= ml.Ecodigo
								 on ml.MLid = L.MLid
								and ml.MLconciliado = 'S'
						 where L.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
						   and L.CDLconciliado = 'S'
					</cfquery>
					<!--- Borrar los CDLibros Reconciliados --->
					<cfquery datasource="#conexion#">
						delete from CDLibros
						 where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
						   and exists (
								select 1
								  from CDLibros L
									inner join MLibros ml
										 on ml.MLid = L.MLid
										and ml.MLconciliado = 'S'
								 where L.ECid = CDLibros.ECid
								   and L.CDLconciliado = 'S'
 								   and L.MLid		= CDLibros.MLid
						 	)
					</cfquery>
				</cftransaction>

				<font style="font-size:24px; color:##FF0000;">ERROR: Se encontraron los siguientes Documentos en Libros ya Conciliados que se intentan reconciliar nuevamente.</font><BR>
				1. Se desconciliaron en Libros de esta Conciliación Bancaria todos los documentos pertenecientes a los grupos de los documentos a Reconciliar<BR>
				2. Se desconciliaron en Bancos de esta Conciliación Bancaria todos los documentos pertenecientes a los grupos de los documentos a Reconciliar<BR>
				3. Se eliminaron en Libros de la Conciliación Bancaria los documentos a Reconciliar<BR><BR>
				Debe volver a inciar el proceso de esta Conciliación Bancaria.<BR><BR>

				<cf_dump var="#rsReconciliados#">
			</cfif>

			<cftransaction>
				<!--- 3.c) Actualizar documentos ya conciliados y status del Estado de Cuenta --->

					<!--- 3.d JARR Obtenemos los registros de bancos que se deben ancutlizar antes de pasar el registro de M --->



					<cfquery name="ABC_Conciliacion" datasource="#conexion#">
						update MLibros
							set MLconciliado = 'S',
								ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
						where exists (
							select 1
							from CDLibros a
							where a.ECid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
							  and a.CDLconciliado = 'S'
							  and a.CDLPreconciliado = 'N'
							  and MLibros.MLid 	  = a.MLid
						)
					</cfquery>


					<!--- <cfcatch type="any">
					<cftransaction action="rollback" />
						<cfset Error= "<br><table><tr><td>#cfcatch.Message#</td></tr></table>">
						<cfthrow detail="Prblema al completar el proceso de Conciliacion #arguments.ECid#:#Error#">
					</cfcatch> --->
					<!---JARR Obtenemos el movimineto BT de MLibros  y hacemos el update por linea en CDBancos--->
					<!--- (select BTEcodigo from BTransaccionesEq where BTid = Table_B.CDLidtrans)  --->
					<!--- JARR query para determinar EQ_transacciones que faltan de agregar en el catalogo --->

					<!--- and	BTEcodigo=Table_B.BTEcodigo  --->
					<cfquery datasource="#conexion#" name="valMovsBancoEQ">
						select distinct Table_A.Ecodigo, Table_A.Bid,Table_B.CDLidtrans as BTid,
								Table_B.BTEcodigo ,bt.BTdescripcion,b.Bdescripcion,bt.BTtipo
							FROM CDBancos AS Table_A
							inner join Bancos b
							on b.Bid =Table_A.Bid
							INNER JOIN
							  (SELECT cdl.CDLidtrans,
							          cdb.CDBlinea,
							          cdb.BTEcodigo
							   FROM CDBancos cdb
							   INNER JOIN CDLibros cdl
							   ON cdl.CDLgrupo=cdb.CDBgrupo
								   AND cdl.CDLconciliado='S'
								   AND cdl.ECid=cdb.ECid
								   AND cdl.CDLPreconciliado = 'N'
							   WHERE cdb.ECid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
							     AND cdb.CDBconciliado ='S' ) AS Table_B
								ON Table_A.CDBlinea = Table_B.CDBlinea
								 and not exists (select Ecodigo,	Bid,	BTid,	BTEcodigo
												from
												BTransaccionesEq
												where Bid = Table_A.Bid
												and Ecodigo=Table_A.Ecodigo
												and	BTid =Table_B.CDLidtrans
												)
								inner join BTransacciones bt
								on bt.BTid = Table_B.CDLidtrans
					</cfquery>
				<!--- JARR  MSg Error de EQ_transacciones que faltan de agregar en el catalogo --->
					<!--- <cfif isdefined("valMovsBancoEQ") and valMovsBancoEQ.recordcount gt 0 >
						<cfset br = "#chr(13)##chr(10)#">
						<cfset error_movsEQ= "">

						<cfloop query="valMovsBancoEQ">
							<cfset error_movsEQ= error_movsEQ&"-Banco: "&valMovsBancoEQ.Bdescripcion & "-DES.Transferencia:"&valMovsBancoEQ.BTdescripcion  &"-Tipo:"&valMovsBancoEQ.BTtipo& br >
						</cfloop>
						<cftransaction action="rollback"/>

							<cfthrow message="Faltan parametrizar las siguientes Transacciones de Equivalencias:#br# #error_movsEQ#"> --->
							<!--- <cf_errorCode	code = "70001"
							msg  = "Faltan parametrizar las sigueintes Transacciones de Equivalencias:
							La Linea '@errorDat_1@'"
							errorDat_1="#valMovsBancoEQ#"
							> --->
							<!--- (select BTEcodigo from BTransaccionesEq where BTid = Table_B.CDLidtrans) --->

					<!--- </cfif> --->
					<cfquery name="transB" datasource="#conexion#" >
						select (select BTEcodigo from BTransaccionesEq where BTid = cdl.CDLidtrans and Bid=cdb.Bid) as newbtcodigo
															from CDBancos cdb
															inner join CDLibros cdl
																on cdl.CDLgrupo=cdb.CDBgrupo
																and cdl.CDLconciliado='S'
																and cdl.ECid=cdb.ECid
																and cdl.CDLPreconciliado = 'N'
															where cdb.ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
															and cdb.CDBconciliado ='S'
						and (select BTEcodigo from BTransaccionesEq where BTid = cdl.CDLidtrans and Bid=cdb.Bid) is null
					</cfquery>
					<cfif transB.recordcount eq 0>

						<cfquery datasource="#conexion#" >
							UPDATE
							    CDBancos
							SET
							    BTid = Table_B.CDLidtrans,
								BTEcodigo = (select BTEcodigo from BTransaccionesEq where BTid = Table_B.CDLidtrans and Bid=Table_B.Bid)
							FROM
							    CDBancos AS Table_A
							    INNER JOIN (
									select cdl.CDLidtrans,cdb.CDBlinea,cdb.BTEcodigo,cdb.Bid
										from CDBancos cdb
										inner join CDLibros cdl
											on cdl.CDLgrupo=cdb.CDBgrupo
											and cdl.CDLconciliado='S'
											and cdl.ECid=cdb.ECid
											and cdl.CDLPreconciliado = 'N'
										where cdb.ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
										and cdb.CDBconciliado ='S'
								) AS Table_B
							ON Table_A.CDBlinea = Table_B.CDBlinea
						</cfquery>
					<cfelse>
						<cftransaction action="rollback"/>
						<cf_errorCode	code = "20001" msg = "Faltan parametrizar las Transacciones de Equivalencias.">
					</cfif>

					<!---JARR Actualizamos el movimiento de a P --->
					<cfquery datasource="#conexion#">
					update  CDLibros
						set CDLPreconciliado='P'
					where ECid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
					  and CDLconciliado = 'S'
					  and CDLPreconciliado = 'N'
					</cfquery>


					<cfquery name="valMovEC_CDL_CDB" datasource="#conexion#">
					select
						case when (
							(
								SELECT
								 count(*) as ECmov
								from DCuentaBancaria edc
								where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
								and Ecodigo =#Session.Ecodigo#
							)=
							(
								SELECT count(*) as CDBmov
								from CDBancos
								where CDBconciliado like 'S'
								and Ecodigo =#Session.Ecodigo#
								and ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
							)
						)
						then
							 1
						else 0
						end as balED
					</cfquery>


					<cfif isdefined("valMovEC_CDL_CDB.balED") and valMovEC_CDL_CDB.balED EQ	 1>
						<cfquery name="ABC_Conciliacion" datasource="#conexion#">
							update ECuentaBancaria set ECaplicado = 'S'
							where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
						</cfquery>
					<cfelse>
						<cfquery name="ABC_Conciliacion" datasource="#conexion#">
							update ECuentaBancaria set ECaplicado = 'P'
							where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
						</cfquery>
					</cfif>


					<!---================================================--->
					<cfquery name="ABC_Conciliacion" datasource="#conexion#">
						update DCuentaBancaria
						   set DCconciliado = 'S',
						       BTid = (
										select b.BTid
										from CDBancos b
										where b.ECid 					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
										  and DCuentaBancaria.ECid 		= b.CDBecref
										  and DCuentaBancaria.Linea 	= b.CDBlinref
										  and DCuentaBancaria.Bid 		= b.Bid
										  and DCuentaBancaria.BTEcodigo = b.BTEcodigo
										  and b.CDBconciliado 			= 'S'

										)
						where exists (
							select 1
							from CDBancos a
							where a.ECid 					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
							  and DCuentaBancaria.ECid 		= a.CDBecref
							  and DCuentaBancaria.Linea  	= a.CDBlinref
							  and DCuentaBancaria.Bid 		= a.Bid
							  and DCuentaBancaria.BTEcodigo = a.BTEcodigo
							  and a.CDBconciliado 			= 'S'

						)
					</cfquery>
					<cfif arguments.debug>
						<cfquery name="ABC_Conciliacion" datasource="#conexion#">
							select ECuentaBancaria.ECid, ECuentaBancaria.Bid, ECuentaBancaria.ECfecha, ECuentaBancaria.CBid,
								   ECuentaBancaria.ECsaldoini, ECuentaBancaria.ECsaldofin, ECuentaBancaria.ECdescripcion,
								   ECuentaBancaria.ECusuario, ECuentaBancaria.ECdesde, ECuentaBancaria.EChasta, ECuentaBancaria.ECdebitos,
								   ECuentaBancaria.ECcreditos, ECuentaBancaria.ECaplicado, ECuentaBancaria.EChistorico,
								   ECuentaBancaria.ECselect, ECuentaBancaria.ts_rversion
							from ECuentaBancaria
							where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
						</cfquery>
						<cfdump var="#ABC_Conciliacion#" label="ECuentaBancaria">
						<cfquery name="ABC_Conciliacion" datasource="#conexion#">
							select a.ECid, a.Linea, a.BTid, a.DCfecha, a.Documento, a.DCReferencia, a.DCconciliado, a.DCmontoori,
								   a.DCmontoloc, a.DCtipo, a.DCtipocambio, a.ts_rversion
							from DCuentaBancaria a
						</cfquery>
						<cfdump var="#ABC_Conciliacion#" label="DCuentaBancaria">
						<cfquery name="ABC_Conciliacion" datasource="#conexion#">
							select b.MLid, b.Ecodigo, b.Bid, b.BTid, b.CBid, b.Mcodigo, b.MLfecha, b.MLdescripcion, b.MLdocumento,
								   b.MLreferencia, b.MLconciliado, b.MLtipocambio, b.MLmonto, b.MLmontoloc, b.MLperiodo, b.MLmes,
								   b.MLtipomov, b.MLusuario, b.IDcontable, b.CDLgrupo, b.MLfechamov, b.ts_rversion, a.ECid, a.MLid,
								   a.CDLidtrans, a.CDLdocumento, a.CDLmonto, a.CDLconciliado, a.CDLmanual, a.CDLtipomov, a.CDLfecha,
								   a.CDLusuario, a.CDLgrupo, a.ts_rversion
							from MLibros b, CDLibros a
							where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
							and a.CDLconciliado = 'S'
							and b.MLid = a.MLid
						</cfquery>
						<cfdump var="#ABC_Conciliacion#" label="MLibros">
						<cfquery name="ABC_Conciliacion" datasource="#conexion#">
							select CDLibros.ECid, CDLibros.MLid, CDLibros.CDLidtrans, CDLibros.CDLdocumento, CDLibros.CDLmonto,
								   CDLibros.CDLconciliado, CDLibros.CDLmanual, CDLibros.CDLtipomov, CDLibros.CDLfecha, CDLibros.CDLusuario,
								   CDLibros.CDLgrupo, CDLibros.ts_rversion
							from CDLibros
						</cfquery>
						<cfdump var="#ABC_Conciliacion#" label="CDLibros final.">
						<cfquery name="ABC_Conciliacion" datasource="#conexion#">
							select CDBancos.ECid, CDBancos.CDBlinea, CDBancos.CDBdocumento, CDBancos.CDBidtrans, CDBancos.CDBmonto,
								   CDBancos.CDBfechabanco, CDBancos.CDBconciliado, CDBancos.CDBmanual, CDBancos.CDBtipomov, CDBancos.CDBecref,
								   CDBancos.CDBfecha, CDBancos.CDBusuario, CDBancos.CDBgrupo, CDBancos.ts_rversion
							from CDBancos
						</cfquery>
						<cfdump var="#ABC_Conciliacion#" label="CDBancos final.">
					</cfif>

			
			</cftransaction>


		</cfif>

		<cfif arguments.debug>
			<cftransaction action="rollback"/>
		</cfif>

		<cfreturn true>
	</cffunction>
</cfcomponent>
