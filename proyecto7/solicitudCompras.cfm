<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>
<cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkload" returnvariable="workload">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
</cfinvoke>
<cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkloadGestionAutorizaciones" returnvariable="SolicitudCNRP">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
</cfinvoke>

<cf_templateheader title="Gestion de Autorizaciones" bloquear="true">
  	<div id="circle-menu3">
    	<div  class="titulo">Solicitud de Compras</div>
        <cfinclude template="formsolicitudCompras.cfm">
	</div>
<cf_templatefooter>