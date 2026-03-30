<cfif isdefined("Form.btnAplicar")>
	<cfset action = "RelacionAumento-lista.cfm">
<cfelseif isdefined("Form.btnImportar")>
	<cfset action = "RelacionAumento-import-tipo.cfm">
<cfelse>
	<cfset action = "RelacionAumento.cfm">
</cfif>

<cfif isdefined("Form.btnAplicar")>
<cftransaction>
	<cfif isdefined("Form.chk") and Len(Trim(Form.chk)) NEQ 0>
		<cfset lotesid = ListToArray(Replace(Form.chk,' ', '', 'all'),',')>
		<cfloop index="i" from="1" to="#ArrayLen(lotesid)#">
			<cfset lote = lotesid[i]>
			
			<!--- Inicializar --->
			<cfquery name="updRHDAumentos" datasource="#Session.DSN#">
				update RHDAumentos 
					set RHDinsertarlt = 0, 
					RHDltactual = null, 
					RHDltnueva = null,
					DEid = null
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
			</cfquery>
			
			<!--- Actualizar codigos de Empleados --->
			<cfquery name="updRHDAumentos" datasource="#Session.DSN#">
				update RHDAumentos
				set DEid = (select max(e.DEid)
							from DatosEmpleado e 
							where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
							and e.NTIcodigo = RHDAumentos.NTIcodigo 
							and e.DEidentificacion = RHDAumentos.DEidentificacion
				)
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
			</cfquery>

			<!--- Chequea que todos los empleados existan --->
			<cfquery name="consEmpleados" datasource="#Session.DSN#">
				select count(1) as cant
				from RHDAumentos
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
				and DEid is null
			</cfquery>
			<cfif consEmpleados.cant GT 0>
				<cfset Request.Error.Backs = 2>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_Hay_empleados_en_el_Lote_que_no_se_encuentran_dentro_del_sistema._Proceso_cancelado_a_partir_de_este_lote"
					default="Hay empleados en el Lote #lote# que no se encuentran dentro del sistema. Proceso cancelado a partir de este lote."
					returnvariable="MSG_EmpleadosLote"/>	
				<cfthrow detail="#MSG_EmpleadosLote#">
			</cfif>
			
			<!--- Chequea que todos los empleados esten nombrados --->
			<cfquery name="rsChequearEmpleados" datasource="#Session.DSN#">
				select 1
				from RHEAumentos a, RHDAumentos b
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.RHAid = b.RHAid
				and not exists(
					select 1
					from LineaTiempo d
					where b.DEid = d.DEid
					and a.Ecodigo = d.Ecodigo
					and a.RHAfdesde between d.LTdesde and d.LThasta
				)
			</cfquery>
			<cfif rsChequearEmpleados.recordCount GT 0>
				<cfset Request.Error.Backs = 2>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_Existen_empleados_en_el_Lote_que_no_están_nombrados._Proceso_cancelado_a_partir_de_este_lote"
					default="Existen empleados en el Lote #lote# que no están nombrados. Proceso cancelado a partir de este lote."
					returnvariable="MSG_EmpleadosLoteN"/>	
				<cfthrow detail="#MSG_EmpleadosLoteN#">
			</cfif>
			
			<!--- Chequea que no haya mas de un aumento para un empleado para la misma fecha rige --->
			<cfquery name="rsChequear" datasource="#Session.DSN#">
				select 1
				from RHEAumentos a, RHDAumentos b
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.RHAid = b.RHAid
				and exists(
					select 1
					from RHEAumentos c, RHDAumentos d
					where c.RHAfdesde = a.RHAfdesde
					and c.RHAid = d.RHAid
					and b.NTIcodigo = d.NTIcodigo
					and b.DEidentificacion = d.DEidentificacion
					and c.RHAid <> a.RHAid
				)
			</cfquery>
			<cfif rsChequear.recordCount GT 0>
				<cfset Request.Error.Backs = 2>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_Existen_aumentos_que_ya_habian_sido_registrados_en_el_Lote._Proceso_cancelado_a_partir_de_este_lote"
					default="Existen aumentos que ya habian sido registrados en el Lote #lote#. Proceso cancelado a partir de este lote."
					returnvariable="MSG_Aumentos"/>	
				<cfthrow detail="#MSG_Aumentos#">
			</cfif>
			
			<!--- Chequear saldos válidos --->
			<cfquery name="rsChequearSaldos" datasource="#Session.DSN#">
				select 
					x.DEidentificacion as Identificacion, 
					{fn concat({fn concat({fn concat({ fn concat(e.DEapellido1, ' ') },e.DEapellido2 )}, ' ')},e.DEnombre) } as Nombre,
					x.RHDvalor
				from RHDAumentos x, DatosEmpleado e
				where x.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
				and e.DEid = x.DEid
				and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and x.RHDvalor < 0
			</cfquery>
			<cfif rsChequearSaldos.recordCount GT 0>
				<cfset Request.Error.Backs = 2>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="MSG_Los_saldos_no_pueden_ser_negativos"
					default="Los saldos no pueden ser negativos."
					returnvariable="MSG_ErrorSaldos"/>
				<cfthrow detail="#MSG_ErrorSaldos#">
			</cfif>

			<!--- Chequear que haya un tipo de acción de tipo aumento --->
			<cfquery name="rsTipoAccion" datasource="#Session.DSN#">
				select RHTid
				from RHTipoAccion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and RHTcomportam = 8
			</cfquery>
			<cfif rsTipoAccion.recordCount GT 0 and Len(Trim(rsTipoAccion.RHTid))>
				<cfset TipoAccion = rsTipoAccion.RHTid>
			<cfelse>
				<cfset Request.Error.Backs = 2>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="MSG_Debe_haber_al_menos_un_tipo_de_acción_con_comportamiento_Aumento_configurado"
					default="Debe haber al menos un tipo de acción con comportamiento Aumento configurado."
					returnvariable="MSG_ErrorTipoAccion"/>
				<cfthrow detail="#MSG_ErrorTipoAccion#">
			</cfif>
			
			<!--- Chequear que exista un componente salarial base --->
			<cfquery name="rsChequearComponenteSalarial" datasource="#Session.DSN#">
				select CSid
				from ComponentesSalariales
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and CSsalariobase = 1
			</cfquery>
			<cfif rsChequearComponenteSalarial.recordCount EQ 0>
				<cfset Request.Error.Backs = 2>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="MSG_Debe_escoger_un_componente_salarial_que_represente_el_salario_base_en_el_mantenimiento_de_componentes_salariales"
					default="Debe escoger un componente salarial que represente el salario base en el mantenimiento de componentes salariales"
					returnvariable="MSG_ErrorComponente"/>
				<cfthrow detail="#MSG_ErrorComponente#">
			</cfif>

			<!--- Ejecutar el código de la aplicación de los lotes de aumentos salariales --->
			<cfquery name="rsFecha1" datasource="#Session.DSN#">
				select RHAfdesde as fecha1
				from RHEAumentos
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfif Len(Trim(rsFecha1.fecha1))>
				<cfset Fecha1 = rsFecha1.fecha1>
				<cfset Fecha2 = DateAdd('d', -1, Fecha1)>
				
				<cfquery name="rsComponenteSalarial" datasource="#Session.DSN#">
					select CSid
					from ComponentesSalariales
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CSsalariobase = 1
				</cfquery>
				<cfset CSid = rsComponenteSalarial.CSid>
				
				<!--- Identificar cuales registros deben insertar en la Linea del Tiempo --->
				<cfquery name="updRHDAumentos" datasource="#Session.DSN#">
					update RHDAumentos
					   set RHDinsertarlt = 1
					where RHDAumentos.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and not exists (
						select 1 
						from LineaTiempo lt
						where lt.DEid = RHDAumentos.DEid
						and lt.LTdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
						and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					)
				</cfquery>

				<!--- Identificar la linea del tiempo actual para los registros a insertar --->
				<cfquery name="updRHDAumentos" datasource="#Session.DSN#">
					update RHDAumentos
					set RHDltactual = ( select LTid from LineaTiempo lt 
										where lt.DEid = RHDAumentos.DEid 
										and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#"> between lt.LTdesde and lt.LThasta)
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and RHDinsertarlt = 1
				</cfquery>
				
				<!--- Insertar la Linea del Tiempo con los nuevos registros --->
				<cfquery name="insLineaTiempo" datasource="#Session.DSN#">
					insert into LineaTiempo (DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, RHJid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal)
					select lt.DEid, lt.Ecodigo, lt.Tcodigo, lt.RHTid, lt.Ocodigo, lt.Dcodigo, lt.RHPid, lt.RHPcodigo, lt.RVid, lt.RHJid, <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">, lt.LThasta, lt.LTporcplaza, lt.LTsalario, lt.LTporcsal
					from RHDAumentos a, LineaTiempo lt
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.RHDinsertarlt = 1
					and lt.LTid = a.RHDltactual
				</cfquery>
				
				<!--- Obtener la nueva linea del tiempo para los registros insertados --->
				<cfquery name="updRHDAumentos" datasource="#Session.DSN#">
					update RHDAumentos
					set RHDltnueva = (select LTid from LineaTiempo lt 
									  where lt.DEid = RHDAumentos.DEid 
									  and lt.LTdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">)
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and RHDinsertarlt = 1
				</cfquery>
				
				<!--- Actualizar la Fecha Hasta de la Linea del Tiempo Anterior --->
				<cfquery name="updRHDAumentos" datasource="#Session.DSN#">
					update LineaTiempo
					set LThasta = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">
					where exists (
						select 1
						from RHDAumentos a
						where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and a.RHDinsertarlt = 1
						and LineaTiempo.LTid = a.RHDltactual
					)
				</cfquery>
				
				<!--- Insertar los Componentes de los registros insertados en la Linea del Tiempo --->
				<cfquery name="insDLineaTiempo" datasource="#Session.DSN#">
					insert into DLineaTiempo (LTid, CSid, CIid, DLTmonto, DLTunidades, DLTtabla)
					select a.RHDltnueva, b.CSid, b.CIid, b.DLTmonto, b.DLTunidades, b.DLTtabla
					from RHDAumentos a, DLineaTiempo b
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.RHDinsertarlt = 1
					and b.LTid = a.RHDltactual
				</cfquery>
				
				<!--- Insercion en DLaboralesEmpleado --->
				<cfquery name="insDLaboralesEmpleado" datasource="#Session.DSN#">
					insert into DLaboralesEmpleado (
							DLconsecutivo, DEid, RHTid, Ecodigo, RHPid, RHPcodigo, Tcodigo, RVid, Dcodigo, Ocodigo, RHJid, 
							DLfvigencia, DLffin, DLsalario, DLobs, DLfechaaplic, Usucodigo, Ulocalizacion, DLporcplaza, DLporcsal,
							Dcodigoant, Ocodigoant, RHPidant, RHPcodigoant, Tcodigoant, DLsalarioant, RVidant, DLporcplazaant, DLporcsalant, RHJidant)
					select -1, d.DEid, #TipoAccion#, d.Ecodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, d.RVid, d.Dcodigo, d.Ocodigo, d.RHJid, 
							d.LTdesde, null, d.LTsalario + b.RHDvalor, 
							'Aumento Salarial', <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, d.LTporcplaza, d.LTporcsal,
							d.Dcodigo, d.Ocodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, d.LTsalario, d.RVid, d.LTporcplaza, d.LTporcsal, d.RHJid
					from RHEAumentos a, RHDAumentos b, LineaTiempo d
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHAid = b.RHAid
					and a.Ecodigo = d.Ecodigo
					and b.DEid = d.DEid
					and a.RHAfdesde = d.LTdesde
				</cfquery>
				
				<!--- Insercion en DDLaboralesEmpleado --->
				<cfquery name="insDDLaboralesEmpleado" datasource="#Session.DSN#">
					insert into DDLaboralesEmpleado (DLlinea, CSid, DDLtabla, DDLunidad, DDLmontobase, DDLmontores, Usucodigo, Ulocalizacion, DDLunidadant, DDLmontobaseant, DDLmontoresant)
					select f.DLlinea, e.CSid, e.DLTtabla, e.DLTunidades, 
							e.DLTmonto + (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end),
							e.DLTmonto + (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end),
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
							e.DLTunidades, e.DLTmonto, e.DLTmonto
					from RHEAumentos a, RHDAumentos b, LineaTiempo d, DLineaTiempo e, DLaboralesEmpleado f, ComponentesSalariales g
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHAid = b.RHAid
					and a.Ecodigo = d.Ecodigo
					and b.DEid = d.DEid
					and a.RHAfdesde = d.LTdesde
					and d.LTid = e.LTid
					and a.Ecodigo = f.Ecodigo
					and b.DEid = f.DEid
					and f.DLconsecutivo = -1
					and e.CSid = g.CSid
				</cfquery>

				<!--- Actualizacion del Consecutivo en DLaboralesEmpleado --->
				<cfquery name="nextDLconsecutivo" datasource="#Session.DSN#">
					select coalesce(max(DLconsecutivo), 0) + 1 as cont
					from DLaboralesEmpleado
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfset cont = nextDLconsecutivo.cont>
				
				<cfquery name="rsDatosLaborales" datasource="#Session.DSN#">
					select DLlinea
					from DLaboralesEmpleado
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and DLconsecutivo = -1
					order by DLlinea
				</cfquery>
				
				<cfloop query="rsDatosLaborales">
					<cfquery name="updDLaboralesEmpleado" datasource="#Session.DSN#">
						update DLaboralesEmpleado
						set DLconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#cont#">
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosLaborales.DLlinea#">
						and DLconsecutivo = -1
					</cfquery>
					<cfset cont = cont + 1>
				</cfloop>
				
				<!--- Actualizacion del calendario de pago y monto de los salarios en la linea del tiempo a partir de la fecha en que rige el aumento --->
				<cfquery name="updLineaTiempo" datasource="#Session.DSN#">
					update LineaTiempo set 
						LTsalario = LTsalario + 
									coalesce((select max(b.RHDvalor)
											  from RHDAumentos b
											  where b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
											  and b.DEid = LineaTiempo.DEid
											  ), 0.00),
						CPid = (select min(e.CPid)
								from CalendarioPagos e
								where e.Ecodigo = LineaTiempo.Ecodigo
								  and e.Tcodigo = LineaTiempo.Tcodigo
								  and e.CPfcalculo is null
								  and e.CPtipo = 0
								  and e.CPdesde = (
										select min(z.CPdesde) 
										from CalendarioPagos z
										where z.Ecodigo = LineaTiempo.Ecodigo
										  and z.Tcodigo = LineaTiempo.Tcodigo
										  and z.CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
										  and z.CPfcalculo is null
										  and z.CPtipo = 0

								  )
						)
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
					and exists ( 
						select 1
						from RHDAumentos x
						where x.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
						  and x.DEid = LineaTiempo.DEid
					)
				</cfquery>
				
				<!--- Actualizacion del salario base en los componentes a partir de la fecha en que rige el aumento --->
				<cfquery name="updDLineaTiempo" datasource="#Session.DSN#">
					update DLineaTiempo
					   set DLTmonto = DLTmonto + 
									  coalesce((select max(b.RHDvalor)
											   from RHDAumentos b, LineaTiempo lt
											   where b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
											   and b.DEid = lt.DEid
											   and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
											   and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
											   and DLineaTiempo.LTid = lt.LTid
											   ), 0.00)
					where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CSid#">
					and exists (
						select 1
						from RHDAumentos b, LineaTiempo lt
						where b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
						  and b.DEid = lt.DEid
						  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
						  and DLineaTiempo.LTid = lt.LTid
					)
				</cfquery>
				
				<!---  quienes tienen componenetes salariales aparte del salario base --->
				<!---
				<cfquery name="rsComponentesExtra" datasource="#session.DSN#">
					select  lt.DEid, 
							dlt.CSid, 
							sum(lt.LTsalario) as salario,
							min(( select min(RHMCvalor)
							  from RHMetodosCalculo mc
							  where mc.CSid = dlt.CSid
								and mc.RHMCcomportamiento in (2,3) )) as valor

					from LineaTiempo lt, DLineaTiempo dlt

					where dlt.LTid=lt.LTid
					  and <cfqueryparam cfsqltype="cf_sql_date" value="#RHAfdesde#"> between lt.LTdesde and lt.LThasta 
					  and lt.DEid in ( select DEid 
									   from RHDAumentos
									   where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">  )
					  and exists (    select 1 
									  from ComponentesSalariales
									  where CSsalariobase != 1
									    and CSid = dlt.CSid )
					
					and exists ( 	select 1
									from RHMetodosCalculo a, RHComponentesCalculo b
									where b.RHMCid=a.RHMCid
									  and a.CSid = dlt.CSid
									  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1"> between a.RHMCfecharige and a.RHMCfechahasta
									  and a.RHMCcomportamiento in (2, 3)
					  )
					group by lt.DEid, dlt.CSid  
				</cfquery>
				--->
				<!---  recupera todos los empleados que tienen componentes salariales que requieren un calculo --->
				<cfset fecha_fin = createdate(6100,01,01) >
				<cfquery name="rsCompCalculo" datasource="#session.DSN#">
					select  dlt.LTid,
							lt.DEid, 
							dlt.CSid,
							dlt.DLTmonto,
							mc.RHMCid,
							mc.RHMCcomportamiento, 
							coalesce(mc.RHMCvalor, 0) as RHMCvalor,
							coalesce((  select max(dle.DLlinea)
										from DLaboralesEmpleado dle
										where dle.DEid = lt.DEid
							   			  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1#"> between dle.DLfvigencia and coalesce(dle.DLffin, <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_fin#">) ), 0) as DLlinea
							
					from DLineaTiempo dlt, LineaTiempo lt, DatosEmpleado de, ComponentesSalariales cs, RHMetodosCalculo mc 

					where lt.LTid = dlt.LTid
					  and de.DEid = lt.DEid
					  and cs.CSid = dlt.CSid
					  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1#"> between lt.LTdesde and lt.LThasta
					  and mc.CSid = dlt.CSid
					  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1#"> between mc.RHMCfecharige and mc.RHMCfechahasta
					  and exists ( 	select 1
					 				from RHDAumentos
									where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
									and DEid = lt.DEid )
				</cfquery>
				
				<cfloop query="rsCompCalculo">
					<!--- Averigua el monto al que debe aplicarse el calculo. Aplica de una vez el porcentaje
						  o la multiplicacion al monto resultante. Los componentes que deben ser tomados en cuenta 
						  para calcular ese monto, son los definidos en la tabla RHComponentesCalculo para cada 
						  RHMCid obtenido en el query sobre el que estamos caminando  --->
						  
					<cfquery name="rsCompCalculados" datasource="#session.DSN#">
						select 	lt.DEid, 
								<cfif rsCompCalculo.RHMCcomportamiento eq 2>
									sum(dlt.DLTmonto)*#rsCompCalculo.RHMCvalor#/100 as monto
								<cfelse>
									sum(dlt.DLTmonto)*#rsCompCalculo.RHMCvalor# as monto
								</cfif>

						from RHComponentesCalculo cc, DLineaTiempo dlt, LineaTiempo lt

						where cc.RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompCalculo.RHMCid#">
						  and dlt.CSid = cc.CSid
						  and lt.LTid = dlt.LTid 
						  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompCalculo.DEid#">
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta 
						group by lt.DEid
					</cfquery>
					
					<!--- Modifica el componente que requiere recalculo en el detalle de la linea del tiempo--->
					<cfquery datasource="#session.DSN#">
						update DLineaTiempo
						set DLTmonto = <cfif len(trim(rsCompCalculados.monto)) ><cfqueryparam cfsqltype="cf_sql_money" value="#rsCompCalculados.monto#"><cfelse>0</cfif>
						where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompCalculo.LTid#">
						  and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompCalculo.CSid#">
					</cfquery>

					<!--- Modifica el salario de la linea del tiempo, recalculado la sumatoria de los componentes que se calcularon de nuevo 
						  Este update puede	ejecutarse N veces, pues seria una vez por cada componente que requiera recalculo
					--->
					<cfquery datasource="#session.DSN#">
						update LineaTiempo
						set LTsalario = ( 	select sum(DLTmonto)
											from DLineaTiempo
											where LTid = LineaTiempo.LTid  )
						where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompCalculo.LTid#">
					</cfquery>

					<!--- Modifica el componente que requiere recalculo en el detalle de Datos Laborales del empleado --->
					<cfquery datasource="#session.DSN#">
						update DDLaboralesEmpleado
						set DDLmontobase = <cfif len(trim(rsCompCalculados.monto)) ><cfqueryparam cfsqltype="cf_sql_money" value="#rsCompCalculados.monto#"><cfelse>0</cfif>,
							DDLmontores = <cfif len(trim(rsCompCalculados.monto)) ><cfqueryparam cfsqltype="cf_sql_money" value="#rsCompCalculados.monto#"><cfelse>0</cfif>
						where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompCalculo.DLLinea#">
						  and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompCalculo.CSid#">
					</cfquery>

					<!--- Modifica el salario de la linea del tiempo, recalculado la sumatoria de los componentes que se calcularon de nuevo 
						  Este update puede	ejecutarse N veces, pues seria una vez por cada componente que requiera recalculo
					--->
					<cfquery datasource="#session.DSN#">
						update DLaboralesEmpleado
						set DLsalario = ( 	select sum(DDLmontobase)		<!--- monto base o monto res??? --->
											from DDLaboralesEmpleado
											where DLlinea = DLaboralesEmpleado.DLlinea  )
						where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompCalculo.DLlinea#">
					</cfquery>

				</cfloop>
				
				<!--- Actualizacion del estado del lote de aumentos --->
				<cfquery name="updRHEAumentos" datasource="#Session.DSN#">
					update RHEAumentos
					set RHAestado = 1
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
			</cfif>
			
		</cfloop>
	</cfif>
</cftransaction>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.RHAid") and Len(Trim(Form.RHAid)) NEQ 0>
		<input name="RHAid" type="hidden" value="<cfoutput>#Form.RHAid#</cfoutput>"> 
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
