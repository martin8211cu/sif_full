<cfquery datasource="sifcontrol" name="cual" maxrows="1">
	select PCUid 
	from PortalCuestionarioU
	where BUid=17
</cfquery>


<cfinvoke component="sif.rh.Componentes.RH_Benziger" method="procesar_persona">
	<cfinvokeargument name="PCid" 	value="6">
	<cfinvokeargument name="PCUid" 	value="#cual.PCUid#">
	<cfinvokeargument name="BUid" 	value="17">	
</cfinvoke>