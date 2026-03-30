
<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select CRMEid, CRMTEid, CRMEnombre, CRMEapellido1, CRMEapellido2, CRMEdireccion, CRMEapartado, 
		       CRMEemail, CRMEtel1, CRMEtel2, CRMEtel3, TIcodigo, CRMEidentificacion, CRMEimagen, <cf_dbfunction name="to_sdateDMY"	args="CRMEfechaini"> as CRMEfechaini, <cf_dbfunction name="to_sdateDMY"	args="CRMEfechafin"> as CRMEfechafin, CRMEdonacion, ts_rversion
		from CRMEntidad
		where CRMEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMEid#">
	</cfquery>
</cfif>

<cfquery name="rsTiposIdentificacion" datasource="sdc">
	select TIcodigo, TInombre from TipoIdentificacion
</cfquery>	

<cfquery name="rsPermDon" datasource="#session.DSN#">
	Select CRMTEid,
		CRMTEdonacionentidad
	from CRMTipoEntidad
	where Ecodigo= #session.Ecodigo# 
		and CEcodigo= #session.CEcodigo# 
</cfquery>

<cfquery name="rsConfig" datasource="#session.DSN#">
	select CRMTEid, CRMTEapellido1, CRMTEapellido2, CRMTEdireccion, CRMTEapartado, CRMTEtel1, CRMTEtel2, CRMTEtel3, CRMTEemail, CRMTEidentificacion 
	from CRMTipoEntidad
	where CEcodigo =  #session.CEcodigo# 
	  and Ecodigo =  #session.Ecodigo# 
</cfquery>

<form name="form1" style="margin:0;" action="SQLEntidad.cfm" method="post" enctype="multipart/form-data" onSubmit="return valida(this);">
	<cfoutput>

	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr>
			<td colspan="3" class="tituloAlterno">
				<cfif modo neq 'ALTA'>
					Modificaci&oacute;n de Entidad
				<cfelse>
					Nueva Entidad				
				</cfif>			
			</td>
		</tr>		

		<tr>
			<td width="14%">&nbsp;</td>
			<td width="20%" nowrap>Tipo:&nbsp;</td>
			<td width="66%">
				<table cellpadding="0" cellspacing="0">
					<tr><td>
					<select name="CRMTEid" onChange="javascript:cambia_tipo(this);">
						<cfloop query="rsTiposEntidad">
							<option <cfif modo neq 'ALTA' and rsForm.CRMTEid eq rsTiposEntidad.CRMTEid >selected</cfif> value="#rsTiposEntidad.CRMTEid#">#rsTiposEntidad.CRMTEcodigo# - #rsTiposEntidad.CRMTEdesc#</option>
						</cfloop>
					</select> 
					</td></tr>
				</table>
			</td>
		</tr>

		<tr>
			<td >&nbsp;</td>
			<td nowrap>Nombre:&nbsp;</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<input name="CRMEnombre" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEnombre#</cfif>" size="15" maxlength="100">
						</td>	
						<td id="tr_apellido1"><input name="CRMEapellido1" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEapellido1#</cfif>" size="15" maxlength="60"></td>
						<td id="tr_apellido2"><input name="CRMEapellido2" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEapellido2#</cfif>" size="14" maxlength="60"></td>
					</tr>
				</table>				
			</td>
		</tr>
		
		<tr id="tr_identificacion">
			<td >&nbsp;</td>
			<td nowrap>Identificaci&oacute;n:&nbsp;</td>
			<td>
				<table width="60%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<select name="TIcodigo">
								<cfloop query="rsTiposIdentificacion">
									<option <cfif modo neq 'ALTA' and rsForm.TIcodigo eq rsTiposIdentificacion.TIcodigo >selected</cfif> value="#rsTiposIdentificacion.TIcodigo#">#rsTiposIdentificacion.TInombre#</option>
								</cfloop>
							</select> 
						</td>
						<td width="1%">&nbsp;</td>
						<td><input name="CRMEidentificacion" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEidentificacion#</cfif>" size="25" maxlength="60"></td>
					</tr>
				</table>
			</td>	
		</tr>

		<tr>
			<td >&nbsp;</td>
			<td nowrap>Fecha Inicio:&nbsp;</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr><td>
						<cfif modo neq 'ALTA' >
							<cf_sifcalendario name="CRMEfechaini" value="#rsForm.CRMEfechaini#">
						<cfelse>
							<cf_sifcalendario name="CRMEfechaini" >
						</cfif>
					</td></tr>
				</table>
			</td>
		</tr>

		<tr>
			<td >&nbsp;</td>
			<td nowrap>Fecha Final:&nbsp;</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr><td>
						<cfif modo neq 'ALTA' >
							<cf_sifcalendario name="CRMEfechafin" value="#rsForm.CRMEfechafin#">
						<cfelse>
							<cf_sifcalendario name="CRMEfechafin" >
						</cfif>
					</td></tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td colspan="2"></td>
		    <td><input type="checkbox" name="CRMEdonacion" <cfif modo neq 'ALTA' and rsForm.CRMEdonacion eq '1'>checked</cfif> value="chk1" >Acepta Donaciones</td>
		</tr>
			</td>
		</tr>
		
		<tr id="tr_direccion">
			<td >&nbsp;</td>
			<td nowrap>Direcci&oacute;n:&nbsp;</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr><td>
						<input name="CRMEdireccion" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEdireccion#</cfif>" size="60" maxlength="255">
					</td></tr>
				</table>
			</td>	
		</tr>

		<tr id="tr_apartado">
			<td >&nbsp;</td>
			<td nowrap>Apartado:&nbsp;</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr><td>
						<input name="CRMEapartado" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEapartado#</cfif>" size="60" maxlength="60">
					</td></tr>
				</table>
			</td>
		</tr>

		<tr id="tr_email">
			<td >&nbsp;</td>
			<td nowrap >E-mail:&nbsp;</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr><td>
						<input name="CRMEemail" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEemail#</cfif>" size="60" maxlength="120">
					</td></tr>
				</table>
			</td>
		</tr>

		<tr id="tr_tel1">
			<td >&nbsp;</td>
			<td nowrap>Teléfono 1:&nbsp;</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr><td>
						<input name="CRMEtel1" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEtel1#</cfif>" size="30" maxlength="30">
					</td></tr>
				</table>
			</td>
		</tr>

		<tr id="tr_tel2">
			<td >&nbsp;</td>
			<td nowrap>Teléfono 2:&nbsp;</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr><td>
						<input name="CRMEtel2" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEtel2#</cfif>" size="30" maxlength="30">
					</td></tr>
				</table>
			</td>
		</tr>

		<tr id="tr_tel3">
			<td >&nbsp;</td>
			<td nowrap >Teléfono 3:&nbsp;</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr><td>
						<input name="CRMEtel3" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CRMEtel3#</cfif>" size="30" maxlength="30">
					</td></tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td >&nbsp;</td>
			<td nowrap >Imagen:&nbsp;</td>
			<td>
				<table width="50%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<input name="CRMEimagen" type="file">
						</td>
						<cfif modo neq 'ALTA' and len(rsForm.CRMEimagen) gt 0 >
								<td width="1%">&nbsp;</td>
								<td align="center">
									<cf_sifleerimagen autosize="true" border="false" tabla="CRMEntidad" campo="CRMEimagen" condicion="CEcodigo = #Session.CEcodigo# and Ecodigo = #Session.Ecodigo# and CRMEid = #form.CRMEid# " conexion="crm" imgname="img" width="130" height="80">
								</td>
						</cfif>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><cfinclude template="/sif/portlets/pBotones.cfm"></td></tr>
		<tr><td colspan="3">
			<cfif modo neq 'ALTA'><input name="CRMEid" type="hidden" value="<cfif modo neq 'ALTA'>#rsForm.CRMEid#</cfif>" ></cfif>
			&nbsp;
		</td></tr>

	</table>

	</cfoutput>
</form>

<script src="../../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<cfif isdefined('rsPermDon')>
		arrPermDon = new Array();
	
		//Tipos de entidad con la bandera de si permite donaciones siempre
		var contPermDon = 0;
		<cfloop query="rsPermDon">	
			contPermDon++;	
			arrPermDon[arrPermDon.length] = <cfoutput>'#rsPermDon.CRMTEid#~#rsPermDon.CRMTEdonacionentidad#'</cfoutput>;
		</cfloop>	
	</cfif>
	
//-----------------------------------------------------------------------------------------------		
	function revisaBandera(){
		var variable = false;
		
		if(contPermDon > 0){
			var	arrTemp = null;
			for(var k=0;k < arrPermDon.length;k++){
				arrTemp= arrPermDon[k].split('~');
				
				if(arrTemp[0] == document.form1.CRMTEid.value){
					if(arrTemp[1] == 1){
						variable = true;
					}
				}
			}				
		}
		
		return variable;
	}

	function valida(f){
		if(document.form1.CRMEdonacion.checked == false){				
			if(revisaBandera()){
				alert('Error, el check de Acepta Donaciones debe estar seleccionado para este tipo de entidad');
				
				return false;				
			}
		}
		
		return true;
	}
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.CRMEnombre.required    = true;
	objForm.CRMEnombre.description = "Nombre";

	objForm.CRMEfechaini.required  = true;
	objForm.CRMEfechaini.description = "Fecha Inicial";

	objForm.CRMEfechafin.required  = true;
	objForm.CRMEfechafin.description = "Fecha Final";

	function deshabilitarValidacion(){
		objForm.CRMEnombre.required    = false;
		objForm.CRMEfechaini.required  = false;
		objForm.CRMEfechafin.required  = false;
		objForm.CRMEapellido1.required  = false;
		objForm.CRMEapellido2.required  = false;
	}

	function cambia_tipo(obj){
		for (var i=0; i<datos.length; i++ ){
			if ( datos[i][0] == obj.value ){
				document.getElementById('tr_apellido1').style.display = (datos[i][1] == '1' ? '' : 'none');
				document.getElementById('tr_apellido2').style.display = (datos[i][2] == '1' ? '' : 'none');
				
				//validacion
				objForm.CRMEapellido1.required  = (datos[i][1] == '1' ? true : false);
				objForm.CRMEapellido1.description = "Apellido 1";
				objForm.CRMEapellido2.required  = (datos[i][1] == '1' ? true : false);
				objForm.CRMEapellido2.description = "Apellido 2";
				
				if ( datos[i][1] == '0' && datos[i][2] == '0' ){
					document.form1.CRMEnombre.size = 59;
				}
				else{
				document.form1.CRMEnombre.size = 15;
				}

				document.getElementById('tr_direccion').style.display 		= (datos[i][3] == '1' ? '' : 'none');
				document.getElementById('tr_apartado').style.display 		= (datos[i][4] == '1' ? '' : 'none');
				document.getElementById('tr_tel1').style.display      		= (datos[i][5] == '1' ? '' : 'none');
				document.getElementById('tr_tel2').style.display      		= (datos[i][6] == '1' ? '' : 'none');
				document.getElementById('tr_tel3').style.display      		= (datos[i][7] == '1' ? '' : 'none');
				document.getElementById('tr_email').style.display     		= (datos[i][8] == '1' ? '' : 'none');
				document.getElementById('tr_identificacion').style.display 	= (datos[i][9] == '1' ? '' : 'none');
				
			}
		}

		return true;
	}
	// ---------------------------------------------------------
	// arreglo en javascript de datos configurables
	var datos = new Array();
	var i = 0;
	<cfoutput query="rsConfig">
		datos[i]    = new Array();
		datos[i][0] = '#rsConfig.CRMTEid#';
		datos[i][1] = '#rsConfig.CRMTEapellido1#';
		datos[i][2] = '#rsConfig.CRMTEapellido2#';
		datos[i][3] = '#rsConfig.CRMTEdireccion#';
		datos[i][4] = '#rsConfig.CRMTEapartado#';
		datos[i][5] = '#rsConfig.CRMTEtel1#';
		datos[i][6] = '#rsConfig.CRMTEtel2#';
		datos[i][7] = '#rsConfig.CRMTEtel3#';
		datos[i][8] = '#rsConfig.CRMTEemail#';
		datos[i][9] = '#rsConfig.CRMTEidentificacion#';
		i++;
	</cfoutput>
	// ---------------------------------------------------------
	cambia_tipo(document.form1.CRMTEid);
</script>