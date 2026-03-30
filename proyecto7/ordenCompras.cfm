<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>

<cf_templateheader title="Gestion de Autorizaciones" bloquear="true">
  	<div id="circle-menu3">
    	<div  class="titulo">Orden de Compras</div>
			<cfset lvarProvCorp = false>
            <cfquery name="rsProvCorp" datasource="#session.DSN#">
                select Pvalor 
                from Parametros 
                where Ecodigo=#session.Ecodigo#
                and Pcodigo=5100
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
            <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td></td>
                </tr>
                <tr><td>&nbsp;</td></tr>
            </table>
            <cfinclude template="autorizaOrden-form.cfm">
	</div>
<cf_templatefooter>
