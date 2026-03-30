<cfif isdefined('URl.btnModificar')>
	<cfinvoke component="sif.Componentes.PlistaControl" method="SetControl">
        <cfinvokeargument name="PLCid"  value="#URL.PLCid#">
        <cfinvokeargument name="MaxRow" value="#URL.MaxRow#">
	</cfinvoke>
</cfif>