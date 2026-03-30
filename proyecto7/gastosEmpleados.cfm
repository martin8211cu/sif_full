<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>

<cf_templateheader title="Gestion de Autorizaciones" bloquear="true">
  	<div id="circle-menu3">
    	<div  class="titulo">Gastos Empleados</div>
        	<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbInicializaCatalogos">
            
            <cfquery name="rsTES" datasource="#session.dsn#">
                Select e.TESid, t.EcodigoAdm
                  from TESempresas e
                    inner join Tesoreria t
                        on t.TESid = e.TESid
                 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery>
            <cfif rsTES.recordCount EQ 0>
                <cfset Request.Error.Backs = 1>
                <cf_errorCode	code = "50798" msg = "ESTA EMPRESA NO HA SIDO INCLUIDA EN NINGUNA TESORERÍA">
            </cfif>
            <cfset session.Tesoreria.TESid = rsTES.TESid>
            <cfset session.Tesoreria.EcodigoAdm = rsTES.EcodigoAdm>

		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

        
        <cfset LvarSAporEmpleadoCFM = "gastosEmpleados.cfm">
        <cfif isdefined ('url.Tipo')>
            <cfset form.Tipo=#url.Tipo#>
        </cfif>
        
        <cfif isdefined ('url.CCHTrelacionada')>
            <cfset form.CCHTrelacionada=#url.CCHTrelacionada#>
        </cfif>
        <cfif isdefined ('url.GECid_comision')>
            <cfset form.idTransaccion=url.GECid_comision>
            <cfset form.CCHTrelacionada=url.GECid_comision>
            <cfset form.Tipo="COMISION">
        </cfif>
        
            <cfif isdefined("form.Tipo")>
                <cfif form.Tipo eq 'ANTICIPO'>
					<cfset form.GEAid= form.CCHTrelacionada>
                    <cfset form.GECid_comision= "-1">
                     <cfinclude template="AprobarTrans_formAnt.cfm" >
                <cfelseif form.Tipo eq 'COMISION'>
                    <cfset LvarComision = true>
                    <cfset form.GECid_comision= form.CCHTrelacionada>
                     <cfinclude template="AprobarTrans_formCom.cfm" >
                <cfelseif find('GASTO',form.Tipo)>
                    <cfset form.Tipo = 'GASTO'>
                    <cfset form.GELid= form.CCHTrelacionada> 
                    <cfinclude template="AprobarTrans_formLiq.cfm">
                </cfif>	
            <cfelse>
                <cfinclude template="AprobarTrans_Lista.cfm">
            </cfif>
             <form name="form1" id="form1" >
            </form>
	</div>
<cf_templatefooter>
