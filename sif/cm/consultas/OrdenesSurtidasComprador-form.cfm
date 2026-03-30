<!---
		Opcion de impresión con corte y encabezado, 
		eliminada por cuestión de uso de espacio en las hojas 
		Se implementa el uso del report header para probar la
		exportación a excel sin mayor cambio a nivel funcional
--->
<cfset comp1  = "">
<cfset comp2  = "">

<cfset Param  = "">
<cfset contador = 0>
<cfset contDetalle = 10>  
<cfset maxRows = 75>

<cfif isdefined('url.CMCid1') and len(trim(#url.CMCid1#))>
     <cfset form.CMCid1 = url.CMCid1>
</cfif>
<cfif isdefined('url.CMCid2') and len(trim(#url.CMCid2#))>
    <cfset form.CMCid2 = url.CMCid2>
</cfif>
<cfif isdefined('url.Rango') and len(trim(#url.Rango#))>
    <cfset form.Rango = url.Rango>
</cfif>

<cfif isdefined('url.Tipo') and len(trim(#url.Tipo#))>
    <cfset form.Tipo = url.Tipo>
</cfif>

<cfif isdefined('url.TipoOrden') and len(trim(#url.TipoOrden#))>
    <cfset form.TipoOrden = url.TipoOrden>
</cfif>

<cfif isdefined("url.fechaDes")>
	 <cfset form.fechaDes = url.fechaDes>
</cfif>

<cfif isdefined("url.fechaHas")>
	<cfset form.fechaHas = url.fechaHas>
</cfif>

<cfif isdefined("url.Periodo")>
	<cfset form.Periodo = url.Periodo>
</cfif>

<cfif isdefined("url.Mes")>
	<cfset form.Mes = url.Mes>
</cfif>

<cfif isdefined("url.showDates")>
	<cfset form.showDates = url.showDates>
</cfif>

<cfif isdefined("form.showDates")>
	<cfset Param = Param & "&showDates="&#form.showDates#>
</cfif>

<cfif isdefined("form.Periodo")>
	<cfset Param = Param & "&Periodo="&#form.Periodo#>
</cfif>

<cfif isdefined("form.Mes")>
	<cfset Param = Param & "&Mes="&#form.Mes#>
</cfif>

<cfif isdefined('form.Tipo') and len(trim(#form.Tipo#))>
	 <cfset Param = Param & "&Tipo="&#form.Tipo#>
</cfif>

<cfif isdefined('form.TipoOrden') and len(trim(#form.TipoOrden#))>
    <cfset Param = Param & "&TipoOrden="&#form.TipoOrden#>
</cfif>

<cfif isdefined('form.CMCid1') and len(trim(#form.CMCid1#))>
   <cfset comp1 = form.CMCid1>
   <cfset Param = Param & "&CMCid1="&#form.CMCid1#> 
</cfif>
<cfif isdefined('form.CMCid2') and len(#form.CMCid2#)>
   <cfset comp2  = form.CMCid2>  
   <cfset Param = Param & "&CMCid2="&#form.CMCid2#>
</cfif>

<cfif isdefined("form.Rango") and form.Rango EQ 'PeriodoMes'>
	<cfset FechaInicio = createdate(form.Periodo,form.mes,1)>
    <cfset FechaFin = createdate(form.Periodo,form.mes,1)>
    <cfset FechaFin = DateAdd("m",1,FechaFin)>
	<cfset FechaFin = DateAdd("d",-1,FechaFin)>
	<cfset FechaFin = DateAdd("h",23,FechaFin)>
	<cfset FechaFin = DateAdd("n",59,FechaFin)>
	<cfset FechaFin = DateAdd("s",59,FechaFin)>
</cfif>

<cfif isdefined("form.Rango") and len(trim(#form.Rango#))>
	<cfset Param = Param & "&Rango="&#form.Rango#>
</cfif> 

<cfif isdefined("form.fechaDes")>
	<cfset Param = Param & "&fechaDes="&#form.fechaDes#>
</cfif>

<cfif isdefined("form.fechaHas")>
	<cfset Param = Param & "&fechaHas="&#form.fechaHas#>
</cfif>
 
<!--- Empresas --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif len(trim(#comp1#)) gt 0 and  len(trim(#comp2#)) gt 0> 
   <cfquery name="rsRango1" datasource="#session.dsn#">
	 select CMCnombre as CMC1 from CMCompradores  where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#comp1#">
   </cfquery>
	<cfquery name="rsRango2" datasource="#session.dsn#">
	 select CMCnombre as CMC2 from CMCompradores  where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#comp2#">
   </cfquery>
  <cfelseif len(trim(#comp1#)) gt 0 >  
	   <cfquery name="rsRango1" datasource="#session.dsn#">
		 select CMCnombre as CMC1 from CMCompradores  where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#comp1#">
	   </cfquery>
 <cfelseif len(trim(#comp2#)) gt 0>  
	<cfquery name="rsRango2" datasource="#session.dsn#">
	   select CMCnombre as CMC2 from CMCompradores  where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#comp2#">
	</cfquery>
 </cfif>

<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cf_dbdatabase name ="database" table="ETrackingItems" datasource="sifpublica" returnvariable="EtrackingitemsTable">
<cf_dbdatabase name ="database" table="ETracking" datasource="sifpublica" returnvariable="EtrackingTable">
<cf_dbdatabase name ="database" table="DTracking" datasource="sifpublica" returnvariable="DtrackingTable">
<cf_dbdatabase name ="database" table="CMActividadTracking" datasource="sifpublica" returnvariable="ActividadTrackingTable">    

<!--- 
	Filtro para determinar la fecha de ingreso real de las lineas de la OC al inventario 
	dependiendo de la procedencia
	Caso Local: fecha de recepcion de la Factura
	Caso Exterior: fecha asociada al ETA_R 
	--->
<cfset LvarFiltroFecha ="AND  CASE eto.CMTOimportacion WHEN 0 THEN COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)
										 												WHEN 1 THEN dt.DTfechaactividad
									END">    
<cfquery name="rsDatos" datasource="#session.dsn#">
   SELECT DISTINCT 
                cmc.CMCid,
                cmc.CMCcodigo#_Cat#'-'+#_Cat#cmc.CMCnombre AS Comprador,
                es.ESnumero,
                do.DOlinea,
                eo.EOnumero,
                CASE eto.CMTOimportacion 
                    WHEN 1 THEN 'INTERNACIONAL' 
                    WHEN 0 THEN 'LOCAL' 
                    ELSE  '	' 
                END AS LugarEmision,
                eto.CMTOimportacion,
                eo.EOFechaAplica,eo.EOfecha, es.ESfechaAplica,ec.ECfechacot,
               <cf_dbfunction name="datediff" args="es.ESfechaAplica,eo.EOFechaAplica"> as EO_SC,
                <cf_dbfunction name="datediff" args="pc.CMPfechaEnvAprob, pc.CMPfechaAprob"> as CA_EA,
                <cf_dbfunction name="datediff" args="eo.EOfecha, eo.EOFechaAplica"> as EO_OC,
                <cf_dbfunction name="datediff" delimiters="|" args="es.ESfechaAplica  | COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)"> as IBR_SC,                  
                <cf_dbfunction name="datediff"  delimiters="|" args="do.DOfechaes | COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)"> as IBR_IBP, 
                <cf_dbfunction name="datediff" args="es.ESfechaAplica,dt.DTfechaactividad">as IBRI_SC,
                <cf_dbfunction name="datediff" args="do.DOfechaes,dt.DTfechaactividad">  as IBRI_IBP,
                eto.CMTOdescripcion,
                rtrim(eto.CMTOcodigo) as CMTOcodigo,
                ec.ECnumero as Cotizacion

    		
    FROM EOrdenCM AS eo 
       INNER JOIN DOrdenCM do 
            ON eo.EOidorden = do.EOidorden 
       
       INNER JOIN CMTipoOrden eto 
            ON eto.CMTOcodigo = eo.CMTOcodigo 
            AND eto.Ecodigo =  eo.Ecodigo
       
       INNER JOIN CFuncional cf 
            ON cf.CFid = do.CFid 
            AND cf.Ecodigo = do.Ecodigo 
            
		INNER JOIN Monedas m 
            ON m.Mcodigo = eo.Mcodigo 
           AND m.Ecodigo = eo.Ecodigo
       
       LEFT JOIN SNegocios sn 
            ON sn.SNcodigo = eo.SNcodigo 
            AND sn.Ecodigo = eo.Ecodigo
                  
       LEFT JOIN CMCompradores cmc 
            ON cmc.CMCid = eo.CMCid 
                     
       LEFT JOIN DSolicitudCompraCM ds 
            ON ds.DSlinea = do.DSlinea 
       
       LEFT JOIN ESolicitudCompraCM es 
            ON es.ESidsolicitud = ds.ESidsolicitud 
       
       LEFT JOIN CMLineasProceso lp 
            ON ds.DSlinea = lp.DSlinea
       
       LEFT JOIN CMProcesoCompra pc 
            ON pc.CMPid = lp.CMPid 
      
       LEFT JOIN DCotizacionesCM dc 
            ON dc.CMPid = pc.CMPid 
            AND dc.DClinea = do.DClinea 
      
      LEFT JOIN ECotizacionesCM ec 
            ON ec.ECid = dc.ECid
            AND ec.SNcodigo = eo.SNcodigo 
      
      LEFT JOIN DDocumentosCxP dcxp 
            ON dcxp.DOlinea = do.DOlinea 
      
      LEFT JOIN EDocumentosCxP ecxp 
            ON ecxp.IDdocumento = dcxp.IDdocumento 
      
      LEFT OUTER JOIN DDocumentosCP dcp 
            ON dcp.DOlinea = do.DOlinea 
      
      LEFT OUTER JOIN EDocumentosCP ecp 
            ON ecp.IDdocumento = dcp.IDdocumento 
      
      LEFT OUTER JOIN HDDocumentosCP hdcp 
            ON hdcp.DOlinea = do.DOlinea 
      
      LEFT OUTER JOIN HEDocumentosCP hecp 
            ON hecp.IDdocumento = hdcp.IDdocumento 
      
      LEFT OUTER JOIN #EtrackingitemsTable# eti 
            ON eti.Ecodigo = do.Ecodigo 
            AND eti.DOlinea = do.DOlinea
      
      LEFT OUTER JOIN #EtrackingTable# et 
           ON et.ETidtracking = eti.ETidtracking
           AND et.Ecodigo =eti.Ecodigo 
       
       LEFT OUTER JOIN #DtrackingTable# dt 
             INNER JOIN #ActividadTrackingTable# atk 
              ON atk.CMATid = dt.CMATid 
              AND atk.Ecodigo = dt.Ecodigo 
              AND atk.ETA_R = 1  
         ON dt.ETidtracking = et.ETidtracking 
         AND dt.Ecodigo = et.Ecodigo 

    WHERE 
					<cfif isdefined('form.EcodigoE') and form.EcodigoE eq -2>
        				eo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                     <cfelse>
                     	eo.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoE#" list="yes">)
                     </cfif>
	
		AND DOcantidad >= DOcantsurtida
        AND DOcantsurtida <> 0
        AND eo.EOestado in (10,55)
        
    <cfif #Form.Tipo# neq "T">
		<cfif 	#Form.Tipo# eq "L">
            AND eto.CMTOimportacion = 0
        </cfif>
        <cfif 	#Form.Tipo# eq "I">
            AND eto.CMTOimportacion = 1
        </cfif>
    </cfif>
     <cfif #Form.TipoOrden# neq "T">
			AND eto.CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rtrim(ltrim(Form.TipoOrden))#">
     </cfif>
    <cfif len(trim(#comp1#)) gt 0 and  len(trim(#comp2#)) gt 0> 
            <cfif #comp1# lt #comp2#>
             and eo.CMCid  between #comp1#  and #comp2#
            <cfelse>
             and eo.CMCid  between #comp2#  and #comp1#
            </cfif> 
         <cfelseif len(trim(#comp1#)) gt 0 >  
             and eo.CMCid =  #comp1#
         <cfelseif len(trim(#comp2#)) gt 0>  
             and eo.CMCid = #comp2#    
         </cfif> 
         <!--- Filtro por fecha de la OC --->
        <cfif isdefined("form.Rango") and form.Rango EQ 'PeriodoMes'>
        	#LvarFiltroFecha#
            between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaInicio#">
            and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaFin#">
		<cfelseif isdefined("form.Rango") and form.Rango EQ 'fecha'>
            <!--- Fechas Desde / Hasta --->
            <cfif isdefined("form.fechaDes") and len(trim(form.fechaDes)) and isdefined("form.fechaHas") and len(trim(form.fechaHas))>
                <cfif datecompare(form.fechaDes, form.fechaHas) eq -1> 
                    <cfset LvarFecha1 =  lsparsedatetime(form.fechaDes)>
                    <cfset LvarFecha2 =  lsparsedatetime(form.fechaHas)>
                <cfelseif datecompare(form.fechaDes, form.fechaHas) eq 1>
                    <cfset LvarFecha1 =  lsparsedatetime(form.fechaHas)>
                    <cfset LvarFecha2 =  lsparsedatetime(form.fechaDes)>
                <cfelseif datecompare(form.fechaDes, form.fechaHas) eq 0>
                    <cfset LvarFecha1 =  lsparsedatetime(form.fechaDes)>
                    <cfset LvarFecha2 =  LvarFecha1>
            </cfif>
            <cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
                #LvarFiltroFecha#
                between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha1#">
                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
			<cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
                #LvarFiltroFecha# >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.fechaDes)#">
			<cfelseif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
                <cfset LvarFecha2 =  lsparsedatetime(form.fechaHas)>
                <cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
                #LvarFiltroFecha# <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
            </cfif>
        </cfif>
    
    ORDER BY Comprador,LugarEmision, CMTOcodigo, eo.EOfecha, eo.EOnumero, Cotizacion
</cfquery>

<cfset LvarTipo = "">
<cfif 'form.TipoReporte' eq 0>
	<cfset LvarTipo = "EstadisticasXComprador_Resumido">
<cfelse>
	<cfset LvarTipo = "EstadisticasXComprador_Detallado">
</cfif>

<cf_templatecss>
<style type="text/css">
.titulo {
		font-family:Times New Roman, Times, serif; 
		font-size:17pt; 
		font-variant:small-caps; 
		font-weight:bolder; 
		padding-left:7px;	
		font-weight:bold;
	}
</style>
         <table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
          <tr> 
            <td alig="left">
                <cf_htmlReportsHeaders 
                    irA="OrdenesSurtidasComprador.cfm"
                    FileName="#LvarTipo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls"
                    title="Reporte Estadisticas Comprador Resumido"
                    print="true">	
             </td>
             <!--- <td width="7%">       
                <cf_rhimprime datos="/sif/cm/consultas/OrdenesSurtidasComprador-form.cfm" paramsuri="#Param#">
            </td>   --->
          </tr>
        </table>    
    <table width="100%" border="0" cellpadding="1" cellspacing="1" >
   <tr> 
      <td  align="center" class="titulo"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td align="center" colspan="11"><b>Reporte de &Oacute;rdenes de Compra Surtidas y Canceladas</b></td>
    </tr>
        <tr> 
           <td colspan="11" align="center">
				<cfif len(trim(#comp1#)) gt 0 and  len(trim(#comp2#)) gt 0 and #comp1# neq #comp2#> 
                    <strong>Comprador, desde:</strong> <cfoutput>#rsRango1.CMC1#</cfoutput><strong>, hasta:</strong>  <cfoutput>#rsRango2.CMC2#</cfoutput>
               <cfelseif len(trim(#comp1#)) gt 0 and  len(trim(#comp2#)) gt 0 and #comp1# eq #comp2#> 
                    <strong>Comprador:</strong> <cfoutput>#rsRango1.CMC1#</cfoutput>
               <cfelseif len(trim(#comp1#)) gt 0  and len(trim(#comp2#)) eq 0 >  
                    <strong>Comprador:</strong> <cfoutput>#rsRango1.CMC1#</cfoutput>
                <cfelseif len(trim(#comp1#)) eq 0 and len(trim(#comp2#)) gt 0 >  
                    <strong>Comprador:</strong> <cfoutput>#rsRango2.CMC2#</cfoutput>
               </cfif>               
            </td>
        </tr>
     <cfoutput> 
			<cfif isdefined('form.Rango') and form.Rango EQ 'PeriodoMes'>
                <tr><td  align="center" colspan="11"><strong>Ordenes de Compra</strong><font size="3">&nbsp;Del Periodo: #form.Periodo# Mes: #form.Mes#</font></td>
			<cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes)) and isdefined("form.fechaHas") and len(trim(form.fechaHas))>
                  <tr><td align="center" colspan="11"><strong>Ordenes de Compra</strong><font size="3">&nbsp;Fecha desde: #LSDateFormat(form.fechaDes,'dd/mm/yyyy')# hasta: #LSDateFormat(form.fechaHas,'dd/mm/yyyy')#</font></td>
	        <cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
                  <tr><td align="center" colspan="11"><strong>Ordenes de Compra</strong><font size="3">&nbsp;Fecha: #LSDateFormat(form.fechaDes,'dd/mm/yyyy')#</font></td>                  
            <cfelseif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
                  <tr><td align="center" colspan="11"><strong>Ordenes de Compra</strong><font size="3">&nbsp;Fecha: #LSDateFormat(form.fechaHas,'dd/mm/yyyy')#</font></td>                        
            </cfif>
		</cfoutput>   
    <cfif isdefined('form.Tipo') and #form.Tipo# neq 'T'>
        <tr>
            <td  colspan="11" align="center" style="padding-right: 20px"><b>Tipo Orden:</b>
				<cfif  #form.Tipo# eq 'L'>Local<cfelseif #form.Tipo# eq 'I'>Internacional</cfif>
			</td>
        </tr>
    </cfif>
    <cfif not  isdefined("form.toExcel") and not isdefined("Url.imprimir")>
        <tr>
            <td colspan="">
                <table width="70%" class="ayuda" align="center" border="0">
                    <tr>
                        <td align="center"  colspan="10">
                            <p align="justify">
                                Definici&oacute;n de las abreviaciones utilizadas: 
                                                <strong>EA:&nbsp;</strong>&nbsp;Fecha de Env&iacute;o de la cotizaci&oacute;n para aprobación al solicitante,&nbsp;
                                                <strong>SC</strong>:&nbsp;Fecha de Aplicaci&oacute;n de la Solicitud de Compra, 
                                                <strong>CA:</strong> &nbsp;Fecha de Aprobaci&oacute;n de la Cotizaci&oacute;n, &nbsp;
                                                <strong>OC:</strong> &nbsp;Fecha de Emisi&oacute;n de la OC,&nbsp;
                                                <strong>EO:</strong> &nbsp;Fecha de Aplicación Final de la OC, &nbsp;
                                                <strong>IBP:</strong> &nbsp;Fecha Estimada de la Orden de Compra, 
                                                <strong>IBRI:</strong>&nbsp;ETA Real Internacional,&nbsp;
                                                <strong>IBR:</strong>&nbsp;Fecha de Ingreso a Bodega,&nbsp;
                                                <strong>EO-SC:</strong>&nbsp;Gesti&oacute;n Compras,&nbsp;
                                                <strong>CA-EA:</strong>&nbsp;Tiempo de Aprobaci&oacute;n de la Cotizaci&oacute;n,&nbsp;
                                                <strong>EO-OC:</strong>&nbsp;Tiempo de Autorizaci&oacute;n de las OC,&nbsp;
                                                <strong>A-B-C:</strong>&nbsp;Gestión Comprador,&nbsp;
                                                <strong>IBR-CS:</strong>&nbsp;Gestión Total Local,&nbsp;
                                                <strong>IBRI-CS:</strong>&nbsp;Gestion Total Internacional,&nbsp;
                                                <strong>IBR-IBP:</strong>&nbsp;Puntualidad Local	,&nbsp;
                                                <strong>IBRI-IBP:</strong>&nbsp;Puntualidad Internacional
                            </p>
                        </td>	
                    </tr>
                </table>	
            </td>
        </tr>
    </cfif>
    <tr> 
	    <td class="bottomline" colspan="10">&nbsp;</td>
    </tr>
	 <cfset imprimeEncabezado()>
     <cffunction name="imprimeEncabezado" output="yes">
         <table width="100%" border="0" cellpadding="1" cellspacing="1" >
            <tr>
				<!--- Ordenes --->
                <td  width="7%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Ordenes</strong></td>
                <!---  Cotizaciones--->
                <td width="8%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Cotizaciones</strong></td>
                <!---  EO-SM--->
                <td width="7%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>EO-SC</strong></td>
                <!---  CA-EA--->
                <td width="7%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>CA-EA</strong></td>
                <!---  EO-OC--->
                <td width="7%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>EO-OC</strong></td>
                <!---  A - B - C--->
                <td width="7%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>A - B - C</strong></td>
                <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
					<!--- IBR- SC --->
					<td width="7%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>IBR-SC</strong></td>
				</cfif>
                <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
					<!--- IBRI - SM --->
                	<td width="7%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>IBRI - SC</strong> </td>
                </cfif>
                <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
					<!--- IBR - IBP --->
                	<td width="7%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>IBR - IBP </strong></td>
                 </cfif>
                 <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
					 <!--- IBRI - IBP --->
                    <td width="7%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black; border-right:1px solid black;" align="center"><strong>IBRI - IBP </strong></td>
               	</cfif>
     </tr>
</cffunction>
    <cfif rsDatos.recordcount gt 0>
    	<!--- Totales Generales--->
		<cfset LvarTotal_EO_SC_G 		= 0>  <cfset LvarTotal_CA_EA_G 		= 0> 
        <cfset LvarTotal_EO_OC_G 	= 0>	<cfset LvarTotal_A_B_C_G 		= 0>
        <cfset LvarTotal_SC_IBR_G 	= 0> 	<cfset LvarTotal_IBR_IBP_G 	= 0>
        <cfset LvarTotal_IBRI_IBP_G 	= 0> 	<cfset LvarTotal_SC_IBRI_G 	= 0>
        <cfset LvarOrdenesT = 0>				<cfset LvarCotizacionTotal 		=0>
        <cfoutput query="rsDatos" group="Comprador">
        <tr><td colspan="11" class="tituloAlterno">#Comprador#</td></tr>
            <cfset EO_OC = "">
            <cfset EO_SC = "">
            <cfset CA_EA = "">
            <cfoutput group="LugarEmision">   
                  <tr><td colspan="11" style="border:1px solid lightgray;" align="center"><strong>#LugarEmision#</strong></td></tr>
                 <cfset contDetalle = contDetalle+4> 
                 <cfset A=0>
                 <cfset B=0>
                 <cfset C=0>
				 <cfoutput group="CMTOdescripcion">  
                 <cfset LineasDetC = LineasComprador(CMCid,CMTOcodigo)>
                     <cfif (isdefined("Url.imprimir") and contDetalle GTE maxRows)> 
                        </table>
                            <BR style="page-break-after:always;">
                        <cfset imprimeEncabezado()> 
                        <cfset contDetalle = 0> 
                    </cfif>  
                    <tr>
                        <td align="left" colspan="11" style="font-style:italic">
                            <b>&nbsp;&nbsp;&nbsp;#CMTOdescripcion#</b>
                        </td>
                    </tr>
                    <tr>    
                        <!--- Ordenes--->
                        <td align="center">
	                        <cfset OrdenesC = OrdenesComprador(CMCid,CMTOimportacion,CMTOcodigo)>
							<cfif OrdenesC neq "">#OrdenesC#<cfelse>-</cfif> 
								<cfif OrdenesC neq "">
                                	<cfset LvarOrdenesT = #LvarOrdenesT#+#OrdenesC#>
                            </cfif>
                        </td>
                        <!---  Cotizaciones--->
                        <td align="center">
							<cfset CotizC = CotizComprador(CMCid,CMTOimportacion,CMTOcodigo)>
                            <cfif CotizC neq "">#CotizC#<cfelse>-</cfif> 
                                <cfif CotizC neq "">
                                    <cfset LvarCotizacionTotal = #LvarCotizacionTotal#+#CotizC#>
                            </cfif>
                        </td>
                        <!---  EO-SC (A)--->
                        <td align="center">
                        <cfset EOSC = DatosComprador(CMCid,CMTOimportacion,CMTOcodigo).EO_SC>
						<cfif EOSC neq "">#LSNumberFormat(EOSC/LineasDetC,"____.__")#<cfelse>-</cfif> 
                            <cfif EOSC neq "">
                                <cfset LvarTotal_EO_SC_G = #LvarTotal_EO_SC_G#+#EOSC#>
                                <cfset A = #EOSC#>
                        </cfif>
                        </td>
                        <!---  CA-EA (B)--->
                        <td  align="center">
							<cfset CAEA = DatosComprador(CMCid,CMTOimportacion,CMTOcodigo).CA_EA>
                            <cfif CAEA  neq "">#LSNumberFormat(CAEA/LineasDetC,"____.__")#<cfelse>-</cfif> 
                                <cfif CAEA neq "">
                                    <cfset LvarTotal_CA_EA_G = #LvarTotal_CA_EA_G#+#CAEA #>
                                    <cfset B = #CAEA#>
                            </cfif>
                        </td>
                        <!---  EO-OC (C)--->
                        <td align="center">
                        	<cfset EOOC = DatosComprador(CMCid,CMTOimportacion,CMTOcodigo).EO_OC>
                            <cfif EOOC   neq "">#LSNumberFormat(EOOC/LineasDetC,"____.__")#<cfelse>-</cfif> 
                                <cfif EOOC  neq "">
                                    <cfset LvarTotal_EO_OC_G = #LvarTotal_EO_OC_G#+#EOOC#>
                                    <cfset C = #EOOC#>
                            </cfif>
                        </td>
                        <!---  A - B - C--->
                        <td align="center">
						  <cfset LvarABC  	= A-B-C>
                           #LSNumberFormat(LvarABC/LineasDetC,"__________.__")#    
                           <cfset LvarTotal_A_B_C_G = #LvarTotal_A_B_C_G#+#LvarABC#>
                        </td>
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <!--- IBR- SC --->
                            <td align="center">
								<cfset IBRSC = DatosComprador(CMCid,CMTOimportacion,CMTOcodigo).IBR_SC>
                                 <cfif IBRSC neq "">
                                    <cfif CMTOimportacion eq 0>
                                        #LSNumberFormat(IBRSC/LineasDetC,"__________.__")#
                                        <cfset LvarTotal_SC_IBR_G = #LvarTotal_SC_IBR_G#+#IBRSC#>
                                     <cfelse>-
                                     </cfif>   
                                  <cfelse>-   
                                  </cfif>  
                            </td>
                        </cfif>
                        
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
                            <!--- IBRI - SC --->
                            <td  align="center">
                            <cfset SCIBR = DatosComprador(CMCid,CMTOimportacion,CMTOcodigo).IBRI_SC>
                             <cfif SCIBR neq "">
                             	<cfif CMTOimportacion eq 1>
                                    #LSNumberFormat(SCIBR/LineasDetC,"__________.__")#
                                    <cfset LvarTotal_SC_IBRI_G = #LvarTotal_SC_IBRI_G#+#SCIBR#>
                                 <cfelse>-
                                 </cfif>
                              <cfelse>-       
                              </cfif>  
                            </td> 
                        </cfif>
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <!--- IBR - IBP --->
                            <td  align="center">
								<cfset IBRIBP = DatosComprador(CMCid,CMTOimportacion,CMTOcodigo).IBR_IBP>
                                 <cfif IBRIBP neq "">
                                    <cfif CMTOimportacion eq 0>
                                        #LSNumberFormat(IBRIBP/LineasDetC,"__________.__")#
                                        <cfset LvarTotal_IBR_IBP_G = #LvarTotal_IBR_IBP_G#+#IBRIBP#>
                                     <cfelse>-
                                     </cfif> 
                                  <cfelse>-      
                                  </cfif> 
                            </td>
                        </cfif>
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
                             <!--- IBRI - IBP --->
                            <td  align="center">
                                <cfset IBRIIBP = DatosComprador(CMCid,CMTOimportacion,CMTOcodigo).IBRI_IBP>
                                 <cfif IBRIIBP neq "">
                                    <cfif CMTOimportacion eq 1>
                                        #LSNumberFormat(IBRIIBP/LineasDetC,"__________.__")#
                                        <cfset LvarTotal_IBRI_IBP_G = #LvarTotal_IBRI_IBP_G#+#IBRIIBP#>
                                     <cfelse>-
                                     </cfif>
                                  <cfelse>-       
                                  </cfif> 
                            </td>
                        </cfif>
                    </tr>
                    <cfset contDetalle = contDetalle+2> 
                 </cfoutput> 
            </cfoutput> 
            		<tr>
                    	<td colspan="2">&nbsp;</td>
                    	<td  style="border-bottom:1px dotted black;" colspan="9">&nbsp;</td></tr>
            		<tr>
                    	<cfset LineasC = LineasComprador(CMCid)>
                    	<td colspan="2" align="left" class="topline"><strong>TOTALES GENERALES PROMEDIO&nbsp;&nbsp;&nbsp;</strong></td>
                        <td align="center" >#LSNumberFormat(LvarTotal_EO_SC_G/LineasC,"__________.__")#</td>
                        <td align="center" >#LSNumberFormat(LvarTotal_CA_EA_G/LineasC,"__________.__")#</td>
                        <td align="center" >#LSNumberFormat(LvarTotal_EO_OC_G/LineasC,"__________.__")#</td>
                        <td align="center" > <cfif LvarTotal_A_B_C_G neq "">#LSNumberFormat(LvarTotal_A_B_C_G/LineasC,"__________.__")#</cfif> </td>
                        
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                                <td align="center"> <cfif LvarTotal_SC_IBR_G neq "">#LSNumberFormat(LvarTotal_SC_IBR_G/LineasC,"__________.__")#</cfif> </td>
                            <cfelse><td align="center" >-</td>
                            </cfif>  
                        </cfif>
                        
						<cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 	
							<cfif CMTOimportacion eq 1>
                            	<td align="center">
                            		<cfif LvarTotal_SC_IBRI_G neq "">#LSNumberformat((LvarTotal_SC_IBRI_G/LineasC),"___.__")#</cfif> 
                            	</td>
                            	<cfelse>
                            		<td align="center" >-</td>
                            </cfif>
                        </cfif>
                                               
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                                <td align="center"> <cfif LvarTotal_IBR_IBP_G neq "">#LSNumberFormat(LvarTotal_IBR_IBP_G/LineasC,"__________.__")#</cfif> </td>
                            <cfelse>
                                <td align="center">-</td>
                            </cfif>
                        </cfif>
                        
						<cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 
							<cfif CMTOimportacion eq 1>
                                <td align="center" >
                                	<cfif LvarTotal_IBRI_IBP_G neq "">#LSNumberformat((LvarTotal_IBRI_IBP_G/LineasC),"___.__")#</cfif>
                                </td>
                                <cfelse>
                                	<td align="center">-</td>			
                            </cfif>
                        </cfif>           
                    </tr>
            		<tr>
                        <td colspan="11" align="left" class="topline"><strong>TOTALES GENERALES&nbsp;&nbsp;&nbsp;</strong></td>
                    </tr>
                    <tr>    
                        <td align="center">#LvarOrdenesT#</td>   
                        <td align="center" >#LvarCotizacionTotal#</td>
                        <td align="center" >#LSNumberFormat(LvarTotal_EO_SC_G,"__________.__")#</td>
                        <td align="center" >#LSNumberFormat(LvarTotal_CA_EA_G,"__________.__")#</td>
                        <td align="center" >#LSNumberFormat(LvarTotal_EO_OC_G,"__________.__")#</td>
                        <td align="center" > <cfif LvarTotal_A_B_C_G neq "">#LSNumberFormat(LvarTotal_A_B_C_G,"__________.__")#</cfif> </td>
                        
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                                <td align="center"> <cfif LvarTotal_SC_IBR_G neq "">#LSNumberFormat(LvarTotal_SC_IBR_G,"__________.__")#</cfif> </td>
                            <cfelse><td align="center" >-</td>
                            </cfif>  
                        </cfif>
						<cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 	
							<cfif CMTOimportacion eq 1>
                            <td align="center">
	                            <cfif LvarTotal_SC_IBRI_G neq "">#LSNumberformat((LvarTotal_SC_IBRI_G),"___.__")#</cfif> 
                            </td>
                            <cfelse>
                            <td align="center" >-</td>
    	                        </cfif>
                        </cfif>
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                                <td align="center"> <cfif LvarTotal_IBR_IBP_G neq "">#LSNumberFormat(LvarTotal_IBR_IBP_G,"__________.__")#</cfif> </td>
                            <cfelse>
                                <td align="center">-</td>
                            </cfif>
                        </cfif>
                        
						<cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 
                        <cfif CMTOimportacion eq 1>
                            <td align="center" >
                            	<cfif LvarTotal_IBRI_IBP_G neq "">#LSNumberformat((LvarTotal_IBRI_IBP_G),"___.__")#</cfif>
                            </td>
                        <cfelse>
                            	<td align="center">-</td>
                        </cfif>
                        </cfif>           
                    </tr>
        <!--- Limpieza de las variables --->
		<cfset LvarTotal_EO_SC_G 		= 0>  <cfset LvarTotal_CA_EA_G 		= 0> 
        <cfset LvarTotal_EO_OC_G 	= 0>	<cfset LvarTotal_A_B_C_G 		= 0>
        <cfset LvarTotal_SC_IBR_G 	= 0> 	<cfset LvarTotal_IBR_IBP_G 	= 0>
        <cfset LvarTotal_IBRI_IBP_G 	= 0> 	<cfset LvarTotal_SC_IBRI_G 	= 0>
        <cfset LvarOrdenesT = 0>				<cfset LvarCotizacionTotal 		=0>
        </cfoutput>
        
         <tr><td colspan="11" align="center">&nbsp;</td></tr>
                	<tr><td colspan="11" align="center">----------------- Fin del Reporte -----------------</td></tr>    
    <cfelse>
        <tr><td colspan="11" align="center">&nbsp;</td></tr>
        <tr><td colspan="11" align="center">----------------- No se encontrar&oacute;n Datos -----------------</td></tr>    
   </cfif>     
    </table>
<!--- 
		Funcion que obtiene los datos estadisticos de cada comprador
		-Cantidad de cotizaciones
		-EO-SC, -EO-OC , -CA_EA
--->
<cffunction name="OrdenesComprador" access="private" returntype="numeric">
	<cfargument name="CMCid" type="numeric" required="yes">
    <cfargument name="CMTOimportacion" type="numeric" required="yes">
    <cfargument name="CMTOcodigo" type="string" required="yes">
    <cfquery dbtype="query" name="rsOrdenes">
    	SELECT Distinct EOnumero 
        from rsDatos
        WHERE CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMCid#">
        	AND CMTOimportacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMTOimportacion#">
            AND CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Arguments.CMTOcodigo)#">
    </cfquery>
    <cfset LvarOrdenes = rsOrdenes.recordcount>
    <cfreturn LvarOrdenes>
</cffunction>

<cffunction name="DatosComprador" access="private" returntype="query">
	<cfargument name="CMCid" type="numeric" required="yes">
    <cfargument name="CMTOimportacion" type="numeric" required="yes">
    <cfargument name="CMTOcodigo" type="string" required="yes">
    <cfquery dbtype="query" name="rsOrdenes">
    	SELECT 
        	sum(EO_SC) as  EO_SC,
            sum(CA_EA) as  CA_EA,
            sum(EO_OC) as  EO_OC,
            sum(IBR_SC) as  IBR_SC,
            sum(IBR_IBP)as  IBR_IBP,
            sum(IBRI_SC) as  IBRI_SC,
            sum(IBRI_IBP) as  IBRI_IBP
        from rsDatos
        WHERE CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMCid#">
        	AND CMTOimportacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMTOimportacion#">
            AND CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Arguments.CMTOcodigo)#">
    </cfquery>   
    <cfreturn rsOrdenes>
</cffunction>

<cffunction name="LineasComprador" access="private" returntype="numeric">
	<cfargument name="CMCid" type="numeric" required="yes">
    <cfargument name="CMTOcodigo" type="string" required="false" default="notDefined">
     <cfquery dbtype="query" name="rsLineas">
    	SELECT 
        	DOlinea
        from rsDatos
        WHERE CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMCid#">
            <cfif Arguments.CMTOcodigo neq 'notDefined'>
        		AND CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Arguments.CMTOcodigo)#">
        	</cfif> 
    </cfquery>    
	<cfset LvarLineas = rsLineas.recordcount>
    <cfreturn LvarLineas>
</cffunction>

<cffunction name="CotizComprador" access="private" returntype="numeric">
	<cfargument name="CMCid" type="numeric" required="yes">
    <cfargument name="CMTOimportacion" type="numeric" required="yes">
    <cfargument name="CMTOcodigo" type="string" required="yes">  
    <cfquery dbtype="query" name="rsCot">
    	SELECT DISTINCT
        	Cotizacion
        from rsDatos
        WHERE CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMCid#">
        	AND CMTOimportacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMTOimportacion#">
            AND CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Arguments.CMTOcodigo)#">
            AND Cotizacion IS NOT null
    </cfquery>
	<cfset LvarLineas = rsCot.recordcount>
    <cfreturn LvarLineas>
</cffunction>
