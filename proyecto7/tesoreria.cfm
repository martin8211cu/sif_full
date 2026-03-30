<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>

<cf_templateheader title="Gestion de Autorizaciones" bloquear="true">
  	<div id="circle-menu3">
    	<div  class="titulo">Tesoreria</div>
        <div style="width:inherit; height:inherit;"> 
        <cfset Session.Tesoreria.ordenesPagoIrLista = "">
		<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
        <cf_navegacion name="TESOPid" navegacion="">
        <cfif isdefined("form.TESOPid")>
            <cfset Session.Tesoreria.ordenesPagoIrLista = "../Solicitudes/#Session.Tesoreria.solicitudesCFM#">
            <cflocation url="../Pagos/ordenesPago.cfm?TESOPid=#form.TESOPid#&PASO=10">
        </cfif>
    
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

    
        <cfif isdefined("form.btnAprobar")>
            <cfinclude template="solicitudesAprobar_sql.cfm">
        <cfelseif isdefined("form.TESSPid")>
            <cfinclude template="solicitudesAprobar_form.cfm">
        <cfelse>
           <cfset titulo = 'Solicitudes de Pago a Aprobar'>
				<cf_SP_lista aprobacionSP="yes" irA="tesoreria.cfm">
        </cfif>
        <form name="form1" id="form1" action="tesoreria.cfm">
        </form>
        </div>
	</div>
<cf_templatefooter>
