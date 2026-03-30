<script language="javascript1.1" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>	
<cfinclude template="../../../Utiles/sifConcat.cfm">
<cfset modoPermisos = "ALTA">
<cfif isdefined("form.APDid") and len(trim(form.APDid))>
	<cfset modoPermisos = "CAMBIO">
</cfif>
			
<cfif modoPermisos neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select 	APDid, APnombre, APemail, 
				AnexoId, APver, APedit, 
				APcalc, APdist, APrecip,ts_rversion, Usucodigo	
		from AnexoPermisoDef
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and APDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.APDid#">
			and AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
	</cfquery>
	<cfif len(trim(data.Usucodigo))>
		<cfquery name="rsUsuario" datasource="#session.DSN#">
			select b.Pnombre#_Cat#' '#_Cat#b.Papellido1#_Cat#' '#_Cat#b.Papellido2 as usuario
			from Usuario a
				inner join DatosPersonales b
					on a.datos_personales = b.datos_personales
			where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
		</cfquery>
	</cfif>
</cfif>
<script language="javascript" type="text/javascript">
 	//Conlis de usuarios de anexos
	var popUpWin = 0;
	 function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin){
	   if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	 }
	 
	 function doConlisUsuariosAnexo(index){
	 	popUpWindow("../../../an/operacion/admin/conlisUsuariosAnexo.cfm?formulario=formPermisos&index="+index,160,90,700,500);
	 }
	 
	 //Funcin para poner disable los campos segn el option seleccionado
	
	
	//Funcion de validacin de los campos antes de irse al SQL
	function funcValidar(){
		if (document.formPermisos.optTipo[0].checked){
			if (document.formPermisos.Usucodigo1.value == ''){
				alert("Debe seleccionar el usuario");
				return false;
			}			
		}
		else if (document.formPermisos.optTipo[1].checked){
			if(document.formPermisos.APnombre.value == '' || document.formPermisos.APemail.value == ''){
				alert("Debe indicar el nombre y el e-mail del usuario");
				return false;
			}		
		}
		return true;
	}	
</script>

<cfoutput>

<form name="formPermisos" action="anexo-permisos-sql.cfm" method="post" onSubmit="javascrip: return funcValidar();">
	<input type="hidden" name="AnexoId" value="<cfif isdefined("form.AnexoID") and len(trim(form.AnexoId))>#form.AnexoId#</cfif>">	
	<table width="100%" cellpadding="2" cellspacing="0" align="center">
		<tr>
			<td width="12%">&nbsp;</td>
			<td width="88%" colspan="2">
				<table width="100%">
					<tr>
						<td width="3%" align="right"><input type="radio" value="Usuario" name="optTipo" id="optTipo1" onClick="funcCambio('usuario');" <cfif modoPermisos NEQ 'ALTA' and len(trim(data.Usucodigo))>checked</cfif>></td>
						<td width="97%"><label for="optTipo1"><strong>Usuario</strong></label></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<table width="100%">
					<tr>
						<td width="4%">&nbsp;</td>
						<td width="96%">
							<input type="hidden" name="Usucodigo1" value="<cfif modoPermisos NEQ 'ALTA'>#data.Usucodigo#</cfif>">								
							<input type="text" name="usuario1" size="50" value="<cfif modoPermisos NEQ 'ALTA' and isdefined("rsUsuario")>#rsUsuario.usuario#</cfif>" disabled>
							<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cursos" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisUsuariosAnexo(1);'></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	  	<tr>
			<td>&nbsp;</td>
			<td colspan="2">
				<table width="100%">
					<tr>
						<td width="3%" align="right"><input type="radio" value="otro" name="optTipo" id="optTipo2" onClick="javascript: funcCambio('otro');" <cfif modoPermisos NEQ 'ALTA' and data.Usucodigo EQ ''>checked</cfif>></td>
						<td width="97%"><label for="optTipo2"><strong>Otro - Lista de distribuci&oacute;n</strong></label></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<table width="100%">
					<tr>
						<td width="4%">&nbsp;</td>
						<td width="10%" align="right" nowrap><strong>Nombre:&nbsp;</strong></td>
						<td width="86%"><input type="text" name="APnombre" value="<cfif modoPermisos NEQ 'ALTA'>#data.APnombre#</cfif>" size="50" maxlength="60"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td align="right" nowrap><strong>E-mail:&nbsp;</strong></td>
						<td><input type="text" name="APemail" value="<cfif modoPermisos NEQ 'ALTA'>#data.APemail#</cfif>" size="60" maxlength="255"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<table width="100%">
					<tr>
						<td width="1%">&nbsp;</td>
						<td width="99%"><strong>Permisos:</strong></td>
					</tr>
				</table>
			</td>			
		</tr>
		<tr>			
			<td>&nbsp;</td>
			<td>
				<table width="799" border="0">					
					<tr>
						<td nowrap colspan="3">
							<input type="checkbox" name="APedit" <cfif modoPermisos NEQ 'ALTA' and data.APedit EQ 1>checked</cfif> value="" id="chk_edit">
							<label for="chk_edit" class="td"><strong>Editar el Diseño del Anexo y sus cuentas, en Administración de Anexos</strong></label>
						</td>	
					</tr>
					<tr>
						<td nowrap>
							<input type="checkbox" name="APcalc" <cfif modoPermisos NEQ 'ALTA' and data.APcalc EQ 1>checked</cfif> value="" id="chk_calc"
								onclick="if (!this.checked) this.form.APdist.checked = false;">
							<label for="chk_calc"><strong>Calcular y refrescar Anexo Calculado</strong></label>
						</td>
						<td nowrap>
					  		<input type="checkbox" name="APdist" <cfif modoPermisos NEQ 'ALTA' and data.APcalc EQ 1 and data.APdist EQ 1>checked</cfif> value="" id="chk_dist">
							<label for="chk_dist"><strong>Distribuir el Anexo Calculado</strong></label>
						</td>
						<td nowrap>
							<input type="checkbox" name="APrecip" <cfif modoPermisos NEQ 'ALTA' and data.APrecip EQ 1>checked</cfif> value="" id="chk_recib">
							<label for="chk_recib"><strong>Recibir una copia del Anexo Calculado</strong></label>
						</td>
					</tr>
					<tr>
						<td nowrap colspan="2">
							<input type="checkbox"  name="APver" <cfif modoPermisos NEQ 'ALTA' and data.APver EQ 1>checked</cfif> value="" id="chk_ver">
							<label for="chk_ver"><strong>Consultar el resultado del Anexo Calculado</strong></label>
						</td>	
					</tr>
			  </table>
			</td>
		</tr>
		<!--- Botones --->
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modoPermisos eq 'ALTA'>
					<input type="submit" name="AltaPerm" value="Agregar"><!---- onClick="javascript: habilitarValidacion();"--->
					<input type="reset" name="Limpiar" value="Limpiar">
				<cfelse>
					<input type="submit" name="CambioPerm" value="Modificar"><!---onClick="habilitarValidacion();"--->
					<input type="submit" name="BajaPerm" value="Eliminar" onClick="if ( confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;">
					<input type="submit" name="NuevoPerm" value="Nuevo"><!-- onClick="deshabilitarValidacion();"--->
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>		
	</table>
	<cfif modoPermisos neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="APDid" value="#data.APDid#">
		<input type="hidden" name="tab" value="3">
		<input type="hidden" name="tipo" value="<cfif modoPermisos NEQ 'ALTA' and data.Usucodigo NEQ ''>usuario<cfelse>otro</cfif>">
	</cfif>
</form>
</cfoutput>

	
<script type="text/javascript" language="JavaScript1.1">
	function funcCambio(parmvalor){
	if(parmvalor=="usuario"){
		document.formPermisos.APnombre.disabled=true;
		document.formPermisos.APemail.disabled=true;
		document.formPermisos.APnombre.value = '';
		document.formPermisos.APemail.value = '';
		document.formPermisos.usuario1.disabled=false;
		document.formPermisos.APver.disabled=false;
		document.formPermisos.APedit.disabled=false;
		document.formPermisos.APcalc.disabled=false;
		document.formPermisos.APdist.disabled=false;			
	}
	else if (parmvalor=="otro"){
		document.formPermisos.usuario1.value='';
		document.formPermisos.Usucodigo1.value='';
		document.formPermisos.usuario1.disabled=true;			
		document.formPermisos.APnombre.disabled=false;
		document.formPermisos.APemail.disabled=false;
		document.formPermisos.APver.checked=false;
		document.formPermisos.APedit.checked=false;
		document.formPermisos.APcalc.checked=false;
		document.formPermisos.APdist.checked=false;
		document.formPermisos.APver.disabled=true;
		document.formPermisos.APedit.disabled=true;
		document.formPermisos.APcalc.disabled=true;
		document.formPermisos.APdist.disabled=true;		
		}
	}
		
	<cfif modoPermisos neq 'ALTA'>	
		funcCambio(trim(document.formPermisos.tipo.value));
	<cfelse>
		funcCambio('usuario');
	</cfif>
</script>

