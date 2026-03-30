<!---<cfif IsDefined("form.CalcularTC")>
	<cflocation url="../sif/tesoreria/GestionEmpleados/SolAntViaticoTC_form.cfm?GEAid=#form.GEAid#&amp;LvarSAporEmpleadoCFM=#form.LvarSAporEmpleadoCFM#">
</cfif>--->

<cfif isdefined ('form.botonSel') and form.botonSel EQ "imprimir">
	<cf_Imprime_Aprobacion location="gastosEmpleados.cfm" devolver="AprobarTrans_formAnt.cfm">
    <cflocation url="gastosEmpleados.cfm">
</cfif>

<cfquery datasource="#session.dsn#" name="rsAnticipo">
	select GEAtotalOri,CCHTid,GEAmanual, GEAviatico, GEAtipoviatico,
			GEAdescripcion, GEAtotalOri, Mcodigo, CFcuenta,
			GECid as GECid_comision, GEAdesde, GEAhasta
	from GEanticipo 
	where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">	
</cfquery>

<!---Aprueba la solicitud de Anticipo--->
<cfif isdefined ('form.botonSel') and form.botonSel EQ "Aprobar">
	<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEanticipo_Aprobar">
		<cfinvokeargument name="GEAid"  		value="#form.GEAid#">
		<cfinvokeargument name="FormaPago" 		value="#form.FormaPago#">
		<!--- Crea nueva transacción de caja: Se esta aprobando una transaccion de COMISION. Ahora se crea la de ANTICIPO --->
		<cfinvokeargument name="CCHTid"  		value="-1">
		<cfinvokeargument name="GECid_comision"	value="#form.GECid_comision#">
	</cfinvoke>	
	<cfif isdefined ('form.chkImprimir')>
		<cf_Imprime_Aprobacion location="gastosEmpleados.cfm">
	</cfif>
</cfif>

<cfif isdefined ('form.botonSel') and form.botonSel EQ "Rechazar">
	<!--- En solicitudesAnticipo EnviarAprobar se incluyó en TransaccionesProceso COMISION no ANTICIPOS --->
	<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
				method="TranProceso" 
				returnvariable="LvarCCHTidProc">
		<cfinvokeargument name="Mcodigo" 			value="#rsAnticipo.Mcodigo#"/>
		<cfif rsAnticipo.CFcuenta NEQ "">
			<cfinvokeargument name="CFcuenta" 			value="#rsAnticipo.CFcuenta#"/>
		</cfif>
		<cfinvokeargument name="CCHTdescripcion" 	value="#rsAnticipo.GEAdescripcion#"/>
		<cfinvokeargument name="CCHTmonto"	 		value="#rsAnticipo.GEAtotalOri#"/>
		<cfinvokeargument name="CCHTestado" 		value="RECHAZADO"/>
		<cfinvokeargument name="CCHTtipo" 			value="ANTICIPO"/>
		<cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
		<cfinvokeargument name="CCHTrelacionada"    value="#form.GEAid#"/>
	</cfinvoke>

	<!--- Actulización del estado del Anticipo--->
	<cfquery name="rsActualiza" datasource="#session.DSN#">
		update GEanticipo 
		   set 	GEAestado =3,
				GEAmsgRechazo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GEAmsgRechazo#">
		 where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
		   and Ecodigo=#session.Ecodigo#
	</cfquery>

		<!---Actualiza el estado de las transacciones En proceso--->
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
			<cfinvokeargument name="CCHTid"    value="#rsAnticipo.CCHTid#"/>
			<cfinvokeargument name="CCHTestado" value="RECHAZADO"/>
			<cfinvokeargument name="CCHtipo"    value="COMISION"/>
		</cfinvoke>
		
		<!--- Crea las transacciones en seguimiento con el NUEVO ESTADO--->
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="SeguimientoT">
			<cfinvokeargument name="CCHTid"      value="#rsAnticipo.CCHTid#"/>
			<cfinvokeargument name="CCHTestado" value="RECHAZADO"/>
			<cfinvokeargument name="CCHtipo"    value="COMISION"/>
		</cfinvoke> 
        <!--- Reload --->
       <cfif isdefined("form.devolver") and form.devolver EQ true>
        	<cflocation url="/cfmx/proyecto7/AprobarTrans_formCom.cfm?GECid_comision=#form.GECid_comision#&tipo=COMISION&LvarComision=true">
        <cfelse>
     		<cfoutput>
				<script language="javascript">
					window.parent.document.form1.action = "gastosEmpleados.cfm";
					window.parent.document.form1.submit();
                </script>
			</cfoutput>
        </cfif>
</cfif>

<cfif isdefined ('form.botonSel') and form.botonSel EQ "imprimir">
	<cf_SP_imprimir location="AprobarTrans_formAnt.cfm">
</cfif>

<cfquery name="rsSQL" datasource="#session.DSN#">
	select count(1) as cantidad
	  from GEanticipo 
	 where GECid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
	   and GEAestado = 1
</cfquery>
<cfif rsSQL.cantidad EQ 0>
	<cflocation url="AprobarTrans_formAnt.cfm">
<cfelse>
	<cflocation url="AprobarTrans_formAnt.cfm?GECid_comision=#form.GECid_comision#">
</cfif>
