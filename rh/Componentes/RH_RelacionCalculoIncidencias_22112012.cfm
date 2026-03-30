	<!---ljimenez sacamos el mes periodo actual de la nomina--->
	<cfquery name="rsActual" datasource="#session.dsn#">
		select CPmes, CPperiodo
		from CalendarioPagos
		where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	</cfquery>

     <cfif CalendarioPagos.CPtipo IS 0 or CalendarioPagos.CPtipo IS 2>
        <!--- ljimenez 
		Insertar como Incidencias los componentes Salariales que se pagan independientes del salario base --->
        
		<cfquery datasource="#Arguments.datasource#" name="rsCSSB">
			insert into IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo,
			Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, RHJid,CPmes,CPperiodo,CSid)  

			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, b.DEid, ld.CIid, b.PEdesde,
				case 
                	when ta.RHTcomportam  <> 13 then 
		                ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
                   	else
                        ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#"> * (1-coalesce(ta.RHTfactorfalta,1))
               	end,
				getdate(), <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 0, null, 0.00, 
                
                case 
                	when ta.RHTcomportam  <> 13 then 
		                ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
                   	else
                        ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#"> * (1-coalesce(ta.RHTfactorfalta,1))
               	end as ICmontores, 
                 coalesce(p.CFidconta, p.CFid), lt.RHJid
                ,#rsActual.CPmes#,#rsActual.CPperiodo#, ld.CSid
			from #PagosEmpleado# b, LineaTiempo lt, DLineaTiempo ld, 
				ComponentesSalariales a, RHPlazas p
				<cfif CalendarioPagos.CPtipo IS 2>
					,CIncidentes ci
				</cfif>
					,RHTipoAccion ta
			where b.PEtiporeg < 2  <!--- se calculan primero los positivos y abajo los negativos---> 
			  and lt.DEid = b.DEid
			  and b.PEdesde between lt.LTdesde and lt.LThasta
			  and ld.LTid = lt.LTid
			  and ld.CIid is not null
			  <cfif CalendarioPagos.CPtipo IS 2>
				  and a.CIid = ci.CIid
				  and ci.CInoanticipo = 1
			  </cfif>
				  and a.CSid = ld.CSid
				  and p.RHPid = lt.RHPid
				  and lt.RHTid = ta.RHTid
			  <cfif rsEmpresa.RecordCount NEQ 0>
				  and (ta.RHTpaga = 1
			  		or (ta.RHTpaga = 0 and exists (select 1 from RHComponentesPagarA cp where cp.RHTid = ta.RHTid and cp.CSid = a.CSid)))
			  <cfelse>
					and ta.RHTpaga = 1
			  </cfif>
			  and b.LTRid = 0
		</cfquery>
        


		
		
		
		 <!---inserta  las componentes de salario en especie cuando se tienen vacaciones ljimenez 20120315--->
      <cfquery datasource="#Arguments.datasource#" name="rsCSSB1">
  			insert into IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo,
			Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, RHJid,CPmes,CPperiodo,CSid)  

			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, b.DEid, ld.CIid, b.PEdesde,
				case 
                	when ta.RHTcomportam  = 3 then 
		                ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
                   	else
                        ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#"> * (1-coalesce(ta.RHTfactorfalta,1))
               	end,
				<cf_dbfunction name="today">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 0, null, 0.00, 
                
                case 
                	when ta.RHTcomportam  = 3 then 
		                ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
                   	else
                        ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#"> * (1-coalesce(ta.RHTfactorfalta,1))
               	end as ICmontores, 
                 coalesce(p.CFidconta, p.CFid), lt.RHJid
                ,#rsActual.CPmes#,#rsActual.CPperiodo#, ld.CSid
			from #PagosEmpleado# b, LineaTiempo lt, DLineaTiempo ld, 
				ComponentesSalariales a, RHPlazas p
				<cfif CalendarioPagos.CPtipo IS 2>
					,CIncidentes ci
				</cfif>
					,RHTipoAccion ta
			where b.PEtiporeg < 2  <!--- se calculan primero los positivos y abajo los negativos---> 
			  and lt.DEid = b.DEid
			  and b.PEdesde between lt.LTdesde and lt.LThasta
			  and ld.LTid = lt.LTid
			  and lt.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- Evitar que lleguen Incidencias de una Empresa Diferente --->
			  and ld.CIid is not null
			  <cfif CalendarioPagos.CPtipo IS 2>
				  and a.CIid = ci.CIid
				  and ci.CInoanticipo = 1
			  </cfif>
				  and a.CSid = ld.CSid
				  and p.RHPid = lt.RHPid
				  and lt.RHTid = ta.RHTid
			  <cfif rsEmpresa.RecordCount NEQ 0>
				  and (ta.RHTpaga = 0
			  		or (ta.RHTpaga = 0 and exists (select 1 from RHComponentesPagarA cp where cp.RHTid = ta.RHTid and cp.CSid = a.CSid)))
			  <cfelse>
					and ta.RHTpaga = 0
			  </cfif>
			  and b.LTRid = 0
		</cfquery>
		
		
		
		

		
         
 
        
      	<!--- ********************************  RECARGOS --->
         <cfquery datasource="#Arguments.datasource#">
           insert into IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, 
                Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, RHJid,CPmes,CPperiodo)
                select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, b.DEid, ld.CIid, b.PEdesde,
                    ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#"> , 
                    getdate(), <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 0, null, 0.00, 
                    ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#"> as ICmontores, coalesce(p.CFidconta, p.CFid), lt.RHJid
                    ,#rsActual.CPmes#,#rsActual.CPperiodo#
                from #PagosEmpleado# b, LineaTiempoR lt, DLineaTiempoR ld, 
                    ComponentesSalariales a, RHPlazas p
                    <cfif CalendarioPagos.CPtipo IS 2>
                        ,CIncidentes ci
                    </cfif>
                        ,RHTipoAccion ta
                where b.PEtiporeg = 1 <!--- se calculan primero los positivos y abajo los negativos---> 
                  and lt.DEid = b.DEid
                  and b.PEdesde between lt.LTdesde and lt.LThasta
                  and b.LTRid = lt.LTRid
                  and ld.LTRid = lt.LTRid
                  and ld.CIid is not null
                  <cfif CalendarioPagos.CPtipo IS 2>
                      and a.CIid = ci.CIid
                      and ci.CInoanticipo = 1
                  </cfif>
                      and a.CSid = ld.CSid
                      and p.RHPid = lt.RHPid
                      and lt.RHTid = ta.RHTid
                  <cfif rsEmpresa.RecordCount NEQ 0>
                      and (ta.RHTpaga = 1
                        or (ta.RHTpaga = 0 and exists (select 1 from RHComponentesPagarA cp where cp.RHTid = ta.RHTid and cp.CSid = a.CSid)))
                <cfelse>
                    and ta.RHTpaga = 1
                  </cfif>
                 and b.LTid = 0
            </cfquery>
            
            

             <cfquery datasource="#Arguments.datasource#">
               insert into IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, 
                    Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, RHJid,CPmes,CPperiodo)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, b.DEid, ld.CIid, b.PEdesde,
                        ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#"> , 
                        getdate(), <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 0, null, 0.00, 
                         ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#"> as ICmontores, coalesce(p.CFidconta, p.CFid), lt.RHJid
                        ,#rsActual.CPmes#,#rsActual.CPperiodo#
                    from #PagosEmpleado# b, LineaTiempoR lt, DLineaTiempoR ld, 
                        ComponentesSalariales a, RHPlazas p
                        <cfif CalendarioPagos.CPtipo IS 2>
                            ,CIncidentes ci
                        </cfif>
                            ,RHTipoAccion ta
                    where b.PEtiporeg = 0 <!--- se calculan primero los positivos y abajo los negativos---> 
                      and lt.DEid = b.DEid
                      and b.PEdesde between lt.LTdesde and lt.LThasta
                      and b.LTRid = lt.LTRid
                      and ld.LTRid = lt.LTRid
                      and ld.CIid is not null
                      <cfif CalendarioPagos.CPtipo IS 2>
                          and a.CIid = ci.CIid
                          and ci.CInoanticipo = 1
                      </cfif>
                          and a.CSid = ld.CSid
                          and p.RHPid = lt.RHPid
                          and lt.RHTid = ta.RHTid
                      <cfif rsEmpresa.RecordCount NEQ 0>
                          and (ta.RHTpaga = 1
                            or (ta.RHTpaga = 0 and exists (select 1 from RHComponentesPagarA cp where cp.RHTid = ta.RHTid and cp.CSid = a.CSid)))
                    <cfelse>
                        and ta.RHTpaga = 1
                      </cfif>
                </cfquery>            
       <!--- ************************ FIN RECARGOS --->
  
		<!--- Se calculan las Incidencias Retroactivas Negativas  (Componentes Salariales Incidentes)  --->
 			<cfquery datasource="#Arguments.datasource#" name="jc">
                insert into IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, 
                Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, RHJid , CPmes, CPperiodo,ICpadreIid)
                select 	distinct <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> as RCNid, 
                        b.DEid, 
                        a.CIid, 
                        a.ICfecha,
                        coalesce(a.ICmontores,0) *-1 as monto,
                    getdate(), 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 
                    0, null, 0.00, 
                    coalesce(a.ICmontores,0) *-1 as ICmontores, a.CFid , a.RHJid
                    , d.CPmes, d.CPperiodo,ICid
                from HIncidenciasCalculo a
                inner join #PagosEmpleado# b
                    on b.DEid = a.DEid
                inner join ComponentesSalariales c
                    on c.CIid = a.CIid
                inner join CalendarioPagos d
                	on d.CPid = a.RCNid
                where b.PEtiporeg = 2
                  and a.ICfecha between b.PEdesde and b.PEhasta
                  and a.ICmontoant = 0
                  and c.CIid is not null
            </cfquery>


       <!--- Insertar Incidencias de este pago correspondientes a valores que se calculan con respecto al salario del empleado Ej: ER  horas extra--->
		<cfquery datasource="#Arguments.datasource#">
		   insert into IncidenciasCalculo (	RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
		   									ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, Iid, RHJid, 
											Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta
											, CPmes, CPperiodo, Ifechacontrol)
		   
		   select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, a.DEid, a.CIid, a.Ifecha, a.Ivalor, 
		   			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, a.Usucodigo, a.Ulocalizacion, 0, null, 0.00, 0.00, 
					coalesce(a.CFid, coalesce(p.CFidconta, p.CFid)), a.Iid, coalesce(a.RHJid, lt.RHJid),
					a.Iusuaprobacion, a.Ifechaaprobacion, a.NAP, a.NRP, a.Inumdocumento, a.CFcuenta
					, #rsActual.CPmes#, #rsActual.CPperiodo#, a.Ifechacontrol

		   from #EmpleadosNomina# b, Incidencias a, CIncidentes c, RHPlazas p, LineaTiempo lt
		   where a.DEid = b.DEid
			 and a.Ifecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Dateadd('d',1,RCalculoNomina.RChasta)#">
			 and a.Iespecial = 0
			 and a.Icpespecial = 0
			 <!--- and c.CIlimitaconcepto = 0 ljimenez la incidencia esta limitada a un valor --->
			 and c.CIid = a.CIid
			 and c.CItipo < 2
			 and lt.DEid = b.DEid
			 and a.Ifecha between lt.LTdesde and lt.LThasta
			 and p.RHPid = lt.RHPid
			 and not exists(select 1 from IncidenciasCalculo ic 
			 				where ic.DEid = a.DEid 
							  and ic.CIid = a.CIid 
							  and ic.ICfecha = a.Ifecha 
							  and ic.Iid = a.Iid)
			<cfif CalendarioPagos.CPtipo EQ 2>
			 and c.CInoanticipo = 1
			</cfif>
			
			<cfif apruebaIncidencias >
				and a.Iestado = 1
				and a.NAP is not null
			</cfif>			
       	</cfquery>

		
	   <!--- Insertar Incidencias no pagadas que corresponden a importe 
			o a cálculo de cualquier nómina igual o anterior a la que se está procesando Ej: Comisiones
			SI LA NOMINA ES DE ANTICIPO NO SE TOMAN EN CUENTA ESAS INCIDENCIAS SOLO SI ES LA INCIDENCIA DE 
			ANTICIPO
			--->
		 <!--- TRAE EL CONCEPTO DE PAGO DEFINIDO PARA ANTICIPO DE SALARIO --->
		<cfif CalendarioPagos.CPtipo IS 2>
			<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="730" default="" returnvariable="CIidAnticipo"/>
			<cfif Not Len(CIidAnticipo)>
				<cfthrow message="Error!, No se ha definido el Concepto de Pago para Anticipos de Salario a utilizar en los parámetros del Sistema. Proceso Cancelado!!">
			</cfif>
		</cfif>
		<cfquery datasource="#Arguments.datasource#">
		   insert into IncidenciasCalculo (	RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
		   									ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, Iid, RHJid,
											Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta,CPmes,CPperiodo, Ifechacontrol)

		   select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,a.DEid, a.CIid, a.Ifecha, a.Ivalor , 
		   			<cfqueryparam cfsqltype="cf_sql_date"value="#now()#">, coalesce(a.Usucodigo, #session.Usucodigo#),'#Arguments.Ulocalizacion#', 0, null, 0.00, 
					coalesce(a.Imonto, a.Ivalor,0.00),coalesce(a.CFid, coalesce(p.CFidconta, p.CFid)), a.Iid, coalesce(a.RHJid,lt.RHJid),
					a.Iusuaprobacion, a.Ifechaaprobacion, a.NAP, a.NRP, a.Inumdocumento, a.CFcuenta
					,#rsActual.CPmes#,#rsActual.CPperiodo# , a.Ifechacontrol
		   from #EmpleadosNomina# b, Incidencias a, CIncidentes c, LineaTiempo lt, RHPlazas p

		   where a.DEid = b.DEid
			 and a.Ifecha  < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Dateadd('d',1,RCalculoNomina.RChasta)#">
			 and a.Iespecial = 0
			 and a.Icpespecial = 0
			 and c.CIid = a.CIid
			 and c.CItipo > 1
			 and lt.DEid = a.DEid
			 and a.Ifecha between lt.LTdesde and lt.LThasta
			 and p.RHPid = lt.RHPid
			 and not exists(select 1 from IncidenciasCalculo ic where ic.DEid = a.DEid and ic.CIid = a.CIid and ic.ICfecha = a.Ifecha)
<!--- ERBG Modificación para evitar conceptos con corportamiento CESE aparezcan en calculo de nómina normal Inicia--->
             and c.CIid not in(select a.CIid from ConceptosTipoAccion a
								inner join RHTipoAccion b
								on a.RHTid = b.RHTid
								where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
								and b.RHTcomportam = 2)
<!--- ERBG Modificación para evitar conceptos con corportamiento CESE aparezcan en calculo de nómina normal Fin--->
			 <cfif CalendarioPagos.CPtipo IS 2>
			 	and c.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidAnticipo#">
			 </cfif>
			<cfif apruebaIncidencias >
				and a.Iestado = 1
				and a.NAP is not null
			</cfif>
	   </cfquery>
   <!--- SI EL FUNCIONARIO NO ESTA VIGENTE DENTRO DE LA LINEA DE TIEMPO PRINCIPAL SE VERIFICA SI ESTA VIGENTE EN LA DE RECARGO PARA TOMAR EN CUENTA LAS INCIDENCIAS
   	ANTERIORES A LA NÓMINA EN PROCESO --->
		<cfquery datasource="#Arguments.datasource#">
		   insert into IncidenciasCalculo (	RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
		   									ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, Iid, RHJid,
											Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta,CPmes,CPperiodo)

		   select distinct <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,a.DEid, a.CIid, a.Ifecha, a.Ivalor , 
		   			<cfqueryparam cfsqltype="cf_sql_date"value="#now()#">, coalesce(a.Usucodigo, #session.Usucodigo#),'#Arguments.Ulocalizacion#', 0, null, 0.00, 
					coalesce(a.Imonto, a.Ivalor,0.00),a.CFid, a.Iid, coalesce(a.RHJid,lt.RHJid),
					a.Iusuaprobacion, a.Ifechaaprobacion, a.NAP, a.NRP, a.Inumdocumento, a.CFcuenta
					,#rsActual.CPmes#,#rsActual.CPperiodo#
		   from #EmpleadosNomina# b, Incidencias a, CIncidentes c, LineaTiempoR lt, RHPlazas p

		   where a.DEid = b.DEid
			 and a.Ifecha  < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Dateadd('d',1,RCalculoNomina.RChasta)#">
			 and a.Iespecial = 0
			 and a.Icpespecial = 0
			 and c.CIid = a.CIid
			 and c.CItipo > 1
			 and lt.DEid = a.DEid
			 and a.Ifecha between lt.LTdesde and lt.LThasta
			 and p.RHPid = lt.RHPid
			 and not exists(select 1 from IncidenciasCalculo ic where ic.DEid = a.DEid and ic.CIid = a.CIid and ic.ICfecha = a.Ifecha)
			 <cfif CalendarioPagos.CPtipo IS 2>
			 	and c.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidAnticipo#">
			 </cfif>
			<cfif apruebaIncidencias >
				and a.Iestado = 1
				and a.NAP is not null
			</cfif>
	   </cfquery>       
	   
	   <!--- Insertar todos los conceptos de cálculo retroactivos Ej: Horas pagadas en nóminas anteriores--->
	   <cfquery datasource="#Arguments.datasource#">
		   insert into IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, 
           	ICmontoant, ICmontores, CFid, RHJid,CPmes,CPperiodo, Ifechacontrol)
		   select distinct <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, a.DEid, a.CIid, a.ICfecha, min(a.ICvalor), 
           <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 0, null, 
           sum(round(a.ICmontores - a.ICmontoant,2)), 0.00 as ICmontores, min(isnull(a.CFid, isnull(p.CFidconta, p.CFid))), a.RHJid
           ,d.CPmes,d.CPperiodo, a.Ifechacontrol
		   from #PagosEmpleado# b, HIncidenciasCalculo a, CIncidentes c, RHPlazas p,CalendarioPagos d
		   where b.PEtiporeg = 1
			 and a.DEid = b.DEid
			 and a.ICfecha between b.PEdesde and b.PEhasta
			 and a.ICvalor != 0.00
			 and c.CIid = a.CIid
			 and c.CItipo < 2
			 and p.RHPid = b.RHPid
             and d.CPid = a.RCNid
			 <cfif CalendarioPagos.CPtipo EQ 2>
			 	and c.CInoanticipo = 1
			</cfif>
			<!--- LZ 24 de Febrero 2009 Problema con Calculo de Retroactivos sobre Otro Retroactivo, Solo se hace sobre los casos donde ICmontoant = 0 (No es Retroactivo de Retroactivo)  --->
			and a.ICmontoant = 0
			  and not exists (Select 1 
			  					from HIncidenciasCalculo hci
			  					Where a.ICfecha = hci.ICfecha
			  					and a.DEid=hci.DEid
			  					and a.RCNid < hci.RCNid
			  					and a.ICmontores= hci.ICmontoant)
			 and b.LTid > 0
			 group by a.DEid, a.CIid, a.ICfecha,a.RHJid,d.CPmes,d.CPperiodo,a.Ifechacontrol
		</cfquery>
        

		
        <!--- Insertar los datos de Subsidios / Rebajos vigentes en la tabla RHSaldoPagosExceso cuando la nomina es normal.--->
		<cfquery datasource="#Arguments.datasource#" name="RSP">
			insert into #IncidenciasReb# (
				RCNid, DEid, CIid, ICfecha, ICvalor,  ICfechasis, CFid, RHSPEid, diassalario, saldoreb, saldosub, dias, diasacum, diasant)
			select 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, 
				pe.DEid, ta.CIncidente1, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#RCalculoNomina.RCdesde#">,
				RHSPEsaldiario,
				<cfqueryparam value="#LSDateFormat(now())#" cfsqltype="cf_sql_date">,
				coalesce(p.CFidconta, p.CFid), RHSPEid, 0, pe.RHSPEsaldo, pe.RHSPEsaldosub, 
				ceiling(case 
						when RHSPEsaldiario > 0 and RHSPEsaldo > 0
							then RHSPEsaldo / RHSPEsaldiario
						when RHSPEsubdiario > 0 and RHSPEsaldosub > 0
							then RHSPEsaldosub / RHSPEsubdiario
					else
						0
					end), 
				0,
				0
			from #EmpleadosNomina# b, 
			RHSaldoPagosExceso pe, 
			RHTipoAccion ta, 
			LineaTiempo lt,
			RHPlazas p
			
			where pe.DEid = b.DEid
			  and pe.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and (pe.RHSPEsaldo > 0.01 or pe.RHSPEsaldosub > 0.01)
			  and pe.RHSPEfdesdesig  < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Dateadd('d',1,RCalculoNomina.RChasta)#">
			  and ta.RHTid = pe.RHTid
			  and lt.DEid = pe.DEid
			  and pe.RHSPEfdesde between lt.LTdesde and lt.LThasta
			  and p.RHPid = lt.RHPid
			  and pe.RHSPEanulado = 0
		</cfquery>
        
    <cfelse>

		<!--- Insertar todas las incidencias de la relación de cálculo especial que esten definidas en el calendario --->
		<cfquery datasource="#Arguments.datasource#" name="rsEspecial"> 
			insert into IncidenciasCalculo ( RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
											 ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, Iid, RHJid,
											 Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta,CPmes,CPperiodo, Ifechacontrol)

			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, a.DEid, a.CIid, a.Ifecha, 
					round(a.Ivalor,2), getdate(), a.Usucodigo, a.Ulocalizacion, 0, null, 0.00, round(coalesce(a.Imonto, a.Ivalor, a.Imonto),2), 
					isnull(a.CFid, isnull(p.CFidconta, p.CFid)), a.Iid, coalesce(a.RHJid, lt.RHJid),
					a.Iusuaprobacion, a.Ifechaaprobacion, a.NAP, a.NRP, a.Inumdocumento, a.CFcuenta
					,cp.CPmes,cp.CPperiodo, a.Ifechacontrol
			from 
				#EmpleadosNomina# b, 
				Incidencias a, 
				LineaTiempo lt, 
				RHPlazas p, 
				CalendarioPagos cp, 
				CCalendario cc,
				CIncidentes c

			where a.DEid = b.DEid
			  and a.Ifecha  < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Dateadd('d',1,RCalculoNomina.RChasta)#">
			  and lt.DEid = a.DEid
			  and a.Ifecha between lt.LTdesde and lt.LThasta
  			  and a.Icpespecial = 0
			  and p.RHPid = lt.RHPid
			  and cp.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and cc.CPid = cp.CPid
			  and c.CIid = cc.CIid
			  and c.CIid = a.CIid
			  and c.CItipo > 1             --Cálculo e Importe
			  and not exists(select 1 from IncidenciasCalculo ic where ic.DEid = a.DEid and ic.CIid = a.CIid and ic.ICfecha = a.Ifecha)
  			<cfif apruebaIncidencias >
				and a.Iestado = 1
				and a.NAP is not null
			</cfif>
		</cfquery>

	    <!--- Insertar Incidencias de este pago correspondientes a valores que se calculan con respecto al salario del empleado Ej: horas extra--->
		<cfquery datasource="#Arguments.datasource#">
		   insert into IncidenciasCalculo (	RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
		   									ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, Iid, RHJid,
											Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta
                                            ,CPmes,CPperiodo, Ifechacontrol)
		   
		   select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, a.DEid, a.CIid, a.Ifecha, 
		   			round(a.Ivalor,2), getdate(), a.Usucodigo, a.Ulocalizacion, 0, null, 0.00, 0.00, 
					coalesce(a.CFid, coalesce(p.CFidconta, p.CFid)), a.Iid, coalesce(a.RHJid, lt.RHJid),
					a.Iusuaprobacion, a.Ifechaaprobacion, a.NAP, a.NRP, a.Inumdocumento, a.CFcuenta
		   			,#rsActual.CPmes#,#rsActual.CPperiodo#, a.Ifechacontrol
		   from #EmpleadosNomina# b, Incidencias a, CIncidentes c, RHPlazas p, LineaTiempo lt
		   
		   where a.DEid = b.DEid
			 and a.Ifecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Dateadd('d',1,RCalculoNomina.RChasta)#">
			 and a.Iespecial = 0
			 and a.Icpespecial = 1
			 and c.CIid = a.CIid
			 and c.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			 and c.CItipo < 2
			 and lt.DEid = b.DEid
			 and a.Ifecha between lt.LTdesde and lt.LThasta
			 and lt.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			 			 			 
			 and p.RHPid = lt.RHPid
			 and not exists(select 1 from IncidenciasCalculo ic 
			 				where ic.DEid = a.DEid 
							  and ic.CIid = a.CIid 
							  and ic.ICfecha = a.Ifecha 
							  and ic.Iid = a.Iid)
			<cfif apruebaIncidencias >
				and a.Iestado = 1
				and a.NAP is not null
			</cfif>
       	</cfquery>
        
	   <!--- Insertar Incidencias no pagadas que corresponden a importe o a cálculo de cualquier nómina igual o anterior a la que se está procesando Ej: Comisiones--->
		<cfquery datasource="#Arguments.datasource#">
		   insert into IncidenciasCalculo (	RCNid, DEid, CIid, ICfecha, 
           									ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch,
		   									 ICmontoant, ICmontores, CFid, Iid, RHJid,
											Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta
                                            ,CPmes,CPperiodo, Ifechacontrol )

		   select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, a.DEid, a.CIid, a.Ifecha, 
		   			round(a.Ivalor,2), getdate(), a.Usucodigo, a.Ulocalizacion, 0, null,
                    0.00, coalesce(a.Imonto,0), isnull(a.CFid, isnull(p.CFidconta, p.CFid)), a.Iid, coalesce(a.RHJid, lt.RHJid),
					a.Iusuaprobacion, a.Ifechaaprobacion, a.NAP, a.NRP, a.Inumdocumento, a.CFcuenta
					,#rsActual.CPmes#,#rsActual.CPperiodo#, a.Ifechacontrol
		   from #EmpleadosNomina# b, Incidencias a, CIncidentes c, LineaTiempo lt, RHPlazas p

		   where a.DEid = b.DEid
			 and a.Ifecha  < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Dateadd('d',1,RCalculoNomina.RChasta)#">
			 and a.Iespecial = 0
			 and a.Icpespecial = 1
			 and c.CIid = a.CIid
			 and c.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			 
			 and c.CItipo > 1
			 and lt.DEid = a.DEid
			 and a.Ifecha between lt.LTdesde and lt.LThasta
			 and lt.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			 			 
			 and p.RHPid = lt.RHPid
			 and not exists(select 1 from IncidenciasCalculo ic where ic.DEid = a.DEid and ic.CIid = a.CIid and ic.ICfecha = a.Ifecha)
			<cfif apruebaIncidencias >
				and a.Iestado = 1
				and a.NAP is not null
			</cfif>
			 
       </cfquery>
    </cfif>
    
	<cf_dbfunction name="to_date" args="'#LSDateFormat(RCalculoNomina.RChasta,"dd-mm-yyyy")#'" returnvariable="vRChasta">

	
	<cfquery datasource="#Arguments.datasource#">
		update #IncidenciasReb#
		set dias = (select coalesce(<cf_dbfunction name="datediff" args="pe.RHSPEfdesdesig|#PreserveSingleQuotes(vRChasta)#" delimiters="|">,0) + 1   
					from RHSaldoPagosExceso pe
					 where pe.RHSPEid = #IncidenciasReb#.RHSPEid
						and pe.RHSPEfdesdesig between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#"> 
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> 
						and pe.RHSPEfdesdesig > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
						and pe.RHSPEfhasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
						and pe.RHSPEfdesde = pe.RHSPEfdesdesig)
		where exists(select 1  from RHSaldoPagosExceso pe
					 where pe.RHSPEid = #IncidenciasReb#.RHSPEid
						and pe.RHSPEfdesdesig between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
						and pe.RHSPEfdesdesig > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
						and pe.RHSPEfhasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
						and pe.RHSPEfdesde = pe.RHSPEfdesdesig
					)
	</cfquery> 
	
	
	<cfquery datasource="#Arguments.datasource#">
		update #IncidenciasReb#
		set diasacum = dias + isnull((select sum(dias) from #IncidenciasReb# b where b.DEid = #IncidenciasReb#.DEid and b.RHSPEid < #IncidenciasReb#.RHSPEid), 0)
    </cfquery>
	<cfquery datasource="#Arguments.datasource#">
		update #IncidenciasReb#
		set diasant = diasacum - dias
    </cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		delete from #IncidenciasReb#
		where exists(
			select 1 from #EmpleadosNomina# e
			where #IncidenciasReb#.DEid = e.DEid
		    and #IncidenciasReb#.diasant > e.dias
		)
    </cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		update #IncidenciasReb#
		set diassalario = (select case when #IncidenciasReb#.diasacum >= b.dias then b.dias - #IncidenciasReb#.diasant else #IncidenciasReb#.diasacum - #IncidenciasReb#.diasant end
						   from #EmpleadosNomina# b
						   where b.DEid = #IncidenciasReb#.DEid)
		where exists(
			select 1 from #EmpleadosNomina# b
			where b.DEid = #IncidenciasReb#.DEid
			)	
    </cfquery>
	
	
	
	<!--- 1. Monto a Rebajar de la tabla de RHSaldoPagosExceso --->
	<cfquery datasource="#Arguments.datasource#">
		insert into IncidenciasCalculo (
			RCNid, DEid, CIid, ICfecha, 
			ICvalor, 
			ICfechasis, Usucodigo, Ulocalizacion, 
			ICcalculo, ICbatch, ICmontoant, ICmontores, 
			CFid, RHSPEid,CPmes,CPperiodo)
		select 
			a.RCNid, a.DEid, ta.CIncidente1, <cf_dbfunction name="dateadd" args="a.diasant, a.ICfecha">,
			case when abs(round(pe.RHSPEsaldiario * a.diassalario, 2)) <= abs(a.saldoreb) then round(pe.RHSPEsaldiario * a.diassalario, 2) else a.saldoreb end,
			a.ICfechasis, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 
			0, null, 0.00, 0.00, 
			a.CFid, a.RHSPEid,#rsActual.CPmes#,#rsActual.CPperiodo#
		from #IncidenciasReb# a, RHSaldoPagosExceso pe, RHTipoAccion ta
		where a.diassalario != 0
		  and pe.RHSPEid = a.RHSPEid
		  and pe.RHSPEsaldiario > 0.01
		  and ta.RHTid = pe.RHTid
	 </cfquery>
    <!--- 2.Monto a Subsidiar de la tabla RHSaldoPagosExceso --->
    <cfquery datasource="#Arguments.datasource#">
		insert into IncidenciasCalculo (
			RCNid, DEid, CIid, ICfecha, 
			ICvalor, 
			ICfechasis, Usucodigo, Ulocalizacion, 
			ICcalculo, ICbatch, ICmontoant, ICmontores, 
			CFid, RHSPEid,CPmes,CPperiodo)
		select 
			a.RCNid, a.DEid, ta.CIncidente2, <cf_dbfunction name="dateadd" args="a.diasant, a.ICfecha">, 
			case when abs(round(pe.RHSPEsubdiario * a.diassalario, 2)) <= abs(a.saldosub) then round(pe.RHSPEsubdiario * a.diassalario, 2) else a.saldosub end,  
			a.ICfechasis, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 
			0, null, 0.00, 0.00, 
			a.CFid, a.RHSPEid,#rsActual.CPmes#,#rsActual.CPperiodo#
		from #IncidenciasReb# a, RHSaldoPagosExceso pe, RHTipoAccion ta
		where a.diassalario != 0
		  and abs(a.saldosub) > 0.01
		  and pe.RHSPEid = a.RHSPEid
		  and pe.RHSPEsubdiario > 0.01
		  and ta.RHTid = pe.RHTid
	</cfquery>   
	
	<!---CarolRS Verifica si debe realizarse la validacion para los centros funcionales inactivos--->
	<cfquery name="rsVerificaCFActivos" datasource="#session.DSN#">
		select Pvalor from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and Pcodigo = 2500
	</cfquery>
	
	<cfif isdefined("rsVerificaCFActivos") and rsVerificaCFActivos.Pvalor EQ 1>	
	
		<!---CarolRS. Antes de la insercion de las incidencias se debe realizar una validacion para identificar que el centro funcional 
		 sea un centro funcional activo, en caso de no estar activo, se hace la insercion con el centro funcional activo activo proximo del empleado en la linea del tiempo.--->
		<!---CarolRS. Validacion de centros funcionales inactivos, Actualizacion de la tabla IncidenciasCalculo en caso de tener centros funcionales inactivos, los actualiza con el proximo centro funcional activo. --->
		<cfquery datasource="#Arguments.datasource#" name="rsTomaNuevoCFid">
			select ic.DEid,ic.CFid,case when cf.CFestado = 0 then <!---inactivo--->
					coalesce(
						(	select distinct c.CFid
							from PagosEmpleado a, RHPlazas b, CFuncional c, DatosEmpleado f 
							Where a.PEtiporeg=0 
							and a.DEid=ic.DEid 
							and b.RHPid=a.RHPid 
							and c.CFid = b.CFid 
							and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							and c.CFestado = 1 
							and a.PEdesde = ( 
										select max(x.PEdesde) 
										from PagosEmpleado x 
										where x.DEid=ic.DEid and 
										x.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
										) )
						,	
						ic.CFid)
					 
				else ic.CFid 
				end CfidAct
		from  IncidenciasCalculo ic
		left outer join CFuncional cf
		on cf.CFid = ic.CFid
		where ic.RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		</cfquery>
		
		<cfloop query="rsTomaNuevoCFid">
			<cfset CFidAct = rsTomaNuevoCFid.CFidAct>
			<cfset DEidAct = rsTomaNuevoCFid.DEid>
			<cfset CFidAnt = rsTomaNuevoCFid.CFid>
			
			<cfif CFidAnt NEQ CFidAct>
				<cfquery datasource="#Arguments.datasource#" name="rsUpdateCFid">
					Update IncidenciasCalculo
					set CFid = #CFidAct#
					where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and DEid = #DEidAct#
					and CFid = #CFidAnt#
				</cfquery>
			</cfif>
		</cfloop>    
	</cfif>

   <!---CarolRS Fin Verifica si debe realizarse la validacion para los centros funcionales inactivos--->

   <!--- Carol RS Insertar como Incidencias los componentes Salariales que se pagan independientes del salario base en forma negativa para contrarestar los montos
	(esto en el caso que el componente tiene el check de Salario Especie activado) --->
	<cfquery datasource="#Arguments.datasource#" name="rsCSNeg">
		insert into IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, 
		Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, RHJid,CPmes,CPperiodo, CSid, ICespecie)
		
		select b.RCNid, b.DEid, b.CIid, b.ICfecha, -1 * b.ICvalor, b.ICfechasis, b.Usucodigo, 
		b.Ulocalizacion, b.ICcalculo, b.ICbatch, -1 * b.ICmontoant, -1 * b.ICmontores, b.CFid, b.RHJid, b.CPmes, b.CPperiodo,a.CSid, 1
		from IncidenciasCalculo b
			inner join ComponentesSalariales a
			on  b.CIid = a.CIid
			and a.CSsalarioEspecie = 1
		where b.RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        <cfif IsDefined('Arguments.pDEid')>	and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"> </cfif>
        
	</cfquery>
	
	
	
     <cfquery datasource="#Arguments.datasource#" name="rsCSNeg">
     delete from IncidenciasCalculo
     where ICid in (
        
     select b.ICid
        from IncidenciasCalculo b
			inner join ComponentesSalariales a
			on  b.CIid = a.CIid
			and a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- Evitar que lleguen Incidencias de una Empresa Diferente --->			
			and a.CSsalarioEspecie = 1
		where b.RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        <cfif IsDefined('Arguments.pDEid')>	and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"> </cfif>
        and DEid in (select DEid from PagosEmpleado
                            group by RCNid ,DEid
                            having sum(PEmontores) =0 ))
	</cfquery>
    
