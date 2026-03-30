<!---<cfdump var="#form#">
<cfabort>
  
	--->

<cfif IsDefined("form.rdTipoAdmin")>
	<cfif  form.rdTipoAdmin EQ 1>	<!--- Individual --->
		<cfif IsDefined("form.Asignar")>	
			<cfif isdefined('form.AGidp') and form.AGidp NEQ ''>
				<cfinvoke component="saci.comp.ISBsobres"
					method="Asigna_Agente" >
					<cfinvokeargument name="Snumero" value="#form.Snumero#">
					<cfinvokeargument name="AGid" value="#form.AGidp#">
				</cfinvoke>
			</cfif>
			<script language="javascript" type="text/javascript">
				alert('La asignación del Agente ha sido exitosa.');
				location.href="sobres.cfm";				
			</script>
		<cfelseif IsDefined("form.Anular")>
			<cfinvoke component="saci.comp.ISBsobres"
				method="cambioEstado" >
				<cfinvokeargument name="Snumero" value="#form.Snumero#">
				<cfinvokeargument name="Sestado" value="2">
			</cfinvoke> 			
			<script language="javascript" type="text/javascript">
				alert('La anulación del sobre ha sido exitosa.');
				location.href="sobres.cfm";				
			</script>
		</cfif>
	<cfelseif form.rdTipoAdmin EQ 2>	<!--- Masivo --->
		<cfif IsDefined("form.Asignar")>	
			<cfif isdefined('form.AGidp_mas') and form.AGidp_mas NEQ ''>
 				<cfinvoke component="saci.comp.ISBsobres"
					method="AsignaAgenteRango" >
					<cfinvokeargument name="rangoIni" value="#form.sobreIni#">
					<cfinvokeargument name="rangoFin" value="#form.sobreFin#">	
					<cfinvokeargument name="AGid" value="#form.AGidp_mas#">
				</cfinvoke>
			</cfif> 
			<script language="javascript" type="text/javascript">
				alert('La Asignación Masiva del Agente ha sido exitosa.');
				location.href="sobres.cfm";				
			</script>			
		<cfelseif IsDefined("form.Anular")>
			<cfinvoke component="saci.comp.ISBsobres"
				method="cambioEstadoRango" >
				<cfinvokeargument name="rangoIni" value="#form.sobreIni#">
				<cfinvokeargument name="rangoFin" value="#form.sobreFin#">	
				<cfinvokeargument name="Sestado" value="2">
			</cfinvoke> 	
			<script language="javascript" type="text/javascript">
				alert('La Anulación Masiva de Sobres ha sido exitosa.');
				location.href="sobres.cfm";
			</script>						
		</cfif>		
	</cfif>
</cfif>