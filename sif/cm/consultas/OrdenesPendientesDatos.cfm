<cf_templatecss>
 <table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
  <tr> 
    <td alig="left">
        <cf_htmlReportsHeaders 
            irA="OrdenesPendientes.cfm"
            FileName="OrdenesPendientesComprador_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls"
            title="Reporte Estadisticas Comprador Resumido"
            print="true">	
     </td>
     <!--- <td width="7%">       
        <cf_rhimprime datos="/sif/cm/consultas/OrdenesSurtidasComprador-form.cfm" paramsuri="#Param#">
    </td>   --->
  </tr>
</table>
	<cfset comp1  = "">
	<cfset comp2  = "">
    <cfset Param  = "">
    <cfset contador = 0>
    <cfset maxRows = 25>
    <cfset LvarEOestado = 10>
    <cfset LvarCFid = "">
    
<cfif isdefined('url.CMCid1') and len(trim(#url.CMCid1#))>
     <cfset form.CMCid1 = url.CMCid1>
</cfif>
<cfif isdefined('url.CMCid2') and len(trim(#url.CMCid2#))>
    <cfset form.CMCid2 = url.CMCid2>
</cfif>
<cfif isdefined('url.CMSid') and len(trim(#url.CMSid#))>
    <cfset form.CMSid = url.CMSid>
</cfif>

<cfif isdefined('form.CMCid1') and len(trim(#form.CMCid1#))>
   <cfset comp1 = form.CMCid1>
   <cfset Param = Param & "&CMCid1="&#form.CMCid1#> 
</cfif>
<cfif isdefined('form.CMCid2') and len(#form.CMCid2#)>
   <cfset comp2  = form.CMCid2>  
   <cfset Param = Param & "&CMCid2="&#form.CMCid2#>
</cfif>
<cfif isdefined('form.EcodigoE') and len(#form.EcodigoE#)>
   <cfset EcodigoE  = form.EcodigoE>  
   <cfset Param = Param & "&EcodigoE="&#form.EcodigoE#>
</cfif>


<!--- URL --->
<cfif isdefined('url.EcodigoE')  and len(trim(#url.EcodigoE#))>
	<cfset LvarEcodigoE = #url.EcodigoE#>
    <cfset form.EcodigoE = #url.EcodigoE#>
	<cfset Param = Param & "&EcodigoE="&#LvarEcodigoE#> 
</cfif>

<cfif isdefined('url.EOestados')  and len(trim(#url.EOestados#))>
	<cfset LvarEOestado = #url.EOestados#>
    <cfset form.EOestado = #url.EOestados#>
	<cfset Param = Param & "&EOestados="&#LvarEOestado#> 
</cfif>

<cfif isdefined('url.EOestados')  and len(trim(#url.EOestados#))>
	<cfset LvarEOestado = #url.EOestados#>
    <cfset form.EOestado = #url.EOestados#>
	<cfset Param = Param & "&EOestados="&#LvarEOestado#> 
</cfif>

<cfif isdefined('url.CFid') and  len(trim(#url.CFid#))>
	<cfset LvarCFid = #url.CFid# >
	<cfset form.CFid = #url.CFid# >
	<cfset Param = Param & "&CFid="&#url.CFid#> 
 </cfif>
 
<!--- FORM --->
<cfif isdefined('form.EOestados') >
	<cfset LvarEOestado = #form.EOestados#>
    <cfset Param = Param & "&EOestados="&#LvarEOestado#> 
</cfif>
<cfif isdefined('form.CFid') and #form.CFid# neq "">
	<cfset LvarCFid = #form.CFid# >
	<cfset Param = Param & "&CFid="& #form.CFid#> 
 </cfif>
 
 
<style type="text/css">
.tituloEmpresa
{
	font-family:Times New Roman, Times, serif; 
	font-size:17pt; 
	font-variant:small-caps; 
	font-weight:bolder; 
	padding-left:7px;	
	font-weight:bold;
}
.TituloPrinc 
{
font-weight: bold;
font-size: 15px;
}
</style>
<style type="text/css">
.TituloBarras 
{
font-weight: bold;
font-size: 14px;
}
</style>
<cf_dbfunction name="to_char" args="eo.EOnumero" returnvariable="EOnumero">
<cf_dbfunction name="to_char" args="eo.Ecodigo" returnvariable="Ecodigo">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return ventanaSecundaria('+ #PreserveSingleQuotes(EOnumero)# +','+ #PreserveSingleQuotes(Ecodigo)# +');''>'" returnvariable="OC" delimiters="+">

	<cfset LvarAplicadaT = 0>
    <cfset LvarAplicadaP = 0>
    <cfset LvarCanTOC = 0>
    <cfset LvarGrupo = 0>  
    <cfif isdefined('form.EOestados')>	
    	<cfset listaForm = #Form.EOestados#>
    <cfelseif isdefined('url.EOestados')>
    	 <cfset listaForm = #url.EOestados#>   
    </cfif>
    
	 <cfif isdefined('form.EOestados') or isdefined('url.EOestados')>	
        <cfloop index="i" list="#listaForm#" delimiters=",">
            <cfif i eq 10>
            	 <cfset LvarAplicadaT = 1>
            <cfelseif i eq 11>     
            	<cfset LvarAplicadaP= 1>
            <cfelseif i eq 99>     
            	<cfset LvarGrupo = 1>    
            </cfif>
           <cfset LvarCanTOC = LvarCanTOC+1> 
        </cfloop>
		<cfif LvarAplicadaT eq 1 and LvarAplicadaP eq 1>
        	<cfset LvarEstados = "AND eo.EOestado in (#listaForm#)">
        <cfelseif LvarAplicadaT eq 1>    
            <cfset LvarEstados = "AND eo.EOestado in (#listaForm#) 
											 AND do.DOcantsurtida  = do.DOcantidad
											 	OR coalesce(dcxp.DDcantidad,dcp.DDcantidad,hdcp.DDcantidad) >= do.DOcantidad
											AND NOT do.DOcantsurtida > do.DOcantidad	
											  "> 
        <cfelseif LvarAplicadaP eq 1>
            <cfset LvarEstados = "AND eo.EOestado in (10,#listaForm#) AND do.DOcantsurtida  < do.DOcantidad"> 
        <cfelseif LvarGrupo eq 1>
            <cfset LvarEstados = "	AND eo.EOestado in (10,-10,-7,0,5,7,8,9,#listaForm#) 
												AND do.DOcantsurtida  <> do.DOcantidad
												and not do.DOcantsurtida > do.DOcantidad"> 
		 <cfelse>
        	<cfset LvarEstados = "AND eo.EOestado in (#listaForm#)">
        </cfif>
    </cfif> 
    
    <!--- Empresas --->
    <cfquery datasource="#session.DSN#" name="rsEmpresa">
        select Edescripcion from Empresas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
    
    <cf_dbdatabase name ="database" table="ETrackingItems" datasource="sifpublica" returnvariable="EtrackingitemsTable">
    <cf_dbdatabase name ="database" table="ETracking" datasource="sifpublica" returnvariable="EtrackingTable">
    <cf_dbdatabase name ="database" table="DTracking" datasource="sifpublica" returnvariable="DtrackingTable">
    <cf_dbdatabase name ="database" table="CMActividadTracking" datasource="sifpublica" returnvariable="ActividadTrackingTable">
    <cfquery name="rsDatos" datasource="#session.dsn#">

        SELECT  DISTINCT
                    cmc.CMCcodigo,
                    cmc.CMCnombre as comprador,                      
                    eo.EOnumero,
                    #PreserveSingleQuotes(OC)# as ver,         
                   cf.CFdescripcion,
                   do.DOdescripcion as item,
                   cf.CFid,
                   sn.SNnombre as Proveedor,
                   es.ESnumero,
                   es.ESidsolicitud,
                   eo.Ecodigo,
                   do.DOconsecutivo,
                   do.DOfechaes,
                   do.DOcantsurtida,
                   do.DOcantidad,
                   es.ESfechaAplica,
                   eo.EOfecha,            
                   es.ESestado,
                   CASE eo.EOestado 
                            when -10 then 'Pendiente de Aprobación Presupuestaria'
                            when -8 then 'Orden Rechazada'
                            when -7 then 'En Proceso de Aprobación'
                            when 0 then 'Pendiente'
                            when 5 then 'Pendiente Vía Proceso'
                            when 7 then 'Pendiente OC Directa'
                            when 8 then 'Pendiente Vía Contrato'
                            when 9 then 'Autorizada por jefe Compras'
                            when 10 then 'A'
                            when 55 then 'Ordenes Canceladas, Surtidas Parcialmente'
                            when 60 then 'Ordenes Canceladas'
                            when 70 then 'Ordenes Anuladas'
                        end  as EstadoOC,
                   eo.EOFechaAplica,
                    CASE eto.CMTOimportacion 
                        WHEN 1 THEN 'E' 
                        WHEN 0 THEN 'L' 
                        ELSE  '	' 
                    END AS LugarEmision,
                   <cf_dbfunction name="datediff"  args=" es.ESfechaAplica| eo.EOfecha" delimiters="|"> as SCOC,
                   <cf_dbfunction name="datediff"  args=" es.ESfechaAplica| eo.EOFechaAplica" delimiters="|">  as SCOCEnv,   
                   <cf_dbfunction name="datediff"  args="do.DOfechaes, #Now()#">  as H_FEE,   
                   CASE eto.CMTOimportacion 
                   		when 0 then COALESCE(ecxp.EDfechaarribo, ecp.Dfechaarribo, hecp.Dfechaarribo)
                   		when 1 	then dt.DTfechaactividad
                    end as fechaEntrega     
        
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
              
              LEFT  JOIN DDocumentosCP dcp 
                    ON dcp.DOlinea = do.DOlinea 
              
              LEFT  JOIN EDocumentosCP ecp 
                    ON ecp.IDdocumento = dcp.IDdocumento 
              
              LEFT  JOIN HDDocumentosCP hdcp 
                    ON hdcp.DOlinea = do.DOlinea 
              
              LEFT  JOIN HEDocumentosCP hecp 
                    ON hecp.IDdocumento = hdcp.IDdocumento 
              
              LEFT  JOIN #EtrackingitemsTable# eti 
                    ON eti.Ecodigo = do.Ecodigo 
                    AND eti.DOlinea = do.DOlinea
              
              LEFT  JOIN #EtrackingTable# et 
                   ON et.ETidtracking = eti.ETidtracking
                   AND et.Ecodigo =eti.Ecodigo 
               
               LEFT  JOIN #DtrackingTable# dt 
                     INNER JOIN #ActividadTrackingTable# atk 
                      ON atk.CMATid = dt.CMATid 
                      AND atk.Ecodigo = dt.Ecodigo 
                      AND atk.ETA_R = 1  
                 ON dt.ETidtracking = et.ETidtracking 
                 AND dt.Ecodigo = et.Ecodigo
    
        WHERE <cfif isdefined('form.EcodigoE') and form.EcodigoE eq -2>
        				eo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                     <cfelse>
                     	eo.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoE#" list="yes">)
                     </cfif>   
        	#LvarEstados#
			<!--- Filtro por Solicitante --->
			<cfif isdefined('form.CMSid') and len (trim(form.CMSid))>
					and es.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">   
			</cfif> 
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
                	and eo.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha1#">
                	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
                
           <cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
                and eo.EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.fechaDes)#">
           <cfelseif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
                <cfset LvarFecha2 =  lsparsedatetime(form.fechaHas)>
                <cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
                and eo.EOfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
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
	 <cfif isdefined('LvarCFid') and #LvarCFid# neq "">
        	and cf.CFid = #LvarCFid#
     </cfif>   
       order by  CMCcodigo, Proveedor, DOfechaes
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
          
<cfset contDetalle = 0>      
<cfset LvarEstado = rsDatos.ESestado>

<cfset imprimeEncabezado()>
<cffunction name="imprimeEncabezado" output="yes">

<cfset LvarColspanTamaño = 13>
<cfif isdefined('LvarCFid') and #LvarCFid# eq "" and isdefined('form.verCantidades')>
	<cfset LvarColspanTamaño = 14>
<cfelseif isdefined('LvarCFid') and #LvarCFid# eq "" or isdefined('form.verCantidades')>
	<cfset LvarColspanTamaño = 13>
</cfif>

    <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td  class="tituloEmpresa" align="center" colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>">#rsEmpresa.Edescripcion#</td>
        </tr>
        <tr>
            <td colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>" align="center">
              <strong class="TituloPrinc">Ordenes de Compra <br /> por Comprador según Estados de la OC</strong>
            </td>
        </tr>
		<cfif LvarCanTOC eq 1>
            <tr>
                <td colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>" align="center"><strong>Estado de la Orden:&nbsp;</strong>
                    <cfswitch expression="#LvarEOestado#">
                        <cfcase value="-10">Pendiente de Aprobación Presupuestaria</cfcase>
                        <cfcase value="-8">Orden Rechazada</cfcase>
                        <cfcase value="-7">En Proceso de Aprobación</cfcase>
                        <cfcase value="0">Pendiente</cfcase>
                        <cfcase value="5">Pendiente Vía Proceso</cfcase>
                        <cfcase value="7">Pendiente OC Directa</cfcase>
                        <cfcase value="8">Pendiente Vía Contrato</cfcase>
                        <cfcase value="9">Autorizada por jefe Compras</cfcase>
                        <cfcase value="10">Aplicadas, Totalmente Surtidas</cfcase>
                        <cfcase value="11">Aplicadas, Surtidas Parcialmente</cfcase>
                        <cfcase value="55">Ordenes Canceladas, Surtidas Parcialmente</cfcase>
                        <cfcase value="60">Ordenes Canceladas</cfcase>
                        <cfcase value="70">Ordenes Anuladas</cfcase>
                        <cfcase value="99">Grupo de Estados</cfcase>
                    </cfswitch>
               </td>     
            </tr>
        </cfif>
        <cfif isdefined('LvarCFid') and #LvarCFid# neq "">
             <tr>
                <td colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>" align="center"><strong>Centro Funcional:&nbsp;</strong>
                       #rsDatos.CFdescripcion#
                </td>
            </tr>
		</cfif>  
        <tr>
            <td colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>" align="center">
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
             <tr><td colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>" align="center">&nbsp;</td>
            </tr>
            <tr>
            	<cfif LvarCanTOC gt 1 or LvarEOestado eq 99>
                	<td width="7%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>Estado OC</strong></td> 
                </cfif>
                <td width="5%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>Orden</strong></td>
              
                <cfif isdefined('LvarCFid') and #LvarCFid# eq "">
                	<td width="16%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>Centro Funcional</strong></td>
              	</cfif>  
                <td width="18%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>Articulo</strong></td>
				<td width="4%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>Lin</strong></td>
                <td width="5%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>Sol</strong></td>
                <cfif isdefined('form.verCantidades')>
                    <td width="4%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>Cant</strong></td>
                    <td width="4%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>Cant Surtida</strong></td> 
				</cfif>
                <td width="6%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>F Aprob. Solicitud</strong></td>      
                <td width="6%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>F Orden Compra</strong></td>      
                <td width="6%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>F Aplica OC</strong></td>
                <td width="6%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>F Esti. Entrega</strong></td>
                <td width="6%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-left:1px solid lightgray;"><strong>F de Arribo</strong></td>
                <td width="5%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-right:1px solid lightgray; border-left:1px solid lightgray;"><strong>SC-OC</strong></td>      
                <td width="5%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-right:1px solid lightgray;"><strong>SC-OC  Aprob. </strong></td>            
				<td width="5%" align="center" valign="top" style="border-bottom:1px solid lightgray;  border-top:1px solid lightgray;  border-right:1px solid lightgray;"><strong>Hoy - F Entrega</strong></td>            
            </tr>
             <tr>
                <td colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>" align="center">&nbsp;
                </td>
            </tr>
</cffunction>
  <cfset LvarCcompradorAnt = "">
  <cfset LvarCFAnt = "">
  <cfoutput query="rsDatos" group="comprador"> 
   <cfoutput group="Proveedor">
			<cfset contDetalle = contDetalle+3>     
            <cfif (isdefined("Url.imprimir") and contDetalle GTE maxRows)>
                </table>
                <BR style="page-break-after:always;">
                <cfset imprimeEncabezado()>
                <cfset contDetalle = 3> 
            </cfif> 
                <cfif contador eq 0>
					<cfif LvarCcompradorAnt neq CMCcodigo>
                          <tr> 
                                <td colspan="14"  class="tituloAlterno">#CMCcodigo# - #comprador#</td>       
                      </tr>
                    <tr><td colspan="14" align="center">&nbsp;</td></tr>
                    <cfset LvarCcompradorAnt = "#CMCcodigo#">
				</cfif>
                    <tr>
                        <td colspan="14" align="left"><strong>Proveedor: </strong>&nbsp;#Proveedor#</td>
                    </tr>
                     <tr>
                        <td colspan="14" align="center">&nbsp;
                    </td>
                </tr>
                </cfif>
               <cfoutput> 
                <cfset contDetalle = contDetalle+1>     
                <cfif (isdefined("Url.imprimir") and contDetalle GTE maxRows)>
                    </table>
                    <BR style="page-break-after:always;">
                    <cfset imprimeEncabezado()>
                    <cfset contDetalle = 3> 
                </cfif> 
                <tr> 
                	<cfif LvarCanTOC gt 1 or LvarEOestado eq 99>
                        <td align="center" style="font-size:11px">
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
                    </cfif>
                    <td align="center">#ver##EOnumero#</td>
					<cfif isdefined('LvarCFid') and #LvarCFid# eq "">
                    	<td align="center">#CFdescripcion#</td>
                    </cfif>  
                    <td align="center" ><p align="center">#item#</p></td>
                    <td align="center" ><p align="center">#LugarEmision#-#DOconsecutivo#</p></td>
                    <td align="center" ><a href="javascript:funcShowSolicitud('#ESidsolicitud#','#Ecodigo#')">#ESnumero#</a></td>
                   <cfif isdefined('form.verCantidades')>
                        <td align="center" ><p align="center">#DOcantidad#</p></td>
                        <td align="center" ><p align="center">#DOcantsurtida#</p></td>
					</cfif>
                    <td align="center" >#DateFormat(ESfechaAplica,'dd/mm/yy')#</td>      
                    <td align="center" >#DateFormat(EOfecha,'dd/mm/yy')#</td>      
                    <td align="center" >#DateFormat(EOFechaAplica,'dd/mm/yy')#</td>                
                    <td align="center" >#DateFormat(DOfechaes,'dd/mm/yy')#</td>
					<td align="center" ><cfif #fechaEntrega# neq ""> #DateFormat(fechaEntrega,'dd/mm/yy')#	</cfif></td>       
                     <td align="center"><cfif #SCOC# neq "">#SCOC#<cfelse>&nbsp;&nbsp;</cfif></td>      
                    <td align="center" ><cfif #SCOCEnv# neq "">#SCOCEnv#<cfelse>&nbsp;&nbsp;</cfif></td>            
                    <td align="center" ><cfif #H_FEE# neq "">#H_FEE#<cfelse>&nbsp;&nbsp;</cfif></td>            
                </tr>    
               </cfoutput> 
               <tr>
                     <td colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>">&nbsp;</td>
               </tr>
     </cfoutput>         
 </cfoutput> 
     <cfif rsDatos.recordcount eq 0>
      <tr>
          <td colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>" align="center">
      			 --------------------------------     No se encontraron datos    ---------------------------------
          </td> 
     </tr>
     </cfif>
      <tr>
          <td colspan="<cfoutput>#LvarColspanTamaño#</cfoutput>" align="center">
            	----------------------------------------   Fin del reporte   ----------------------------------------------
          </td> 
     </tr>
</table>   
    
<script language=javascript>
function ventanaSecundaria(indice, ecodigo){
			var OC =  indice;
			window.open('../consultas/OrdenesPendientesDetalleOC.cfm?OC='+OC+'&Ecodigo='+ecodigo,"ventana1","width=1000,height=700,top=120,left=200,scrollbars=yes")
		}
function funcShowSolicitud(numSolicitud,ecodigo)
{
		var SC =  numSolicitud;
		window.open("../consultas/MisSolicitudes-vista.cfm?&ESidsolicitud="+numSolicitud+'&Ecodigo='+ecodigo+"&ESestado="+<cfoutput>#LvarEstado#</cfoutput>20,20,950,600);
}
</script>    



  