<cftransaction>	
	<cfinvoke component="saci.comp.ISBlogin"
		method="CambioRealName" >
		<cfinvokeargument name="LGnumero" value="#form.logg#">
		<cfinvokeargument name="LGrealName" value="#form.nuevoLGrealName#">
	</cfinvoke>
</cftransaction>