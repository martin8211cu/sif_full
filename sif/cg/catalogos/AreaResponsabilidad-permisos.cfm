<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegación del form por tabs para que tenga un orden lógico.
 --->

<cfif isdefined("Form.Usucodigo") and Len(Trim(Form.Usucodigo)) GT 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Form.CGARid") and Len(Trim(Form.CGARid)) GT 0>
	<cfquery name="rsArea" datasource="#Session.DSN#">
		select CGARcodigo as codigo,
			   CGARdescripcion as nombre
		from CGAreaResponsabilidad
		where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
	</cfquery>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select p.Usucodigo,
			   p.CGARid, 
			   p.Usucodigo,
			   dp.Pid,
			   { fn concat( { fn concat( { fn concat( { fn concat( dp.Pnombre , ' ')}, dp.Papellido1)}, ' ')},  dp.Papellido2)} as nombre,
			   p.ts_rversion
		from CGPermisosAreaResp p
			inner join Usuario u
				on u.Usucodigo=p.Usucodigo
					and u.Uestado = 1 
					and u.Utemporal = 0
		
			inner join DatosPersonales dp
				on dp.datos_personales =u.datos_personales
		where p.CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
		  and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and p.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>
</cfif>

<SCRIPT SRC="../../../js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</SCRIPT>

<cfoutput>

	<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<td valign="top">
				<cfset navegacion = "&tab=3">
				<cfif isdefined("Form.CGARid") and Len(Trim(Form.CGARid)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CGARid=" & Form.CGARid>
				</cfif>	
				<cf_dbfunction returnvariable="LvarNombreLista" name="concat" args="dp.Pnombre, ' ', dp.Papellido1, ' ',  dp.Papellido2">
				<cfinvoke 
					component="sif.Componentes.pListas" 
					method="pLista"
					returnvariable="rsLista"
					columnas="p.Usucodigo
							, CGARid
							, Pid
							, #LvarNombreLista# as Nombre
							, 3 as tab"
					etiquetas="Identificaci&oacute;n,Usuario"
					tabla="CGPermisosAreaResp p
							inner join Usuario u
								on u.Usucodigo=p.Usucodigo
									and u.Uestado = 1 
									and u.Utemporal = 0
							inner join DatosPersonales dp
								on dp.datos_personales =u.datos_personales"
					filtro="Ecodigo=#Session.Ecodigo# and p.CGARid=#form.CGARid# order by Nombre"
					desplegar="Pid,Nombre"
					filtrar_por="Pid, #LvarNombreLista#"
					align="left,left"
					formatos="S,S"
					keys="CGARid,Usucodigo"
					navegacion="#navegacion#"
					formName="listapermisos"
					ira="AreaResponsabilidad.cfm"
					maxrows="3"
				/>			
			</td>
			<td valign="top">
				<form method="post" name="formp" action="AreaResponsabilidad-permisos-sql.cfm">
				
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr><td>&nbsp;</td></tr>					
					  <tr>
						<td colspan="2" align="center" class="tituloEncab"><strong>Area de Responsabilidad: #trim(rsArea.codigo)# - #rsArea.nombre# </strong></td>
					  </tr>	
				
					  <tr>
						<td colspan="2">&nbsp;</td>
					  </tr>		  
					  <tr>
						<td width="9%" align="right"><strong>Usuario:</strong>&nbsp;</td>
						<td width="39%" nowrap>
						
						<cfset arrValuesCambio = ArrayNew(1)>
						<cfif modo NEQ 'ALTA'>
							<cfif len(trim(rsForm.Usucodigo))>
								<cfset ArrayAppend(arrValuesCambio, rsForm.Usucodigo)>
								<cfset ArrayAppend(arrValuesCambio, rsForm.Pid)>
								<cfset ArrayAppend(arrValuesCambio, rsForm.Nombre)>							
							</cfif>
							&nbsp;&nbsp;&nbsp;
							<input type="text" class="cajasinbordeb" name="Pid" size="10" maxlength="10" value="#rsForm.Pid#" tabindex="-1">
							<input type="text" class="cajasinbordeb" size="60" maxlength="60" value="#rsForm.Nombre#" tabindex="-1">
							<input type="hidden" name="Usucodigo" value="#rsForm.Usucodigo#" tabindex="-1">
						<cfelse>
							<!--- Lista de Usuarios Autorizados --->
							<cfquery name="rsUsuariosAutorizados" datasource="#Session.DSN#">
								select Usucodigo 
								from CGPermisosAreaResp 
								where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
									and CGARid=<cfqueryparam value="#form.CGARid#" cfsqltype="cf_sql_numeric"> 
									and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric"> 
							</cfquery>
					
							<cfset filtroExtra = "">
							<cfif isdefined('rsUsuariosAutorizados') and rsUsuariosAutorizados.recordCount GT 0>
								<cfset filtroExtra = " and a.Usucodigo not in (#ValueList(rsUsuariosAutorizados.Usucodigo, ',')#)">		
							</cfif>
							<cf_dbfunction returnvariable="LvarNombre" name="concat" args="b.Pnombre, ' ', b.Papellido1, ' ',  b.Papellido2">
							<cf_conlis 
								campos="Usucodigo,Pid,Nombre"
								size="0,10,60"
								conexion="asp"
								desplegables="N,S,S"
								modificables="N,N,N"
								valuesArray="#arrValuesCambio#"
								title="Lista de Usuarios"
								tabla="Usuario a, DatosPersonales b, vUsuarioProcesos c"
								columnas="distinct a.Usucodigo, a.CEcodigo, b.Pid, #LvarNombre# as Nombre,(case when a.Uestado = 0 then 'Inactivo' when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' when a.Uestado = 1 and a.Utemporal = 0 then 'Activo' else '' end) as Estado"
								filtro=" a.datos_personales = b.datos_personales 
									  and a.Usucodigo = c.Usucodigo 
									  and c.Ecodigo = #session.EcodigoSDC#
									  and a.CEcodigo = #session.CEcodigo#
									  and a.Uestado = 1 
									  and a.Utemporal = 0
									  #filtroExtra#"
								filtrar_por="Pid, #LvarNombre# "
								desplegar="Pid,Nombre"
								etiquetas="Identificaci&oacute;n,Nombre"
								formatos="S,S"
								align="left,left"
								asignar="Usucodigo,Pid,Nombre"
								asignarFormatos="S,S,S"
								form="formp"
								showEmptyListMsg="true"
								tabindex="3"
								EmptyListMsg=" --- No se encotraron usuarios --- "/>			
						</cfif>	  
				
				
						</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>		     
					  <tr>
						<td colspan="2" align="center">
							<cfif modo NEQ "ALTA">
								<input type="hidden" name="botonSel" value="" tabindex="-1">
								<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1" style="visibility:hidden;">
								<input type="submit" name="Baja" class="btnEliminar" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcBaja) return funcBaja();if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}" tabindex="3">
								<input type="submit" name="Nuevo" class="btnNuevo" value="Nuevo" tabindex="3" onClick="javascript: deshabilitarValidacion()">
							<cfelse>
								<cf_botones modo='#modo#' tabindex="3">
							</cfif>
							
						</td>
					  </tr>
				
					  <tr>
						<td colspan="2" valign="baseline">
							<input type="hidden" name="CGARid" value="#form.CGARid#" tabindex="-1">
							<cfset ts = "">
							<cfif modo NEQ "ALTA">
								<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
								</cfinvoke>
							</cfif>
							<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" tabindex="-1">		
						</td>
					  </tr>
					</table>
				</form>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>


</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#F5FAA0";
	objForm = new qForm("formp");

	objForm.Pid.required = true;
	objForm.Pid.description="Usuario";	

	function deshabilitarValidacion(){
		objForm.Pid.required = false;
	}
	function habilitarValidacion(){
		objForm.Pid.required = true;
	}	
	function limpiar() {
		objForm.reset();
	}	
</SCRIPT>
