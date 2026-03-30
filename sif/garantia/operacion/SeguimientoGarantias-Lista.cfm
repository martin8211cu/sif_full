<cfif isdefined("url.CMPid") and not isdefined("form.CMPid") and len(trim(url.CMPid))>
	<cfset form.CMPid = url.CMPid>
</cfif>

<cfquery name="rsSeguiGarantias" datasource="#session.DSN#">
        select 
        	a.CMPid, 
            a.CMPProceso, 
            a.CMPLinea, 
            a.Mcodigo, 
            CMPMontoProceso, 
            b.COEGid, 
            b.COEGPersonaEntrega, 
            b.COEGReciboGarantia, 
            c.SNnombre, 
            b.COEGPersonaEntrega, 
            b.COEGIdentificacion, 
            case when b.COEGContratoAsociado = 'N' 
            	then  
                	'<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'  
                else  
                	'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' 
                end as COEGContratoAsociado
        from COHEGarantia b
            left join CMProceso a
            on b.CMPid  = a.CMPid
            inner join SNegocios c
            on c.SNid = b.SNid
        where b.Ecodigo = #session.Ecodigo# 
        	and b.COEGVersionActiva=1
            and (b.COEGEstado not in (8, 5)) <!--- No se presentan Devueltas o Ejecutadas, solicitado por Chantal 18-3-2010 --->
        <cfif isdefined('form.FILTRO_CMPPROCESO') and len(trim(form.FILTRO_CMPPROCESO))>
			and lower(a.CMPProceso) like lower('%#form.FILTRO_CMPPROCESO#%')
		</cfif>
        <cfif isdefined('form.FILTROS_CMPLINEA') and len(trim(form.FILTROS_CMPLINEA))>
			and a.CMPLinea = #FILTROS_CMPLINEA#
		</cfif>
        <cfif isdefined('form.FILTROS_COEGRECIBOGARANTIA') and len(trim(form.FILTROS_COEGRECIBOGARANTIA))>
			and b.COEGReciboGarantia = #FILTROS_COEGRECIBOGARANTIA#
		</cfif>
        <cfif isdefined('form.FILTRO_SNNOMBRE') and len(trim(form.FILTRO_SNNOMBRE))>
			and lower(c.SNnombre) like lower('%#FILTRO_SNNOMBRE#%')
		</cfif>
		<cfif isdefined('form.filtro_COEGPersonaEntrega') and len(trim(form.filtro_COEGPersonaEntrega))>
			and lower(b.COEGPersonaEntrega) like lower('%#form.filtro_COEGPersonaEntrega#%')
		</cfif>
		<cfif isdefined('form.filtro_COEGIdentificacion') and len(trim(form.filtro_COEGIdentificacion))>
			and lower(b.COEGIdentificacion) like lower('%#form.filtro_COEGIdentificacion#%')
		</cfif>	
		<cfif isdefined('form.filtro_COEGContratoAsociado') and len(trim(form.filtro_COEGContratoAsociado))>
			and b.COEGContratoAsociado = '#form.filtro_COEGContratoAsociado#'
		</cfif>	
</cfquery>
<cfquery name="rsTipoGarantia" datasource="#Session.DSN#">
	select -1 as value, '-- todos --' as description, 0 as ord from dual
	union
	select 1 as value, 'Participación' as description, 1 as ord from dual
	union
	select 2 as value, 'Cumplimiento' as description, 1 as ord from dual
	order by ord,description
</cfquery>
<cfquery name="rsCOEGContratoAsociado" datasource="#Session.DSN#">
	select '' as value, '-- todos --' as description, 0 as ord from dual
	union
	select 'S' as value, 'Si' as description, 1 as ord from dual
	union
	select 'N' as value, 'No' as description, 1 as ord from dual
	order by ord,description
</cfquery> 

<cf_templateheader title="Seguimiento de Garantias">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Seguimiento de Garantias'>
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
        	<td style="vertical-align:top" width="100%">
            	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
                   	query="#rsSeguiGarantias#" 
					conexion="#session.dsn#"
					desplegar="CMPProceso, CMPLinea, COEGReciboGarantia, SNnombre, COEGPersonaEntrega, COEGIdentificacion, COEGContratoAsociado"
					etiquetas="Proceso, Linea, Garantia,Provedor, Persona Entrega, Identificación, Asociado Contr"
					formatos="S,I,I,S,S,S,S"
					align="left, left, left, left, left, left, center"
					mostrar_filtro="true"
					irA="SeguimientoGarantias-form.cfm"
					Keys="COEGid"										
					checkboxes="N"
					rstipoGarantia="#rsTipoGarantia#"
					rsCOEGContratoAsociado='#rsCOEGContratoAsociado#'
                    PageIndex="1">	
                    				
                </cfinvoke>
            </td>
        </tr>
    </table>
    <cf_web_portlet_end>
<cf_templatefooter>