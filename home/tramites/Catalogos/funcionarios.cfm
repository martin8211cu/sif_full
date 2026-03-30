<cfif isdefined("url.id_funcionario") and not isdefined("form.id_funcionario")>
	<cfset form.id_funcionario = url.id_funcionario >
</cfif>

<cf_templatecss>
<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	SELECT id_inst,codigo_inst,nombre_inst   
	FROM TPInstitucion 
</cfquery>
	<br>
	<table width="98%" border="0" cellspacing="1" cellpadding="0">
	<tr> 
		<!----
		<td valign="top" width="50%">
			<form style="margin: 0%" name="filtrof" method="post" action="instituciones.cfm">
				<cfoutput>
				<table  border="0" width="100%" class="areaFiltro" >
					<tr> 
						<td>Nombre:</td>
						<td>Primer Apellido:</td>
						<td>Segundo Apellido:</td>
					</tr>
					<tr> 
						<td><input type="text" name="fnombre"  maxlength="60" size="25" value="<cfif isdefined("form.fnombre")>#trim(form.fnombre)#</cfif>"></td>
						<td><input type="text" name="fapellido1" maxlength="60" size="25" value="<cfif isdefined("form.fapellido1")>#trim(form.fapellido1)#</cfif>"></td>
						<td><input type="text" name="fapellido2"  maxlength="60" size="25" value="<cfif isdefined("form.fapellido2")>#trim(form.fapellido2)#</cfif>"></td>
					</tr>
					<tr> 
						<td>Identificaci&oacute;n:</td>
						<td></td>
					</tr>
					<tr> 
						<td><input type="text" name="fidentificacion"  maxlength="30" size="25" value="<cfif isdefined("form.fidentificacion")>#fidentificacion#</cfif>"></td>
						<td></td>

						<td align="right"><input type="submit" name="btnFiltrar" value="Filtrar">
						<input type="button" name="btnLimpiar" value="Limpiar" onClick="javasript: limpiarfuncionario();"> </td>
					</tr>
					
				</table>
				<input type="hidden" name="tab" value="4">
				<input type="hidden" name="id_inst" value="#form.id_inst#">
				</cfoutput>
			</form>
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select identificacion_persona,
					   nombre || ' '  || apellido1  || ' ' || apellido2 as nombre,	
					   b.id_inst,
					   id_funcionario,
					   a.id_persona,
					   nombre_inst, 
					   4 as tab
				
				from TPPersona a, TPFuncionario b, TPInstitucion c

				where c.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
				  and a.id_persona = b.id_persona			
				  and b.id_inst = c.id_inst
				  	<cfif isdefined("form.fidentificacion") and len(trim(form.fidentificacion))>
						and upper (identificacion_persona) like upper('%#trim(form.fidentificacion)#%')
				  	</cfif>
					<cfif isdefined("form.fnombre") and len(trim(form.fnombre))>
					  	and upper (nombre) like upper('%#trim(form.fnombre)#%')
					</cfif>
					<cfif isdefined("form.fapellido1") and len(trim(form.fapellido1))>
						and upper(apellido1) like upper('%#trim(form.fapellido1)#%')
					</cfif>
					<cfif isdefined("form.fapellido2") and len(trim(form.fapellido2))>
						and upper(apellido2) like upper('%#trim(form.fapellido2)#%')
					</cfif>
	
					order by nombre,apellido1,apellido2
			</cfquery>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="identificacion_persona,nombre"/>
				<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n,Nombre"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="instituciones.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_inst,id_persona,id_funcionario"/>
			</cfinvoke>
		</td>
		<td valign="top">&nbsp;&nbsp;</td>
		--->
		
		<td valign="top">
		<table width="400" align="center" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="funcionarios-form.cfm"></td></tr>
			<cfif isdefined("Form.id_inst") AND Len(Trim(Form.id_inst)) GT 0 and isdefined("Form.id_funcionario") AND Len(Trim(Form.id_funcionario)) GT 0 >
				<tr><td class="tituloMantenimiento" colspan="2"><font size="1">Ventanillas asociadas</font></td></tr>
				<tr><td><cfinclude template="funcionarios-ventanilla.cfm"></td></tr>
			</cfif>
		</table>		
		
		</td> 
		
	</tr>
	<tr> 
		<td colspan="2">&nbsp;</td>
	</tr> 
	</table>

<script language="javascript" type="text/javascript">

function limpiarfuncionario(){
	document.filtrof.fidentificacion.value = ' ';
	document.filtrof.fnombre.value = ' ';
	document.filtrof.fapellido1.value = ' ';
	document.filtrof.fapellido2.value = ' ';
}
</script>
