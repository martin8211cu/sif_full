<form style="margin: 0" action="popUp-Documentos.cfm" name="fsolicitud" id="fsolicitud" method="post">
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
         <td>
            <!---  Filtro  --->
            <cfoutput>
                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                    <tr>
                        <td class="tituloAlterno" align="center">Lista de Documentos</td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
                  <tr> 
                  	<td class="fileLabel" nowrap width="8%" align="left"><strong>Tipo Transaccion:</strong></td>
                    <td class="fileLabel" nowrap width="8%" align="left"><strong>Documento:</strong></td>
                    <td class="fileLabel" nowrap width="8%" align="left"><strong>Socio Negocio:</strong></td>
                    <td class="fileLabel" nowrap width="8%" align="left">&nbsp;</td>
                  </tr>
                  <tr>	
                  	<td nowrap width="21%">
                    	<input type="text" name="CCTdescripcion" size="30" maxlength="20" value="<cfif isdefined('form.CCTdescripcion')>#form.CCTdescripcion#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>
                    <td nowrap width="21%">
                    	<input type="text" name="Ddocumento" size="20" maxlength="20" value="<cfif isdefined('form.Ddocumento')>#form.Ddocumento#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>
                    <td nowrap width="21%">
                    	<input type="text" name="SNnombre" size="20" maxlength="20" value="<cfif isdefined('form.SNnombre')>#form.SNnombre#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>
                    <td width="27%" rowspan="1" align="center" valign="center"><input type="submit" name="btnFiltro" value="Filtrar"></td>
                  </tr>
                  
                </table>
            </cfoutput>
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
</table>
 
	<cfset LvarMaxRows = 25>
    
    <cfquery name="rsListaItems" datasource="#session.dsn#">
        select 
        ct.CCTdescripcion, d.Ddocumento, s.SNnombre, d.Dtotal, d.Dsaldo,d.CCTcodigo,
        d.Mcodigo, d.Dtipocambio
        from Documentos d 
          inner join CCTransacciones ct 
          on ct.CCTcodigo = d.CCTcodigo 
          and ct.Ecodigo = d.Ecodigo
          inner join SNegocios s
          on s.SNcodigo = d.SNcodigo
          and s.Ecodigo = d.Ecodigo
        where d.Ecodigo = #Session.Ecodigo# 
        and ct.CCTtipo = 'C' 
        and ct.CCTvencim <> -1 
		<cfif isdefined("form.CCTdescripcion") and len(trim(form.CCTdescripcion))>
            and upper(ct.CCTdescripcion) like upper('%#form.CCTdescripcion#%')
        </cfif>
        <cfif isdefined("form.Ddocumento") and len(trim(form.Ddocumento))>
            and upper(d.Ddocumento) like upper('%#form.Ddocumento#%')
        </cfif>
        <cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
            and upper(s.SNnombre) like upper('%#form.SNnombre#%')
        </cfif>
        <cfif isdefined("url.soc") and len(trim(url.soc))>
            and d.SNcodigo = #url.soc#
        </cfif>
        and (d.Dsaldo) > 0
        order by d.Ddocumento
	</cfquery>
    
    <cfquery name="rsMonedas" datasource="#session.dsn#">
		select Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
		from Monedas m
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		order by Mnombre
	</cfquery>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <cfset navegacion = "">
    
                <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
                    <cfinvokeargument name="query" value="#rsListaItems#">
                    <cfinvokeargument name="desplegar" value="CCTdescripcion,Ddocumento,SNnombre,Dsaldo">
                    <cfinvokeargument name="etiquetas" value="Tipo Transaccion,Documento,Socio Negocio,Saldo">
                    <cfinvokeargument name="formatos" value="S,S,S,M">
                    <cfinvokeargument name="align" value="left,left,left,right">
                    <cfinvokeargument name="ajustar" value="S">
                    <cfif isdefined ("rsListaItems") and rsListaItems.recordcount GT 0>
                        <cfinvokeargument name="botones" value="Agregar,Cerrar"/>
                    <cfelse>
                        <cfinvokeargument name="botones" value="Cerrar"/>
                    </cfif>
                    <cfinvokeargument name="showEmptyListMsg" value="true">
                    <cfinvokeargument name="showLink" value="false">
                    <cfinvokeargument name="formName" value="fsolicitud">
                    <cfinvokeargument name="maxrows" value="#LvarMaxRows#"/>
                    <cfinvokeargument name="keys" value="Ddocumento,Dsaldo,Mcodigo,Dtipocambio">
                    <cfinvokeargument name="funcion" value="funcAgregar">
                    <cfinvokeargument name="fparams" value="Ddocumento,Dsaldo,Mcodigo,Dtipocambio,CCTcodigo">
                    <cfinvokeargument name="navegacion" value="#navegacion#"/>
                    <cfinvokeargument name="usaAjax" value="true"/>
                    <cfinvokeargument name="conexion" value="#session.dsn#"/>
                    <cfinvokeargument name="incluyeForm" value="false"/>
                </cfinvoke>
            </td>
        </tr>
    </table>
</form>

	
	<script language='javascript' type='text/JavaScript' >
    <!--//
		function funcAgregar(documento, saldo, moneda, tipoC, CCTcodigo){
				window.opener.document.form1.FPmontoori.value = saldo;
				tipoC = window.opener.fm(tipoC,2);
				window.opener.document.form1.FPtc.value       = tipoC;
				i = 0;
				<cfoutput query="rsMonedas">
					if(window.opener.document.form1.Mcodigo.options[i].value == moneda){
                        window.opener.document.form1.Mcodigo.options[i].selected = true;
					}
					i++;
				</cfoutput>
				window.opener.document.form1.Dsaldo.value     = saldo;
				window.opener.document.form1.CCTcodigo.value  = CCTcodigo;
				window.opener.document.form1.Ddocumento.value = documento;
				window.opener.setMontoLocal();
				window.close();
        }
		function funcCerrar(){
			window.close();
		}
    //-->
    </script>
    
    <hr width="99%" align="center">

