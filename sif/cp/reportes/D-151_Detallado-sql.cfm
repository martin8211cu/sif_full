<cf_htmlReportsHeaders 
	irA="D-151.cfm"
	FileName="ReporteD-151.xls"
	title="Reporte D-151">
    
<style type="text/css"></style>
   
<cf_dbfunction name="date_part"	args="yyyy, ECP.Dfecha"  returnvariable="LvarAno1">
<cf_dbfunction name="date_part"	args="mm, ECP.Dfecha"  returnvariable="LvarMes1">
<cf_dbfunction name="date_part"	args="yyyy, SP.TESSPfechaSolicitud"  returnvariable="LvarAno2">
<cf_dbfunction name="date_part"	args="mm, SP.TESSPfechaSolicitud"  returnvariable="LvarMes2">
<cf_dbfunction name="date_part"	args="yyyy, GE.GELfecha"  returnvariable="LvarAno3">
<cf_dbfunction name="date_part"	args="mm, GE.GELfecha"  returnvariable="LvarMes3">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="rsReporte" datasource="#session.dsn#">
   	<cfif isdefined('form.TipoProveedor') And (form.TipoProveedor EQ 'SN' Or form.TipoProveedor EQ 'T')>
	<!---1: Cuentas por Pagar:--------------------------------------------------------------------------------------------------------->
    Select 
    	Distinct
        Moneda,
    	NumDOC, IDDOC, -1 As NumLiq, '-1' As Empleado, '-1' As DesLiq,               
        TipoDOC, Fecha, Nombre, Identificacion, 
        Sum(MontoL_SIMP) As MontoL_SIMP, 
        Sum(MontoO_SIMP) As MontoO_SIMP,
        Sum(IMPL) As IMPL,
        Sum(IMPO) As IMPO,
        Sum(MontoLocal) As MontoLocal,
        Sum(MontoOrigen) As MontoOrigen,
        Clasificacion, ClasificacionValor
    From
    (
        Select
        	M.Miso4217 As Moneda,
            ECP.Ddocumento As NumDOC,
            ECP.IDdocumento As IDDOC,
            DCP.CPTcodigo As TipoDOC,
			<cf_dbfunction name="date_format"	args="ECP.Dfecha, DD/MM/YYYY"> As Fecha,
            SN.SNnombre As Nombre,
            SN.SNidentificacion As Identificacion,
            (
                (Case
                    When DCP.CPTcodigo = 'FC'
                        Then DCP.DDtotallin
                    When DCP.CPTcodigo = 'NC'
                        Then DCP.DDtotallin * -1
                    Else
                        0
                End) * ECP.EDtcultrev
            ) As MontoL_SIMP, 	<!--- Monto Local Sin Impuestos ---> 
            (
                (Case
                    When DCP.CPTcodigo = 'FC'
                        Then DCP.DDtotallin
                    When DCP.CPTcodigo = 'NC'
                        Then DCP.DDtotallin * -1
                    Else
                        0
                End)
            ) As MontoO_SIMP,	<!--- Monto Origen Sin Impuestos --->
            (
                (Case
                    When DCP.CPTcodigo = 'FC'
                        Then DCP.DDtotallin
                    When DCP.CPTcodigo = 'NC'
                        Then DCP.DDtotallin * -1
                    Else
                        0
                End) * (I.Iporcentaje / 100) * ECP.EDtcultrev
            ) As IMPL,			<!--- Impuestos Locales --->  
            (
                (Case
                    When DCP.CPTcodigo = 'FC'
                        Then DCP.DDtotallin
                    When DCP.CPTcodigo = 'NC'
                        Then DCP.DDtotallin * -1
                    Else
                        0
                End) * (I.Iporcentaje / 100)
            ) As IMPO,			<!--- Impuestos Origen --->  
            
           	((
                (Case
                    When DCP.CPTcodigo = 'FC'
                        Then DCP.DDtotallin
                    When DCP.CPTcodigo = 'NC'
                        Then DCP.DDtotallin * -1
                    Else
                        0
                End) * ECP.EDtcultrev
            )      
            
            +
            
            (
                (Case
                    When DCP.CPTcodigo = 'FC'
                        Then DCP.DDtotallin
                    When DCP.CPTcodigo = 'NC'
                        Then DCP.DDtotallin * -1
                    Else
                        0
                End) * (I.Iporcentaje / 100) * ECP.EDtcultrev
            )) As MontoLocal,			<!--- Monto Local con Impuestos --->   
            
           	((
                (Case
                    When DCP.CPTcodigo = 'FC'
                        Then DCP.DDtotallin
                    When DCP.CPTcodigo = 'NC'
                        Then DCP.DDtotallin * -1
                    Else
                        0
                End)
            )      
            
            +
            
            (
                (Case
                    When DCP.CPTcodigo = 'FC'
                        Then DCP.DDtotallin
                    When DCP.CPTcodigo = 'NC'
                        Then DCP.DDtotallin * -1
                    Else
                        0
                End) * (I.Iporcentaje / 100) 
            )) As MontoOrigen,			<!--- Monto Origen con Impuestos --->                  
                        
            Coalesce(
                        (
                        Select 
                            Min(DSN.SNCDdescripcion) 
                        From 
                            SNClasificacionSN CSN
                                Left Join SNClasificacionD DSN On 
                                    DSN.SNCDid = CSN.SNCDid
                        Where 
                            CSN.SNid = SN.SNid 
                        ),
                        '----'
                    ) As Clasificacion,
                    
            Coalesce(
                        (
                        Select 
                            Min(DSN.SNCDvalor) 
                        From 
                            SNClasificacionSN CSN
                                Left Join SNClasificacionD DSN On 
                                    DSN.SNCDid = CSN.SNCDid
                        Where 
                            CSN.SNid = SN.SNid 
                        ),
                        '----'
                    ) As ClasificacionValor                    
                    
        From 
            HDDocumentosCP DCP 
            Inner Join HEDocumentosCP ECP On
                ECP.IDdocumento = DCP.IDdocumento And
                ECP.Ecodigo = #session.Ecodigo#
            Left Outer Join Impuestos I On
                I.Icodigo = DCP.Icodigo And
                I.Ecodigo = #session.Ecodigo#
            Inner Join SNegocios SN On 
                SN.SNcodigo = DCP.SNcodigo And
                SN.Ecodigo = #session.Ecodigo#
           	Inner Join Monedas M On
            	M.Mcodigo = ECP.Mcodigo And
                M.Ecodigo = #session.Ecodigo#                            
              
        Where 
            DCP.Ecodigo = #session.Ecodigo# 
            And DCP.CPTcodigo in ('FC', 'NC')
            And #LvarAno1# * 100 + #LvarMes1#  Between #form.periodo# * 100 + #form.mes# And #form.periodo2# *100 + #form.mes2#
        <!---Si esta definido el Socio de Negocio en el filtro:--->
        <cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo)) And form.TipoProveedor NEQ 'T'>
            And SN.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.SNcodigo)#">
            <!---And SN.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNnumero)#">--->
        </cfif>
        
        <!---Si se escogio una clasificación:--->
        <cfif isdefined('form.SNCEid') and len(trim(form.SNCEid))>
             And #form.SNCEid#  In 
             (Select B.SNCEid 
                From SNClasificacionSN A
                    Left Join SNClasificacionD B On 
                        B.SNCDid = A.SNCDid
                Where A.SNid = SN.SNid 
              ) 
        </cfif>
    
		<!---Si es escogio un rango de clasificaciones:--->
        <cfif isdefined('form.SNCDvalor1') and len(trim(form.SNCDvalor1)) and isdefined('form.SNCDvalor2') and len(trim(form.SNCDvalor2))>
            And  (Select Count(1)
                    From SNClasificacionSN A 
                        Left Join SNClasificacionD B On 
                            B.SNCDid = A.SNCDid 
                    Where A.SNid = SN.SNid
                        And B.SNCDvalor  Between '#form.SNCDvalor1#' And '#form.SNCDvalor2#'
                        And B.SNCEid =  #form.SNCEid#
                  )  > 0
        </cfif>
   	) Tabla
    Group By 
    	IDDOC
        
    Union All
   	</cfif>
     
	<!---2: Solicitudes de pago Manual:------------------------------------------------------------------------------------------------>
    Select 
    Distinct
    Moneda,
    NumDOC, IDDOC, -1, '-1', '-1',  
    TipoDOC, Fecha, Nombre, Identificacion, 
    Sum(MontoL_SIMP) As MontoL_SIMP, 
    Sum(MontoO_SIMP) As MontoO_SIMP,
    Sum(IMPL) As IMPL,
    Sum(IMPO) As IMPO,
    Sum(MontoLocal) As MontoLocal,
    Sum(MontoOrigen) As MontoOrigen,
    Clasificacion, ClasificacionValor
    From
    (
    Select
        M.Miso4217 As Moneda,
        <cf_dbfunction name="to_char"	args="SP.TESSPnumero"> As NumDOC,
        SP.TESSPid As IDDOC,
        
        'SPM' As TipoDOC,
        <cf_dbfunction name="date_format"	args="SP.TESSPfechaSolicitud, DD/MM/YYYY"> As Fecha, 
        Coalesce(SN.SNnombrePago, SN.SNnombre, B.TESBeneficiario) As Nombre,
        Coalesce(SN.SNidentificacion, B.TESBeneficiarioId) As Identificacion,
        (DP.TESDPmontoPagoLocal - (Coalesce(TESDPimpNCFOri, 0) * DP.TESDPtipoCambioOri)) As MontoL_SIMP,
        (DP.TESDPmontoPago - (Coalesce(TESDPimpNCFOri, 0))) As MontoO_SIMP,
        (Coalesce(TESDPimpNCFOri, 0) * DP.TESDPtipoCambioOri) As IMPL,
        Coalesce(TESDPimpNCFOri, 0) As IMPO,
        DP.TESDPmontoPagoLocal As MontoLocal,
        DP.TESDPmontoPago As  MontoOrigen,
        Coalesce(
                    (
                    Select 
                        Min(DSN.SNCDdescripcion) 
                    From 
                        SNClasificacionSN CSN
                            Left Join SNClasificacionD DSN On 
                                DSN.SNCDid = CSN.SNCDid
                    Where 
                        CSN.SNid = SN.SNid 
                    ),
                    'NA'
                ) As Clasificacion,
                    
        Coalesce(
                    (
                    Select 
                        Min(DSN.SNCDvalor) 
                    From 
                        SNClasificacionSN CSN
                            Left Join SNClasificacionD DSN On 
                                DSN.SNCDid = CSN.SNCDid
                    Where 
                        CSN.SNid = SN.SNid 
                    ),
                    '----'
                ) As ClasificacionValor  
    From
        TESdetallePago DP
        Inner Join TESsolicitudPago SP On
            DP.TESSPid = SP.TESSPid And
            SP.EcodigoOri = #session.Ecodigo#
        Inner Join Conceptos C On
            DP.Cid = C.Cid And
            C.Ecodigo = #session.Ecodigo#
        Left Outer Join SNegocios SN On
            SP.SNcodigoOri = SN.SNcodigo And
            SN.Ecodigo = #session.Ecodigo#
        Left Outer Join TESbeneficiario B On
            SP.TESBid = B.TESBid
        Inner Join Monedas M On
            M.Mcodigo = SP.McodigoOri And
            M.Ecodigo = #session.Ecodigo#  
            
    Where
        DP.EcodigoOri = #session.Ecodigo# And
        C.Cd151 = 1 And
        SP.TESSPestado = 12 And <!---En OP Emitida--->
        SP.TESSPtipoDocumento in (0, 5) <!---0: Solicitud Manual, 5: Solicitud Manual Por Oficina  --->
        And #LvarAno2# * 100 + #LvarMes2#  Between #form.periodo# * 100 + #form.mes# And #form.periodo2# *100 + #form.mes2#
    <!---Si esta definido el Socio de Negocio en el filtro:--->
    <cfif isdefined('form.TipoProveedor') And (form.TipoProveedor EQ 'SN' Or form.TipoProveedor EQ 'T')>
        <cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo)) And form.TipoProveedor NEQ 'T'>
            And SN.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.SNcodigo)#">
            <!---And SN.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNnumero)#">--->
        </cfif>
        
        <!---Si se escogio una clasificación:--->
        <cfif isdefined('form.SNCEid') and len(trim(form.SNCEid))>
             And #form.SNCEid#  In 
             (Select B.SNCEid 
                From SNClasificacionSN A
                    Left Join SNClasificacionD B On 
                        B.SNCDid = A.SNCDid
                Where A.SNid = SN.SNid 
              ) 
        </cfif>
        
        <!---Si es escogio un rango de clasificaciones:--->
        <cfif isdefined('form.SNCDvalor1') and len(trim(form.SNCDvalor1)) and isdefined('form.SNCDvalor2') and len(trim(form.SNCDvalor2))>
            And  (Select Count(1)
                    From SNClasificacionSN A 
                        Left Join SNClasificacionD B On 
                            B.SNCDid = A.SNCDid 
                    Where A.SNid = SN.SNid
                        And B.SNCDvalor  Between '#form.SNCDvalor1#' And '#form.SNCDvalor2#'
                        And B.SNCEid =  #form.SNCEid#
                  )  > 0
        </cfif>
    <cfelse>
        <cfif isdefined('form.TipoProveedor') And form.TipoProveedor NEQ 'T' And isdefined('form.TESBid') And len(trim(form.TESBid))>
            And B.TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.TESBid)#">
        </cfif>             
    </cfif>
    ) Tabla
    Group By 
        IDDOC
    
    Union All
        
	<!---3: Liquidaciones de Gastos a Empleados:--------------------------------------------------------------------------------------->
    Select
    	M.Miso4217 As Moneda,
    	<cf_dbfunction name="to_char"	args="GED.GELGnumeroDoc"> As NumDOC,
        GE.GELid As IDDOC,
        
        GE.GELnumero As NumLiq,
        BN.TESBeneficiario As Empleado,
        GE.GELdescripcion As Des,
        
        'LE' As TipoDOC,
        <cf_dbfunction name="date_format"	args="GE.GELfecha, DD/MM/YYYY"> As Fecha, 
        Coalesce(SN.SNnombre, B.TESBeneficiario)  As Nombre,
        Coalesce(SN.SNidentificacion, B.TESBeneficiarioId) As Identificacion,
        ((GELGtotalOri - GELGimpNCFOri) * GELGtipoCambio ) As MontoL_SIMP,
        ((GELGtotalOri - GELGimpNCFOri) ) As MontoO_SIMP,
        (GELGimpNCFOri * GELGtipoCambio) As IMPL,
        GELGimpNCFOri As IMPO,
        (GELGtotalOri * GELGtipoCambio) As MontoLocal,
        GELGtotalOri As MontoOrigen,
        Coalesce(
                    (
                    Select 
                        Min(DSN.SNCDdescripcion) 
                    From 
                        SNClasificacionSN CSN
                            Left Join SNClasificacionD DSN On 
                                DSN.SNCDid = CSN.SNCDid
                    Where 
                        CSN.SNid = SN.SNid 
                    ),
                    'NA'
                ) As Clasificacion,
        Coalesce(
                    (
                    Select 
                        Min(DSN.SNCDvalor) 
                    From 
                        SNClasificacionSN CSN
                            Left Join SNClasificacionD DSN On 
                                DSN.SNCDid = CSN.SNCDid
                    Where 
                        CSN.SNid = SN.SNid 
                    ),
                    '----'
                ) As ClasificacionValor  
                     
    From 
        GEliquidacionGasto GED
        Inner Join GEliquidacion GE On
            GE.GELid = GED.GELid And
            GE.Ecodigo = #session.Ecodigo#
        Inner Join GEconceptoGasto GEC On
            GED.GECid = GEC.GECid
        Inner Join Conceptos C On
            GEC.Cid = C.Cid And
            C.Cd151 = 1 And
            C.Ecodigo = #session.Ecodigo#
        Left Outer Join SNegocios SN On
            SN.SNcodigo = GED.SNcodigo And
            SN.Ecodigo = #session.Ecodigo#
        Left Outer Join TESbeneficiario B On
            GED.TESBid = B.TESBid   
        Inner Join Monedas M On
        	M.Mcodigo = GED.Mcodigo And
            M.Ecodigo = #session.Ecodigo#
      	Inner Join TESbeneficiario BN On
        	BN.TESBid = GE.TESBid
                                   
    Where
        GE.GELestado in (4, 5) <!---4: Finalizada, 5: Por Entregar--->
        <!---And GE.GELtipoP = 1--->
        And GED.Ecodigo = #session.Ecodigo#
        And #LvarAno3# * 100 + #LvarMes3#  Between #form.periodo# * 100 + #form.mes# And #form.periodo2# *100 + #form.mes2#
    <!---Si esta definido el Socio de Negocio en el filtro:--->
    <cfif isdefined('form.TipoProveedor') And (form.TipoProveedor EQ 'SN'  Or form.TipoProveedor EQ 'T')>
        <cfif isdefined('form.SNcodigo') And Len(trim(form.SNcodigo)) And form.TipoProveedor NEQ 'T'>
            And SN.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.SNcodigo)#">
            <!---And SN.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNnumero)#">--->
        </cfif>
        
        <!---Si se escogio una clasificación:--->
        <cfif isdefined('form.SNCEid') and len(trim(form.SNCEid))>
             And #form.SNCEid#  In 
             (Select B.SNCEid 
                From SNClasificacionSN A
                    Left Join SNClasificacionD B On 
                        B.SNCDid = A.SNCDid
                Where A.SNid = SN.SNid 
              ) 
        </cfif>
        
        <!---Si es escogio un rango de clasificaciones:--->
        <cfif isdefined('form.SNCDvalor1') and len(trim(form.SNCDvalor1)) and isdefined('form.SNCDvalor2') and len(trim(form.SNCDvalor2))>
            And  (Select Count(1)
                    From SNClasificacionSN A 
                        Left Join SNClasificacionD B On 
                            B.SNCDid = A.SNCDid 
                    Where A.SNid = SN.SNid
                        And B.SNCDvalor  Between '#form.SNCDvalor1#' And '#form.SNCDvalor2#'
                        And B.SNCEid =  #form.SNCEid#
                  )  > 0
        </cfif>
    <cfelse>
        <cfif isdefined('form.TipoProveedor') And form.TipoProveedor NEQ 'T' And isdefined('form.TESBid') And len(trim(form.TESBid))>
            And B.TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.TESBid)#">
        </cfif>             
    </cfif>             
    Order By
        ClasificacionValor, Nombre, TipoDOC, Fecha, NumDOC      
</cfquery>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	Select 
        Edescripcion,
        Ecodigo
	From Empresas
	Where Ecodigo=#session.Ecodigo#
</cfquery>

<cffunction name="obtenerDetallePago" description="Obtiene el detalles de los pagos" returntype="query">
	<cfargument name='IDDOC' 	type="numeric" 	required='true'>
    <cfargument name='TipoDOC' 	type="string" 	required='true'>
    
    <cfquery name="rsResult" datasource="#session.dsn#">
        Select
        	Distinct         
            B.TESSPnumero As NumSol, 
            C.TESOPnumero As NumOP,
            Case MP.TESTMPtipo
                when 1 then 'CHK ' #_Cat# <cf_dbfunction name="to_char" args="C.TESCFDnumFormulario">
                when 2 then 'TRI ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = C.TESTDid)
                when 3 then 'TRE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = C.TESTDid)
                when 4 then 'TRM ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = C.TESTDid)
                when 5 then 'TCE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = C.TESTDid)
            End As DocPago,
            Coalesce(TESL.TESTLtotalDebitado, C.TESOPtotalPago) As MontoPagado,
            E.Bcodigo As BancoPago, 
            Coalesce(D.CBcodigo,'NA') As CtaPago, 
            Coalesce(P.TESTPcuenta, 'NA') as CtaSocio , Coalesce(E1.Bcodigo, 'NA') as BancoSocio       
        From
            TESdetallePago A       	   
            Inner Join TESsolicitudPago B On
                A.TESSPid = B.TESSPid And
                B.TESSPestado = 12 And
                B.EcodigoOri = #session.Ecodigo#
            Left Outer Join TESordenPago C On
                A.TESOPid = C.TESOPid And
                C.EcodigoPago = #session.Ecodigo#
            Left Outer Join CuentasBancos D
                Inner Join Bancos E On 
                    E.Bid = D.Bid
                On D.CBid = C.CBidPago  
            Left Outer Join TESmedioPago MP On
                MP.CBid	= C.CBidPago And 
                MP.TESMPcodigo 	= C.TESMPcodigo 
            Left Outer Join TEStransferenciasD TESF On 
                C.TESOPid = TESF.TESOPid And  
                TESF.TESTDestado <> 3  						<!---Documento Anulado.--->    
            Left Outer Join TEStransferenciasL TESL On
                TESL.TESTLid = TESF.TESTLid
            Left Outer Join TEScontrolFormulariosD TESCF On
                TESCF.TESOPid = C.TESOPid And
                TESCF.TESCFDestado <> 3						<!---Documento Anulado.---> 
          	Left Outer Join TEStransferenciaP P
               	On C.TESTPid   = P.TESTPid   
           	Left Outer Join Bancos E1 On
            	P.Bid = E1.Bid      	
        Where
            <cfif #Arguments.TipoDOC# EQ 'FC'>
                A.TESDPtipoDocumento = 1 And 		 		<!---0: Manual, 1: CxP, 5: Manual por CF--->
                A.TESDPidDocumento = #Arguments.IDDOC# And
            <cfelse>
                A.TESDPtipoDocumento In (0, 5) And 
                A.TESSPid = #Arguments.IDDOC# And
            </cfif>
                A.EcodigoOri = #session.Ecodigo#
	</cfquery>
    
    <cfreturn rsResult>           
    
</cffunction>

<!---<cf_dump var="#rsReporte#">--->

<cfif isdefined("form.btnDownload")>
	<cfset oldlocale = SetLocale("French (Canadian)")>
</cfif>

<table align="center" border="0" summary="Reporte" cellpadding="0" cellspacing="0">
	<cfoutput>
   		<tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px"> 
        	<td  align="left" bgcolor="BCBCBC" colspan="15"><strong>#rsEmpresa.Edescripcion#</strong></td>
            <td  align="right" bgcolor="BCBCBC" colspan="5"><strong>Fecha:&nbsp;#DateFormat(Now(), "mmm d, yyyy")#</strong></td>
        </tr> 
		<tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px">
			<td  align="left" bgcolor="BCBCBC" colspan="15"><strong>Sistema de Cuentas por Pagar</strong></td>
            <td  align="right" bgcolor="BCBCBC" colspan="5"><strong>Hora:&nbsp;#TimeFormat(Now(), "h:mm TT")#</strong></td>
		</tr>
		<tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px">
        	<td  align="left" bgcolor="BCBCBC" colspan="20"><strong>Reporte D-151 Detallado</strong></td>
		</tr>
    </cfoutput>
    <tr><td>&nbsp;</td></tr>
    <cfif rsReporte.RecordCount GT 0>
<!---    <tr>
        <td  colspan="20" align="center">--->
            <!---<table  border="0" cellpadding="0" cellspacing="0"  align="center">--->
            	<tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
                	<td colspan="4"></td>
                    <td colspan="3" align="center"><strong>Montos Locales</strong></td>
                    <td colspan="3" align="center"><strong>Montos Origen</strong></td>
                </tr>
                <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
                    <td  width="5%" align="center">
                        <strong>Tipo</strong>
                    </td>
                    <td  width="5%" align="center">
                        <strong>Documento</strong>
                    </td>
                    <td  width="5%" align="center">
                        <strong>Moneda</strong>
                    </td>                
                    <td  width="5%" align="center">
                        <strong>Fecha</strong>
                    </td>                                                                   
                    <td width="10%" align="center">
                        <strong>Monto</strong>
                    </td>
                    <td width="7%" align="center">
                        <strong>Impuesto</strong>
                    </td>
                    <td width="7%" align="center">
                        <strong>Total</strong>
                    </td>
                    <td width="7%" align="center">
                        <strong>Monto</strong>
                    </td>
                    <td width="7%" align="center">
                        <strong>Impuestos</strong>
                    </td>
                    <td width="7%" align="center">
                        <strong>Total</strong>
                    </td>
                  	<td width="5%" align="center">
                        <strong>Sol. de Pago</strong>
                    </td> 
                  	<td width="5%" align="center">
                        <strong>Orden de Pago</strong>
                    </td> 
              		<td width="10%" align="center">
                        <strong>Doc. de Pago</strong>
                 	</td>
                	<td width="5%" align="center">
                        <strong>Banco Pago</strong>
                    </td>                       
                	<td width="5%"align="center">
                        <strong>Cuenta Pago</strong>
                    </td>
                	<td width="5%"align="center">
                        <strong>&nbsp;Banco Trans.&nbsp;</strong>
                    </td>  
                	<td width="5%"align="center">
                        <strong>&nbsp;Cuenta Trans.&nbsp;</strong>
                    </td>
                	<td width="5%" align="center">
                        <strong>&nbsp;Numero Liq.&nbsp;</strong>
                    </td> 
                	<td width="25%" align="center">
                        <strong>&nbsp;Empleado&nbsp;</strong>
                    </td> 
                	<td width="25%" align="center">
                        <strong>&nbsp;Descripci&oacute;n&nbsp;</strong>
                    </td>                                                                                                                                                                                                                                                                                                                               
                </tr>
                <cfset count = 1>
                <cfset totalGeneral1 = 0>
                <cfset totalGeneral2 = 0>
                <cfset totalGeneral3 = 0>
                <cfset totalGeneral4 = 0>
                <cfset totalGeneral5 = 0>
                <cfset totalGeneral6 = 0>
                
                <cfoutput query="rsReporte" group="ClasificacionValor">
                	<tr style="font-family:Arial, Helvetica, sans-serif; font-size:13px">
                    	<td colspan="20" align="Left" bgcolor="DDDDDD">
                        	<strong>
                            	&nbsp;Clasificaci&oacute;n:&nbsp;#ClasificacionValor#&nbsp;-&nbsp;#Clasificacion#
                            </strong>
                       	</td>
                    </tr>
                    <cfoutput group="Nombre">
                        <tr style="font-family:Arial, Helvetica, sans-serif; font-size:13px">
                            <td colspan="20" align="Left" bgcolor="BCBCBC">
                                <strong style="font-size:13px">
                                    Socio:&nbsp;#Identificacion#&nbsp;-&nbsp;#Nombre#
                                </strong>
                            </td>
                        </tr>
						<cfset subTotal1 = 0> 		<!---Monto sin impuestos local--->
                        <cfset subTotal2 = 0>		<!---Impuestos locales--->
                        <cfset subTotal3 = 0>		<!---Monto local--->
                        <cfset subTotal4 = 0>		<!---Monto sin impuestos origen--->
                        <cfset subTotal5 = 0>		<!---Impuestos origen--->
                        <cfset subTotal6 = 0>		<!---Monto Origen--->
                        
                        <cfoutput group="NumDOC">
                        	<cfset contadorPagos = 0>
                     		<cfif #TipoDOC# Eq 'FC' Or #TipoDOC# Eq 'SP Manual'>
                        		<cfset rsPago = obtenerDetallePago(#IDDOC#, #TipoDOC#)>
								<cfset contadorPagos = rsPago.RecordCount>                                     
                        	</cfif>
						
                            <cfset contadorTemp = 1> 
                                                                                      
                            <tr style="font-family:Arial, Helvetica, sans-serif; font-size:11px">
                                <td width="5%" align="Left">
                                    #TipoDOC#
                                </td>
                                <td width="5%" align="Left">
                                    #NumDOC#
                                </td>
                                <td width="5%" align="Left">
                                    #Moneda#
                                </td>                                
                                <td width="5%" align="Left">
                                    #Fecha#
                                </td>                                                                                        
                                <td width="7%" align="right">
                                    <cfif isdefined("Form.btnDownload")>
                                        #LSNumberFormat(MontoL_SIMP, "_________.___")# 
                                    <cfelse>
                                        #LSNumberFormat(MontoL_SIMP, ",.00")#
                                    </cfif>
                                </td>
                                <td width="7%" align="right">
                                    <cfif isdefined("Form.btnDownload")>
                                        #LSNumberFormat(IMPL, "_________.___")# 
                                    <cfelse>
                                        #LSNumberFormat(IMPL, ",.00")#
                                    </cfif>
                                </td>
                                <td width="7%" align="right">
                                    <cfif isdefined("Form.btnDownload")>
                                        #LSNumberFormat(MontoLocal, "_________.___")# 
                                    <cfelse>
                                        #LSNumberFormat(MontoLocal, ",.00")#
                                    </cfif>
                                </td>
                                <td width="7%" align="right">
                                    <cfif isdefined("Form.btnDownload")>
                                        #LSNumberFormat(MontoO_SIMP, "_________.___")# 
                                    <cfelse>
                                        #LSNumberFormat(MontoO_SIMP, ",.00")#
                                    </cfif>
                                </td>
                                <td width="7%" align="right">
                                    <cfif isdefined("Form.btnDownload")>
                                        #LSNumberFormat(IMPO, "_________.___")# 
                                    <cfelse>
                                        #LSNumberFormat(IMPO, ",.00")#
                                    </cfif>
                                </td>
                                <td width="7%" align="right">
                                    <cfif isdefined("Form.btnDownload")>
                                        #LSNumberFormat(MontoOrigen, "_________.___")# 
                                    <cfelse>
                                        #LSNumberFormat(MontoOrigen, ",.00")#
                                    </cfif>
                                </td>
                                <cfif contadorPagos GT 0>                                
                                    <cfloop query="rsPago">
                                        <cfif contadorTemp GT 1>
                                            <tr style="font-family:Arial, Helvetica, sans-serif; font-size:11px">
                                                <td colspan="10" ></td>                                  	
                                        </cfif>
                                        <td width="5%" align="center">  
                                            #NumSol#
                                        </td>
                                        <td width="5%" align="center">  
                                            #NumOP#
                                        </td>
                                        <td width="10%" align="center">  
                                            #DocPago#
                                        </td>
                                        <td width="5%" align="center">  
                                            #BancoPago#
                                        </td>
                                        <td width="5%" align="center">  
                                            #CtaPago#
                                        </td>
                                        <td width="5%" align="center">  
                                            #BancoSocio#
                                        </td>
                                        <td width="5%" align="center">  
                                            #CtaSocio#
                                        </td>
                                        <cfset contadorTemp = contadorTemp + 1>
                                    </cfloop>
                               	<cfelse>
										<td colspan="7"></td>                            	
                                </cfif>
                                <cfif NumLiq NEQ -1>
                                	<td >
                                		#NumLiq#
                                    </td>
                                    <cfif len(#Empleado#) GT 5 And not isdefined("Form.btnDownload")>
                                    	 <td width="20%" title="#Empleado#">
                                         	#left(Empleado, 5)#...
                                         </td>
                                   	<cfelse>
                                        <td width="20%">
                                            #Empleado#
                                        </td>                                    	
                                    </cfif>
                                   <cfif len(#DesLiq#) GT 10 And not isdefined("Form.btnDownload")>
                                    	 <td width="20%" title="#DesLiq#">
                                         	#left(DesLiq, 10)#...
                                         </td>
                                   	<cfelse>
                                        <td width="20%">
                                            #DesLiq#
                                        </td>                                    	
                                    </cfif>
                               	<cfelse>
                                	<td ></td>                                                                  
                                </tr></cfif>
                                
								
                        <cfset subTotal1 = subTotal1 + #MontoL_SIMP#>
                        <cfset subTotal2 = subTotal2 + #IMPL#>
                        <cfset subTotal3 = subTotal3 + #MontoLocal#>
                        
                        <cfset totalGeneral1 = totalGeneral1 + #MontoL_SIMP#>
                        <cfset totalGeneral2 = totalGeneral2 + #IMPL#>
                        <cfset totalGeneral3 = totalGeneral3 + #MontoLocal#>
                        
                        <cfset count = count + 1>				
                        </cfoutput>
                            <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
                                <td colspan="4"align="Left">
                                    <strong>Totales&nbsp;#Nombre#&nbsp;</strong>
                                </td>
                                <td width="10%" align="right" bgcolor="DDDDDD" style=" border-bottom:1px solid black;">
                                	<strong>
										<cfif isdefined("Form.btnDownload")>
                                            #LSNumberFormat(subTotal1, "_________.___")# 
                                        <cfelse>
                                            #LSNumberFormat(subTotal1, ",.00")#
                                        </cfif>
                                   	</strong>
                                </td>
                                <td width="10%" align="right" bgcolor="DDDDDD" style=" border-bottom:1px solid black;">
                                	<strong>
										<cfif isdefined("Form.btnDownload")>
                                            #LSNumberFormat(subTotal2, "_________.___")# 
                                        <cfelse>
                                            #LSNumberFormat(subTotal2, ",.00")#
                                        </cfif>
                                   	</strong>
                                </td>
                                <td width="10%" align="right" bgcolor="DDDDDD" style=" border-bottom:1px solid black;">
                                	<strong>
										<cfif isdefined("Form.btnDownload")>
                                            #LSNumberFormat(subTotal3, "_________.___")# 
                                        <cfelse>
                                            #LSNumberFormat(subTotal3, ",.00")#
                                        </cfif>
                                   	</strong>
                                </td>
                                <td colspan="13" bgcolor="DDDDDD"></td>                                                                                                                                                                                                
                            </td>                       
                   	</cfoutput>
                </cfoutput>
                <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
                    <td colspan="4"align="Left">
                        <strong>Total General:&nbsp;</strong>
                    </td>
                    <td width="10%" align="right" style=" border-bottom:1px solid black;">
                 	<cfoutput>
                    	<strong>
							<cfif isdefined("Form.btnDownload")>
                                #LSNumberFormat(totalGeneral1, "_________.___")# 
                            <cfelse>
                                #LSNumberFormat(totalGeneral1, ",.00")#
                            </cfif>
                        </strong>
                  	</cfoutput>
                    </td>
                    <td width="10%" align="right" style=" border-bottom:1px solid black;">
                 	<cfoutput>
                    	<strong>
							<cfif isdefined("Form.btnDownload")>
                                #LSNumberFormat(totalGeneral2, "_________.___")# 
                            <cfelse>
                                #LSNumberFormat(totalGeneral2, ",.00")#
                            </cfif>
                        </strong>
                  	</cfoutput>
                    </td>
                    <td width="10%" align="right" style=" border-bottom:1px solid black;">
                 	<cfoutput>
                    	<strong>
							<cfif isdefined("Form.btnDownload")>
                                #LSNumberFormat(totalGeneral3, "_________.___")# 
                            <cfelse>
                                #LSNumberFormat(totalGeneral3, ",.00")#
                            </cfif>
                        </strong>
                  	</cfoutput>
                    </td>
                </tr>
                <tr>
                	<td colspan="4"align="right"></td>
                    <td colspan="3" width="10%" align="Left" style=" border-top:1px solid black;"></td>                                                                                               
                </tr>                
<!---            </table>--->
<!---        </td>
    </tr>--->
    <tr>
        <td align="left" nowrap="nowrap" colspan="20"></td>
    </tr>
    <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px"><td align="center" nowrap="nowrap" colspan="20"><p>&nbsp;</p>
    <p><cfoutput>Cantidad de Registros:&nbsp;#rsReporte.RecordCount#</cfoutput></p>
    <p>***Fin de Linea***</p></td></tr>
    </cfif>
</table>
<cfif rsReporte.RecordCount EQ 0>
    <p align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:12px">No se encontraron registros</p>
</cfif>