	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>  
 <cfset imprimirProyecto = true>
   <cfset url.GELid = form.GELid >   <cfset url.url ="AprobarTrans_formLiq.cfm" >
<cfif isdefined ('form.botonSel') and form.botonSel EQ "Aprobar">
	<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEliquidacion_Aprobar">
		<cfinvokeargument name="GELid"  		value="#form.GELid#">
		<cfinvokeargument name="FormaPago" 		value="#form.FormaPago#">
	</cfinvoke>	

	<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cfinclude template="../sif/tesoreria/GestionEmpleados/LiquidacionImprimirCCH.cfm">					
	<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cfinclude template="../sif/tesoreria/GestionEmpleados/LiquidacionImpresion_form.cfm"> 
	</cfif>	
</cfif>

<!---Rechazar--->
<cfif isdefined ('form.botonSel') and form.botonSel EQ "Rechazar">
	<cfquery name="ActualizaDet" datasource="#session.dsn#">
			update GEliquidacionGasto 
			   set  GELGestado = 3
			 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery>
	<cfquery name="ActualizaEncabe" datasource="#session.dsn#">
		update GEliquidacion
			set GELestado= 3
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery>

<!---MOTIVO DE RECHAZO --->
	<cfquery name="ActualizaEncabe3" datasource="#session.dsn#">
		update GEliquidacion
		 set  GELmsgRechazo ='#msgRechazo#',
		 UsucodigoRechazo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery>
	<cfquery name="EliminaDetalles" datasource="#session.dsn#">
		delete from  GEliquidacionAnts
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery>    
	<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cfinclude template="../sif/tesoreria/GestionEmpleados/LiquidacionImprimirCCH.cfm">				
	<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cfinclude template="../sif/tesoreria/GestionEmpleados/LiquidacionImpresion_form.cfm"> 
	</cfif>		
</cfif>
<script language="javascript">
$(document).ready(function () {
	 window.setTimeout("fnImgPrint();",1000);
	  window.setTimeout("window.parent.document.form1.submit();",1500);
	window.parent.document.form1.action = "gastosEmpleados.cfm";
})
</script>


