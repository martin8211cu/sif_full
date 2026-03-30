<!--- 
	Modificado por: Yu Hui 26 de Mayo 2005 
	Motivo: Cambio de Tag de Empleados
--->

<!--- Define el Modo --->
<cfset MODOCAMBIO = isdefined("Session.Compras.Solicitantes.CMSid") and len(trim(Session.Compras.Solicitantes.CMSid))>
<!--- Funciones --->
<!--- Verifica si existe integración con con Recursos Humanos --->
<cffunction name="hayIntegracionRH" output="false" returntype="boolean">
	<cfset result = false>
	<cfquery name="rsNomina" datasource="#session.DSN#">
		select Pvalor 
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 520
	</cfquery>
	<cfif rsNomina.RecordCount gt 0 and rsNomina.Pvalor eq 'S'>
		<cfset result = true>
	</cfif>
	<cfreturn result>
</cffunction>
<cfset _hayIntegracionRH = hayIntegracionRH()>
<!--- Consultas --->
<!--- Consultas del Modo Cambio --->
<cfif MODOCAMBIO>
	<cfquery name="rsSolicitante" datasource="#Session.DSN#">
		select CMSid, coalesce(DEid,0) as DEid, CMSestado, Usucodigo, CMScodigo, coalesce(CFid,-1) as CFid, ts_rversion
		from CMSolicitantes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Solicitantes.CMSid#">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsSolicitante.ts_rversion#" returnvariable="ts"/>

	<cfif not _hayIntegracionRH>
		<!--- recupera Usucodigo para este solicitantes de UsuarioReferencia --->
		<cfquery name="rsUsuario" datasource="asp">
			select Usucodigo 
			from UsuarioReferencia
			where llave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSolicitante.CMSid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
				and STabla='CMSolicitantes'
		</cfquery>
	</cfif>
</cfif>

<!--- Utilidades de Montos y Números 
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>--->
<!--- QFORMS --->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	//-->
</script>
<!--- Pintado del Form --->

<form name="form1" action="solicitantes-Paso1-sql.cfm" method="post" onSubmit="javascript:if (window._finalizarform) _finalizarform();" style="margin:0;">
<cfoutput>
<table width="99%%"  border="0" cellspacing="0" cellpadding="1">
  <tr>
    <td width="1%" nowrap><strong>C&oacute;digo&nbsp;:&nbsp;</strong></td>
    <td>
			<input name="CMScodigo" id="CMScodigo" <cfif MODOCAMBIO>readonly="true"</cfif> type="text" value="<cfif MODOCAMBIO>#HTMLEditFormat(trim(rsSolicitante.CMScodigo))#</cfif>" size="10" maxlength="10" onFocus="this.select();">
		  <cfif MODOCAMBIO><input type="hidden" name="CMScodigo_old" id="CMScodigo_old"  value="#HTMLEditFormat(rsSolicitante.CMScodigo)#"></cfif>
		</td>
  </tr>
  <tr>
    <td width="1%" nowrap><strong>Solicitante&nbsp;:&nbsp;</strong></td>
    <td>
		<!---			
			<cfif MODOCAMBIO >
				<input type="hidden" name="_Usucodigo" value="#rsUsuario.Usucodigo#">
			</cfif>
		--->			
			
			<cfif _hayIntegracionRH>
				<!---
				<cfif MODOCAMBIO>
					<cf_rhempleados conlis="false" idempleado="#rsSolicitante.DEid#" size="40">
				<cfelse>
					<cf_rhempleados size="40">
				</cfif>
				--->
				<cfif MODOCAMBIO>
					<cf_rhempleado size="40" Nombre="Nombre" DEidentificacion="Pid" validateUser="true" idempleado="#rsSolicitante.DEid#" readonly="true">
				<cfelse>
					<cf_rhempleado size="40" Nombre="Nombre" DEidentificacion="Pid" validateUser="true">
				</cfif>
			<cfelse>
				<cfif MODOCAMBIO>
					<cf_sifusuarioE conlis="false" idusuario="#rsUsuario.Usucodigo#" size="40">
				<cfelse>
					<cf_sifusuarioE size="40">
				</cfif>
			</cfif>
			
		</td>
  </tr>

	<cfif not _hayIntegracionRH>
		<tr>
		    <td width="1%" nowrap><strong>Centro Funcional&nbsp;:&nbsp;</strong></td>
			<td>
				<cfif MODOCAMBIO>
					<cfquery name="rsCFuncional" datasource="#session.DSN#">
						select CFid, CFcodigo, CFdescripcion
						from CFuncional
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitante.CFid#">
					</cfquery>
					<cf_rhcfuncional query="#rsCFuncional#">
				<cfelse>
					<cf_rhcfuncional>
				</cfif>
			</td>
		</tr>
	</cfif>

  <tr>
    <td width="1%" nowrap></td>
    <td><input style="border:0;" type="checkbox" name="CMSestado" id="CMSestado" <cfif MODOCAMBIO and rsSolicitante.CMSestado eq 1>checked</cfif>><label for="CMSestado"><strong>Activo</strong></label></td>
  </tr>
</table>
<br>
<cfif MODOCAMBIO>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="CMSid" value="#Session.Compras.Solicitantes.CMSid#">
	<cf_botones values="<< Anterior,Eliminar,Guardar,Guardar y Continuar >>" names="Anterior, Baja, Cambio, CambioEsp" tabindex="2">
<cfelse>
	<cf_botones values="<< Anterior,Agregar,Agregar y Continuar >>" names="Anterior, Alta, AltaEsp" tabindex="2">
</cfif>
</form>
</cfoutput>
<cf_qforms>
	<cf_qformsRequiredField name="Nombre" description="Nombre">
		<cf_qformsRequiredField name="CMScodigo" description="Código">
		   <cfif not _hayIntegracionRH>
			  <cf_qformsRequiredField name="CFcodigo" description="Centro Funcional">
		   </cfif>
</cf_qforms>