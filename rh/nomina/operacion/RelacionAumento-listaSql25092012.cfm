<cfset vDebug = 'false'>


<cfsetting requesttimeout="8600">

<cfif isdefined("Form.btnAplicar")>
	<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	<cfset action = "RelacionAumento-lista.cfm">
<cfelseif isdefined("Form.btnImportar")>
	<cfset action = "RelacionAumento-import-tipo.cfm">
<cfelse>
	<cfset action = "RelacionAumento.cfm">
</cfif>
<!--- VERIFICA SI TIENE CONTROL PRESUPUESTARIO --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="540" default="" returnvariable="ControlP"/>
<cfquery name="UsaTabla" datasource="#session.DsN#">
	select CSusatabla
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and CSsalariobase = 1
</cfquery>
<cfif Usatabla.CSusatabla EQ 1>
	<cfset usaEstructuraSal = true>
<cfelse>
	<cfset usaEstructuraSal = false>
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
				and  exists(
					select 1
					from LineaTiempo d
					where b.DEid = d.DEid
					and a.Ecodigo = d.Ecodigo
					<cfif usaEstructuraSal>
						and d.LThasta >= a.RHAfdesde
					<cfelse>
						and a.RHAfdesde between d.LTdesde and d.LThasta
					</cfif>
				)
                union 
                select 1
				from RHEAumentos a, RHDAumentos b
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.RHAid = b.RHAid
				and  exists(
					select 1
					from LineaTiempoR d
					where b.DEid = d.DEid
					and a.Ecodigo = d.Ecodigo
					<cfif usaEstructuraSal>
						and d.LThasta >= a.RHAfdesde
					<cfelse>
						and a.RHAfdesde between d.LTdesde and d.LThasta
					</cfif>
				)
			</cfquery>	
            

			<cfif rsChequearEmpleados.recordCount EQ 0>
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
                
                <cfif vDebug>
                    Fecha 1: <cfdump var="#Fecha1#"> <br>
                    Fecha 2: <cfdump var="#Fecha2#"> <br>
                </cfif>
                
				
				<cfquery name="rsComponenteSalarial" datasource="#Session.DSN#">
					select CSid
					from ComponentesSalariales
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CSsalariobase = 1
				</cfquery>
				<cfset CSid = rsComponenteSalarial.CSid>
              
				<!--- Identificar cuales registros deben insertar en la Linea del Tiempo
				buscamos los cortes que estan con lthasta > = fecha de corte del aumento --->
				<cfquery name="updRHDAumentos" datasource="#Session.DSN#">
					update RHDAumentos
					   set RHDinsertarlt = 1
					where RHDAumentos.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and LTid in (
						select LTid 
						from LineaTiempo lt
						where lt.DEid = RHDAumentos.DEid
						and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#"> between lt.LTdesde and lt.LThasta
                        and lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
					)
				</cfquery>
                <!--- Identificar cuales registros deben insertar en la Linea del Tiempo Recargo
				buscamos los cortes que estan con lthasta > = fecha de corte del aumento --->
                
                <cfquery name="updRHDAumentos" datasource="#Session.DSN#">
					update RHDAumentos
					   set RHDinsertarlt = 1
					where RHDAumentos.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and LTRid in (
						select LTRid 
						from LineaTiempoR lt
						where lt.DEid = RHDAumentos.DEid
						and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#"> between lt.LTdesde and lt.LThasta
                        and lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
					)
				</cfquery>


				<!--- Identificar la linea del tiempo actual para los registros a insertar --->
				<cfquery name="updRHDAumentos" datasource="#Session.DSN#">
					update RHDAumentos
					set RHDltactual = ( select max(LTid) from LineaTiempo lt 
										where lt.DEid = RHDAumentos.DEid 
										<cfif usaEstructuraSal>
											and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
										<cfelse>
											and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#"> between lt.LTdesde and lt.LThasta
										</cfif>
										and RHDAumentos.LTid = lt.LTid)
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and RHDinsertarlt = 1
                    and LTid > 0
				</cfquery>
                
                <cfquery name="updRHDAumentos" datasource="#Session.DSN#">
					update RHDAumentos
					set RHDltactual = ( select max(LTRid) from LineaTiempoR lt 
										where lt.DEid = RHDAumentos.DEid 
										<cfif usaEstructuraSal>
											and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
										<cfelse>
											and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#"> between lt.LTdesde and lt.LThasta
										</cfif>
										
                                        and RHDAumentos.LTRid = lt.LTRid)
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and RHDinsertarlt = 1
                    and  LTRid > 0
				</cfquery>
                
				<cfif vDebug>
                    <cfquery name="rsRHDAumentos" datasource="#Session.DSN#">
                    select *
                    from RHDAumentos
                        where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
                    </cfquery>
                    Detalle de los empleados relacion aumento lineas quese deben insertar 
                    <cfdump var="#rsRHDAumentos#">
                    
                    Lineas tiempo antes del insert 
                    <cfquery name="insLineaTiempo" datasource="#Session.DSN#">
                        select *
                        from LineaTiempo
                        where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
                        order by LTdesde
                    </cfquery>    
                    
                     <cfquery name="insLineaTiempoR" datasource="#Session.DSN#">
                        select *
                        from LineaTiempoR
                        where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
                        order by LTdesde
                    </cfquery>         	
                    <cfdump var="#insLineaTiempo#">
                     <cfdump var="#insLineaTiempoR#">
                </cfif>
                
                <cfquery name="rsInsertLT" datasource="#Session.DSN#">
					select 	a.RHDAlinea, lt.DEid, lt.Ecodigo, lt.Tcodigo, lt.RHTid, lt.Ocodigo, lt.Dcodigo, lt.RHPid, ltrim(rtrim(lt.RHPcodigo)) as RHPcodigo, coalesce(RHPcodigoAlt,'') as RHPcodigoAlt, lt.RVid, lt.RHJid,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#"> as Fecha1, lt.LThasta, lt.LTporcplaza, lt.LTsalario
                    <!---a.RHDSalario---> <!---  El salario Base de aumento  IRR - APH --->
                    , lt.LTporcsal
                    ,coalesce(lt.RHCPlinea,0) as RHCPlinea
                    ,coalesce(lt.RHCPlineaP,0) as RHCPlineaP
					from RHDAumentos a, LineaTiempo lt
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.RHDinsertarlt = 1
					and lt.LTid = a.RHDltactual
                    and a.LTid > 0
				</cfquery>

                
                <cfloop query="rsInsertLT">
                	<cfquery name="insLineaTiempo" datasource="#Session.DSN#">
                        insert into LineaTiempo (DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RHPcodigoAlt, RVid, RHJid, LTdesde, LThasta, 
                        LTporcplaza, LTsalario, LTporcsal <cfif usaEstructuraSal>,RHCPlinea,RHCPlineaP</cfif> )
                        values (
                        #rsInsertLT.DEid#, 
                        #rsInsertLT.Ecodigo#, 
                        '#rsInsertLT.Tcodigo#', 
                        <!---#rsInsertLT.RHTid#,---> 
						#TipoAccion#,
                        #rsInsertLT.Ocodigo#,
                        #rsInsertLT.Dcodigo#, 
                        #rsInsertLT.RHPid#, 
                        '#rsInsertLT.RHPcodigo#', 
                        '#rsInsertLT.RHPcodigoAlt#', 
                        #rsInsertLT.RVid#, 
                        #rsInsertLT.RHJid#, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#rsInsertLT.Fecha1#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#rsInsertLT.LThasta#">,
                        #rsInsertLT.LTporcplaza#,
                        #rsInsertLT.LTsalario#, 
                       <!--- #rsInsertLT.RHDSalario#,---> <!---  El salario Base de aumento  IRR - APH --->
                        #rsInsertLT.LTporcsal#
                        <cfif usaEstructuraSal>
                        	<cfif len(#rsInsertLT.RHCPlinea#) NEQ 0>, #rsInsertLT.RHCPlinea#<cfelSe> ,NULL </cfif>
                            ,#rsInsertLT.RHCPlineaP#
                        </cfif>
                        )
                    </cfquery>
                    
						
                    
                    <!--- Obtener la nueva linea del tiempo para los registros insertados --->
                    <cfquery name="updRHDAumentos" datasource="#Session.DSN#">
                        update RHDAumentos
                        set RHDltnueva = (select max(LTid) from LineaTiempo lt 
                                          where lt.DEid = RHDAumentos.DEid 
                                          and lt.LTdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">)
                        where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
                        and RHDinsertarlt = 1
                        and  LTid > 0
                        and RHDAlinea = #rsInsertLT.RHDAlinea#
                    </cfquery>
                
                </cfloop>
                
                
                 <cfquery name="rsInsertLTR" datasource="#Session.DSN#">
					select 	a.RHDAlinea, lt.DEid, lt.Ecodigo, lt.Tcodigo, lt.RHTid, lt.Ocodigo, lt.Dcodigo, lt.RHPid, lt.RHPcodigo, lt.RHPcodigoAlt, lt.RVid, lt.RHJid,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#"> as Fecha1, lt.LThasta, lt.LTporcplaza, lt.LTsalario, lt.LTporcsal,lt.RHCPlinea
                    , coalesce(lt.RHCPlineaP,0) as RHCPlineaP
					from RHDAumentos a, LineaTiempoR lt
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.RHDinsertarlt = 1
					and lt.LTRid = a.RHDltactual
                    and a.LTRid > 0
				</cfquery>
                <cfloop query="rsInsertLTR">
                	<cfquery name="insLineaTiempo" datasource="#Session.DSN#">
                        insert into LineaTiempoR (DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RHPcodigoAlt, RVid, RHJid, LTdesde,
                         LThasta, LTporcplaza, LTsalario, LTporcsal<cfif usaEstructuraSal>,RHCPlinea,RHCPlineaP</cfif> )
                        values (
                        #rsInsertLTR.DEid#, 
                        #rsInsertLTR.Ecodigo#, 
                        '#rsInsertLTR.Tcodigo#', 
                        <!---#rsInsertLTR.RHTid#,--->
						#TipoAccion#, 
                        '#rsInsertLTR.Ocodigo#', 
                        '#rsInsertLTR.Dcodigo#', 
                        #rsInsertLTR.RHPid#, 
                        '#rsInsertLTR.RHPcodigo#',
                        '#rsInsertLTR.RHPcodigoAlt#',
                        #rsInsertLTR.RVid#, 
                        #rsInsertLTR.RHJid#, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#rsInsertLTR.Fecha1#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#rsInsertLTR.LThasta#">,
                        #rsInsertLTR.LTporcplaza#, 
                        #rsInsertLTR.LTsalario#, 
                        #rsInsertLTR.LTporcsal#
                        <cfif usaEstructuraSal>
                        	<cfif len(#rsInsertLTR.RHCPlinea#) NEQ 0>, #rsInsertLTR.RHCPlinea#<cfelSe> ,NULL </cfif>
                            ,#rsInsertLTR.RHCPlineaP#
                        </cfif>
                        )
                    </cfquery>
                    
                    <!--- Obtener la nueva linea del tiempo para los registros insertados --->
                    <cfquery name="updRHDAumentos" datasource="#Session.DSN#">
                        update RHDAumentos
                        set RHDltnueva = (select max(LTRid) from LineaTiempoR lt 
                                          where lt.DEid = RHDAumentos.DEid 
                                          and lt.LTdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">)
                        where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
                        and RHDinsertarlt = 1
                        and  LTRid > 0
                        and RHDAlinea = #rsInsertLTR.RHDAlinea#
                    </cfquery>
                </cfloop>
                
                
                <!--- Obtener la nueva linea del tiempo para los registros insertados --->
				<cfquery name="updRHDAumentos" datasource="#Session.DSN#">
					update RHDAumentos
					set RHDltnueva = coalesce(LTid, LTRid)
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and coalesce(RHDltnueva,0) = 0
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
						and LineaTiempo.DEid = a.DEid
						and LineaTiempo.LTid = coalesce(a.RHDltactual,0)
					)
				</cfquery>
                
                <!--- Actualizar la Fecha Hasta de la Linea del Tiempo Anterior Lineas Recargo --->
				<cfquery name="updRHDAumentosR" datasource="#Session.DSN#">
					update LineaTiempoR
					set LThasta = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">
					where exists (
						select 1
						from RHDAumentos a
						where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and a.RHDinsertarlt = 1
						and LineaTiempoR.DEid = a.DEid
						and LineaTiempoR.LTRid = coalesce(a.RHDltactual,0)
					)
				</cfquery>
                
                
                 <cfif vDebug>
                    Relacion Actualizada
                    <cfquery name="insLineaTiempo" datasource="#Session.DSN#">
                        select *
                        from RHDAumentos
                    </cfquery>            	
                    <cfdump var="#insLineaTiempo#">

                </cfif>
				
				<!--- Insertar los Componentes de los registros insertados en la Linea del Tiempo --->
				<cfquery name="insDLineaTiempo" datasource="#Session.DSN#">
					insert into DLineaTiempo (LTid, CSid, CIid, DLTmonto, DLTunidades, DLTtabla, DLTmetodoC)
					select a.RHDltnueva, b.CSid, b.CIid, b.DLTmonto, b.DLTunidades, b.DLTtabla, b.DLTmetodoC
					from RHDAumentos a, DLineaTiempo b
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.RHDinsertarlt = 1
					and b.LTid = a.RHDltactual
                    and a.LTid > 0
				</cfquery>
                
                
                 <!---Insertar los Componentes de los registros insertados en la Linea del Tiempo Recargo--->
				<cfquery name="insDLineaTiempoR" datasource="#Session.DSN#">
					insert into DLineaTiempoR (LTRid, RHPid, RHPcodigo, CSid, CIid, DLTmonto, DLTunidades, DLTtabla, DLTmetodoC)
					select a.RHDltnueva, b.RHPid, b.RHPcodigo, b.CSid, b.CIid, b.DLTmonto, b.DLTunidades, b.DLTtabla, b.DLTmetodoC
					from RHDAumentos a, DLineaTiempoR b
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.RHDinsertarlt = 1
					and b.LTRid = a.RHDltactual
                    and a.LTRid > 0
				</cfquery>
                
                
                
         <!---     <cfthrow message="#vDebug#" >
--->
               <cfif vDebug>
                    Lineas tiempo despues del insert 
                    <cfquery name="insLineaTiempo" datasource="#Session.DSN#">
                        select *
                        from LineaTiempo
                        where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
                        order by LTdesde
                    </cfquery>            	
                    <cfdump var="#insLineaTiempo#">
                    <cfquery name="insLineaTiempoR" datasource="#Session.DSN#">
                        select *
                        from LineaTiempoR
                        where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
                        order by LTdesde
                    </cfquery>            	
                    <cfdump var="#insLineaTiempoR#">
                </cfif>

				<!--- Actualizacion del calendario de pago y monto de los salarios en la linea del tiempo a partir de la fecha en que rige el aumento --->
				<cfif usaEstructuraSal>
                
                <cfif vDebug>
                  	Lineas tiempo despues del insert 
                    <cfquery name="insLineaTiempo" datasource="#Session.DSN#">
                        select *
                        from LineaTiempo
                        where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
                        order by LTdesde
                    </cfquery>            	
                    <cfdump var="#insLineaTiempo#">
                </cfif>   
					<!--- Si usa estructura --->
					<cfquery name="updLineaTiempo" datasource="#Session.DSN#">
						update LineaTiempo set 
							LTsalario = coalesce((select b.RHDvalor
												  from RHDAumentos b
												  where b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
												  and b.DEid = LineaTiempo.DEid
                                                  and b.RHDltnueva = LineaTiempo.LTid
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
                    
                    <cfquery name="updLineaTiempoR" datasource="#Session.DSN#">
						update LineaTiempoR set 
							LTsalario = coalesce((select b.RHDvalor
												  from RHDAumentos b
												  where b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
												  and b.DEid = LineaTiempoR.DEid
                                                  and b.RHDltnueva = LineaTiempoR.LTRid
												  ), 0.00),
							CPid = (select min(e.CPid)
									from CalendarioPagos e
									where e.Ecodigo = LineaTiempoR.Ecodigo
									  and e.Tcodigo = LineaTiempoR.Tcodigo
									  and e.CPfcalculo is null
									  and e.CPtipo = 0
									  and e.CPdesde = (
											select min(z.CPdesde) 
											from CalendarioPagos z
											where z.Ecodigo = LineaTiempoR.Ecodigo
											  and z.Tcodigo = LineaTiempoR.Tcodigo
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
							  and x.DEid = LineaTiempoR.DEid
						)
					</cfquery>
                    

                    
					<!--- VERIFICA LOS QUE NO ESTAN ACTIVOS PORQUE VAN EN NÓMINA DE RETROACTIVO --->
					<cfquery name="rsCPidRetro" datasource="#session.DSN#">
						select b.DEid
						from RHEAumentos a
						inner join RHDAumentos b
							on b.RHAid = a.RHAid
						inner join LineaTiempo lt
							on lt.Ecodigo = a.Ecodigo
							and lt.DEid = b.DEid
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta
					</cfquery>
					<cfset Lvar_Inactivos = ValueList(rsCPidRetro.DEid)>
                    
					<cfif rsCPidRetro.REcordCount>
						<cfquery name="updLineaTiempo" datasource="#Session.DSN#">
							update LineaTiempo set 
								CPid = (select min(e.CPid)
										from CalendarioPagos e
										where e.Ecodigo = LineaTiempo.Ecodigo
										  and e.Tcodigo = LineaTiempo.Tcodigo
										  and e.CPfcalculo is null
										  and e.CPtipo = 3
										  and e.CPdesde = (
												select min(z.CPdesde) 
												from CalendarioPagos z
												where z.Ecodigo = LineaTiempo.Ecodigo
												  and z.Tcodigo = LineaTiempo.Tcodigo
												  and z.CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
												  and z.CPfcalculo is null
												  and z.CPtipo = 3
		
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
							and DEid not in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Lvar_Inactivos#">)
						</cfquery>
                   </cfif>     
                        
                        <!--- VERIFICA LOS QUE NO ESTAN ACTIVOS PORQUE VAN EN NÓMINA DE RETROACTIVO --->
					<cfquery name="rsCPidRetroR" datasource="#session.DSN#">
						select b.DEid
						from RHEAumentos a
						inner join RHDAumentos b
							on b.RHAid = a.RHAid
						inner join LineaTiempoR lt
							on lt.Ecodigo = a.Ecodigo
							and lt.DEid = b.DEid
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta
					</cfquery>
					<cfset Lvar_InactivosR = ValueList(rsCPidRetroR.DEid)>
                    
					<cfif rsCPidRetroR.REcordCount>
						<cfquery name="updLineaTiempo" datasource="#Session.DSN#">
							update LineaTiempoR set 
								CPid = (select min(e.CPid)
										from CalendarioPagos e
										where e.Ecodigo = LineaTiempoR.Ecodigo
										  and e.Tcodigo = LineaTiempoR.Tcodigo
										  and e.CPfcalculo is null
										  and e.CPtipo = 3
										  and e.CPdesde = (
												select min(z.CPdesde) 
												from CalendarioPagos z
												where z.Ecodigo = LineaTiempoR.Ecodigo
												  and z.Tcodigo = LineaTiempoR.Tcodigo
												  and z.CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
												  and z.CPfcalculo is null
												  and z.CPtipo = 3
		
										  )
								)
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
							and exists ( 
								select 1
								from RHDAumentos x
								where x.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
								  and x.DEid = LineaTiempoR.DEid
							)
							and DEid not in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Lvar_InactivosR#">)
						</cfquery>
					</cfif>	


                    
                 <cfif vDebug>
                    Lineas tiempo despues del insert sss
                    <cfquery name="insLineaTiempo" datasource="#Session.DSN#">
                        select *
                        from LineaTiempo
                        where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
                        and LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
                        order by LTdesde
                    </cfquery>            	
                    <cfdump var="#insLineaTiempo#">
                </cfif>
                
				<!---ljimenez Seccion para recalcular los componentes salariales de cada corte de la LineaTiempo--->
                <cfquery name="insLineaTiempo" datasource="#Session.DSN#">
                    select *
                    from LineaTiempo
                    where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> and LTid > 0)
                    and LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
                    order by LTdesde
                </cfquery>   
                
                <cfif  isdefined('insLineaTiempo') and insLineaTiempo.recordcount GT 0>
                	<cfset vTLinea ='N'>
                    <cfloop query="insLineaTiempo">
                        <cfquery name="rsDetLT" datasource="#Session.DSN#">
                            select 
                                a.LTid
                                , a.CSid
                                , a.DLTmonto
                                , a.DLTunidades
                                , a.DLTtabla
                                , a.CIid
                                , a.DLTmetodoC
                                , a.DLTporcplazacomponente
                                , b.DEid
                                , b.Ecodigo
                                , b.RHTid
                                , b.RHCPlinea
                                , b.LTdesde
                                , b.LThasta
                                , b.LTporcplaza
                                , b.LTsalario
                                , b.LTporcsal
                                , b.CPid
                                , coalesce(b.RHCPlineaP,0) as RHCPlineaP
                                , b.LTsalrec
                                , b.RHPcodigoAlt
                                , b.LTporcplazacomponente 
                                , b.RHPid
                                , 'N' as vTLinea
                            from DLineaTiempo a
                            inner join LineaTiempo b
                                on a.LTid = b.LTid
                            where a.LTid = #insLineaTiempo.LTid#
                        </cfquery>
                        <cfthrow message="#insLineaTiempo.LTid#">
                        <cfinclude template="RelacionAumento-Recalculo.cfm">
                    </cfloop>
                 </cfif>
                
				<!---ljimenez Seccion para recalcular los componentes salariales de cada corte de la LineaTiempo Recargos --->
                <cfquery name="insLineaTiempoR" datasource="#Session.DSN#">
                    select *
                    from LineaTiempoR
                    where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> and LTRid > 0)
                    and LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
                    order by LTdesde
                </cfquery>   
				<cfif  isdefined('insLineaTiempoR') and insLineaTiempoR.recordcount GT 0>
					<cfset vTLinea ='R'>
                    <cfloop query="insLineaTiempoR">
                        <cfquery name="rsDetLTR" datasource="#Session.DSN#">
                            select 
                                a.LTRid
                                , a.CSid
                                , a.DLTmonto
                                , a.DLTunidades
                                , a.DLTtabla
                                , a.CIid
                                , a.DLTmetodoC
                                <!---, a.DLTporcplazacomponente--->
                                , b.DEid
                                , b.Ecodigo
                                , b.RHTid
                                , b.RHCPlinea
                                , b.LTdesde
                                , b.LThasta
                                , b.LTporcplaza
                                , b.LTsalario
                                , b.LTporcsal
                                , b.CPid
                                , coalesce(b.RHCPlineaP,0) as RHCPlineaP
                               <!--- , b.LTsalrec--->
                                , b.RHPcodigoAlt
                                <!---, b.LTporcplazacomponente --->
                                , b.RHPid
                                , 'R' as vTLinea
                            from DLineaTiempoR a
                            inner join LineaTiempoR b
                                on a.LTRid = b.LTRid
                            where a.LTRid = #insLineaTiempoR.LTRid#
                        </cfquery>
                        <cfinclude template="RelacionAumento-Recalculo.cfm">
                    </cfloop>    
                </cfif>
                
                
                <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" 
                    ecodigo="#session.Ecodigo#" pvalor="2542" default="0" returnvariable="rsRelacionAumentoCheck"/>
                    
                <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" 
                    ecodigo="#session.Ecodigo#" pvalor="2541" default="Aumento Salarial Masivo" returnvariable="leyendaAumentoSalario"/>    

				<cf_dbfunction name="OP_concat" returnvariable="concat">
				
				<cf_dbfunction name="to_char_currency" args="b.RHDvalor" returnvariable="RHVALOR">
				
				<cf_dbfunction name="to_char_float" args="b.RHDporcentaje" dec="2" returnvariable="RHPORCENTAJE">

                
   				<!--- Insercion en DLaboralesEmpleado --->
				<cfquery name="insDLaboralesEmpleado" datasource="#Session.DSN#">
                    insert into DLaboralesEmpleado (
                        DLconsecutivo, DEid, RHTid, Ecodigo, Ecodigoant, RHPid, RHPcodigo, Tcodigo, RVid, Dcodigo, Ocodigo, RHJid, 
                        DLfvigencia, DLffin, DLsalario, DLobs, DLfechaaplic, Usucodigo, Ulocalizacion, DLporcplaza, DLporcsal,
                        Dcodigoant, Ocodigoant, RHPidant, RHPcodigoant, Tcodigoant, DLsalarioant, RVidant, DLporcplazaant, 
                        DLporcsalant, RHJidant, RHCPlinea)
					select -1, d.DEid, #TipoAccion#, d.Ecodigo, d.Ecodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, d.RVid, d.Dcodigo, d.Ocodigo, d.RHJid, 
							d.LTdesde, null, 
							<cfif usaEstructuraSal>
								b.RHDvalor, 
							<cfelse>
								d.LTsalario -(select coalesce(sum(DLTmonto),0)  
                                                    from DLineaTiempo 
                                                  	where LTid = d.LTid 
                                                   	and CIid in (select CIid 
                                                                 from ComponentesSalariales
                                                                  where Ecodigo = #session.Ecodigo# 
                                                                  and CIid is not null)
                                    ),2) * coalesce(d.LTporcsal,100)/100, <!---+ b.RHDvalor, --->
							</cfif>
							<cfif rsRelacionAumentoCheck EQ '1'>
							case
								when a.RHAtipo = 'M'
									then <cfqueryparam cfsqltype="cf_sql_varchar" value="#leyendaAumentoSalario#"> #concat# ' ( ' #concat# #preserveSingleQuotes(RHVALOR)# #concat# ' )' 
								when a.RHAtipo = 'P'
									then <cfqueryparam cfsqltype="cf_sql_varchar" value="#leyendaAumentoSalario#"> #concat# ' ( ' #concat# #preserveSingleQuotes(RHPORCENTAJE)# #concat# '% )' 
								else    <!---en el caso que sea por tabla salarial--->
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#leyendaAumentoSalario#">
							end
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#leyendaAumentoSalario#">
							</cfif>  as leyenda , 
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, d.LTporcplaza, d.LTporcsal,
							d.Dcodigo, d.Ocodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, d.LTsalario, d.RVid, d.LTporcplaza, 
                            d.LTporcsal, d.RHJid,  d.RHCPlinea
					from RHEAumentos a, RHDAumentos b, LineaTiempo d, 
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHAid = b.RHAid
					and a.Ecodigo = d.Ecodigo
					and b.DEid = d.DEid
					and a.RHAfdesde = d.LTdesde
                    and b.LTid > 0
				</cfquery>
                
				
				<!--- Insercion en DDLaboralesEmpleado --->
				<cfquery name="insDDLaboralesEmpleado" datasource="#Session.DSN#">
					insert into DDLaboralesEmpleado (DLlinea, CSid, DDLtabla, DDLunidad, DDLmontobase, 
						DDLmontores,DDLmetodoC, Usucodigo, Ulocalizacion, DDLunidadant, DDLmontobaseant, DDLmontoresant)
					select 
		                    f.DLlinea, e.CSid, e.DLTtabla, e.DLTunidades, 
							<cfif usaEstructuraSal>
                                e.DLTmonto + (case when g.CSsalariobase = 1 then (b.RHDvalor - e.DLTmonto) else 0.00 end),
                                e.DLTmonto + (case when g.CSsalariobase = 1 then (b.RHDvalor - e.DLTmonto) else 0.00 end),
							<cfelse>
                                e.DLTmonto + (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end),
                                e.DLTmonto + (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end),
							</cfif>
							e.DLTmetodoC,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
							(select z.DLTunidades from DLineaTiempo z inner join LineaTiempo y on z.LTid = y.LTid and y.LTid = b.LTid and z.CSid  = e.CSid ),
                            (select z.DLTmonto from DLineaTiempo z inner join LineaTiempo y on z.LTid = y.LTid and y.LTid = b.LTid and z.CSid  = e.CSid),
                            (select z.DLTmonto from DLineaTiempo z inner join LineaTiempo y on z.LTid = y.LTid and y.LTid = b.LTid and z.CSid  = e.CSid)
                            <!---e.DLTunidades, e.DLTmonto, e.DLTmonto--->
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
                        and b.RHDinsertarlt  = 1
                        and b.LTid > 0
				</cfquery>
                
				<!--- Actualizacion del Consecutivo en DLaboralesEmpleado --->
				<cfquery name="nextDLconsecutivo" datasource="#Session.DSN#">
					select coalesce(max(DLconsecutivo), 0) + 1 as cont
					from DLaboralesEmpleado
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfset cont = nextDLconsecutivo.cont>
				
				<cfquery name="rsDatosLaborales" datasource="#Session.DSN#">
					select DLlinea,*
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
               
				
					<!--- Modifica el salario de la linea del tiempo, recalculado la sumatoria de los componentes que se calcularon de nuevo 
						  Este update puede	ejecutarse N veces, pues seria una vez por cada componente que requiera recalculo
					--->
					<cfquery datasource="#session.DSN#">
						update LineaTiempo
						set LTsalario = (select sum(DLTmonto)
											from DLineaTiempo
											where LTid = LineaTiempo.LTid )
						where exists (select 1
										from RHDAumentos b, LineaTiempo lt
										where b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
										  and b.DEid = lt.DEid
										  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										  and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
										  and LineaTiempo.LTid = lt.LTid)
					</cfquery>
                    
                    <cfquery datasource="#session.DSN#">
						update LineaTiempoR
						set LTsalario = (select sum(DLTmonto)
											from DLineaTiempoR
											where LTRid = LineaTiempoR.LTRid )
						where exists (select 1
										from RHDAumentos b, LineaTiempoR lt
										where b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
										  and b.DEid = lt.DEid
										  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										  and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
										  and LineaTiempoR.LTRid = lt.LTRid)
					</cfquery>
                    
				<cfelse> <!---NO usa tabla salarial--->
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
<!---                    <cfthrow message="#CSid#">--->
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
				</cfif>
				
				
                <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" 
                    ecodigo="#session.Ecodigo#" pvalor="2542" default="0" returnvariable="rsRelacionAumentoCheck"/>
                    
                <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" 
                    ecodigo="#session.Ecodigo#" pvalor="2541" default="Aumento Salarial Masivo" returnvariable="leyendaAumentoSalario"/>    

				<cf_dbfunction name="OP_concat" returnvariable="concat">
				
				<cf_dbfunction name="to_char_currency" args="b.RHDvalor" returnvariable="RHVALOR">
				<cf_dbfunction name="to_char_float" args="b.RHDporcentaje" dec="2" returnvariable="RHPORCENTAJE">

   				<!--- Insercion en DLaboralesEmpleado --->
				<cfquery name="insDLaboralesEmpleado" datasource="#Session.DSN#">
                    insert into DLaboralesEmpleado (
                        DLconsecutivo, DEid, RHTid, Ecodigo, Ecodigoant, RHPid, RHPcodigo, Tcodigo, RVid, Dcodigo, Ocodigo, RHJid, 
                        DLfvigencia, DLffin, DLsalario, DLobs, DLfechaaplic, Usucodigo, Ulocalizacion, DLporcplaza, DLporcsal,
                        Dcodigoant, Ocodigoant, RHPidant, RHPcodigoant, Tcodigoant, DLsalarioant, RVidant, DLporcplazaant, 
                        DLporcsalant, RHJidant, RHCPlinea)
					select -1, d.DEid, #TipoAccion#, d.Ecodigo, d.Ecodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, d.RVid, d.Dcodigo, d.Ocodigo, d.RHJid, 
							d.LTdesde, null, 
							<cfif usaEstructuraSal>
								b.RHDvalor, 
							<cfelse>
								round(d.LTsalario -(select coalesce(sum(DLTmonto),0)  
                                                    from DLineaTiempo 
                                                  	where LTid = d.LTid 
                                                   	and CIid in (select CIid 
                                                                 from ComponentesSalariales
                                                                  where Ecodigo = #session.Ecodigo# 
                                                                  and CIid is not null)
                                    ),2) * coalesce(d.LTporcsal,100)/100, 
							</cfif>
							<cfif rsRelacionAumentoCheck EQ '1'>
							case
								when a.RHAtipo = 'M'
									then <cfqueryparam cfsqltype="cf_sql_varchar" value="#leyendaAumentoSalario#"> #concat# ' ( ' #concat# #preserveSingleQuotes(RHVALOR)# #concat# ' )' 
								when a.RHAtipo = 'P'
									then <cfqueryparam cfsqltype="cf_sql_varchar" value="#leyendaAumentoSalario#"> #concat# ' ( ' #concat# #preserveSingleQuotes(RHPORCENTAJE)# #concat# '% )' 
								else    <!---en el caso que sea por tabla salarial--->
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#leyendaAumentoSalario#">
							end
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#leyendaAumentoSalario#">
							</cfif>  as leyenda , 
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, d.LTporcplaza, d.LTporcsal,
							d.Dcodigo, d.Ocodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, (d.LTsalario -  b.RHDvalor), d.RVid, d.LTporcplaza, 
                            d.LTporcsal, d.RHJid,  d.RHCPlinea
					from RHEAumentos a, RHDAumentos b, LineaTiempo d
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHAid = b.RHAid
					and a.Ecodigo = d.Ecodigo
					and b.DEid = d.DEid
					and a.RHAfdesde = d.LTdesde
                    and b.LTid > 0
				</cfquery>
                
				
				<!--- Insercion en DDLaboralesEmpleado --->
				<cfquery name="insDDLaboralesEmpleado" datasource="#Session.DSN#">
					insert into DDLaboralesEmpleado (DLlinea, CSid, DDLtabla, DDLunidad, DDLmontobase, 
						DDLmontores,DDLmetodoC, Usucodigo, Ulocalizacion, DDLunidadant, DDLmontobaseant, DDLmontoresant)
					select 
		                    f.DLlinea, e.CSid, e.DLTtabla, e.DLTunidades, 
							<cfif usaEstructuraSal>
                                e.DLTmonto + (case when g.CSsalariobase = 1 then (b.RHDvalor - e.DLTmonto) else 0.00 end),
                                e.DLTmonto + (case when g.CSsalariobase = 1 then (b.RHDvalor - e.DLTmonto) else 0.00 end),
							<cfelse>
                                e.DLTmonto <!---+ (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end) ya viene incluido en de l DLlineaTiempo--->,
                                e.DLTmonto <!---+ (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end) ya viene incluido en de l DLlineaTiempo--->,
							</cfif>
							e.DLTmetodoC,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
							(select z.DLTunidades from DLineaTiempo z , LineaTiempo y 
                                    where z.LTid = y.LTid 
                                        and z.CSid = e.CSid
                                        and  y.LTid = b.LTid ) ,
                            (select z.DLTmonto from DLineaTiempo z , LineaTiempo y 
                                    where z.LTid = y.LTid 
                                        and z.CSid = e.CSid
                                        and  y.LTid = b.LTid ) - (b.RHDvalor),
                            (select z.DLTmonto from DLineaTiempo z , LineaTiempo y 
                                    where z.LTid = y.LTid 
                                        and z.CSid = e.CSid
                                        and  y.LTid = b.LTid ) - (b.RHDvalor)
		<!---					(select z.DLTunidades from DLineaTiempo z inner join LineaTiempo y on z.LTid = y.LTid and y.LTid = b.LTid and z.CSid  = e.CSid ) ,
                            (select z.DLTmonto from DLineaTiempo z inner join LineaTiempo y on z.LTid = y.LTid and y.LTid = b.LTid and z.CSid  = e.CSid) - (b.RHDvalor),
                            (select z.DLTmonto from DLineaTiempo z inner join LineaTiempo y on z.LTid = y.LTid and y.LTid = b.LTid and z.CSid  = e.CSid) - (b.RHDvalor)--->
                            <!---e.DLTunidades, e.DLTmonto, e.DLTmonto--->
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
                        <!---and b.RHDinsertarlt  = 1--->
                        and b.LTid > 0
				</cfquery>
                
				<!--- Actualizacion del Consecutivo en DLaboralesEmpleado --->
				<cfquery name="nextDLconsecutivo" datasource="#Session.DSN#">
					select coalesce(max(DLconsecutivo), 0) + 1 as cont
					from DLaboralesEmpleado
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfset cont = nextDLconsecutivo.cont>
				
				<cfquery name="rsDatosLaborales" datasource="#Session.DSN#">
					select a.DLlinea, a.*
					from DLaboralesEmpleado a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.DLconsecutivo = -1
					order by a.DLlinea
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
               

				
				<!--- Modifica el salario de la linea del tiempo, recalculado la sumatoria de los componentes que se calcularon de nuevo 
					  Este update puede	ejecutarse N veces, pues seria una vez por cada componente que requiera recalculo
				--->
                <!---<cfthrow message="#TipoAccion#">--->
                
				<cfquery datasource="#session.DSN#">
					update LineaTiempo
					set <!---LTsalario = (select sum(DLTmonto)
										from DLineaTiempo
										where LTid = LineaTiempo.LTid ), Para que no  sume los vales---> 
                         RHTid = #TipoAccion#
                    where exists (select 1
									from RHDAumentos b, LineaTiempo lt
									where b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
									  and b.DEid = lt.DEid
									  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									  and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
									  and LineaTiempo.LTid = lt.LTid)
							and RHTid<>'50'       <!---ERBG Cambio para que no sobreescriba las faltas--->                               
				</cfquery>
				
				<cfquery datasource="#session.DSN#">
					update LineaTiempoR
					set LTsalario = (select sum(DLTmonto)
										from DLineaTiempoR
										where LTRid = LineaTiempoR.LTRid )
						, RHTid = #TipoAccion#                                        
					where exists (select 1
									from RHDAumentos b, LineaTiempoR lt
									where b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
									  and b.DEid = lt.DEid
									  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									  and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
									  and LineaTiempoR.LTRid = lt.LTRid)
                            and RHTid<>'50'       <!---ERBG Cambio para que no sobreescriba las faltas---> 
				</cfquery>
                                    
                
				<!--- Actualizacion del estado del lote de aumentos --->
				<cfquery name="updRHEAumentos" datasource="#Session.DSN#">
					update RHEAumentos
					set RHAestado = 1
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
			</cfif>
		</cfloop>
       <!---- Registro  en  Datos Empleado  y  linea de Tiempo el  SDI    IRR-APH 080812---> 
    	 <cfquery name="rsActSDI_DE" datasource="#session.dsn#">
                	select distinct dle.DEid, Tcodigo, RVid, DLfvigencia, RHTid, DLsalario ,max(RHDltnueva) as Ltid 
					from  DLaboralesEmpleado dle
					left join RHDAumentos rhA  on  dle.deid = rhA.deid
					where   Ecodigo = #session.Ecodigo#
                    and DLfvigencia>= '#Fecha1#' 
					and RHTid = #TipoAccion#
					group by dle.DEid, Tcodigo, RVid, DLfvigencia, RHTid, DLsalario
         </cfquery>  
         <cfloop query="rsActSDI_DE">
            <cfinvoke component="rh.Componentes.RH_CalculoSDI" method="fnSDImasivo" returnvariable="SDIm">       
            	<cfinvokeargument name="DEid" value="#rsActSDI_DE.DEid#"/>
                <cfinvokeargument name="RVid" value="#rsActSDI_DE.RVid#"/>
                <cfinvokeargument name="SalarioM" value="#rsActSDI_DE.DLsalario#"/>
                <cfinvokeargument name="Fecha" value="#Fecha1#"/>
            </cfinvoke>
            <cfquery name="upLtSdi" datasource="#session.dsn#">
            	update LineaTiempo
                set LTSalarioSDI = #SDIm#
                where Deid = #rsActSDI_DE.Deid#
                and Ltid = #rsActSDI_DE.Ltid#
            </cfquery>
            <cfquery name="upDEsdi" datasource="#session.dsn#">
            	update DatosEmpleado
                set DEsdi =  #SDIm#
                where Deid = #rsActSDI_DE.Deid#
                and Ecodigo = #session.Ecodigo#
            </cfquery>
         </cfloop>   
         <!------------------------------------------------------------------------------------------------>
         
	</cfif>
    
  <!--- Aqui podria generar la actualizaciópn  del SDI---->  

<cfif vDebug>
    
    lineas tiempo normal
    <cfquery name="insLineaTiempo" datasource="#Session.DSN#">
    select *
    from LineaTiempo;
    where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
    order by LThasta, LTdesde
    </cfquery>            	
    <cfdump var="#insLineaTiempo#">
    
    
    lineas tiempo Recargo
    <cfquery name="insLineaTiempoR" datasource="#Session.DSN#">
    select *
    from LineaTiempoR
    where DEid in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
    order by LThasta, LTdesde
    </cfquery>    
    recargos        	
    <cfdump var="#insLineaTiempoR#">
                                    
    <cfquery name="insLineaTiempo" datasource="#Session.DSN#">
    select *
    from RHDAumentos
    
    </cfquery>            	
    <cfdump var="#insLineaTiempo#">

rsDLaboralesEmpleado
<cfquery name="rsDLaboralesEmpleado" datasource="#Session.DSN#">
    select *
    from DLaboralesEmpleado;
	where DEid  in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
    
    </cfquery>            	
    <cfdump var="#rsDLaboralesEmpleado#">


rsDLaboralesEmpleadorsDLaboralesEmpleado
<cfquery name="rsDLaboralesEmpleado" datasource="#Session.DSN#">
    select b.*
    from DLaboralesEmpleado a
	inner join DDLaboralesEmpleado b;
	on a.DLlinea = b.DLlinea
	where a.DEid  in (select distinct DEid from RHDAumentos where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">)
    
    </cfquery>            	
    <cfdump var="#rsDLaboralesEmpleado#">
	


<cftransaction action="rollback">
    <cf_dump var="Fin de Debug Linea  1630 + -">
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
