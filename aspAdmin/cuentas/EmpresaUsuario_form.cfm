<cfif isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial")>
	<cfset form.cliente_empresarial = url.cliente_empresarial >
</cfif>
<cfif isdefined("url.ecodigo2") and not isdefined("form.ecodigo2")>
	<cfset form.ecodigo2 = url.ecodigo2 >
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fNombre.value  = "";
		document.filtro.fNombreC.value = "";
		document.filtro.fCuenta.value  = "";
	}
	
	function doConlis() {
		var top = (screen.height - 600) / 2;
		var left = (screen.width - 600) / 2;
		window.open('EmpresaUsuario_conlis.cfm?ecodigo2=<cfoutput>#form.ecodigo2#</cfoutput>&cliente_empresarial=<cfoutput>#form.cliente_empresarial#</cfoutput>', 'Usuarios','menu=no,scrollbars=yes,top='+top+',left='+left+',width=600,height=550');
	}
</script>

<cfif 	isdefined('form.Usucodigo') and form.Usucodigo NEQ ''
	and isdefined('form.Ulocalizacion') and form.Ulocalizacion NEQ ''
	and isdefined('form.Ecodigo2') and form.Ecodigo2 NEQ ''
	and isdefined('form.cliente_empresarial') and form.cliente_empresarial NEQ ''>
	
	<cfquery name="rsDatosRolesUsuario" datasource="#session.DSN#">
		select convert(varchar,up.id) as id
				, r.descripcion
		from UsuarioPermiso up,
			 Empresa e,
			 Rol r
		where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
			and up.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
			and up.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
			and up.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#">
			and up.Ecodigo=e.Ecodigo
			and up.rol=r.rol
		order by up.rol	
	</cfquery>
	
	<cfquery name="rsRolesConRef" datasource="#session.DSN#">
		Select distinct rtrim(r.rol) as rol, referencia,etiqueta_referencia
		from Empresa e,
			EmpresaModulo em,
			Modulo m,
			Rol r
		where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
			and e.Ecodigo=em.Ecodigo
			and em.modulo=m.modulo
			and m.sistema=r.sistema
			and r.referencia in ('N','I')
		order by rol
	</cfquery>	
</cfif>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<link href="../css/sif.css" rel="stylesheet" type="text/css">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
	  <td valign="top">
		 <cfoutput> 
			<form name="formFiltroUsuarios" style="margin:0;" action="CuentaPrincipal_tabs.cfm" method="post">
				<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#" >							
				<input type="hidden" name="Ecodigo2" value="#form.Ecodigo2#" >
			
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
				  <tr>
					<td width="2%">&nbsp;</td>
					<td width="44%"><strong>Nombre</strong></td>
					<td width="5%">&nbsp;</td>
					<td width="42%" rowspan="4" align="center" valign="middle"><input type="submit" name="Filtrar" value="Filtrar">
					</td>
					<td width="7%">&nbsp;</td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
					<td><input name="fNombre" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>#form.fNombre#</cfif>"></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
					<td><strong>Login</strong></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
					<td><input name="fLogin" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>#form.fLogin#</cfif>"></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				</table>
			</form>
		 </cfoutput>
	  </td>
	  <td valign="top">&nbsp;</td>
	  <td width="50%" rowspan="2" valign="top">
		  <cfif 	isdefined('form.Usucodigo') and form.Usucodigo NEQ ''
				and isdefined('form.Ulocalizacion') and form.Ulocalizacion NEQ ''
				and isdefined('form.Ecodigo2') and form.Ecodigo2 NEQ ''>
				
			  <form name="formRolesXUsuario" method="post" action="UsuarioEmpresarialRoles_sql.cfm" style="margin: 0;">
				  <cfoutput>
					  <!--- <input type="hidden" name="newAction" id="newAction" value="EmpresaUsuario_form.cfm"> --->
					  <input type="hidden" name="Nombre" id="Nombre" value="<cfif isdefined('form.Nombre') and form.Nombre NEQ ''>#form.Nombre#</cfif>">
					  <input type="hidden" name="valueNuevoPermiso" id="valueNuevoPermiso" value="">
					  <input type="hidden" name="referencia" id="referencia" value="">
					  <input type="hidden" name="Agregar" id="Agregar" value="0">						
					  <input type="hidden" name="IdRolBorrar" id="IdRolBorrar" value="">					
					  <input type="hidden" name="ecodigo2" id="ecodigo2" value="#form.ecodigo2#">											
					  <input type="hidden" name="btnBorrarRol" id="btnBorrarRol" value="0">					
					  <input type="hidden" name="Usucodigo" id="Usucodigo" value="#form.Usucodigo#">					
					  <input type="hidden" name="Ulocalizacion" id="Ulocalizacion" value="#form.Ulocalizacion#">
					  <input type="hidden" name="cliente_empresarial" id="cliente_empresarial" value="#form.cliente_empresarial#">				
				  </cfoutput>
				  				  				  
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				    <cfif isdefined('form.Nombre') and form.Nombre NEQ ''>				  
					    <tr>
						  <td colspan="3" nowrap align="center" class="tituloListas">
							  <strong><cfoutput>#form.Nombre#</cfoutput></strong><hr>
						  </td>				  
					    </tr>						  				
				    </cfif>
				    <tr>
					  <td colspan="3" class="tituloListas" align="center">Rol(es) Asignado(s)
				      <input name="btnAgregar" type="button" id="btnAgregar" value="Agregar" onClick="javascript: doConlisRoles();"></td>				  
				    </tr>					  
					  
					  <cfif isdefined('rsDatosRolesUsuario') and rsDatosRolesUsuario.recordCount GT 0>						
						  <cfoutput>
							  <cfloop query="rsDatosRolesUsuario">
							    <tr>
								  <td width="5%">&nbsp;</td>
								  <td width="12%"><a href="##"><img border="0" alt="Eliminar este rol" onClick="javascript: quitaRol(#rsDatosRolesUsuario.id#);" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a></td>
								  <td width="83%">#rsDatosRolesUsuario.descripcion#</td>
							    </tr>
							  </cfloop>
						  </cfoutput>
					  </cfif>
				  </table>
			  </form>					
			<cfelse>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			    <tr>
				  <td colspan="3" align="center" class="tituloListas">
					  <strong>Seleccione un usuario de la lista para ver sus roles</strong>
				  </td>				  
			    </tr>				
			  </table>			
		  </cfif>
	  </td>
  </tr>
	<tr>				
		<td width="50%" valign="top">
			<cfset select = " e.cliente_empresarial, case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
							((case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' '	else null end) +
							 (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
							 (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) as nombre,
							 u.Usucuenta, convert(varchar, ue.Usucodigo) as Usucodigo, ue.Ulocalizacion, u.Pid, #form.ecodigo2# as ecodigo2" >					 
							 
			<cfset navegacion = "">
			<cfif isdefined("Form.fNombre") and Len(Trim(Form.fNombre)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fNombre=" & Form.fNombre>
				<cfset select = select & ", '#form.fNombre#' as fNombre">
			</cfif>		
			<cfif isdefined("Form.fLogin") and Len(Trim(Form.fLogin)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fLogin=" & Form.fLogin>
				<cfset select = select & ", '#form.fLogin#' as fLogin ">				
			</cfif>
			<cfif isdefined("Form.ecodigo2") and Len(Trim(Form.ecodigo2)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ecodigo2=" & Form.ecodigo2>
			</cfif>
			<cfif isdefined("Form.cliente_empresarial") and Len(Trim(Form.cliente_empresarial)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cliente_empresarial=" & Form.cliente_empresarial>
			</cfif>						
		
			<cfset from = " UsuarioEmpresarial ue, Usuario u, Empresa e, UsuarioEmpresa uemp " >
			<cfset where = " e.Ecodigo = #form.ecodigo2#">
			<cfif isdefined('form.fNombre') and form.fNombre NEQ ''>
				<cfset where = where & " and upper(ue.Pnombre + ' ' + ue.Papellido1 + ' ' + ue.Papellido2) like upper('%#form.fNombre#%')">
			</cfif>
			<cfif isdefined('form.fLogin') and form.fLogin NEQ ''>
				<cfset where = where & " and upper(u.Usulogin) like upper('%#form.fLogin#%')">
			</cfif>				
			<cfset where = where & " and ue.Usucodigo = u.Usucodigo
						 and ue.Ulocalizacion = u.Ulocalizacion
						 and ue.cliente_empresarial = e.cliente_empresarial
						 and uemp.Ecodigo = e.Ecodigo
						 and uemp.cliente_empresarial = ue.cliente_empresarial
						 and uemp.Usucodigo = u.Usucodigo
						 and uemp.Ulocalizacion = u.Ulocalizacion">
		
			<cfset where = where & " order by  upper((case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null end) +
													 (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
													 (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) ">

			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="#from#"/>
				<cfinvokeargument name="columnas" value="#select#"/>
				<cfinvokeargument name="desplegar" value="nombre,Usulogin"/>
				<cfinvokeargument name="etiquetas" value="Nombre de Usuario, Login"/>
				<cfinvokeargument name="formatos" value="V,V"/>
				<cfinvokeargument name="filtro" value="#where#"/>
				<cfinvokeargument name="align" value="left,center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="CuentaPrincipal_tabs.cfm"/>
				<cfinvokeargument name="Conexion" value="#session.DSN#"/>
				<cfinvokeargument name="MaxRows" value="15"/>
 				<cfinvokeargument name="keys" value="Usucodigo,Ulocalizacion"/>
				<cfinvokeargument name="navegacion" value="botonSel=Buscar&#navegacion#"/>
				<!---<cfinvokeargument name="Cortes" value="nombre"/>--->
				<cfinvokeargument name="showEmptyListMsg" value="true"/> 
				<cfinvokeargument name="botones" value="Agregar,Eliminar"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="debug" value="N"/>
			</cfinvoke>
		</td>
		<td width="2%" valign="top">&nbsp;
			
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">
	arrRolesConRef = new Array();	
	
	// Todos los roles que poseen referencia
<cfif isdefined("rsRolesConRef")>
	<cfoutput>
		<cfloop query="rsRolesConRef">	
			arrRolesConRef[arrRolesConRef.length] = '#rsRolesConRef.rol#'
													+ '~'
													+ '#rsRolesConRef.referencia#'
													+ '~'													
													+ '#rsRolesConRef.etiqueta_referencia#';
		</cfloop>
	</cfoutput>
</cfif>
//-------------------------------------------------------------------------------------------			
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) 
				popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//-------------------------------------------------------------------------------------------		
	function cambioPermiso(obj){
		var p = null;
		var r = obj.value.split("~");
		var prende = false;
			
		for(var i=0;i<arrRolesConRef.length;i++){
			p = arrRolesConRef[i].split("~");
			
			if(r[0] == p[0]){ //si los roles son iguales, el seleccionado en el combo y el del arreglo de roles con referencia
				prende = true;
				obj.form.referencia.value = p[1];				
				break;
			}
		}
				
		if(!prende)		
			obj.form.referencia.value = '0';
	}
//-------------------------------------------------------------------------------------------				
	function doConlisRoles(){
		<cfoutput>	
			<cfif 	isdefined('form.Usucodigo') and form.Usucodigo NEQ ''
				and isdefined('form.Ulocalizacion') and form.Ulocalizacion NEQ ''
				and isdefined('form.Ecodigo2') and form.Ecodigo2 NEQ ''>		
					if(document.formRolesXUsuario.Usucodigo.value != '' &&
						document.formRolesXUsuario.Ulocalizacion.value != '' &&
						document.formRolesXUsuario.cliente_empresarial.value != ''){
							var params ="";
							params = "?form=formEmpresasHabil"
									+ "&Usucodigo=#form.Usucodigo#"
									+ "&Ulocalizacion=#form.Ulocalizacion#"
									+ "&cliente_empresarial=#form.cliente_empresarial#"
									+ "&paramEmpresa=#form.Ecodigo2#"
									<cfif isdefined('form.Pid') and form.Pid NEQ ''>							
										+ "&paramIdentifEmpleado=#form.Pid#"
									</cfif>									
									+ "&paramNewForm=EmpresaUsuario_Form.cfm";									
			
							popUpWindow("UsuarioEmpresarialRoles_conlis.cfm"+params,250,100,520,500);
					}else{
						alert('Primero debe seleccionar un usuario de la lista');
						return false;
					}
			</cfif>
		</cfoutput>
	}
//-------------------------------------------------------------------------------------------			
	function quitaRol(cod){
		var f = document.formRolesXUsuario;
		
		if(confirm('Desea eliminar este rol ?')){
			f.btnBorrarRol.value = 1;
			f.IdRolBorrar.value = cod;			
			f.submit()
		}
	}
//-------------------------------------------------------------------------------------------		
	function funcAgregar(){
		doConlis();
		return false;
	}
//-------------------------------------------------------------------------------------------		
	function funcEliminar(){
		if ( checkeados() ){
			if ( confirm('Va a deshabilitar los usuarios para la empresa. Desde continuar?' ) ){
				document.lista.ECODIGO2.value = '<cfoutput>#form.ecodigo2#</cfoutput>';
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';				
				document.lista.action = 'SQLUsuarios.cfm';
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay usuarios seleccionados para el proceso.');
		}	

		return false;
	}
//-------------------------------------------------------------------------------------------		
	function existe(form, name){
	// RESULTADO
	// Valida la existencia de un objecto en el form
	
		if (form[name] != undefined) {
			return true
		}
		else{
			return false
		}
	}
//-------------------------------------------------------------------------------------------		
	function check_all(obj){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (obj.checked){
				if (form.chk.length){
					for (var i=0; i<form.chk.length; i++){
						form.chk[i].checked = "checked";
					}
				}
				else{
					form.chk.checked = "checked";
				}
			}	
		}
	}
//-------------------------------------------------------------------------------------------		
	function checkeados(){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked){
						return true;
					}
				}
				return false;
			}
			else{
				if (form.chk.checked){
					return true;
				}
				else{	
					return false;
				}	
			}
		}
	}
	function fnRefrescar()
	{
		window.document.formRolesXUsuario.action ="";
		window.document.formRolesXUsuario.submit();
	}
</script>