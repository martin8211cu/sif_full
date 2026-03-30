<cfset eo1  = "">
<cfset eo2  = "">
<cfset eon1  = "">
<cfset eon2  = "">

<cfif isdefined('form.EOidorden1') and len(trim(#form.EOidorden1#))>
   <cfset eo1 = form.EOidorden1>
</cfif>

<cfif isdefined('form.EOidorden2') and len(#form.EOidorden2#)>
   <cfset eo2  = form.EOidorden2>  
</cfif>

<cfif isdefined('form.CFid') and #form.CFid# neq "">
	<cfset LvarCFid = #form.CFid# >
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
 
<!--- Empresas --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif len(trim(#eo1#)) gt 0 and  len(trim(#eo2#)) gt 0> 
   <cfquery name="rsRango1" datasource="#session.dsn#">
	 select EOnumero as EO1 from EOrdenCM  
     where Ecodigo = #session.Ecodigo#
     	and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#eo1#">
   </cfquery>
	 <cfquery name="rsRango2" datasource="#session.dsn#">
         select EOnumero as EO2 from EOrdenCM  
         where Ecodigo = #session.Ecodigo#
            and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#eo2#">
   </cfquery>
  <cfelseif len(trim(#eo1#)) gt 0 >  
	  <cfquery name="rsRango1" datasource="#session.dsn#">
         select EOnumero as EO1 from EOrdenCM  
         where Ecodigo = #session.Ecodigo#
            and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#eo1#">
   </cfquery>
 <cfelseif len(trim(#eo2#)) gt 0>  
	<cfquery name="rsRango2" datasource="#session.dsn#">
         select EOnumero as EO2 from EOrdenCM  
         where Ecodigo = #session.Ecodigo#
            and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#eo2#">
   </cfquery>
 </cfif>

<cf_dbfunction name="to_char" args="do.DOconsecutivo" returnvariable="Linea">
<cf_dbfunction name="to_char" args="eo.EOnumero" returnvariable="EOnumero">
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cf_dbfunction name="to_char" args="eo.Ecodigo" returnvariable="Ecodigo">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return ventanaSecundaria('+ #PreserveSingleQuotes(EOnumero)# +','+ #PreserveSingleQuotes(Ecodigo)# +');''>'" returnvariable="OC" delimiters="+">
<cfquery name="rsDatos" datasource="#session.dsn#">
    SELECT 
     	#PreserveSingleQuotes(OC)# as ver, 
        eo.EOfecha as FechaOC,
        eo.EOnumero as Orden,
        es.ESnumero as Solicitud,
        cf.CFcodigo#_Cat#'-'#_Cat#cf.CFdescripcion as Departamento,
        sn.SNcodigo,
        eo.Ecodigo,
        sn.SNnombre as SNombre,
        LTRIM(cmc.CMCnombre) AS Comprador,
        <cf_dbfunction name='sPart' args='do.DOdescripcion|1|20' delimiters='|'> #_Cat# case when <cf_dbfunction name="length" args="do.DOdescripcion"> > 20 then '...' else '' end as Articulo,
        <cf_dbfunction name='sPart' args='do.DOalterna|1|15' delimiters='|'> #_Cat# case when <cf_dbfunction name="length" args="do.DOalterna"> > 15 then '...' else '' end as DescripcionD,
        do.DOalterna,
        do.DOdescripcion,
        do.DOpreciou as CostoUnitario,
        m.Miso4217 as Moneda,
        m.Msimbolo as Simbolo,
        do.DOcantidad as Cantidad,
        do.DOcantsurtida,
        do.DOtotal as TotalLinea,
        CASE eto.CMTOimportacion 
            		WHEN 1 THEN 'INTERNACIONAL' 
            		WHEN 0 THEN 'LOCAL' 
            		ELSE  '	' 
        		END AS LugarEmision,
	    #Linea# #_Cat#'-'#_Cat# CASE eto.CMTOimportacion  
                    WHEN 1 THEN 'E'  
                    WHEN 0 THEN'L'    
        end as DOconsecutivo,
        es.ESidsolicitud,
        es.ESestado,
        ts.CMTScodigo,
        case eo.EOestado 
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
                        end as EstadoOC
    
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
            ON ds.ESidsolicitud = do.ESidsolicitud
            AND ds.DSlinea = do.DSlinea
            AND ds.Ecodigo = #session.Ecodigo#
    
    	LEFT JOIN ESolicitudCompraCM es  
            ON ds.ESidsolicitud = es.ESidsolicitud
            AND es.ESidsolicitud = do.ESidsolicitud
		
        LEFT JOIN CMTiposSolicitud ts
			ON ts.CMTScodigo = es.CMTScodigo 
            AND ts.Ecodigo = es.Ecodigo
            
	WHERE eo.Ecodigo = #session.Ecodigo#
    	<cfif #Form.TipoOrden# neq "T">
                <cfif 	#Form.TipoOrden# eq "L">
                    AND eto.CMTOimportacion = 0
                </cfif>
                <cfif 	#Form.TipoOrden# eq "I">
                    AND eto.CMTOimportacion = 1
                </cfif>
            </cfif>
            
			<cfif len(trim(#eo1#)) gt 0 and  len(trim(#eo2#)) gt 0> 
				<cfif #eo1# lt #eo2#>
                	and eo.EOnumero  between #rsRango1.EO1#  and #rsRango2.EO2#
				<cfelse>
                and eo.EOnumero  between #rsRango2.EO2#  and #rsRango1.EO1#
            </cfif> 
            <cfelseif len(trim(#eo1#)) gt 0 >  
            	and eo.EOnumero =  #rsRango1.EO1#
            <cfelseif len(trim(#eo2#)) gt 0>  
            	and eo.EOnumero = #rsRango2.EO2#    
            </cfif> 
				
			<!--- filtro por palabra especifica--->
			<cfif IsDefined("form.SpecificWord") and len(trim(#form.SpecificWord#))>
				and do.DOobservaciones like 
															'%#form.SpecificWord#%'
				or do.DOalterna like 
															'%#form.SpecificWord#%'
				or eo.Observaciones like 
															'%#form.SpecificWord#%'
			</cfif>
			
            <cfif isdefined('LvarCFid') and #LvarCFid# neq "">
        		and do.CFid = #LvarCFid#
		    </cfif>
            
            <cfif isdefined("form.Rango") and form.Rango EQ 'PeriodoMes'>
            	and eo.EOfecha
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
                    and eo.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha1#">
                    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
                <cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
                	and eo.EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.fechaDes)#">
                <cfelseif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
					<cfset LvarFecha2 =  lsparsedatetime(form.fechaHas)>
                    <cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
                	and eo.EOfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
                </cfif>
            </cfif>
            
         ORDER BY Orden
</cfquery> 

<cfif isdefined("form.toExcel")>
	<cfcontent type="application/msexcel">
	<cfheader 	name="Content-Disposition" 
	value="attachment;filename=ReporteOrdenesCompra_ResumenGeneral_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
</cfif>

<cfset LvarColspan = 15>

<cfif not  isdefined("form.toExcel")>
	<cf_templatecss>
	<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
	  <tr align="left"> 
		<td><a href="/cfmx/sif/">SIF</a></td>
		<td>|</td>
		<td nowrap><a href="../MenuCM.cfm">Compras</a></td>
		<td>|</td>
		<td width="100%"><a href="../consultas/ReporteCristal.cfm">Regresar</a></td>
	  </tr>
	</table>
</cfif>	
    <table width="100%" border="0" cellpadding="1" cellspacing="1" >
    <tr> 
      <td  align="center" class="tituloAlterno" colspan="15"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="center" colspan="<cfoutput>#LvarColspan#</cfoutput>"><b>Reporte de Ordenes de Compra-Resumen General</b></td>
    </tr>
    <tr> 
       <td colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center">
            <cfif len(trim(#eo1#)) gt 0 and  len(trim(#eo2#)) gt 0 and #eo1# neq #eo2#> 
                <strong>Orden, desde:</strong> <cfoutput>#rsRango1.eo1#</cfoutput><strong>, hasta:</strong>  <cfoutput>#rsRango2.eo2#</cfoutput>
           <cfelseif len(trim(#eo1#)) gt 0 and  len(trim(#eo2#)) gt 0 and #eo1# eq #eo2#> 
                <strong>Orden:</strong> <cfoutput>#rsRango1.eo1#</cfoutput>
           <cfelseif len(trim(#eo1#)) gt 0  and len(trim(#eo2#)) eq 0 >  
                <strong>Orden:</strong> <cfoutput>#rsRango1.eo1#</cfoutput>
            <cfelseif len(trim(#eo1#)) eq 0 and len(trim(#eo2#)) gt 0 >  
                <strong>Orden:</strong> <cfoutput>#rsRango2.eo2#</cfoutput>
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
    <cfif isdefined('form.TipoOrden') and #form.TipoOrden# neq 'T'>
        <tr>
            <td  colspan="<cfoutput>#LvarColspan#</cfoutput>" align="center" style="padding-right: 20px"><b>Tipo Orden:</b>
				<cfif  #form.TipoOrden# eq 'L'>Local<cfelseif #form.TipoOrden# eq 'I'>Internacional</cfif>
			</td>
        </tr>
    </cfif>
    <tr> 
	    <td class="bottomline" colspan="13">&nbsp;</td>
    </tr>
	</table>
	<table width="100%" cellpadding="1" cellspacing="1" align="center">
            <tr>
				<!--- Mes-Fecha--->
                <td  width="8%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Mes<br />Fecha</strong></td>
                <!--- Estado OC--->
                <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"  align="center"><strong>Estado OC</strong></td>
                <!--- Orden --->
                <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"  align="center"><strong>Orden</strong></td>
                <!--- Linea --->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Linea</strong></td>
				<!--- Solicitud--->
                <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"  align="center"><strong>Sol</strong></td>
                <!--- Departamento --->
                <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"  align="center"><strong>Centro Funcional</strong></td>
                <!--- Proveedor--->
                 <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Proveedor</strong></td>  
                <!---  Moneda--->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Mon</strong></td>
                <!---Cantidad--->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Cant</strong></td>
				<!--- C/U--->
                <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Costo/U</strong></td>
                <!---  Total Linea--->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Monto Linea</strong></td>
                <!--- Clasificacion--->
				<td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Tipo</strong></td>
				<!--- Articulo--->
				<td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Descripci&oacute;n</strong></td>
				<!---Descripcion Detalla--->
                <td style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Descripci&oacute;n<br />Detallada</strong> </td>
                <!--- Comprador--->
                <td  style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black; border-right:1px solid black;" align="center"><strong>Comprador</strong></td>
     </tr>
			<cfif rsDatos.recordcount gt 0>
                <cfoutput query="rsDatos">
                        <tr>
                            <!--- Fecha--->
                            <td  align="center">#DateFormat(FechaOC,'dd-mmm-yy')#</td>
                            <td align="left" style="font-size:11px">
                                <cfif #EstadoOC# eq 'A'>
                                    <cfif DOcantsurtida eq Cantidad>
                                        A. Totalmente Surtida	
                                    <cfelse>
                                        A. Parcialmente Surtida
                                    </cfif>
                                    <cfelse>
                                        #EstadoOC#
                                </cfif>
                            </td>
                            <!--- Orden--->
                            <td  align="center">#ver##Orden#</td>
                            <!--- Linea--->
                            <td  align="center">#DOconsecutivo#</td>
                            <!--- Solicitud--->
                            <td  align="center"><a href="javascript:funcShowSolicitud('#ESidsolicitud#','#ESestado#', '#Ecodigo#')">#Solicitud#</a></td>
                            <!--- Departamento--->
                            <td  align="left" style="font-size:11px;">#Departamento#</td>
                            <!--- Proveedor --->
                            <td  align="left" style="font-size:11px;">#SNombre#</td>
                            <!---  Moneda--->
                            <td  align="right">
                                #Moneda#
                            </td>
                            <!---  Cantidad--->
                            <td  align="right">
                                #Cantidad#
                            </td>
                            <!---  CostoUnitario--->
                            <td  align="right">
                                #Simbolo#&nbsp;#CostoUnitario#
                            </td>
                            <!---  Monto Linea--->
                            <td  align="right">
                                #Simbolo#&nbsp;#TotalLinea#
                            </td>
                            <!--- Clasificacion--->
                            <td style="font-size:11px;" align="left">
                                <cfif CMTScodigo neq "">
                                     #ClasificacionArticulo(CMTScodigo)# 
                                 </cfif>    	   
                            </td>
                            <!--- Articulo--->
                            <td  style="font-size:11px;" align="left" <cfif #DOdescripcion# neq "">title="#DOdescripcion#"</cfif>>
                                <cfif not isdefined("form.toExcel")>
                                     #Articulo# 
                                 <cfelse>
                                      #DOdescripcion#
                                </cfif>     
                            </td>
                           <!--- Descripcion Detallada --->
                            <td  align="left" style="font-size:11px;" <cfif #DOalterna# neq "">title="#DOalterna#"</cfif>>
                            <cfif not isdefined("form.toExcel")>
                                 #DescripcionD#
                             <cfelse>
                                #DOalterna#    
                             </cfif>    
                            </td>
                            <!--- Comprador--->
                            <td  align="left" style="font-size:10px;">
                                #Comprador#
                            </td>
                        </tr>
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
    <cffunction access="private" name="ClasificacionArticulo" returntype="string">
    	<cfargument name="CMTScodigo" type="string" required="yes">
        <cfset LvarClasificacion ="">
			<!--- Tipos de Compra --->
        <cfquery name="rsTipos" datasource="#session.DSN#" >
            select CMTStarticulo, CMTSservicio, CMTSactivofijo, CMTSobras
            from CMTiposSolicitud
            where Ecodigo= #session.Ecodigo# 
            and CMTScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CMTScodigo)#">
        </cfquery>
        <cfif rsTipos.CMTStarticulo  eq 1>
        	<cfset LvarClasificacion = "Articulo">
        <cfelseif  rsTipos.CMTSservicio eq 1>
        	<cfset LvarClasificacion = "Servicio">     
        </cfif>    
        <cfreturn LvarClasificacion>
    </cffunction>