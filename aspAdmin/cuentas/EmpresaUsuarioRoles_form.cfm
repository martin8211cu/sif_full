<cfparam name="form.usucodigo" default="-1">
<cfparam name="form.ulocalizacion" default="">
<cfparam name="form.cliente_empresarial" default="-1">

<cfquery name="rsDatosAct" datasource="#session.DSN#">
	Select convert(varchar,up.id) as id,
		up.Ecodigo,
		referencia,
		etiqueta_referencia,	
		campoRef =
			case
				when referencia ='N' then num_referencia
				when referencia ='I' then int_referencia
--				when referencia='0' then 0
			end ,
		nombre_comercial,
		up.rol,
		r.descripcion
	from UsuarioPermiso up,
		Empresa e,
		Rol r	
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		and up.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
		and up.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
		and up.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#">
		and up.Ecodigo=e.Ecodigo
		and up.rol=r.rol
	order by up.Ecodigo,rol
</cfquery> 

<cfif isdefined('rsDatosAct') and rsDatosAct.recordCount GT 0>
	<cfquery dbtype="query" name="rsEmpreAct">
		Select distinct Ecodigo, nombre_comercial
		from rsDatosAct
	</cfquery>
</cfif>

<cfquery name="rsRolesXEmpresa" datasource="#session.DSN#">
	Select distinct (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo) + '~' + r.sistema + '~' + nombre_comercial) as CodRol
		,nombre_comercial
		, r.descripcion
	from Empresa e,
		EmpresaModulo em,
		Modulo m,
		Rol r
	where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
		and e.Ecodigo=em.Ecodigo
		and em.modulo=m.modulo
		and m.sistema=r.sistema
		and (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo))  not in (
			Select (rtrim(up.rol) + '~' + convert(varchar,emp.Ecodigo))
			from UsuarioPermiso up,
				Empresa emp,
				Rol r
			where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
				and up.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
				and up.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
				and up.Ecodigo=emp.Ecodigo
				and up.rol=r.rol
--				and r.referencia not in ('N','I')
		)
	order by nombre_comercial,descripcion
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

<link href="file://///Websdc/coldfusion/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="file://///Websdc/coldfusion/sif/css/estilos.css" rel="stylesheet" type="text/css">
<form name="formEmpresasHabil" method="post" action="file://///Websdc/coldfusion/sif/framework/usuarios/UsuarioEmpresarialRoles_sql.cfm" style="margin: 0;" onSubmit="return valida(this);">
		<cfoutput>
			<input type="hidden" name="Usucodigo" id="Usucodigo" value="#form.Usucodigo#">
			<input type="hidden" name="Ulocalizacion" id="Ulocalizacion" value="#form.Ulocalizacion#">	
			<input type="hidden" name="cliente_empresarial" id="cliente_empresarial" value="#form.cliente_empresarial#">	
		</cfoutput>
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <cfif isdefined('rsEmpreAct') and rsEmpreAct.recordCount GT 0>
			  <tr> 
				<td colspan="3" class="tituloListas" align="center">XXXXX<cfoutput>#form.nombre#</cfoutput></td>
			  </tr>
            <cfoutput> 
              <cfset etiqRef = ''>
              <cfset contPerm = 0>
              <cfloop query="rsEmpreAct">
               <cfquery dbtype="query" name="rsPermAct">
                Select id, rol, descripcion from rsDatosAct where Ecodigo=
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpreAct.Ecodigo#">
                </cfquery>
                <cfif isdefined('rsPermAct') and rsPermAct.recordCount GT 0>
                  <cfloop query="rsPermAct">
                    <tr> 
                      <td align="center" nowrap><a href="##"><img border="0" alt="Eliminar este rol" onClick="javascript: quitaRol(#rsPermAct.id#);" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a></td>
                      <td align="center" nowrap>&nbsp;</td>
                      <td >#rsPermAct.descripcion#</td>
                    </tr>
                  </cfloop>
                </cfif>
              </cfloop>
              <input type="hidden" name="btnBorrarRol" id="btnBorrarRol" value="0">
              <input type="hidden" name="IdRolBorrar" id="IdRolBorrar" value="">
              <tr> 
                <td colspan="2">&nbsp;</td>
                <td><input name="btnAgregar" type="submit" id="btnAgregar" value="Agregar"></td>
              </tr>
            </cfoutput> 
		  <cfelseif form.usucodigo EQ -1>
			  <tr> 
				<td colspan="3" class="tituloListas">Escoja un usuario para ver sus roles</td>
			  </tr>
		  <cfelse>
			  <tr> 
				<td colspan="3" class="tituloListas" align="center"><cfoutput>#form.Nombre#</cfoutput></td>
			  </tr>
			  <tr> 
				<td colspan="3" align="center"><strong>-- No tiene roles asignados --</strong></td>
			  </tr>
          </cfif>
        </table>
</form>

<iframe 
		name="frameDEid_Empleado" 
		marginheight="0" 
		marginwidth="0" 
		frameborder="0" 
		height="0" 
		width="0" 
		scrolling="auto" 
		src="">
</iframe>

<script language="JavaScript" type="text/javascript" src="file://///Websdc/coldfusion/sif/js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript">
	arrRolesConRef = new Array();	
	
	// Todos los roles que poseen referencia
	<cfoutput>
		<cfloop query="rsRolesConRef">	
			arrRolesConRef[arrRolesConRef.length] = '#rsRolesConRef.rol#'
													+ '~'
													+ '#rsRolesConRef.referencia#'
													+ '~'													
													+ '#rsRolesConRef.etiqueta_referencia#';
		</cfloop>
	</cfoutput>
//-------------------------------------------------------------------------------------------		
	// Para la validacion del campo de num_int_referencia de los roles con referencia = a N o I
	var banderaValida = false;
	
	function valida(f){
		if(banderaValida){
			<cfif isdefined('rsForm') and rsForm.recordCount GT 0 and rsForm.Pid NEQ ''>		
				if(f.num_int_referencia.value == ''){
					var emp = f.valueNuevoPermiso.value.split("~");
					alert('Error, el usuario actualmente seleccionado no se encuentra registrado como empleado para la empresa: ' + emp[3]);
					
					return false;
				}
			<cfelse>
				alert('Error, el usuario actualmente seleccionado no posee número de identificación');
				
				return false;
			</cfif>
		}
		if(f.nuevoPermiso.value == ''){
			alert('Error, nuevo rol es requerido');
			f.nuevoPermiso.focus();
			
			return false;			
		}
		
		return true;
	}
//-------------------------------------------------------------------------------------------		
	function quitaRol(cod){
		var f = document.formEmpresasHabil;
		
		if(confirm('Desea eliminar este rol ?')){
			f.btnBorrarRol.value = 1;
			f.IdRolBorrar.value = cod;			
			f.submit()
		}
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
				
		if(prende){
			<cfif isdefined('rsForm') and rsForm.recordCount GT 0 and rsForm.Pid NEQ ''>
				document.all["frameDEid_Empleado"].src="queryDEidEmpleado.cfm?keyRol=" + r[0]
						+ "&form=formEmpresasHabil"
						+ "&empresa=" + r[1]
						+ "&sistema=" + r[2]
						+ "&identifEmpleado=<cfoutput>#rsForm.Pid#</cfoutput>";
			</cfif>
			banderaValida = true;			
		}else{
			banderaValida = false;		
			obj.form.referencia.value = '0';
		}
	}
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
	function funPrueba(){
		alert('Aplica Despues');
	}
//-------------------------------------------------------------------------------------------		
	
	function doConlisRoles(){
		<cfoutput>	
			<cfif isdefined('form.Usucodigo') and form.Usucodigo NEQ '' 
						and isdefined('form.Ulocalizacion') and form.Ulocalizacion NEQ '' 
						and isdefined('form.cliente_empresarial') and form.cliente_empresarial NEQ '' >
				var params ="";
				params = "?form=formEmpresasHabil"
						+ "&paramUsucodigo=#form.Usucodigo#"
						+ "&paramUlocalizacion=#form.Ulocalizacion#"
						+ "&paramClienteEmpresarial=#form.cliente_empresarial#";

				popUpWindow("UsuarioEmpresarialRoles_conlis.cfm"+params,250,100,520,500);
			</cfif>
		</cfoutput>
	}
	function fnRefrescar()
	{
		window.document.formEmpresasHabil.action ="";
		window.document.formEmpresasHabil.submit();
	}
</script>