<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Modificar_Num_Seguro_Social "
Default="Modificar N&uacute;m. Seguro Social"
returnvariable="LB_Modificar_Num_Seguro_Social"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Situacion_Actual "
Default="Situaci&oacute;n Actual"
returnvariable="LB_Situacion_Actual"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Situacion_Propuesta "
Default="Situaci&oacute;n Propuesta"
returnvariable="LB_Situacion_Propuesta"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Cerrar"
Default="Cerrar"
returnvariable="LB_Cerrar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Modificar"
Default="Modificar"
returnvariable="LB_Modificar"/>

<!---Empresa es de Mexico?--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
ecodigo="#session.Ecodigo#" pvalor="2025" default="0" returnvariable="vEsMexico"/>

<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfquery datasource="#Session.DSN#" name="rsEmpleado">
		select 	a.DEid,			
				b.NTIdescripcion,
				a.DEidentificacion, 
				a.DESeguroSocial,
				a.DEnombre, 	
				a.DEapellido1, 		
				a.DEapellido2,
				a.ts_rversion
		from DatosEmpleado a 
		  inner join NTipoIdentificacion b
		    on  a.NTIcodigo = b.NTIcodigo				
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		<cfif Session.cache_empresarial EQ 0>
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfif>
	</cfquery>
</cfif>

<cfoutput>
	<cf_templatecss>
	<title>#LB_Modificar_Num_Seguro_Social#</title>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Modificar_Num_Seguro_Social#">
	<form method="post" name="form1" action="SQLModSeguroSocial.cfm" onsubmit=" return validar()">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<fieldset><legend>#LB_Situacion_Actual#</legend>
						<table width="100%" border="0" cellpadding="1" cellspacing="1">
							<tr>
								<td><b><cf_translate  key="LB_Empleado">Empleado</cf_translate></b></td>
								<td>:</td>
								<td>#trim(rsEmpleado.DEnombre)#&nbsp;#trim(rsEmpleado.DEapellido1)#&nbsp;#trim(rsEmpleado.DEapellido2)#</td>
							</tr>
							<tr>
								<td><b>#trim(rsEmpleado.NTIdescripcion)#</b></td>
								<td>:</td>
								<td>#trim(rsEmpleado.DEidentificacion)#</td>
							</tr>
							<tr>
								<td nowrap="nowrap"><b><cf_translate  key="LB_Num_Seguro_Social">N&uacute;m. Seguro Social</cf_translate></b></td>
								<td>:</td>
								<td><cfif isdefined("rsEmpleado.DESeguroSocial") and len(trim(rsEmpleado.DESeguroSocial)) >#rsEmpleado.DESeguroSocial#<cfelse><cf_translate  key="LB_Sin Definir">*** Sin Definir ***</cf_translate></cfif></td>
							</tr>
							<tr>
								<td><b><cf_translate  key="LB_Periodo">Periodo</cf_translate></b></td>
								<td>:</td>
								<td>#Year(Now())#</td>
							</tr>							
							<tr>
								<td><b><cf_translate  key="LB_Mes">Mes</cf_translate></b></td>
								<td>:</td>
								<td>
									<cfswitch expression="#Month(Now())#">
											<cfcase value="1">
												<cf_translate key="LB_ENERO">Enero</cf_translate>
											</cfcase>
											<cfcase value="2">
												<cf_translate key="LB_Febrero">Febrero</cf_translate>
											</cfcase>
											<cfcase value="3">
												<cf_translate key="LB_Marzo">Marzo</cf_translate>
											</cfcase>
											<cfcase value="4">
												<cf_translate key="LB_Abril">Abril</cf_translate>
											</cfcase>
											<cfcase value="5">
												<cf_translate key="LB_Mayo">Mayo</cf_translate>
											</cfcase>
											<cfcase value="6">
												<cf_translate key="LB_Junio">Junio</cf_translate>
											</cfcase>
											<cfcase value="7">
												<cf_translate key="LB_Julio">Julio</cf_translate>
											</cfcase>
											<cfcase value="8">
												<cf_translate key="LB_Agosto">Agosto</cf_translate>
											</cfcase>
											<cfcase value="9">
												<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
											</cfcase>
											<cfcase value="10">
												<cf_translate key="LB_Octubre">Octubre</cf_translate>
											</cfcase>
											<cfcase value="11">
		
												<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
											</cfcase>
											<cfcase value="12">
												<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
											</cfcase>
									</cfswitch>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td>
					<fieldset><legend>#LB_Situacion_Propuesta#</legend>
						<table width="100%" border="0" cellpadding="1" cellspacing="1">
							<tr>
								<td><b><cf_translate  key="LB_Num_Seguro_Social">N&uacute;m. Seguro Social</cf_translate></b></td>
								<td>:</td>
								<td><input  name="DESeguroSocial" 
											type="text" 
											id="DESeguroSocial" 
											size="30" maxlength="60" 
											value="<cfif isdefined("url.DESeguroSocial")>#url.DESeguroSocial#</cfif>" /></td>
							</tr>
							<tr>
								<td><b><cf_translate  key="LB_Periodo_de_inicio_de_vigencia">Periodo de inicio de vigencia</cf_translate></b></td>
								<td>:</td>
								<td>
								<cfset ano_anterior = Year(Now()) - 1>
								<select name="ANO" id="ANO"  tabindex="1">
										<option value="#ano_anterior#">#ano_anterior#</option>
										<option value="#Year(Now())#" selected>#Year(Now())#</option>
									</select>								</td>
							</tr>
							<tr>
								<td><b><cf_translate  key="LB_Mes_de_inicio_de_vigencia">Mes de inicio de vigencia</cf_translate></b></td>
								<td>:</td>
								<td>
									<select name="MES" id="MES"  tabindex="1">
										<option value="1" <cfif 1 eq Month(Now())>selected</cfif>><cf_translate key="LB_Enero">Enero</cf_translate></option>
										<option value="2" <cfif 2 eq Month(Now())>selected</cfif>><cf_translate key="LB_Febrero">Febrero</cf_translate></option>
										<option value="3" <cfif 3 eq Month(Now())>selected</cfif>><cf_translate key="LB_Marzo">Marzo</cf_translate></option>
										<option value="4" <cfif 4 eq Month(Now())>selected</cfif>><cf_translate key="LB_Abril">Abril</cf_translate></option>
										<option value="5" <cfif 5 eq Month(Now())>selected</cfif>><cf_translate key="LB_Mayo">Mayo</cf_translate></option>
										<option value="6" <cfif 6 eq Month(Now())>selected</cfif>><cf_translate key="LB_Junio">Junio</cf_translate></option>
										<option value="7" <cfif 7 eq Month(Now())>selected</cfif>><cf_translate key="LB_Julio">Julio</cf_translate></option>
										<option value="8" <cfif 8 eq Month(Now())>selected</cfif>><cf_translate key="LB_Agosto">Agosto</cf_translate></option>
										<option value="9" <cfif 9 eq Month(Now())>selected</cfif>><cf_translate key="LB_Septiembre">Septiembre</cf_translate></option>
										<option value="10" <cfif 10 eq Month(Now())>selected</cfif>><cf_translate key="LB_Octubre">Octubre</cf_translate></option>
										<option value="11" <cfif 11 eq Month(Now())>selected</cfif>><cf_translate key="LB_Noviembre">Noviembre</cf_translate></option>
										<option value="12" <cfif 12 eq Month(Now())>selected</cfif>><cf_translate key="LB_Diciembre">Diciembre</cf_translate></option>
									</select>								</td>
							</tr>
							<tr> 
								<td   colspan="3" align="center">
									<input  type="submit" 
										name="Cambio" 
										class="btnGuardar" 
										value="#LB_Modificar#" 
										tabindex="1">	
									<input  type="button" 
										name="Cerrar" 
										class="btnNuevo"  
										<!---onClick="CerrarVentana();"--->
										value="#LB_Cerrar#" 
										tabindex="1">								</td>
							</tr>							
						</table>
					</fieldset>
				</td>
			</tr>
		</table>
		<input type="hidden" name="DEid" value="<cfoutput>#rsEmpleado.DEid#</cfoutput>">
		<input type="hidden" name="DESeguroSocialActual" value="<cfoutput>#rsEmpleado.DESeguroSocial#</cfoutput>">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsEmpleado.ts_rversion#" returnvariable="ts"></cfinvoke>
		<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
		
	</form>

	<cf_web_portlet_end>

	<cf_qforms>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Num_Seguro_Social"
	Default="Núm. Seguro Social"
	returnvariable="LB_Num_Seguro_Social"/>
	
	<script language="JavaScript">
	
		objForm.DEid.required = true;
		objForm.DEid.description = '#LB_Empleado#';
	
		<!---objForm.DESeguroSocial.required = true;
		objForm.DESeguroSocial.description = '#LB_Num_Seguro_Social#';--->
	
		function validar(){
			var err = '';
			<cfif vEsMexico EQ 1>
				if ( (document.form1.DESeguroSocial.value.length > 0) && (document.form1.DESeguroSocial.value.length != 11)){
					err= 'El Seguro social debe estar compuesto de 11 caracteres. \n'
				}
			</cfif>
			if( err == '' ){
				return true;
			}
			else{
				alert(err);
				return false;
			}
		}
		
		function modificarFecha(){
			document.form1.accion.value='UPDATE';
			document.form1.submit();
		}
		function ActualizaPadre(){
			window.opener.document.location.reload();
		}
		function CerrarVentana(){
			ActualizaPadre();
			window.close();
		}
		<cfif isdefined("url.aplicado")>
			CerrarVentana();
		</cfif>
	</script>	

</cfoutput>