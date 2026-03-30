<!---<cf_dump var="#form#">--->
<cf_htmlReportsHeaders 
	irA="D-151.cfm"
	FileName="ReporteD-151.xls"
	title="Reporte D-151">
   
<cf_dbfunction name="date_part"	args="yyyy, ECP.Dfecha"  returnvariable="LvarAno1" >
<cf_dbfunction name="date_part"	args="mm, ECP.Dfecha"  returnvariable="LvarMes1" >
<cf_dbfunction name="date_part"	args="yyyy, SP.TESSPfechaSolicitud"  returnvariable="LvarAno2" >
<cf_dbfunction name="date_part"	args="mm, SP.TESSPfechaSolicitud"  returnvariable="LvarMes2" >
<cf_dbfunction name="date_part"	args="yyyy, GE.GELfecha"  returnvariable="LvarAno3" >
<cf_dbfunction name="date_part"	args="mm, GE.GELfecha"  returnvariable="LvarMes3" >

<cfquery name="rsReporte" datasource="#session.dsn#">
    Select Distinct Nombre, Identificacion, Sum(Monto) As Monto, Clasificacion
    From
    (  
   	<cfif isdefined('form.TipoProveedor') And (form.TipoProveedor EQ 'SN' Or form.TipoProveedor EQ 'T')>
	<!---1: Cuentas por Pagar:--------------------------------------------------------------------------------------------------------->
    Select
        Distinct
        ECP.Ddocumento As NumDOC,
        DCP.CPTcodigo As TipoDOC,         
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
        ) As Monto,
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
                ) As Clasificacion
    From 
        HDDocumentosCP DCP 
        Inner Join HEDocumentosCP ECP On
            ECP.IDdocumento = DCP.IDdocumento And
            ECP.Ecodigo = #session.Ecodigo#
        Inner Join Impuestos I On
            I.Icodigo = DCP.Icodigo And
            I.Ecodigo = #session.Ecodigo#
        Inner Join SNegocios SN On 
            SN.SNcodigo = DCP.SNcodigo And
            SN.Ecodigo = #session.Ecodigo#
    Where 
        DCP.Ecodigo = #session.Ecodigo# 
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
        
    Union All
      	</cfif>
        
	<!---2: Solicitudes de pago Manual:------------------------------------------------------------------------------------------------>
    Select
        Distinct
        Convert(Varchar, SP.TESSPnumero) As NumDOC,
        'SP_Manual' As TipoDOC,        
        Coalesce(SN.SNnombrePago, SN.SNnombre, B.TESBeneficiario) As Nombre,
        Coalesce(SN.SNidentificacion, B.TESBeneficiarioId) As Identificacion,
        (DP.TESDPmontoPagoLocal - (Coalesce(TESDPimpNCFOri, 0) * DP.TESDPfactorConversion)) As Monto,
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
                ) As Clasificacion
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
    
    Union All
        
	<!---3: Liquidaciones de Gastos a Empleados:--------------------------------------------------------------------------------------->
    Select
        Distinct
        Convert(Varchar, GE.GELnumero) As NumDOC,
        'Liq_Empleados' As TipoDOC,        
        Coalesce(SN.SNnombre, B.TESBeneficiario)  As Nombre,
        Coalesce(SN.SNidentificacion, B.TESBeneficiarioId) As Identificacion,
        ((GELGtotalOri - GELGimpNCFOri) * GELGtipoCambio ) As Monto,
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
                ) As Clasificacion       
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
    Where
        GE.GELestado in (4, 5) <!---4: Finalizada, 5: Por Entregar--->
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
                          
    ) Tabla
    Group By
        Nombre
    Order By
        Nombre 
</cfquery>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	Select 
        Edescripcion,
        Ecodigo
	From Empresas
	Where Ecodigo=#session.Ecodigo#
</cfquery>

<cfif isdefined("form.btnDownload")>
	<cfset oldlocale = SetLocale("French (Canadian)")>
</cfif>

<table align="center" width="100%" border="0" summary="Reporte" cellpadding="0" cellspacing="0">
	<cfoutput>
        <tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px"> 
            <td align="left" bgcolor="BCBCBC" colspan="3"><strong>#rsEmpresa.Edescripcion#</strong></td>
            <td align="right" bgcolor="BCBCBC" colspan="1"><strong>Fecha:&nbsp;#DateFormat(Now(), "mmm d, yyyy")#</strong></td>
        </tr> 
        <tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px">
            <td align="left" bgcolor="BCBCBC" colspan="3"><strong>Sistema de Cuentas por Pagar</strong></td>
            <td align="right" bgcolor="BCBCBC" colspan="1"><strong>Hora:&nbsp;#TimeFormat(Now(), "h:mm TT")#</strong></td>
        </tr>
        <tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px">
            <td align="left" bgcolor="BCBCBC" colspan="4"><strong>Reporte D-151 Resumido</strong></td>
        </tr>
        <tr><td>&nbsp;</td></tr>
   	</cfoutput>
    <cfif rsReporte.RecordCount GT 0>
    <tr>
        <td width="100%" colspan="4" align="center">
            <table width="98%" border="0" cellpadding="0" cellspacing="0"  align="center">
                <tr style="font-family:Arial, Helvetica, sans-serif; font-size:13x">
                    <td  width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center">
                        <strong>Clasificacion</strong>
                    </td>
                    <td  width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center">
                        <strong>Identificacion</strong>
                    </td>   
                    <td  width="30%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center">
                        <strong>Proveedor</strong>
                    </td>
                    <td width="10%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black; border-right:1px solid black;" align="center">
                        <strong>Monto (Sin Impuesto)</strong>
                    </td>                                                           
                </tr>
                <cfset count = 1>
                <cfoutput>
                    <cfloop query="rsReporte">
                        <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
                            <td width="6%" style=" border-bottom:1px solid black;" align="Left">
                                #Clasificacion#
                            </td>
                            <td width="6%" style=" border-bottom:1px solid black;" align="center">
                                #Identificacion#
                            </td>
                            <td width="6%" style=" border-bottom:1px solid black;" align="Left">
                                #Nombre#
                            </td>
                            <td width="6%" style=" border-bottom:1px solid black;" align="Left">
                                <cfif isdefined("Form.btnDownload")>
                                    #LSNumberFormat(Monto, "_________.___")#
                                <cfelse>
                                    #LSNumberFormat(Monto, ",.00")#
                                </cfif>
                            </td>
                        </tr>
                        <cfset count = count + 1>				
                    </cfloop>
              	</cfoutput>
            </table>
        </td>
    </tr>
    <tr>
        <td align="left" nowrap="nowrap" colspan="2"></td>
    </tr>
    <tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px"><td align="center" nowrap="nowrap" colspan="12"><p>&nbsp;</p>
    <cfoutput><p>Cantidad de Registros:&nbsp;#rsReporte.RecordCount#</p></cfoutput>
    <p>***Fin de Linea***</p></td></tr>
    </cfif>
</table>
<cfif rsReporte.RecordCount EQ 0>
    <p align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:14px">No se encontraron registros</p>
</cfif>