<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEvaluaciones"
	Default="Lista de Evaluaciones"
	returnvariable="LB_ListaDeEvaluaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_se_encontraron_registros"
	Default="No se encontraron registros"
	returnvariable="LB_No_se_encontraron_registros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>
	
<cfif isdefined("form.REid") and len(trim(form.REid)) and form.REid gt 0>
	<cfset Form.modo='CAMBIO'>
</cfif>
<!--- Consultas en cualquier modo --->
<cfquery name="rsTablas" datasource="#session.dsn#">
	select TEcodigo, TEnombre
	from TablaEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Consultas en modo Cambio --->
<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.dsn#"><!--- RHPcodigo,  --->
		select 	REid, 
				Ecodigo, 
				TEcodigo, 
				REdescripcion, 
				REdesde, 
				REhasta, 
				REdias, 
				REevaluacionbase, 
				REaplicajefe, 
				REaplicaempleado, 
				REavisara, 
				REestado, 
				ts_rversion
		from RHRegistroEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
</cfif>

<cfquery name="rsTablas" datasource="#session.dsn#">
	select TEcodigo, TEnombre
	from TablaEvaluacion	
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by TEnombre
</cfquery>	

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="javascript1.2" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form
	/*function mostrarTabla(b) {
		if (b) {
			document.form1.RHEEtipoeval[0].checked = false;
			document.form1.RHEEtipoeval[1].checked = true;
			document.form1.TEcodigo.disabled = false;
			if (window.requerirTEcodigo) requerirTEcodigo(true);} 
		else {
			document.form1.RHEEtipoeval[0].checked = true;
			document.form1.RHEEtipoeval[1].checked = false;
			document.form1.TEcodigo.disabled = true;
			if (window.requerirTEcodigo) requerirTEcodigo(false);}
	}
	*/
	function funcLimpiar(){
		document.form1.reset();
	}
	function funcBaja(){
		return confirm(
		<cfif isdefined("rsResultados") and rsResultados.Cont gt 0>
			'Precaución!, esta Relación ya contiene Resultados. ¿Desea Eliminarla?'
		<cfelse>
			'¿Desea Eliminar la Relación?'
		</cfif>
		);
	}
	function funcSiguiente(){
		document.form1.SEL.value = "2";
		document.form1.action = "registro_evaluacion.cfm";
		return true;
	}
	function funcAlta(){
		document.form1.params.value = "?SEL=2";
		return true;
	}
</script>
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<cfoutput>
<cfset vb_readonly='false'>
<cfif isdefined("form.Estado") and form.Estado EQ 1><cfset vb_readonly='true'></cfif>
<form action="registro_evaluacion_sql.cfm" method="post" name="form1" onSubmit="javascript: document.form1.TEcodigo.disabled = false;">
	<table width="95%" align="center"  border="0" cellspacing="2" cellpadding="0">
		<tr>
			<td rowspan="10">&nbsp;</td>
			<td colspan="3">&nbsp;</td>
			<td rowspan="7">&nbsp;</td>
		</tr>

		<tr>
			<td width="15%" valign="middle" nowrap><strong>Descripci&oacute;n:</strong>&nbsp;</td>
			<td colspan="2" valign="middle" width="50%">
				<cfif modo neq 'AlTA' and isdefined("rsForm.REdescripcion") and len(trim(rsForm.REdescripcion)) gt 0>
					<cfoutput>
						<input name="REdescripcion" type="text" value="#rsForm.REdescripcion#" size="50" maxlength="100" tabindex="1"
						<cfif isdefined("form.Estado") and form.Estado EQ 1>readonly=""</cfif>>
					</cfoutput>
				<cfelse>
					<input name="REdescripcion" type="text" value="" size="50" maxlength="100" tabindex="1">
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td colspan="1" nowrap><strong>Vigencia:</strong>&nbsp;</td>
			<td colspan="2">
				<cfif modo neq 'AlTA' and isdefined("rsForm.REdesde") and len(trim(rsForm.REdesde)) gt 0>					
					<cf_sifcalendario name="REdesde" value="#LSDateFormat(rsForm.REdesde,'dd/mm/yyyy')#" tabindex="1" readOnly="#vb_readonly#">
				<cfelse>
					<cf_sifcalendario name="REdesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td colspan="1" nowrap><strong>Permite Evaluar hasta:</strong>&nbsp;</td>
			<td colspan="2">
				<cfif modo neq 'AlTA' and isdefined("rsForm.REhasta") and len(trim(rsForm.REhasta)) gt 0 and LSDateFormat(rsForm.REhasta,'dd/mm/yyyy') neq '01/01/6100'>
					<cf_sifcalendario name="REhasta" value="#LSDateFormat(rsForm.REhasta,'dd/mm/yyyy')#" tabindex="1">
				<cfelse>
					<cf_sifcalendario name="REhasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
				</cfif>
			</td>
		</tr>

		<tr>
			<td colspan="1" nowrap><strong>Tabla de Evaluaci&oacute;n:</strong>&nbsp;</td>
			<td colspan="2">
				<select name="TEcodigo" <cfif isdefined("form.Estado") and form.Estado EQ 1>disabled</cfif> tabindex="1">
					<option value="">-seleccionar-</option>
					<cfloop query="rsTablas">
						<option value="#rsTablas.TEcodigo#" <cfif modo neq 'ALTA' and rsForm.TEcodigo eq rsTablas.TEcodigo>selected</cfif>>#rsTablas.TEnombre#</option>
					</cfloop>
				</select>
			</td>
		</tr>

		<tr>
			<td colspan="1" nowrap><strong>D&iacute;as a recordar:</strong>&nbsp;</td>
			<td colspan="2">
				<cfset valor = 0 >
				<cfif modo neq 'ALTA'>
					<cfset valor = rsForm.REdias >
				</cfif>
				<cf_monto name="REdias" size="3" decimales="0" value="#valor#" readOnly="#vb_readonly#" tabindex="1">
			</td>
		</tr>

		<tr>
			<td colspan="1" nowrap><strong>Basada en:</strong>&nbsp;</td>
			<td colspan="2">				
				<cfset va_Evaluaciones = ArrayNew(1)>
				<cfif modo neq 'ALTA' and len(trim(rsForm.REevaluacionbase))>
					<cfquery name="rsEvaluacion" datasource="#session.DSN#">
						select REdescripcion as REdescripcionBase, REid as REevaluacionbase
						from RHRegistroEvaluacion
						where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.REevaluacionbase#">
					</cfquery>
					<cfif rsEvaluacion.RecordCount NEQ 0>
						<cfset ArrayAppend(va_Evaluaciones, rsEvaluacion.REevaluacionbase)>						
						<cfset ArrayAppend(va_Evaluaciones, rsEvaluacion.REdescripcionBase)>
					</cfif>
				</cfif>
				<cf_conlis 
					campos="REevaluacionbase,REdescripcionBase"
					asignar="REevaluacionbase,REdescripcionBase"
					valuesarray="#va_Evaluaciones#"
					size="0,40"
					desplegables="N,S"
					modificables="N,N"						
					title="#LB_ListaDeEvaluaciones#"
					tabla="RHRegistroEvaluacion"
					columnas="REid as REevaluacionbase,REdescripcion as REdescripcionBase"
					filtro="Ecodigo = #session.Ecodigo# 
							and REestado = 1"
					filtrar_por="REdescripcionBase"
					desplegar="REdescripcionBase"
					etiquetas="#LB_Descripcion#"
					formatos="S"
					align="left"								
					asignarformatos="S,S"
					form="form1"
					showemptylistmsg="true"
					readonly="#vb_readonly#"
					emptylistmsg=" ---#LB_No_se_encontraron_registros# --- "
					tabindex="1"
				/>
				<cfif modo neq 'ALTA' >
					<input type="hidden" name="_REevaluacionbase" value="#rsForm.REevaluacionbase#" />
				</cfif>
			</td>
		</tr>
		<!-----	
		<tr>
			<td colspan="1" nowrap><strong>Avisar a:</strong>&nbsp;</td>
			<td colspan="2">
				<cfset vAdministrador = arraynew(1) >

				<cfif modo eq 'ALTA'>
					<cfquery name="rsAdmin" datasource="#session.DSN#">
						select a.Pvalor as REavisara, u.Usulogin, c.Pnombre, c.Papellido1, c.Papellido2
						from RHParametros a
						
						inner join Usuario u
						on u.Usucodigo = <cf_dbfunction name="to_number" args="a.Pvalor">
						
						inner join DatosPersonales c
						on c.datos_personales = u.datos_personales
						
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.Pcodigo=180
					</cfquery>
				<cfelse>
					<cfquery name="rsAdmin" datasource="#session.DSN#">
						select u.Usucodigo as REavisara, u.Usulogin, c.Pnombre, c.Papellido1, c.Papellido2
						from Usuario u
						
						inner join DatosPersonales c
						on c.datos_personales = u.datos_personales
						
						where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.REavisara#">						  
					</cfquery>
				</cfif>	
				
				<cfset vAdministrador[1] = rsAdmin.REavisara >
				<cfset vAdministrador[2] = rsAdmin.Pnombre & ' ' & rsAdmin.Papellido1 & ' ' & rsAdmin.Papellido2 >
				<cfset vAdministrador[3] = rsAdmin.Usulogin >

				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<cf_conlis
								campos="REavisara,usuario,Usulogin"
								desplegables="N,S,N"
								modificables="N,N,N"
								size="0,45,0"
								title="Lista de Usuarios"
								
								tabla="Usuario a, vUsuarioProcesos b, DatosPersonales c"
								columnas="distinct a.Usucodigo as REavisara,{fn concat({fn concat({fn concat({fn concat( c.Pnombre, ' ')}, c.Papellido1)} , '') }, c.Papellido2)} as usuario,a.Usulogin"
								filtro="	a.Usucodigo = b.Usucodigo
										and a.CEcodigo = #session.CEcodigo#
										and b.Ecodigo = #session.EcodigoSDC#
										and a.datos_personales = c.datos_personales
										and a.Utemporal = 0
										and a.Uestado = 1
										order by c.Pnombre, c.Papellido1, c.Papellido2"
			
								desplegar="usuario,Usulogin"
								filtrar_por="{fn concat({fn concat({fn concat({fn concat(c.Papellido1 , ' ' )}, c.Papellido2 )},  ' ' )}, c.Pnombre)}|a.Usulogin"
								filtrar_por_delimiters="|"
								etiquetas="Usuario,Login"
								formatos="S"
								align="left"
								asignar="REavisara,usuario"
								asignarformatos="S,S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron usuarios --"
								tabindex="1"
								valuesArray="#vAdministrador#" >
						</td>
						<td><img src="/cfmx/rh/imagenes/Borrar01_S.gif" onclick="javascript:document.form1.REavisara.value=''; document.form1.usuario.value='';" /></td>
					</tr>
				</table>	
			</td>
		</tr>	
		----->
			<tr>
			<td colspan="1" nowrap><strong></strong>&nbsp;</td>
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%">
							<input type="checkbox"  onclick="javascript:ValidarChecks();" tabindex="1"
									name="REaplicajefe" id="REaplicajefe" 
									<cfif isdefined("form.Estado") and form.Estado EQ 1>disabled</cfif> 
									<cfif modo neq 'ALTA' and rsForm.REaplicajefe eq 1>checked</cfif> />
						</td>
						<td><label for="REaplicajefe" tabindex="1">Aplicada solo por jefe</label></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="1" nowrap><strong></strong>&nbsp;</td>
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%">
							<input type="checkbox" onclick="javascript:ValidarChecks();" tabindex="1"
									name="REaplicaempleado" id="REaplicaempleado" 
									<cfif isdefined("form.Estado") and form.Estado EQ 1>disabled</cfif> 
									<cfif modo neq 'ALTA' and rsForm.REaplicaempleado eq 1>checked</cfif> /></td>
						<td><label for="REaplicaempleado" tabindex="1">Aplica a funcionario</label></td>
					</tr>
				</table>
			</td>
		</tr>

		<tr><td colspan="4">&nbsp;</td></tr>
		
		<tr>
			<td colspan="4" align="center">
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="params" value="">
				<input type="hidden" name="Estado" value="<cfif isdefined("form.Estado") and form.Estado EQ 1>#form.Estado#<cfelse>0</cfif>">
				<cfif modo neq 'AlTA' and isdefined("rsForm.REid") and len(trim(rsForm.REid)) gt 0>
					<cfoutput>
						<input type="hidden" name="REid" value="#rsForm.REid#">
						<input type="hidden" name="REestado" value="#rsForm.REestado#">
					</cfoutput>
				</cfif>
				
				<cfif modo neq 'ALTA' and isdefined("rsForm.ts_rversion")>
					<cfset ts = "">
					<cfinvoke 	component="sif.Componentes.DButils"
								method="toTimeStamp"
								returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
				</cfif>

				<cfif modo EQ "ALTA">
					<cf_botones values="Agregar,Limpiar" names="Alta,Limpiar" nbspbefore="4" nbspafter="4" tabindex="3">
				<cfelse>	
					<cfif isdefined("form.Estado") and form.Estado EQ 1>
						<cfset vs_botones='Modificar,Siguiente'>
						<cfset vs_names='Cambio,Siguiente'>
					<cfelse>
						<cfset vs_botones='Modificar,Eliminar,Siguiente'>
						<cfset vs_names='Cambio,Baja,Siguiente'>
					</cfif>
					<cf_botones values="#vs_botones#" names="#vs_names#" nbspbefore="4" nbspafter="4" tabindex="3">
				</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="ValidaCHK" value="">
</form>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	//inicializa el form
	funcLimpiar()
	qFormAPI.errorColor = "#FFFFCC";
	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
			if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
			this.error="El valor para "+this.description+" debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?).";
		}
	}
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	var objForm = new qForm("form1");
	objForm.REdescripcion.required = true;
	objForm.REdescripcion.description = "Descripción";
	objForm.REdescripcion.validateAlfaNumerico();
	objForm.REdesde.required = true;
	objForm.REdesde.description = "Fecha desde";
	objForm.REhasta.required = true;
	objForm.REhasta.description = "Fecha hasta";	
	
	objForm.ValidaCHK.required = true;
	objForm.ValidaCHK.description = "Aplica solo por jefe y/o Aplica a funcionario";


	function ValidarChecks(){
		if(!document.form1.REaplicajefe.checked && !document.form1.REaplicaempleado.checked ){
			objForm.ValidaCHK.required = true;
		}
		else{
			objForm.ValidaCHK.required = false;
		}
	}

	function habilitarValidacion(){		
		objForm.REdescripcion.required = true;
		objForm.REdesde.required = true;
		objForm.REhasta.required = true;
	}

	function deshabilitarValidacion(){
		objForm.REdescripcion.required = false;
		objForm.REhasta.required = false;		
		objForm.REfdesde.required = false;
	}
	<cfif modo NEQ "ALTA">
		ValidarChecks();
	</cfif>
	
</script>