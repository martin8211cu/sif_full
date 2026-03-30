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
	select CMCid, CMCnombre, Usucodigo, CMCjefe 
	from CMCompradores 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and CMCestado = 1
	order by CMCjefe
</cfquery>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_dbfunction name="to_char" args="a.CMPid" returnvariable="lvarToCharCMPid">
<cf_dbfunction name="to_char" args="a.CMPnumero" returnvariable="lvarToCharCMPnumero">
<cfquery name="qryLista" datasource="#session.dsn#">
	select Distinct 0 as OPT, a.CMPnumero, a.CMPid, a.CMPdescripcion, a.CMPfechapublica, a.CMPfmaxofertas, 
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
                                                where sxa.ProcessInstanceId = es.ProcessInstanceid))
						 #_Cat#
                    (select max( u.Usulogin)
            	  		from DSolicitudCompraCM ds
                        inner join ESolicitudCompraCM es
                           on es.ESidsolicitud = ds.ESidsolicitud
                  	    inner join Usuario u
                    	    on u.Usucodigo = es.Usucodigo
                      where dc.CMPid = a.CMPid
                         and ds.DSlinea = dc.DSlinea
                         and es.ProcessInstanceid is null) 
						 
						 #_Cat# 
						 case when a.CMPestado = 83 
                         then 
						 	'&nbsp;<a id="'#_Cat#'#lvarToCharCMPid#'#_Cat#'" onmouseover="fnMostrarToolTip_1($(''##'#_Cat#'#lvarToCharCMPid#'#_Cat#'''),''Justificación del Rechazo, Num. Proceso: '#_Cat#'#lvarToCharCMPnumero#'#_Cat#''','''#_Cat#a.CMPjustificacionRechazo#_Cat#''')">
							 <img src="/cfmx/sif/imagenes/notas2.gif" /></a>' 
						 else 
                         	'_' 
                         end 
                        

                else '-'  end as AprobadorSolicitante
     </cfif>
	from CMProcesoCompra a
    	 left Outer join DCotizacionesCM dc
        	on dc.CMPid = a.CMPid
	where a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<cfif not lvarSolicitante>
	<cfset lvarIrA = "evaluarCotizaciones.cfm">
<cfelse>
    <cfset lvarIrA = "evaluarCotizacionesSolicitante.cfm">
</cfif>
<form name="lista" method="post" action="<cfoutput>#lvarIrA#</cfoutput>">
	<table width="100%"  border="0" class="areaFiltro">
	  <tr>
      	<cfif not lvarSolicitante>
	  	<td class="fileLabel" align="right" width="11%" nowrap>
			Comprador:
		</td>
		<td width="29%" nowrap>
			  <select name="CMCid" onChange="javascript: this.form.OPT.value='0'">
		          <option value="-1" <cfif isdefined("form.CMCid") and Len(Trim(Form.CMCid)) and Form.CMCid EQ -1> selected</cfif>>(Todos)</option>
		            <cfoutput query="rsCompradores">
			          <option value="#rsCompradores.CMCid#" <cfif isdefined("form.CMCid") and Len(Trim(Form.CMCid))><cfif Form.CMCid EQ rsCompradores.CMCid> selected</cfif><cfelseif Session.Compras.Comprador EQ rsCompradores.CMCid> selected</cfif>>#rsCompradores.CMCnombre#</option>
		              </cfoutput>
	          </select>		</td>
       	</cfif>
	    <td width="24%" align="right" class="fileLabel" nowrap>Num. Proceso de Compra: </td>
	    <td width="24%" nowrap>
			<input type="text" name="CMPnumero_f" id="CMPnumero_f" style="text-align:right"size="15" maxlength="10" 
				onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
				onFocus="javascript:this.select();" 
				onChange="javascript: fm(this,-1);"
				value="<cfif isdefined('form.CMPnumero_f') and form.CMPnumero_f NEQ ''><cfoutput>#form.CMPnumero_f#</cfoutput></cfif>">		
		</td>
	    <td width="12%" rowspan="2" nowrap valign="middle" align="center">
        	<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" class="btnFiltrar">
        </td>
	  </tr>
	  <tr>
	    <td class="fileLabel" align="right" nowrap>Descripci&oacute;n:</td>
	    <td nowrap>
			<input name="CMPdescripcion_f" value="<cfif isdefined('form.CMPdescripcion_f') and form.CMPdescripcion_f NEQ ''><cfoutput>#form.CMPdescripcion_f#</cfoutput></cfif>" type="text" id="ESobservacion_f" size="60" maxlength="255">
		</td>
	    <td class="fileLabel" align="right" nowrap>Fecha M&aacute;xima para Cotizaci&oacute;n: </td>
	    <td nowrap>
			<cfset fechaMax = ''>
			<cfif isdefined('form.CMPfmaxofertas_f') and form.CMPfmaxofertas_f NEQ ''>
				<cfset fechaMax = form.CMPfmaxofertas_f>
			</cfif>
			
			<cf_sifcalendario form="lista" value="#fechaMax#" name="CMPfmaxofertas_f">			
		</td>
      </tr>
	</table>
	
<cfif not lvarSolicitante>
    	<cfset lvarIrA = "evaluarCotizaciones.cfm">
        <cfset lvardesplegar = "CMPnumero,CMPdescripcion, CMPfechapublica, CMPfmaxofertas, ECcount, AprobadorSolicitante">
        <cfset lvaretiquetas = "Num. Proceso, Descripción, Fecha de Publicación, Fecha Máxima para Cotización, Cotizaciones Recibidas, Solicitante Aprobador">
   		<cfset lvarBotones = "Evaluar">
   		<cf_notas link="">
        <style type="text/css">
			.rechazarPC{
				background-image:url('/cfmx/sif/imagenes/notas2.gif');
				
			}
		</style>
    <cfelse>
    	<cfset lvarIrA = "evaluarCotizacionesSolicitante.cfm">
        <cfset lvardesplegar = "CMPnumero,CMPdescripcion, CMPfechapublica, CMPfmaxofertas">
        <cfset lvaretiquetas = "Num. Proceso, Descripción, Fecha de Publicación, Fecha Máxima para Cotización">
    	<cfset lvarBotones = "Aprobar,Rechazar">
    <table width="100%"><tr><td align="center" nowrap><strong>Justificaci&oacute;n Rechazo:</strong><input name="CMPjustificacionRechazo" id="CMPjustificacionRechazo" type="text" maxlength="100" style="width:70%" value="" /></td></tr></table>
</cfif>
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="qryLista">
            <cfinvokeargument name="query" 				value="#qryLista#">
            <cfinvokeargument name="desplegar" 			value="#lvardesplegar#"/>
            <cfinvokeargument name="etiquetas" 			value="#lvaretiquetas#"/>
            <cfinvokeargument name="formatos" 			value="V,V,D,D,V,S"/>
            <cfinvokeargument name="align" 				value="center, left, center, center, center, center"/>
            <cfinvokeargument name="ajustar" 			value="N"/>
            <cfinvokeargument name="irA" 				value="#lvarIrA#"/>
            <cfinvokeargument name="radios" 			value="S"/>
            <cfinvokeargument name="botones" 			value="#lvarBotones#"/>
            <cfinvokeargument name="formName" 			value="lista"/>
            <cfinvokeargument name="incluyeForm" 		value="false"/>
            <cfinvokeargument name="keys" 				value="CMPid"/>
            <cfinvokeargument name="funcion" 			value="funcProcesar"/>
            <cfinvokeargument name="fparams" 			value="CMPid,ECcount"/>
            <cfinvokeargument name="inactivecol" 		value="filasdesactivadas"/>
            <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
            <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
            <cfinvokeargument name="EmptyListMsg" 		value="-- No se encontraron procesos de compra generados por el comprador seleccionado --"/>
        <cfif not lvarSolicitante>
        	<cfinvokeargument name="lineaAzul" 			value="CMPestado eq 79"/>
            <cfinvokeargument name="lineaVerde" 		value="CMPestado eq 81"/>
            <cfinvokeargument name="lineaRoja" 			value="CMPestado eq 83"/>
        </cfif>
	</cfinvoke>
    <cfif not lvarSolicitante>
    	<table>
        	<tr><td><p style="color:#0000FF">Las lineas en color azul est&aacute;n a la espera de ser aprobadas por el solicitante.</p></td></tr>
            <tr><td><p style="color:#00CC00">Las lineas en color verde ya han sido aprobadas por el solicitante.</p></td></tr>
            <tr><td><p style="color:#FF0000">Las lineas en color rojo han sido rechazadas por el solicitante.</p></td></tr>
        </table>
    </cfif>	

</form>
<script language="javascript" type="text/javascript">
	<!--//
		function hayAlgunoChequeado(){
			if (document.lista.chk) {
				if (document.lista.chk.value) {
					return (document.lista.chk.checked);
				} else {
					for (var i=0; i<document.lista.chk.length; i++) {
						if (document.lista.chk[i].checked) return true;
					}
				}
			}
			return false;
		}
		function funcProcesar(cmpid, eccount){
			if (eccount>0){
				document.lista.CMPID.value = cmpid;
				document.lista.OPT.value = 1;
				document.lista.submit();
				return true;
			} else {
				alert('El Proceso de Compra seleccionado no tiene ninguna cotización!');
				return false;
			}
		}		
		function funcEvaluar() {
			//validar que haya un option seleccionado
			if (hayAlgunoChequeado()) {
				//document.lista.CMPID.value = document.lista.chk.value;
				document.lista.OPT.value = 3;
				document.lista.submit();
				return true;
			} else {
				alert('Debe seleccionar un Proceso de Compra!');
				return false;
			}
		}
		
		function funcAprobar() {
			//validar que haya un option seleccionado
			if (hayAlgunoChequeado()) {
				if(!confirm("Está seguro de Aprobar la cotización?"))
					return false;
				document.lista.action = "evaluar-Aplicar.cfm";
				
			} else {
				alert('Debe seleccionar un Proceso de Compra!');
				return false;
			}
		}
		function funcRechazar() {
			//validar que haya un option seleccionado
			if (hayAlgunoChequeado()) {
				if(document.lista.CMPjustificacionRechazo.value.replace(/^\s+|\s+$/g,"") == ""){
					alert("El campo Justificación Rechazo es requerido.");
					return false;
				}
				if(!confirm("Está seguro de Rechazar la cotización?"))
					return false;
				document.lista.action = "evaluar-Aplicar.cfm";
				document.lista.submit();
				return true;
			} else {
				alert('Debe seleccionar un Proceso de Compra!');
				return false;
			}
		}
	//-->
</script>