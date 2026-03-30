<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_ElCodigoDePlazaYaExiste" Default="El Código de Plaza ya existe" returnvariable="MSG_ElCodigoDePlazaYaExiste" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSePuedeInactivarLaPlaza" Default="No se puede inactivar la plaza" returnvariable="MSG_NoSePuedeInactivarLaPlaza" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate" XmlFile="/sif/rh/generales.xml"/>
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/sif/rh/generales.xml"/>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElPuestoSeleccionadoNoExiste"
	Default="El Puesto seleccionado no existe"
	returnvariable="MSG_ElPuestoSeleccionadoNoExiste"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_CentroFuncionalParaContabilizacion"
	Default="Centro Funcional para Contabilización"
	returnvariable="MSG_CentroFuncionalParaContabilizacion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Puesto"
	Default="Puesto"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="MSG_Puesto"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<!-- Establecimiento del modo -->
<cfif isdefined("form.CambioPlazas")>
	<cfset modoPlazas="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modoPlazas")>
		<cfset modoPlazas="ALTA">
	<cfelseif form.modoPlazas EQ "CAMBIO">
		<cfset modoPlazas="CAMBIO">
	<cfelse>
		<cfset modoPlazas="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modoPlazas neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select RHPid, a.RHPPid, a.RHPcodigo as RHPcodigo, 
		coalesce(ltrim(rtrim(b.RHPcodigoext)),rtrim(ltrim(b.RHPcodigo))) as RHPcodigoext,
		RHPdescripcion, Dcodigo, Ocodigo, a.RHPpuesto, b.RHPdescpuesto, a.CFidconta, 
		a.RHPactiva, a.ts_rversion, a.IDInterfaz
		from RHPlazas a
			left outer join RHPuestos b
			on b.RHPcodigo = a.RHPpuesto
			and b.Ecodigo = a.Ecodigo
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">
	</cfquery>
	
	<cfset contabiliza = -1 >
	<cfif len(trim(rsForm.CFidconta))>
		<cfset contabiliza = rsForm.CFidconta >
	</cfif>
	<cfquery name="rsCF" datasource="#session.DSN#">
		select CFid as CFidconta, CFcodigo as CFcodigo2, CFdescripcion as CFdescripcion2
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#contabiliza#"	>
	</cfquery>
</cfif>
<cfif isdefined("form.CFpk") and len(trim(form.CFpk))>
	<cfquery name="rsResponsable" datasource="#session.DSN#">
		select RHPid, Ocodigo, Dcodigo
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
	</cfquery>
</cfif>

<!--- Verifica si requiere del Centro Funcional --->
<cfquery name="rsRequiereCF" datasource="#Session.DSN#">
	select Pvalor as RequiereCF
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 400
</cfquery>

<!--- Centro de Costos equivalente a Centro Funcional --->
<cfquery name="centrocosto" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 520
</cfquery>


<!--- Departamentos--->
<cfquery name="rsDepartamentos" datasource="#session.DSN#">
	select Dcodigo, Ddescripcion
	from Departamentos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Ddescripcion
</cfquery>

<!--- Oficinas --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Odescripcion
</cfquery>

<!--- VARIABLE PARA DEFINIR PERMISO PARA MODIFICAR LA ACCION 
	SE DEFINE ACTIVA PARA LAS ACCIONES NORMALES --->
<cfset Lvar_Modifica = 1>
<!--- 
	ROL DEFINIDO PARA HENKEL PARA PERMITIR MODIFICAR ACCIONES REGISTRADAS DESDE INTERFAZ
	VERIFICA SI EL USUARIO TIENE EL ROL
--->
<cfquery name="rsRolAccionesInterfaz" datasource="asp">
	select 1
	from UsuarioRol
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and SScodigo = 'RH'
	  and SRcodigo = 'ADMAINT'
	  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>
<!--- VERIFICA SI HAY UNA ACCION REGISTRADA --->

<cfif modoPlazas neq 'ALTA'>
	<!--- VERIFICA SI LA ACCION VIENE DE INTERFAZ Y ADEMÁS SI TIENE EL ROL PARA MODIFICAR
		SI CUMPLE AMBAS CONDICIONES ENTONCES LA VARIABLE SE ASIGNA UN 1 --->
	<cfif rsForm.IDInterfaz GT 0 and rsRolAccionesInterfaz.RecordCount GT 0>
		<cfset Lvar_Modifica = 1>
	<cfelseif rsForm.IDInterfaz GT 0 and rsRolAccionesInterfaz.RecordCount EQ 0>
		<cfset Lvar_Modifica = 0>
	</cfif> 
</cfif>

<form name="form2" id="form2" method="post" action="SQLPlazas.cfm" onSubmit="return validar(this);">
  
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr> 
      <td align="right"><cf_translate key="LB_Codigo" XmlFile="/sif/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</div></td>
      <td>
	  	<input name="RHPcodigo" type="text" value="<cfif modoPlazas neq 'ALTA'>#trim(rsForm.RHPcodigo)#</cfif>" tabindex="1" size="12" maxlength="10" onfocus="javascript:this.select();" alt="El C&oacute;digo de Plaza" >			
		<input type="hidden" name="RHPid" value="<cfif modoPlazas neq 'ALTA'>#rsForm.RHPid#</cfif>" >		
		<input type="hidden" name="CFpk" value="#Form.CFpk#" >
		<input type="hidden" name="Ocodigo" value="<cfif isdefined("rsResponsable") and len(trim(rsResponsable.Ocodigo))>#rsResponsable.Ocodigo#<cfelseif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>#form.Ocodigo#</cfif>" >
		<input type="hidden" name="Dcodigo" value="<cfif isdefined("rsResponsable") and len(trim(rsResponsable.Dcodigo))>#rsResponsable.Dcodigo#<cfelseif isdefined("form.Dcodigo") and len(trim(form.Dcodigo))>#form.Dcodigo#</cfif>" >	
	  </td>
    </tr>
    <tr> 
      <td align="right"><cf_translate key="LB_Descripcion" XmlFile="/sif/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
      <td><input name="RHPdescripcion" type="text" tabindex="1" value="<cfif modoPlazas neq 'ALTA'>#rsForm.RHPdescripcion#</cfif>" size="45" maxlength="80" onFocus="javascript:this.select();" alt="La Descripci&oacute;n" ></td>
    </tr>
    <tr>
      <td align="right"><cf_translate key="LB_Puesto" XmlFile="/sif/rh/generales.xml">Puesto</cf_translate>:&nbsp;</td>
      <td>
        <cfif modoPlazas eq 'ALTA'>
          <cf_rhpuesto name="RHPpuesto" tabindex="1" form="form2">
          <cfelse>
          <cf_rhpuesto name="RHPpuesto" tabindex="1" form="form2" query="#rsForm#">
        </cfif>
      </td>
    </tr>

	<TR>
		<td align="right"><cf_translate key="LB_Fecha" XmlFile="/sif/rh/generales.xml">Fecha</cf_translate>:&nbsp;</td>
		<td>
			<cfset vFecha = LSDateFormat(now(), 'dd/mm/yyyy')>
			<cfif modoPlazas eq 'CAMBIO'>
				<cfquery name="rsFecha" datasource="#session.DSN#">
					select RHLTPid, RHLTPfdesde as desde
					from RHLineaTiempoPlaza
					where RHPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">
					order by RHLTPfdesde asc
				</cfquery>
				<cfset vFecha = LSDateFormat(rsFecha.desde, 'dd/mm/yyyy')>
				<cfif rsFecha.recordcount gt 1 >
					#vFecha#
					<input type="hidden" name="LTFecha" value="#vFecha#" />
				<cfelse>
					<cf_sifcalendario name="LTFecha" form="form2" value="#vFecha#"  >
					<input type="hidden" name="RHLTPid" value="#rsFecha.RHLTPid#" />
				</cfif> 
				
			<cfelse>
				<cf_sifcalendario name="LTFecha" form="form2" value="#vFecha#" >
			</cfif>
		</td>
	</TR>


	<cfif not centrocosto.Pvalor eq 1 >
	<tr>
		<td>&nbsp;</td>
		<td nowrap><cf_translate key="LB_CentroFuncionalParaContabilizacion">Centro Funcional para contabilizaci&oacute;n</cf_translate>:&nbsp;</td>
	</tr>	  

	<tr>
		<td nowrap align="right"></td>
		<td>
	        <cfif modoPlazas neq 'ALTA'>
				<cf_rhcfuncional form="form2" size="30" id="CFidconta" name="CFcodigo2" desc="CFdescripcion2" 
								 excluir="#Form.CFpk#" query="#rsCF#" tabindex="1" >
			<cfelse>
				<cf_rhcfuncional form="form2" size="30" id="CFidconta" name="CFcodigo2" desc="CFdescripcion2" excluir="#Form.CFpk#" tabindex="1" >
			</cfif>
		</td>
	</tr>	  
	</cfif>
    <tr>
     <td colspan="2">
	 	<input name="chkResponsable"  id="chkResponsable" type="checkbox" tabindex="1" 	value="" 
			<cfif modoPlazas neq 'ALTA' and isdefined("rsResponsable") and rsResponsable.RHPid eq form.RHPid  >checked="checked"</cfif> >
			<label for="chkResponsable"><cf_translate key="CHK_ResponsableDelCentroFuncional">Responsable del Centro Funcional (JEFE)</cf_translate></label></td>
    </tr>
	<tr>
	  <td colspan="2">
	    <cfif modoPlazas EQ "CAMBIO">
			<cfquery name="rsPlazaUsada" datasource="#Session.DSN#">
				select 1
				from LineaTiempo
				where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta
			</cfquery>
			<input type="hidden" name="plazaUsada" value="#rsPlazaUsada.recordCount#">
		</cfif>
	  	<input name="RHPactiva" id="RHPactiva" type="checkbox" tabindex="1" value="1" 
			<cfif modoPlazas EQ "CAMBIO" and rsForm.RHPactiva EQ 1> checked<cfelseif modo EQ "ALTA"> checked</cfif>
			<cfif modoPlazas EQ "CAMBIO"> onClick="javascript: checkPlaza(this);"</cfif>>
			<cf_translate key="CHK_Activa">Activa</cf_translate>
	  </td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
		<!--- PORTLET DE BOTONES --->
		<script language="JavaScript" type="text/javascript" >
			// Funciones para Manejo de Botones
			botonActual = "";
		
			function setBtn(obj) {
				botonActual = obj.name;
			}
			function btnSelected(name, f) {
				if (f != null) {
					return (f["botonSel"].value == name)
				} else {
					return (botonActual == name)
				}
			}

		</script>
		<cfif not isdefined('modo')>
			<cfset modo = "ALTA">
		</cfif>
		<input type="hidden" name="botonSel" value="">
		<cfif modoPlazas EQ "ALTA">
			<input type="submit" name="AltaPlazas" value="#BTN_Agregar#" tabindex="1" 
				   onClick="javascript: this.form.botonSel.value = this.name">
			<input type="reset" name="LimpiarPlazas" value="#BTN_Limpiar#" tabindex="1" 
					onClick="javascript: this.form.botonSel.value = this.name">
		<cfelse>	
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Modificar"
						Default="Modificar"
						XmlFile="/sif/rh/generales.xml"
						returnvariable="BTN_Modificar"/>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Eliminar"
						Default="Eliminar"
						XmlFile="/sif/rh/generales.xml"
						returnvariable="BTN_Eliminar"/>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MGS_DeseaEliminarelRegistro"
						XmlFile="/sif/rh/generales.xml"
						Default="Desea eliminar el Registro?"
						returnvariable="MGS_DeseaEliminarElRegistro"/>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Nuevo"
						Default="Nuevo"
						XmlFile="/sif/rh/generales.xml"
						returnvariable="BTN_Nuevo"/>

			<cfif Lvar_Modifica>
			<input type="submit" name="CambioPlazas" value="#BTN_Modificar#" tabindex="1" 
					onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
			<input type="submit" name="BajaPlazas" value="#BTN_Eliminar#" tabindex="1" 
					onclick="javascript: this.form.botonSel.value = this.name; 
							 if (window.deshabilitarValidacion) deshabilitarValidacion(); return confirm('#MGS_DeseaEliminarElRegistro#');">
			</cfif>
			<input type="submit" name="NuevoPlazas" value="#BTN_Nuevo#" tabindex="1" 
					onClick="javascript: this.form.botonSel.value = this.name; 
							 if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
		</cfif>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Regresar"
		Default="Regresar"
		XmlFile="/sif/rh/generales.xml"
		returnvariable="BTN_Regresar"/>
		<input type="button" name="Regresar" value="#BTN_Regresar#" tabindex="1" onClick="javascript: regresa();">
	
	</td></tr>
	
	<cfif isdefined("rsForm.IDInterfaz") and  len(trim(rsForm.IDInterfaz)) GT 0>
		<tr><td colspan="2" align="center">*
			<cf_translate key="MSG_RegistroNoSePuedeModificar">
			Este registro no se puede modificar debido a <br>
			que se gener&oacute; en otra aplicaci&oacute;n
			</cf_translate>.
		</td></tr>
	</cfif>
	<tr><td colspan="2">&nbsp;</td></tr>
	<cfif not centrocosto.Pvalor eq 1 >
	<tr><td colspan="2">
		<table width="100%" class="ayuda">
			<tr><td><strong><cf_translate key="LB_CentroFuncionalParaContabilizacion">Centro Funcional para contabilizaci&oacute;n</cf_translate></strong></td></tr>
			<tr>
				<td>
					<cf_translate key="IndicaElCentroFuncionalDondeSeContabilizaraLaPlazaSiSeDejaEnBlancoElSistemaTomaElCentroFuncionalDeLaPlaza">
					Indica el centro funcional donde se contabilizar&aacute; la plaza. 
					Si se deja en blanco, el sistema toma el centro funcional de la plaza.
					</cf_translate>
				</td>
			</tr>
		</table>
	</td></tr>
	</cfif>
	
	<cfset ts = "">	
	<cfif modoPlazas neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<tr>
		<td colspan="2">
			<input type="hidden" name="quitarPlazaCF" value="">
			<input type="hidden" name="ts_rversion" value="<cfif modoPlazas NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
			<input type="hidden" name="RHPPid" value="<cfif modoPlazas NEQ 'ALTA'><cfoutput>#rsForm.RHPPid#</cfoutput></cfif>">			
		</td>
	</tr>

  </table>  
  </cfoutput>
</form>



<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js" ></script>
<script language="JavaScript1.2" type="text/javascript" >
	<!--//
	function validar(f){
		//f.obj.RHPcodigo.disabled = false;
		f.RHPcodigo.disabled = false;
		
		if (btnSelected('AltaPlazas',f) || btnSelected('CambioPlazas',f)){
			var error='';
	
			if (f.RHPcodigo.value == ''){
				error='El <cfoutput>#MSG_Codigo#</cfoutput> de la plaza es requerido.\n';
			}
			
			if (f.RHPdescripcion.value == ''){
				error= error +'La <cfoutput>#MSG_Descripcion#</cfoutput> de la plaza es requerida.\n';
			}
			
			if (f.RHPpuesto.value == ''){
				error= error + 'El <cfoutput>#MSG_Puesto#</cfoutput> es requerido.\n';
			}
			if (error == ''){
				return true;
			}
			else {
				alert(error);
				return false;
			}
		}
		return true;
	}

	<cfif modoPlazas EQ "CAMBIO">
		function checkPlaza(ctl) {
			if (!ctl.checked && parseInt(document.form2.plazaUsada.value) > 0) {
				alert('<cfoutput>#MSG_NoSePuedeInactivarLaPlaza#</cfoutput>');
				ctl.checked = true;
			}
		}
	</cfif>

	var f2 = document.form2;
	<cfif modoPlazas NEQ 'CAMBIO'>
		try
		{
			f2.RHPcodigo.focus();
		}
		catch(e)
		{}
	</cfif>
	//-->
</script>
