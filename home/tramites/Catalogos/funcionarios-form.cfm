

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
<cfif isdefined("url.id_inst") and Len("url.id_inst") gt 0 >
	<cfset form.id_inst = url.id_inst >
</cfif>
<cfif isdefined("Form.id_inst") AND Len(Trim(Form.id_inst)) GT 0 and isdefined("Form.id_funcionario") AND Len(Trim(Form.id_funcionario)) GT 0 >
	<cfset modo="CAMBIO">
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select identificacion_persona,
			   nombre,
			   apellido1,
			   apellido2,
			   email1,
			   b.id_inst,
			   id_funcionario,
			   a.id_persona,
			   nombre_inst,
			   b.vigente_desde,
			   b.vigente_hasta,
			   a.id_tipoident,
			   b.es_admin,
			   b.ts_rversion
		from TPPersona a, TPFuncionario b, TPInstitucion c
		where a.id_persona = b.id_persona			
		  and b.id_inst = c.id_inst
		  and b.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_funcionario#">
		  and b.id_inst 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
	</cfquery>
</cfif>

<SCRIPT LANGUAGE='Javascript'  SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</SCRIPT>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlis() {
		var params ="";
		params = "?formulario=formf&id=id_persona&nombre=nombre&apellido1=apellido1&apellido2=apellido2";
		popUpWindow("/cfmx/home/tramites/Catalogos/conlisPersona.cfm"+params,225,110,650,500);
	}
</script>

<cfoutput>
<form method="post" name="formf" action="funcionarios-sql.cfm" onSubmit="return f_validar(this);">
	<table border="0" align="center" width="400" cellpadding="2" cellspacing="0">
		<tr><td class="tituloMantenimiento" colspan="2"><font size="1">Funcionario</font></td></tr>

		<cfif modo eq 'ALTA'>
			<tr>
				<td colspan="2"><table width="99%" class="areaFiltro"><tr><td>Para seleccionar una persona, digite su identificaci&oacute;n o haga clic en el icono de la derecha y seleccionela de la lista</td></tr></table></td>
			</tr>
		</cfif>

		<tr valign="baseline"> 
			<td nowrap align="left" valign="top">Identificaci&oacute;n:</td>
				<td valign="middle">
					<table border="0" cellpadding="0" cellspacing="0">
						<tr><td width="480" valign="top">
							<cfquery name="rsTipoIdent" datasource="#session.tramites.dsn#">
								select id_tipoident, codigo_tipoident, nombre_tipoident, mascara
								from TPTipoIdent
								where es_fisica = 1
							</cfquery>
							<select name="id_tipoident" onchange="validar_identificacion()" >
								<option value="">-seleccionar-</option>
								<cfloop query="rsTipoIdent">
									<cfset identificacion = trim(rsTipoIdent.codigo_tipoident)&' - ' & trim(rsTipoIdent.nombre_tipoident)>
									<option value="#rsTipoIdent.id_tipoident#" <cfif modo neq 'ALTA' and rsdatos.id_tipoident eq rsTipoIdent.id_tipoident >selected</cfif> >#identificacion#</option>
								</cfloop>
							</select> 
						</td>
						<td width="125" valign="top">
								<input type="text"
								<cfif modo NEQ "ALTA">readonly</cfif> name="identificacion_persona" 
								value="<cfif modo NEQ "ALTA">#rsDatos.identificacion_persona#</cfif>"  
								onchange="validar_identificacion()" 
								onkeyup="validar_identificacion()" 
								size="20"  
								maxlength="30" 
								onfocus="javascript:this.select();"  
								style="color:##000000" 
								onBlur="<cfif modo EQ "ALTA">TraeNombre(this.value)</cfif>">
						</td>							
						<td width="84" valign="top" nowrap="nowrap">
								<img src="../images/Borrar01_S.gif" name="img_ident_mal" width="20" height="18" border="0" id="img_ident_mal" style="display:none">
							<img src="../images/check-verde.gif" name="img_ident_ok" width="18" height="20" border="0" id="img_ident_ok"  style="display:none">
						  <img src="../images/blank.gif" height="20" width="1" border="0">						</td>
						<td width="31" align="right" valign="top"><a href="javascript:doConlis();"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Personas" name="img" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlis();'></a></td>
						</tr>
						<tr>
						  <td colspan="4" align="right"><input type="text" id="explicar_mascara" name="explicar_mascara" style="border:0;font-style:italic" size="40" readonly="readonly" disabled="disabled"></td>
					  </tr>
					</table>	
				</td>
		</tr>		
		
		<tr valign="baseline"> 
			<td>Nombre:&nbsp;</td>
			<td >
				<INPUT disabled="true"
						TYPE="textbox" 
						NAME="nombre" 
						VALUE="<cfif modo NEQ "ALTA">#rsDatos.nombre#</cfif>" 
						SIZE="40" 
						tabindex="1"
						MAXLENGTH="60" 
						ONBLUR=""  
						ONFOCUS="this.select(); " 
						ONKEYUP=""
						style="color:##000000">
			</td>
		</tr>			

		<tr valign="baseline"> 
			<td>Apellido 1:&nbsp;</td>
			<td >
				<INPUT disabled="true"
						NAME="apellido1" 
						VALUE="<cfif modo NEQ "ALTA">#rsDatos.apellido1#</cfif>" 
						SIZE="40" 
						tabindex="1"
						MAXLENGTH="60" 
						ONBLUR=""  
						ONFOCUS="this.select(); " 
						ONKEYUP=""
						style="color:##000000">
			</td>
		</tr>			

		<tr valign="baseline"> 
			<td>Apellido 2:&nbsp;</td>
			<td >
				<INPUT disabled="true"
						NAME="apellido2" 
						VALUE="<cfif modo NEQ "ALTA">#rsDatos.apellido2#</cfif>" 
						SIZE="40" 
						tabindex="1"
						MAXLENGTH="60" 
						ONBLUR=""  
						ONFOCUS="this.select(); " 
						ONKEYUP="" 
						style="color:##000000">
			</td>
		</tr>			

		<cfif modo neq 'ALTA'>
			<cfinclude template="/home/tramites/getEmpresa.cfm">
			
			<!--- Persona tiene usuario asociado --->
			<cfquery name="usuario" datasource="asp">
				select Usucodigo
				from UsuarioReferencia
				where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.id_persona#">
				and STabla = 'TPPersona'
			</cfquery>
			<cfset correo = '' >
			<cfset login = '' >
			<cfif usuario.recordcount gt 0 >
				<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
				<cfset usuario = sec.getUsuarioByRef(rsDatos.id_persona, getEmpresa.EcodigoSDC, 'TPPersona') >
				<cfset correo = usuario.Pemail1 >
				<cfset login = usuario.Usulogin >
			</cfif>
		</cfif>

		<tr valign="baseline"> 
			<td nowrap>Correo Electr&oacute;nico:&nbsp;</td>
			<td >
				<INPUT TYPE="textbox" 
						NAME="email" 
						VALUE="<cfif modo NEQ "ALTA">#trim(correo)#</cfif>" 
						SIZE="40" 
						tabindex="1"
						MAXLENGTH="60" 
						ONBLUR=""  
						ONFOCUS="this.select(); " 
						ONKEYUP=""
						style="color:##000000">
			</td>
		</tr>
		
		<tr>
		  <td nowrap align="left" valign="middle">&nbsp;</td>
		  <td>Por favor confirme que la direcci&oacute;n de correo sea correcto, la contrase&ntilde;a ser&aacute; enviada a la direcci&oacute;n indicada.</td>
	  </tr>
		<tr>
			<td nowrap align="left" valign="middle">Vigente Desde:</td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr > 
						<cfif modo EQ "ALTA">
							<td width="1%" valign="middle">
								<cf_sifcalendario 
									name="vigente_desde" 
									form="formf"
									value="#LSDateFormat(now(),'DD/MM/YYYY')#"> 
							</td>
						<cfelse>
							<td width="1%" valign="middle">
								<cf_sifcalendario name="vigente_desde" form="formf" value="#LSDateFormat(rsDatos.vigente_desde,'DD/MM/YYYY')#">
							</td>
						</cfif>
						<td nowrap width="1%" valign="middle" align="left">&nbsp;Hasta:&nbsp;</td>
						<cfif modo EQ "ALTA">
							<td nowrap valign="middle">
								<cf_sifcalendario 
									name="vigente_hasta" 
									form="formf"
									value="#LSDateFormat(CreateDate(6100,1,1),'DD/MM/YYYY')#"> 
							</td>
						<cfelse>
							<td nowrap valign="middle">
								<cf_sifcalendario name="vigente_hasta" form="formf" value="#LSDateFormat(rsDatos.vigente_hasta,'DD/MM/YYYY')#">
							</td>
						</cfif>				
					</tr>
				</table>
			</td>
		</tr>	
		
		<tr >
			<td></td>
			<td>
				<table width="20%" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="middle"><input type="checkbox" id="es_admin" name="es_admin" <cfif modo neq 'ALTA' and rsDatos.es_admin eq 1>checked</cfif> ></td>
						<td valign="middle" nowrap><label for="es_admin">Es administrador</label></td>
					</tr>
				</table>
			</td>
		</tr>

		<tr id='usuario2' style="display:;">
			<td>Usuario:&nbsp;</td>
			<td><input type="text" size="30" disabled maxlength="30" name="login" value="<cfif modo neq 'ALTA'>#login#</cfif>"></td>
		</tr>
		

		<cfquery name="grupos"  datasource="#session.tramites.dsn#">
			select g.id_grupo, 
				   g.codigo_grupo, 
				   g.nombre_grupo,
				   	<cfif modo neq 'ALTA'>
				   		( select id_funcionario from TPFuncionarioGrupo fg where fg.id_grupo=g.id_grupo and fg.id_funcionario=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#"> ) as asociado
					<cfelse>
						null as asociado
					</cfif>
			from TPGrupo g
			where g.id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
		</cfquery>
		<cfquery name="servicios"  datasource="#session.tramites.dsn#">
			select g.id_tiposerv, 
				   g.codigo_tiposerv, 
				   g.nombre_tiposerv,
				   	<cfif modo neq 'ALTA'>
				   		( select id_funcionario from TPFuncionarioServicio fg where fg.id_tiposerv=g.id_tiposerv and fg.id_funcionario=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#"> ) as asociado
					<cfelse>
						null as asociado
					</cfif>
			from TPTipoServicio g
			where g.id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
		</cfquery>

		<cfif grupos.recordcount gt 0>
			<tr><td colspan="2" class="subTitulo">Funciones</td></tr>
			<tr>
				<td colspan="2">
					<table width="100%" cellpadding="2" cellspacing="0">
						<cfloop query="grupos">
							<cfif grupos.currentrow mod 2 ><tr></cfif>
							<td width="1%" valign="top"><input type="checkbox" name="grupos" value="#grupos.id_grupo#" id="chk_grupos_#grupos.id_grupo#" <cfif len(trim(grupos.asociado))>checked</cfif> ></td>
							<td valign="top"><label for="chk_grupos_#grupos.id_grupo#">#grupos.nombre_grupo#</label></td>
							<cfif not grupos.currentrow mod 2></tr></cfif>
						</cfloop>
						<cfif not grupos.recordcount mod 2></tr></cfif>
					</table>
				</td>
			</tr>
		</cfif>

		<cfif servicios.recordcount gt 0>
			<tr><td colspan="2" class="subTitulo">Servicios que brinda</td></tr>
			<tr>
				<td colspan="2">
					<table width="100%" cellpadding="2" cellspacing="0">
						<cfloop query="servicios">
							<cfif servicios.currentrow mod 2 ><tr></cfif>
							<td width="1%" valign="top"><input type="checkbox" name="servicios" value="#servicios.id_tiposerv#" id="chk_servicios_#servicios.id_tiposerv#" <cfif len(trim(servicios.asociado))>checked</cfif> ></td>
							<td valign="top"><label for="chk_servicios_#servicios.id_tiposerv#" >#servicios.nombre_tiposerv#</label></td>
							<cfif not servicios.currentrow mod 2></tr></cfif>
						</cfloop>
						<cfif not servicios.recordcount mod 2></tr></cfif>
					</table>
				</td>
			</tr>
		</cfif>

		<tr><td>&nbsp;</td></tr>
		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; ">
					<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
				<cfelse>
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">				
				</cfif>
					<input type="button" name="Lista" value="Lista de Funcionarios" onClick="javascript: location.href='instituciones.cfm?tab=4&id_inst=#form.id_inst#'">
			</td>
		</tr>
		<tr valign="baseline"> 
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
				</cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
			<input type="hidden" name="id_persona" value="<cfif modo NEQ "ALTA">#rsDatos.id_persona#</cfif>">
			<input type="hidden" name="id_funcionario" value="<cfif modo NEQ "ALTA">#rsDatos.id_funcionario#</cfif>">
			<input type="hidden" name="tab" value="4">
			<input type="hidden" name="id_inst" value="#Form.id_inst#">
		</tr>
	</table>
</form>
<iframe id="FRAMEVALIDAID" name="FRAMEVALIDAID" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>

</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	function f_validar(f){
		var msj = '';
		var ok = true;
		
		if ( f.id_persona.value == '' ){
			if ( !confirm('El funcionario que desea agregar no esta inscrito en el padrón.\n Desea agregarlo?') ){
				return false;
			}
			
			if ( f.id_tipoident.value == '' ){
				msj += ' - El campo Tipo de Identificación es requerido.\n '
			}	
			
			if ( f.identificacion_persona.value == '' ){
				msj += ' - El campo Identificación es requerido.\n '
			} else if (!validar_identificacion()) {
				msj += ' - La identificación tiene un formato inválido.\n '
			}

			if ( f.nombre.value == '' ){
				msj += ' - El campo Nombre es requerido.\n '
			}	

			if ( f.apellido1.value == '' ){
				msj += ' - El campo Apellido 1 es requerido.\n '
			}	

			if ( f.apellido2.value == '' ){
				msj += ' - El campo Apellido 2 es requerido.\n '
			}	
		}
		<cfif modo eq 'ALTA'>
		if ( f.email.value == '' ){
			msj += ' - El campo Correo Electrónico es requerido.\n '
		}
		</cfif>
			
		if ( f.vigente_desde.value == '' ){
			msj += ' - El campo Vigente Desde es requerido.\n '
		}	

		if ( f.vigente_hasta.value == '' ){
			msj += ' - El campo Vigente Hasta es requerido.\n '
		}	

		if ( msj != '' ){
			alert('Se presentaron los siguientes errores:\n' + msj)
			return false;
		}

		window.document.formf.nombre.disabled=false;
		window.document.formf.apellido1.disabled=false;
		window.document.formf.apellido2.disabled=false;
		window.document.formf.login.disabled = false;

		return true;
	}
	
	function TraeNombre(DATO) {
		window.document.formf.login.disabled = true;
		window.document.formf.login.value = '';

		document.formf.nombre.value = "";
		document.formf.apellido1.value = "";
		document.formf.apellido2.value = "";
		document.formf.id_persona.value = "";

		if (DATO != "") {
			var frame = document.getElementById("FRAMEVALIDAID");
			frame.src = "traePersona.cfm?DATO="+DATO;
		}
		else{
			window.parent.document.formf.nombre.disabled=true;
			window.parent.document.formf.apellido1.disabled=true;
			window.parent.document.formf.apellido2.disabled=true;
		}
	}
	
	
	
	
	<cfset mascara_cfc = CreateObject("component", "home.tramites.componentes.mascara")>
	TPTipoIdent_regex = {<cfoutput query="rsTipoIdent"><cfif Len(Trim(mascara))>
		'#JSStringFormat(id_tipoident)#':/#mascara_cfc.mascara2regex(mascara)#/, </cfif></cfoutput>
		dummy: 0
		};
	TPTipoIdent_mascaras = {<cfoutput query="rsTipoIdent"><cfif Len(Trim(mascara))>
		'#JSStringFormat(id_tipoident)#':'#JSStringFormat(mascara)#', </cfif></cfoutput>
		dummy: 0
		}
	
	function validar_identificacion() {
		var f = document.forms.formf;
		if (!(f && f.identificacion_persona)) return;
		// regresa true si la identificacion es valida o si no esta restringida
		var ident = f.identificacion_persona.value;
		var tipoid = f.id_tipoident.value;
		var mascara = TPTipoIdent_regex[tipoid];
		var imal = document.all ? document.all.img_ident_mal : document.getElementById('img_ident_mal');
		var iok = document.all ? document.all.img_ident_ok : document.getElementById('img_ident_ok');
		iok.style.display  = ident.length && mascara && mascara.test(ident) ? 'inline' : 'none';
		imal.style.display = ident.length && mascara && !mascara.test(ident) ? 'inline' : 'none';
		f.explicar_mascara.value = TPTipoIdent_mascaras[tipoid]?'Capturar como: '+TPTipoIdent_mascaras[tipoid]:'';
		return (!mascara) || mascara.test(ident);
	}
	validar_identificacion();
</SCRIPT>

