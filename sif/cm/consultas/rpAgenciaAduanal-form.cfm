<!--- Empresas --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Agencia Aduanal --->
<cfif isdefined('form.fCMAAid') and len(trim(form.fCMAAid)) gt 0>
    <cfquery name="rsCMAgenciaAduanal" datasource="#session.DSN#" >
        select CMAAdescripcion 
        from CMAgenciaAduanal
        where Ecodigo =  #session.Ecodigo# 
            and  CMAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.fCMAAid)#"> 
        order by CMAAcodigo, CMAAdescripcion 
    </cfquery>
</cfif>

<!--- Aduana --->
<cfif isdefined('form.fCMAid') and len(trim(form.fCMAid)) gt 0>
    <cfquery name="rsCMAduanas" datasource="#session.DSN#" >
        select CMAdescripcion  
        from CMAduanas
        where Ecodigo =  #session.Ecodigo#  
            and CMAid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.fCMAid)#">
        order by CMAcodigo, CMAdescripcion 
    </cfquery>
</cfif>
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">   
<cf_dbdatabase name ="database" table="ETracking" datasource="sifpublica" returnvariable="EtrackingTable">
<cf_dbdatabase name ="database" table="DTracking" datasource="sifpublica" returnvariable="DtrackingTable">
<cf_dbdatabase name ="database" table="CMActividadTracking" datasource="sifpublica" returnvariable="ActividadTrackingTable">
<cfquery name="rsDatos" datasource="#session.dsn#">
    Select  distinct     
                    et.ETconsecutivo as NumTracking,	
                    p.EPDnumero,	
                    do.EOnumero,
                    ad.CMAdescripcion as Aduana,
                    ag.CMAAid,
                    ag.CMAAdescripcion as Agencia_Aduanal,	      
                    b.DTfechaincidencia as DO,
                    a.DTfechaincidencia as ETA_REAL,
                    p.EPDfecha as FD,
                    ec.EDfecha as FA,
                    datediff(dd,b.DTfechaincidencia,a.DTfechaincidencia) as DO_FR,
                    datediff(dd,p.EPDfecha,b.DTfechaincidencia) as FD_DO,
                    datediff(dd,ec.EDfecha,p.EPDfecha) as FA_FD,
                    datediff(dd,dr.fechaalta, ec.EDfecha) as FC_FA,
                    cmc.CMCnombre AS Comprador
    
    from #DtrackingTable# a
            inner join #DtrackingTable# b
                  on a.ETidtracking = b.ETidtracking
    
            inner join #ActividadTrackingTable# atk
                     on atk.CMATid      	= a.CMATid
                       and atk.Ecodigo  	= a.Ecodigo
                   and atk.ETA_R			= 1
    
            inner join #ActividadTrackingTable# atk1
                     on atk1.CMATid     	= b.CMATid
                       and atk1.Ecodigo 	= b.Ecodigo
                   and atk1.CMATFDO		= 1
    
            inner join #EtrackingTable# et          
                     on et.ETidtracking 	= a.ETidtracking
    
            inner join EPolizaDesalmacenaje p
                     on p.EPembarque    = convert(char, et.ETidtracking)
                    and p.Ecodigo       	= et.Ecodigo
    
            inner join DPolizaDesalmacenaje dpd          
                     on dpd.EPDid   	= p.EPDid
                    and dpd.Ecodigo 	= p.Ecodigo
                    
			left join EDocumentosRecepcion dr
            	on dr.EPDid =  p.EPDid
                and dr.Ecodigo = p.Ecodigo
			
            inner join CMAgenciaAduanal ag                
                     on p.CMAAid    = ag.CMAAid                  
                    and p.Ecodigo   = ag.Ecodigo
    
            inner join CMAduanas ad                
                     on p.CMAid     		= ad.CMAid                  
                    and p.Ecodigo   	= ad.Ecodigo        
    
            inner join DOrdenCM do          
                     on do.DOlinea = dpd.DOlinea
            
            inner join EOrdenCM eo
            	on eo.EOidorden = do.EOidorden         
                     
            inner join DDocumentosI  di
                on di.DOlinea   		= do.DOlinea
                and di.Ecodigo  	= do.Ecodigo
                
            inner join EDocumentosI ed
                on ed.EDIid     		= di.EDIid 
                and ed.Ecodigo  	= di.Ecodigo
            
            left join EDocumentosCxP ec
                on ec.EDdocumento   	= ed.Ddocumento
                and ec.Ecodigo      		= ed.Ecodigo
                and ec.CPTcodigo    		= ed.CPTcodigo
                and ec.SNcodigo     		= ed.SNcodigo
                
            left join CMCompradores cmc 
                on cmc.CMCid = eo.CMCid 
            
    where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    	
		<!--- Filtro de la Agencia Aduanal --->
		<cfif isdefined('form.fCMAAid') and len(trim(form.fCMAAid)) gt 0>
        	<cfif form.fCMAAid neq 0>
            	and ag.CMAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.fCMAAid)#">
            </cfif>
        </cfif>
        <!--- Filtro Aduana --->
        <cfif isdefined('form.fCMAid') and len(trim(form.fCMAid)) gt 0>
        	<cfif form.fCMAid neq 0>
            	and ad.CMAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.fCMAid)#">
            </cfif>
        </cfif>
	order by Agencia_Aduanal, Aduana, EPDnumero
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

</style>
 <table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
  <tr> 
    <td alig="left">
        <cf_htmlReportsHeaders 
            irA="rpAgenciaAduanal.cfm"
            FileName="ReporteAgenciaAduanal_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls"
            title="Reporte de Agencias Aduanales"
            print="true">	
     </td>
  </tr>
</table>    
<table width="100%" border="0" cellpadding="1" cellspacing="1" >
    <tr> 
      <td  align="center" class="titulo"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td align="center" colspan="11"><b>Reporte de Agencia Aduanal</b></td>
    </tr>
    <tr> 
       <td colspan="11" align="center">
                       
        </td>
    </tr>
	  <cfoutput> 
            <cfif isdefined('form.fCMAAid') and len(trim(form.fCMAAid)) gt 0>
                <tr><td  align="center" colspan="11"><strong>Agencia Aduanal</strong><font size="3">&nbsp;#rsCMAgenciaAduanal.CMAAdescripcion #</font></td>
            </cfif>
            <cfif isdefined('form.fCMAid') and len(trim(form.fCMAid)) gt 0 and #form.fCMAid# neq 0>
                <tr><td  align="center" colspan="11"><strong>Aduana:</strong><font size="3">&nbsp;#rsCMAduanas.CMAdescripcion#</font></td>
            </cfif>
            
        </cfoutput>     
       <tr>
        <td colspan="">
            <table width="70%" class="tablaborde" align="center" border="0" cellpadding="2" cellspacing="0" bgcolor="#F5F5F5">	
                <tr>
                    <td align="center"  colspan="11">
                        <p align="justify">
                            Definici&oacute;n de las abreviaciones utilizadas: 
                                <strong>FR:&nbsp;</strong>&nbsp;ETA real,
                                <strong>FD</strong>:&nbsp;Fecha DUA, <!--- fecha en que la aduana da luz verde al desalmacenaje de la mercader&iacute;a, --->
                                <strong>DO:</strong> &nbsp; Fecha de Env&iacute;o de los Documentos, <!--- fecha en que se le proporciona los documentos a la agencia aduanal, o cuando se da la instrucci&oacute;n de que inicie el desalmacenaje, --->
                                <strong>FA:</strong> &nbsp; Fecha de recibo de la Factura de la Agencia, <!--- fecha en que se recibe la factura de agencia, --->
                                <strong>FC:</strong> &nbsp;Fecha de Cierre de la Poliza,
                                <strong>DO-FR:</strong> &nbsp; Tiempo de movilizaci&oacute;n a almac&eacute;n Fiscal,
                                <strong>FD-DO:</strong>&nbsp;Tiempo de Desalmacenaje,
                                <strong>FA-FD:</strong>&nbsp;Tiempo de entrega de Facturas,
                                <strong>FC-FA:</strong>&nbsp; Tiempo de Cierre de la Poliza
                        </p>
                    </td>	
                </tr>
            </table>	
        </td>
    </tr>
    <tr> 
        <td class="bottomline" colspan="11">&nbsp;</td>
    </tr>
</table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" >
    <tr class="tituloListas">
        <td width="7%" style="border-top:1px solid black; border-bottom:1px solid black;border-left:1px solid black; border-right:1px solid black;" align="center"><strong>OC</strong></td>
        <td width="15%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>DUA</strong></td>
        <td width="20%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>Comprador</strong></td>
        <td width="6%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>FR</strong></td>
        <td width="6%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;"align="center"><strong>DO</strong></td>
        <td width="6%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>FD</strong></td>
        <td width="6%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>FA</strong></td>
        <td width="6%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>DO-FR</strong> </td>
        <td width="6%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>FD-DO</strong></td>
        <td width="6%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>FA-FD</strong></td>
        <td width="6%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>FC-FA</strong></td>
        <td width="8%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;" align="center"><strong>Tiempo Total</strong></td>
    </tr>
    <cfif rsDatos.recordcount gt 0>
		<cfoutput query="rsDatos" group="Agencia_Aduanal">
        	<tr><td colspan="12" class="tituloAlterno">#rsDatos.Agencia_Aduanal#</td></tr>
            <!--- Variables totalizados por Agencia Aduanal --->
			<cfset LvarDO_FR_G 		= 0>		<cfset LvarFD_DO_G 		= 0>
            <cfset LvarFA_FD_G		= 0>		<cfset LvarFC_FA_G		= 0>
            <cfset LvarT_Total_G		= 0>
        	<cfoutput group="Aduana">
            	<tr><td colspan="12" style="border:1px solid lightgray" align="center"><strong>#rsDatos.Aduana#</strong></td></tr>
            <!--- Variables totalizados por Aduana --->
				<cfset LvarDO_FR 		= 0>		<cfset LvarFA_FD		= 0>
                <cfset LvarFC_FA		= 0>		<cfset LvarT_Total		= 0>
                <cfset FDDO 				= 0>		<cfset FAFD 				= 0>
				<cfset FCFA				= 0>      <cfset LvarFD_DO 		=  0>
				<cfoutput>
                    <tr>
                        <td align="center">#EOnumero#</td>
                        <td align="center" style="font-size:11px;">#EPDnumero#</td>
                        <td align="center" style="font-size:11px;">#Comprador#</td>
                        <td align="center">#DateFormat(ETA_REAL,'dd-mm-yy')#</td>
                        <td align="center">#DateFormat(DO,'dd-mm-yy')#</td>
                        <td align="center">#DateFormat(FD,'dd-mm-yy')#</td>
                        <td align="center">#DateFormat(FA,'dd-mm-yy')#</td>
                        <td align="center">
                            <cfif DO_FR neq "">
                            	#DO_FR#
                                <cfset LvarDO_FR 	= LvarDO_FR+DO_FR>
                            <cfelse>-</cfif> 
                        </td>
                        <td align="center">
                            <cfif FD_DO neq "">
                            	#FD_DO#
                                 <cfset LvarFD_DO = LvarFD_DO+FD_DO>
                                 <cfset FDDO = FD_DO>
                            <cfelse>-</cfif> 
                        </td>
                        <td align="center">
                            <cfif FA_FD neq "">
                            	#FA_FD#
                                <cfset LvarFA_FD		= LvarFA_FD+FA_FD>
                                <cfset FAFD = FA_FD>
							<cfelse>-</cfif> 
                        </td>
                        <td align="center">
                        	 <cfif FC_FA neq "">
                             	#FC_FA#
                             	<cfset LvarFC_FA		= LvarFC_FA+FC_FA> 
                                <cfset FCFA = FC_FA>
                             <cfelse>-</cfif> 
                        </td>
                        <td align="center">
                        	<cfset Total  	= FDDO+FAFD+FCFA> 
                        	<cfdump var="#Total#">
                        	<cfset LvarT_Total		= LvarT_Total+Total>
                        </td>
                    </tr>
                <cfset Total  	= 0>
            	</cfoutput>
                	<tr>
                    	<td colspan="7" align="right"><strong><u>Subtotal de Aduana:</u></strong></td>
                        <td align="center"><strong>#LvarDO_FR#</strong></td>
                        <td align="center"><strong>#LvarFD_DO#</strong></td>
                        <td align="center"><strong>#LvarFA_FD#</strong></td>
                        <td align="center"><strong> #LvarFC_FA#</strong></td>
                        <td align="center"><strong>#LvarT_Total#</strong></td>
                    </tr>
                    <tr><td colspan="12">&nbsp;</td></tr>
			<cfset LvarDO_FR_G 		= LvarDO_FR_G+LvarDO_FR>
            <cfset LvarFD_DO_G 		= LvarFD_DO_G+LvarFD_DO>
            <cfset LvarFA_FD_G		= LvarFA_FD_G+LvarFA_FD>
            <cfset LvarFC_FA_G		= LvarFC_FA_G+LvarFC_FA>
            <cfset LvarT_Total_G		= LvarT_Total_G+LvarT_Total>
			<cfset LvarDO_FR 	= 0>		<cfset LvarFD_DO 	= 0>	
			<cfset LvarFA_FD	= 0>		<cfset LvarFC_FA	= 0>
            <cfset LvarT_Total 	= 0>       
        	</cfoutput>
            <cfset TotalLineasG = PolizasAgencia(CMAAid)>
            	<tr>
                    <td colspan="4" align="left"><strong>Total Ordenes:</strong>#OrdenesAgencia(CMAAid)#<br />
                    										 <strong>Total Polizas:</strong>#PolizasAgencia(CMAAid)#<br /></td>
                    <td colspan="3" align="right"><strong><u>PROMEDIO AGENCIA:</u></strong></td>
                    <td align="center"><strong>#LSNumberformat((LvarDO_FR_G/TotalLineasG),"___.__")#</strong></td>
                    <td align="center"><strong>#LSNumberformat((LvarFD_DO_G/TotalLineasG),"___.__")#</strong></td>
                    <td align="center"><strong>#LSNumberformat((LvarFA_FD_G/TotalLineasG),"___.__")#</strong></td>
                    <td align="center"><strong>#LSNumberformat((LvarFC_FA_G/TotalLineasG),"___.__")#</strong></td>
                    <td align="center"><strong>#LSNumberformat((LvarT_Total_G/TotalLineasG),"___.__")#</strong></td>
                </tr>
				<tr><td colspan="12">&nbsp;</td></tr>
		<cfset LvarDO_FR_G 	= 0>		<cfset LvarFD_DO_G 	= 0>
        <cfset LvarFA_FD_G	= 0>		<cfset LvarFC_FA_G	= 0>
        <cfset LvarT_Total_G	= 0>
        </cfoutput>
        <tr><td colspan="12" align="center">&nbsp;</td></tr>
        <tr><td colspan="12" align="center">----------------- Fin del Reporte -----------------</td></tr>    
      <cfelse>
        <tr><td colspan="11" align="center">&nbsp;</td></tr>
        <tr><td colspan="11" align="center">----------------- No se encontrar&oacute;n Datos -----------------</td></tr>     	  
     </cfif>
</table>
<!------> 
<cffunction name="OrdenesAgencia" access="private" returntype="numeric"
hint="Funcion para obtener el total de las OC por Agencia Aduanal">
	<cfargument name="Agencia" type="numeric" required="yes">
    <cfquery dbtype="query" name="rsOrdenes">
    	SELECT DISTINCT
        	EOnumero
        from rsDatos
        WHERE CMAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agencia#">
    </cfquery>    
	<cfset LvarOrdenes = rsOrdenes.recordcount>
    <cfreturn LvarOrdenes>
</cffunction>
 
<cffunction name="PolizasAgencia" access="private" returntype="numeric"
	hint="Funcion para obtener el total de las OC por Agencia Aduanal">
	<cfargument name="Agencia" type="numeric" required="yes">
    <cfquery dbtype="query" name="rsPolizas">
    	SELECT DISTINCT
        	EPDnumero
        from rsDatos
        WHERE CMAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agencia#">
    </cfquery>    
	<cfset LvarPolizas = rsPolizas.recordcount>
    <cfreturn LvarPolizas>
</cffunction> 
     
