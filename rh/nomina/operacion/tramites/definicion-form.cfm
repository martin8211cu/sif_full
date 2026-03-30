<cfif isdefined("Form.Cambio")>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfif not isdefined("Form.modo")>    
    <cfset modo="ALTA">
  <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
  <cfelse>
    <cfset modo="ALTA">
  </cfif>  
</cfif>

<cfif isdefined('session.cache_empresarial') and session.cache_empresarial EQ 1>
	<cfset corpor = true>
<cfelse>
	<cfset corpor = false>			
</cfif>

<cfset particip = 5>

<cfif isdefined('form.ProcessId') and form.ProcessId NEQ "">
	<cfquery name="rsPosicion" datasource="#Session.DSN#">
		select convert(varchar,ActivityId) as ActivityId,Name
		from WfActivity 
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
			and Name not in ('Paso - RECHAZADO','Paso - COMPLETADO')
		order by Ordering asc
	</cfquery>
</cfif>
	
<cfquery name="rsPaquete" datasource="#Session.DSN#">
	select convert(varchar,PackageId) as PackageId
	from WfPackage 
	where Name = 'Recursos Humanos' and Ecodigo=#session.Ecodigo#
</cfquery>

<cfif rsPaquete.RecordCount IS 0>
	<cfquery name="rsPaquete" datasource="#Session.DSN#">
		insert WfPackage (Name, Description,Ecodigo)
		values ('Recursos Humanos', 'Recursos Humanos',#session.Ecodigo#)
		select @@identity as PackageId
	</cfquery>
</cfif>

<cfif modo EQ "CAMBIO" and isdefined('rsPaquete') and rsPaquete.recordCount GT 0>
	<cfquery name="rsCantParticip" datasource="#Session.DSN#">
		select count(ap.ParticipantId) as cantParticip
		from 	WfParticipant pa,
				WfActivityParticipant ap
		where PackageId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPaquete.PackageId#">
			and pa.ParticipantId=ap.ParticipantId
			and ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
	</cfquery>
	
	<cfif isdefined('rsCantParticip') and rsCantParticip.cantParticip GT 4>
		<cfset particip = rsCantParticip.cantParticip + 2>	
	</cfif>
</cfif>

<cfif isdefined('rsPaquete') and rsPaquete.recordCount GT 0 and isdefined('form.ProcessId') and form.ProcessId NEQ "">
	<cfquery name="rsTramite" datasource="#Session.DSN#">
		select Name,Description
		from WfProcess
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
			and PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPaquete.PackageId#">
	</cfquery>
</cfif>

<cfquery name="rsActiv" datasource="#Session.DSN#">
	select convert(varchar,ActivityId) as ActivityId,Name
	from WfActivity 
	where ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
		and Name not in ('Paso - RECHAZADO','Paso - COMPLETADO')
		<cfif isdefined('form.ActivityId') and form.ActivityId NEQ ''>
			and ActivityId < <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
		</cfif>
		
	order by Ordering asc
</cfquery>

<cfif isdefined('form.ActivityId') and form.ActivityId NEQ "">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select Name,Description,NotifyPartBefore,NotifySubjBefore,
				NotifyReqBefore,NotifyPartAfter,NotifySubjAfter,NotifyReqAfter
		from WfActivity
		where ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
			and ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
	</cfquery>

	<cfquery name="rsCambioPosicion" datasource="#Session.DSN#">
		select convert(varchar,FromActivity) as FromActivity
		from WfTransition 
		where ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
			and ToActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
			and Name in ('Aceptar','Completar')
	</cfquery>
	
</cfif>

<cfquery name="rsActivActuales" datasource="#Session.DSN#">
	select Name
	from WfActivity
	where ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
		and Name not in ('Paso - RECHAZADO', 'Paso - COMPLETADO')
		<cfif IsDefined('form.ActivityId') and Len(form.ActivityId)>
		and ActivityId != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
		</cfif>
	order by Ordering, Name
</cfquery>

<cfif isdefined('modo') and modo EQ 'CAMBIO' and isdefined('form.ActivityId') and form.ActivityId NEQ "">
	<cfquery name="rsTransiciones" datasource="#Session.DSN#">
		select * 
		from WfTransition 
		where FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
			and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
			and (Name = 'Regresar' or Name='Rechazar')
	</cfquery>
</cfif>

<cf_templatecss>

<form name="formDefinicion" id="formDefinicion" method="post" action="SQLdefinicion.cfm" onSubmit="javascript: return valida(this);">
	<input type="hidden" name="particip" value="<cfoutput>#particip#</cfoutput>">
	<input type="hidden" name="bandera" value="">
	<input type="hidden" name="ProcessId" value="<cfif isdefined('form.ProcessId') and form.ProcessId NEQ ""><cfoutput>#form.ProcessId#</cfoutput></cfif>">	
	<input type="hidden" name="ActivityId" value="<cfif modo EQ "CAMBIO" and isdefined('form.ActivityId') and form.ActivityId NEQ ""><cfoutput>#form.ActivityId#</cfoutput></cfif>">
		
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td colspan="5" class="subTitulo">
	  	<div align="center">	  
				Tr&aacute;mite:&nbsp;&nbsp;&nbsp;&nbsp;
				<cfoutput>#rsTramite.Name#</cfoutput>
		</div>
	  </td>
    </tr>	
    <tr> 
      <td colspan="2">&nbsp;</td>
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="5" align="center" class="subTitulo"><cfif modo NEQ "ALTA">Modificaci&oacute;n de Actividad<cfelse>Nueva Actividad</cfif></td>
    </tr>
    <tr> 
      <td colspan="2">Nombre</td> 
      <td colspan="2">
	  	<input type="radio" name="rdAccion" id="rdAccion1" value="1" onClick="javascript: Bandera(this);" 
			<cfif isdefined('modo') and modo EQ 'ALTA'> 
				checked
			<cfelseif isdefined('modo') and modo EQ 'CAMBIO' and isdefined('rsTransiciones') and rsTransiciones.recordCount EQ 0>
				checked
			</cfif>>
        <label for="rdAccion1">Notificar</label></td>
    </tr>
	<cfif isdefined('modo') and modo EQ 'CAMBIO' and isdefined('rsTransiciones')> 
		<cfquery name="rsPasoRechaz" dbtype="query">
			select *
			from rsTransiciones 
			where Name = 'Rechazar'
		</cfquery>
		<cfif isdefined('rsPasoRechaz') and rsPasoRechaz.recordCount EQ 0>
			<cfquery name="rsPasoRegresar" dbtype="query">
				select *
				from rsTransiciones 
				where Name = 'Regresar'
			</cfquery>		
		</cfif>
	</cfif>			
	
    <tr> 
      <td colspan="2"><input name="Name" type="text" id="Name" onFocus="this.select()" size="40" maxlength="20" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.Name#</cfoutput></cfif>"></td>
      <td colspan="3">
	  	<input type="radio" name="rdAccion" id="rdAccion2" value="2" onClick="javascript: Bandera(this);"
			<cfif isdefined('rsPasoRechaz') and rsPasoRechaz.recordCount GT 0> 
				checked
			</cfif>		
		>
        <label for="rdAccion2">Permite Anular</label></td>
    </tr>
    <tr> 
      <td colspan="2">Descripci&oacute;n</td> 
      <td colspan="3" nowrap> 
	  	  <cfif isdefined('rsActiv') and rsActiv.recordCount GT 0>
			  <input type="radio" name="rdAccion" id="rdAccion3" value="3" onClick="javascript: Bandera(this);"
				<cfif isdefined('rsPasoRegresar') and rsPasoRegresar.recordCount GT 0> 
					checked
				</cfif>		
			  >
			  <label for="rdAccion3">Permite regresar a </label>
			  <select name="cbActiv" id="cbActiv">
				<cfoutput query="rsActiv"> 
					<cfif isdefined('modo') and modo NEQ 'ALTA'>
						<cfif rsActiv.ActivityId NEQ form.ActivityId>
						  <option value="#rsActiv.ActivityId#"
							<cfif isdefined('rsPasoRegresar') and rsPasoRegresar.recordCount GT 0 and rsActiv.ActivityId EQ rsPasoRegresar.ToActivity> 
								selected
							</cfif>				  
						  >#rsActiv.Name#</option>
						 </cfif>
 					<cfelse>
					  <option value="#rsActiv.ActivityId#">#rsActiv.Name#</option>
				  	</cfif>
				</cfoutput> 
			  </select> 
          <cfelse>
          	&nbsp; 
		  </cfif> 
	  </td>
    </tr>
    <tr> 
      <td colspan="2" rowspan="6"><textarea name="Descripcion" cols="36" rows="7" id="Descripcion" style="font-family:Arial, Helvetica, sans-serif"><cfif modo NEQ "ALTA"><cfoutput>#rsForm.Description#</cfoutput></cfif></textarea></td>
      <td colspan="3">
		<cfif isdefined('rsPosicion') and rsPosicion.recordCount GT 0>
	  		&nbsp;&nbsp;&nbsp;<strong>Posici&oacute;n</strong>
	        <cfelse>
			&nbsp;
		</cfif>	  
	  </td>
    </tr>
    <tr>
      <td colspan="3">
			&nbsp;&nbsp;&nbsp;	
		  <cfif isdefined('rsPosicion') and rsPosicion.recordCount GT 0>
			  <select name="cbPosicion" id="cbPosicion">
				  <cfif modo NEQ 'ALTA'>
						<cfif isdefined('rsCambioPosicion') and rsCambioPosicion.recordCount EQ 0>
						  <option value="P" selected>De primero</option>			  
						<cfelse> 
						  <option value="P">De primero</option>
						</cfif>				  
						<cfif rsPosicion.recordCount GT 1>
							  <cfoutput query="rsPosicion">
								<cfif rsPosicion.ActivityId NEQ form.ActivityId>
									<option value="#rsPosicion.ActivityId#" <cfif isdefined('rsCambioPosicion') and rsCambioPosicion.recordCount GT 0 and rsCambioPosicion.FromActivity EQ rsPosicion.ActivityId> selected</cfif>>Despu&eacute;s de #rsPosicion.Name#</option>
								</cfif>
							  </cfoutput> 
						</cfif>
				  <cfelse>
					  <cfset contPosActiv = 0>
					  <option value="P">De primero</option>			  				  				  				  
					  <cfoutput query="rsPosicion">
						<cfset contPosActiv = contPosActiv + 1>					  
						
						<option value="#rsPosicion.ActivityId#"	<cfif contPosActiv EQ rsPosicion.recordCount>selected</cfif>>Despu&eacute;s de #rsPosicion.Name#</option>
					  </cfoutput>            
				  </cfif>
		    </select>
		  <cfelse>
		  	&nbsp;
		  </cfif>	  
	  </td>
    </tr>
    <tr>
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3"><input name="ckNotifyPartBefore" type="checkbox" id="ckNotifyPartBefore" value="checkbox" <cfif modo NEQ "ALTA" and rsForm.NotifyPartBefore EQ '1'> checked<cfelseif modo EQ "ALTA"> checked</cfif>>
        <label for="ckNotifyPartBefore">Notificar al responsable por email</label> </td>
    </tr>
    <tr>	
      <td colspan="3"><input name="ckNotifySubjAfter" type="checkbox" id="ckNotifySubjAfter" value="checkbox" <cfif modo NEQ "ALTA" and rsForm.NotifySubjAfter EQ '1'> checked<cfelseif modo EQ "ALTA"> checked</cfif>>
        <label for="ckNotifySubjAfter">Notificar al empleado por email</label> </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="5" align="center">
	  
	  <!--- Inicio del bloque para los participantes --->
	  
		<cfif modo EQ "CAMBIO">
			<cfquery name="rsParticipantes" datasource="#Session.DSN#">
				select Name,pa.Usucodigo,'00' as Ulocalizacion,ap.ParticipantId
				from WfParticipant pa, 
					WfActivityParticipant ap
				where pa.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPaquete.PackageId#">
					and ap.ActivityId= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
					and pa.ParticipantId=ap.ParticipantId 
				order by Name
			</cfquery>
			<cfif rsParticipantes.RecordCount neq 0>
				<cfquery datasource="asp" name="rsUsuariosPart">
					select 
						u.Usucodigo, dp.Pid,
						dp.Pnombre || ' ' || dp.Papellido1 || ' ' || dp.Papellido2 nombre
					from Usuario u, DatosPersonales dp
					where u.datos_personales = dp.datos_personales
					  and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					  and u.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsParticipantes.Usucodigo)#" list="yes">)
				</cfquery>
			</cfif>
		</cfif>	
		<cfset Cont = 0>
		<cfif modo EQ "CAMBIO">
			<input type="hidden" name="ParticABorrar" value="">
		</cfif>
	  
	  
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
			  <td colspan="4" class="subTitulo" align="center">Responsable (s) de completar esta actividad </td>
		    </tr>
			<tr>
			  <td width="23%">&nbsp;</td>
			  <td width="8%">&nbsp;</td>
			  <td width="33%" align="left" class="tituloListas">Identificaci&oacute;n</td>
			  <td width="36%" align="left" class="tituloListas">Nombre</td>
			</tr><cfif modo EQ 'CAMBIO' and rsParticipantes.RecordCount GT 0>
			<cfoutput query="rsParticipantes">
				<cfquery dbtype="query" name="thisrow">
					select * from rsUsuariosPart where Usucodigo = #rsParticipantes.Usucodigo#
				</cfquery>
			<tr height="18">
				<td>Responsable #rsParticipantes.CurrentRow#</td>
				<td align="center">
				<cfif rsParticipantes.RecordCount gt 1>
					<a href="javascript: borraPartic(#rsParticipantes.ParticipantId#,'#JSStringFormat(thisrow.nombre)#');"><img width="21" height="18" alt="Quitar a #HTMLEditFormat(thisrow.nombre)# de esta actividad"  src="/cfmx/rh/imagenes/Borrar01_T.gif" border="0"></a>
				</cfif>
					</td>
				<td>#thisrow.Pid#</td>
				<td>#thisrow.nombre#</td></tr>
			</cfoutput></cfif>
			<cfoutput>
			<tr height="18">
				<td>Seleccionar Responsable </td>
				<td align="center"><a href="javascript:conlisUsuarios()"><img src="/cfmx/rh/imagenes/Description.gif" width="18" height="14" border="0"></a></td>
				<td><input type="hidden" readonly="" id="nuevoUsucodigo" name="nuevoUsucodigo" value="" >
				    <input type="text" readonly="" id="nuevoUsuID" name="nuevoUsuID" value="" style="width:90%;border:1px solid gray"></td>
				<td><input type="text" readonly="" id="nuevoNombre" name="nuevoNombre" value="" style="width:90%;border:1px solid gray"></td></tr>
			</cfoutput>
	    </table>
	  </td>
    </tr>		

    <tr> 
      <td colspan="2">&nbsp;</td>
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="5" align="center"> 
		  <input type="hidden" name="botonSel" value="">
	      <input name="Tramites" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(); tramites();" type="button" id="Tramites" value="Volver a los trámites">	  
		  <cfif not isdefined('form.rsRO')>
			  <cfif modo EQ "ALTA">
				  <input name="Aceptar" onClick="javascript: this.form.botonSel.value = this.name; habilitarValidacion();" type="submit" id="btnAceptar" value="Aceptar">
			  <cfelse>
				  <input name="Cambiar" type="submit" id="Cambiar" onClick="javascript: this.form.botonSel.value = this.name; habilitarValidacion();" value="Cambiar">
				  <input name="Borrar" type="submit" id="Borrar" onclick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(); return confirm('¿Desea eliminar la Actividad?');" value="Borrar">
				  <input name="Nuevo" type="submit" id="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion();" value="Nuevo">
			  </cfif> 
		  </cfif>
		</td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
      <td colspan="3">&nbsp;</td>
    </tr>
  </table>
</form>

<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>

<script language="JavaScript" type="text/javascript">
//------------------------------------------------------------------------------------------		
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
//------------------------------------------------------------------------------------------		
	<!--- Actividades del proceso actual --->
	arrNombreActiv = {<cfoutput query="rsActivActuales">	
		"#JSStringFormat(rsActivActuales.Name)#": true,
	</cfoutput> "_dummy_entry_": false };

//------------------------------------------------------------------------------------------		
	function borraPartic(ParticipantId,Nombre){
		var cf = confirm('¿Desea eliminar al responsable ' + Nombre + '?');
		if(cf) {
			document.formDefinicion.ParticABorrar.value = ParticipantId;
			document.formDefinicion.submit();
		}
		return cf;
	}
//------------------------------------------------------------------------------------------		
	function tramites(){
		document.formDefinicion.action='procesos.cfm';
		
		document.formDefinicion.submit();
	}
//------------------------------------------------------------------------------------------	
	//	Solo ejecuta la funcion de Valida para el boton de Aceptar o el de Cambiar
	function valida(form){
		var f = document.formDefinicion;
		if (!btnSelected('Aceptar',f) && !btnSelected('Cambiar',f)){
			return true;
		}
		var codEmplAux = "";
		var codEmpl = "";
		var respCargado = false;				
		
		if (f.Name.value == '') {
			alert("Error, debe especificar el nombre de la actividad");
			f.Name.focus();
			return false;
		}
		if (f.Descripcion.value == '') {
			alert("Error, debe describir la actividad");
			f.Descripcion.focus();
			return false;
		}

		if (arrNombreActiv[f.Name.value] != null){
			alert('Error, ya hay una actividad con nombre ' + f.Name.value + 
				', por favor digite un nombre distinto para esta actividad');
			return false;
		}

		<cfif modo is 'ALTA' or ( modo is 'CAMBIO' and rsParticipantes.RecordCount is 0)>
		if (f.nuevoUsucodigo.value == '') {
			alert('Error, debe especificar un responsable para la actividad');
			return false;
		}
		</cfif>

		if(f.bandera.value == 1){
			if(f.cbActiv.value == ""){
				alert('Debe elegir una actividad anterior');
				return false;
			}
		}
		
		<cfif isdefined('rsActiv') and rsActiv.recordCount GT 0>
			if(f.rdAccion3.checked){
				if(((f.cbActiv.selectedIndex) + 1) > f.cbPosicion.selectedIndex){
					alert('Error, la actividad a regresar se ubica después del lugar en donde se insertará la nueva actividad');			
					
					return false;					
				}
			}
		</cfif>
		
		return true;
	}
//------------------------------------------------------------------------------------------	

	function Bandera(obj){
		switch (obj.value){
			case '1':
			case '2':
				obj.form.bandera.value = 0;
				break;
			case '3':
				obj.form.bandera.value = 1;
				break;
		}
	}
//------------------------------------------------------------------------------------------	
	function rechaza(obj, index){
		var codEmpl = "";
		eval('codEmpl = obj.form.DEid' + index + '.value');

		if(codEmpl == ""){
			alert('Debe elegir primeramente el responsable para el Paso ' + index);
			obj.checked = false;
		}
	}
//------------------------------------------------------------------------------------------
	function deshabilitarValidacion(){
		//objForm.Name.required = false;
		//objForm.Descripcion.required = false;
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		//objForm.Name.required = true;
		//objForm.Descripcion.required = true;
	}		
//------------------------------------------------------------------------------------------
	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}
	function conlisUsuarios(){
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
		}
		window.gPopupWindow = window.open("ConlisUsuariosEmpresa.cfm?s=RH","conlis",
			"width=640,height=480,left=100,top=100,toolbar=no");
		window.onfocus = closePopup;
	}
	function SeleccionarUsuario(Usucodigo, Cedula, Nombre) {
		document.formDefinicion.nuevoUsucodigo.value = Usucodigo;
		document.formDefinicion.nuevoUsuID.value = Cedula;
		document.formDefinicion.nuevoNombre.value = Nombre;
	}
	document.SeleccionarUsuario = SeleccionarUsuario;

	
</script>
