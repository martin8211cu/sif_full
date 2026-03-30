<cfset lvarSolicitante= true>
<!----Cargar valores recibidos por URL--->
<cfif isdefined("url.CMCid") and not isdefined("form.CMCid")>
	<cfset form.CMCid= url.CMCid >
</cfif>
<cfif isdefined("url.CMPnumero_f") and not isdefined("form.CMPnumero_f")>
	<cfset form.CMPnumero_f= url.CMPnumero_f >
</cfif>
<cfif isdefined("url.CMPdescripcion_f") and not isdefined("form.CMPdescripcion_f")>
	<cfset form.CMPdescripcion_f= url.CMPdescripcion_f >
</cfif>
<cfif isdefined("url.CMPfmaxofertas_f") and not isdefined("form.CMPfmaxofertas_f")>
	<cfset form.CMPfmaxofertas_f= url.CMPfmaxofertas_f >
</cfif>
<!------Cargar la navegacion----->
<cfset navegacion = ''>
<cfif isdefined("Form.CMCid") and Len(Trim(Form.CMCid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMCid=" & Form.CMCid>
</cfif>
<cfif isdefined("Form.CMPnumero_f") and Len(Trim(Form.CMPnumero_f)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMPnumero_f=" & Form.CMPnumero_f>
</cfif>
<cfif isdefined("Form.CMPdescripcion_f") and Len(Trim(Form.CMPdescripcion_f)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMPdescripcion_f=" & Form.CMPdescripcion_f>
</cfif>
<cfif isdefined("Form.CMPfmaxofertas_f") and Len(Trim(Form.CMPfmaxofertas_f)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMPfmaxofertas_f=" & Form.CMPfmaxofertas_f>
</cfif>

<cfquery name="rsCompradores" datasource="#Session.DSN#">
	select distinct CMCid, CMCnombre, Usucodigo, CMCjefe 
	from CMCompradores 
<!---	 Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">and--->
	where CMCestado = 1
	order by CMCjefe
</cfquery>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_dbfunction name="to_char" args="a.CMPid" returnvariable="lvarToCharCMPid">
<cf_dbfunction name="to_char" args="a.CMPnumero" returnvariable="lvarToCharCMPnumero">
<cf_dbfunction name="to_char" args="E.EcodigoSDC" returnvariable="lvarToCharECnumero">
<cf_dbfunction name="to_char" args="E.Ecodigo" returnvariable="lvarToCharECodigo">
                  
<cfquery name="qryLista" datasource="#session.dsn#">
	select Distinct 0 as OPT,a.Ecodigo, a.CMPnumero, a.CMPid, a.CMPdescripcion, a.CMPfechapublica, case when 1 = 1 then '<a style="cursor:pointer;float:none" title="Detalles" onclick="return fnObtDetalles('''#_Cat##lvarToCharCMPid##_Cat#''','''#_Cat##lvarToCharECodigo##_Cat#''')"><img border="0" align="absmiddle" name="imagen" src="/cfmx/sif/imagenes/Page_Load.gif"></a>'  end as detalle,
    			<!---Solicitante--->
			(
				select us.Usulogin
				from Usuario us
				where us.Usucodigo=a.Usucodigo
			) as usuario,
               <!---Comprador--->
			(
				select cmp.	CMCnombre
				from CMCompradores cmp
				where cmp.CMCid = a.CMCid 
			) as comprador,
            	'<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC='#_Cat##lvarToCharECnumero##_Cat#'" class="iconoEmpresa"  alt="logo" border="0" height="45" />' 
                as Empresa,
    case when 1 = 1 then '<a id="btnAprobar" class="archivos-icon-aprobar" style="cursor:pointer;float:none" title="Aprobar" onclick="funcAprobar('''#_Cat##lvarToCharCMPid##_Cat#''','''#_Cat##lvarToCharECodigo##_Cat#''')"></a>' end as aprobar, case when 1 = 1 then '<a class="archivos-icon-rechazar" style="cursor:pointer;float:none" title="Rechazar" onclick="funcRechazar('''#_Cat##lvarToCharCMPid##_Cat#''','''#_Cat##lvarToCharECodigo##_Cat#''')"></a>' end as rechazar, a.CMPfmaxofertas, 
		coalesce((select sum(1) 
        			from ECotizacionesCM b 
                  where b.CMPid = a.CMPid 
                    and b.ECestado in (5,10)),0) as ECcount,
		case when (coalesce((select sum(1) 
        						from ECotizacionesCM b 
                              where b.CMPid = a.CMPid 
                                and b.ECestado in (5,10)),0)) = 0 <cfif not lvarSolicitante>or a.CMPestado = 79 or a.CMPestado = 81 or a.CMPestado = 83</cfif> then a.CMPid else 0 end as filasdesactivadas
        <cfif not lvarSolicitante>
        	,a.CMPestado
        	, case when a.CMPestado = 79 or a.CMPestado = 81 or a.CMPestado = 83
            	then 
                	(select max( u.Usulogin)
                        from  DSolicitudCompraCM ds
                            inner join ESolicitudCompraCM es
                                on es.ESidsolicitud = ds.ESidsolicitud
                            left outer join WfxActivity xa
                                on xa.ProcessInstanceId = es.ProcessInstanceid
                            inner join WfxActivityParticipant xap
                                on xap.ActivityInstanceId = xa.ActivityInstanceId
                           	inner join Usuario u
                    			on u.Usucodigo = xap.Usucodigo 
                        where xap.HasTransition = 1
                          and dc.CMPid = a.CMPid
                          and ds.DSlinea = dc.DSlinea
                          and a.CMPestado = 79
                          and xa.FinishTime = (select max(sxa.FinishTime)
                                                from WfxActivity sxa
                                                    inner join WfxActivityParticipant sxap
                                                        on sxap.ActivityInstanceId = sxa.ActivityInstanceId
                                                where sxa.ProcessInstanceId = es.ProcessInstanceid)) #_Cat#
                    (select max( u.Usulogin)
            	  from DSolicitudCompraCM ds
                        
                    inner join ESolicitudCompraCM es
                        on es.ESidsolicitud = ds.ESidsolicitud
                  	inner join Usuario u
                    	on u.Usucodigo = es.Usucodigo
                  where dc.CMPid = a.CMPid
                     and ds.DSlinea = dc.DSlinea
                    and es.ProcessInstanceid is null) #_Cat# case when a.CMPestado = 83 then '&nbsp;<a id="'#_Cat##lvarToCharCMPid##_Cat#'" onmouseover="fnMostrarToolTip_1($(''##'#_Cat##lvarToCharCMPid##_Cat#'''),''Justificación del Rechazo, Num. Proceso: '#_Cat##lvarToCharCMPnumero##_Cat#''','''#_Cat#a.CMPjustificacionRechazo#_Cat#''')"><img src="/cfmx/sif/imagenes/notas2.gif" /></a>' else '' end 

                else '-'  end as AprobadorSolicitante
     </cfif>
	from CMProcesoCompra a
    	 left Outer join DCotizacionesCM dc
        	on dc.CMPid = a.CMPid
            inner join Empresas E
            	on E.Ecodigo = a.Ecodigo
	where 1 = 1
    <cfif isdefined("Form.F_Ecodigo") and Form.F_Ecodigo NEQ -1>
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.F_Ecodigo#">	
   	</cfif>
	<cfif isdefined("Form.CMCid") and Len(Trim(Form.CMCid)) and Form.CMCid NEQ -1 and not lvarSolicitante>
		and a.CMCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.CMCid#">
	<cfelseif (isdefined("Form.CMCid") and Len(Trim(Form.CMCid)) and Form.CMCid EQ -1) or lvarSolicitante>
		<!--- No hace nada pero evita que se vaya al ELSE --->
	<cfelse>
    	<cfif NOT isdefined('Session.Compras.Comprador') OR NOT LEN(TRIM(Session.Compras.Comprador))>
        	<cfthrow message="No tiene permisos como comprador">
        </cfif>
		and a.CMCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.Compras.Comprador#">
	</cfif>
	<cfif isdefined("Form.CMPnumero_f") and Len(Trim(Form.CMPnumero_f)) GT 0>
		and a.CMPnumero=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.CMPnumero_f#">
	</cfif>
	<cfif isdefined('form.CMPdescripcion_f') and Len(Trim(form.CMPdescripcion_f))>
		and upper(a.CMPdescripcion) like '%#UCase(Form.CMPdescripcion_f)#%'
	</cfif>	 	
	<cfif isdefined('form.CMPfmaxofertas_f') and Len(Trim(form.CMPfmaxofertas_f))>
		and a.CMPfmaxofertas>=<cf_jdbcquery_param value="#LSParseDateTime(form.CMPfmaxofertas_f)#" cfsqltype="cf_sql_timestamp">
	</cfif>		
	<cfif not lvarSolicitante>
        and ((a.CMPestado >= 10 and a.CMPestado < 50)  <!---Averiguar los estados correctos--->
        	or a.CMPestado in(81,79,83))
  	<cfelse>
        and a.CMPestado = 79
        and (
        		(select count(1)
                        from CMProcesoCompra pc
                            inner join DCotizacionesCM dc
                                on dc.CMPid = pc.CMPid
                            inner join DSolicitudCompraCM ds
                                on ds.DSlinea = dc.DSlinea
                            inner join ESolicitudCompraCM es
                                on es.ESidsolicitud = ds.ESidsolicitud
                            inner join WfxActivity xa
                                on xa.ProcessInstanceId = es.ProcessInstanceid
                            inner join WfxActivityParticipant xap
                                on xap.ActivityInstanceId = xa.ActivityInstanceId
                        where xap.Usucodigo = #session.Usucodigo#
                          and xap.HasTransition = 1
                          and pc.CMPestado = 79
                          and xa.FinishTime = (select max(sxa.FinishTime)
                                                from WfxActivity sxa
                                                    inner join WfxActivityParticipant sxap
                                                        on sxap.ActivityInstanceId = sxa.ActivityInstanceId
                                                where sxa.ProcessInstanceId = es.ProcessInstanceid)
                         and pc.CMPid = a.CMPid
                ) > 0
   			or (select count(1)
            	  from CMProcesoCompra pc
                  	inner join DCotizacionesCM dc
                    	on dc.CMPid = pc.CMPid
                    inner join DSolicitudCompraCM ds
                        on ds.DSlinea = dc.DSlinea
                    inner join ESolicitudCompraCM es
                        on es.ESidsolicitud = ds.ESidsolicitud
                  where dc.CMPid = a.CMPid
                    and dc.Ecodigo = a.Ecodigo
                    and es.Usucodigo = #session.Usucodigo#
                    and es.ProcessInstanceid is null
                    and pc.CMPid = a.CMPid
                 ) > 0
            )
   	</cfif>
	order by a.CMPnumero
</cfquery>

    <cfset lvarIrA = "cotizaciones.cfm">

<form name="lista" method="post" action="<cfoutput>#lvarIrA#</cfoutput>">
	<table width="100%"  border="0" class="areaFiltro">
	  <tr>
	    <td width="24%" align="right" class="fileLabel" nowrap>Num. Proceso de Compra: </td>
	    <td width="24%" nowrap>
			<input type="text" name="CMPnumero_f" id="CMPnumero_f" style="text-align:right"size="15" maxlength="10" 
				onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
				onFocus="javascript:this.select();" 
				onChange="javascript: fm(this,-1);"
				value="<cfif isdefined('form.CMPnumero_f') and form.CMPnumero_f NEQ ''><cfoutput>#form.CMPnumero_f#</cfoutput></cfif>">		
		</td>      
         <cfparam name="form.F_Ecodigo" default="-1">
		 <cfif lvarProvCorp>  
            <td width="200"><strong>Empresa: </strong></td>                   
        <td>
            <select name="F_Ecodigo">
            <cfif not isdefined('form.F_Ecodigo') OR F_Ecodigo EQ -1>
                <option value="-1"  selected > -Todas- </option>	
            <cfelse>
                <option value="-1" > -Todas-  </option>	
            </cfif>
                <cfloop query="rsDProvCorp">
                    <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.F_Ecodigo') and form.F_Ecodigo eq rsDProvCorp.Ecodigo) > selected</cfif> >
                    
                    <cfoutput>#rsDProvCorp.Edescripcion#</cfoutput>
                    </option>	
                </cfloop>	
            </select>
        </td>
        <cfelse>
        <td width="200"></td>                   
        <td></td>
        </cfif>
  	    <td width="12%" rowspan="2" nowrap valign="middle" align="center">
        	<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" class="btnFiltrar">
        </td>
	  </tr>
	  <tr>
	    <td class="fileLabel" align="right" nowrap>Descripci&oacute;n:</td>
	    <td nowrap colspan="3">
			<input name="CMPdescripcion_f" value="<cfif isdefined('form.CMPdescripcion_f') and form.CMPdescripcion_f NEQ ''><cfoutput>#form.CMPdescripcion_f#</cfoutput></cfif>" type="text" id="ESobservacion_f" size="60" maxlength="255">
		</td>
          <td>
          
        </td>
      </tr>
	</table>
        <cfset lvardesplegar = "CMPnumero,CMPdescripcion, CMPfechapublica, CMPfmaxofertas, usuario, comprador, empresa, detalle, aprobar, rechazar">
        <cfset lvaretiquetas = "Num. Proceso, Descripción, Fecha de Publicación, Fecha Máxima para Cotización, Solicitante, Comprador, Empresa, Detalle, Aprobar, Rechazar">
        
	<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="qLista">
            <cfinvokeargument name="query" 				value="#qryLista#">
            <cfinvokeargument name="desplegar" 			value="#lvardesplegar#"/>
            <cfinvokeargument name="etiquetas" 			value="#lvaretiquetas#"/>
            <cfinvokeargument name="formatos" 			value="V,V,D,D,V,S,S,S,S,S"/>
            <cfinvokeargument name="align" 				value="center, left, center, center, center, center, center, center, center, center"/>
            <cfinvokeargument name="ajustar" 			value="N"/>
            <cfinvokeargument name="formName" 			value="lista"/>
            <cfinvokeargument name="irA" 			    value=""/>
            <cfinvokeargument name="funcion" 			value=""/>
            <cfinvokeargument name="incluyeForm" 		value="false"/>
            <cfinvokeargument name="keys" 				value="CMPid,Ecodigo"/>
            <cfinvokeargument name="showLink" 			value="false"/>
            <cfinvokeargument name="fparams" 			value="CMPid,ECcount"/>
            <cfinvokeargument name="inactivecol" 		value="filasdesactivadas"/>
	</cfinvoke>
    <cfif not qryLista.RecordCount gt 0>
   		<table width="100%">
       		<tr>
              <td colspan="8" align="center">
                  -----------------<cf_translate key="MSG_NoHayTramitesPorAprobar">NO HAY TR&Aacute;MITES POR APROBAR</cf_translate>----------------
              </td>
            </tr>
	    </table>
  	</cfif>
	<cf_Lightbox link="" Titulo="Detalle de la Cotización" width="80" height="80" name="DetaCotizacion" url="/cfmx/proyecto7/detalleCotizaciones.cfm"></cf_Lightbox>
    <cf_Lightbox link="" Titulo="Justificación del Rechazo" width="40" height="30" name="JustRechazo" url="/cfmx/proyecto7/justifiRechazo.cfm"></cf_Lightbox>
</form>
<script language="javascript" type="text/javascript">
		function fnObtDetalles(CMPi,Ecodigo){
			fnLightBoxSetURL_DetaCotizacion("/cfmx/proyecto7/detalleCotizaciones.cfm?CMPi="+CMPi+"&Ecodigo="+Ecodigo);
			fnLightBoxOpen_DetaCotizacion();
		}
		function funcAprobar(CMPi,Ecodigo) {
			if(!confirm("Está seguro de Aprobar la cotización?"))
				return false;
			document.lista.action = "/cfmx/sif/cm/operacion/evaluar-Aplicar.cfm?chk="+CMPi+"&btnAprobar=btnAprobar&Ecodigo="+Ecodigo;
			document.lista.submit();
		}
		function funcRechazar(CMPi,Ecodigo) {
			fnLightBoxSetURL_JustRechazo("/cfmx/proyecto7/justifiRechazo.cfm?CMPi="+CMPi+"&Ecodigo="+Ecodigo);
			fnLightBoxOpen_JustRechazo();
		}
		
		
</script>