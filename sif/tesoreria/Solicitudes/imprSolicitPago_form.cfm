<cf_dbfunction name="op_concat" returnvariable="_CAT">

<cfinvoke key="LB_SolManual" default="SOLICITUD DE PAGO MANUAL"	returnvariable="LB_SolManual"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolManualxCF" default="SOLICITUD DE PAGO MANUAL POR CENTRO FUNCIONAL"	returnvariable="LB_SolManualxCF"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolPagoDctosManual" default="SOLICITUD DE PAGO DE DOCUMENTOS DE CxP"	returnvariable="LB_SolPagoDctosManual"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolAnticiposCxP" default="SOLICITUD DE PAGO DE ANTICIPOS DE CxP"	returnvariable="LB_SolAnticiposCxP"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolDevAntCxC" default="SOLICITUD DE DEVOLUCIÓN DE ANTICIPOS DE CxC"	returnvariable="LB_SolDevAntCxC"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolDevAntPos" default="SOLICITUD DE DEVOLUCIÓN DE ANTICIPOS DE POS"	returnvariable="LB_SolDevAntPos"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolPagoAntEmpleados" default="SOLICITUD DE PAGO DE ANTICIPOS A EMPLEADOS"	returnvariable="LB_SolPagoAntEmpleados"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolPagoLiqGE" default="SOLICITUD DE PAGO DE LIQUIDACION A GASTOS EMPLEADOS"	returnvariable="LB_SolPagoLiqGE"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolPagoFondosCCH" default="SOLICITUD DE PAGO PARA FONDOS DE CAJA CHICA"	returnvariable="LB_SolPagoFondosCCH"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolPagoReintegroCCH" default="SOLICITUD DE PAGO PARA REINTEGRO DE CAJA CHICA"	returnvariable="LB_SolPagoReintegroCCH"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolTransCtasBanc" default="SOLICITUD DE TRANSFERENCIAS ENTRE CUENTAS BANCARIAS"	returnvariable="LB_SolTransCtasBanc"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolPagoInterfaz" default="SOLICITUD DE PAGO POR INTERFAZ"	returnvariable="LB_SolPagoInterfaz"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 
<cfinvoke key="LB_SolPago" default="SOLICITUD DE PAGO"	returnvariable="LB_SolPago"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/> 

<cfinvoke key="LB_PorMulta" default="POR MULTA"	returnvariable="LB_PorMulta"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_PorCesion" default="POR CESION"	returnvariable="LB_PorCesion"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_PorEmbargo" default="POR EMBARGO"	returnvariable="LB_PorEmbargo"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>

<cfinvoke key="LB_Preparacion" default="En Preparación"	returnvariable="LB_Preparacion"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_ProcesoAprob" default="En Proceso de Aprobación"	returnvariable="LB_ProcesoAprob"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_SolAprobada" default="Solicitud Aprobada"	returnvariable="LB_SolAprobada"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_SolRechazada" default="Solicitud Rechazada"	returnvariable="LB_SolRechazada"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_SolRechazadaXTes" default="Solicitud Rechazada en Tesorería"	returnvariable="LB_SolRechazadaXTes"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_SolAprobEInclOP" default="Solicitud Aprobada e Incluida en Preparación de OP"	returnvariable="LB_SolAprobEInclOP"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_EnProceso" default="en Proceso"	returnvariable="LB_EnProceso"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_SolAprobInclAprob" default="Solicitud Aprobada e Incluida en Proceso de Aprobación de OP"	returnvariable="LB_SolAprobInclAprob"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_RechazadaOP" default="Solicitud Rechazada en OP"	returnvariable="LB_RechazadaOP"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_SolAproInclEmisionOP" default="Solicitud Aprobada e Incluida en Proceso de Emisión de OP"	returnvariable="LB_SolAproInclEmisionOP"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_SolOpSinAplicar" default="Solicitud en OP. Sin Aplicar"	returnvariable="LB_SolOpSinAplicar"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_SolPagOP" default="Solicitud Pagada en OP"	returnvariable="LB_SolPagOP"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_SolAnuOP" default="Solicitud Anulada en OP"	returnvariable="LB_SolAnuOP"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_AprobConCesiones" default="Aprobada con Cesiones"	returnvariable="LB_AprobConCesiones"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_ApliSinOP" default="Aplicada sin Orden Pago"	returnvariable="LB_ApliSinOP"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_EstadoDesc" default="Estado Desconocido"	returnvariable="LB_EstadoDesc"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>

<cfinvoke key="LB_MotRechazo" default="MOTIVO RECHAZO"	returnvariable="LB_MotRechazo"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="LB_MotAnulacion" default="MOTIVO ANULACION"	returnvariable="LB_MotAnulacion"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>

<cfinvoke key="MSG_NoEncotroSP" default="No se encontró la solicitud de pago seleccionada, favor inténtelo de nuevo"	returnvariable="MSG_NoEncotroSP"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>
<cfinvoke key="MSG_SPSeleccionada" default="La solicitud de pago seleccionada está vacía, favor inténtelo de nuevo"	returnvariable="MSG_SPSeleccionada"	method="Translate" component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>

<cfif isDefined("Url.TESSPid") and not isDefined("form.TESSPid")>
  <cfset form.TESSPid = Url.TESSPid>
</cfif>
<cfif isDefined("Url.imprime") and not isDefined("form.imprime")>
  <cfset form.imprime = Url.imprime>
</cfif>
 <cfset Rubro =''>
 <cfset Subrubro=''>
 <cfset LvarRenglon =0>
 
<cfif isdefined('form.TESSPid') and form.TESSPid NEQ ''>
<STYLE>
	H6.SaltoDePagina
	{
		PAGE-BREAK-AFTER: always
	}
</STYLE>
	<style type="text/css">
	@media print {
		.noprint 
		{
			display: none;
		}
		.Corte_Pagina_imp
		{
			PAGE-BREAK-AFTER: always
		}
	}
	@media screen {
		.Corte_Pagina
		{
			border:dotted 1px #FF0000;
			margin-top:20px;
			margin-bottom:20px;
		}
	}
	.style1 {
		font-size: 18px;
		font-weight: bold;
		font-family: Arial, Helvetica, sans-serif;
	}
	.style4 {font-size: 13px}
	.style7 {font-size: 10px; font-weight: bold; }
	.style8 {
		font-family: "Courier New", Courier, mono;
		font-size: 8px;
	}
	</style>

	<!--- Plan de Compras --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 2300
	</cfquery>
	<cfset LvarPlanComprasActivo = (rsSQL.Pvalor EQ '1')>
	
	<cfquery datasource="#session.dsn#" name="rsSPsRelacionadas">
		select TESSPid, TESSPnumero, TESSPestado, TESSPidCPC
		  from TESsolicitudPago sp
		 where sp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and sp.TESSPid	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">	
	</cfquery>
	<cfif rsSPsRelacionadas.TESSPestado EQ '202'>
		<!--- Aprobada con Cesiones Generadas: obtiene todas las SPs generadas hijas --->
		<cfquery datasource="#session.dsn#" name="rsSPsRelacionadas">
			select TESSPid, TESSPnumero, TESSPestado, TESSPidCPC
			  from TESsolicitudPago sp
			 where sp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and coalesce(sp.TESSPidCPC, sp.TESSPid)=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			order by TESSPid
		</cfquery>
	<cfelseif rsSPsRelacionadas.TESSPidCPC NEQ ''>
		<!--- SP generada por Cesiones: obtiene todas las SPs generadas del padre --->
		<cfquery datasource="#session.dsn#" name="rsSPsRelacionadas">
			select TESSPid, TESSPnumero, TESSPidCPC
			  from TESsolicitudPago sp
			 where sp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and coalesce(sp.TESSPidCPC, sp.TESSPid)=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSPsRelacionadas.TESSPidCPC#">	
			order by TESSPid
		</cfquery>
	</cfif>
<!--- No se usan Equivalencias
<!---Obtengo la compañia--->
<cfquery name="rsCodICTS" datasource="sifinterfaces">
	select EQUempOrigen as CodICTS, EQUempSIF as Ecodigo, EQUcodigoSIF as EcodigoSDC, EQUdescripcion as Edescripcion
	from SIFLD_Equivalencia
	where EQUcodigoSIF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	and CATcodigo = 'CADENA'
</cfquery>--->

<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select Ecodigo, Edescripcion
    from Empresas
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<!---Periodo--->
<cfquery name ="rsAnio" datasource="#session.dsn#">
	select Pvalor  from Parametros 
	where  Pcodigo = 50 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery> 
	
<cfquery name ="rsMes" datasource="#session.dsn#">
	select Pvalor from Parametros 
	where Pcodigo = 60
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

	<cfif rsSPsRelacionadas.recordCount GT 1>
		<cfset LvarSPsDestinos = valueList(rsSPsRelacionadas.TESSPnumero)>
		<cfset LvarSPsOrigen  = listGetAt(LvarSPsDestinos,1)>
		<cfset LvarSPsDestinos  = listDeleteAt(LvarSPsDestinos,1)>
	<cfelse>
		<cfset LvarSPsDestinos = "">
		<cfset LvarSPsOrigen  = "">
	</cfif>
	
	<cfloop query="rsSPsRelacionadas">
		<cfset LvarTESSPid	= rsSPsRelacionadas.TESSPid>

		<cfquery datasource="#session.dsn#" name="rsReporteTotal">
			Select 
				cf.CFformato
				, TESSPnumero
				, dtp.TESDPtipoDocumento
				, dtp.TESDPidDocumento
				, case when sp.TESSPtipoDocumento <> 1
					then 
						case when dtp.TESDPreferenciaOri is not null then dtp.TESDPreferenciaOri #_CAT# ',' else ' ' end #_CAT# dtp.TESDPdocumentoOri #_CAT# ' '
					else ' ' 
				  end #_CAT# dtp.TESDPdescripcion as TESDPdescripcion
				, sp.UsucodigoSolicitud
				,{fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )} as confeccionadoPor
				, sp.TESSPestado
				, sn.SNnombre
				, sp.McodigoOri
				, e.Edescripcion
				, m.Mnombre, m.Miso4217
				, sp.TESSPfechaSolicitud
				, sp.TESSPfechaPagar
				, coalesce(sn.SNnombrePago, sn.SNnombre, tb.TESBeneficiario, cd.CDCnombre) #_CAT# ' ' #_CAT# coalesce(sp.TESOPbeneficiarioSuf,'') as pagueseA
				, sp.CPCid
				, coalesce(sn2.SNnombrePago, sn2.SNnombre) as cedidoA
				,	case c.CPCtipo 
						when 'M' then '#LB_PorMulta# '
						when 'C' then '#LB_PorCesion# '
						when 'E' then '#LB_PorEmbargo# '
					end #_CAT# CPCdocumento as CPCdocumento
				,	case CPCnivel
						when 'O' then 'A O.C.' #_CAT# (select <cf_dbfunction name="to_char" args="EOnumero"> from EOrdenCM where EOidorden = c.EOidorden)
						when 'D' then (select 'A ' #_CAT# CPTcodigo #_CAT# '.' #_CAT# Ddocumento from HEDocumentosCP where IDdocumento = c.IDdocumento)
					end as CPCAdocumento
				, c.CPCdescripcion
				, sp.TESSPtotalPagarOri
				, TESDPmontoSolicitadoOri
				, <cf_dbfunction name="withData" args="sp.TESOPobservaciones"> as hayTESOPobservaciones
				, sp.TESOPinstruccion
				, case sp.TESSPtipoDocumento
					when 0 		then '#LB_SolManual#'
					when 5 		then '#LB_SolManualxCF#' 
					when 1 		then '#LB_SolPagoDctosManual#'
					when 2 		then '#LB_SolAnticiposCxP#' 
					when 3 		then '#LB_SolDevAntCxC#' 
					when 4 		then '#LB_SolDevAntPos#' 
					when 6 		then '#LB_SolPagoAntEmpleados#' 
					when 7 		then '#LB_SolPagoLiqGE#'
					when 8		then '#LB_SolPagoFondosCCH#'
					when 9		then '#LB_SolPagoReintegroCCH#'
					when 10		then '#LB_SolTransCtasBanc#' 
					when 100 	then '#LB_SolPagoInterfaz#' 
					else '#LB_SolPago#'
				end as Titulo
				, case sp.TESSPestado
					when 0   then '#LB_Preparacion#'
					when 1   then '#LB_ProcesoAprob#'
					when 2   then '#LB_SolAprobada#'
					when 3   then '#LB_SolRechazada#'
					when 23  then '#LB_SolRechazadaXTes#'
					when 10  then '#LB_SolAprobEInclOP#. ' #_CAT# coalesce(<cf_dbfunction name="to_char" args="op.TESOPnumero">,'(#LB_EnProceso#)')
					when 101 then '#LB_SolAprobInclAprob#. ' #_CAT# <cf_dbfunction name="to_char" args="op.TESOPnumero">
					when 103 then '#LB_RechazadaOP#. ' #_CAT# <cf_dbfunction name="to_char" args="op.TESOPnumero">
					when 11  then '#LB_SolAproInclEmisionOP#. ' #_CAT# <cf_dbfunction name="to_char" args="op.TESOPnumero"> 
					when 110 then '#LB_SolOpSinAplicar#' #_CAT# <cf_dbfunction name="to_char" args="op.TESOPnumero">
                    when 12  then '#LB_SolPagOP#. ' #_CAT# <cf_dbfunction name="to_char" args="op.TESOPnumero">
					when 13  then '#LB_SolAnuOP#. ' #_CAT# <cf_dbfunction name="to_char" args="op.TESOPnumero">
					when 202 then '#LB_AprobConCesiones#'
					when 212 then '#LB_ApliSinOP#'
					else '#LB_EstadoDesc#'					
				end as Estado
				, case sp.TESSPestado					
					when 3   then 	'#LB_MotRechazo#:'
					when 23  then 	'#LB_MotRechazo#:'
					when 103 then 	'#LB_MotRechazo#:'
					when 13  then 	'#LB_MotAnulacion#:'
					else '&nbsp;'					
				end as Motivo1
				, case sp.TESSPestado					
					when 3   then 	sp.TESSPmsgRechazo
					when 23  then 	sp.TESSPmsgRechazo
					when 103 then 	sp.TESSPmsgRechazo
					when 13  then 	sp.TESSPmsgRechazo
					else '&nbsp;'					
				end as Motivo2
				,{fn concat({fn concat({fn concat({fn concat(dpR.Pnombre , ' ' )}, dpR.Papellido1 )}, ' ' )}, dpR.Papellido2 )} as canceladoPor
				,sp.TESSPfechaRechazo
				,sp.TESSPidDuplicado
				,tes.TESdescripcion
				,sp.CFid, cfn.CFdescripcion
				,uA.Usulogin
				,case when RlineaId is null AND MlineaId is NULL then 0 else 1 end as LinGenerada
				,sp.TESSPid
				,sp.TESBid
				,sp.SNcodigoOri
				,sp.NAP
				,dtp.CFcuentaDB
				,dtp.Cid
				,dtp.TESDPmoduloOri
				,op.TESMPcodigo
				,op.TESOPid
				,Aprueba = (select D.DEapellido1+' '+D.DEapellido2+' '+D.DEnombre 
							from TESsolicitudFirmas F
   							inner join DatosEmpleado D on F.DEid_Aprueba = D.DEid
							where TESSPid = sp.TESSPid
							and F.Ecodigo = sp.EcodigoOri)
				,Autoriza = (select D.DEapellido1+' '+D.DEapellido2+' '+D.DEnombre 
							from TESsolicitudFirmas F
   							inner join DatosEmpleado D on F.DEid_Autoriza = D.DEid
							where TESSPid = sp.TESSPid
							and F.Ecodigo = sp.EcodigoOri)
			from TESsolicitudPago sp 
				inner join Empresas e
					on e.Ecodigo=sp.EcodigoOri
			
				inner join Monedas m
					on m.Ecodigo=sp.EcodigoOri
						and m.Mcodigo=sp.McodigoOri
			
				left outer join CFuncional cfn
					on cfn.CFid = sp.CFid
			
				left outer join Tesoreria tes
					on tes.TESid = sp.TESid
			
				left outer join TESordenPago op
					on op.TESOPid = sp.TESOPid
			
				left outer join SNegocios sn
					 on sn.Ecodigo=sp.EcodigoOri
					and sn.SNcodigo=sp.SNcodigoOri
			
				left outer join TESbeneficiario tb
					 on tb.TESBid	= sp.TESBid
	
				left outer join ClientesDetallistasCorp cd
					 on cd.CDCcodigo=sp.CDCcodigo
			
				inner join Usuario u
					inner join DatosPersonales dp
						on dp.datos_personales=u.datos_personales
					on u.Usucodigo=sp.UsucodigoSolicitud
			
				left join Usuario uR
					inner join DatosPersonales dpR
						on dpR.datos_personales=uR.datos_personales
					on uR.Usucodigo=sp.UsucodigoRechazo
			
				left join Usuario uA
					on uA.Usucodigo=sp.UsucodigoAprobacion
			
				inner join TESdetallePago dtp
					on dtp.TESSPid=sp.TESSPid
						and dtp.EcodigoOri=sp.EcodigoOri
			
				inner join CFinanciera cf
					on cf.Ecodigo=sp.EcodigoOri
						and cf.CFcuenta=dtp.CFcuentaDB
			
				left join CPCesion c
				
					inner join SNegocios sn2
						on sn2.SNid=c.SNidDestino
					on c.CPCid=sp.CPCid
			where sp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and sp.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">	
			order by TESDPdocumentoOri, TESDPreferenciaOri, TESDPid
		</cfquery>
		
<!---Obtengo  el  Tipo de Pago--->
<cfquery name="rsTipoPago" datasource="#session.dsn#">
	select case TESOPFPtipo					
					when 0  then 	'Pago con Cheque o Transferencia' <!---'Pago no  Especificado'--->
					when 1  then 	'Pago con Cheque'
					when 2  then 	'Pago por Transferencia'
					when 3  then 	'Pago con TCE'
					else 'Pago no  Especificado'
	end as tipoPago 
	from TESsolicitudPago a
	inner join TESOPformaPago b on b.TESOPFPid = a.TESSPid 
	where a.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.TESSPid#">
	and TESOPFPtipoId = 5 
</cfquery>	


<!---cfthrow message="tp: #rsTipoPago.tipoPago# r #rsTipoPago.RecordCount# tesspid = #rsReporteTotal.TESSPid#"--->
<!--- Obtengo los datos del  Banco --->
<cfif rsTipoPago.tipoPago EQ  'Pago por Transferencia'>
		<cfquery name="rsBanco" datasource="#session.dsn#">
			select TESTPbanco, TESTPcuenta, TESTPciudad + ' ' + Ppais as Localidad	
			from TESsolicitudPago a
			inner join TESOPformaPago b on b.TESOPFPid = a.TESSPid 
			inner join TEStransferenciaP on TESTPid = b.TESOPFPcta
			where a.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.TESSPid#">	
			and TESOPFPtipoId = 5 		
		</cfquery>
<cfelseif rsReporteTotal.TESOPid NEQ ''>
	<cfquery name="rsBanco" datasource="#session.dsn#">
		Select TESTPbanco, TESTPcuenta, TESTPciudad + ' ' + Ppais as Localidad	
		from TESordenPago a inner join TEStransferenciaP b on a.TESTPid = b.TESTPid
		where TESOPid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.TESOPid#">
	</cfquery>

</cfif>


		<cfif isdefined('rsReporteTotal') and rsReporteTotal.recordCount GT 0>
			<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
			<cfoutput>
			<cfif rsSPsRelacionadas.currentRow GT 1><div class="Corte_Pagina"></div>
		</cfif>
		<table width="100%" border="0">
	<tr>
		<td height="22" align="center"><span class="style1"><cf_translate key=LB_SolPago>SOLICITUD DE PAGO</cf_translate></span></td>
	</tr>
		<tr><td height="22" align="center"><strong>#rsEmpresa.Edescripcion#</strong></td>
	</tr>
	<tr>
		<cfif  isdefined("rsTipoPago") and rsTipoPago.tipoPago NEQ '' and rsTipoPago.RecordCount GT 0>	
			<td height="20" align="center"><strong><cf_translate key=LB_TipPago>Tipo de Pago</cf_translate>: (#rsTipoPago.tipoPago#)</strong></td>
		<cfelse>						
			<td height="20" align="center"><strong><cf_translate key=LB_TipPago>Tipo de Pago</cf_translate>: (<cf_translate key=LB_ChkOTrans>Con Cheque o Transferencia</cf_translate>)</strong></td>
		</cfif>
	</tr>
	<tr>
		<td height="20" align="center"><strong>#rsReporteTotal.Estado#</strong></td>
	</tr>
</table>
<br/>
<table  width="100%" >
	<tr>
		<td width="25%"><strong><cf_translate key=LB_AFavor>A  favor de</cf_translate>:</strong></td>
		<td width="35%">#rsReporteTotal.pagueseA#</td>
		<td width="15%" align = "right"><strong>SP:</strong></td>
		<td width="25%"><span class="style1">#rsReporteTotal.TESSPnumero#</span></td>
	</tr>
	<tr>
		<td width="25%" align="left"><strong><cf_translate key=LB_Imp>Importe</cf_translate>:</strong> </strong></td>
		<td width="35%">#LSNumberFormat(rsReporteTotal.TESSPtotalPagarOri,',9.00')#</td>
		<td width="15%" align="right"><strong><cf_translate key=LB_Moneda>Moneda</cf_translate>:  </strong></td>
		<td width="25%">#rsReporteTotal.Mnombre#</td>
	</tr>
		<tr>
		<td align ="left" width="25%"><strong><cf_translate key=LB_ImpLetra>Importe Letras</cf_translate>:</strong></td>
		<td width="70%" align ="left">#LvarObj.fnMontoEnLetras(rsReporteTotal.TESSPtotalPagarOri)#</td>
	</tr>
	<tr>
		<td width="25%"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate> :</strong>#LSDateFormat(rsReporteTotal.TESSPfechaSolicitud,'dd/mm/yyyy')#</td>
		<td width="35%"><strong><cf_translate key=LB_PagarDia>Pagar el  Día</cf_translate>: </strong> #DateFormat(rsReporteTotal.TESSPfechaPagar,"DD/MM/YYYY")#</td> 
		<td width="15%" align ="right"><strong><cf_translate key=LB_Periodo>Periodo</cf_translate>: </strong></td>
		<td width="25%" >#rsAnio.Pvalor#-#rsMes.Pvalor#</td>
	</tr>
</table>

	<table width="100%" >
	<tr >
		<td width="23%" height="21"><strong><cf_translate key=LB_BancoBen>Banco del Beneficiario</cf_translate>:</strong></td>
		<cfif isdefined("rsBanco") and rsBanco.RecordCount GT 0>
			<td width="34%">#rsBanco.TESTPbanco#</td>
		<cfelse>
			<td>&nbsp;</td>	
		</cfif>
		<td width="16%" > <strong><cf_translate key=LB_CtaBen>Cuenta del Beneficiario</cf_translate>: </strong></td>
		<cfif isdefined("rsbanco") and rsBanco.RecordCount GT 0>
			<td width="27%">#rsBanco.TESTPcuenta#</td>
		<cfelse>
			<td width="27%">&nbsp;</td>
		</cfif>
	  </tr>	  	  
</table>
<table  width="100%">
		<tr>
	  	  <td width="23%"><strong><cf_translate key=LB_Localidad>Localidad</cf_translate>:</strong></td>
		  <cfif isdefined("rsbanco") and rsBanco.RecordCount GT 0>
		  		  <td width="34%">#rsBanco.localidad#</td>
		  </cfif>
	    </tr>
		<tr >
		  <td width="23%" ><strong><cf_translate key=LB_Observaciones>Observaciones</cf_translate>: </strong></td>
		  <cfif rsReporteTotal.hayTESOPobservaciones EQ 1>
				<cfquery datasource="#session.dsn#" name="rsSQL">
				 Select TESOPobservaciones
                 from TESsolicitudPago sp
				 where sp.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">	
				</cfquery>
			<td width="77%">#replace(rsSQL.TESOPobservaciones,chr(10),"<BR>","ALL")#</td>
		  </cfif>	
		</tr>
		
</table>
</br>		
			
<!-------------------------------------------------------------------------------------------------------------------------->
<table width="100%"  border="1" cellspacing="0" cellpadding="0">
				<tr>
					<td width="60" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_Rubro>RUBRO</cf_translate></span></td>
					<td width="75" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_SubRubro>SUB-RUBRO</cf_translate></span></td>
					<td width="350" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_DescripcionDet>DESCRIPCION</cf_translate></span></td>
					<td width="350" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_UECF>							UE - CENTRO FUNCIONAL</cf_translate></span></td>
					<cfif rsReporteTotal.NAP NEQ ''>
					<td width="60" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_Nap>NAP</cf_translate></span></td>
					</cfif>
					<td width="60" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_Moneda>MONEDA</cf_translate></span></td>
					<td width="60" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_Monto>MONTO</cf_translate></span></td>
	</tr>		
</table>

<cfloop query="rsReporteTotal">		
	<cfquery name="rsRubroYsubRubro" datasource="#session.dsn#">							
 		 select Rubro = case  
		    when TESDPmoduloOri = 'CPFC' then (select top 1 case DD.DDtipo 
	    		when 'S' then (select substring (cuentac,1,5) from Conceptos where Cid = DD.DDcoditem) 
   				when 'F' then (select substring (cuentac,1,5) from Conceptos where Ccodigo = 'AF') 
				end 
				from TESsolicitudPago O
  				inner join TESdetallePago D on D.TESSPid = O.TESSPid
  				inner join HEDocumentosCP CP on CP.IDdocumento = D.TESDPidDocumento 
  				inner join HDDocumentosCP DD on DD.IDdocumento  = CP.IDdocumento 
  				where  D.TESSPid =<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsReporteTotal.TESSPid#">
				and TESDPidDocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.TESDPidDocumento#">
 				and D.TESDPtipoDocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReporteTotal.TESDPtipoDocumento#">
  				and NOT (TESDPmontoAprobadoOri <= 0 and TESDPdescripcion like '- Credito:%') 
				and D.RlineaId is null and D.MlineaId is null)
						 
			 when TESDPmoduloOri = 'TESP' or TESDPmoduloOri = 'CCH' or TESDPmoduloOri = 'TEPN' or TESDPmoduloOri = 'TEGE' 
			      then (select top 1 Rubro = case PCNid
						when 1 then substring(CFformato, 6,5) 
					  	when 2 then substring(CFformato, 6+5,5)
	   					when 3 then substring(CFformato, 6+10,5)
						when 4 then substring(CFformato, 6+15,5)
	   					when 5 then substring(CFformato, 6+20,5)
	   					when 6 then substring(CFformato, 6+25,5)
	   					when 7 then substring(CFformato, 6+30,5)
	   					when 8 then substring(CFformato, 6+35,5)
	   					when 9 then substring(CFformato, 6+40,5)
				  	   	when 10 then substring(CFformato, 6+45,5)
	   					when 11 then substring(CFformato, 6+50,5)  
	   					end
						from TESdetallePago DP 
					    inner join CFinanciera CF on DP.CFcuentaDB = CF.CFcuenta 
						and DP.EcodigoOri = CF.Ecodigo
						inner join CtasMayor CM on CF.Cmayor = CM.Cmayor and CF.Ecodigo = CM.Ecodigo
						inner join PCEMascaras M on M.PCEMid = CM.PCEMid 
					  	inner join PCNivelMascara D  on M.PCEMid = D.PCEMid 
						where CFcuentaDB = convert(integer, <cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsReporteTotal.CFcuentaDB#">)
                    	and PCNdescripcion  like 'RUBROS')
						end,
		SubRubro = case  
			    when TESDPmoduloOri = 'CPFC' then (select top 1 Rubro = case DD.DDtipo
				    when 'S' then (select substring (cuentac,6,3) from Conceptos where Cid = DD.DDcoditem) 
   					when 'F' then (select substring (cuentac,6,3) from Conceptos 
					where Ccodigo = 'AF') 
					end 
		 			from TESsolicitudPago O
  					inner join TESdetallePago D on D.TESSPid = O.TESSPid
  					inner join HEDocumentosCP CP on CP.IDdocumento = D.TESDPidDocumento 
  					inner join HDDocumentosCP DD on DD.IDdocumento  = CP.IDdocumento 
  		  			where  D.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.TESSPid#">
                    and TESDPidDocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.TESDPidDocumento#">
  					and D.TESDPtipoDocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReporteTotal.TESDPtipoDocumento#">
  					and NOT (TESDPmontoAprobadoOri <= 0 and TESDPdescripcion like '- Credito:%')  	  										 					and D.RlineaId is null and D.MlineaId is null)
					    
			 when TESDPmoduloOri = 'TESP' or TESDPmoduloOri = 'CCH' or TESDPmoduloOri = 'TEPN' or TESDPmoduloOri = 'TEGE' 
			   	then (select top 1 SubRubro = case PCNid
					when 1 then substring(CFformato, 12,3) 
				  	when 2 then substring(CFformato, 12+5,3)
				  	when 3 then substring(CFformato, 12+10,3)
				 	when 4 then substring(CFformato, 12+15,3)
				 	when 5 then substring(CFformato, 12+20,3)
				 	when 6 then substring(CFformato, 12+25,3)
					when 7 then substring(CFformato, 12+30,3)
	   				when 8 then substring(CFformato, 12+35,3)
	   				when 9 then substring(CFformato, 12+40,3)
	  				when 10 then substring(CFformato, 12+45,3)
	   				when 11 then substring(CFformato, 12+50,3) 
	   			end
				from TESdetallePago DP 
				inner join CFinanciera CF on DP.CFcuentaDB = CF.CFcuenta 
				and DP.EcodigoOri = CF.Ecodigo
				inner join CtasMayor CM on CF.Cmayor = CM.Cmayor and CF.Ecodigo = CM.Ecodigo
				inner join PCEMascaras M on M.PCEMid = CM.PCEMid 
				inner join PCNivelMascara D  on M.PCEMid = D.PCEMid 
				where CFcuentaDB = convert(integer, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporteTotal.CFcuentaDB#">)
               	and PCNdescripcion  like 'RUBROS')
				end 			
		from  TESdetallePago
		where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.TESSPid#">
	</cfquery>

	<cfif isdefined("rsRubroYsubRubro") and rsRubroYsubRubro.recordcount GT 0 and rsRubroYsubRubro.Rubro NEQ ''> 
		<cfset Rubro = 	rsRubroYsubRubro.Rubro>
		<cfset SubRubro = rsRubroYsubRubro.subRubro>
	<cfelse>
		<cfif rsReporteTotal.Cid NEQ ''>
			<cfquery name ="rsTEPN" datasource="#session.dsn#">
				select substring(C.cuentac,1,5) as Rubro, 
				substring(C.cuentac,6,3) as subRubro
				from Conceptos C
				inner join CConceptos CC on CC.CCid = C.CCid
				where Cid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReporteTotal.Cid#">
			</cfquery>
			
			<cfset Rubro = 	rsTEPN.Rubro>
			<cfset SubRubro = rsTEPN.subRubro>
		<cfelseif rsReporteTotal.Cid EQ ''>
			<cfif trim(rsReporteTotal.TESDPmoduloOri) EQ 'TESP'>	
				<cfquery name = "rsTE" datasource="#session.dsn#">
				select substring(C.cuentac,1,5) as Rubro, 
				substring(C.cuentac,6,3) as  subRubro
				from Conceptos C
				where Ccodigo = 'TE'
				</cfquery>
				<cfif isdefined("rsTE") and rsTE.recordcount GT 0 and ltrim(rtrim(rsTE.Rubro)) NEQ ''>
					<cfset Rubro = 	rsTE.Rubro>
					<cfset SubRubro = rsTE.subRubro>				
				</cfif>
			<cfelseif trim(rsReporteTotal.TESDPmoduloOri) EQ 'CCH'>	
				<cfquery name = "rsCJ" datasource="#session.dsn#">
				select substring(C.cuentac,1,5) as Rubro, 
				substring(C.cuentac,6,3) as  subRubro
				from Conceptos C
				where Ccodigo = 'CJ'
				</cfquery>
				<cfif isdefined("rsCJ") and rsCJ.recordcount GT 0 and ltrim(rtrim(rsCJ.Rubro)) NEQ ''>
					<cfset Rubro = 	rsCJ.Rubro>
					<cfset SubRubro = rsCJ.subRubro>	
				</cfif>
			<cfelse>
				<cfset Rubro = 	'&nbsp;'>
				<cfset SubRubro = '&nbsp;'>	
			</cfif>		
		</cfif>		
	</cfif>
	

<table width="100%"  border="0" cellspacing="0" cellpadding="0">

	<cfset LvarListaNon = (CurrentRow MOD 2)>
	<cfset LvarDesc = rsReporteTotal.TESDPdescripcion>
	<cfset LvarCFdesc = rsReporteTotal.CFdescripcion>
	<cfif len(LvarDesc) GT 43>
		<!---cfset LvarDesc=substring(LvarDesc,0,42)--->
	</cfif>	
	
	<cfif len(LvarCFdesc) GT 43>
		<!---cfset LvarCFdesc=substring(LvarCFdesc,0,42)--->
	</cfif>
	<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">		
	  		  
  		<td  width="60" valign="top" align="center" style="border-left-width: 1px; border-left-style: solid; border-left-color: gray;" ><span class="style8">#Rubro#</span></td>		
		<td width="75" valign="top" align="center"><span class="style8">#Subrubro#</span></td>															
		<td width="350" valign="top" align="left"><span class="style8">#rsReporteTotal.TESDPdescripcion#</span></td>
		<td width="350" valign="top" align="left"><span class="style8">#rsReporteTotal.CFdescripcion#</span></td>
		<cfif rsReporteTotal.NAP NEQ ''>
		<td width="60" valign="top" align="right"><span class="style8">#rsReporteTotal.NAP#</span></td>
		</cfif>								
		<td width="60" valign="top" align="right"><span class="style8">#rsReporteTotal.Miso4217#</span></td>
						
		<cfif rsReporteTotal.TESDPmontoSolicitadoOri GT 0>
		<td width="60" valign="top" nowrap align="right" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#LSNumberFormat(rsReporteTotal.TESDPmontoSolicitadoOri,',9.00')#</span></td>
		<cfelse>
		<td width="60" valign="top" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#LSNumberFormat(Abs(rsReporteTotal.TESDPmontoSolicitadoOri),',9.00')#</span></td>
		</cfif>
	</tr>	
			
		<cfset LvarRenglon = LvarRenglon+1>
		<cfif LvarRenglon EQ 31>
			<H6 class=SaltoDePagina>&nbsp;</H6>	
		<cfelseif LvarRenglon EQ 30>
			  <tr>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<cfif rsReporteTotal.NAP NEQ ''>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				</cfif>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
			  </tr> 
		<cfelseif LvarRenglon GT 30 and LvarRenglon EQ rsReporteTotal.recordCount>
				<tr>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<cfif rsReporteTotal.NAP NEQ ''>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				</cfif>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
			  </tr> 
		</cfif>

		</cfloop> 
	<cfset LvarCPCimpresion=false>
						<cfinclude template="solicitudesCP_Cesion.cfm">
						<cfif NOT LvarCPCimpresion AND rsReporteTotal.recordCount LT 25>
							<cfloop index = "LoopCount" from = "1" to = "#25 - rsReporteTotal.recordCount#">
							  <tr>
								<td style="border-left-width: 1px; border-left-style: solid; border-left-color: gray;">&nbsp;</td>
								<td>&nbsp; </td>
								<td>&nbsp; </td>
								<td>&nbsp; </td>
								<cfif rsReporteTotal.NAP NEQ ''>
								<td>&nbsp;</td>
								</cfif>
								<td>&nbsp; </td>
								<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
								
							  </tr>			
							</cfloop>
							<tr>
							<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
							<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
							<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
							<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
							<cfif rsReporteTotal.NAP NEQ ''>
							<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
							</cfif>
							<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
							<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;" >&nbsp;</td>
							</tr>
						</cfif>		 
</table>


<!------------------------------------------------------------------------------------------------------------------------->					
				<br />
				<table width="100%">
					<tr>
					<td>&nbsp;</td></tr>
					<tr>
						<td width="50%" align="center">____________________________________</td>
						<td width="50%" align="center">____________________________________</td>
					</tr>
					<tr>
						<!---<cfquery name="rsAutoriza" datasource="#session.dsn#">
						select de.DEnombre+' '+de.DEapellido1+' '+de.DEapellido1 as Nombre ,ECFencargado, sp.CFid 
						from 	TESsolicitudPago sp 
						inner join EmpleadoCFuncional ef on ef.CFid = sp.CFid and ef.Ecodigo = sp.EcodigoOri
						inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sp.EcodigoOri
						where  ef.Ecodigo = sp.EcodigoOri  and ECFencargado = 1 
						and sp.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.TESSPid#">
						</cfquery>
						td  align="center">&nbsp;#rsAutoriza.Nombre#&nbsp;</td--->
						
						<td align="center">&nbsp;#rsReporteTotal.Aprueba#&nbsp;</td>
						
						<!---<cfquery name ="rsAprueba" datasource="#session.dsn#">
							select de.DEnombre+' '+de.DEapellido1+' '+de.DEapellido1 as Nombre  ,ECFencargado, sp.CFid
							   from TESsolicitudPago sp 
							   inner join CFuncional cf on sp.CFid = cf.CFid and cf.Ecodigo = sp.EcodigoOri
							   inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
							   inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sp.EcodigoOri
							   where ECFencargado = 1 and sp.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteTotal.TESSPid#">
						</cfquery>
						td  align="center">&nbsp;#rsAprueba.Nombre#&nbsp;</td---->
						
						<td align="center">&nbsp;#rsReporteTotal.Autoriza#&nbsp;</td>
						
					</tr>
					<tr>
						<td  align="center"><strong>&nbsp;<cf_translate key=LB_Aprueba>Aprueba</cf_translate>&nbsp; </strong></td>
						<td  align="center"><strong>&nbsp;<cf_translate key=LB_Autoriza>Autoriza</cf_translate>&nbsp;</strong></td>
					</tr>
			</table>
				<br />
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" style="border:solid 1px gray;">
					<tr>
						<td><cf_translate key=LB_UsoExcTes>Para uso  exclusivo  de tesoreria</cf_translate></td>
					</tr>	
					<tr>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
					</tr>
					<tr>
							<td><cf_translate key=LB_Banco>Banco</cf_translate>: ______________________</td>
							<td><cf_translate key=LB_Cuenta>Cuenta</cf_translate>: _____________________</td>
							<td><cf_translate key=LB_Cuenta>Cheque</cf_translate>: _____________________</td>
					</tr>
					<tr>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
					</tr>
					<tr >
							<td align="center"><cf_translate key=LB_Elabora>Elabora</cf_translate></td> 
							<td align="center">&nbsp;<!---<cf_translate key=LB_Autoriza>Autoriza</cf_translate>---></td>
							<td align="center"><cf_translate key=LB_FecyFirma>Fecha y Firma de Recibido</cf_translate></td>
							
					</tr>	
				</table>
				
			</cfoutput>	
		</cfif>
	</cfloop>
<cfelse>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		Select count(1) as cantidad
		  from TESsolicitudPago sp
		 where sp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 		   and sp.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#form.TESSPid EQ ""#">	
	</cfquery>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>	  
		<tr>
		  <cfif rsSQL.cantidad EQ 0>
			<td align="center"><strong><cfoutput>#MSG_NoEncotroSP#</cfoutput></strong></td>
		  <cfelse>
			<td align="center"><strong><cfoutput>#MSG_SPSeleccionada#</cfoutput></strong></td>
		  </cfif>
		</tr>	  
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr>
		  <td align="center">&nbsp;</td> 
		</tr>				  
	</table>
</cfif>


