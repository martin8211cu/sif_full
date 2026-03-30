<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>

<cfinclude template="../sif/cm/admin/defaults.cfm">
<!---Query de Numeros a mostrar     SOLICITUD DE COMPRAS--->
<cfset nummodulo_sc =0>
<cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkload" returnvariable="workload">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
</cfinvoke>
<cfoutput>
	<cfquery name="workload" dbtype="query">
			select * 
			  from workload
			 where 1=1             
				and ( UPPER(workload.ProcessInstanceDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('solicitud de compra')#%">
				   OR UPPER(workload.ActivityDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('solicitud de compra')#%">
					)
	</cfquery>
</cfoutput>
<!--- ver los responsables --->
<cfset soy_responsable = false>
<cfset hay_responsables = false>
<cfoutput>
	<cfif workload.ParticipantUsucodigo is session.Usucodigo>
		<cfset soy_responsable = true>
	</cfif>
	<cfif Len(workload.ParticipantUsucodigo)>
		<cfset hay_responsables = true>
	</cfif>
</cfoutput>
<cfloop query="workload">
	<!--- No muestra los tramites q esten asociados a una SC con un NRP --->
    <cfquery name="rsExisteNRP" datasource="#session.dsn#">
        select count(1) as cantidad from ESolicitudCompraCM where NRP is not null and ProcessInstanceid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#workload.ProcessInstanceId#">
    </cfquery>
    <cfif rsExisteNRP.cantidad eq 0>
	   <cfif workload.ProcessInstanceId NEQ 0>  					
            <cfif soy_responsable or request.lista_actividades_superuser>
                <cfif workload.State EQ "COMPLETED">
                    <cfinvoke component="sif.Componentes.Workflow.Management" 
                              method="getAllowedTransitions" 
                              returnvariable="rsTrans">
                        <cfinvokeargument name="ActivityInstanceId" value="#workload.ActivityInstanceId#">
                    </cfinvoke>
                    <cfloop query="rsTrans">
                        <cfif findNoCase("ACEPTA",name) OR findNoCase("APROB",name) OR findNoCase("APRUEB",name) OR findNoCase("APLICA",name) OR findNoCase("AUTORI",name)
                           OR findNoCase("RATIFIC",name) OR findNoCase("CONCEN",name) OR findNoCase("POSITIV",name) OR findNoCase("CONFIRM",name)
                           OR name EQ "OK" OR findNoCase("ACCEPT",name) OR findNoCase("APPROV",name) OR findNoCase("AGREE",name)  OR findNoCase("PASS",name)>
                             <cfset nummodulo_sc = nummodulo_sc +1>
                        <cfelseif TRIM(Ucase(Name)) eq 'APROBACIONJEFE'>
                            <cfset nummodulo_sc = nummodulo_sc +1>
                        </cfif>	  
                    </cfloop>
                </cfif>
           </cfif>
          </cfif>
   </cfif>
</cfloop>
<cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkloadGestionAutorizaciones" returnvariable="SolicitudCNRP">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
</cfinvoke>
 <cfset nummodulo_sc = nummodulo_sc + SolicitudCNRP.recordcount>
<!---Query de Numeros a mostrar     COTIZACIONES--->
<cfset lvarSolicitante= true>
<cfset lvarFiltroEcodigo = Session.Ecodigo>
<cfset NumeroCT = 0>
<cfquery name="qryLista" datasource="#session.dsn#">
	select Distinct 0 as OPT, a.CMPnumero, a.CMPid, a.CMPdescripcion, a.CMPfechapublica,
		coalesce((select sum(1) 
        			from ECotizacionesCM b 
                  where b.CMPid = a.CMPid 
                    and b.ECestado in (5,10)),0) as ECcount,
		case when (coalesce((select sum(1) 
        						from ECotizacionesCM b 
                              where b.CMPid = a.CMPid 
                                and b.ECestado in (5,10)),0)) = 0 <cfif not lvarSolicitante>or a.CMPestado = 79 or a.CMPestado = 81 or a.CMPestado = 83</cfif> then a.CMPid else 0 end as filasdesactivadas
	from CMProcesoCompra a
    	 left Outer join DCotizacionesCM dc
        	on dc.CMPid = a.CMPid
	where a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
		and a.CMPestado = 79
        and (
        		(select count(1)
                        from CMProcesoCompra pc
                            inner join DCotizacionesCM dc
                                on dc.CMPid = pc.CMPid
                            inner join DSolicitudCompraCM ds
                                on ds.DSlinea = dc.DSlinea
                            inner join ESolicitudCompraCM es
                                on es.ESidsolicitud = ds.ESidsolicitud
                            inner join WfxActivity xa
                                on xa.ProcessInstanceId = es.ProcessInstanceid
                            inner join WfxActivityParticipant xap
                                on xap.ActivityInstanceId = xa.ActivityInstanceId
                        where xap.Usucodigo = #session.Usucodigo#
                          and xap.HasTransition = 1
                          and pc.CMPestado = 79
                          and xa.FinishTime = (select max(sxa.FinishTime)
                                                from WfxActivity sxa
                                                    inner join WfxActivityParticipant sxap
                                                        on sxap.ActivityInstanceId = sxa.ActivityInstanceId
                                                where sxa.ProcessInstanceId = es.ProcessInstanceid)
                         and pc.CMPid = a.CMPid
                ) > 0
   			or (select count(1)
            	  from CMProcesoCompra pc
                  	inner join DCotizacionesCM dc
                    	on dc.CMPid = pc.CMPid
                    inner join DSolicitudCompraCM ds
                        on ds.DSlinea = dc.DSlinea
                    inner join ESolicitudCompraCM es
                        on es.ESidsolicitud = ds.ESidsolicitud
                  where dc.CMPid = a.CMPid
                    and dc.Ecodigo = a.Ecodigo
                    and es.Usucodigo = #session.Usucodigo#
                    and es.ProcessInstanceid is null
                    and pc.CMPid = a.CMPid
                 ) > 0
            )
</cfquery>
<cfif qryLista.Recordcount>
	<cfset NumeroCT = qryLista.Recordcount>
</cfif>
<!---Query de Numeros a mostrar     Orden de compras--->
<cfif session.compras.comprador NEQ "">
<cfset NumeroOC =0>
<cfquery name="rsLista" datasource="#session.DSN#">
	select a.CMAid, a.Nivel, b.EOidorden, a.CMAestado
	from CMAutorizaOrdenes a
	inner join EOrdenCM b
		on a.EOidorden=b.EOidorden
	 	and b.EOestado in (-7,-8,-9)
	inner join CMCompradores d
	on b.CMCid = d.CMCid
	inner join CMTipoOrden c
	on b.CMTOcodigo=c.CMTOcodigo
	and b.Ecodigo=c.Ecodigo
	inner join Monedas e
	on b.Mcodigo=e.Mcodigo
	and b.Ecodigo=e.Ecodigo
	where a.Ecodigo = #Session.Ecodigo#
	  and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.compras.comprador#">
	  and a.CMAestadoproceso not in (10,15)			
</cfquery>
<cfloop query="rsLista">
<!---Validar que existen casos para mostrar los campos aprobar rechazar o reiniciar--->
	<cfif rsLista.nivel gt 0 >
        <cfquery name="rsValida" datasource="#session.DSN#">
            select CMAestado
            from CMAutorizaOrdenes
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
              and CMAestado = 2
              and Nivel = #rsLista.Nivel#-1
        </cfquery>
    </cfif>
	<cfif ( rsLista.nivel eq 0 ) or (isdefined("rsValida") and rsValida.recordCount gt 0 and rsLista.CMAestado eq 0 ) >
		 <cfif not  rsLista.Nivel gt 0 >
            <cfquery name="rsReiniciar" datasource="#session.DSN#">
                select 1 
                from CMAutorizaOrdenes 
                where Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and EOidorden =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
                and CMAestadoproceso not in (10,15) and Nivel > 0 and CMAestado=1
            </cfquery>
            <cfif rsReiniciar.recordCount gte 1 >
               <cfset NumeroOC = NumeroOC + 1 >   
            </cfif>
        <cfelse>
			<cfset NumeroOC = NumeroOC + 1 >            
        </cfif>
     </cfif>
</cfloop>
</cfif>
<!---Query de Numeros a mostrar     Gasto Empleados--->
<cfquery datasource="#session.dsn#" name="listaGatosEmpl" maxrows="300">
<cfset LvarCortes = "">
select 		distinct
			tp.CCHTid as idTransaccion,
			tp.CCHTrelacionada
	from  CCHTransaccionesProceso tp
		inner join GEanticipo ga
			on tp.CCHTrelacionada= ga.GEAid
	where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and tp.CCHTtipo='ANTICIPO'
	and tp.CCHTrelacionada is not null
    <!---Muestra solo los CF donde soy aprobador--->
    and ga.CFid in (select  CFid
                        from TESusuarioSP tu 
                        where tu.Usucodigo = #session.Usucodigo#
                        and tu.TESUSPaprobador = 1 
                        and Ecodigo =  #session.Ecodigo#
                    )
	and ga.GEAestado in(1)

union all
	
	select distinct
			tp.CCHTid as IdTransaccion,
			tp.CCHTrelacionada
			
	from  CCHTransaccionesProceso tp
		inner join GEliquidacion gl
			on tp.CCHTrelacionada= gl.GELid
		left join GEcomision gc
			on gc.GECid = gl.GECid
		left join CCHica ch on ch.CCHid = gl.CCHid
	where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and tp.CCHTtipo='GASTO'
	and tp.CCHTrelacionada is not null
    <!---Muestra solo los CF donde soy aprobador--->
    and gl.CFid in (select  CFid
                    from TESusuarioSP tu 
                    where tu.Usucodigo = #session.Usucodigo#
                    and tu.TESUSPaprobador = 1 
                    and Ecodigo =  #session.Ecodigo# 
                )
	and gl.GELestado in(1)

union all
	select 	distinct
			ga.GECid as idTransaccion,
			tp.CCHTrelacionada
			
	from  CCHTransaccionesProceso tp
		inner join GEcomision ga
			on tp.CCHTrelacionada= ga.GECid
	where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and tp.CCHTtipo='COMISION'
	and tp.CCHTrelacionada is not null
    <!---Muestra solo los CF donde soy aprobador--->
    and ga.CFid in (select  CFid
                    from TESusuarioSP tu 
                    where tu.Usucodigo = #session.Usucodigo#
                    and tu.TESUSPaprobador = 1 
                    and Ecodigo =  #session.Ecodigo# 
                )
	and ga.GECestado in (1,2)	<!--- En Proceso o Activa --->
	and (
		select count(1)
		  from GEanticipo a
		 where GECid=ga.GECid
		   and GEAestado = 1
		) > 0
</cfquery>
<cfif listaGatosEmpl.recordcount gt 0>
	<cfset NumeroGE = listaGatosEmpl.recordcount>
<cfelse>
	<cfset NumeroGE = 0>
</cfif>
<!---Query de Numeros a mostrar     TESORERIA--->
<cfparam name="Attributes.AprobacionSP"	default="yes" type="boolean">
<!--- SP_lista trabaja a nivel empresarial, excepto cuando es RechazoSP que es a nivel de Tesorería --->
<cfparam name="Attributes.RechazoSP"	default="no" type="boolean">
<cfparam name="Attributes.PasarSP"		default="no" type="boolean">
<cfparam name="Attributes.FiltarxUsuario"default="no" type="boolean">
<cfparam name="Attributes.Tipo"				default="">
<cfparam name="Attributes.Estado"			default="0">
<cfparam name="Attributes.ListarCancelados" default="yes" type="boolean">
<cfparam name="Attributes.Botones" 			default=""    type="string">
<cfparam name="Attributes.PorEmpleado" 		default="no"  type="boolean">
<cfparam name="Attributes.PorSolicitante"	default="no"  type="boolean">

<cfset LvarSAporComision = isdefined('caller.LvarSAporComision') and caller.LvarSAporComision>
	
<cfset LvarPrimera = false>
<cfset LvarHoy = createODBCdate(now())>
<cfset LvarHaceUnMes = dateadd("d",-7, LvarHoy)>
							
<cf_navegacion name="CFid_F" 				session value="">
<cf_navegacion name="UsucodigoSP_F"			session value="">
<cf_navegacion name="Usucodigo2_F"			session value="">
<cf_navegacion name="DEid_F" 				session value="" >
<cf_navegacion name="TESSPfechaPago_I" 		session value="">
<cf_navegacion name="TESSPfechaPago_F" 		session value="">
<cf_navegacion name="McodigoOri_F" 			session value="">
<cf_navegacion name="TipoTransaccion" 		session value="">
	<cfif isdefined("form.cboCFid")>
		<cfset CFid_F = form.cboCFid>
	</cfif>
	<cfset cboCFid = CFid_F>
	
	<!--- Por Empleado solo puede ver sus Liquidaciones --->
	<cfif Attributes.PorEmpleado>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select llave as DEid
			  from UsuarioReferencia
			 where Usucodigo= #session.Usucodigo#
			   and Ecodigo	= #session.EcodigoSDC#
			   and STabla	= 'DatosEmpleado'
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cf_errorCode	code = "50737"
							msg  = "El usuario '@errorDat_1@' no ha sido registrado como Empleado de la Empresa"
							errorDat_1="#session.Usulogin#"
			>
		</cfif>
		<cfset form.DEid = rsSQL.DEid>
	</cfif>

	<cfif Attributes.PorEmpleado AND NOT LvarSAporComision>
		<cfset UsucodigoSP_F = session.usucodigo>
	</cfif>
	<cfset Usucodigo = UsucodigoSP_F>
               

<cfset LvarPrimera = false>
<cfset LvarHoy = createODBCdate(now())>
<cfset LvarHaceUnMes = dateadd("d",-7, LvarHoy)>

<cfparam name="session.SP_TipoAnterior" default="*">
<cfset LvarDesdeTesoreria = Attributes.RechazoSP OR Attributes.PasarSP>
<cfif session.SP_TipoAnterior NEQ Attributes.Tipo or isdefined("url._")>
	<cfset session.SP_TipoAnterior = Attributes.Tipo>

	<cfset session.Tesoreria.CFid = "-1">
	<cf_navegacion name="CFid_F"				value="" session>
	<cf_navegacion name="UsucodigoSP_F"			value="" session>

	<cf_navegacion name="TESSPestado_F"			value="" session>
	<cf_navegacion name="TESSPtipoDocumento_F"	value="" session>
	<cf_navegacion name="SNcodigo_F" 			value="" session>
	<cf_navegacion name="TESBid_F" 				value="" session>
	<cf_navegacion name="CDCcodigo_F" 			value="" session>

	<cf_navegacion name="TESBeneficiario_F" 	value="" session>
	<cf_navegacion name="TESSPfechaPago_I" 		session default="#LSDateFormat(LvarHaceUnMes,'dd/mm/yyyy')#">
	<cf_navegacion name="TESSPfechaPago_F" 		session value="">
	<cf_navegacion name="EcodigoOri_F"			value="" session>
	
	<cfset LvarPrimera = true>
</cfif>

<cfif Attributes.Tipo EQ "">					<!--- TODOS --->
	<cfif not Attributes.AprobacionSP AND not LvarDesdeTesoreria>
		<cf_navegacion name="TESSPestado_F"		session default="0">
	<cfelse>
		<cf_navegacion name="TESSPestado_F"		default="0">
	</cfif>
	<cf_navegacion name="TESSPtipoDocumento_F"	session default="">
	<cf_navegacion name="SNcodigo_F" 			session default="">
	<cf_navegacion name="TESBid_F" 				session default="">
	<cf_navegacion name="CDCcodigo_F" 			session default="">
<cfelseif Find(Attributes.Tipo,"0,5") GT 0>		<!--- MANUAL --->
	<cf_navegacion name="TESSPtipoDocumento_F"	value="#Attributes.Tipo#">
	<cf_navegacion name="TESSPestado_F"			value="0">

	<cf_navegacion name="TESBid_F" 				session default="">
	<cf_navegacion name="SNcodigo_F" 			session default="">
	<cf_navegacion name="CDCcodigo_F" 			value="">
<cfelseif Attributes.Tipo EQ 4>					<!--- POS --->
	<cf_navegacion name="TESSPtipoDocumento_F"	value="#Attributes.Tipo#">
	<cf_navegacion name="TESSPestado_F"			value="0">

	<cf_navegacion name="CDCcodigo_F" 			session default="">
	<cf_navegacion name="SNcodigo_F" 			value="">
	<cf_navegacion name="TESBid_F" 				value="">
<cfelse>										<!--- CxP, Anti.CxP, Anti.CxC --->
	<cf_navegacion name="TESSPtipoDocumento_F"	value="#Attributes.Tipo#">
	<cf_navegacion name="TESSPestado_F"			value="0">

	<cf_navegacion name="SNcodigo_F" 			session default="">
	<cf_navegacion name="TESBid_F" 				value="">
	<cf_navegacion name="CDCcodigo_F" 			value="">
</cfif>

<cf_navegacion name="CFid_F" 				session default="">
<cf_navegacion name="UsucodigoSP_F"			session default="">
<cf_navegacion name="TESBeneficiario_F" 	session default="">
<cf_navegacion name="TESSPfechaPago_I" 		session default="#LSDateFormat(LvarHaceUnMes,'dd/mm/yyyy')#">
<cf_navegacion name="TESSPfechaPago_F" 		session default="">
<cf_navegacion name="EcodigoOri_F"			session default="">

<cfif len(trim(form.SNcodigo_F))>
	<cf_navegacion name="TESBid_F" 			session	value="">
	<cf_navegacion name="CDCcodigo_F" 		session	value="">
<cfelseif len(trim(form.TESBid_F))>
	<cf_navegacion name="CDCcodigo_F" 		session	value="">
</cfif>
<cfset session.Tesoreria.CFid = -1>        

<cfquery datasource="#session.dsn#" name="listaTesoreria" maxrows="300">
        Select
        	 sp.TESSPmsgRechazo
            , sp.TESSPfechaPagar
            , u.Usulogin
        from TESsolicitudPago sp
            inner join Empresas e
               on e.Ecodigo=sp.EcodigoOri

            inner join Monedas m
               on m.Ecodigo=sp.EcodigoOri
              and m.Mcodigo=sp.McodigoOri
        
            inner join Usuario u
                on u.Usucodigo=sp.UsucodigoSolicitud
        
            inner join DatosPersonales dp
                on dp.datos_personales=u.datos_personales

            left outer join TESordenPago op
                on op.TESOPid = sp.TESOPid

    <cfif LvarDesdeTesoreria>
        <!--- RechazoSP:  es a nivel de Tesoreria (opcion en Ordenes de Pago) --->
        where sp.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
    <cfelse>
        where sp.EcodigoOri= #session.Ecodigo# 
        <cfif Attributes.Tipo NEQ "">
            <cfif session.Tesoreria.CFid LT 0>
                <!--- Todos los Centros Funcionales, todos los CFs del aprobador y sin CF --->
                and (	sp.CFid is NULL
                     OR 
                        (
                            select count(1) from TESusuarioSP tu
                             where tu.Usucodigo = #session.Usucodigo#
                               and tu.CFid		= sp.CFid
                               and tu.TESUSPsolicitante = 1
                        ) > 0
                )
            <cfelseif session.Tesoreria.CFid EQ 0>
                <!--- Sin Centro Funcional, sin CF (TEMPORAL PARA LOS VIEJOS) --->
                and sp.CFid is NULL
            <cfelse>
                <!--- Un Centro Funcional --->
                and sp.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">
            </cfif>				
            <cfset form.CFid_F = "">
        <cfelseif Attributes.AprobacionSP>
            <cfif session.Tesoreria.CFid LT 0>
                <!--- Todos los Centros Funcionales, todos los CFs del aprobador y sin CF --->
                and (	sp.CFid is NULL
                     OR 
                        (
                            select count(1) from TESusuarioSP tu
                             where tu.Usucodigo = #session.Usucodigo#
                               and tu.CFid		= sp.CFid
                               and tu.TESUSPaprobador = 1
                        ) > 0
                    )
            <cfelseif session.Tesoreria.CFid EQ 0>
                <!--- Sin Centro Funcional, sin CF (TEMPORAL PARA LOS VIEJOS) --->
                and sp.CFid is NULL
            <cfelseif session.Tesoreria.CFid_subordinados EQ 0>
                <!--- No subordinados, los del CF --->
                and sp.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">
            <cfelse>
                <!--- Subordinados, todos los de los CFs subordinados --->
                and 
                    (
                        select count(1) from CFuncional CFsub
                         where CFsub.Ecodigo	= sp.EcodigoOri
                           and CFsub.CFid		= sp.CFid
                           and CFsub.CFpath 	like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(session.Tesoreria.CFid_subPath) & "%"#">
                    ) > 0
            </cfif>				
            <cfset form.CFid_F = "">
        </cfif>
    </cfif>
        <cfif Attributes.AprobacionSP>
        and sp.TESSPestado = 1
        and NOT exists
            (
                select 1 
                    from TESTramiteSolPago 
                    where CFid = sp.CFid
            )
        <cfelseif LvarDesdeTesoreria>
                and TESSPestado in (2,10)
	
    	</cfif>

            <cfif LvarDesdeTesoreria>
                <cfset LvarCortes = "Edescripcion">
                order by sp.EcodigoOri, sp.TESSPnumero
            <cfelse>
                <cfset LvarCortes = "">
                order by sp.TESSPnumero
            </cfif>
</cfquery>
<cfif listaTesoreria.recordcount gt 0>
	<cfset NumeroTE = listaTesoreria.recordcount>
<cfelse>
	<cfset NumeroTE = 0>
</cfif>
<!---Query de Numeros a mostrar     RECURSOS HUMANOS--->
<cfset NumeroRH =0>
<cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkload" returnvariable="workload">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
</cfinvoke>
<cfoutput>
	<cfquery name="workload" dbtype="query">
			select * 
			  from workload
			 where 1=1                         
				and ( UPPER(workload.ProcessDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('recursos humanos')#%">
				   OR UPPER(workload.Edescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('recursos humanos')#%"> OR
                   UPPER(workload.ProcessDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('RH')#%">
				   OR UPPER(workload.Edescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('RH')#%">
					)
	</cfquery>
</cfoutput>
<!--- ver los responsables --->
<cfset soy_responsable = false>
<cfset hay_responsables = false>
<cfoutput>
	<cfif workload.ParticipantUsucodigo is session.Usucodigo>
		<cfset soy_responsable = true>
	</cfif>
	<cfif Len(workload.ParticipantUsucodigo)>
		<cfset hay_responsables = true>
	</cfif>
</cfoutput>
<cfloop query="workload">
	<!--- No muestra los tramites q esten asociados a una SC con un NRP --->
    <cfquery name="rsExisteNRP" datasource="#session.dsn#">
        select count(1) as cantidad from ESolicitudCompraCM where NRP is not null and ProcessInstanceid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#workload.ProcessInstanceId#">
    </cfquery>
    <cfif rsExisteNRP.cantidad eq 0>
		<cfif soy_responsable or request.lista_actividades_superuser>
            <cfif workload.State EQ "COMPLETED">
                <cfinvoke component="sif.Componentes.Workflow.Management" 
                          method="getAllowedTransitions" 
                          returnvariable="rsTrans">
                    <cfinvokeargument name="ActivityInstanceId" value="#workload.ActivityInstanceId#">
                </cfinvoke>
                <cfloop query="rsTrans">
                    <cfif findNoCase("ACEPTA",name) OR findNoCase("APROB",name) OR findNoCase("APRUEB",name) OR findNoCase("APLICA",name) OR findNoCase("AUTORI",name)
                       OR findNoCase("RATIFIC",name) OR findNoCase("CONCEN",name) OR findNoCase("POSITIV",name) OR findNoCase("CONFIRM",name)
                       OR name EQ "OK" OR findNoCase("ACCEPT",name) OR findNoCase("APPROV",name) OR findNoCase("AGREE",name)  OR findNoCase("PASS",name)>
                         <cfset NumeroRH = NumeroRH +1>
                    <cfelseif TRIM(Ucase(Name)) eq 'APROBACIONJEFE'>
                        <cfset NumeroRH = NumeroRH +1>
                    </cfif>	  
                </cfloop>
            </cfif>
       </cfif>
	</cfif>
</cfloop>

<cf_templateheader title="Gestion de Autorizaciones" bloquear="true">

  	<div id="circle-menu">
    	<div  class="titulo">Gestion de Autorizaciones</div>
        <cfset num =1>
		<div id="circle-menu-interno1">
		   <cfif nummodulo_sc EQ 0>
               <div class="modulo-scdiv"><a class="modulo-sc" href="/cfmx/proyecto7/solicitudCompras.cfm" style="position: relative;"></a></div>
               <script type="text/javascript">
                    $(document).ready(function() {  
                           $(".modulo-scdiv").fadeIn(5000);
                    });  
                </script>
           <cfelse>
                <div class="NumeroSC"><cfoutput>#nummodulo_sc#</cfoutput> </div>
                <div class="modulo-scdiv2"><a class="modulo-sc2" href="/cfmx/proyecto7/solicitudCompras.cfm" style="position: relative;"></a></div>
                <script type="text/javascript">
                    $(document).ready(function() {  
                           $(".modulo-scdiv2").fadeIn(5000);
                    });  
                </script>
            </cfif>    
                
            <cfif NumeroCT EQ 0>
                <div class="modulo-ctdiv"><a class="modulo-ct" href="/cfmx/proyecto7/cotizaciones.cfm" style="position: relative;"></a></div>
                <script type="text/javascript">
                    $(document).ready(function() {  
                           $(".modulo-ctdiv").fadeIn(5000);
                    });  
                </script>
            <cfelse>
                <div class="NumeroCT"><cfoutput>#NumeroCT#</cfoutput> </div>
                <div class="modulo-ctdiv2"><a class="modulo-ct2" href="/cfmx/proyecto7/cotizaciones.cfm" style="position: relative;"></a></div>
                <script type="text/javascript">
                    $(document).ready(function() {  
                           $(".modulo-ctdiv2").fadeIn(5000);
                    });  
                </script>
            </cfif>
            
           <cfif NumeroGE EQ 0>
                <div class="modulo-gediv"><a class="modulo-ge" href="/cfmx/proyecto7/gastosEmpleados.cfm" style="position: relative;"></a></div>
                <script type="text/javascript">
                    $(document).ready(function() {  
                           $(".modulo-gediv").fadeIn(5000);
                    });  
                </script>
            <cfelse>
                <div class="NumeroGE"><cfoutput>#NumeroGE#</cfoutput> </div>
                <div class="modulo-gediv2"><a class="modulo-ge2" href="/cfmx/proyecto7/gastosEmpleados.cfm" style="position: relative;"></a></div>
                <script type="text/javascript">
                    $(document).ready(function() {  
                           $(".modulo-gediv2").fadeIn(5000);
                    });  
                </script>
            </cfif>
        </div>
        <div id="circle-menu-interno2" > 
        <cfif session.compras.comprador NEQ "">  
			<cfif NumeroOC EQ 0>
                <div class="modulo-ocdiv"><a class="modulo-oc" href="/cfmx/proyecto7/ordenCompras.cfm" style="position: relative;"></a></div>
                <script type="text/javascript">
                    $(document).ready(function() {  
                           $(".modulo-ocdiv").fadeIn(5000);
                    });  
                </script>
            <cfelse>
                <div class="NumeroOC"><cfoutput>#NumeroOC#</cfoutput> </div>
                <div class="modulo-ocdiv2"><a class="modulo-oc2" href="/cfmx/proyecto7/ordenCompras.cfm" style="position: relative;"></a></div>
                <script type="text/javascript">
                    $(document).ready(function() {  
                           $(".modulo-ocdiv2").fadeIn(5000);
                    });  
                </script>
            </cfif>
        </cfif>
        
        <cfif NumeroTE EQ 0>
            <div class="modulo-tediv"><a class="modulo-te" href="/cfmx/proyecto7/tesoreria.cfm" style="position: relative;"></a></div>
             <script type="text/javascript">
				$(document).ready(function() {  
					   $(".modulo-tediv").fadeIn(5000);
				});  
			</script>
        <cfelse>
        	<div class="NumeroTE"><cfoutput>#NumeroTE#</cfoutput> </div>
            <div class="modulo-tediv2"><a class="modulo-te2" href="/cfmx/proyecto7/tesoreria.cfm" style="position: relative;"></a></div>
            <script type="text/javascript">
				$(document).ready(function() {  
					   $(".modulo-tediv2").fadeIn(5000);
				});  
			</script>
        </cfif>    
                 
        <cfif NumeroRH EQ 0>
            <div class="modulo-rhdiv"><a class="modulo-rh" href="/cfmx/proyecto7/recursosHumanos.cfm" style="position: relative;"></a></div>
                        <script type="text/javascript">
				$(document).ready(function() {  
					   $(".modulo-rhdiv").fadeIn(5000);
				});  
			</script>
        <cfelse>
        	<div class="NumeroRH"><cfoutput>#NumeroRH#</cfoutput> </div>
            <div class="modulo-rhdiv2"><a class="modulo-rh2" href="/cfmx/proyecto7/recursosHumanos.cfm" style="position: relative;"></a></div>
            <script type="text/javascript">
				$(document).ready(function() {  
					   $(".modulo-rhdiv2").fadeIn(5000);
				});  
			</script>
        </cfif>  
        </div>
	</div>
<cf_templatefooter>
