<cfif isdefined("Url.TEid") and not isdefined("Form.TEid")>
	<cfset Form.TEid = Url.TEid>
</cfif>
<cfif isdefined("Url.EPid") and not isdefined("Form.EPid")>
	<cfset Form.EPid = Url.EPid>
</cfif>

<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
</cfif>

<cfif isdefined("Form.EPid") and Len(Trim(Form.TEid))>
	<cfset modoDet="CAMBIO">
<cfelse>
	<cfset modoDet="ALTA">
</cfif>  

<cfif isdefined("Form.btnNuevo")>
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
</cfif>

<!--- Consultas --->
<cfset ValoresUtilizados = "">
<cfif modo NEQ 'ALTA' and isdefined("Form.TEid") and Len(Trim(Form.TEid))>
	<cfquery datasource="#Session.DSN#" name="rsForm">
		select TEid, rtrim(TEcodigo) as TEcodigo, TEdescripcion, ts_rversion
		from TiposEmpleado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsFrecuencia">
		Select Ttipopago
		from ExcepcionesPersonales
		where TEid = <cfqueryparam value="#form.TEid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset ValoresUtilizados = ValueList(rsFrecuencia.Ttipopago, ',')>
</cfif>
<cfset FrecuenciaPago 		= "0,1,2,3,4">
<cfset FrecuenciaPagoDesc 	= "Semanal,Bisemanal,Quincenal,Mensual,Horas">

<cfquery name="rsImpuestoRenta" datasource="#Session.DSN#">
	select rtrim(IRcodigo) as IRcodigo, IRdescripcion
	from ImpuestoRenta
</cfquery>

<!--- Seccion del detalle --->
<cfif modoDet neq 'ALTA' and isdefined("Form.TEid") and Len(Trim(Form.TEid)) and isdefined("Form.EPid") and Len(Trim(Form.EPid))>
	<cfquery datasource="#Session.DSN#" name="rsFormDetalle">
		Select TEid, EPid, IRcodigo, Ttipopago, EPmonto, EPmontomultiplicador, EPmontodependiente, ts_rversion,
			   case Ttipopago when 0 then 'Semanal' when 1 then 'Bisemanal' when 2 then 'Quincenal' when 3 then 'Mensual' when 4 then 'Horas' else '' end as FrecuenciaDesc
		from ExcepcionesPersonales
		where TEid = <cfqueryparam value="#form.TEid#" cfsqltype="cf_sql_numeric">
		and EPid = <cfqueryparam value="#Form.EPid#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function irALista() {
		location.href = "TiposEmpleado.cfm";
	}

	function valida(f) {
		<cfif modo EQ "CAMBIO">
		f.obj.EPmonto.value = qf(f.obj.EPmonto.value);
		f.obj.EPmontomultiplicador.value = qf(f.obj.EPmontomultiplicador.value);
		f.obj.EPmontodependiente.value = qf(f.obj.EPmontodependiente.value);
		</cfif>
		return true;
	}

</script>

<cfoutput>
	<form name="form1" method="post" action="TiposEmpleado-SQL.cfm" onSubmit="javascript: return valida(this);">
	  <cfif modo NEQ 'ALTA'>
		  <input type="hidden" id="TEid" name="TEid" value="#Form.TEid#">
	  </cfif>
	  <cfif modoDet NEQ 'ALTA'>
		  <input type="hidden" id="EPid_del" name="EPid_del" value="#Form.EPid#">
	  </cfif>
	  <table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr> 
		  <td <cfif modo NEQ "ALTA">colspan="2" </cfif>class="subTitulo">
			  <cfif modo EQ "ALTA"><cf_translate  key="LB_Nuevo">Nuevo</cf_translate><cfelse><cf_translate  key="LB_Modificar">Modificar</cf_translate></cfif><cf_translate  key="LB_TipoDeEmpleado">Tipo de Empleado</cf_translate> 
		  </td>
		</tr>
		<tr> 
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CODIGO"
			Default="C&oacute;digo"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_CODIGO"/>
	
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DESCRIPCION"
			Default="Descripci&oacute;n"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_DESCRIPCION"/>
			
			<td <cfif modo NEQ "ALTA">colspan="2" </cfif>valign="top">
				<table width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr>
					  <td class="fileLabel" align="right" nowrap>#LB_CODIGO#:&nbsp;</td>
					  <td nowrap><input name="TEcodigo" type="text" id="TEcodigo" size="10" maxlength="5" onfocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'>#rsForm.TEcodigo#</cfif>"></td>
					  <td class="fileLabel" align="right" nowrap>#LB_DESCRIPCION#:&nbsp;</td>
					  <td nowrap><input name="TEdescripcion" type="text" id="TEdescripcion" size="80" maxlength="80" onfocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'>#rsForm.TEdescripcion#</cfif>"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> 
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Agregar"
		Default="Agregar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Agregar"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_ModificarTipo"
		Default="Modificar Tipo"
		returnvariable="BTN_ModificarTipo"/>		

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_BorrarTipo"
		Default="Borrar Tipo"
		returnvariable="BTN_BorrarTipo"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_NuevoTipo"
		Default="Nuevo Tipo"
		returnvariable="BTN_NuevoTipo"/>		
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Lista"
		Default="Lista de Tipos de Empleado"
		returnvariable="BTN_Lista"/>				
		
		  <td nowrap <cfif modo NEQ "ALTA">colspan="2" </cfif>align="center"> 
				<cfif modo EQ "ALTA">
					<input type="submit" name="btnAgregarE" value="<cfoutput>#BTN_Agregar#</cfoutput>"> 
				<cfelseif modo NEQ "ALTA">
					<input type="submit" name="btnCambiarE" value="<cfoutput>#BTN_ModificarTipo#</cfoutput>" onClick="javascript: habilitarValidacion(); ">
					<input type="submit" name="btnBorrarE" value="<cfoutput>#BTN_BorrarTipo#</cfoutput>" onClick="javascript: deshabilitarValidacion(); return confirm('¿Esta seguro(a) que desea borrar esta tipo de empleado?')" > 
					<input type="submit" name="btnNuevoE" value="<cfoutput>#BTN_NuevoTipo#</cfoutput>" onClick="javascript: deshabilitarValidacion();">
	
					<cfset ts2 = "">	
					<cfinvoke 
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts2">
						<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="timestampE" value="#ts2#">
				</cfif>
				<input type="button" name="btnLista" value="<cfoutput>#BTN_Lista#</cfoutput>" onClick="javascript: irALista();">
			</td>
		</tr>
		<cfif modo NEQ "ALTA">
		<tr>
			<td colspan="2"><hr></td>
		</tr>
		<tr>
			<td width="50%" valign="top">
			
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_FrecuenciaDePago"
				Default="Frecuencia de Pago"
				returnvariable="LB_FrecuenciaDePago"/>	
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ImpuestoDeRenta"
				Default="Impuesto de Renta"
				returnvariable="LB_ImpuestoDeRenta"/>	

			
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaResult">
					<cfinvokeargument name="tabla" value="ExcepcionesPersonales a, TiposEmpleado b, ImpuestoRenta c"/>
					<cfinvokeargument name="columnas" value="a.EPid, case a.Ttipopago when 0 then 'Semanal' when 1 then 'Bisemanal' when 2 then 'Quincenal' when 3 then 'Mensual' when 4 then 'Horas' else '' end as Frecuencia, c.IRdescripcion as Impuesto"/>
					<cfinvokeargument name="desplegar" value="Frecuencia, Impuesto"/>
					<cfinvokeargument name="etiquetas" value="#LB_FrecuenciaDePago#,#LB_ImpuestoDeRenta#"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value=" b.TEid = #Form.TEid#
															and a.TEid = b.TEid
															and a.IRcodigo = c.IRcodigo
															order by a.Ttipopago, c.IRdescripcion
															" />
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="TiposEmpleado.cfm"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="formName" value="form1"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			</td>
			<td width="50%" valign="top" style="padding-left: 10px">
				<table border="0" width="100%" cellpadding="2" cellspacing="0">
					<tr>
					  <td class="fileLabel" align="right" nowrap><cfoutput>#LB_FrecuenciaDePago#</cfoutput>:</td>
					  <td nowrap>
					    <cfif modoDet EQ 'ALTA'>
							<select name="Ttipopago">
							<cfloop from="1" to="#ListLen(FrecuenciaPago)#" index="i">
								<cfif ListFind(ValoresUtilizados, ListGetAt(FrecuenciaPago, i, ','), ',') EQ 0>
									<option value="#ListGetAt(FrecuenciaPago, i, ',')#">#ListGetAt(FrecuenciaPagoDesc, i, ',')#</option>
								</cfif>
							</cfloop>
							</select>
						<cfelse>
							#rsFormDetalle.FrecuenciaDesc#
							<input type="hidden" name="Ttipopago" value="#rsFormDetalle.Ttipopago#">
						</cfif>
					  </td>
					</tr>
					<tr>
						<td class="fileLabel" align="right" nowrap><cfoutput>#LB_ImpuestoDeRenta#</cfoutput>:</td>
						<td nowrap>
							<select name="IRcodigo">
							<cfloop query="rsImpuestoRenta">
								<option value="#IRcodigo#">#IRdescripcion#</option>
							</cfloop>
							</select>
						</td>
					</tr>
					<tr>
					  <td class="fileLabel" align="right" nowrap><cf_translate  key="LB_Monto">Monto</cf_translate>:</td>
					  <td nowrap>
						<input name="EPmonto" type="text" id="EPmonto" size="20" maxlength="18"  value="<cfif modoDet NEQ 'ALTA' and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0>#LSNumberFormat(rsFormDetalle.EPmonto, ',9.00')#<cfelse>0.00</cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
					  </td>
					</tr>
					<tr>
					  <td class="fileLabel" align="right" nowrap><cf_translate  key="LB_MontoMultiplicado">Monto Multiplicador</cf_translate>:</td>
					  <td nowrap>
						<input name="EPmontomultiplicador" type="text" id="EPmontomultiplicador" size="20" maxlength="18"  value="<cfif modoDet NEQ 'ALTA' and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0>#LSNumberFormat(rsFormDetalle.EPmontomultiplicador,',9.00')#<cfelse>0.00</cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
					  </td>
					</tr>
					<tr>
					  <td class="fileLabel" align="right" nowrap><cf_translate  key="LB_MontoDependientes">Monto Dependientes</cf_translate>:</td>
					  <td nowrap>
						<input name="EPmontodependiente" type="text" id="EPmontodependiente" size="20" maxlength="18"  value="<cfif modoDet NEQ 'ALTA' and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0>#LSNumberFormat(rsFormDetalle.EPmontodependiente,',9.00')#<cfelse>0.00</cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
					  </td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_AgregarExcepcion"
								Default="Agregar Excepción"
								returnvariable="BTN_AgregarExcepcion"/>							
							
							<cfif modoDet EQ "ALTA">
								<input type="submit" name="btnAgregarD" value="<cfoutput>#BTN_AgregarExcepcion#</cfoutput>" onClick="javascript: habilitarValidacion(); " > 
							<cfelseif modoDet NEQ "ALTA" and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0>
								<cfset ts = "">	
								<cfinvoke 
									component="sif.Componentes.DButils"
									method="toTimeStamp"
									returnvariable="ts">
									<cfinvokeargument name="arTimeStamp" value="#rsFormDetalle.ts_rversion#"/>
								</cfinvoke>
								<input type="hidden" name="timestampD" value="<cfif modo NEQ 'ALTA' and isdefined('rsFormDetalle') and rsFormDetalle.recordCount GT 0>#ts#</cfif>">
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_ModificarExcepcion"
								Default="Modificar Excepción"
								returnvariable="BTN_ModificarExcepcion"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_BorrarExcepcion"
								Default="Borrar Excepción"
								returnvariable="BTN_BorrarExcepcion"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_NuevaExcepcion"
								Default="Nueva Excepción"
								returnvariable="BTN_NuevaExcepcion"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_EstaSeguroQueDeseaBorrarEstaExcepcionPersonal"
								Default="¿Esta seguro(a) que desea borrar esta excepción personal?"
								returnvariable="MSG_EstaSeguroQueDeseaBorrarEstaExcepcionPersonal"/>
								
								
								<input type="submit" name="btnCambiarD" value="<cfoutput>#BTN_ModificarExcepcion#</cfoutput>" onClick="javascript: habilitarValidacion();" > 
								<input type="submit" name="btnBorrarD" value="<cfoutput>#BTN_BorrarExcepcion#</cfoutput>" onClick="javascript: deshabilitarValidacion(); return confirm('<cfoutput>#MSG_EstaSeguroQueDeseaBorrarEstaExcepcionPersonal#</cfoutput>')" > 
								<input type="submit" name="btnNuevoD" value="<cfoutput>#BTN_NuevaExcepcion#</cfoutput>" onClick="javascript: deshabilitarValidacion();" >	
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		</cfif>
	  </table>
	</form>
</cfoutput>

<script language="JavaScript">
	
	function deshabilitarValidacion() {
		objForm.TEcodigo.required = false;
		objForm.TEdescripcion.required = false;
		<cfif modo EQ "CAMBIO">
		objForm.Ttipopago.required = false;
		objForm.IRcodigo.required = false;
		objForm.EPmonto.required = false;
		objForm.EPmontomultiplicador.required = false;
		objForm.EPmontodependiente.required = false;
		</cfif>
	}
	
	function habilitarValidacion() {
		objForm.TEcodigo.required = true;
		objForm.TEdescripcion.required = true;
		<cfif modo EQ "CAMBIO">
		objForm.Ttipopago.required = true;
		objForm.IRcodigo.required = true;
		objForm.EPmonto.required = true;
		objForm.EPmontomultiplicador.required = true;
		objForm.EPmontodependiente.required = true;
		</cfif>
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	returnvariable="MSG_Codigo"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	returnvariable="MSG_Descripcion"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FrecuenciaDePago"
	Default="Frecuencia de Pago"
	returnvariable="MSG_FrecuenciaDePago"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ImpuestoDeRenta"
	Default="Impuesto de Renta"
	returnvariable="MSG_ImpuestoDeRenta"/>		

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Monto"
	Default="Monto"
	returnvariable="MSG_Monto"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_MontoMultiplicador"
	Default="Monto Multiplicador"
	returnvariable="MSG_MontoMultiplicador"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_MontoDependientes"
	Default="Monto Dependientes"
	returnvariable="MSG_MontoDependientes"/>	
		

	
	objForm.TEcodigo.required = true;
	objForm.TEcodigo.description = "<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.TEdescripcion.required = true;
	objForm.TEdescripcion.description = "<cfoutput>#MSG_Descripcion#</cfoutput>";
	<cfif modo NEQ "ALTA">
		objForm.TEcodigo.required = true;
		objForm.TEcodigo.description = "<cfoutput>#MSG_Codigo#</cfoutput>";
		objForm.TEdescripcion.required = true;
		objForm.TEdescripcion.description = "<cfoutput>#MSG_Descripcion#</cfoutput>";
		<cfif modoDet EQ "ALTA">
			objForm.Ttipopago.required = true;
			objForm.Ttipopago.description = "<cfoutput>#MSG_FrecuenciaDePago#</cfoutput>";
			objForm.IRcodigo.required = true;
			objForm.IRcodigo.description = "<cfoutput>#MSG_ImpuestoDeRenta#</cfoutput>";
			objForm.EPmonto.required = true;
			objForm.EPmonto.description = "<cfoutput>#MSG_Monto#</cfoutput>";
			objForm.EPmontomultiplicador.required = true;
			objForm.EPmontomultiplicador.description = "<cfoutput>#MSG_MontoMultiplicador#</cfoutput>";
			objForm.EPmontodependiente.required = true;
			objForm.EPmontodependiente.description = "<cfoutput>#MSG_MontoDependientes#</cfoutput>";
		<cfelseif modoDet NEQ "ALTA">
			objForm.IRcodigo.required = true;
			objForm.IRcodigo.description = "<cfoutput>#MSG_ImpuestoDeRenta#</cfoutput>";
			objForm.EPmonto.required = true;
			objForm.EPmonto.description = "<cfoutput>#MSG_Monto#</cfoutput>";
			objForm.EPmontomultiplicador.required = true;
			objForm.EPmontomultiplicador.description = "<cfoutput>#MSG_MontoMultiplicador#</cfoutput>";
			objForm.EPmontodependiente.required = true;
			objForm.EPmontodependiente.description = "<cfoutput>#MSG_MontoDependientes#</cfoutput>";
		</cfif>		
	</cfif>		
</script>
