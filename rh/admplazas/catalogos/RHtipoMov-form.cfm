<cfif isdefined("Form.RHTMid") and Len(Trim(Form.RHTMid)) GT 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<!--- Rol de Crear Plaza --->
<cfset tiene_rol = false >
<cfquery name="creaPlaza" datasource="#session.DSN#">
	select 1
	from UsuarioRol
	where SRcodigo='CREAPLAZA'
	and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">	
</cfquery>
<cfif creaPlaza.recordcount gt 0 >
	<cfset tiene_rol = true >
</cfif>	

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		Select RHTMid
			, RHTMcodigo
			, RHTMdescripcion
			, id_tramite
			, RHTMcomportamiento
			, modtabla
			, modcategoria
			, modestadoplaza
			, modcfuncional
			, modcentrocostos
			, modcomponentes
			, modindicador
			, modpuesto
			, modfechahasta
			, RHTid
			, ts_rversion
		FROM RHTipoMovimiento 
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and RHTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTMid#">
	</cfquery>
</cfif>

<cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
	<cfinvokeargument name="PackageBaseName" value="RHPP" />
</cfinvoke>

<cfquery name="rsProcesos" datasource="#Session.DSN#">
	select ProcessId, Name, upper(Name) as upper_name, PublicationStatus
	from WfProcess
	where WfProcess.Ecodigo = #session.Ecodigo#
	  and (PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfPackage.PackageId#">
		   and PublicationStatus = 'RELEASED'
			<cfif modo NEQ 'ALTA' and IsDefined('rsForm') and Len(rsForm.Id_tramite)>
				or ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Id_tramite#">
			</cfif>)
	order by upper_name
</cfquery>

<cfquery name="tipoaccion" datasource="#session.DSN#">
	select ta.RHTid, ta.RHTcodigo, ta.RHTdesc, ta.RHTpfijo
	from RHTipoAccion ta
	where ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by ta.RHTcodigo
</cfquery>

<SCRIPT SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</SCRIPT>

<script language="JavaScript">
	var accion = new Object();
	
	<cfoutput query="tipoaccion">
		accion['#RHTid#'] = new Array();
		accion['#RHTid#'][0] = '#tipoaccion.RHTpfijo#';
	</cfoutput>
</script>

<script language="JavaScript">
	function deshabilitarValidacion(){
		objForm.RHTMcodigo.required = false;
		objForm.RHTMdescripcion.required = false;
	}
</script>

<cfoutput>
<form method="post" name="form1" action="RHtipoMov-sql.cfm" onSubmit="javascript: habilita();">
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td colspan="4">&nbsp;</td>
	  </tr>	
	  <tr>
		<td width="9%" align="right"><strong>C&oacute;digo:</strong>&nbsp;</td>
		<td width="39%">
			<input type="text" name="RHTMcodigo" 
				value="<cfif modo NEQ "ALTA">#rsForm.RHTMcodigo#</cfif>" 
				size="10" maxlength="10" onfocus="javascript:this.select();" >			
		</td>
		<td width="12%" align="right"><strong>Comportamiento:</strong>&nbsp;</td>
		<td width="40%">

		<select name="RHTMcomportamiento" id="RHTMcomportamiento" onChange="javascript: cambioCompor(this);">
		  <cfif tiene_rol ><option value="10" <cfif modo NEQ 'ALTA' and rsForm.RHTMcomportamiento EQ '10'> selected</cfif>>Crear Plaza</option></cfif>
		  <option value="20" <cfif modo NEQ 'ALTA' and rsForm.RHTMcomportamiento EQ '20'> selected</cfif>>Modificar Atributo</option>
		  <option value="30" <cfif modo NEQ 'ALTA' and rsForm.RHTMcomportamiento EQ '30'> selected</cfif>>Cambio Estado</option>
	    </select>
		</td>
	  </tr>
	  <tr>
		<td align="right"><strong>Descripci&oacute;n:</strong>&nbsp;</td>
		<td>
			<input type="text" name="RHTMdescripcion" value="<cfif modo NEQ "ALTA">#rsForm.RHTMdescripcion#</cfif>" size="50" maxlength="80" onfocus="javascript:this.select();" >
		</td>

		<td align="right"><strong>Tr&aacute;mite:</strong>&nbsp;</td>
		<td >
			<select name="id_tramite" id="id_tramite">
				<option value="-1">--- Ninguno ---</option>
				<cfloop query="rsProcesos">
					<option value="#rsProcesos.ProcessId#" <cfif (MODO neq "ALTA") and (trim(rsForm.id_tramite) eq trim(rsProcesos.ProcessId))>selected</cfif>>
						#rsProcesos.Name#
					</option>
				</cfloop>
			</select></td>
	  </tr>
	
	<tr id="display_tramite">
		<td align="right" nowrap="nowrap" ><strong>Tipo de Acci&oacute;n que genera:</strong>&nbsp;</td>
		<td colspan="3">
			<select name="RHTid" onchange="javascript:cambioPlazoFijo(this);" >
				<option value="" >- seleccionar -</option>
				<cfloop query="tipoaccion">
					<option value="#tipoaccion.RHTid#" <cfif modo neq 'ALTA' and rsForm.RHTid eq tipoaccion.RHTid>selected</cfif>  >#trim(tipoaccion.RHTcodigo)# - #trim(tipoaccion.RHTdesc)#</option>
				</cfloop>
			</select>
		</td>
	</tr>	

	<tr>
		<td></td>
		<td>
			<table cellpadding="0" cellspacing="" >
				<tr>
					<td valign="middle"><input name="ckFechaHasta" <cfif modo NEQ 'ALTA' and rsForm.modfechahasta EQ 1> checked</cfif> type="checkbox" value="1" onclick="javascript:cambioAccion(this);"></td>
	 				<td valign="middle">Plazo Fijo</td>
				</tr>
			</table>
		</td>
		<td></td>

		<!--- <td>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td valign="middle"><input name="ckIndicador" <cfif modo NEQ 'ALTA' and rsForm.modindicador EQ 1> checked</cfif> type="checkbox" value="1"></td>
					<td valign="middle">Indicador de Negociable</td>
				</tr>
			</table>
		</td>	 --->	
	</tr>	


	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>	
	  <tr>
		<td colspan="4">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td>
					<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Permite Modificar" tituloalign="left">
						<table width="100%"  border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td width="31%"><input name="ckTabla" onclick="javascript:checkTabla(this);" <cfif modo NEQ 'ALTA' and rsForm.modtabla EQ 1> checked</cfif> type="checkbox" value="1">
							&nbsp;&nbsp;Tipo de Tabla</td>
							<td width="35%"><input name="ckEstadoPlaza" <cfif modo NEQ 'ALTA' and rsForm.modestadoplaza EQ 1> checked</cfif> type="checkbox" value="1">
							&nbsp;&nbsp;Estado de la Plaza </td>
						  </tr>
						  <tr>
							<td><input name="ckPuesto" <cfif modo NEQ 'ALTA' and rsForm.modpuesto EQ 1> checked</cfif> type="checkbox" value="1" />&nbsp;&nbsp;Puesto Presupuestario </td>
							<td><input name="ckCF" <cfif modo NEQ 'ALTA' and rsForm.modcfuncional EQ 1> checked</cfif> type="checkbox" value="1">&nbsp;&nbsp;Centro Funcional </td>
						  </tr>
						  <tr>
						    <td><input name="ckCategoria" <cfif modo NEQ 'ALTA' and rsForm.modcategoria EQ 1> checked</cfif> type="checkbox" value="1" />&nbsp;&nbsp;Categor&iacute;a</td>
						    <td><input name="ckComponente" <cfif modo NEQ 'ALTA' and rsForm.modcomponentes EQ 1> checked</cfif> type="checkbox" value="1">&nbsp;&nbsp;Componentes</td>
					      </tr>
						</table>
					<cf_web_portlet_end> 				
				</td>
				<td>&nbsp;&nbsp;&nbsp;</td>
			  </tr>
			</table>
		</td>
	  </tr>	 	
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>	      
	  <tr>
		<td colspan="4" align="center">
			<cf_botones modo='#modo#'>
		</td>
	  </tr>
	  <tr>
		<td colspan="4" valign="baseline">
			<input type="hidden" name="RHTMid" value="<cfif modo NEQ "ALTA">#rsForm.RHTMid#</cfif>">
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

	objForm.RHTMcodigo.required = true;
	objForm.RHTMcodigo.description="Código";	
		
	objForm.RHTMdescripcion.required = true;
	objForm.RHTMdescripcion.description="Descripción";				
	
	function cambioCompor(cb){
		var f = document.form1;
		switch(cb.value){
			case '10':{	//	Crear Plaza
				f.ckTabla.disabled = true;
				f.ckCategoria.disabled = true;
				f.ckPuesto.disabled = true;
				f.ckEstadoPlaza.disabled = true;				
				f.ckCF.disabled = true;
				//f.ckCC.disabled = true;
				//document.getElementById("display_tramite").style.display = 'none';
				document.form1.RHTid.disabled = true;
				//document.getElementById("label_tramite").style.display = 'none';
				
				//f.ckIndicador.disabled = false;
				f.ckComponente.disabled = false;
				//f.ckFechaHasta.disabled = false;
				<cfif modo EQ 'ALTA'>
					f.ckTabla.checked = 1;
					f.ckCategoria.checked = 1;
					f.ckPuesto.checked = 1;				
					f.ckEstadoPlaza.checked = 1;
					f.ckCF.checked = 1;
					//f.ckCC.checked = 1;
					
					//f.ckIndicador.checked = 0;
					f.ckComponente.checked = 0;
					//f.ckFechaHasta.checked = 0;									
				<cfelse>
					f.ckTabla.checked = 1;
					f.ckCategoria.checked = 1;
					f.ckPuesto.checked = 1;
					f.ckEstadoPlaza.checked = 1;
					f.ckCF.checked = 1;
					//f.ckCC.checked = 1;

					<cfif rsForm.modcomponentes EQ 1>
						f.ckComponente.checked = 1;
					<cfelse>
						f.ckComponente.checked = 0;
					</cfif>												
					<!--- <cfif rsForm.modindicador EQ 1>
						f.ckIndicador.checked = 1;
					<cfelse>
						f.ckIndicador.checked = 0;
					</cfif> --->
					
					<cfif rsForm.modfechahasta EQ 1>
						f.ckFechaHasta.checked = 1;
					<cfelse>
						f.ckFechaHasta.checked = 0;
					</cfif>																										
				</cfif>		
			}
			break;
			case '20':{	//	Modificar Atributo
				f.ckTabla.disabled = false;
				f.ckEstadoPlaza.disabled = true;				
				//f.ckCC.disabled = false;
				//f.ckIndicador.disabled = false;
				f.ckCategoria.disabled = false;
				f.ckCF.disabled = false;
				f.ckComponente.disabled = false;
				f.ckPuesto.disabled = false;	
				//f.ckFechaHasta.disabled = false;	
				
				//document.getElementById("display_tramite").style.display = '';
				document.form1.RHTid.disabled = false;
				//document.getElementById("label_tramite").style.display = '';
			
				<cfif modo EQ 'ALTA'>
					f.ckCF.checked = 0;			
					f.ckTabla.checked = 0;
					f.ckEstadoPlaza.checked = 0;				
					//f.ckCC.checked = 0;
					//f.ckIndicador.checked = 0;
					f.ckCategoria.checked = 0;
					f.ckComponente.checked = 0;
					f.ckPuesto.checked = 0;	
					f.ckFechaHasta.checked = 0;	
				<cfelse>
					<cfif rsForm.modtabla EQ 1>
						f.ckTabla.checked = 1;
					<cfelse>
						f.ckTabla.checked = 0;
					</cfif>
					<cfif rsForm.modcategoria EQ 1>
						f.ckCategoria.checked = 1;
					<cfelse>
						f.ckCategoria.checked = 0;
					</cfif>					 
					f.ckEstadoPlaza.checked = 0;
					<cfif rsForm.modcfuncional EQ 1>
						f.ckCF.checked = 1;
					<cfelse>
						f.ckCF.checked = 0;
					</cfif>		
					<cfif rsForm.modcomponentes EQ 1>
						f.ckComponente.checked = 1;
					<cfelse>
						f.ckComponente.checked = 0;
					</cfif>												
					<!--- <cfif rsForm.modindicador EQ 1>
						f.ckIndicador.checked = 1;
					<cfelse>
						f.ckIndicador.checked = 0;
					</cfif> --->
					<cfif rsForm.modpuesto EQ 1>
						f.ckPuesto.checked = 1;
					<cfelse>
						f.ckPuesto.checked = 0;
					</cfif>																
					<cfif rsForm.modfechahasta EQ 1>
						f.ckFechaHasta.checked = 1;
					<cfelse>
						f.ckFechaHasta.checked = 0;
					</cfif>									
				</cfif>						
			}
			break;			
			case '30':{	//	Cambiar estado
				f.ckTabla.disabled = true;
				f.ckEstadoPlaza.disabled = true;				
				//f.ckCC.disabled = true;
				//f.ckIndicador.disabled = true;
				f.ckCategoria.disabled = true;
				f.ckCF.disabled = true;
				f.ckComponente.disabled = true;
				f.ckPuesto.disabled = true;
				//f.ckFechaHasta.disabled = true;
				f.ckCF.checked = 0;			
				f.ckTabla.checked = 0;
				f.ckEstadoPlaza.checked = 1;				
				//f.ckCC.checked = 0;
				//f.ckIndicador.checked = 0;
				f.ckCategoria.checked = 0;
				f.ckComponente.checked = 0;
				f.ckPuesto.checked = 0;	
				//f.ckFechaHasta.checked = 0;
				//document.getElementById("display_tramite").style.display = '';
				document.form1.RHTid.disabled = false;
				//document.getElementById("label_tramite").style.display = '';

			}
			break;			
		}
		
		// si el check de tabla esta marcado, los checks de puesto y categoria, 
		// deben estar marcados y deshabilitados
		if ( document.form1.ckTabla.checked ){
			document.form1.ckPuesto.checked = true;
			document.form1.ckCategoria.checked = true;
			document.form1.ckPuesto.disabled = true;
			document.form1.ckCategoria.disabled = true;
		}
	}
	
	function habilita(){
		var f = document.form1;
		f.ckTabla.disabled = false;
		f.ckEstadoPlaza.disabled = false;				
		//f.ckCC.disabled = false;
		//f.ckIndicador.disabled = false;
		f.ckCategoria.disabled = false;
		f.ckCF.disabled = false;
		f.ckComponente.disabled = false;
		f.ckPuesto.disabled = false;		
	}
	function funcLimpiar(){
		document.form1.RHTMcomportamiento.value = 0;
		cambioCompor(document.form1.RHTMcomportamiento);
	}
	
	function checkTabla(obj){
		if ( obj.checked ){
			document.form1.ckPuesto.checked = true;
			document.form1.ckCategoria.checked = true;
			document.form1.ckPuesto.disabled = true;
			document.form1.ckCategoria.disabled = true;
		}
		else{
			document.form1.ckPuesto.disabled = false;
			document.form1.ckCategoria.disabled = false;
		}
	}
	
	function cambioAccion(obj){
		var f = document.form1;
		f.RHTid.options.length = 0;
		
		var i = 0;
		var plazo_fijo = 0;

		f.RHTid.options.length++;
		f.RHTid.options[i].text = '- seleccionar -';
		f.RHTid.options[i].value = '';

		<cfoutput query="tipoaccion">
			plazo_fijo = #tipoaccion.RHTpfijo#;
			if ( obj.checked == plazo_fijo ){
				i++;
				f.RHTid.options.length++;
				f.RHTid.options[i].text = '#JSStringFormat(tipoaccion.RHTcodigo)# - #JSStringFormat(tipoaccion.RHTdesc)#';
				f.RHTid.options[i].value = '#tipoaccion.RHTid#';
			}
		</cfoutput>
	}
	
	function cambioPlazoFijo(obj){
		if ( obj.value != '' ){
			if ( accion[obj.value][0] == 1 ){
				document.form1.ckFechaHasta.checked = true;
			}
			else{
				document.form1.ckFechaHasta.checked = false;
			}
		}
	}
		
	cambioCompor(document.form1.RHTMcomportamiento);
	checkTabla(document.form1.ckTabla);
	cambioAccion(document.form1.ckFechaHasta);
	<cfif modo neq 'ALTA'>
		document.form1.RHTid.value = '<cfoutput>#rsForm.RHTid#</cfoutput>';
	</cfif>
</SCRIPT>