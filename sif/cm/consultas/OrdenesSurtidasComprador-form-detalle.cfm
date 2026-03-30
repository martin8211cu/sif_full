<cfset comp1  = "">
<cfset comp2  = "">

<cfset Param  = "">
<cfset contador = 0>
<cfset contDetalle = 2>  

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

<cfif isdefined("form.showDates")>
	<cfset maxRows = 25>
<cfelse>    
	<cfset maxRows = 28>
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
<cf_dbfunction name="to_char" args="eo.EOnumero" returnvariable="EOnumero">
<cf_dbfunction name="to_char" args="eo.Ecodigo" returnvariable="Ecodigo">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return ventanaSecundaria('+ #PreserveSingleQuotes(EOnumero)# +','+ #PreserveSingleQuotes(Ecodigo)# +');''>'" returnvariable="OC" delimiters="+">
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
    			 #PreserveSingleQuotes(OC)# as ver,			
                 cmc.CMCid,
                RTRIM(cmc.CMCcodigo)#_Cat#'-'#_Cat#cmc.CMCnombre AS Comprador,
                sn.SNnombre  as Proveedor,
                es.ESnumero,		
                do.DOlinea,
                eo.EOnumero, 		
                eo.Ecodigo,
                do.DOconsecutivo as Linea,
                CASE eto.CMTOimportacion  WHEN 1 THEN 'INTERNACIONAL' 
                    										WHEN 0 THEN 'LOCAL' 
                    										ELSE  '	' 
                	END AS LugarEmision,
                eto.CMTOimportacion,	
                eo.EOFechaAplica,
                eo.EOfecha, 					
                es.ESfechaAplica,
                ec.ECfechacot,				
                cf.CFdescripcion,
                do.DOfechaes,				
                es.ESidsolicitud,
                es.ESestado,					
                eo.EOidorden,
                do.DOfechaes,
                <cf_dbfunction name="datediff" args="es.ESfechaAplica,eo.EOFechaAplica"> as EO_SC,
                <cf_dbfunction name="datediff" args="pc.CMPfechaEnvAprob, pc.CMPfechaAprob"> as CA_EA,
                <cf_dbfunction name="datediff" args="eo.EOfecha, eo.EOFechaAplica"> as EO_OC,
                <cf_dbfunction name="datediff" delimiters="|" args="es.ESfechaAplica  | COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)"> as IBR_SC,                  
                <cf_dbfunction name="datediff"  delimiters="|" args="do.DOfechaes | COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)"> as IBR_IBP, 
                <cf_dbfunction name="datediff" args="es.ESfechaAplica,dt.DTfechaactividad">as IBRI_SC,
                <cf_dbfunction name="datediff" args="do.DOfechaes,dt.DTfechaactividad">  as IBRI_IBP,
                eto.CMTOdescripcion,
                rtrim(eto.CMTOcodigo) as CMTOcodigo,
                coalesce(ec.ECnumero,null) as Cotizacion,
                CASE eto.CMTOimportacion WHEN 1 THEN dt.DTfechaactividad
                    									   WHEN 0 THEN COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)
                	END AS FechaReal, 
                pc.CMPfechaAprob as CA, 
                pc.CMPfechaEnvAprob as EA

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

    WHERE 	<cfif isdefined('form.EcodigoE') and form.EcodigoE eq -2>
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
    
    ORDER BY Comprador,LugarEmision, CMTOcodigo,Proveedor, eo.EOfecha, es.ESnumero, Cotizacion
</cfquery> 

<cfset LvarTipo = "">
<cfif 'form.TipoReporte' eq 0>
	<cfset LvarTipo = "EstadisticasXComprador_Resumido">
<cfelse>
	<cfset LvarTipo = "EstadisticasXComprador_Detallado">
</cfif>

<!---<cfif isdefined("form.toExcel")>
    <cfcontent type="application/vnd.ms-excel">
    <cfheader name="Content-Disposition" 
	    value="attachment;filename=#LvarTipo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls">    
</cfif>--->

<cfset LvarColspan = 12>
<cfset LvarColspanTotal = 7>
<cfset ColspanTotales = 3>
<cfset ColspanLinea = 5>
<cfif #form.Tipo# eq "T" or #form.Tipo# eq "I">
	 <cfif isdefined("form.showDates") or isdefined("form.toExcel")>
		<cfset LvarColspan = 21>
    	<cfset LvarColspanTotal = 11>
         <cfset ColspanTotales = 10>
         <cfset ColspanLinea = 12>
      <cfelse>
      	  <cfset LvarColspan = 14>
    	  <cfset LvarColspanTotal = 9>
          <cfset ColspanTotales = 3>
          <cfset ColspanLinea = 5>
     </cfif>   
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
                title="Reporte Estadisticas Comprador Detallado"
                print="true">	
        </td>
	 	<!--- <td align="right" width="7%">
			<cf_rhimprime datos="/sif/cm/consultas/OrdenesSurtidasComprador-form-detalle.cfm" paramsuri="#Param#">
		</td> --->  
	  </tr>
	</table>    
	<cfoutput>
        <table width="100%" border="0" cellpadding="1" cellspacing="1" >
            <tr> 
              <td  align="center" ><span class="titulo">#rsEmpresa.Edescripcion#</span></td>
            </tr>
            <tr> 
              <td align="center" colspan="#LvarColspan#"><b>Reporte de Estadisticas de Compras por Comprador</b></td>
            </tr>
            <tr> 
              <td align="center" colspan="#LvarColspan#"><b>Tipo de Reporte:</b><cfif 'form.TipoReporte' eq 0>Resumido<cfelse>Detallado</cfif></td>
            </tr>
            <tr> 
               <td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">
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
                <tr><td  align="center" colspan="<cfoutput>#LvarColspan#</cfoutput>"><strong>Ordenes de Compra</strong><font size="3">&nbsp;Del Periodo: #form.Periodo# Mes: #form.Mes#</font></td>
            <cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes)) and isdefined("form.fechaHas") and len(trim(form.fechaHas))>
                  <tr><td align="center" colspan="<cfoutput>#LvarColspan#</cfoutput>"><strong>Ordenes de Compra</strong><font size="3">&nbsp;Fecha desde: #LSDateFormat(form.fechaDes,'dd/mm/yyyy')# hasta: #LSDateFormat(form.fechaHas,'dd/mm/yyyy')#</font></td>
            <cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
                  <tr><td align="center" colspan="<cfoutput>#LvarColspan#</cfoutput>"><strong>Ordenes de Compra</strong><font size="3">&nbsp;Fecha: #LSDateFormat(form.fechaDes,'dd/mm/yyyy')#</font></td>                  
            <cfelseif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
                  <tr><td align="center" colspan="<cfoutput>#LvarColspan#</cfoutput>"><strong>Ordenes de Compra</strong><font size="3">&nbsp;Fecha: #LSDateFormat(form.fechaHas,'dd/mm/yyyy')#</font></td>                        
            </cfif>
        </cfoutput>
        <cfif isdefined('form.Tipo') and #form.Tipo# neq 'T'>
            <tr>
                <td  colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center" style="padding-right: 20px"><b>Tipo Orden:</b>
                    <cfif  #form.Tipo# eq 'L'>Local<cfelseif #form.Tipo# eq 'I'>Internacional</cfif>
                </td>
            </tr>
        </cfif>
        <cfif not  isdefined("form.toExcel") and not isdefined("Url.imprimir")>
            <tr>
                <td colspan="">
                    <table width="70%" class="ayuda" align="center" border="0">
                        <tr>
                            <td align="center"  colspan="<cfoutput>#LvarColspan#</cfoutput>">
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
            <td class="bottomline" colspan="<cfoutput>#LvarColspan#</cfoutput>">&nbsp;</td>
        </tr>
        </table>
    </cfoutput>    
 <cfset imprimeEncabezado()>
<cffunction name="imprimeEncabezado" output="yes">
     <table width="100%" border="0" cellpadding="1" cellspacing="1" >
     <tr>
				<!--- Ordenes --->
                <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Orden</strong></td>
                <!--- Solicitudes --->
                <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"  align="center"><strong>Soli.</strong></td>
                <!--- Linea --->
                <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Lin</strong></td>
				<!--- Proveedor --->
                <td  width="11%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"  align="center"><strong>Proveedor</strong></td>
                <!--- Departamento --->
                <td  width="11%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"  align="center"><strong>Centro Funcional</strong></td>
                <cfif isdefined("form.showDates") or isdefined("form.toExcel")>
					<!---  Fecha de Recibo de la Solicitud--->
                    <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>F. Recibo<br /> Solicitud</strong></td>
					<!---  EA--->
                    <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>F. env&iacute;o<br /> Cot</strong></td>
					<!---  CA--->
                    <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>F. Cot<br /> Aprob</strong></td>
                    <!---  Fecha de la OC--->
                    <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Fecha OC</strong></td>
                    <!---  Fecha Envio de la OC--->
                    <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Fecha <br />Envio OC</strong></td>
                    <!---  Fecha Estimada de Entrega--->
                    <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>F. Est<br />Entrega</strong></td>
                    <!--- Fecha Real de Entrega--->
                    <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>F.Real <br />Entrega</strong></td>
				</cfif>
                <!---  Cotizaciones--->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Cot</strong></td>
                <!---  EO-SM--->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>EO-SC</strong></td>
                <!---  CA-EA--->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>CA-EA</strong></td>
				<!---  EO-OC--->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>EO-OC</strong></td>
                <!---  A - B - C--->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>A - B - C</strong></td>
                
				<cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
					<!--- SC-IBR--->
                    <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black; border-right:1px solid black;" align="center"><strong>IBR-SC</strong></td> 
                 </cfif>
                 <cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 
					<!--- IBRI- SC --->
                    <td style=" border-bottom:1px solid black;  border-top:1px solid black; border-left:1px solid black; border-right:1px solid black;" align="center"><strong>IBRI-SC</strong></td>
                </cfif>
                <cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
					 <!--- IBP-IBR--->
                    <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-right:1px solid black;" align="center"><strong>IBP-IBR</strong></td> 
                </cfif>    
               	<!--- IBP-IBRI--->
			   <cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 
					<td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-right:1px solid black;" align="center"><strong>IBP-IBRI</strong></td> 
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
        <tr><td colspan="#LvarColspan#" class="tituloAlterno">#Comprador#</td></tr>
            <cfset EO_OC = "">
            <cfset EO_SC = "">
            <cfset CA_EA = "">
            <cfset contDetalle = contDetalle+1>
            <cfoutput group="LugarEmision">   
                  <tr><td colspan="#LvarColspan#" style="border:1px solid lightgray" align="center"><strong>#LugarEmision#</strong></td></tr>
                <cfset contDetalle = contDetalle+1>
                 <cfoutput group="CMTOdescripcion">   
                    <tr>
                        <td align="left" colspan="#LvarColspan#" style="font-style:italic">
                            <b>#CMTOdescripcion#</b>
                        </td>
                    </tr>
                    <cfset LvarTotal_EO_SC = 0> 
                    <cfset LvarTotalSC_OC = 0> 
                    <cfset LvarTotal_CA_EA = 0> 
                    <cfset LvarTotal_EO_OC = 0>
                    <cfset LvarTotal_A_B_C = 0>
                    <!--- Locales --->
                    <cfset LvarTotal_SC_IBR = 0> 
                    <cfset LvarTotal_IBR_IBP = 0>
                    <!--- Internacionales --->
                    <cfset LvarTotal_IBRI_IBP = 0> 
                    <cfset LvarTotal_SC_IBRI = 0> 
                    <cfset A =0>
                    <cfset B =0>
                    <cfset C =0>
                    <cfset TotalLineas = 0>
                    <cfset contDetalle = contDetalle+1>
                    <cfoutput>
                         <cfif (isdefined("Url.imprimir") and contDetalle GTE maxRows)> 
                            </table>
                                <BR style="page-break-after:always;">
                            <cfset imprimeEncabezado()> 
                            <cfset contDetalle = 1> 
                        </cfif> 
                        <tr>
                            <!--- Ordenes--->
                            <td  align="left">#ver##EOnumero#</td>
                            <!--- Solicitudes--->
                            <td align="center"><cfif #ESidsolicitud# neq ""><a href="javascript:funcShowSolicitud('#ESidsolicitud#','#ESestado#', '#Ecodigo#')">#ESnumero#</a><cfelse>-</cfif></td>
                            <!--- Linea--->
                            <td align="center">#Linea#</td>
                            <!--- Proveedores--->
                            <td align="center" style="font-size:10px;" valign="top">#proveedor#</td>
                            <!--- Departamento--->
                            <td  align="center" style="font-size:10px;" valign="top">#CFdescripcion#</td>
                            <cfif isdefined("form.showDates") or isdefined("form.toExcel")>
                                <!---  Fecha de Recibo de la Solicitud--->
                                <td  align="center"><cfif #ESfechaAplica# neq "">#Dateformat(ESfechaAplica,'dd-mm-yyyy')#<cfelse>-</cfif></td>
                                <!---  EA --->
                                <td  align="center"><cfif #EA# neq "">#Dateformat(EA,'dd-mm-yyyy')#<cfelse>-</cfif> </td>
                                <!---  CA --->
                                <td  align="center"><cfif #CA# neq "">#Dateformat(CA,'dd-mm-yyyy')#<cfelse>-</cfif> </td>
                                <!---  Fecha de la OC--->
                                <td align="center"><cfif #EOfecha# neq "">#Dateformat(EOfecha,'dd-mm-yyyy')#<cfelse>-</cfif> </td>
                                <!---  Fecha Envio de la OC--->
                                <td  align="center"><cfif #EOFechaAplica# neq "">#Dateformat(EOFechaAplica,'dd-mm-yyyy')#<cfelse>-</cfif> </td>
                                <!---  Fecha Estimada de Entrega--->
                                <td align="center"><cfif #DOfechaes# neq "">#Dateformat(DOfechaes,'dd-mm-yyyy')#<cfelse>-</cfif></td>
                                <!--- Fecha Real de Entrega--->
                                <td  align="center"><cfif #FechaReal# neq "">#Dateformat(FechaReal,'dd-mm-yyyy')#<cfelse>-</cfif>  </td>
                            </cfif>    
                             <!---  Cotizaciones--->
                            <td align="center"><cfif #ESidsolicitud# neq "">#CotizacionesComprador(CMCid,CMTOimportacion,CMTOcodigo,ESidsolicitud,EOidorden)#<cfelse>-</cfif></td>
                            <!---  EO-SC (A)--->
                            <td align="center">
                                 <cfif EO_SC neq "">#EO_SC#<cfelse>-</cfif> 
                                <cfif EO_SC neq "">
                                    <cfset LvarTotal_EO_SC = #LvarTotal_EO_SC#+#EO_SC#>
                                     <cfset A = #EO_SC#>    
                                </cfif>
                            </td>
                            <!---  CA-EA (B)--->
                            <td align="center">
                                 <cfif CA_EA neq "">#CA_EA#<cfelse>-</cfif> 
                                 <cfif CA_EA neq "">
                                    <cfset LvarTotal_CA_EA = #LvarTotal_CA_EA#+#CA_EA#> 
                                    <cfset B = #CA_EA#>
                                 </cfif>
                            </td>
                            <!---  EO-OC (C)--->
                            <td  align="center">
                                  <cfif EO_OC neq "">#EO_OC#<cfelse>-</cfif> 
                                 <cfif EO_OC neq "">
                                    <cfset LvarTotal_EO_OC = #LvarTotal_EO_OC#+#EO_OC#>
                                    <cfset C = #EO_OC#>
                                </cfif>
                            </td>
                            <!---  A - B - C--->
                            <td align="center">
                                  <cfset LvarABC  	= A-B-C> 
                                      <cfif LvarABC neq "">#LvarABC#<cfelse>-</cfif>     
                                 <cfset LvarTotal_A_B_C = #LvarTotal_A_B_C#+#LvarABC#> 
                            </td>
                            <cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
                                <!--- SC-IBR--->
                                <td  align="center">
                                 <cfif CMTOimportacion eq 0>
                                         <cfif IBR_SC neq "">#IBR_SC#<cfelse>-</cfif> 
                                        <cfif IBR_SC neq "">
                                            <cfset LvarTotal_SC_IBR = #LvarTotal_SC_IBR#+#IBR_SC#>
                                        </cfif>
                                  <cfelse>-      
                                 </cfif>        
                                </td>
                            </cfif>
                            <!--- SC-IBRI--->
                            <cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 
                                 <td  align="center">
                                     <cfif CMTOimportacion eq 1>
                                         <cfif IBRI_SC neq "">#IBRI_SC#<cfelse>-</cfif> 
                                         <cfif IBRI_SC neq "">
                                                <cfset LvarTotal_SC_IBRI = #LvarTotal_SC_IBRI#+#IBRI_SC#>
                                         </cfif>
                                      <cfelse>-   
                                     </cfif>
                                </td> 
                            </cfif>
                            <cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
                                 <!--- IBP-IBR--->
                                <td align="center">
                                     <cfif CMTOimportacion eq 0>
                                          <cfif IBR_IBP neq "">#IBR_IBP#<cfelse>-</cfif> 
                                         <cfif IBR_IBP neq "">
                                                <cfset LvarTotal_IBR_IBP = #LvarTotal_IBR_IBP #+#IBR_IBP#>
                                         </cfif>
                                      <cfelse>-   
                                     </cfif>     
                                </td>
                            </cfif>
                             <!--- IBRI - IBP --->
                            <cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 
                                <td align="center">
                                    <cfif CMTOimportacion eq 1>
                                         <cfif IBRI_IBP neq "">#IBRI_IBP#<cfelse>-</cfif> 
                                         <cfif IBRI_IBP neq "">
                                                <cfset LvarTotal_IBRI_IBP = #LvarTotal_IBRI_IBP #+#IBRI_IBP#>
                                         </cfif>
                                     <cfelse>-    
                                    </cfif>     
                                </td>
                            </cfif>    
                        </tr>
                        <cfset contDetalle = contDetalle+1> 
                    </cfoutput>   
                        <tr>
                            <td colspan="#ColspanLinea#"></td>
                            <td colspan="#LvarColspanTotal#" style="border-top:1px dotted black;">&nbsp;</td>
                        </tr>
                        <tr>
                             <td colspan="2" align="left"><strong>Ordenes:</strong>&nbsp;#OrdenesComprador(CMCid,CMTOcodigo)#</td>
                            <cfset TotalLineas = LineasComprador(CMCid,CMTOcodigo,CMTOcodigo)>
                            <td colspan="#ColspanTotales#" align="right" class="topline"><strong>Total Promedio&nbsp;&nbsp;&nbsp;</strong></td>
                            
                            <td align="center" >
								<cfset CotizC = CotizComprador(CMCid,CMTOcodigo)>
                                <cfif CotizC neq "">#LSnumberFormat(CotizC,"__.__")#<cfelse>-</cfif> 
                                    <cfif CotizC neq "">
                                        <cfset LvarCotizacionTotal = #LvarCotizacionTotal#+#CotizC#>
                                </cfif>
                            </td>
                            <td align="center" >
                               <cfif LvarTotal_EO_SC neq "">#LSNumberformat((LvarTotal_EO_SC /TotalLineas),"___.__")#</cfif>
                               <cfset LvarTotal_EO_SC_G = #LvarTotal_EO_SC_G#+#LvarTotal_EO_SC#>
                            </td>
                            <td align="center" >
                                <cfif LvarTotal_CA_EA neq "">#LSNumberformat((LvarTotal_CA_EA /TotalLineas),"___.__")# </cfif>     
                                <cfset LvarTotal_CA_EA_G = #LvarTotal_CA_EA_G#+#LvarTotal_CA_EA#>
                            </td>
                            <td align="center" >
                                <cfif LvarTotal_EO_OC neq "">#LSNumberformat((LvarTotal_EO_OC /TotalLineas),"___.__")#</cfif>        
                                <cfset LvarTotal_EO_OC_G = #LvarTotal_EO_OC_G#+#LvarTotal_EO_OC#>
                            </td>
                            <td align="center" >
                                <cfif LvarTotal_A_B_C neq "">#LSNumberformat((LvarTotal_A_B_C/TotalLineas),"___.__")#</cfif>     
                                <cfset LvarTotal_A_B_C_G = #LvarTotal_A_B_C_G#+#LvarTotal_A_B_C#> 
                            </td>
                            <cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
                                <cfif CMTOimportacion eq 0>
                                        <td align="center">
                                            <cfif LvarTotal_SC_IBR neq "">#LSNumberformat((LvarTotal_SC_IBR/TotalLineas),"___.__")#</cfif>
                                            <cfset LvarTotal_SC_IBR_G = #LvarTotal_SC_IBR_G#+#LvarTotal_SC_IBR#>
                                       </td> 
                                <cfelse>
                                    <td align="center" >-</td>
                                </cfif>    
                            </cfif>
                            <cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 	
                                 <cfif CMTOimportacion eq 1>
                                    <td align="center">
                                             <cfif LvarTotal_SC_IBRI neq "">#LSNumberformat((LvarTotal_SC_IBRI/TotalLineas),"___.__")#</cfif> 
                                             <cfset LvarTotal_SC_IBRI_G = #LvarTotal_SC_IBRI_G#+#LvarTotal_SC_IBRI#>
                                    </td>
                                 <cfelse>
                                    <td align="center" >-</td>
                                </cfif>
                            </cfif>
                            <cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
                                <cfif CMTOimportacion eq 0>
                                     <td align="center">
										  <cfif LvarTotal_IBR_IBP neq "">#LSNumberformat((LvarTotal_IBR_IBP/TotalLineas),"___.__")#</cfif>
                                          <cfset LvarTotal_IBR_IBP_G = #LvarTotal_IBR_IBP_G#+#LvarTotal_IBR_IBP#>
                                     </td> 
                                <cfelse>
                                    <td align="center">-</td>
                                </cfif>
                            </cfif>
                            <cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 
                                <cfif CMTOimportacion eq 1>
                                    <td align="center" >
                                             <cfif LvarTotal_IBRI_IBP neq "">#LSNumberformat((LvarTotal_IBRI_IBP/TotalLineas),"___.__")#</cfif>
                                             <cfset LvarTotal_IBRI_IBP_G = #LvarTotal_IBRI_IBP_G#+#LvarTotal_IBRI_IBP#>
                                    </td>
                                 <cfelse>
                                    <td align="center">-</td>
                                </cfif>
                            </cfif>                            
                        </tr>
                          <!--- -----------------Limpiar Variables --------------------->
                        <cfset LvarTotal_EO_SC = 0> 
                        <cfset LvarTotal_CA_EA = 0> 
                        <cfset LvarTotal_EO_OC = 0>
                        <cfset LvarTotal_A_B_C = 0>
                        <cfset LvarTotal_SC_IBR = 0> 
                        <cfset LvarTotal_IBR_IBP = 0>
                        <cfset LvarTotal_IBRI_IBP = 0> 
                        <cfset LvarTotal_SC_IBRI = 0> 
                        <cfset TotalLineas = 0>   
                        <cfset contDetalle = contDetalle+2>  
                        <!--- --------------------------------------------------------->
                </cfoutput>         
            </cfoutput>
            <TR><TD>&nbsp;</TD></TR>
            <tr>
                 <td colspan="2" align="left">&nbsp;</td>
                 
                <cfset TotalLineasG = LineasComprador(CMCid)>
                <td colspan="#ColspanTotales#" align="right" class="topline"><strong>TOTALES GENERALES PROMEDIO&nbsp;&nbsp;&nbsp;</strong></td>
                <td align="center" >#LSNumberformat(LvarCotizacionTotal/TotalLineasG,"___.__")#</td>
                <td align="center" >
                   <cfif LvarTotal_EO_SC_G neq "">#LSNumberformat((LvarTotal_EO_SC_G /TotalLineasG),"___.__")#</cfif>
                </td>
                <td align="center" >
                    <cfif LvarTotal_CA_EA_G neq "">#LSNumberformat((LvarTotal_CA_EA_G /TotalLineasG),"___.__")# </cfif>     
                </td>
                <td align="center" >
                    <cfif LvarTotal_EO_OC_G neq "">#LSNumberformat((LvarTotal_EO_OC_G /TotalLineasG),"___.__")#</cfif>        
                </td>
                <td align="center" >
                    <cfif LvarTotal_A_B_C_G neq "">#LSNumberformat((LvarTotal_A_B_C_G/TotalLineasG),"___.__")#</cfif>     
                </td>
                <cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
                    <cfif CMTOimportacion eq 0>
                            <td align="center">
                                <cfif LvarTotal_SC_IBR_G neq "">#LSNumberformat((LvarTotal_SC_IBR_G/TotalLineasG),"___.__")#</cfif>
                           </td> 
                    <cfelse>
                        <td align="center" >-</td>
                    </cfif>    
                </cfif>
                <cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 	
                     <cfif CMTOimportacion eq 1>
                        <td align="center">
                                 <cfif LvarTotal_SC_IBRI_G neq "">#LSNumberformat((LvarTotal_SC_IBRI_G/TotalLineasG),"___.__")#</cfif> 
                        </td>
                     <cfelse>
                        <td align="center" >-</td>
                    </cfif>
                </cfif>
                <cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
                    <cfif CMTOimportacion eq 0>
                         <td align="center">
                                  <cfif LvarTotal_IBR_IBP_G neq "">#LSNumberformat((LvarTotal_IBR_IBP_G/TotalLineasG),"___.__")#</cfif>
                         </td> 
                    <cfelse>
                        <td align="center">-</td>
                    </cfif>
                </cfif>
                <cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 
                    <cfif CMTOimportacion eq 1>
                        <td align="center" >
                                 <cfif LvarTotal_IBRI_IBP_G neq "">#LSNumberformat((LvarTotal_IBRI_IBP_G/TotalLineasG),"___.__")#</cfif>
                        </td>
                     <cfelse>
                        <td align="center">-</td>

                    </cfif>
                </cfif>                            
            </tr>
            <tr>
                 <td colspan="2" align="left"><strong>Total Ordenes:</strong>&nbsp;#OrdenesComprador(CMCid)#</td>
                <td colspan="#ColspanTotales#" align="right" class="topline"><strong>TOTALES GENERALES&nbsp;&nbsp;&nbsp;</strong></td>
                
                <td align="center" >#LvarCotizacionTotal#</td>
                <td align="center" >
                   <cfif LvarTotal_EO_SC_G neq "">#LSNumberformat((LvarTotal_EO_SC_G),"___.__")#</cfif>
                </td>
                <td align="center" >
                    <cfif LvarTotal_CA_EA_G neq "">#LSNumberformat((LvarTotal_CA_EA_G ),"___.__")# </cfif>     
                </td>
                <td align="center" >
                    <cfif LvarTotal_EO_OC_G neq "">#LSNumberformat((LvarTotal_EO_OC_G ),"___.__")#</cfif>        
                </td>
                <td align="center" >
                    <cfif LvarTotal_A_B_C_G neq "">#LSNumberformat((LvarTotal_A_B_C_G),"___.__")#</cfif>     
                </td>
                <cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
                    <cfif CMTOimportacion eq 0>
                            <td align="center">
                                <cfif LvarTotal_SC_IBR_G neq "">#LSNumberformat((LvarTotal_SC_IBR_G),"___.__")#</cfif>
                           </td> 
                    <cfelse>
                        <td align="center" >-</td>
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
                <cfif #form.Tipo# eq "T" or #form.Tipo# eq "L"> 
                    <cfif CMTOimportacion eq 0>
                         <td align="center">
                                  <cfif LvarTotal_IBR_IBP_G neq "">#LSNumberformat((LvarTotal_IBR_IBP_G),"___.__")#</cfif>
                         </td> 
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
		<!--- -----------------Limpiar Variables --------------------->
        <cfset LvarTotal_EO_SC_G 		= 0>  <cfset LvarTotal_CA_EA_G 		= 0> 
        <cfset LvarTotal_EO_OC_G 	= 0>	<cfset LvarTotal_A_B_C_G 		= 0>
        <cfset LvarTotal_SC_IBR_G 	= 0> 	<cfset LvarTotal_IBR_IBP_G 	= 0>
        <cfset LvarTotal_IBRI_IBP_G 	= 0> 	<cfset LvarTotal_SC_IBRI_G 	= 0>
        <cfset LvarOrdenesT = 0>				<cfset LvarCotizacionTotal 		=0>  
        <!--- --------------------------------------------------------->   
        </cfoutput>
        <tr><td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">&nbsp;</td></tr>
        <tr><td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">----------------- Fin del Reporte -----------------</td></tr>    
    <cfelse>
                	<tr><td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">&nbsp;</td></tr>
                	<tr><td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">----------------- No se encontrar&oacute;n Datos -----------------</td></tr>    
               </cfif>     
    </table>
    
	<script language=javascript>
		function ventanaSecundaria(indice, ecodigo){
			var OC =  indice;
			window.open('../consultas/OrdenesPendientesDetalleOC.cfm?OC='+OC+'&Ecodigo='+ecodigo,"ventana1","width=1000,height=700,top=120,left=200,scrollbars=yes")
		}
		
		function funcShowSolicitud(numSolicitud,Estado,ecodigo)
		{
			var SC =  numSolicitud;
			window.open("../consultas/MisSolicitudes-vista.cfm?&ESidsolicitud="+numSolicitud+'&Ecodigo='+ecodigo+"&ESestado="+Estado,20,20,950,600);
		}
    </script>  
    
    <cffunction name="CotizacionesComprador" access="private" returntype="numeric">
	<cfargument name="CMCid" type="numeric" required="yes">
    <cfargument name="CMTOimportacion" type="numeric" required="yes">
    <cfargument name="CMTOcodigo" type="string" required="yes">
    <cfargument name="ESidsolicitud" type="numeric" required="yes">
    <cfargument name="EOidorden" type="numeric" required="yes">
    <cfquery dbtype="query" name="rsCot">
    	SELECT DISTINCT
        	Cotizacion
        from rsDatos
        WHERE CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMCid#">
        	AND CMTOimportacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMTOimportacion#">
            AND CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Arguments.CMTOcodigo)#">
            AND ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ESidsolicitud#">
            AND EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			AND Cotizacion IS NOT null
    </cfquery>
	<cfset LvarLineas = rsCot.recordcount>
    <cfreturn LvarLineas>
</cffunction>

<cffunction name="CotizComprador" access="private" returntype="numeric"
hint="Funcion para obtener el total de las cotizaciones del Comprador">
	<cfargument name="CMCid" type="numeric" required="yes">
    <cfargument name="CMTOcodigo" type="string" required="false" default="notDefined">    
    <cfquery dbtype="query" name="rsCot">
    	SELECT DISTINCT
        	Cotizacion
        from rsDatos
        WHERE CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMCid#">
        	 <cfif Arguments.CMTOcodigo neq 'notDefined'>
            	AND CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Arguments.CMTOcodigo)#">
            </cfif>
            AND Cotizacion IS NOT null
    </cfquery>
	<cfset LvarLineas = rsCot.recordcount>
    <cfreturn LvarLineas>
</cffunction>

<cffunction name="OrdenesComprador" access="private" returntype="numeric"
hint="Funcion para obtener el total de las OC del COmprador">
	<cfargument name="CMCid" type="numeric" required="yes">
    <cfargument name="CMTOcodigo" type="string" required="false" default="notDefined">    
    <cfquery dbtype="query" name="rsOrdenes">
    	SELECT DISTINCT
        	EOnumero
        from rsDatos
        WHERE CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMCid#">
            <cfif Arguments.CMTOcodigo neq 'notDefined'>
            	AND CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Arguments.CMTOcodigo)#">
            </cfif>
    </cfquery>    
	<cfset LvarOrdenes = rsOrdenes.recordcount>
    <cfreturn LvarOrdenes>
</cffunction>

<cffunction name="LineasComprador" access="private" returntype="numeric"
hint="Funcion para obtener el total de las lineas del comprador">
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