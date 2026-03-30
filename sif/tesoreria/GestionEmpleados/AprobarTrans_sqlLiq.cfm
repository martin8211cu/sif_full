<!---Ir a lista--->
<cfif IsDefined("form.irLista")>
	<cflocation url="AprobarTrans.cfm">
</cfif>



<cfif IsDefined("form.Aprobar")>
	<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEliquidacion_Aprobar">
		<cfinvokeargument name="GELid"  		value="#form.GELid#">
		<cfinvokeargument name="FormaPago" 		value="#form.FormaPago#">
	</cfinvoke>

	<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImprimirCCH.cfm?GELid=#form.GELid#&url=AprobarTrans">
	<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImpresion_form.cfm?GELid=#form.GELid#&url=AprobarTrans">
	</cfif>
	<cflocation url="AprobarTrans.cfm">
</cfif>


<!---Rechazar--->
<cfif IsDefined("form.Rechazar")>
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

	<!--- <cfquery name="deleteCFDI" datasource="#session.dsn#">
		delete from CERepoTMP
		where Ecodigo = #Session.Ecodigo# and ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery> --->

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
		<cflocation url="LiquidacionImprimirCCH.cfm?GELid=#form.GELid#&url=AprobarTrans">
	<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImpresion_form.cfm?GELid=#form.GELid#&url=AprobarTrans">
	</cfif>
	<cflocation url="AprobarTrans.cfm">
</cfif>


