<!--- Lee parametro de Publicacion --->
<cfquery name="rsPublica" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and Pcodigo=570
</cfquery>

<script language="javascript" type="text/javascript">
	
	function ValidaEstado(EstProc,CMPid){
		var param = "?CMPid="+CMPid+"&OPT=1";
		     if (EstProc == 0)  {document.location.href ="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>"+param}
		else if (EstProc == 10) {document.location.href ="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>"+param}
		else if (EstProc == 50) {alert('El estado no permite su modificación');return false;}
		else if (EstProc == 79) {alert('El estado no permite su modificación');return false;}
		else if (EstProc == 81) {alert('El estado no permite su modificación');return false;}
		else if (EstProc == 83) {document.location.href ="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>"+param}
		else if (EstProc == 85) {alert('El estado no permite su modificación');return false;}
		else {alert('El estado no permite su modificación');return false;}
	}
	function funcAnular_Proceso() {
		var continuar = false;
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				continuar = document.form1.chk.checked;
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) {
						continuar = true;
						break;
					}
				}
			}
			if (!continuar) {
				alert('Debe seleccionar al menos un proceso de compra');
			} else {
				continuar = (confirm('¿Está seguro de que desea anular los procesos de compra seleccionados?'));
				document.form1.opt.value = "0";
				document.form1.CMPID.value = "";
				if (document.form1.chk.value) {
					document.form1.CMPID.value = document.form1.chk.value;
				} else {
					for (var i=0; i<document.form1.chk.length; i++) {
						if (document.form1.chk[i].checked) {
							document.form1.CMPID.value = document.form1.CMPID.value + (document.form1.CMPID.value != "" ? "," : "") + document.form1.chk[i].value;
						}
					}
				}
			}
		} else {
			alert('No hay ningún proceso de compra pendiente de publicar');
		}
		return continuar;
	}
</script>
<!--- 
	Podria deshabilitarse la eliminacion de un proceso de compra dependienndo de como se quiera

<cfif rsPublica.RecordCount gt 0 and rsPublica.Pvalor eq '1'>
	<cfset inactiveCol = "case when a.CMPestado = 0 or a.CMPestado = 83 then 0 else a.CMPid end">
<cfelse>
	<cfset inactiveCol = "case when a.CMPestado = 0 or a.CMPestado = 83 then 0 else a.CMPid end">
</cfif>--->
<cfset inactiveCol ="1">


<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
	
<cfset filtro = "">
<cfoutput>
	<cfif isdefined('form.CMPnumero_f') and form.CMPnumero_f NEQ ''>
		<cfset filtro = filtro & " and CMPnumero = #form.CMPnumero_f#">
	</cfif>
	<cfif isdefined('form.CMPfechapublica_f') and form.CMPfechapublica_f NEQ ''>
		<cfset filtro = filtro & " and CMPfechapublica >= #LSParseDateTime(form.CMPfechapublica_f)#" >
	</cfif>			
	<cfif isdefined('form.CMPfmaxofertas_f') and form.CMPfmaxofertas_f NEQ ''>
		<cfset filtro = filtro & " and CMPfmaxofertas <= #LSParseDateTime(form.CMPfmaxofertas_f)#" >
	</cfif>		
	
	<cfif isdefined('form.CMPestado_f') and form.CMPestado_f NEQ '-1'>
		<cfset filtro = filtro & " and a.CMPestado = #form.CMPestado_f#" >
	</cfif>	
    <!---►►Filtro por Numero de Solicitud◄◄--->
    <cfif isdefined('form.ESnumeroF') and LEN(TRIM(form.ESnumeroF))>
    	<cfset filtro = filtro & " and (select count(1) 
										from CMLineasProceso lp
											inner join ESolicitudCompraCM es
												on es.ESidsolicitud =  lp.ESidsolicitud 
									  where lp.CMPid = a.CMPid
										 and es.ESnumero = #form.ESnumeroF#) > 0">
    </cfif>	
</cfoutput>
<form name="filtroProcesos" method="post" style="margin:0;" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
	<input type="hidden" name="opt" value="0">
	<table width="100%"  border="0" class="areaFiltro">
      <tr>
        <td width="22%" align="right"><strong>Num. Proceso:</strong></td>
        <td width="19%"><input type="text" name="CMPnumero_f" id="CMPnumero_f" style="text-align:right"size="15" maxlength="10" 
			onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
			onFocus="javascript:this.select();" 
			onChange="javascript: fm(this,-1);"
			value="<cfif isdefined('form.CMPnumero_f') and form.CMPnumero_f NEQ ''><cfoutput>#form.CMPnumero_f#</cfoutput></cfif>"></td>
        <td width="22%" align="right" nowrap><strong>Fecha de Publicaci&oacute;n:</strong></td>
        <td width="29%">
			<cfset fechaPublica = ''>
			<cfif isdefined('form.CMPfechapublica_f') and form.CMPfechapublica_f NEQ ''>
				<cfset fechaPublica = form.CMPfechapublica_f>
			</cfif>
			
			<cf_sifcalendario form="filtroProcesos" value="#fechaPublica#" name="CMPfechapublica_f">		
		</td>
        <td width="8%" rowspan="2" align="center" valign="middle">
			<input name="btnFiltrar" type="submit" id="btnFiltrar2" class="btnFiltrar" value="Filtrar">
		</td>
      </tr>
      <tr>
      	<!---►►Numero de Solicitud◄◄--->
      	<cfparam name="form.ESnumeroF" default="">
        <td align="right" nowrap><strong>Num.Solicitud: </strong></td>
        <td><cf_inputNumber name="ESnumeroF" value="#form.ESnumeroF#" comas="false"></td>
        
        <td align="right" nowrap><strong>Fecha Max. Cotización:</strong></td>
        <td>
			<cfset fechaMax = ''>
			<cfif isdefined('form.CMPfmaxofertas_f') and form.CMPfmaxofertas_f NEQ ''>
				<cfset fechaMax = form.CMPfmaxofertas_f>
			</cfif>
			<cf_sifcalendario form="filtroProcesos" value="#fechaMax#" name="CMPfmaxofertas_f">		
		</td>
      </tr>
      <cfif lvarProvCorp>
      	<tr>
         <td align="right" nowrap><strong>Estado: </strong></td>
        <td>
        	<cfparam name="form.CMPestado_f" default="-1">
        	<select name="CMPestado_f">
                <option value="-1" <cfif form.CMPestado_f EQ -1>selected="selected"</cfif>>--Todos--</option>
                <option value="0"  <cfif form.CMPestado_f EQ 0>selected="selected"</cfif>>No Publicado</option>
                <option value="10" <cfif form.CMPestado_f EQ 10>selected="selected"</cfif>>Publicado</option>
                <!---<option value="50" <cfif form.CMPestado_f EQ 50>selected="selected"</cfif>>Orden de Compra</option>--->
                <option value="79" <cfif form.CMPestado_f EQ 79>selected="selected"</cfif>>Pediente de Aprobación Solicitante</option>
                <option value="81" <cfif form.CMPestado_f EQ 81>selected="selected"</cfif>>Aprobado por Solicitante</option>
                <option value="83" <cfif form.CMPestado_f EQ 83>selected="selected"</cfif>>Rechazado por Solicitante</option>
                <!---<option value="85" <cfif form.CMPestado_f EQ 85>selected="selected"</cfif>>Anulados</option>	--->		
			</select>
        </td>
        <td align="right" nowrap><strong>Empresa: </strong></td>
        <td >
        <select name="Ecodigo_f">
        	<cfloop query="rsDProvCorp">
            	<option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo) or (not isdefined('form.Ecodigo_f') and rsDProvCorp.Ecodigo EQ lvarFiltroEcodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
            </cfloop>	
		</select></td>
      </tr>
      </cfif>
    </table>
</form>

<form name="form1" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
	<input type="hidden" name="opt" value="1">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td>
        	<cf_dbfunction name="to_char" args="a.CMPid" returnvariable="lvarToCharCMPid">
            <cf_dbfunction name="to_char" args="a.CMPnumero" returnvariable="lvarToCharCMPnumero">
            <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
        	<cf_notas link="">
			<!---<cfif PublicarProceso>--->
            	<cfset lvarEstado = "case a.CMPestado 
										when 0 then 'No Publicado' 
										when 10 then 'Publicado' 
										when 50 then 'Orden de Compra' 
										when 79 then 'Pediente de Aprobación Solicitante' 
										when 81 then 'Aprobado por Solicitante' 
										when 83 then '<a id='''#_Cat##lvarToCharCMPid##_Cat#''' onmouseover=""fnMostrarToolTip_1($(''##'#_Cat##lvarToCharCMPid##_Cat#'''),''Justificación del Rechazo, Num. Proceso: '#_Cat##lvarToCharCMPnumero##_Cat#''','''#_Cat#a.CMPjustificacionRechazo#_Cat#''')"">Rechazado</a>' 
										else 'Desconocido' end">
            <!---<cfelse>
                <cfset lvarEstado = "case a.CMPestado when 0 then 'No Aplicado' when 83 then '<a id='''#_Cat##lvarToCharCMPid##_Cat#''' onmouseover=""fnMostrarToolTip_1($(''##'#_Cat##lvarToCharCMPid##_Cat#'''),''Justificación del Rechazo, Num. Proceso: '#_Cat##lvarToCharCMPnumero##_Cat#''','''#_Cat#a.CMPjustificacionRechazo#_Cat#''')"">Rechazado</a>' else 'Aplicado' end">
           	</cfif>--->
            
            <cfset LvarOrderBy = "a.fechaalta">
            <cfif isdefined("form.Colname") and form.Colname neq "" and Colorder neq 0>
            	<cfset LvarOrderBy = form.Colname>
            </cfif>
                        
			<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet">
				<cfinvokeargument name="tabla" 			value="CMProcesoCompra a left outer join CMNotas N on a.CMPid = N.CMPid and N.CMNestado = 1"/>
				<cfinvokeargument name="columnas" 		value="a.CMPnumero,a.CMPid, a.CMPdescripcion, a.CMPfechapublica, a.CMPfmaxofertas, #lvarEstado# as CMPestado,a.CMPestado as EstProc,
														 #inactiveCol# as inactive, N.CMNtipo"/>
				<cfinvokeargument name="desplegar" 		value="CMPnumero,CMPdescripcion, CMPfechapublica, CMPfmaxofertas,CMNtipo, CMPestado"/>
				<cfinvokeargument name="etiquetas" 		value="<a href=""javascript:fnFiltrarLista('a.CMPnumero')"">Num. Proceso</a>,
                																					<a href=""javascript:fnFiltrarLista('a.CMPdescripcion')"">Descripci&oacute;n</a>, 
                                                                                                    <a href=""javascript:fnFiltrarLista('a.CMPfechapublica')"">Fecha de Publicaci&oacute;n</a>, 
                                                                                                    <a href=""javascript:fnFiltrarLista('a.CMPfmaxofertas')"">Fecha M&aacute;xima para Cotizaci&oacute;n</a>,
                                                                                                    Proceso Activo, 
                                                                                                    <a href=""javascript:fnFiltrarLista('a.CMPestado')"">Estado</a>"/>
				<cfinvokeargument name="formatos" 		value="V,V,D,D,V,V"/>
				<cfinvokeargument name="filtro" 		value=" a.CMCid = #Session.Compras.Comprador#
														and a.CMPestado in (0,10,79,81,83)										
														and a.Ecodigo = #lvarFiltroEcodigo#
                                                        #filtro#														
														order by #LvarOrderBy# 
														"/>
				<cfinvokeargument name="align" 			value="left, left, center, center, left, center"/>
				<cfinvokeargument name="checkboxes" 	value="S"/>
				<cfinvokeargument name="ajustar" 		value="N"/>
				<cfinvokeargument name="irA" 			value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="keys" 			value="CMPid"/>
				<cfinvokeargument name="inactivecol" 	value="inactive"/>
				<cfinvokeargument name="MaxRows" 		value="20"/>
				<cfinvokeargument name="formName" 		value="form1"/>
				<cfinvokeargument name="incluyeForm" 	value="false"/>
				<cfinvokeargument name="botones" 		value="Anular_Proceso"/>
				<cfinvokeargument name="debug" 			value="N"/>
                <cfinvokeargument name="funcion" 		value="return ValidaEstado"/>
                <cfinvokeargument name="fparams" 		value="EstProc,CMPid">
                
			</cfinvoke>
		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
    <input type="hidden" name="Colorder" value="0" />
    <input type="hidden" name="Colname" value="0" />
</form>

<script>
function fnFiltrarLista(columna)
{
	document.form1.Colorder.value=1;
	document.form1.Colname.value=columna;
	document.form1.submit();
}
</script>