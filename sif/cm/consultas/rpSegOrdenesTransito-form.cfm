<cfset Param  = "">
<cfset comp1  = "">
<cfset comp2  = "">
<cfset codigoOC1  = "">
<cfset codigoOC2  = "">

<cfif isdefined('url.NumeroOC1') and len(trim(#url.NumeroOC1#))>
     <cfset form.NumeroOC1 = url.NumeroOC1>
</cfif>
<cfif isdefined('url.NumeroOC2') and len(trim(#url.NumeroOC2#))>
    <cfset form.NumeroOC2 = url.NumeroOC2>
</cfif>

<!--- Definiciòn de numeros de órdenes de compra--->
<cfif isdefined('form.NumeroOC1') and len(trim(#form.NumeroOC1#))>
	<cfset codigoOC1  = form.NumeroOC1>
   <cfset numeroOC1 = form.NumeroOC1>
</cfif>
<cfif isdefined('form.NumeroOC2') and len(#form.NumeroOC2#)>
	<cfset codigoOC2  = form.NumeroOC2>
   <cfset numeroOC2 = form.NumeroOC2> 
</cfif>

<cfif isdefined('url.CMCid1') and len(trim(#url.CMCid1#))>
     <cfset form.CMCid1 = url.CMCid1>
</cfif>
<cfif isdefined('url.CMCid2') and len(trim(#url.CMCid2#))>
    <cfset form.CMCid2 = url.CMCid2>
</cfif>

<cfif isdefined("url.fechaDes")>
	 <cfset form.fechaDes = url.fechaDes>
</cfif>

<cfif isdefined("url.fechaHas")>
	<cfset form.fechaHas = url.fechaHas>
</cfif>

<cfif isdefined('form.CMCid1') and len(trim(#form.CMCid1#))>
   <cfset comp1 = form.CMCid1>
</cfif>

<cfif isdefined('form.CMCid2') and len(#form.CMCid2#)>
   <cfset comp2  = form.CMCid2>  
</cfif>


<!--- Rango Compradores --->
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

<!--- Empresas --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cf_dbfunction name="to_char" args="eo.EOnumero" returnvariable="EOnumero">
<cf_dbfunction name="to_char" args="eo.Ecodigo" returnvariable="Ecodigo">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return ventanaSecundaria('+ #PreserveSingleQuotes(EOnumero)# +');''>'" returnvariable="OC" delimiters="+">

<!--- Tablas del esquema sifPublica --->
<cf_dbdatabase name ="database" table="ETrackingItems" datasource="sifpublica" returnvariable="EtrackingitemsTable">
<cf_dbdatabase name ="database" table="ETracking" datasource="sifpublica" returnvariable="EtrackingTable">
<cf_dbdatabase name ="database" table="DTracking" datasource="sifpublica" returnvariable="DtrackingTable">
<cf_dbdatabase name ="database" table="CMActividadTracking" datasource="sifpublica" returnvariable="ActividadTrackingTable">
<!--- Obtencion de los datos --->

<cfquery name="rsDatos" datasource="#session.dsn#">
   SELECT  
                cmc.CMCid,
                cmc.CMCcodigo#_Cat#'-'#_Cat#cmc.CMCnombre AS Comprador,
                es.ESnumero,
                es.ESidsolicitud,
                eo.Ecodigo,
                es.ESestado,
                eo.EOnumero,
                sn.SNnombre  as Proveedor,
                dt.Observaciones,
                et.ETfechamod,
                case et.ETestado when 'P' then 'En Proceso' when 'T' then 'En Tr&aacute;nsito' when 'E' then 'Entregado' end as ETestado,
                dt.DTfechaactividad,
                 #PreserveSingleQuotes(OC)# as ver,
				 dt.DTfechaactividad as ETA_A,
				 dt2.DTfechaactividad as ETS,
                 et.ETconsecutivo,
                 eo.EOFechaAplica

    FROM EOrdenCM AS eo 
       INNER JOIN DOrdenCM do 
            ON eo.EOidorden = do.EOidorden 

       
       INNER JOIN SNegocios sn 
            ON sn.SNcodigo = eo.SNcodigo 
            AND sn.Ecodigo = eo.Ecodigo
                  
       INNER JOIN CMCompradores cmc 
            ON cmc.CMCid = eo.CMCid 
                     
       INNER JOIN DSolicitudCompraCM ds 
            ON ds.DSlinea = do.DSlinea 
       
       INNER JOIN ESolicitudCompraCM es 
            ON es.ESidsolicitud = ds.ESidsolicitud 
     
      INNER JOIN #EtrackingitemsTable# eti 
            ON eti.Ecodigo = do.Ecodigo 
            AND eti.DOlinea = do.DOlinea
      
      INNER JOIN #EtrackingTable# et 
           ON et.ETidtracking = eti.ETidtracking
           AND et.Ecodigo =eti.Ecodigo 
		   
	INNER JOIN #EtrackingTable#  et2 
           ON et2.ETidtracking = eti.ETidtracking
           AND et2.Ecodigo =eti.Ecodigo   
       
       left JOIN #DtrackingTable# dt 
             INNER JOIN #ActividadTrackingTable# atk 
              ON atk.CMATid = dt.CMATid 
              AND atk.Ecodigo = dt.Ecodigo 
              AND atk.ETA_A = 1  
         ON dt.ETidtracking = et.ETidtracking 
         AND dt.Ecodigo = et.Ecodigo 
		 
	left JOIN #DtrackingTable# dt2 
			 INNER JOIN #ActividadTrackingTable# atk2 
			  ON atk2.CMATid = dt2.CMATid 
			  AND atk2.Ecodigo = dt2.Ecodigo 
			  AND atk2.ETS = 1  
		 ON dt2.ETidtracking = et2.ETidtracking 
		 AND dt2.Ecodigo = et2.Ecodigo	 

    WHERE eo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
   
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
          <!--- Búsqueda en el rango de las ordenes seleccionadas por el usuario--->
		<cfif len(trim(#codigoOC1#)) gt 0 and  len(trim(#codigoOC2#)) gt 0> 
			<cfif #codigoOC1# lt #codigoOC2#>
             and eo.EOnumero  between 
             	<cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC1#"> and 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC2#">
            <cfelse>
             and eo.EOnumero  between
               	<cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC2#"> and 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC1#">
            </cfif> 
       	<cfelseif len(trim(#codigoOC1#)) gt 0 >  
             and eo.EOnumero >=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC1#">
     	<cfelseif len(trim(#codigoOC2#)) gt 0>  
             and eo.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC2#"> 
      	</cfif>

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
    
    ORDER BY Comprador, EOnumero
</cfquery>

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

.tablaborde {	
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #CCCCCC;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #CCCCCC;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #CCCCCC;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #CCCCCC;
		
	}
	
.tituloListas{
	
	}

</style>

 <table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
  <tr> 
    <td alig="left">
        <cf_htmlReportsHeaders 
            irA="rpSegOrdenesTransito.cfm"
            FileName="ReporteSegOrdenesTransito_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls"
            title="Reporte de Seguimiento de Ordenes en Transito"
            print="true">	
     </td>
  </tr>
</table>    
<table width="100%" border="0" cellpadding="1" cellspacing="1" >
    <tr> 
      <td  align="center" class="titulo"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td align="center" colspan="11"><b>Reporte de seguimiento de &Oacute;rdenes de Compra en Tr&aacute;nsito</b></td>
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
      <tr> 
           <td colspan="10" align="center">
                <cfif len(trim(#codigoOC1#)) gt 0 and  len(trim(#codigoOC2#)) gt 0 and #codigoOC1# neq #codigoOC2#> 
                    <strong>Orden de Compra desde la </strong> <cfoutput>#numeroOC1#</cfoutput><strong>, hasta la </strong>  <cfoutput>#numeroOC2#</cfoutput>
               <cfelseif len(trim(#codigoOC1#)) gt 0 and  len(trim(#codigoOC2#)) gt 0 and #codigoOC1# eq #codigoOC2#> 
                    <strong>Orden de Compra: </strong> <cfoutput>#numeroOC1#</cfoutput>
               <cfelseif len(trim(#codigoOC1#)) gt 0  and len(trim(#codigoOC2#)) eq 0 >  
                    <strong>Desde &oacute;rden de Compra: </strong> <cfoutput>#numeroOC1#</cfoutput>
                <cfelseif len(trim(#codigoOC1#)) eq 0 and len(trim(#codigoOC2#)) gt 0 >  
                    <strong>Hasta &oacute;rden de Compra: </strong> <cfoutput>#numeroOC2#</cfoutput>
               </cfif>               
            </td>            
        </tr>
    <tr> 
        <td class="bottomline" colspan="11">&nbsp;</td>
    </tr>
</table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" >
    <tr class="tituloListas">
        <td width="7%" style="border-top:1px solid black; border-bottom:1px solid black;border-left:1px solid black; border-right:1px solid black;" align="center"><strong>OC</strong></td>
        <td width="7%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>Solicitud</strong></td>
        <td width="15%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>Proveedor</strong></td>
        <td width="20%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;"align="center"><strong>Observaciones</strong></td>
        <td width="7%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>ETS</strong></td>
        <td width="7%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>ETA OC</strong></td>
        <td width="7%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>&Uacute;ltimo Seguimiento</strong></td>
        <td width="7%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>Estado</strong></td>
        <td width="7%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>ETA Actualizado</strong></td>
    </tr>
    <cfif rsDatos.recordcount gt 0>
		<cfoutput query="rsDatos" group="Comprador">    
        	<tr><td colspan="9" class="tituloAlterno">#Comprador#</td></tr>                    
				<cfoutput group="EOnumero">
                    <tr>
                        <td align="center">#ver##EOnumero#</td>
                        <td align="center"><a href="javascript:funcShowSolicitud('#ESidsolicitud#','#ESestado#','#Ecodigo#')">#ESnumero#</a></td>
                        <td align="center">#Proveedor#</td>
                        <td align="center">#Observaciones#</td>
                        <td align="center"><cfif ETS neq "">#LSdateFormat(ETS,"dd/mm/yyyy")#<cfelse>-</cfif></td>
                        <td align="center">#LSdateFormat(EOFechaAplica,"dd/mm/yyyy")#</td>
                        <td align="center">#LSdateFormat(ETfechamod,"dd/mm/yyyy")#</td>
                        <td align="center">#ETestado#</td>
                        <td align="center"><cfif ETA_A neq "">#LSdateFormat(ETA_A,"dd/mm/yyyy")#<cfelse>-</cfif></td>
                    </tr>
            	</cfoutput>   
        </cfoutput>
        <tr><td colspan="11" align="center">----------------- Fin del Reporte -----------------</td></tr>    
      <cfelse>
        <tr><td colspan="11" align="center">&nbsp;</td></tr>
        <tr><td colspan="11" align="center">----------------- No se encontrar&oacute;n Datos -----------------</td></tr>     	  
     </cfif>
</table>
     
<script language=javascript>
		function ventanaSecundaria(indice, ecodigo){
			var OC =  indice;
			window.open('../consultas/OrdenesPendientesDetalleOC.cfm?OC='+OC,"ventana1","width=1000,height=700,top=120,left=200,scrollbars=yes")
		}
		function funcShowSolicitud(numSolicitud,Estado,ecodigo)
		{
			var SC =  numSolicitud;
			window.open("../consultas/MisSolicitudes-vista.cfm?&ESidsolicitud="+numSolicitud+'&Ecodigo='+ecodigo+"&ESestado="+Estado,20,20,950,600);
		}
</script>  