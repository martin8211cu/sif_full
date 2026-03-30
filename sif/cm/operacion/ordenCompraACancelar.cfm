<cfset lvarProvCorp = false>
<cfparam name="form.Ecodigo_f" default="#Session.Ecodigo#">
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
    <cfquery name="rsEProvCorp" datasource="#session.DSN#">
        select EPCid
        from EProveduriaCorporativa
        where Ecodigo = #session.Ecodigo#
         and EPCempresaAdmin = #session.Ecodigo#
    </cfquery>
    <cfif rsEProvCorp.recordcount eq 0>
    	<cfthrow message="El Catálogo de Proveduría Corporativa no se ha configurado">
    </cfif>
    <cfquery name="rsDProvCorp" datasource="#session.DSN#">
        select DPCecodigo as Ecodigo, Edescripcion
        from DProveduriaCorporativa dpc
        	inner join Empresas e
            	on e.Ecodigo = dpc.DPCecodigo
        where dpc.Ecodigo = #session.Ecodigo#
         and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
       	union
        select e.Ecodigo, e.Edescripcion
        from Empresas e
        where e.Ecodigo = #session.Ecodigo#
        order by 2
    </cfquery>
</cfif>
<cfparam name="form.Cancelar" default="1">
<cf_templateheader title="Ordenes de Compra">
	<cf_web_portlet_start titulo="Ordenes de Compra">
		<cfinclude template="/sif/portlets/pNavegacionCM.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
             <fieldset>
                <legend>Justificación</legend>
                    <table align="center"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td><textarea name="textarea_justificacion" id="textarea_justificacion" rows="3" cols="125"></textarea></td>
                        </tr>
                        <tr>
                            <td class="Ayuda" align="center" style="color: ##FF0000; ">
                                Ind&iacute;que en esta &aacute;rea el motivo de la cancelaci&oacute;n!
                            </td>
                        </tr>
                    </table>
                </fieldset>
                </td>
            </tr>
            <tr><td>&nbsp;</td></tr>
            <tr>
                <td>
                    <fieldset >
                    <legend>Tipo de Cancelaci&oacute;n</legend>
                        <input type="radio" id="TipoCancelacion1"  name="TipoCancelacion" onclick="javascript: escogeMetodo();" <cfif form.Cancelar eq 1>checked="checked"</cfif>/>Cancelaci&oacute;n por &Oacute;rden de Compra
                        <input type="radio" id="TipoCancelacion2" name="TipoCancelacion" onclick="javascript: escogeMetodo();" <cfif form.Cancelar eq 2>checked="checked"</cfif>/>Cancelaci&oacute;n por lineas de la &Oacute;rden de Compra
                    </fieldset>
                </td>
            </tr>
            <tr>
				<td>
                        <cfinclude template="ordenCompraACancelar-cancelar.cfm">
                        <div id="CancelacionParcialLinea" style="display:<cfif form.Cancelar eq 1>none<cfelse>block</cfif>">
                            <cfinclude template="cancelacionOrdenes-filtro.cfm">
                             <cfif isdefined("form.EOidorden1") and form.EOidorden1 neq "">
                                <cfinclude template="ordenCompraACancelar-listaDet.cfm">
                              </cfif>  
                        </div>
                        
                       <div id="CancelacionOrden" style="display:<cfif form.Cancelar eq 1>block<cfelse>none</cfif>">
                            <cfinclude template="ordenCompra-filtroglobal.cfm">
                            <cfinclude template="ordenCompraACancelar-lista.cfm">
                       </div>
                </td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<script  language="javascript" type="text/javascript">
	function escogeMetodo()
	{
			if(document.getElementById('TipoCancelacion1').checked){
				document.getElementById('CancelacionOrden').style.display = 'block';
				document.getElementById('CancelacionParcialLinea').style.display = 'none';
			} else if (document.getElementById('TipoCancelacion2').checked){
				document.getElementById('CancelacionParcialLinea').style.display = 'block';
				document.getElementById('CancelacionOrden').style.display = 'none';
			}
	}
</script>