<cfparam name="param" default="">
<cfif isdefined('form.btnNuevo') or isdefined('Nuevo')>
	<cfset param = 'btnNuevo=true'>
<cfelseif isdefined('ALTA')>
	<cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="AltaAcuerdoPago" returnvariable="TESAPid">
		<cfinvokeargument name="TESAPnumero" 		value="#form.TESAPnumero#">
		<cfinvokeargument name="TASAPfecha" 		value="#form.TASAPfecha#">
		<cfinvokeargument name="TESAPautorizador1" 	value="#form.TESAPautorizador1#">
        <cfinvokeargument name="TESAPautorizador2" 	value="#form.TESAPautorizador2#">
        <cfinvokeargument name="Ocodigo" 			value="#form.Ocodigo#">
	</cfinvoke>
    <cfset param = 'TESAPid=#TESAPid#'>
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="CambioAcuerdoPago" returnvariable="TESAPid">
		<cfinvokeargument name="TESAPid" 			value="#form.TESAPid#">
        <cfinvokeargument name="TESAPnumero" 		value="#form.TESAPnumero#">
		<cfinvokeargument name="TASAPfecha" 		value="#form.TASAPfecha#">
		<cfinvokeargument name="TESAPautorizador1" 	value="#form.TESAPautorizador1#">
        <cfinvokeargument name="TESAPautorizador2" 	value="#form.TESAPautorizador2#">
        <cfinvokeargument name="ts_rversion" 		value="#form.ts_rversion#">
        <cfinvokeargument name="Ocodigo" 			value="#form.Ocodigo#">
	</cfinvoke>
    <cfset param = 'TESAPid=#TESAPid#'>
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="BajaAcuerdoPago">
		<cfinvokeargument name="TESAPid" 			value="#form.TESAPid#">
         <cfinvokeargument name="ts_rversion" 		value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif isdefined('BAJAD')>
    <cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="BajaDAcuerdoPago">
		 <cfinvokeargument name="TESSPid" value="#form.TESSPidEliminar#">
	</cfinvoke>
     <cfset param = 'TESAPid=#TESAPid#'>
<cfelseif isdefined('BTNALTAD')>
	 <cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="AltaDAcuerdoPagoUNO">
		 <cfinvokeargument name="TESAPid" value="#form.TESAPid#">
         <cfinvokeargument name="TESSPid" value="#form.TESSPid#">
	</cfinvoke>
     <cfset param = 'TESAPid=#TESAPid#'>
<cfelseif isdefined('EnviarA')>
	 <cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="fnEnviarAprobacion">
		 <cfinvokeargument name="TESAPid" value="#form.TESAPid#">
	</cfinvoke>
<cfelseif isdefined('Rechazar')>
	 <cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="fnRechazado">
		 <cfinvokeargument name="TESAPid" value="#form.TESAPid#">
	</cfinvoke>
<cfelseif isdefined('Anular')>
	 <cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="fnAnulado">
		 <cfinvokeargument name="TESAPid" value="#form.TESAPid#">
	</cfinvoke>
<cfelseif isdefined('Aprobar')>
	 <cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="fnAprobado">
		 <cfinvokeargument name="TESAPid" value="#form.TESAPid#">
	</cfinvoke>
<cfelseif isdefined('Generar')>
		<html><head></head><body>
			<cfoutput>
			<form method="post" name="form1" action="AcuerdoPago-Reporte.cfm">
				<input type="hidden" name="TESAPnumero" value="#form.TESAPnumero#" />
				<input type="hidden" name="TESAPid" value="#form.TESAPid#" />
				<input type="hidden" name="Regresar" 	value="#IrA#" />
			</form>
			</cfoutput>
			<script language="javascript1.2" type="text/javascript">
				document.form1.submit();
			</script>
		</body></html>
</cfif>
<cfif not isdefined('Generar')>
	<cflocation addtoken="no" url="#IrA#?#param#">
</cfif>
