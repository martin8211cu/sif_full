<cfif IsDefined("form.Asignar")>	
	<cfif isdefined('form.AGidp_mas') and form.AGidp_mas NEQ ''>
		<cfinvoke component="saci.comp.ISBsobres"
			method="AsignaAgenteRango" >
			<cfinvokeargument name="rangoIni" value="#form.sobreIni#">
			<cfinvokeargument name="rangoFin" value="#form.sobreFin#">	
			<cfinvokeargument name="AGid" value="#form.AGidp_mas#">
		</cfinvoke>
	</cfif> 
<!--- 	<script language="javascript" type="text/javascript">
		alert('La Asignación Masiva del Agente ha sido exitosa.');
		location.href="sobres.cfm";				
	</script>			 --->
<cfelseif IsDefined("form.Anular")>
	<cfinvoke component="saci.comp.ISBsobres"
		method="cambioEstadoRango" >
		<cfinvokeargument name="rangoIni" value="#form.sobreIni#">
		<cfinvokeargument name="rangoFin" value="#form.sobreFin#">	
		<cfinvokeargument name="Sestado" value="2">
	</cfinvoke> 	
<!--- 	<script language="javascript" type="text/javascript">
		alert('La Anulación Masiva de Sobres ha sido exitosa.');
		location.href="sobres.cfm";
	</script>						 --->
</cfif>		

<cfinclude template="ISBsobres-redirect.cfm">