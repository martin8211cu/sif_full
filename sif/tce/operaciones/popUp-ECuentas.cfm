<!---<cfset Bid = url.Bid>
<cfset CBPTCid = url.CBPTCid>
<cfdump var="#Bid#">
<cfdump var="#CBPTCid#">--->

<cfif not isdefined("form.Bid") and isdefined ("url.Bid") and len(trim(url.Bid))>
    <cfset form.Bid = url.Bid>
</cfif>

<cfif not isdefined("form.CBPTCid") and isdefined ("url.CBPTCid") and len(trim(url.CBPTCid))>
    <cfset form.CBPTCid = url.CBPTCid>
</cfif>
<cfif not isdefined("form.Miso4217") and isdefined ("url.Miso4217") and len(trim(url.Miso4217))>
    <cfset form.Miso4217 = url.Miso4217>
</cfif>
<cfif not isdefined("form.Fecha") and isdefined ("url.Fecha") and len(trim(url.Fecha))>
    <cfset form.Fecha = url.Fecha>
</cfif>
<cfif not isdefined("form.TCambio") and isdefined ("url.TCambio") and len(url.TCambio)>
    <cfset form.TCambio = url.TCambio>
</cfif>

<form style="margin: 0" action="popUp-ECuentas.cfm" name="fsolicitud" id="fsolicitud" method="post">
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
         <td>
            <!---  Filtro  --->
            <cfoutput>
                <input type="hidden" value="#form.Bid#" 	 name="Bid">
                <input type="hidden" value="#form.CBPTCid#"  name="CBPTCid">
                <input type="hidden" value="#form.Miso4217#" name="Miso4217">
                <input type="hidden" value="#form.Fecha#"    name="Fecha">
                <input type="hidden" value="#form.TCambio#"  name="TCambio">
                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                    <tr>
                        <td class="tituloAlterno" align="center">Lista de Estados de Cuenta</td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
                  <tr> 
                    <td class="fileLabel" nowrap width="8%" align="left"><strong>Cuenta Bancaria:</strong></td>
                    <td class="fileLabel" nowrap width="8%" align="left"><strong>Descripci&oacute;n:</strong></td>
                    <td class="fileLabel" nowrap width="8%" align="left"><strong>Saldo:</strong></td>
                    <td class="fileLabel" nowrap width="8%" align="left">&nbsp;</td>
                  </tr>
                  <tr>	
                  	<td nowrap width="51%">
                    	<input type="text" name="CBancaria" size="55" maxlength="20" value="<cfif isdefined('form.CBancaria')>#form.CBancaria#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>
                    <td nowrap width="51%">
                    	<input type="text" name="CDescripcion" size="45" maxlength="20" value="<cfif isdefined('form.CDescripcion')>#form.CDescripcion#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>
                    <td nowrap width="31%">
                    	<input type="text" name="CSaldo" size="10" maxlength="20" value="<cfif isdefined('form.CSaldo')>#form.CSaldo#</cfif>" style="text-transform: uppercase;" tabindex="1">
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
        cb.CBdescripcion, 
        cb.CBid, 
        m.Mnombre, 
        m.Miso4217,
        ec.ECdescripcion, 
        (ec.ECsaldofin * -1) as ECsaldofin, 
        case #form.TCambio# when 1 then coalesce(htc.TCventa,1.00) else #form.TCambio# end as TCventa, 
        case m.Miso4217 when '#form.Miso4217#' then 1.00 else (case #form.TCambio# when 1 then coalesce(htc.TCventa,1.00) else #form.TCambio# end) end as TCventa2, 
        ec.ECid
        from ECuentaBancaria ec
            inner join CuentasBancos cb
            	on cb.CBid = ec.CBid
            inner join Monedas m
           		on m.Mcodigo = cb.Mcodigo
            	and m.Ecodigo = cb.Ecodigo
            inner join CBTarjetaCredito tc
            	on tc.CBTCid = cb.CBTCid
            inner join DatosEmpleado de
            	on de.DEid = tc.DEid
            left outer join Htipocambio htc
            	on htc.Mcodigo = m.Mcodigo
            	and htc.Ecodigo = cb.Ecodigo
            	and htc.Hfecha <= '#LSdateformat(form.Fecha,'yyyymmdd')#'
            	and htc.Hfechah > '#LSdateformat(form.Fecha,'yyyymmdd')#'
        where cb.Ecodigo = #session.Ecodigo# AND (ec.ECsaldofin * -1) > 0 
            and cb.CBesTCE = 1 
            and cb.Bid = #form.Bid#
            <cfif isdefined("form.CBancaria") and len(trim(form.CBancaria))>
            	and upper(cb.CBdescripcion) like upper('%#form.CBancaria#%')
			</cfif>
            <cfif isdefined("form.CDescripcion") and len(trim(form.CDescripcion))>
            	and upper(ec.ECdescripcion) like upper('%#form.CDescripcion#%')
			</cfif>
            <cfif isdefined("form.CSaldo") and len(trim(form.CSaldo))>
            	and (ec.ECsaldofin * -1) = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CSaldo#">
			</cfif>
           and not exists (select 1
                            from CBDPagoTCEdetalle ed1
                            inner join CBEPagoTCE pg1
                            on pg1.CBPTCid = ed1.CBPTCid
                            where ed1.ECid = ec.ECid
                            and pg1.CBPTCestatus = 13
                            and 0 = (select count(1) from CBEPagoTCE pgt
                            		where pgt.CBPTCidOri = pg1.CBPTCid))
            and not exists (select 1
                            from CBDPagoTCEdetalle ed
                            inner join CBEPagoTCE pg
                            on pg.CBPTCid = ed.CBPTCid
                            where ed.ECid = ec.ECid
                            and pg.CBPTCestatus <> 13)
            and not exists(select 1
                            from CBDPagoTCEdetalle ed2
                            inner join CBEPagoTCE pg2
                            on pg2.CBPTCid = ed2.CBPTCid
                            where pg2.CBPTCid = #form.CBPTCid#
                              and ed2.CBid = cb.CBid
                              and pg2.CBPTCestatus <> 13)
	</cfquery>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <cfset navegacion = "">
    
                <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
                    <cfinvokeargument name="query" value="#rsListaItems#">
                    <cfinvokeargument name="desplegar" value="CBdescripcion, ECdescripcion, ECsaldofin">
                    <cfinvokeargument name="etiquetas" value="Cuenta Bancaria, Descripcion,Saldo">
                    <cfinvokeargument name="formatos" value="S,S,M">
                    <cfinvokeargument name="align" value="eft,Left,Left">
                    <cfinvokeargument name="ajustar" value="S">
                    <cfif isdefined ("rsListaItems") and rsListaItems.recordcount GT 0>
                        <cfinvokeargument name="botones" value="Agregar,Cerrar"/>
                    <cfelse>
                        <cfinvokeargument name="botones" value="Cerrar"/>
                    </cfif>
                    <cfinvokeargument name="showEmptyListMsg" value="true">
                    <cfinvokeargument name="irA" value="TCEPago-SQL.cfm">
                    <cfinvokeargument name="showLink" value="false">
                    <cfinvokeargument name="formName" value="fsolicitud">
                    <cfinvokeargument name="maxrows" value="#LvarMaxRows#"/>
                    <cfinvokeargument name="keys" value="CBid,ECsaldofin,TCventa,ECid,TCventa2">
                    <cfinvokeargument name="fparams" value="CBdescripcion">
                    <cfinvokeargument name="checkboxes" value="S"/>
                    <cfinvokeargument name="checkall" value="S"/>
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
		function algunoMarcado(){
		var aplica = false;
		var form = document.fsolicitud;
		if (form.chk) {
			if (form.chk.value) {
				aplica = form.chk.checked;
			} else {
				for (var i=0; i<form.chk.length; i++) {
					if (form.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (aplica);
		} else {
			alert('Debe seleccionar al menos un Estado de Cuenta antes de realizar esta acción!');
			return false;
		}
		}
		
		function funcAgregar(){
			<cfoutput>
			if (algunoMarcado()){
			document.fsolicitud.action="TCEPago-SQL.cfm";
			return true;
			</cfoutput>
			}
			else{
				return false;
			}
        }
		function funcCerrar(){
			window.close();
		}
    //-->
    </script>
    
    <hr width="99%" align="center">

