<!--- <style>
/* Center the loader */
#loader {
  position: absolute;
  left: 46%;
  top: 40%;
  z-index: 1;
  width: 50px;
  height: 50px;
  margin: -24px 0 0 -24px;
  border: 10px solid #f3f3f3;
  border-radius: 70%;
  border-top: 10px solid #3498db;
  width: 120px;
  height: 120px;
  -webkit-animation: spin 2s linear infinite;
  animation: spin 2s linear infinite;
}

@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Add animation to "page content" */
.animate-bottom {
  position: relative;
  -webkit-animation-name: animatebottom;
  -webkit-animation-duration: 1s;
  animation-name: animatebottom;
  animation-duration: 1s
}

@-webkit-keyframes animatebottom {
  from { bottom:-100px; opacity:0 }
  to { bottom:0px; opacity:1 }
}

@keyframes animatebottom {
  from{ bottom:-100px; opacity:0 }
  to{ bottom:0; opacity:1 }
}

#myDiv {
  display: none;
  text-align: center;
}
</style>


<div id="loader"></div> --->
<cf_navegacion name="PASO" default="0" navegacion="">
<cf_navegacion name="TESSPid" default = "0" navegacion="">

<cfset Session.Tesoreria.ordenesPagoIrLista = "">
<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
<cf_navegacion name="TESOPid" navegacion="">
<cfif isdefined("form.TESOPid")>
	<cfset Session.Tesoreria.ordenesPagoIrLista = "../Solicitudes/#Session.Tesoreria.solicitudesCFM#">
	<cflocation url="../Pagos/ordenesPago.cfm?TESOPid=#form.TESOPid#&PASO=10">
</cfif>

<cfset GvarDetalleGrande = false>
<cfif form.PASO EQ "10">
	<cfquery datasource="#session.dsn#" name="rsDetalle">
		select count(1) cantidad
		  from TESdetallePago dp
		 where dp.TESSPid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
      and BMUsucodigo = #session.Usucodigo#
	</cfquery>
	<cfset GvarDetalleGrande = (rsDetalle.cantidad GT 50)>
	<cfif GvarDetalleGrande>
		<cf_templatecss>
		<cfinclude template="solicitudesCP_form.cfm">
		<cfabort>
	</cfif>
</cfif>


<cf_templateheader title="Preparación de Solicitudes de Pago de Documentos de CxP">
	<cfinclude template="TESid_Ecodigo.cfm">
	<cfif form.PASO EQ 0>
		<cfinclude template="solicitudesCP_lista.cfm">
	<cfelseif form.PASO EQ 10>
		<cfinclude template="solicitudesCP_form.cfm">
	<cfelseif form.PASO EQ 1>
		<cfinclude template="solicitudesCP_lista1Sel.cfm">
	<cfelseif form.PASO EQ 2>
		<cfinclude template="solicitudesCP_lista2Gen.cfm">
	<cfelseif form.PASO EQ 3>
		<cfinclude template="solicitudesCP_listaDocCxP.cfm">
	</cfif>
<cf_templatefooter>
<!---   --->

<script language="javascript" type="text/javascript">
	<!--- document.getElementById("loader").style.display = "none";

	function muestraLoading(){
		document.getElementById("loader").style.display = "initial";
	} --->
</script>