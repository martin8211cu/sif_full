<cfif isdefined("url.id_vistagrupo") and not isdefined("form.id_vistagrupo")>
	<cfset form.id_vistagrupo = url.id_vistagrupo >
</cfif>

<cfquery datasource="#session.tramites.dsn#" name="lista">
	select id_vistagrupo, id_vista, etiqueta, 3 as tab, #form.id_tipo# as id_tipo
	from DDVistaGrupo
	where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
</cfquery>

		<cfset modovg = 'ALTA'>
		<cfif isdefined("form.id_vistagrupo") and len(trim(form.id_vistagrupo))>
			<cfset modovg = 'CAMBIO'>
			
			<cfquery name="data" datasource="#session.tramites.dsn#">
				select *, 3 as tab
				from DDVistaGrupo
				where id_vistagrupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vistagrupo#">
			</cfquery>
			
		</cfif>



<table width="100%"  border="0" cellspacing="2" cellpadding="0">
	<tr>
		<td colspan="2" bgcolor="#ECE9D8" style="padding:3px;" colspan="4"><font size="1"><cfif modovg neq 'ALTA'>
				  Modificar&nbsp;la<cfelse>Agregar
				</cfif>&nbsp;Grupo de Vistas</font></td>
	</tr>

	<tr>
    	<td width="45%" valign="top">
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#Lista#"/>
				<cfinvokeargument name="desplegar" value="etiqueta"/>
				<cfinvokeargument name="etiquetas" value="Nombre"/>
				<cfinvokeargument name="formatos" value="S"/>
				<cfinvokeargument name="align" value="left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="Vista_Principal.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_vistagrupo,id_vista"/>
			</cfinvoke>
		</td>
		
		
		<cfoutput>
		<form name="formvg" action="vistaGrupo_sql.cfm" method="post" onSubmit="return validarTab2(this);">
			<input type="hidden" name="id_vista" value="#form.id_vista#">
			<input type="hidden" name="id_tipo" value="#form.id_tipo#">
			<cfif modovg eq 'CAMBIO'>
				<input name="id_vistagrupo" type="hidden" value="#data.id_vistagrupo#">
			</cfif>
		<td width="55%" valign="top">
			<table width="100%"  border="0" cellspacing="0" cellpadding="2">
			
			
			
				<tr>
			    	<td align="right">Etiqueta:&nbsp;</td>
    				<td><input type="text" size="60" maxlength="100" name="etiqueta" onFocus="this.select();" value="<cfif modovg neq 'ALTA'>#data.etiqueta#</cfif>" ></td>
 	 			</tr>
  				
				<tr>
    				<td align="right">Columna:&nbsp;</td>
    				<td><input type="text" size="6" maxlength="3" name="columna" style="text-align:right;" onFocus="this.select();" value="<cfif modovg neq 'ALTA'>#data.columna#</cfif>" ></td>
  				</tr>

 				 <tr>
    				<td align="right">Orden:&nbsp;</td>
    				<td><input type="text" size="6" maxlength="3" name="orden" style="text-align:right;" onFocus="this.select();" value="<cfif modovg neq 'ALTA'>#data.orden#</cfif>" ></td>
 		 		</tr>
  
  				<tr>
    				<td></td>
    				<td>
						<table width="100%" cellpadding="0" >
							<tr>
								<td width="1%"><input type="checkbox" name="borde" <cfif modovg neq 'ALTA' and data.borde eq 1>checked</cfif>></td>
								<td align="left">Borde</td>
							</tr>
						</table>
					</td>
 				</tr>
  				
				<tr>
					<td colspan="2" align="center">
						<cfif modovg neq 'ALTA'>
							<input type="submit" name="Modificar" value="Modificar">
							<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript: return confirm('Desea eliminar el registro?');">
							<input type="button" name="Nuevo" value="Nuevo" onClick="location.href='Vista_Principal.cfm?tab=3&id_vista=#form.id_vista#&id_tipo=#form.id_tipo#';">
						<cfelse>
							<input type="submit" name="Agregar" value="Agregar">
						</cfif>
					</td>
				</tr>
				
				
			</table>
		</td>
		</form>
		</cfoutput>
	</tr>
</table>

<script type="text/javascript" language="javascript1.2">
	function validarTab2(f){
		var msj = '';
		
		if ( document.formvg.etiqueta.value == '' ){
			msj += ' - El campo Etiqueta es requerido\n';
		}

		if ( document.formvg.columna.value == '' ){
			msj += ' - El campo Columna es requerido\n';
		}

		if ( isNaN(document.formvg.columna.value) ){
			msj += ' - El campo Columna debe ser numérico\n';
		}

		if ( document.formvg.orden.value == '' ){
			msj += ' - El campo Orden es requerido\n';
		}

		if ( isNaN(document.formvg.orden.value) ){
			msj += ' - El campo Orden debe ser numérico\n';
		}

		if ( msj !='' ){
			alert('Se presentaron los siguientes errores\n' + msj);
			return false;
		}
	
		return true;
	}
</script>
