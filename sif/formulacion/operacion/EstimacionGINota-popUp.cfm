<cfif not isdefined('form.FPEEid') and isdefined('url.FPEEid')>
	<cfset form.FPEEid = url.FPEEid>
</cfif>
<cfif not isdefined('form.FPEPid') and isdefined('url.FPEPid')>
	<cfset form.FPEPid = url.FPEPid>
</cfif>
<cfif not isdefined('form.FPDElinea') and isdefined('url.FPDElinea')>
	<cfset form.FPDElinea = url.FPDElinea>
</cfif>
<cfif not isdefined('form.RolAdmin') and isdefined('url.RolAdmin')>
	<cfset form.RolAdmin = url.RolAdmin>
</cfif>

<cfquery name="rsEstado" datasource="#session.DSN#">
	select FPEEestado
	from FPEEstimacion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	 and FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPEEid#">
</cfquery>
<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="NotasDetalleEstimacion" returnvariable="Notas">
		<cfinvokeargument name="FPEEid" 			value="#form.FPEEid#">
		<cfinvokeargument name="FPEPid" 			value="#form.FPEPid#">
		<cfinvokeargument name="FPDElinea" 			value="#form.FPDElinea#">
	<cfif isdefined('form.DPDEObservaciones')>
		<cfinvokeargument name="DPDEObservaciones" 	value="#form.DPDEObservaciones#">		
	</cfif>
</cfinvoke>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Notas del Proceso de Estimación de Fuentes de Financiamiento y Egresos">
	<cfoutput>
		<form id="NotasPopUp" name="NotasPopUp" method="post" action="EstimacionGINota-popUp.cfm">
			<input type="hidden" name="FPEEid" 	  value="#Notas.FPEEid#" />
			<input type="hidden" name="FPEPid" 	  value="#Notas.FPEPid#" />
			<input type="hidden" name="FPDElinea" value="#Notas.FPDElinea#" />
			<input type="hidden" name="RolAdmin"  value="#form.RolAdmin#" />
			<textarea name="DPDEObservaciones" cols="50" rows="10" <cfif (not isdefined('form.RolAdmin') OR (isdefined('form.RolAdmin') and form.RolAdmin NEQ 'true')) or rsEstado.FPEEestado NEQ 1>readonly="true"</cfif>>#Notas.DPDEObservaciones#</textarea>
			<cfif isdefined('form.RolAdmin') and form.RolAdmin EQ 'true' and rsEstado.FPEEestado EQ 1>
				<p align="center">
					<input name="btnAgregar" value="Guardar y Cerrar" class="btnGuardar" type="submit"/>
				</p>
			</cfif>
		</form>
	</cfoutput>
<cf_web_portlet_end>
<cfif isdefined('form.btnAgregar')><script type="text/javascript">window.close();</script></cfif>