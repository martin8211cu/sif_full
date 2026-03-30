
<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select u.CEcodigo
			, ta.RHTid
			, ta.Usucodigo
			, BMfalta
			, dp.Pid
			, {fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )},dp.Papellido2 )} as Nombre
			, ta.ts_rversion
		from RHUsuarioTipoAccion ta
			inner join Usuario u
				on u.Usucodigo=ta.Usucodigo
					and u.Uestado = 1 
					and u.Utemporal = 0
					and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		
			inner join DatosPersonales dp
				on dp.datos_personales =u.datos_personales
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
			and ta.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
	</cfquery>
</cfif>

<!--- 

		select RHTid, Usucodigo,  ts_rversion
		from RHUsuarioTipoAccion
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
 --->

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>


<form name="form1" method="post" action="TipoAccionUsuario-SQL.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" nowrap="nowrap"><strong><cf_translate XmlFile="/rh/generales.xml" key="LB_USUARIO">Usuario</cf_translate>:</strong>&nbsp;</td>
      <td>
		<cfset arrValuesCambio = ArrayNew(1)>
		<cfif modo NEQ 'ALTA'>
			<cfif len(trim(rsForm.RHTid))>
				<cfset ArrayAppend(arrValuesCambio, rsForm.Usucodigo)>
				<cfset ArrayAppend(arrValuesCambio, rsForm.Pid)>
				<cfset ArrayAppend(arrValuesCambio, rsForm.Nombre)>							
			</cfif>
			&nbsp;&nbsp;&nbsp;<input type="text"  class="cajasinbordeb" name="Pid" size="10" maxlength="10" value="#rsForm.Pid#">
			<input type="text"  class="cajasinbordeb" name="Pid" size="30" maxlength="60" value="#rsForm.Nombre#">
			<input type="hidden" name="Usucodigo" value="#rsForm.Usucodigo#">
		<cfelse>
			<!--- Lista de Usuarios Autorizados --->
			<cfquery name="rsUsuariosAutorizados" datasource="#Session.DSN#">
				select distinct Usucodigo from RHUsuarioTipoAccion 
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHTid = <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric"> 
			</cfquery>
	
			<cfset filtroExtra = "">
			<cfif isdefined('rsUsuariosAutorizados') and rsUsuariosAutorizados.recordCount GT 0>
				<cfset filtroExtra = " and a.Usucodigo not in (#ValueList(rsUsuariosAutorizados.Usucodigo, ',')#)">		
			</cfif>
	
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_TITULOCONLIS"
			Default="Lista de Usuarios"
			returnvariable="LB_TITULOCONLIS"/>	

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_IDENTIFICACION"
			Default="Identificaci&oacute;n"
			returnvariable="LB_IDENTIFICACION"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_NOMBRE"
			Default="Nombre"
			returnvariable="LB_NOMBRE"/>			
	
			<cf_conlis 
				campos="Usucodigo,Pid,Nombre"
				size="0,10,60"
				conexion="asp"
				desplegables="N,S,S"
				modificables="N,N,N"
				valuesArray="#arrValuesCambio#"
				title="#LB_TITULOCONLIS#"
				tabla="Usuario a, DatosPersonales b"
				columnas="distinct a.Usucodigo, a.CEcodigo, b.Pid, {fn concat({fn concat({fn concat({fn concat(b.Pnombre , ' ' )}, b.Papellido1 )}, ' ' )}, b.Papellido2 )} as Nombre,(case when a.Uestado = 0 then 'Inactivo' when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' when a.Uestado = 1 and a.Utemporal = 0 then 'Activo' else '' end) as Estado"
				filtro=" a.datos_personales = b.datos_personales 
					  and a.CEcodigo = #session.CEcodigo#
					  and a.Uestado = 1 
					  and a.Utemporal = 0
						and exists ( select c.Usucodigo
											 from vUsuarioProcesos c
											 where c.Ecodigo = #session.EcodigoSDC#
											   and c.Usucodigo = a.Usucodigo
											   and c.SScodigo='RH'  ) 
					  #filtroExtra#"
				filtrar_por="Pid|{fn concat({fn concat({fn concat({fn concat(b.Papellido1 , ' ' )}, b.Papellido2 )},  ' ' )}, b.Pnombre)}"
				filtrar_por_delimiters="|"
				desplegar="Pid,Nombre"
				etiquetas="#LB_IDENTIFICACION#,#LB_NOMBRE#"
				formatos="S,S"
				align="left,left"
				asignar="Usucodigo,Pid,Nombre"
				asignarFormatos="S,S,S"
				form="form1"
				showEmptyListMsg="true"
				EmptyListMsg=" --- No se encotraron usuarios --- "/>			
		</cfif>	  

  
	  </td>
    </tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
		<cfif form.especial eq 'S'>
			<cfset regresa = 'TipoAccionSP.cfm?RHTid=' & form.RHTid>
		<cfelse>
			<cfset regresa = 'TipoAccion.cfm?RHTid=' & form.RHTid>
		</cfif>
	
		<cfif modo neq "ALTA">
			<cf_botones modo="#modo#" exclude="Cambio" regresar="#regresa#">
		<cfelse>
			<cf_botones modo="#modo#" regresar="#regresa#">
		</cfif>
	</td></tr>
	<tr>
		<td colspan="2" align="center">&nbsp;</td>
	</tr>
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
  </table>  
  </cfoutput>
  <input type="hidden" id="especial" name="especial" value="<cfif isdefined("form.especial") and len(trim(form.especial)) neq 0><cfoutput>#form.especial#</cfoutput></cfif>">
  <input type="hidden" id="RHTid" name="RHtid" value="<cfif isdefined("form.RHTid") and len(trim(form.RHTid)) neq 0><cfoutput>#form.RHTid#</cfoutput></cfif>">
  <input type="hidden" id="RHTdesc" name="RHTdesc" value="<cfif isdefined("form.RHTdesc") and len(trim(form.RHTdesc)) neq 0><cfoutput>#form.RHTdesc#</cfoutput></cfif>">
</form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR8"
	Default="Usuario"
	returnvariable="LB_MESAJEERROR8"/>
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.Pid.required = true;
	objForm.Pid.description="<cfoutput>#LB_MESAJEERROR8#</cfoutput>";	

	function deshabilitarValidacion(){
		objForm.Pid.required = false;
	}
	function habilitarValidacion(){
		objForm.Pid.required = true;
	}	
	function limpiar() {
		objForm.reset();
	}
	
	function funcRegresar(id){
	<cfif form.especial eq 'S'>
		document.location.href = 'TipoAccionSP.cfm?RHTid=' & id;
	<cfelse>
		document.location.href = 'TipoAccion.cfm?RHTid=' & id;
	</cfif>
}

</script> 
