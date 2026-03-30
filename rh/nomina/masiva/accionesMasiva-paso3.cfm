<!----========================= TRADUCCION =============================---->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="C&oacute;digo"	
	returnvariable="MSG_Codigo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripci&oacute;n"	
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Año"
	Default="Año"	
	returnvariable="MSG_Año"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha_Rige"
	Default="Fecha Rige"	
	returnvariable="MSG_Fecha_Rige"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha_Vence"
	Default="Fecha Vence"	
	returnvariable="MSG_Fecha_Vence"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Periodo_Maximo"
	Default="Periodo Máximo"	
	returnvariable="MSG_Periodo_Maximo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Numero_de_Periodos"
	Default="Número de Periodos"	
	returnvariable="MSG_Numero_de_Periodos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Anterior_Guardar_y_Continuar"
	Default="Anterior, Guardar y Continuar"	
	returnvariable="BTN_Anterior_Guardar_y_Continuar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Siguiente"
	Default="Siguiente"	
	returnvariable="BTN_Siguiente"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Anterior"
	Default="Anterior"	
	returnvariable="BTN_Anterior"/>

<!--- Si se trabaja con Periodos --->
<cfif isdefined("rsDatosAccion") and rsDatosAccion.RHTAperiodos EQ 1>
	<cfquery name="rsDatosPeriodo" datasource="#Session.DSN#">
		select 	a.RHPAMid, 
				a.RHAid, 
				rtrim(a.RHPAcodigo) as RHPAcodigo, 
				rtrim(a.RHPAdescripcion) as RHPAdescripcion, 
			  	a.RHPAManio, 
				a.RHPAMfdesde, 
				a.RHPAMfhasta, 
				b.RHAAperiodom, 
				b.RHAAnumerop
		from RHPeriodosAccionesM a
			inner join RHAccionesMasiva b
				on a.RHAid = b.RHAid
				and a.Ecodigo = b.Ecodigo		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosAccion.RHAid#">
	</cfquery> 
	
	<!--- Sección de Java Script --->
	<script src="/cfmx/rh/js/utilesMonto.js"></script>
	
	<!--- Inicia el pintado de la pantalla de trabajar con periodo --->
	<cfoutput>
	<form name="form1" method="post" style="margin: 0;" action="accionesMasiva-sql.cfm">
		<cfinclude template="accionesMasiva-hiddens.cfm">
		<input type="hidden" name="RHPAMid" value="<cfif rsDatosPeriodo.recordCount>#rsDatosPeriodo.RHPAMid#</cfif>">
		<table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
			<tr>
				<td align="right" nowrap="nowrap" class="fileLabel"><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
				<td nowrap="nowrap">
					<input type="text" name="RHPAcodigo" size="5" maxlength="5" value="<cfif rsDatosPeriodo.recordCount GT 0>#rsDatosPeriodo.RHPAcodigo#</cfif>" />
				</td>
				<td align="right" nowrap="nowrap" class="fileLabel"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
				<td colspan="3" nowrap="nowrap">
					<input type="text" name="RHPAdescripcion" maxlength="80" value="<cfif rsDatosPeriodo.recordCount GT 0>#rsDatosPeriodo.RHPAdescripcion#</cfif>" style="width: 100%" />
				</td>
		    </tr>
			<tr>
				<td align="right" nowrap="nowrap" class="fileLabel"><cf_translate key="LB_Periodo">Per&iacute;odo</cf_translate></td>
				<td nowrap="nowrap">
					<input type="text" name="RHPAManio" size="5" maxlength="5" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif rsDatosPeriodo.recordCount GT 0>#rsDatosPeriodo.RHPAManio#</cfif>" />
			    </td>
				<td align="right" nowrap="nowrap" class="fileLabel"><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate></td>
				<td nowrap="nowrap">
					<cfset fdesde = "">
					<cfif rsDatosPeriodo.recordCount GT 0>
						<cfset fdesde = LSDateFormat(rsDatosPeriodo.RHPAMfdesde, 'dd/mm/yyyy')>
					</cfif>
					<cf_sifcalendario form="form1" name="RHPAMfdesde" value="#fdesde#">
			  	</td>
				<td align="right" nowrap="nowrap" class="fileLabel"><cf_translate key="LB_Fecha_Vence">Fecha Vence</cf_translate></td>
				<td nowrap="nowrap">
					<cfset fhasta = "">
					<cfif rsDatosPeriodo.recordCount GT 0>
						<cfset fhasta = LSDateFormat(rsDatosPeriodo.RHPAMfhasta, 'dd/mm/yyyy')>
					</cfif>
					<cf_sifcalendario form="form1" name="RHPAMfhasta" value="#fhasta#">
			  </td>
			</tr>
			<tr>
				<td colspan="2" align="right" nowrap="nowrap" class="fileLabel">
					<cf_translate key="LB_Incluir_empleados_no_reconocidos">INCLUIR EMPLEADOS NO RECONOCIDOS</cf_translate>
				</td>
				<td align="right" nowrap="nowrap" class="fileLabel"><cf_translate key="LB_Periodo_maximo_a_incluir">Periodo M&aacute;ximo a Incluir</cf_translate></td>
				<td nowrap="nowrap">
					<input type="text" name="RHAAperiodom" size="5" maxlength="5" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif rsDatosPeriodo.recordCount GT 0>#rsDatosPeriodo.RHAAperiodom#</cfif>" />
				</td>
				<td align="right" nowrap="nowrap" class="fileLabel"><cf_translate key="LB_No_Periodos_anteriores">No. Periodos Anteriores</cf_translate></td>
				<td nowrap="nowrap">
					<input type="text" name="RHAAnumerop" size="5" maxlength="5" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif rsDatosPeriodo.recordCount GT 0>#rsDatosPeriodo.RHAAnumerop#</cfif>" />
				</td>
			</tr>
			<tr>
				<td colspan="6">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="6">
					<cf_botones names="btnRegresar,btnGuardar,btnSiguiente" values="<< #BTN_Anterior_Guardar_y_Continuar# >>, #BTN_Siguiente# >>">
				</td>
			</tr>
			<tr>
				<td colspan="6">&nbsp;</td>
			</tr>
		</table>
	</form>
	</cfoutput>
	
	<cf_qforms>
	<script language="javascript" type="text/javascript">
		<cfoutput>
		objForm.RHPAcodigo.required = true;
		objForm.RHPAcodigo.description = "#MSG_Codigo#";
		objForm.RHPAdescripcion.required = true;
		objForm.RHPAdescripcion.description = "#MSG_Descripcion#";
		objForm.RHPAManio.required = true;
		objForm.RHPAManio.description = "#MSG_Año#";
		objForm.RHPAMfdesde.required = true;
		objForm.RHPAMfdesde.description = "#MSG_Fecha_Rige#";
		objForm.RHPAMfhasta.required = true;
		objForm.RHPAMfhasta.description = "#MSG_Fecha_Vence#";
		objForm.RHAAperiodom.required = true;
		objForm.RHAAperiodom.description = "#MSG_Periodo_Maximo#";
		objForm.RHAAnumerop.required = true;
		objForm.RHAAnumerop.description = "#MSG_Numero_de_Periodos#";
		</cfoutput>
		
		function funcbtnRegresar(){
			deshabilitarvalidacion();
			document.form1.paso.value = "2";
		}
		
		function funcbtnSiguiente(){
			deshabilitarvalidacion();
			document.form1.paso.value = "4";
		}	
		
		function deshabilitarvalidacion(){
			objForm.RHPAcodigo.required = false;
			objForm.RHPAdescripcion.required = false;
			objForm.RHPAManio.required = false;
			objForm.RHPAMfdesde.required = false;
			objForm.RHPAMfhasta.required = false;
			objForm.RHAAperiodom.required = false;
			objForm.RHAAnumerop.required = false;
		}
		function habilitarvalidacion(){
			objForm.RHPAcodigo.required = true;
			objForm.RHPAdescripcion.required = true;
			objForm.RHPAManio.required = true;
			objForm.RHPAMfdesde.required = true;
			objForm.RHPAMfhasta.required = true;
			objForm.RHAAperiodom.required = true;
			objForm.RHAAnumerop.required = true;
		}
		function funcbtnGuardar(){
			habilitarvalidacion();
		}
	</script>
<cfelse>
	<table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" style="color:#FF0000; font-size:14px; " class="fileLabel">-- <cf_translate key="LB_El_Tipo_de_Accion_Masiva_no_permite_Trabajar_con_Periodos">El Tipo de Acci&oacute;n Masiva no permite Trabajar con Per&iacute;odos </cf_translate>--</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<form name="form1" action="#CurrentPage#" method="post" style="margin: 0;">
					<cfinclude template="accionesMasiva-hiddens.cfm">
					<cf_botones names="btnRegresar,btnSiguiente" values="<< #BTN_Anterior#,#BTN_Siguiente# >>">
				</form>			
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>						
	</table>
	<script language="javascript" type="text/javascript">
		function funcbtnRegresar(){
			document.form1.paso.value = "2";
		}
		function funcbtnSiguiente(){
			document.form1.paso.value = "4";
		}	
	</script>
</cfif>
