<!--- Definición del modo --->
<cfset modo="ALTA">
<cfif isdefined("Form.SNCEid") and len(trim("Form.SNCEid")) NEQ 0 and Form.SNCEid gt 0>
    <cfset modo="CAMBIO">
</cfif>

<!--- Consulta solo en modo cambio --->
<cfif modo neq "ALTA">
	<cfquery name="rsSNClasificacion" datasource="#Session.DSN#">
		select SNCEid, Ecodigo, SNCEcodigo, SNCEdescripcion, SNCEcorporativo, PCCEobligatorio, PCCEactivo, PCEcatid, SNCEalertar, SNCtiposocio, ts_rversion 
		from SNClasificacionE 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		<cfif isdefined('session.Ecodigo') and 
				isdefined('session.Ecodigocorp') and
				session.Ecodigo NEQ session.Ecodigocorp and
				rsConsultaCorp.RecordCount GT 0>
				and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfif>
		  and SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">
	</cfquery>	
</cfif>

<!--- formulario del mantenimiento --->
<form method="post" name="form1" action="SQLSNClasificaciones.cfm">
<cfoutput>
	<table width="100%" cellpadding="1" cellspacing="0" border="0">
  		<tr> 
			<td nowrap align="right">C&oacute;digo:&nbsp;</td>
			<td>
				<input type="text" name="SNCEcodigo" tabindex="1" 
					value="<cfif modo NEQ "ALTA">#trim(htmlEditFormat(rsSNClasificacion.SNCEcodigo))#</cfif>" 
					size="10" maxlength="10">
			</td>
		</tr>
		<tr> 
			<td nowrap align="right">Descripci&oacute;n:&nbsp;</td>
			<td>
				<input type="text" name="SNCEdescripcion" tabindex="1" 
				value="<cfif modo NEQ "ALTA">#trim(htmlEditFormat(rsSNClasificacion.SNCEdescripcion))#</cfif>" 
				size="50" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Cat&aacute;logo Contable:</td>
			<td>
				<cfif modo NEQ 'ALTA' and len(trim(rsSNClasificacion.PCEcatid))>
					<cfquery name="rsCatCuenta" datasource="#session.DSN#">
						select PCEcatid, CEcodigo, PCEcodigo, PCEdescripcion, PCElongitud, PCEempresa, PCEreferenciar, PCEactivo, PCEoficina, PCEreferenciarMayor
						from PCECatalogo
						where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
						  and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNClasificacion.PCEcatid#">
					</cfquery>
					<cf_sifcatalogos query="#rsCatCuenta#" tabindex="1" >
				<cfelse>
					<cf_sifcatalogos tabindex="1">
				</cfif>				
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Tipo:</td>
			<td>
				<select name="SNCtiposocio">
					<option value="A" <cfif modo neq 'ALTA' and rsSNClasificacion.SNCtiposocio eq 'A'>selected</cfif> >Ambos</option>
					<option value="C" <cfif modo neq 'ALTA' and rsSNClasificacion.SNCtiposocio eq 'C'>selected</cfif>>Cliente</option>
					<option value="P" <cfif modo neq 'ALTA' and rsSNClasificacion.SNCtiposocio eq 'P'>selected</cfif>>Proveedor</option>
				</select>
			</td>
		</tr>
		<tr > 
			<td nowrap></td>
			<td align="left">
				<input name="SNCEcorporativo" id="SNCEcorporativo" type="checkbox" tabindex="1"
					<cfif isdefined('session.Ecodigo') and 
					  isdefined('session.Ecodigocorp') and
					  session.Ecodigo NEQ session.Ecodigocorp and 
					  rsConsultaCorp.RecordCount GT 0>disabled<cfelseif modo NEQ "ALTA">disabled</cfif>
					<cfif modo NEQ "ALTA" and rsSNClasificacion.SNCEcorporativo EQ 1>checked</cfif>>
				<label for="SNCEcorporativo" style="font-style:normal; font-variant:normal; font-weight:normal">Corporativo</label>
			</td>
		</tr>
		<tr > 
			<td nowrap></td>
			<td align="left">
				<input name="PCCEobligatorio" id="PCCEobligatorio" type="checkbox" tabindex="1"
					<cfif modo NEQ "ALTA" and rsSNClasificacion.PCCEobligatorio EQ 1>checked</cfif>>
				<label for="PCCEobligatorio" style="font-style:normal; font-variant:normal; font-weight:normal">Obligatorio</label>
			</td>
		</tr>
		<tr > 
			<td nowrap></td>
			<td align="left">
				<input name="PCCEactivo" id="PCCEactivo" type="checkbox" tabindex="1"
					<cfif modo NEQ "ALTA" and rsSNClasificacion.PCCEactivo EQ 1>checked</cfif>>
				<label for="PCCEactivo" style="font-style:normal; font-variant:normal; font-weight:normal">Activo</label>
			</td>
		</tr>
		<tr > 
			<td nowrap></td>
			<td align="left">
				<input name="SNCEalertar" id="SNCEalertar" type="checkbox" tabindex="1"
					<cfif modo NEQ "ALTA" and rsSNClasificacion.SNCEalertar EQ 1>checked</cfif>>
				<label for="SNCEalertar" style="font-style:normal; font-variant:normal; font-weight:normal">Alertar si no lo tienen</label>
			</td>
		</tr>
	</table>
	<cfif modo neq "ALTA">
		<cfset masbotones = "ValoresC">
		<cfset masbotonesv = "Valores de Clasificación">
	<cfelse>
		<cfset masbotones = "">
		<cfset masbotonesv = "">
	</cfif>
	<cf_botones modo="#modo#" include="#masbotones#" includevalues="#masbotonesv#" tabindex="1">
	<cfif modo NEQ "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSNClasificacion.ts_rversion#" returnvariable="ts"/>
		<input tabindex="-1" type="hidden" name="SNCEid" value="<cfif modo NEQ "ALTA">#rsSNClasificacion.SNCEid#</cfif>">
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
	</cfif>
	<input type="hidden" name="Pagina" tabindex="-1" value="#form.Pagina#">	
	<input type="hidden" name="MaxRows" tabindex="-1" value="#form.MaxRows#">	
</cfoutput>
</form>

<!--- creación de objeto qforms, objeto javascript utilizado para las validaciones --->
<cf_qforms>

<!-- validaciones y otras funciones de javascript --->
<script language="javascript" type="text/javascript">
	objForm.SNCEcodigo.description="Código";
	objForm.SNCEdescripcion.description="Descripción";
	function habilitarValidacion(){
		objForm.SNCEcodigo.required = true;
		objForm.SNCEdescripcion.required = true;
	}
	function deshabilitarValidacion(){
		objForm.SNCEcodigo.required = false;
		objForm.SNCEdescripcion.required = false;
	}
	function funcValoresC() {
		var data = 'SNValoresClasificacion.cfm?SNCEid=' + document.form1.SNCEid.value +'&PCEcatid='+document.form1.PCEcatid.value;
		location.href='SNValoresClasificacion.cfm?SNCEid=' + document.form1.SNCEid.value +'&PCEcatid='+document.form1.PCEcatid.value;
		return false;
	}
	document.form1.SNCEcodigo.focus();
</script>