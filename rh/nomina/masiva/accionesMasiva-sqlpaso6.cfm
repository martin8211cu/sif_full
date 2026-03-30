<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfif isdefined("Form.btnAplicar")>
	<cfif isdefined("Form.RHAid") and len(trim(Form.RHAid))>		
		<cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="aplicarAccionMasiva" returnvariable="LvarResult">
			<cfinvokeargument name="RHAid" value="#Form.RHAid#"/> 
		</cfinvoke>
	</cfif>
	<cfquery name="rsUp" datasource="#session.dsn#">
		update DAnualidad set DAaplicada=1 where RHAid=#Form.RHAid#
	</cfquery>
</cfif>
