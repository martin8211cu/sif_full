<cfif isdefined("Form.RHUTMlinea") and Len(Trim(Form.RHUTMlinea)) GT 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Form.RHTMid") and Len(Trim(Form.RHTMid)) GT 0>
	<cfquery name="rsTipoMov" datasource="#Session.DSN#">
		Select RHTMcodigo
			, RHTMdescripcion
		from RHTipoMovimiento
		where RHTMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTMid#">
	</cfquery>
</cfif>


<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select RHUTMlinea
			, utm.Usucodigo
			, utm.BMfecha
			, Pid
			, (dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' '  #LvarCNCT#  dp.Papellido2) as Nombre
			, utm.ts_rversion
		from RHUsuariosTipoMovCF utm
			inner join Usuario u
				on u.Usucodigo=utm.Usucodigo
					and u.Uestado = 1 
					and u.Utemporal = 0
		
			inner join DatosPersonales dp
				on dp.datos_personales =u.datos_personales
		where RHUTMlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHUTMlinea#">
	</cfquery>
</cfif>

<SCRIPT SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</SCRIPT>

<cfoutput>
<form method="post" name="form1" action="RHUsuariosTipoMovCF-sql.cfm">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="2" align="center" class="tituloEncab"><strong>Tipo de Movimiento: 
			<cfif isdefined("rsTipoMov") and rsTipoMov.recordCount GT 0>
				 &nbsp;&nbsp; #rsTipoMov.RHTMcodigo# &nbsp;&nbsp; #rsTipoMov.RHTMdescripcion#
			</cfif>
		</strong></td>
	  </tr>	
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>		  
	  <tr>
		<td width="9%" align="right"><strong>Usuario:</strong>&nbsp;</td>
		<td width="39%" nowrap>
		
		<cfset arrValuesCambio = ArrayNew(1)>
		<cfif modo NEQ 'ALTA'>
			<cfif len(trim(rsForm.RHUTMlinea))>
				<cfset ArrayAppend(arrValuesCambio, rsForm.Usucodigo)>
				<cfset ArrayAppend(arrValuesCambio, rsForm.Pid)>
				<cfset ArrayAppend(arrValuesCambio, rsForm.Nombre)>							
			</cfif>
			&nbsp;&nbsp;&nbsp;<input type="text"  class="cajasinbordeb" name="Pid" size="10" maxlength="10" value="#rsForm.Pid#">
			<input type="text"  class="cajasinbordeb" name="Pid" size="60" maxlength="60" value="#rsForm.Nombre#">
			<input type="hidden" name="Usucodigo" value="#rsForm.Usucodigo#">
		<cfelse>
			<!--- Lista de Usuarios Autorizados --->
			<cfquery name="rsUsuariosAutorizados" datasource="#Session.DSN#">
				select Usucodigo 
				from RHUsuariosTipoMovCF 
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and RHTMid=<cfqueryparam value="#form.RHTMid#" cfsqltype="cf_sql_numeric"> 
			</cfquery>
	
			<cfset filtroExtra = "">
			<cfif isdefined('rsUsuariosAutorizados') and rsUsuariosAutorizados.recordCount GT 0>
				<cfset filtroExtra = " and a.Usucodigo not in (#ValueList(rsUsuariosAutorizados.Usucodigo, ',')#)">		
			</cfif>
	
	
			<cf_conlis 
				campos="Usucodigo,Pid,Nombre"
				size="0,10,60"
				conexion="asp"
				desplegables="N,S,S"
				modificables="N,N,N"
				valuesArray="#arrValuesCambio#"
				title="Lista de Usuarios"
				tabla="Usuario a, DatosPersonales b, vUsuarioProcesos c"
				columnas="distinct a.Usucodigo, a.CEcodigo, b.Pid, (b.Pnombre #LvarCNCT# ' ' #LvarCNCT#b.Papellido1 #LvarCNCT# ' '  #LvarCNCT#  b.Papellido2) as Nombre,(case when a.Uestado = 0 then 'Inactivo' when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' when a.Uestado = 1 and a.Utemporal = 0 then 'Activo' else '' end) as Estado"
				filtro=" a.datos_personales = b.datos_personales 
					  and a.Usucodigo = c.Usucodigo 
					  and c.Ecodigo = #session.EcodigoSDC#
					  and a.CEcodigo = #session.CEcodigo#
					  and a.Uestado = 1 
					  and a.Utemporal = 0
					  #filtroExtra#"
				filtrar_por="Pid,b.Pnombre #LvarCNCT# ' ' #LvarCNCT# b.Papellido1 #LvarCNCT# ' '  #LvarCNCT#  b.Papellido2"
				desplegar="Pid,Nombre"
				etiquetas="Identificaci&oacute;n,Nombre"
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
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>		     
	  <tr>
		<td colspan="2" align="center">
			<cfif modo NEQ "ALTA">
				<cf_botones modo='#modo#' exclude="Cambio">
			<cfelse>
				<cf_botones modo='#modo#'>
			</cfif>
			
		</td>
	  </tr>
	  <tr>
		<td colspan="2" valign="baseline">
			<input type="hidden" name="RHTMid" value="#form.RHTMid#">
			<input type="hidden" name="RHUTMlinea" value="<cfif modo NEQ "ALTA">#rsForm.RHUTMlinea#</cfif>">
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">		
		</td>
	  </tr>
	</table>
</form>

</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#F5FAA0";
	objForm = new qForm("form1");

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
