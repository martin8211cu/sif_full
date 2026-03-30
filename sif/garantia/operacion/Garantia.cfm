<cfif isdefined("url.COEGid") and not isdefined("form.COEGid") and len(trim(url.COEGid))>
	<cfset form.COEGid = url.COEGid>
</cfif>

<cfquery name="rsGarantias" datasource="#session.DSN#">
    	select b.COEGid, a.CMPProceso, 
			c.SNnumero, c.SNnombre,
			b.COEGReciboGarantia,
			b.COEGVersion,
			case b.COEGTipoGarantia
				when 1 then 'Participación'
				when 2 then 'Cumplimiento'
			end as COEGTipoGarantia,
			d.Miso4217,
			b.COEGMontoTotal,
            coalesce(
            case bb.COEGEstado
                when 1 then 'Vigente'
                when 2 then 'Edición'
                when 3 then 'En proceso de Ejecución'
                when 4 then 'En Ejecución'
                when 5 then 'Ejecutada'
                when 6 then 'En proceso Liberación'
                when 7 then 'Liberada'
                when 8 then 'Devuelta'
            end
			, case b.COEGEstado
				when 1 then 'Vigente'
				when 2 then 'Edición'
				when 3 then 'En proceso de Ejecución'
				when 4 then 'En Ejecución'
				when 5 then 'Ejecutada'
				when 6 then 'En proceso Liberación'
				when 7 then 'Liberada'
				when 8 then 'Devuelta'
			end ) as Estado,
			a.CMPLinea,
			b.COEGPersonaEntrega,
			b.COEGIdentificacion, case when b.COEGContratoAsociado = 'N' then  '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'  else  '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' end as COEGContratoAsociado
        from COEGarantia b
		    left outer join CODGarantia l
			    on b.COEGid = l.COEGid
			left outer join  CMProceso a
				on a.CMPid = b.CMPid																		
			inner join SNegocios c
				on c.SNid = b.SNid																		
			inner join Monedas d
				on d.Mcodigo = b.Mcodigo
            left outer join COHEGarantia bb
              on bb.COEGid = b.COEGid
	            and bb.COEGVersionActiva = 1
        where b.Ecodigo = #session.Ecodigo#
			and c.SNtiposocio in ('A','P')
			and (bb.COEGEstado not in (8, 7, 5) or b.COEGEstado in (2) )<!--- No se presentan Devueltas, Liberadas o Ejecutadas, solicitado por Chantal 5-3-2010 --->
			and b.COEGVersionActiva = 1
            and Coalesce(bb.COEGVersion,-1) = Coalesce((select max(x.COEGVersion) from COHEGarantia x where x.COEGid = b.COEGid) ,  bb.COEGVersion,-1)
            <cfif isdefined('form.filtro_CMPProceso') and len(trim(form.filtro_CMPProceso))>
	           	and lower(a.CMPProceso) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_CMPProceso)#%">
            </cfif>
            <cfif isdefined('form.filtro_SNnumero') and len(trim(form.filtro_SNnumero))>
	           	and lower(c.SNnumero) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_SNnumero)#%">
            </cfif>
            <cfif isdefined('form.filtro_SNnombre') and len(trim(form.filtro_SNnombre))>
	           	and lower(c.SNnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_SNnombre)#%">
            </cfif>
            <cfif isdefined('form.filtro_COEGPersonaEntrega') and len(trim(form.filtro_COEGPersonaEntrega))>
            	and lower(b.COEGPersonaEntrega) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_COEGPersonaEntrega)#%">
            </cfif>
            <cfif isdefined('form.filtro_COEGIdentificacion') and len(trim(form.filtro_COEGIdentificacion))>
            	and lower(b.COEGIdentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_COEGIdentificacion)#%">
            </cfif>	
            <cfif isdefined('form.filtro_COEGReciboGarantia') and len(trim(form.filtro_COEGReciboGarantia)) and form.filtro_COEGReciboGarantia neq -1>
            	and b.COEGReciboGarantia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.filtro_COEGReciboGarantia,',','','all')#">
            </cfif>	
            <cfif isdefined('form.filtro_COEGTipoGarantia') and len(trim(form.filtro_COEGTipoGarantia)) and form.filtro_COEGTipoGarantia neq -1>
            	and b.COEGTipoGarantia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtro_COEGTipoGarantia#">
            </cfif>	
			<cfif isdefined('form.filtro_Miso4217') and len(trim(form.filtro_Miso4217)) and form.filtro_Miso4217 neq -1>
            	and d.Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.filtro_Miso4217#">
            </cfif>
            <cfif isdefined('form.filtro_Estado') and len(trim(form.filtro_Estado)) and form.filtro_Estado neq -1>
            	and coalesce(bb.COEGEstado, b.COEGEstado) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtro_Estado#">
            </cfif>
            <cfif isdefined('form.filtro_COEGContratoAsociado') and len(trim(form.filtro_COEGContratoAsociado))>
            	and b.COEGContratoAsociado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.filtro_COEGContratoAsociado#">
            </cfif>	
			 <cfif isdefined('form.NumGarantia') and len(trim(form.NumGarantia)) >
			    and l.CODGNumeroGarantia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumGarantia#">
			 </cfif>													
			order by b.COEGReciboGarantia, b.COEGid
    </cfquery>
	
<cfquery name="rsMiso4217" datasource="#Session.DSN#">
	select '-1' as value, '-- todos --' as description, 0 as ord from dual
	union
	select Miso4217 as value, Miso4217 as description, 1 as ord
	from Monedas a
    inner join COEGarantia b
    on a.Mcodigo = b.Mcodigo
	where a.Ecodigo = #Session.Ecodigo#
	order by ord,description
</cfquery>
<cfquery name="rsCOEGTipoGarantia" datasource="#Session.DSN#">
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

<cfquery name="rsEstado" datasource="#session.DSN#">
	select -1 as value, '-- todos --' as description from dual
	union
	select 1 as value, 'Vigente' as description from dual
    union all
    select 2 as value, 'Edicion' as description from dual
    union all
    select 3 as value, 'En proceso de Ejecución' as description from dual
    union all
    select 4 as value, 'En Ejecución' as description from dual
    union all
    select 5 as value, 'Ejecutada' as description from dual
    union all
    select 6 as value, 'En proceso Liberación' as description from dual
    union all
    select 7 as value, 'Liberada' as description from dual
    union all
    select 8 as value, 'Devuelta' as description from dual
    order by description
</cfquery>

<cf_templateheader title="Garantías">
    <cfinclude template="/sif/portlets/pNavegacion.cfm">
    <cf_web_portlet_start titulo="Garantías">
	<form name="NumeroDocunmento" action="Garantia.cfm" method="post">
		<table align="center" width="100%">
		   <tr align="left">
			 <td >
			  <strong> Numero de Garantía:</strong>			 
			 &nbsp;
			 <input type="text" name="NumGarantia"/>
			 &nbsp;	 
			 <input type="submit" value="Filtrar" class="btnFiltrar" name="filtrar"/>
			 </td>
		   </tr>
		</table>
	</form>
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
        	<td style="vertical-align:top" width="100%">           	
                            	
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
                    query="#rsGarantias#" 
                    conexion="#session.dsn#"
                    desplegar="CMPProceso, SNnumero, SNnombre,COEGPersonaEntrega, COEGIdentificacion, COEGReciboGarantia, COEGVersion, COEGTipoGarantia, Miso4217, COEGMontoTotal, Estado,COEGContratoAsociado"
                    etiquetas="Proceso, Cód Proveedor, Proveedor, Persona Entrega, Identificación, Garantía, Version, Tipo Garantía, Moneda, Monto, Estado, Asoc Contr"
                    formatos="S,S,S,S,S,I,U,U,S,U,U,U"
                    align="left,left,left,left,left,center,center,left,center,right,right,center"
                    mostrar_filtro="true"
                    irA="GarantiaForm.cfm"
                    Keys="COEGReciboGarantia,COEGVersion"										
                    checkboxes="N"					
                    botones="Nuevo"
                    rsMiso4217="#rsMiso4217#"
                    rsCOEGTipoGarantia="#rsCOEGTipoGarantia#"
                    rsCOEGContratoAsociado='#rsCOEGContratoAsociado#'
                    rsEstado="#rsEstado#"
					usaAjax="true"
                    PageIndex="1">						
                </cfinvoke>	
            </td>
        </tr>
    </table>
    <cf_web_portlet_end>
<cf_templatefooter>