<cfif isdefined("Form.Cambio") or isdefined("form.btnRegresar") or isdefined("form.BotonSel")>
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
<cfif modo neq 'ALTA'>
	<cfquery datasource="#Session.DSN#" name="rs">
		select
			Clave,
			Nombre_Corto,
			Nombre,
			Ecodigo
		from CEBancos
		where Clave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">
	</cfquery>
</cfif>

	<cfset LvarAction   = 'SQLCatalogoBancosCE.cfm'>
	<cfset LvarCuentas  = 'listaCatalogoCuentasMCE.cfm'>
	<cfset LvarImporta  = 'CatalogoBancosCEImportacion.cfm'>
	<cfset LvarEmpresas = 'EmpresasMapeoCE.cfm'>

<cfoutput>
	<form action="#LvarAction#" method="post" name="form1">
		<table align="center" cellpadding="0" cellspacing="2">
			<tr valign="baseline">
				<td nowrap align="right"><strong><cf_translate key=LB_Codigo> Clave</cf_translate>:</strong>&nbsp;</td>
				<td>
					<input type="text" name="Clave" id="Clave" value="<cfif MODO NEQ "ALTA">#rs.Clave#</cfif>"  size="12" maxlength="10" tabindex="1" <cfif MODO NEQ "ALTA">disabled = true</cfif>>
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><strong><cf_translate key=LB_NombreCorto>Nombre Corto</cf_translate>:</strong>&nbsp;</td>
				<td>
					<input type="text" name="Nombre_Corto" id="Nombre_Corto" value="<cfif MODO NEQ "ALTA">#rs.Nombre_Corto#</cfif>"  size="47" maxlength="80" tabindex="1">
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap style="vertical-align:top"><strong><cf_translate key=LB_Nombre>Nombre o raz&oacute;n social</cf_translate>:</strong>&nbsp;</td>
				<td>
                    <textarea cols="44" rows="4" name="Nombre"  id="Nombre"><cfif MODO NEQ "ALTA">#rs.Nombre#</cfif></textarea>
				</td>
			</tr>
			<tr>
				<td align="right"><input type="checkbox" name="Empresa" <cfif MODO NEQ "ALTA"><cfif #rs.Ecodigo# neq ''>checked="true"></cfif></cfif> </td>
			    <td><strong><cf_translate key=LB_Solo>Solo para esta empresa</cf_translate></strong></td>
			</tr>
			<tr valign="baseline">
				<td colspan="2">
					<input type="hidden" name="Clave" value="<cfif MODO NEQ "ALTA">#rs.Clave#</cfif>">
					<cfif modo NEQ 'ALTA'>
						<cf_botones modo="#modo#" form="form1" include="Importar" tabindex="1">
					<cfelse>
						<cf_botones modo="#modo#" form="form1" include="Importar" tabindex="1" >
					</cfif>
				</td>
			</tr>

		</table>
	</form>
</cfoutput>


<cf_qforms form="form1">
<script language="javascript" type="text/javascript">
	function funcCambio(){
		funcAlta();
	}

	function funcAlta(){
		if(document.getElementById('Clave').value != ""){
	    	if(document.getElementById('Nombre_Corto').value != ""){
	    		if(document.getElementById('Nombre').value != ""){
				    objForm.CGICMcodigo.required = true;
		            objForm.CGICMcodigo.description = 'CÃ³digo';
		            objForm.CGICMnombre.required = true;
		            objForm.CGICMnombre.description = 'Nombre de Mapeo';
				     return true;

			     }else{
				    alert('El Campo Nombre o raz\u00f3n social es requerido')
		            return false
		     	}

			}else{
				alert("El Campo Nombre Corto es requerido")
		        return false
			}

		}else{
			alert("El Campo Clave es requerido")
		    return false
		}

	}
	function funcBaja(){
		if (confirm('¿Esta seguro de eliminar este Banco?' )){
			return true;
		}
		else{
			return false;
		}

		objForm.CGICMcodigo.required = false;
		objForm.CGICMnombre.required = false;
	}

	function funcCuentas(){
		document.form1.action='<cfoutput>#LvarCuentas#</cfoutput>';
		document.form1.submit();
	}
	function funcImportar(){
		document.form1.action='<cfoutput>#LvarImporta#</cfoutput>';
		document.form1.submit();
	}
	function funcEmpresas(){
		document.form1.action='<cfoutput>#LvarEmpresas#</cfoutput>';
		document.form1.submit();
	}

	document.form1.CGICMcodigo.focus();
</script>