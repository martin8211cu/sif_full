<cfif isdefined("url.id_inst") and Len("url.id_inst") gt 0>
	<cfset form.id_inst = url.id_inst >
	<cfset form.Cambio = "Cambiar" >
</cfif>
<cfset modo = 'ALTA'>
<cfif isdefined("form.id_inst") and len(trim(form.id_inst))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined("Form.id_inst") AND Len(Trim(Form.id_inst)) GT 0 >
<!--- id_inst ,codigo_inst, nombre_inst,ts_rversion  --->
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select id_inst,
			   id_direccion,
			   codigo_inst,
			   nombre_inst,
			   liq_dias,
			   liq_banco,
			   liq_cuenta,
			   BMUsucodigo,
			   BMfechamod,
			   ts_rversion
		from TPInstitucion 
		where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
	</cfquery>
</cfif>
<SCRIPT LANGUAGE='Javascript'  SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</SCRIPT>


<cfset ts = ""> 
<cfif modo NEQ "ALTA">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
	</cfinvoke>
</cfif>

<cfoutput>
<form action="institucion-sql.cfm" method="post" enctype="multipart/form-data" name="formi">
	<table width="50%" align="center" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td width="50%" valign="top">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr > 
						<td colspan="2" class="subTitulo" align="left"><font size="2" color="black"><strong>Instituci&oacute;n</strong></font></td>
					</tr>		
					<tr > 
						<td width="25%" nowrap align="right">C&oacute;digo:</td>
						<td width="70%">
							<input type="text" name="codigo_inst" 
							value="<cfif modo NEQ "ALTA">#rsDatos.codigo_inst#</cfif>" 
							size="10" maxlength="10" onfocus="javascript:this.select();" >
						</td>
					</tr>
					<tr > 
						<td nowrap align="right">Descripci&oacute;n:</td>
						<td>
							<input type="text" name="nombre_inst" 
							value="<cfif modo NEQ "ALTA">#rsDatos.nombre_inst#</cfif>" 
							size="60" maxlength="100" onfocus="javascript:this.select();" >
						</td>
					</tr>
					<tr >
					  <td rowspan="2" align="right" valign="top" nowrap>Seleccionar&nbsp;
				      logotipo&nbsp;</td>
				  <td nowrap align="left"><input name="logo_inst" type="file" id="logo_inst" onChange="document.getElementById('logo_inst_preview').src = this.value"></td>
				  </tr>

					<tr >
					  <td nowrap align="left">
					  <img src="<cfif modo NEQ "ALTA">../public/logo_inst.cfm?id_inst=#rsDatos.id_inst#&amp;ts=#ts#</cfif>" height="80" id="logo_inst_preview">
					  </td>
				 	 </tr>
					  
				  
					<tr > 
						<td nowrap align="left">&nbsp;</td>
					<td nowrap align="left">&nbsp;</td>
					</tr>

					<cfquery name="tipos"  datasource="#session.tramites.dsn#">
						select ti.id_tipoinst as id, 
							   ti.codigo_tipoinst as codigo, 
							   ti.nombre_tipoinst as nombre
								<cfif modo neq 'ALTA'>
							   		, ( select tpr.id_tipoinst 
										from TPRTipoInst tpr 
										where tpr.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#"> 
										  and tpr.id_tipoinst=ti.id_tipoinst) as asociado
								<cfelse>
									,null as asociado
							   	</cfif>
						from TPTipoInst ti
						order by ti.nombre_tipoinst
					</cfquery>
			
					<cfif tipos.recordcount gt 0>
						<tr><td colspan="2" class="subTitulo"><font size="2" color="black"><strong>Tipo de Instituci&oacute;n (Marque todos los que apliquen)</strong></font></td></tr>
						<tr>
							<td colspan="2">
								<table width="100%" cellpadding="2" cellspacing="0">
									<cfloop query="tipos">
										<cfif tipos.currentrow mod 2 ><tr></cfif>
										<td width="1%"><input type="checkbox" name="tipos" value="#tipos.id#" id="tipos_#tipos.id#" <cfif len(trim(tipos.asociado))>checked</cfif> ></td>
										<td><label  for="tipos_#tipos.id#">#tipos.nombre#</label></td>
										<cfif not tipos.currentrow mod 2></tr></cfif>
									</cfloop>
									<cfif not tipos.recordcount mod 2></tr></cfif>
								</table>
							</td>
						</tr>
					</cfif>

					<tr > 
						<td  colspan="2" class="subTitulo" align="left"><font size="2" color="black"><strong>Direcci&oacute;n </strong></font></td>
					</tr>		
					<tr > 
						<td nowrap colspan="2"  align="left">
							<cfif modo NEQ "ALTA" and Len(trim(rsDatos.id_direccion)) >
								<cf_tr_direccion action="input" key="#rsDatos.id_direccion#" title="">
							<cfelse>
								<cf_tr_direccion action="input"  title="">
							</cfif>			
						</td>
					</tr>		
				</table>
			</td>
			
			<!--- ********************************************************************************************* --->
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<!---<cfinclude template="../../../sif/portlets/pBotones.cfm">--->
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo NEQ "ALTA">
					<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; ">
					<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacionIns) deshabilitarValidacionIns(); return true; }else{ return false;}">
					<input type="button" name="Nuevo" value="Nuevo" onClick="javascript: location.href='instituciones.cfm'">
				<cfelse>
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name; ">
				</cfif>
				<input type="button" name="Regresar" value="Listado de Instituciones" onClick="javascript: regresarins();">
			</td>
		</tr>		

	</table>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
	<input type="hidden" name="id_inst" value="<cfif modo NEQ "ALTA">#rsDatos.id_inst#</cfif>">
</form>
</cfoutput>
<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	ObjFormIns = new qForm("formi");

	ObjFormIns.codigo_inst.required = true;
	ObjFormIns.codigo_inst.description="Código";				
	ObjFormIns.nombre_inst.required = true;
	ObjFormIns.nombre_inst.description="Descripción";				
	ObjFormIns.nombre_inst.required = true;
	ObjFormIns.nombre_inst.description="Descripción";				
	
	function deshabilitarValidacionIns(){
		ObjFormIns.codigo_inst.required = false;
		ObjFormIns.nombre_inst.required = false;
	}
	
	function regresarins(){
		location.href="instituciones-lista.cfm";
	}
</script>