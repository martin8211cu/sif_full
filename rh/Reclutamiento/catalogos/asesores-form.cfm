
<!--- Consultas --->
<!-- Establecimiento del modo -->
<cfif isdefined("form.Usucodigo")>
	<cfset modo="CAMBIO">
<cfelse>
		<cfset modo="ALTA">
</cfif>
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select ta.Usucodigo,dp.Pid,de.DEid, DEnombre #LvarCNCT# ' ' #LvarCNCT# DEapellido1 #LvarCNCT# ' ' #LvarCNCT# DEapellido2 as Nombre
		from RHAsesor ta
			inner join Usuario u
			on u.Usucodigo=ta.Usucodigo
				inner join DatosPersonales dp
				on dp.datos_personales =u.datos_personales
			inner join UsuarioReferencia r
					inner join DatosEmpleado de
						on <cf_dbfunction name="to_char" args="de.DEid">=r.llave
						and r.STabla='DatosEmpleado'
				on r.Usucodigo=ta.Usucodigo			
		where ta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ta.Usucodigo=#form.Usucodigo#
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

<form name="form1" method="post" action="asesores-sql.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" nowrap="nowrap"><strong><cf_translate XmlFile="/rh/generales.xml" key="LB_USUARIO">Usuario</cf_translate>:</strong>&nbsp;</td>
      <td>
		
			<!--- Lista de Usuarios Autorizados --->
			<cfquery name="rsUsuariosAutorizados" datasource="#Session.DSN#">
				select distinct de.DEid from RHAsesor ta
					inner join UsuarioReferencia r
						inner join DatosEmpleado de
							on <cf_dbfunction name="to_char" args="de.DEid">=r.llave
							and r.STabla='DatosEmpleado'
						on r.Usucodigo=ta.Usucodigo			
				where ta.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">				
			</cfquery>

	
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
			<cfset arrValuesCambio = ArrayNew(1)>
			<cfif isdefined ('modo') and modo eq 'Cambio' and isdefined('rsform') and rsform.recordcount gt 0>
				<cfset ArrayAppend(arrValuesCambio, rsForm.Usucodigo)>
				<cfset ArrayAppend(arrValuesCambio, rsForm.Pid)>
				<cfset ArrayAppend(arrValuesCambio, rsForm.Nombre)>		
			</cfif>
			<cfset filtroExtra = "">
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

 
	  </td>
    </tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">


		<cfif modo neq "ALTA">
			<cf_botones modo="#modo#" exclude="Cambio"  sufijo="Det">
		<cfelse>
			<cf_botones modo="#modo#"  sufijo="Det">
		</cfif>
	</td></tr>
	<tr>
		<td colspan="2" align="center">&nbsp;</td>
	</tr>
	<cfset ts = "">	
	<input type="hidden" name="modo" value="Cambio" />

	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
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
	


</script> 




