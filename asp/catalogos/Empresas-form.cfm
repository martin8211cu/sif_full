<cfset modo = "ALTA">
<cfif isdefined("Form.Empresa")>
	<cfset modo = "CAMBIO">
</cfif>

<cfset action = "Empresas-confirma.cfm">
<cfif modo EQ "CAMBIO">
	<cfset action = "Empresas-sql.cfm">
</cfif>

<!--- Datos de la Cuenta Empresarial Utilizada --->
<cfquery name="rsCuenta" datasource="asp">
	select CEcodigo, 
		   id_direccion, 
		   Mcodigo, 
		   rtrim(LOCIdioma) as LOCIdioma, 
		   CEnombre, 
		   CEcuenta, 
		   CEtelefono1, 
		   CEtelefono2, 
		   CEfax, 
		   CEcontrato,
		   Ecorporativa
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
</cfquery>

<cfset escorporativa = false>

<cfquery name="rsMonedas" datasource="asp">
	select Mcodigo, 
		   Mnombre
	from Moneda	
	order by Mnombre
</cfquery>

<!--- Idiomas --->
<cfquery name="rsIdiomas" datasource="sifcontrol">
	select Iid, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>


<cfif modo EQ "ALTA">
	<!--- Corregir luego de que se decida que hacer con los caches de la cuenta empresarial --->
	<cfquery name="rsCaches" datasource="asp">
		select b.Cid, 
			   b.Ccache
		from CECaches a, Caches	b
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
		and a.Cid = b.Cid
		order by Ccache
	</cfquery>
</cfif>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="asp">
		select CEcodigo, 
			   Mcodigo, 
			   id_direccion, 
			   Cid, 
			   Enombre,
			   Etelefono1, 
			   Etelefono2, 
			   Efax, 
			   Ereferencia,
			   Eidentificacion,
			   Enumero,
			   Eactividad,
			   Eidresplegal,
			   Enumlicencia, 
               Iid,coalesce(ERepositorio,0) as ERepositorio
		from Empresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
		and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	</cfquery>
	<cfset escorporativa = rsCuenta.Ecorporativa EQ form.Empresa>
    
	<cfset contaElectronica = rsData.ERepositorio>
    
	<cfquery name="rsUsuarios1" datasource="asp">
		select count(1) as cant from UsuarioRol
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
	</cfquery>

	<cfquery name="rsUsuarios2" datasource="asp">
		select count(1) as cant from UsuarioProceso
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
	</cfquery>
	
	<cfquery datasource="asp" name="PBitacoraEmp">
		select PBinactivo
		from PBitacoraEmp
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
	</cfquery>
	
</cfif>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	<cfif modo EQ "CAMBIO">
	function funcGuardarContinuar() {
		if (objForm.validate()) {
			document.frmEmpresas.ACCION.value = "1";
			document.frmEmpresas.submit();
		}	
	}

	function funcGuardarNuevo() {
		if (objForm.validate()){
			document.frmEmpresas.ACCION.value = "2";
			document.frmEmpresas.submit();
		}
	}

	function funcEliminar() {
		<!--- Validar que la empresa puede ser eliminada --->
		<cfoutput>
		if (#rsUsuarios1.cant# > 0 || #rsUsuarios2.cant# > 0) {
			alert('Esta empresa no puede ser eliminada porque tiene roles o procesos asociados');
			return false;
		}
		</cfoutput>
		if (confirm('¿Está seguro de que desea eliminar esta empresa?')) {
			deshabilitarValidacion();
			document.frmEmpresas.ACCION.value = "3";
			document.frmEmpresas.submit();
		}
	}

	function funcCancelar() {
		location.href = '/cfmx/asp/index.cfm';
	}
	
	<cfelse>

	function CrearCache(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='/cfmx/asp/catalogos/Caches.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}

	function funcCancelar2() {
		location.href = '/cfmx/asp/index.cfm';
	}
	
	function habilitarCE(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='/cfmx/asp/catalogos/Caches.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
		else 
		{
			var cache = document.frmEmpresas.Cid.value;
			document.frmEmpresas.action = "/cfmx/asp/catalogos/Empresas.cfm?cache=" + cache;
			document.frmEmpresas.submit();
		}
	}
	
	</cfif>
	
</script>

<cfoutput>
<form name="frmEmpresas" action="#action#" enctype="multipart/form-data" method="post" >
<input name="modo" type="hidden" value="<cfoutput>#modo#</cfoutput>">
<input name="ACCION" type="hidden" value="0">
<cfif modo neq 'ALTA'>
	<input name="id_direccion" type="hidden" value="<cfoutput>#rsData.id_direccion#</cfoutput>">
	<input name="Empresa" type="hidden" value="<cfoutput>#Form.Empresa#</cfoutput>">
</cfif>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <cfif modo EQ "CAMBIO">
  <tr>
  	<td colspan="3" bgcolor="##A0BAD3">
		<cfinclude template="frame-botones.cfm">
	</td>
  </tr>
  <cfelse>
  <tr>
  	<td colspan="3" bgcolor="##A0BAD3">
		<cfinclude template="frame-cancelar.cfm">
	</td>
  </tr>
  </cfif>
  <tr>
  	<td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td class="textoAyuda" width="20%" valign="top">
		<cfif modo EQ "ALTA">
			Para crear una nueva <strong>empresa</strong> por favor complete el siguiente formulario.<br><br>
			Debe asegurarse de que el <strong>cache</strong> escogido sea el correcto ya que una vez guardados los datos de la empresa, el cache <strong>NO</strong> puede ser modificado.<br><br>
			Después de haber llenado el formulario, haga click en <font color="##0000FF">Siguiente >></font> para continuar.<br><br>
			Si desea trabajar con una empresa diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar Empresa</font> en el cuadro de <strong>Opciones</strong>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
		<cfelse>
			Usted puede cambiar cualquier dato de la empresa y hacer click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
			Si desea continuar agregando más empresas haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
			Si desea trabajar con una empresa diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar Empresa</font> en el cuadro de <strong>Opciones</strong>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
		</cfif>
	</td>
    <td style="padding-left: 5px; padding-right: 5px;" valign="top">
		<table border="0" width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td class="etiquetaCampo" align="right" nowrap>Nombre:&nbsp;</td>
				<td colspan="3" align="left" nowrap>
					<input type="text" name="Enombre" size="60" maxlength="100" value="<cfif modo neq 'ALTA'>#rsData.Enombre#<cfelseif modo EQ 'ALTA'and isdefined('form.Enombre') and len(trim(form.Enombre))>#form.Enombre#</cfif>" onFocus="this.style.backgroundColor='##FFFFFF';">
				</td>
			</tr>
		
			<tr>
				<td class="etiquetaCampo" align="right" nowrap>Telef&oacute;no 1:&nbsp;</td>
				<td align="left" nowrap><input type="text" name="Etelefono1" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.Etelefono1#<cfelseif modo EQ 'ALTA'and isdefined('form.Etelefono1') and len(trim(form.Etelefono1))>#form.Etelefono1#</cfif>"></td>
				<td class="etiquetaCampo" align="right" nowrap>Moneda:&nbsp;</td>
				<td align="left" nowrap>
					<select name="Mcodigo">
					  <cfloop query="rsMonedas">
						<option value="#rsMonedas.Mcodigo#"<cfif (modo EQ 'ALTA' and rsCuenta.Mcodigo EQ rsMonedas.Mcodigo) or (modo EQ 'CAMBIO' and rsData.Mcodigo EQ rsMonedas.Mcodigo)> selected</cfif>>#rsMonedas.Mnombre#</option>
					  </cfloop>
					</select>
				</td>
			</tr>		
			<tr>
				<td class="etiquetaCampo" align="right" nowrap>Telef&oacute;no 2:&nbsp;</td>
				<td align="left" nowrap><input type="text" name="Etelefono2" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.Etelefono2#<cfelseif modo EQ 'ALTA'and isdefined('form.Etelefono2') and len(trim(form.Etelefono2))>#form.Etelefono2#</cfif>"></td>
				<td class="etiquetaCampo" align="right" nowrap>Fax:&nbsp;</td>
				<td align="left" nowrap><input type="text" name="Efax" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.Efax#<cfelseif modo EQ 'ALTA'and isdefined('form.Efax') and len(trim(form.Efax))>#form.Efax#</cfif>"></td>
			</tr>
			<tr>
				<td class="etiquetaCampo" align="right" nowrap><cf_translate key="LB_ActEconomina">Act.Econ&oacute;mica</cf_translate>:&nbsp;</td>
				<td><input type="text" name="Eactividad" value="<cfif modo neq 'ALTA'>#rsData.Eactividad#<cfelseif modo EQ 'ALTA'and isdefined('form.Eactividad') and len(trim(form.Eactividad))>#form.Eactividad#</cfif>" size="15" maxlength="50"></td>
				<td class="etiquetaCampo" align="right" nowrap><cf_translate key="LB_Licencia">Licencia</cf_translate>:&nbsp;</td>
				<td><input type="text" name="Enumlicencia" value="<cfif modo neq 'ALTA'>#rsData.Enumlicencia#<cfelseif modo EQ 'ALTA'and isdefined('form.Enumlicencia') and len(trim(form.Enumlicencia))>#form.Enumlicencia#</cfif>" size="15" maxlength="20"></td>
			</tr>
			<tr>
			  <td class="etiquetaCampo" align="right" nowrap>Cache:&nbsp;</td>
			  <td align="left" nowrap>
				<cfif modo EQ "ALTA">
					<select name="Cid" id="Cid" onChange="javascript: habilitarCE(this);">
					  <cfloop query="rsCaches">
						<option value="#rsCaches.Cid#" <cfif isdefined('form.Cid') and form.Cid EQ rsCaches.Cid>selected</cfif>>#rsCaches.Ccache#</option>
					  </cfloop>
					  <cfif acceso_uri('/asp/catalogos/Caches.cfm')>
					    <option value="">-----------------------</option>
					    <option value="0">Crear Nuevo ...</option>
					  </cfif>
					</select>
				<cfelse>
					<cfquery name="rsCache" datasource="asp">
						select Ccache
						from Caches
						where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.Cid#" null="#Len(rsData.Cid) is 0#">
					</cfquery>
					#rsCache.Ccache#
				</cfif>
			  </td>
				
			  <td align="right" nowrap class="etiquetaCampo">Identificaci&oacute;n:&nbsp;</td>
			  <td><input type="text" name="Eidentificacion" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.Eidentificacion#<cfelseif modo EQ 'ALTA'and isdefined('form.Eidentificacion') and len(trim(form.Eidentificacion))>#form.Eidentificacion#</cfif>"></td>	
			</tr>
			<tr>	
                <td class="etiquetaCampo" align="right" nowrap>Idioma:&nbsp;</td>
                <td align="left" nowrap>
                  <select name="Iid">
                    <cfloop query="rsIdiomas">
                      <option value="#rsIdiomas.Iid#" <cfif modo neq 'ALTA' and rsData.Iid eq rsIdiomas.Iid> selected</cfif>>#rsIdiomas.LOCIdescripcion#</option>
                    </cfloop>
                  </select>
                </td>
			  <!---<td colspan=2></td>--->				
                <td align="right" nowrap class="etiquetaCampo">N&uacute;mero de Empresa:&nbsp</td>				
                <td><input type="text" name="Enumero" size="5" maxlength="5" value="<cfif modo neq 'ALTA'>#rsData.Enumero#<cfelseif modo EQ 'ALTA'and isdefined('form.Enumero') and len(trim(form.Enumero))>#form.Enumero#</cfif>"></td>				
			</tr>				

			<tr>
			  <td align="right" nowrap class="etiquetaCampo">&nbsp;</td>
			  <td align="left" nowrap colspan="3" valign="top">
			  <table cellpadding="0" cellspacing="0" border="0" align="left">
              	<tr>
			  		<td width="20" valign="middle"><input type="checkbox" value="1" name="auditar" id="auditar" onChange="if (!this.checked && !confirm('Al deshabilitar la auditoría, no será posible rastrear las modificaciones hechas por los usuarios a su propia información. ¿Desea proceder?')) this.checked=true;" <cfif Modo EQ "ALTA" Or Modo EQ "CAMBIO" AND PBitacoraEmp.PBinactivo neq 1>checked</cfif>>
                    </td>
			  		<td width="458" valign="middle"><label for="auditar"><strong>&nbsp;Habilitar auditor&iacute;a</strong></label>
                    </td>
                </tr>
			    <tr>
			      <td valign="middle"><input type="checkbox" name="escorporativa" value="1" id="escorporativa" <cfif escorporativa>checked</cfif>></td>
			      <td valign="middle"><label for="escorporativa"><strong>Esta empresa representa el corporativo para esta cuenta empresarial</strong></label> </td>
			    </tr>
                <!---SML. 31/10/2014 Inicio Cambio para saber si una empresa utiliza contabilidad Electronica--->
                <cfif modo NEQ "ALTA">
                    <cfquery name="rsTieneRep" datasource="asp">
                        SELECT count(1) as cantidad
                        FROM CacheRepo
                        WHERE Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.Cid#" null="#Len(rsData.Cid) is 0#">
                    </cfquery>
                <cfelseif modo EQ 'ALTA' and isdefined('url.cache') and len(trim(url.cache))> <!---La condicion es para cuando se hace el submit al cambiar el combobox de los caches--->
                	 <cfquery name="rsTieneRep" datasource="asp">
                        SELECT count(1) as cantidad
                        FROM CacheRepo
                        WHERE Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cache#">
                	</cfquery>
                <cfelseif modo EQ 'ALTA' and not isdefined('form')> <!---Si es la primera vez que se entra a la pagina--->
                	<cfquery name="rsTieneRep" datasource="asp">
                        SELECT COUNT(1) as cantidad
						FROM (SELECT TOP 1 b.Cid, b.Ccache
	  						  FROM CECaches a, Caches	b
                              WHERE a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
                                    AND a.Cid = b.Cid
                              ORDER BY Ccache) PrimerCache
                        INNER JOIN  CacheRepo c on PrimerCache.Cid = c.Cid 
                	</cfquery>
				</cfif>
                <tr>
			      <td valign="middle"><input type="checkbox" name="contaElectronica" id="contaElectronica" <cfif (isdefined('rsTieneRep') and rsTieneRep.cantidad EQ 0)>disabled</cfif> <cfif isdefined('contaElectronica') and #contaElectronica# EQ 1>checked</cfif>></td>
			      <td valign="middle"><label for="contaElectronica"><strong>Habilitar Contabilidad Electronica</strong></label> </td>
			    </tr>
                <!---SML. 31/10/2014 Fin Cambio para saber si una empresa utiliza contabilidad Electronica--->
			  </table> 
			  </td>
			</tr>
			<tr>
			  <td align="right" nowrap class="etiquetaCampo"><cfif modo EQ "CAMBIO">Logo:</cfif>&nbsp;</td>
			  <td align="left" nowrap colspan="3">
			  	<cfif modo EQ "CAMBIO">
			  		<input type="file" name="logo">
				</cfif>
			  </td>
			</tr>
			<tr>
				<td align="right" nowrap class="etiquetaCampo"><cf_translate key="LB_IdentificacionRepresentante">Identificaci&oacute;n Representante</cf_translate>:&nbsp;</td>
				<td><input type="text" name="Eidresplegal" value="<cfif modo neq 'ALTA'>#rsData.Eidresplegal#<cfelseif modo EQ 'ALTA'and isdefined('form.Eidresplegal') and len(trim(form.Eidresplegal))>#form.Eidresplegal#</cfif>" size="20" maxlength="20"></td>
			</tr>
			<tr>
				<td colspan="4">
					<cfif modo neq 'ALTA'>
						<cf_direccion form="frmEmpresas" action="input" key="#rsData.id_direccion#" >
					<cfelse>
						<cfquery name="rsCuentaPais" datasource="asp">
							select Ppais
							from CuentaEmpresarial a, Direcciones b
							where a.id_direccion=b.id_direccion
							and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
						</cfquery>
						<cfset data.atencion = '' >	
						<cfset data.direccion1 = '' >	
						<cfset data.direccion2 = '' >	
						<cfset data.ciudad = '' >	
						<cfset data.estado = '' >	
						<cfset data.codpostal = '' >
						<cfset data.pais = trim(rsCuentaPais.Ppais) >
						
						<cf_direccion action="input" form="frmEmpresas" data="#data#">
					</cfif>
				</td>
			</tr>
			
			<tr>
				<td colspan="4" align="center">
				<cfif modo EQ "ALTA">
					<input type="submit" name="Siguiente" value="Siguiente >>" onmouseover="javascript: this.className='botonDown2';" onmouseout="javascript: this.className='botonUp2';">
				</cfif>
				</td>
			</tr>
		
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
		</table>
	</td>
    <td width="1%" valign="top">
		<cfinclude template="frame-Progreso.cfm">
		<br>
		<cfinclude template="frame-Proceso.cfm">
	</td>
  </tr>
</table>
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function deshabilitarValidacion() {
		objForm.Enombre.required = false;
		<cfif modo EQ "ALTA">
			objForm.Cid.required = false;
		</cfif>
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("frmEmpresas");
	
	objForm.Enombre.required = true;
	objForm.Enombre.description = "Nombre";
	<cfif modo EQ "ALTA">
		objForm.Cid.required = true;
		objForm.Cid.description = "Cache";
	</cfif>
	objForm.codpostal.required = true;
	objForm.codpostal.description = "Código Postal";
</script>
