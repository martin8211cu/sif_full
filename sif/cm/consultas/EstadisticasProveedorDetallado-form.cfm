<cfset prov1  = "">
<cfset prov2  = "">
<cfset Param  = "">
<cfset contador = 0>
<cfset contDetalle = 5>  

<!--- 	---------------Variables URL imprimir--------------------------->
<cfif isdefined('url.snegocios1') and len(trim(#url.snegocios1#))>
     <cfset form.snegocios1 = url.snegocios1>
</cfif>
<cfif isdefined('url.snegocios2') and len(trim(#url.snegocios2#))>
    <cfset form.snegocios2 = url.snegocios2>
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
<!--- ---------------------------------------------------------- --->

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
<cfif isdefined('form.snegocios1') and len(trim(#form.snegocios1#))>
   <cfset prov1 = form.snegocios1>
   <cfset Param = Param & "&snegocios1="&#form.snegocios1#> 
</cfif>
<cfif isdefined('form.snegocios2') and len(#form.snegocios2#)>
   <cfset prov2  = form.snegocios2>  
   <cfset Param = Param & "&snegocios2="&#form.snegocios2#>
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
	<cfset maxRows = 21>
<cfelse>    
	<cfset maxRows = 40>
</cfif>

<!--- Empresas --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif len(trim(#prov1#)) gt 0 and  len(trim(#prov2#)) gt 0> 
   <cfquery name="rsRango1" datasource="#session.dsn#">
	 select SNnombre as Prov1 from SNegocios  
     where Ecodigo = #session.Ecodigo#
     	and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#prov1#">
   </cfquery>
	 <cfquery name="rsRango2" datasource="#session.dsn#">
         select SNnombre as Prov2 from SNegocios  
         where Ecodigo = #session.Ecodigo#
            and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#prov2#">
   </cfquery>
  <cfelseif len(trim(#prov1#)) gt 0 >  
	  <cfquery name="rsRango1" datasource="#session.dsn#">
         select SNnombre as Prov1 from SNegocios  
         where Ecodigo = #session.Ecodigo#
            and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#prov1#">
   </cfquery>
 <cfelseif len(trim(#prov2#)) gt 0>  
	<cfquery name="rsRango2" datasource="#session.dsn#">
         select SNnombre as Prov2 from SNegocios  
         where Ecodigo = #session.Ecodigo#
            and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#prov2#">
   </cfquery>
 </cfif>

<cf_dbfunction name="to_char" args="eo.EOnumero" returnvariable="EOnumero">
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return ventanaSecundaria('+ #PreserveSingleQuotes(EOnumero)# +');''>'" returnvariable="OC" delimiters="+">
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
                es.ESnumero,
                do.DOlinea,
                 cmc.CMCnombre AS Comprador,
                eo.EOnumero,
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
                CASE eto.CMTOimportacion  WHEN 1 THEN dt.DTfechaactividad
                    										WHEN 0 THEN  COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)
                END AS FechaReal,
                pc.CMPfechaAprob as CA, 
                pc.CMPfechaEnvAprob as EA,
                es.ESidsolicitud,
                es.ESestado,
                eo.EOidorden,
               CASE eo.EOestado WHEN - 10 THEN 'Pendiente de Aprobación Presupuestaria' 
                                            WHEN - 8 THEN 'Orden Rechazada' 
                                            WHEN - 7 THEN 'En Proceso de Aprobación' 
                                            WHEN 0 THEN 'Pendiente' 
                                            WHEN 5 THEN 'Pendiente Vía Proceso' 
                                            WHEN 7 THEN 'Pendiente OC Directa' 
                                            WHEN 8 THEN 'Pendiente Vía Contrato' 
                                            WHEN 9 THEN 'Autorizada por jefe Compras' 
                                            WHEN 10 THEN 'A' 
                                            WHEN 55 THEN 'Ordenes Canceladas, Surtidas Parcialmente' 
                                            WHEN 60 THEN 'Ordenes Canceladas' 
                                            WHEN 70 THEN 'Ordenes Anuladas' 
            		END AS EstadoOC, 
                do.DOcantsurtida,
                do.DOcantidad,
               <cf_dbfunction name="datediff" args="es.ESfechaAplica,eo.EOFechaAplica"> as EO_SC,
                <cf_dbfunction name="datediff" args="pc.CMPfechaEnvAprob, pc.CMPfechaAprob"> as CA_EA,
                <cf_dbfunction name="datediff" args="es.ESfechaAplica, pc.CMPfechaEnvAprob"> as EA_SC,
                <cf_dbfunction name="datediff"  delimiters="|" args="eo.EOFechaAplica | COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)"> as IBR_EO, 
                <cf_dbfunction name="datediff" args="eo.EOFechaAplica, dt.DTfechaactividad">as IBRI_EO,
                <cf_dbfunction name="datediff" args="eo.EOfecha, eo.EOFechaAplica"> as EO_OC,
                <cf_dbfunction name="datediff" delimiters="|" args="es.ESfechaAplica  | COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)"> as IBR_SC,                  
                <cf_dbfunction name="datediff"  delimiters="|" args="do.DOfechaes | COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)"> as IBR_IBP, 
                <cf_dbfunction name="datediff" args="es.ESfechaAplica,dt.DTfechaactividad">as IBRI_SC,
                <cf_dbfunction name="datediff" args="do.DOfechaes,dt.DTfechaactividad">  as IBRI_IBP,
                eto.CMTOdescripcion,
                eto.CMTOcodigo as CMTOcodigo,
                ec.ECnumero as Cotizacion,
                sn.SNcodigo,
                sn.SNidentificacion,
                m.Miso4217 as Moneda,
                do.DOtotal,
                 Round((do.DOtotal*eo.EOtc),2) as Total,
                eo.EOtc,
                sn.SNnombre  as Proveedor
    		
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

    WHERE  <cfif isdefined('form.EcodigoE') and form.EcodigoE eq -2>
                    eo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                 <cfelse>
                    eo.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoE#" list="yes">)
                 </cfif> 
		AND  DOcantidad >= DOcantsurtida
        AND DOcantsurtida <> 0
        AND eo.EOestado = 10
        
    <cfif #Form.Tipo# neq "T">
                <cfif 	#Form.Tipo# eq "L">
                    AND eto.CMTOimportacion = 0
                </cfif>
                <cfif 	#Form.Tipo# eq "I">
                    AND eto.CMTOimportacion = 1
                </cfif>
            </cfif>
	<cfif len(trim(#prov1#)) gt 0 and  len(trim(#prov2#)) gt 0> 
            <cfif #prov1# lt #prov2#>
             and sn.SNidentificacion  between <cfqueryparam cfsqltype="cf_sql_varchar" value="#prov1#">  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#prov2#">
            <cfelse>
             and sn.SNidentificacion  between <cfqueryparam cfsqltype="cf_sql_varchar" value="#prov2#">  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#prov1#">
            </cfif> 
         <cfelseif len(trim(#prov1#)) gt 0 >  
             and sn.SNidentificacion =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#prov1#">
         <cfelseif len(trim(#prov2#)) gt 0>  
             and sn.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#prov2#">    
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
        
	ORDER BY Proveedor, LugarEmision, CMTOdescripcion, EOnumero
</cfquery> 

<cfset LvarTipo = "">
<cfif 'form.TipoReporte' eq 0>
	<cfset LvarTipo = "EstadisticasXProveedor_Resumido">
<cfelse>
	<cfset LvarTipo = "EstadisticasXProveedor_Detallado">
</cfif>

<cfif isdefined("form.toExcel")>
     <cfcontent type="application/vnd.ms-excel">
     <cfheader name="Content-Disposition" 
        value="attachment;filename=#LvarTipo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls">    
</cfif>

<cfset LvarColspan = 19>
<cfset LvarColspanTotal = 12>
<cfset ColspanTotales = 5>
<cfset ColspanTotales_G = 7>
<cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I" or #Form.Tipo# eq "L">
	 <cfif isdefined("form.showDates") or isdefined("form.toExcel")>
		<cfset LvarColspan = 26>
    	<cfset LvarColspanTotal = 21>
         <cfset ColspanTotales = 12>
         <cfset ColspanTotales_G = 14>
      <cfelse>
      	  <cfset LvarColspan = 19>
    	  <cfset LvarColspanTotal = 12>
          <cfset ColspanTotales = 5>
          <cfset ColspanTotales_G = 7>
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
	  <tr align="left"> 
		<tr> 
		<td alig="left">
            <cf_htmlReportsHeaders 
                irA="EstadisticasProveedor.cfm"
                FileName="#LvarTipo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls"
                title="Reporte Estadisticas Proveedor Detallado"
                print="true">	
        </td>
		<!--- <td width="100%"><a href="../consultas/EstadisticasProveedor.cfm">Regresar</a></td>
        <td align="right" width="100%">
			<cf_rhimprime datos="/sif/cm/consultas/EstadisticasProveedorDetallado-form.cfm" paramsuri="#Param#">
		</td>  --->
	  </tr>
	</table>

    <table width="100%" border="0" cellpadding="1" cellspacing="1" >
        <tr> 
        	<td  align="center"><span class="titulo"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></span></td>
        </tr>
        <tr> 
          <td align="center" colspan="<cfoutput>#LvarColspan#</cfoutput>"><b>Reporte de Estadisticas de Compras por Proveedor</b></td>
        </tr>
        <tr> 
          <td align="center" colspan="<cfoutput>#LvarColspan#</cfoutput>"><b>Tipo de Reporte:</b><cfif 'form.TipoReporte' eq 0>Resumido<cfelse>Detallado</cfif></td>
        </tr>
        <tr> 
           <td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">
				<cfif len(trim(#prov1#)) gt 0 and  len(trim(#prov2#)) gt 0 and #prov1# neq #prov2#> 
                    <strong>Proveedor, desde:</strong> <cfoutput>#rsRango1.prov1#</cfoutput><strong>, hasta:</strong>  <cfoutput>#rsRango2.prov2#</cfoutput>
               <cfelseif len(trim(#prov1#)) gt 0 and  len(trim(#prov2#)) gt 0 and #prov1# eq #prov2#> 
                    <strong>Proveedor:</strong> <cfoutput>#rsRango1.prov1#</cfoutput>
               <cfelseif len(trim(#prov1#)) gt 0  and len(trim(#prov2#)) eq 0 >  
                    <strong>Proveedor:</strong> <cfoutput>#rsRango1.prov1#</cfoutput>
                <cfelseif len(trim(#prov1#)) eq 0 and len(trim(#prov2#)) gt 0 >  
                    <strong>Proveedor:</strong> <cfoutput>#rsRango2.prov2#</cfoutput>
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
                                    <strong>EA-SC:</strong>&nbsp;Tiempo de Elaborac&oacute;n Cotizaci&oacute;n
                                    <strong>CA-EA:</strong>&nbsp;Tiempo de Aprobaci&oacute;n de la Cotizaci&oacute;n,&nbsp;
                                    <strong>EO-OC:</strong>&nbsp;Tiempo de Autorizaci&oacute;n de las OC,&nbsp;
                                    <strong>A-B-C:</strong>&nbsp;Gestión Comprador,&nbsp;
                                    <strong>IBR-CS:</strong>&nbsp;Gestión Total Local,&nbsp;
                                    <strong>IBR-EO:</strong>&nbsp;Tiempo Entrega Proveedor Local&nbsp;
                                    <strong>IBRI-CS:</strong>&nbsp;Gestion Total Internacional,&nbsp;
                                    <strong>IBR-IBP:</strong>&nbsp;Puntualidad Local,&nbsp;
                                    <strong>IBRI-IBP:</strong>&nbsp;Puntualidad Internacional&nbsp;
                                    <strong>IBRI-EO:</strong>&nbsp;Tiempo Entrega Proveedor Internacional
                            </p>
                        </td>	
                    </tr>
                </table>	
            </td>
        </tr>
    </cfif>
    <tr> 
	    <td class="bottomline" colspan="16">&nbsp;</td>
    </tr>
    </table>
    <cfset imprimeEncabezado()>
	<cffunction name="imprimeEncabezado" output="yes">
         <table width="100%" border="0" cellpadding="1" cellspacing="1" >
            <tr>
                <!--- Estado de la OC --->
                <td align="center" width="7%" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>Estado OC</strong></td> 
                <!--- Ordenes --->
                <td  style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>Orden</strong></td>
                <!--- Solicitudes --->
                <td  style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"  align="center"><strong>Soli.</strong></td>
                <!--- Linea --->
                <td   style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>Lin</strong></td>
                <!--- Comprador--->
                <td   style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>Comprador</strong></td>
                <!--- Departamento --->
                <td  style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"  align="center"><strong>Centro Funcional</strong></td>
                 <cfif isdefined("form.showDates") or isdefined("form.toExcel")>
                    <!---  Fecha de Recibo de la Solicitud--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>F. Recibo<br /> Solicitud</strong></td>
                    <!---  EA--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>F. env&iacute;o<br /> Cot</strong></td>
					<!---  CA--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>F. Cot<br /> Aprob</strong></td>
                    <!---  Fecha de la OC--->
                    <td  style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>Fecha OC</strong></td>
                    <!---  Fecha Envio de la OC--->
                    <td  style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"align="center"><strong>Fecha <br />Envio OC</strong></td>
                    <!---  Fecha Estimada de Entrega--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>F. Est<br />Entrega</strong></td>
                    <!--- Fecha Real de Entrega--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>F.Real <br />Entrega</strong></td>
                </cfif>
                 <!--- Moneda --->
                 <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>Mon</strong></td>  
                 <!--- Monto--->
                 <td  style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>Monto</strong></td>  
                <!---  EO-SM--->
                <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>EO-SC</strong></td>
                <!---  EA-SC--->
                <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>EA-SC</strong></td>
				<!---  CA-EA--->
                <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>CA-EA</strong></td>
                <!---  EO-OC--->
                <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"align="center"><strong>EO-OC</strong></td>
                <!---  A - B - C--->
                <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;" align="center"><strong>A - B - C</strong></td>
                <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
					<!--- IBR-SC--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray; border-right:1px solid lightgray;" align="center"><strong>IBR-SC</strong></td> 
                </cfif>
                <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
					<!--- IBRI-SC--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray; border-left:1px solid lightgray; border-right:1px solid lightgray;" align="center"><strong>IBRI-SC</strong></td>
				</cfif>	
                <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L">     
					<!--- IBR-EO--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray; border-right:1px solid lightgray;" align="center"><strong>IBR-EO</strong></td> 
                </cfif>
                <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
					<!--- IBRI-EO--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray; border-right:1px solid lightgray;" align="center"><strong>IBRI-EO</strong></td> 
                </cfif>
				<cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                     <!--- IBP-IBR--->
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-right:1px solid lightgray;" align="center"><strong>IBP-IBR</strong></td> 
                </cfif>    
                <!--- IBP-IBRI--->
               <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
                    <td style=" border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-right:1px solid lightgray;" align="center"><strong>IBP-IBRI</strong></td> 
               </cfif>
         </tr>   
	</cffunction>
	<cfif rsDatos.recordcount gt 0>
        <cfoutput query="rsDatos" group="Proveedor">
        <tr><td colspan="#LvarColspan#" class="tituloAlterno">#Proveedor#</td></tr>
             <!--- Totales Generales--->
             	<cfset LvarTotal_EA_SC_G = 0>
                <cfset LvarTotal_EO_SC_G = 0>  		<cfset LvarTotal_CA_EA_G = 0> 
                <cfset LvarTotal_EO_OC_G = 0>		<cfset LvarTotal_A_B_C_G = 0>
                <cfset LvarTotal_SC_IBR_G = 0> 		<cfset LvarTotal_IBR_IBP_G = 0>
				<cfset LvarTotal_IBRI_IBP_G = 0> 	<cfset LvarTotal_SC_IBRI_G = 0>
				<cfset LvarTotal_G = 0>					<cfset LvarTotal_IBR_EO_G = 0>
                <cfset TotalLineas_G = 0>				<cfset LvarTotal_IBRI_EO_G = 0>
                <cfset contDetalle = contDetalle+1> 	<cfset LvarTotal_EA_SC_G = 0>
             <cfoutput group="LugarEmision">   
                        	  <tr><td colspan="#LvarColspan#" style="border:1px solid lightgray" align="center"><strong>#LugarEmision#</strong></td></tr>
 				
                   <!--- ---------------Variables Totalizar ------------------------------>
                <cfset LvarTotal_EO_SC = 0>  		<cfset LvarTotal_CA_EA = 0> 
                <cfset LvarTotal_EO_OC = 0>		<cfset LvarTotal_A_B_C = 0>
                <cfset LvarTotal_SC_IBR = 0> 		<cfset LvarTotal_IBR_EO = 0>
				<cfset LvarTotal_IBR_IBP = 0>     <cfset LvarTotal_IBRI_EO = 0>
                <cfset LvarTotal_IBRI_IBP = 0> 	<cfset LvarTotal_SC_IBRI = 0>
                <cfset LvarTotal_EA_SC = 0>
                <cfset TotalLineas = 0>				<cfset A =0>
                <cfset B =0>								<cfset C =0>
				<cfset LvarTotal = 0>
                <!--- ----------------------------------------------------------------->
                <cfset contDetalle = contDetalle+1> 
                 <cfoutput group="CMTOdescripcion">   
                    <tr>
                        <td align="left" colspan="#LvarColspan#" style="font-style:italic">
                            <b>#CMTOdescripcion#</b>
                        </td>
                    </tr>
					<cfoutput>  
					<cfset contDetalle = contDetalle+1> 
                      <cfif (isdefined("Url.imprimir") and contDetalle GTE maxRows)>  
                        </table>
                            <BR style="page-break-after:always;">
                        <cfset imprimeEncabezado()> 
                        <cfset contDetalle = 1> 
                    </cfif>
                    	<!--- Estado de la OC --->      
                        <tr>
                            <td align="left" style="font-size:11px">
								<cfif #EstadoOC# eq 'A'>
                                    <cfif DOcantsurtida eq DOcantidad>
                                        Aplicada, Totalmente Surtida	
                                    <cfelse>
                                        Aplicada, Parcialmente Surtida
                                    </cfif>
                                <cfelse>
                                    #EstadoOC#
                                </cfif>
                            </td>
                            <!--- Ordenes--->
                            <td align="left">#ver##EOnumero#</td>
                            <!--- Solicitudes--->
                            <td  align="center"><a href="javascript:funcShowSolicitud('#ESidsolicitud#','#ESestado#')">#ESnumero#</a></td>
                            <!--- Linea--->
                            <td  align="center">#linea#</td>
                            <!--- Comprador--->
                            <td  align="center" style="font-size:10px;">#Comprador#</td>
                            <!--- Departamento--->
                            <td  align="center" style="font-size:10px;">#CFdescripcion#</td>
                            <cfif isdefined("form.showDates") or isdefined("form.toExcel")>
								<!---  Fecha de Recibo de la Solicitud--->
                                <td  align="center">#DateFormat(ESfechaAplica,'dd-mm-yyyy')#</td>
                                 <!---  EA --->
                                <td  align="center">#Dateformat(EA,'dd-mm-yyyy')#</td>
                                <!---  CA --->
                                <td  align="center">#Dateformat(CA,'dd-mm-yyyy')#</td>
                                <!---  Fecha de la OC--->
                                <td  align="center">#DateFormat(EOfecha,'dd-mm-yyyy')#</td>
                                <!---  Fecha Envio de la OC--->
                                <td  align="center">#DateFormat(EOfechaAplica,'dd-mm-yyyy')#</td>
                                <!---  Fecha Estimada de Entrega--->
                                <td align="center">#DateFormat(DOfechaes,'dd-mm-yyyy')#</td>
                                <!--- Fecha Real de Entrega--->
                                <td align="center">#DateFormat(FechaReal,'dd-mm-yyyy')#</td>
                            </cfif>
                            <!--- Moneda --->
                            <td  align="center">#Moneda#</td>
                             <!--- Monto --->
                            <td align="center">
                                 #LSNumberFormat(DOtotal,"__________.__")#
									<cfif Total neq "">
                                        <cfset LvarTotal = #LvarTotal #+#Total#>
                                    </cfif>
                            </td>                             
                                 <!---  EO-SC (A)--->
                                <td align="center">
                                     <cfif EO_SC neq "">#EO_SC#<cfelse>-</cfif> 
									 <cfif EO_SC neq "">
                                        <cfset LvarTotal_EO_SC = #LvarTotal_EO_SC#+#EO_SC#>
                                         <cfset A = #EO_SC#>    
                                     </cfif>
                                </td>
                                  <!---  EA-SC --->
                                <td align="center">
                                     <cfif EA_SC neq "">#EA_SC#<cfelse>-</cfif> 
                                    <cfif EA_SC neq "">
                                        <cfset LvarTotal_EA_SC = #LvarTotal_EA_SC#+#EA_SC#>
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
                                    <!--- IBR-EO--->
                                    <td  align="center">
										 <cfif CMTOimportacion eq 0>
                                                <cfif IBR_EO neq "">#IBR_EO#<cfelse>-</cfif>
                                                <cfif IBR_EO neq ""><cfset LvarTotal_IBR_EO = #LvarTotal_IBR_EO#+#IBR_EO#></cfif>
                                          <cfelse>-      
                                         </cfif>        
                                    </td>
                                </cfif>
                                <!--- IBRI_EO --->
                                 <cfif #form.Tipo# eq "T" or #form.Tipo# eq "I"> 
                                     <td  align="center">
                                         <cfif CMTOimportacion eq 1>
                                            <cfif IBRI_EO neq "">#IBRI_EO#<cfelse>-</cfif>
                                             <cfif IBRI_EO neq ""><cfset LvarTotal_IBRI_EO = #LvarTotal_IBRI_EO#+#IBRI_EO#></cfif>
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
            		<cfset TotalLineas = LineasProveedor(SNidentificacion,CMTOcodigo)>
                    <tr>
                        <td colspan="#ColspanTotales_G#"></td>
                        <td colspan="#LvarColspanTotal#" style="border-top:2px dotted lightgray;">&nbsp;</td>
                    </tr>
                    <tr>
                         <td colspan="2"><strong>Total Ordenes:</strong>
                         &nbsp;#OrdenesProveedor(SNidentificacion,CMTOcodigo)#</td>
                        <td colspan="#ColspanTotales#" align="right" class="topline"><strong>Total Promedio:&nbsp;&nbsp;&nbsp;</strong></td>
                        <td align="center">#LSNumberFormat((LvarTotal/TotalLineas),"__________.__")#</td>    
                        <td align="center" >
							<cfif LvarTotal_EO_SC neq "">#LSNumberFormat((LvarTotal_EO_SC /TotalLineas),"__________.__")#</cfif>
                            <cfset LvarTotal_EO_SC_G = #LvarTotal_EO_SC_G#+#LvarTotal_EO_SC#>
                        </td>
                        <td align="center" >
							<cfif LvarTotal_EA_SC neq "">#LSNumberFormat((LvarTotal_EA_SC /TotalLineas),"__________.__")#</cfif>
                            <cfset LvarTotal_EA_SC_G = #LvarTotal_EA_SC_G#+#LvarTotal_EA_SC#>
                        </td>
                        <td align="center" >
							<cfif LvarTotal_CA_EA neq "">#LSNumberFormat((LvarTotal_CA_EA /TotalLineas),"__________.__")#</cfif>
                            <cfset LvarTotal_CA_EA_G = #LvarTotal_CA_EA_G#+#LvarTotal_CA_EA#>
                        </td>
                        <td align="center" >
							<cfif LvarTotal_EO_OC neq "">#LSNumberFormat((LvarTotal_EO_OC /TotalLineas),"__________.__")#</cfif>
                        	<cfset LvarTotal_EO_OC_G = #LvarTotal_EO_OC_G#+#LvarTotal_EO_OC#>
                        </td>
                        <td align="center" >
							<cfif LvarTotal_A_B_C neq "">#LSNumberFormat((LvarTotal_A_B_C/TotalLineas),"__________.__")#</cfif>
                             <cfset LvarTotal_A_B_C_G = #LvarTotal_A_B_C_G#+#LvarTotal_A_B_C#> 
                        </td>
                        
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <cfif CMTOimportacion eq 0>
                                <td align="center">
									<cfif LvarTotal_SC_IBR neq "">#LSNumberFormat((LvarTotal_SC_IBR/TotalLineas),"__________.__")#</cfif>
                                    <cfset LvarTotal_SC_IBR_G = #LvarTotal_SC_IBR_G#+#LvarTotal_SC_IBR#>
                                </td>
                            <cfelse><td align="center" >-</td>
                         </cfif>  
                       </cfif>
                       <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 	
                             <cfif CMTOimportacion eq 1>
                                <td align="center">
                                	<cfif LvarTotal_SC_IBRI neq "">#LSNumberFormat((LvarTotal_SC_IBRI/TotalLineas),"__________.__")#</cfif>
                                	<cfset LvarTotal_SC_IBRI_G = #LvarTotal_SC_IBRI_G#+#LvarTotal_SC_IBRI#>
                                </td>
                             <cfelse><td align="center" >-</td>
                            </cfif>
                         </cfif>
                           
                         <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L">  
                            <cfif CMTOimportacion eq 0>
                                <td align="center">
									<cfif LvarTotal_IBR_EO neq "">#LSNumberFormat((LvarTotal_IBR_EO/TotalLineas),"__________.__")#</cfif>
                                    <cfset LvarTotal_IBR_EO_G = #LvarTotal_IBR_EO_G#+#LvarTotal_IBR_EO#>
                                </td>
                            <cfelse><td align="center" >-</td>
                            </cfif>    
                        </cfif>
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I">  
                             <cfif CMTOimportacion eq 1>
                                <td align="center">
                                	<cfif LvarTotal_IBRI_EO neq "">#LSNumberFormat((LvarTotal_IBRI_EO/TotalLineas),"__________.__")#</cfif>
                                	<cfset LvarTotal_IBRI_EO_G = #LvarTotal_IBRI_EO_G#+#LvarTotal_IBRI_EO#>
                                </td>
                             <cfelse>
                                <td align="center" >-</td>
                            </cfif>
                        </cfif>
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <cfif CMTOimportacion eq 0>
                                <td align="center">
									<cfif LvarTotal_IBR_IBP neq "">#LSNumberFormat((LvarTotal_IBR_IBP/TotalLineas),"__________.__")#</cfif>
                                    <cfset LvarTotal_IBR_IBP_G = #LvarTotal_IBR_IBP_G#+#LvarTotal_IBR_IBP#>
                                </td>
                            <cfelse><td align="center">-</td>
                            </cfif>
                        </cfif>
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
                            <cfif CMTOimportacion eq 1>
                                <td align="center" >
									<cfif LvarTotal_IBRI_IBP neq "">#LSNumberFormat((LvarTotal_IBRI_IBP/TotalLineas),"__________.__")#</cfif>
									<cfset LvarTotal_IBRI_IBP_G = #LvarTotal_IBRI_IBP_G#+#LvarTotal_IBRI_IBP#>
                                </td>
                             <cfelse><td align="center">-</td>
                            </cfif>
                        </cfif>           
                    </tr>
                   <cfset LvarTotal_G = #LvarTotal_G#+#LvarTotal#>
                    <cfset TotalLineas_G = #TotalLineas_G#+#TotalLineas#>
                    <!--- -----------------Limpiar Variables --------------------->
                    <cfset LvarTotal_EA_SC = 0>
                    <cfset LvarTotal_EO_SC = 0> 		<cfset LvarTotal_CA_EA = 0> 
                    <cfset LvarTotal_EO_OC = 0>		<cfset LvarTotal_A_B_C = 0>
                    <cfset LvarTotal_SC_IBR = 0> 		<cfset LvarTotal_IBR_EO = 0> 	
					<cfset LvarTotal_SC_IBRI = 0>		<cfset LvarTotal_IBRI_EO = 0> 
					<cfset LvarTotal_IBR_IBP = 0>		<cfset LvarTotal_IBRI_IBP = 0> 	 
                    <cfset TotalLineas = 0>				<cfset LvarTotal = 0>  
                    <!--- --------------------------------------------------------->
                    <cfset contDetalle = contDetalle+2>
			</cfoutput>           
    	</cfoutput>
        <tr><td>&nbsp;</td></tr>
        <tr>
                        <td colspan="#ColspanTotales_G#" align="right" class="topline"><strong>TOTALES GENERALES PROMEDIO:&nbsp;&nbsp;&nbsp;</strong></td>
                        <td align="center">#LSNumberFormat((LvarTotal_G/TotalLineas_G),"__________.__")#</td>    
                        <td align="center" ><cfif LvarTotal_EO_SC_G neq "">#LSNumberFormat((LvarTotal_EO_SC_G/TotalLineas_G),"__________.__")#</cfif></td>
                        <td align="center" ><cfif LvarTotal_EA_SC_G neq "">#LSNumberFormat((LvarTotal_EA_SC_G/TotalLineas_G),"__________.__")#</cfif></td>
                        <td align="center" ><cfif LvarTotal_CA_EA_G neq "">#LSNumberFormat((LvarTotal_CA_EA_G/TotalLineas_G),"__________.__")#</cfif></td>
                        <td align="center" ><cfif LvarTotal_EO_OC_G neq "">#LSNumberFormat((LvarTotal_EO_OC_G/TotalLineas_G),"__________.__")#</cfif></td>
                        <td align="center" ><cfif LvarTotal_A_B_C_G neq "">#LSNumberFormat((LvarTotal_A_B_C_G/TotalLineas_G),"__________.__")#</cfif></td>
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                                <td align="center"><cfif LvarTotal_SC_IBR_G neq "">#LSNumberFormat((LvarTotal_SC_IBR_G/TotalLineas_G),"__________.__")#</cfif></td>
                            <cfelse><td align="center" >-</td>
                            </cfif> 
                        </cfif>
                         
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 	
                             <cfif CMTOimportacion eq 1 or #Form.Tipo# eq "T">
                                <td align="center"><cfif LvarTotal_SC_IBRI_G neq "">#LSNumberFormat((LvarTotal_SC_IBRI_G/TotalLineas_G),"__________.__")#</cfif></td>
                             <cfelse><td align="center" >-</td>
                            </cfif>
                        </cfif> 
                            
                         <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L">     
							<cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                                <td align="center"><cfif LvarTotal_IBR_EO_G neq "">#LSNumberFormat((LvarTotal_IBR_EO_G/TotalLineas_G),"__________.__")#</cfif></td>
                            <cfelse><td align="center" >-</td>
                            </cfif>   
                        </cfif>  
                        
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I">    
                            <cfif CMTOimportacion eq 1 or #Form.Tipo# eq "T">
                                <td align="center"><cfif LvarTotal_IBRI_EO_G neq "">#LSNumberFormat((LvarTotal_IBRI_EO_G/TotalLineas_G),"__________.__")#</cfif></td>
                             <cfelse><td align="center" >-</td>
                            </cfif>
                       </cfif>     
                       <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                            <cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                                <td align="center"><cfif LvarTotal_IBR_IBP_G neq "">#LSNumberFormat((LvarTotal_IBR_IBP_G/TotalLineas_G),"__________.__")#</cfif></td>
                            <cfelse>
                                <td align="center">-</td>
                            </cfif>
                        </cfif>
                        
                        <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
                            <cfif CMTOimportacion eq 1 or #Form.Tipo# eq "T">
                                <td align="center" ><cfif LvarTotal_IBRI_IBP_G neq "">#LSNumberFormat((LvarTotal_IBRI_IBP_G/TotalLineas_G),"__________.__")#</cfif></td>
                             <cfelse>
                                <td align="center">-</td>
                            </cfif>
                        </cfif>         
                    </tr>
        <tr>
            <td colspan="#ColspanTotales_G#" align="right" class="topline"><strong>TOTALES GENERALES:&nbsp;&nbsp;&nbsp;</strong></td>
            <td align="center">#LSNumberFormat(LvarTotal_G,"__________.__")#</td>   
            <td align="center" ><cfif LvarTotal_EO_SC_G neq "">#LvarTotal_EO_SC_G#</cfif></td>
            <td align="center" ><cfif LvarTotal_EA_SC_G neq "">#LvarTotal_EA_SC_G#</cfif></td>
            <td align="center" ><cfif LvarTotal_CA_EA_G neq "">#LvarTotal_CA_EA_G #</cfif></td>
            <td align="center" ><cfif LvarTotal_EO_OC_G neq "">#LvarTotal_EO_OC_G#</cfif></td>
            <td align="center" ><cfif LvarTotal_A_B_C_G neq "">#LvarTotal_A_B_C_G#</cfif></td>
            
            <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                <cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                    <td align="center"><cfif LvarTotal_SC_IBR_G neq "">#LvarTotal_SC_IBR_G#</cfif></td>
                <cfelse><td align="center" >-</td>
                </cfif>  
            </cfif>
            
            <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 	
                 <cfif CMTOimportacion eq 1 or #Form.Tipo# eq "T">
                    <td align="center">
                        <cfif LvarTotal_SC_IBRI_G neq "">#LvarTotal_SC_IBRI_G#</cfif></td>
                 <cfelse><td align="center" >-</td>
                 </cfif>
            </cfif>
            
            <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L">    
				<cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                    <td align="center"><cfif LvarTotal_IBR_EO_G neq "">#LvarTotal_IBR_EO_G#</cfif></td>
                <cfelse><td align="center" >-</td>
                </cfif>  
            </cfif>
            
            <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 	     
				<cfif CMTOimportacion eq 1 or #Form.Tipo# eq "T">
                    <td align="center"><cfif LvarTotal_IBRI_EO_G neq "">#LvarTotal_IBRI_EO_G#</cfif></td>
                 <cfelse><td align="center" >-</td>
                </cfif>
            </cfif>
            
            <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "L"> 
                <cfif CMTOimportacion eq 0 or #Form.Tipo# eq "T">
                    <td align="center"><cfif LvarTotal_IBR_IBP_G neq "">#LvarTotal_IBR_IBP_G#</cfif></td>
                <cfelse>
                    <td align="center">-</td>
                </cfif>
            </cfif>
            
            <cfif #Form.Tipo# eq "T" or #Form.Tipo# eq "I"> 
                <cfif CMTOimportacion eq 1 or #Form.Tipo# eq "T">
                    <td align="center" ><cfif LvarTotal_IBRI_IBP_G neq "">#LvarTotal_IBRI_IBP_G#</cfif></td>
                 <cfelse>
                    <td align="center">-</td>
                </cfif>
            </cfif>           
        </tr> 
       <!--- -----------------Limpieza del Totales Generales--------------------->
		<cfset LvarTotal_EO_SC_G = 0> 		<cfset LvarTotal_CA_EA_G = 0> 
        <cfset LvarTotal_EO_OC_G = 0>		<cfset LvarTotal_A_B_C_G = 0>
        <cfset LvarTotal_SC_IBR_G = 0> 		<cfset LvarTotal_IBR_EO_G = 0>
		<cfset LvarTotal_IBR_IBP_G = 0>		<cfset LvarTotal_IBRI_EO_G = 0>
        <cfset LvarTotal_IBRI_IBP_G = 0> 	<cfset LvarTotal_SC_IBRI_G = 0>  
        <cfset LvarTotal_G = 0>					<cfset LvarTotal_EA_SC_G = 0>
        <cfset TotalLineas_G = 0>        
        <cfset contDetalle = contDetalle+3>
        <!--- -----------------------------------------------------------------------> 
    </cfoutput>
                    <tr><td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">&nbsp;</td></tr>
                	<tr><td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">----------------- Fin del Reporte -----------------</td></tr>    
                <cfelse>
                	<tr><td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">&nbsp;</td></tr>
                	<tr><td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">----------------- No se encontrar&oacute;n Datos -----------------</td></tr>    
               </cfif>     
     </tr>
    </table>
 
 <script language=javascript>
		function ventanaSecundaria(indice){
			var OC =  indice;
			window.open('../consultas/OrdenesPendientesDetalleOC.cfm?OC='+OC,"ventana1","width=1000,height=700,top=120,left=200,scrollbars=yes")
		}
		function funcShowSolicitud(numSolicitud,Estado)
		{
			var SC =  numSolicitud;
			window.open("../consultas/MisSolicitudes-vista.cfm?&ESidsolicitud="+numSolicitud+"&ESestado="+Estado,20,20,950,600);
		}
    </script>  

<cffunction name="LineasProveedor" access="private" returntype="numeric">
	<cfargument name="SNidentificacion" type="string" required="yes">
    <cfargument name="CMTOcodigo" type="string" required="yes">
    <cfquery dbtype="query" name="rsLineas">
    	SELECT DOlinea
        FROM rsDatos
        WHERE SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.SNidentificacion)#">
            AND CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Arguments.CMTOcodigo)#">
    </cfquery>
    
	<cfset LvarLineas = rsLineas.recordcount>
    <cfreturn LvarLineas>
</cffunction>

<cffunction name="OrdenesProveedor" access="private" returntype="numeric">
	<cfargument name="SNidentificacion" type="string" required="yes">
    <cfargument name="CMTOcodigo" type="string" required="yes">
    <cfquery dbtype="query" name="rsOrdenes">
    	SELECT DISTINCT EOnumero
        FROM rsDatos
        WHERE SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.SNidentificacion)#">
            AND CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Arguments.CMTOcodigo)#">
    </cfquery>
	<cfset LvarOrdenes = rsOrdenes.recordcount>
    <cfreturn LvarOrdenes>
</cffunction>