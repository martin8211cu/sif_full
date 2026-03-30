<cfquery name="rsGarantiasContrato" datasource="#Session.DSN#">
	select distinct b.CMPProceso,a.CMPid, b.CMPid
	from COEGarantia a
	inner join CMProceso b
		on b.CMPid  = a.CMPid
	where b.Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset fecha= DateFormat(Now(),'mm/dd/yyyy')>
<cf_dbfunction name = "op_concat" returnvariable = "_Cat">
 <cf_dbfunction name="to_char" args="b.COEGReciboGarantia" 	datasource="#session.dsn#" returnvariable="LvarCOEGReciboGarantia">
 <cf_dbfunction name="to_char" args="b.COEGVersion" 		datasource="#session.dsn#" returnvariable="LvarCOEGVersion">
<cfquery name="rsDetalleGarantia" datasource="#session.DSN#" maxrows="5001">
	select 	
    	a.CODGFechaFin, 
        a.CODGid, 
        c.CMPid, 
        d.SNnombre,
        case when b.COEGTipoGarantia = 1 
			then 
            	'Participación' 
            else 
            	'Cumplimiento' 
        end as COEGTipoGarantia,
        a.CODGNumeroGarantia, 
		a.COTRid, 
        b.COEGid, 
        a.CODGMonto, 
        h.Mnombre, 
        g.Bdescripcion, 
        c.CMPProceso, 
		f.COTRDescripcion, 
        b.COEGPersonaEntrega,
        b.COEGIdentificacion, 
		b.COEGNumeroControl,
		#preservesinglequotes(LvarCOEGReciboGarantia)# #_Cat#  '-' #_Cat#  #preservesinglequotes(LvarCOEGVersion)# as GarantiaRecibo,
        case when b.COEGContratoAsociado = 'N' 
        	then  
            	'<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'  
            else  
            	'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' 
        end as COEGContratoAsociado, 
        case when b.COEGContratoAsociado = 'S' 
        	then 
            	'<img src="emailVencimientosGarantia.gif" style="cursor:pointer" onclick="location.href=&quot;GarantiasVencimiento-email.cfm?COEGid=' #_Cat# <cf_dbfunction name="to_char" datasource="#session.DSN#" args="b.COEGid">#_Cat#'&quot;" border="0" width="37" height="12">'
            else 
            	''	
        end as dibujo 
	from COHDGarantia a
		inner join COHEGarantia b
			on b.COEGid = a.COEGid
			and b.COEGVersion = a.COEGVersion
		left join CMProceso c
			on c.CMPid  = b.CMPid
		left join SNegocios d
			on d.SNid = b.SNid
		inner join COTipoRendicion f
			on 	f.COTRid = a.COTRid
		inner join Bancos g
			on g.Bid = a.Bid
		inner join Monedas h
			on h.Mcodigo = b.Mcodigo 			
	where a.Ecodigo = #session.Ecodigo#	
		and b.COEGid = a.COEGid	
		and COEGEstado not in (2,5,7,8)	
		and b.COEGVersionActiva = 1
		<!--- Tipo de transacción --->
		<cfif isdefined("url.Proceso") and len(trim(url.Proceso)) and url.Proceso NEQ '-1'>
			and c.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Proceso#">
		</cfif>
		<cfif isdefined('url.SNnumero1') and Len(trim(url.SNnumero1))>
			and d.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero1#">
		</cfif>
		<!--- Fechas Desde / Hasta --->
		 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>					
			<cfif datecompare(url.fechaDes, url.fechaHas) eq -1> 
				and a.CODGFechaFin between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
			<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 1>
				and a.CODGFechaFin between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
			<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 0>
				and a.CODGFechaFin between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
			</cfif>
		<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
			and a.CODGFechaFin >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
		<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
			and a.CODGFechaFin <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
		</cfif> 					
	order by a.CODGFechaFin,c.CMPid,b.SNid
</cfquery>



<cf_templateheader title="CONAVI GARANTIAS - REPORTES">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Vencimiento de Garantias'>

    <form name="form1" method="get" action="<!---VencimientoGarantiasInfo.cfm--->">
    <table width="100%" cellpadding="2" cellspacing="0">
        <tr>
            <td valign="top">
                <fieldset><legend>Datos del Reporte</legend>
                    <table  width="100%" cellpadding="2" cellspacing="0" border="0">
                        
                        <tr>						
                            <td nowrap align="right"><strong>Proceso:</strong></td>
                            <td align="left">
                                <select name="Proceso" tabindex="1">
                                    <option value="-1">Todas</option>
                                    <cfoutput query="rsGarantiasContrato"> 
                                        <option value="#rsGarantiasContrato.CMPid#">#rsGarantiasContrato.CMPProceso#</option>
                                    </cfoutput> 
                                </select> 
                            </td>
                            
                            <td nowrap align="right"><strong>Provedor: </strong></td>
                            <td align="left">
                                <cf_sifsociosnegocios2 SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNnumero="SNnumero1" frame="frSNnombre11" tabindex="1">
                            </td>	
                        </tr>
                        <tr>
                            <td width="19%" align="right"><strong>Desde:</strong></td>
                            <td width="23%"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1"></td>		
                            <td width="13%" align="right" nowrap><strong>Hasta:</strong></td>
                            <td width="41%"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center">										
                                    <cf_botones values="Filtrar,Limpiar" names="Filtrar,Limpiar" tabindex="1" >
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </td>	
        </tr>
    </table>
    </form>
    
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
                <td style="vertical-align:top" width="100%">
                    <cfflush interval="16">
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
                    <cfinvokeargument name="query" value="#rsDetalleGarantia#"/>				
                    <cfinvokeargument name="desplegar" 		value="CODGFechaFin, CMPProceso,GarantiaRecibo, SNnombre, COEGPersonaEntrega, COEGIdentificacion, COEGTipoGarantia, COEGNumeroControl,COTRDescripcion, CODGNumeroGarantia, CODGMonto, Mnombre, Bdescripcion, COEGContratoAsociado, dibujo"/>
                    <cfinvokeargument name="etiquetas" 		value="Fecha Vencim, Proceso, Recibo, Provedor, Persona Entrega, Identificación, Clase, N°Control, Tipo, N°Garantia,Monto,Moneda,Banco,Cont asoc,Correo"/>
                    <cfinvokeargument name="formatos" 		value="D,I,S,S,S,S,S,S,S,I,M,S,S,U,IMG"/>
                    <cfinvokeargument name="usaAJAX" 		value="no"/>
                    <cfinvokeargument name="conexion" 		value="#session.DSN#"/>
                    <cfinvokeargument name="align" 			value="left, left, left,left, left, left, left, left, left, center, right, center, left, center, right"/>
                    <cfinvokeargument name="ajustar" 		value="true"/>
                    <cfinvokeargument name="debug" 			value="N"/>
                    <cfinvokeargument name="Keys" 			value="COEGid"/>
                    <cfinvokeargument name="mostrar_filtro" value="false"/>
                    <cfinvokeargument name="filtrar_automatico" value="True"/> 
                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="showLink" 	value="false"/>
                    <cfinvokeargument name="MaxRows" 		value="30"/>
                    <cfinvokeargument name="TabIndex" 		value="1"/>
                    <cfinvokeargument name="incluyeForm" value="false"/>
                    <cfinvokeargument name="formName" value="formDetalles"/>
                </cfinvoke>	
            </td>
        </tr>
    </table>
<cf_web_portlet_end>
<cf_templatefooter>