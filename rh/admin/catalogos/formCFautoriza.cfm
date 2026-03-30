<!--- Consultas --->
<!-- Establecimiento del modo -->
<cfif isdefined("url.usucodigo") and len(trim(url.usucodigo))>
	<cfset form.usucodigo = url.usucodigo>
</cfif>
<cfif isdefined("form.usucodigo")>
	<cfset modo="CAMBIO_A">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA_A">
	<cfelseif form.modo EQ "CAMBIO_A">
		<cfset modo="CAMBIO_A">
	<cfelse>
		<cfset modo="ALTA_A">
	</cfif>
</cfif>

<cfif modo neq 'ALTA_A'>
	<!--- Form --->
	<cfquery name="rsFormAut" datasource="#session.DSN#">
		select ta.CFid
			, ta.Usucodigo
			, dp.Pid
			, {fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )},dp.Papellido2 )} as Nombre
			, ta.ts_rversion
		from CFautoriza ta
			inner join Usuario u
				on u.Usucodigo=ta.Usucodigo
					and u.Uestado = 1 
					and u.Utemporal = 0
					and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		
			inner join DatosPersonales dp
				on dp.datos_personales =u.datos_personales
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CFid = (select CFid from CFuncional where CFcodigo ='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#)
			and ta.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
	</cfquery>
</cfif>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<form name="formAut" method="post" action="SQLCFuncional.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" nowrap="nowrap">&nbsp;<strong><cf_translate XmlFile="/rh/generales.xml" key="LB_USUARIO">Usuario</cf_translate>:</strong>&nbsp;</td>
      <td>
		<cfset arrValuesCambio = ArrayNew(1)>
		<cfif modo NEQ 'ALTA_A'>
			<cfif len(trim(rsFormAut.CFid))>
				<cfset ArrayAppend(arrValuesCambio, rsFormAut.Usucodigo)>
				<cfset ArrayAppend(arrValuesCambio, rsFormAut.Pid)>
				<cfset ArrayAppend(arrValuesCambio, rsFormAut.Nombre)>							
			</cfif>
			&nbsp;&nbsp;&nbsp;
			<input type="text"  class="cajasinbordeb" name="Pid" size="10" maxlength="10" value="#rsFormAut.Pid#">
			<input type="text"  class="cajasinbordeb" name="Pnombre" size="30" maxlength="60" value="#rsFormAut.Nombre#">
			<input type="hidden" name="Usucodigo" value="#rsFormAut.Usucodigo#">
		<cfelse>
			<!--- Lista de Usuarios Autorizados --->
			<cfquery name="rsUsuariosAutorizados" datasource="#Session.DSN#">
				select distinct Usucodigo from CFautoriza 
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CFid = (select CFid from CFuncional where CFcodigo ='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#)
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
				size="0,10,40"
				conexion="asp"
				desplegables="N,S,S"
				modificables="N,N,N"
				valuesArray="#arrValuesCambio#"
				title="#LB_TITULOCONLIS#"
				tabla="Usuario a, DatosPersonales b"
				columnas="distinct a.Usucodigo, a.Usulogin, a.CEcodigo, b.Pid, {fn concat({fn concat({fn concat({fn concat(b.Pnombre , ' ' )}, b.Papellido1 )}, ' ' )}, b.Papellido2 )} as Nombre,(case when a.Uestado = 0 then 'Inactivo' when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' when a.Uestado = 1 and a.Utemporal = 0 then 'Activo' else '' end) as Estado"
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
				filtrar_por="Pid|Usulogin|{fn concat({fn concat({fn concat({fn concat(b.Papellido1 , ' ' )}, b.Papellido2 )},  ' ' )}, b.Pnombre)}"
				filtrar_por_delimiters="|"
				desplegar="Pid,Usulogin,Nombre"
				etiquetas="#LB_IDENTIFICACION#,Login,#LB_NOMBRE#"
				formatos="S,S,S"
				align="left,left,left"
				asignar="Usucodigo,Pid,Nombre"
				asignarFormatos="S,S,S"
				form="formAut"
				showEmptyListMsg="true"
				EmptyListMsg=" --- No se encotraron usuarios --- "/>			
		</cfif>	  

  
	  </td>
    </tr>
    <tr>
		<td align="right">
			<input name="chkResponsable"  id="chkResponsable" type="checkbox" tabindex="1" 	value="1" 
				<cfif modo neq 'ALTA_A' and isdefined("rsFormAut") and rsFormAut.Usucodigo eq rsform.CFuResponsable >checked="checked"</cfif> >
		</td>
		<td>
			&nbsp;&nbsp;&nbsp;
			<label for="chkResponsable"><cf_translate key="CHK_ResponsableDelCentroFuncional">Responsable del Centro Funcional (JEFE)</cf_translate></label>
		</td>
    </tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
	<cfif isdefined ('form.CFcodigo') and len(trim(form.CFcodigo)) gt 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid from CFuncional where CFcodigo='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsCFid.recordcount gt 0>
			<input type="hidden" name="CFid" value="#rsCFid.CFid#" />
			<cfset LvarCFid=#rsCFid.CFid#>
		</cfif>
	</cfif>
	
		<cfif modo neq "ALTA_A">
			<cf_botones modo="CAMBIO" sufijo="Aut">
		<cfelse>
			<cf_botones modo="ALTA" sufijo="Aut">
		</cfif>
	</td></tr>
	<tr>
		<td colspan="2" align="center">&nbsp;</td>
	</tr>
	<cfset ts = "">	
	<input type="hidden" name="modo" value="CAMBIO_A" />
	<cfif modo neq "ALTA_A">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsFormAut.ts_rversion#"/>
		</cfinvoke>
	</cfif>

	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA_A'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
  </table>  
  </cfoutput>
 </form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR8"
	Default="Usuario"
	returnvariable="LB_MESAJEERROR8"/>
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formAut");
	
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
	
	function funcRegresarDet(id){
		document.location.href = 'CFuncional.cfm?CFcodigo1=' & id;

}

</script> 



























