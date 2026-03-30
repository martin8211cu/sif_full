<cfif isdefined ('form.Lista')>
	<cflocation url="Distrito.cfm">
</cfif>

<cfif isdefined ('form.Importar')>
	<cflocation url="DistritoImportador.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Distrito" method="Alta" returnvariable="MIGDiid">
			<cfinvokeargument name="MIGArid" 	value="#form.MIGArid#"/>
			<cfinvokeargument name="MIGDicodigo" 	value="#form.MIGDicodigo#"/>
			<cfinvokeargument name="MIGDidescripcion" 	value="#form.MIGDidescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
	<cfif isdefined ('form.Distrito')>
		<cfoutput>
				<script language="JavaScript1.2">
					window.close();
					window.parent.opener.document.f2.MIGDicodigo.value='#form.MIGDicodigo#';
					window.parent.opener.document.f2.MIGDidescripcion.value='#form.MIGDidescripcion#';
					window.parent.opener.document.f2.MIGDiid.value=#MIGDiid#;
				</script>
		</cfoutput>
			<cfabort>
	</cfif>
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Distrito" method="Cambio" >
			<cfinvokeargument name="MIGArid" 	value="#form.MIGArid#"/>
			<cfinvokeargument name="MIGDidescripcion" 	value="#form.MIGDidescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="MIGDiid" 		value="#form.MIGDiid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Distrito" method="Baja" >
			<cfinvokeargument name="MIGDiid" 		value="#form.MIGDiid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Distrito.cfm">
</cfif>
<cflocation url="Distrito.cfm">
