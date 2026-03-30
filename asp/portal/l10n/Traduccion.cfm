<cfquery datasource="sifcontrol" name="idiomas">
	select Iid,Icodigo,Descripcion,Icodigo as locale_lang
	from Idiomas
	order by Icodigo
</cfquery>
<cfloop query="idiomas">
	<cfset idiomas.locale_lang = Mid(idiomas.locale_lang,1,2)>
</cfloop>

<cfparam name="url.VSgrupo" default="">
<cfparam name="url.Iid" default="">

<cfquery datasource="sifcontrol" name="grupos">
	select VSgrupo, VSnombre_grupo
	from VSgrupo
	order by VSgrupo
</cfquery>

<cfquery name="rsSistemas" datasource="asp">
	select 	s.SScodigo, 
			s.SSdescripcion
	from SSistemas s
	order by 2
</cfquery>

<cfquery name="rsModulos" datasource="asp">
	select 	m.SScodigo, 
			m.SMcodigo, 
			m.SMdescripcion
	from SModulos m
	order by 3
</cfquery>

<cfif not isdefined("url.SScodigo")>
	<cfquery name="rsModulosInicial" dbtype="query">
		select 	SMcodigo, 
				SMdescripcion
		from rsModulos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsSistemas.SScodigo)#">
	</cfquery>
</cfif>
<cf_templateheader title="Traducción de etiquetas">
<cf_web_portlet_start titulo="Traducción de etiquetas">
<cfinclude template="/home/menu/pNavegacion.cfm">
<script type="text/javascript">
<!--
	function comboclick(){
		if (!document.filtro.Iid.value.length || !document.filtro.VSgrupo.value.length)
			return;
		if (document.form1){
			if (document.form1.changed.value == '*') {
				if (confirm ('¿Desea guardar los cambios?')) {
					document.form1.redirIid.value     = document.filtro.Iid.value;
					document.form1.redirVSgrupo.value = document.filtro.VSgrupo.value;
					document.form1.submit();
					return;
				}
			}
		}
		document.filtro.submit();
	}
	
//-->
</script>
<form method="get" action="Traduccion.cfm" name="filtro" id="filtro" >
<table bgcolor="#CCCCCC" width="800" cellspacing="0" cellpadding="4" align="center" >
	<tr>
		<td colspan="4"><strong>Selecci&oacute;n de datos</strong></td>
	</tr>
	<tr>
		<td valign="top" bgcolor="#EDEDED">Idioma</td>
		<td valign="top" bgcolor="#EDEDED">
			<select name="Iid" id="Iid" onchange="comboclick()">
				<cfif Not Len(url.Iid)>
					<option value="">-seleccione-</option>
				</cfif>
				<cfoutput query="idiomas" group="locale_lang">
					<optgroup label="#HTMLEditFormat(idiomas.locale_lang)#">
						<cfoutput>
							<option value="#HTMLEditFormat(idiomas.Iid)#" <cfif idiomas.Iid eq url.Iid>selected</cfif>>#HTMLEditFormat(idiomas.Descripcion)# (#HTMLEditFormat(Trim(idiomas.Icodigo))#)</option>
						</cfoutput>
					</optgroup>
				</cfoutput>
			</select>
		</td>
		
		<td valign="top" bgcolor="#EDEDED">Grupo</td>
		<td valign="top" bgcolor="#EDEDED">
			<select name="VSgrupo" id="VSgrupo" onchange="comboclick()">
				<cfif Not Len(url.VSgrupo)>
					<option value="">-seleccione-</option>
				</cfif>
				<cfoutput query="grupos">
					<option value="#HTMLEditFormat(grupos.VSgrupo)#" <cfif grupos.VSgrupo eq url.VSgrupo>selected</cfif>>#HTMLEditFormat(grupos.VSnombre_grupo)#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	
	<cfif isdefined("url.VSgrupo") and len(trim(url.VSgrupo)) and (url.VSgrupo eq 103 or url.VSgrupo eq 124)>
		<cfoutput>
		<tr>
			<td bgcolor="##EDEDED">Sistema</td>
			<td bgcolor="##EDEDED">
				<select name="SScodigo" style="width:300px;" onchange="javascript:change_sistema(this);" >
					<!---<option value="">-seleccione-</option>--->
					<cfloop query="rsSistemas">
						<option value="#rsSistemas.SScodigo#" <cfif isdefined("url.SScodigo") and url.SScodigo eq rsSistemas.SScodigo>selected</cfif> >#trim(rsSistemas.SScodigo)# - #rsSistemas.SSdescripcion#</option>
					</cfloop>
				</select>
			</td>
			<td bgcolor="##EDEDED">M&oacute;dulo</td>
			<td bgcolor="##EDEDED">
				<select name="SMcodigo" style="width:270px;" >
					<cfif isdefined("rsModulosInicial")>
						<cfloop query="rsModulosInicial">
							<option value="#rsModulosInicial.SMcodigo#" >#trim(rsModulosInicial.SMcodigo)# - #rsModulosInicial.SMdescripcion#</option>
						</cfloop>
					</cfif>
				</select>			
			</td>
		</tr>
		<tr>
			<td bgcolor="##EDEDED" colspan="4" align="center">
				<input type="button" name="btnFiltrar" class="btnFiltrar" value="Filtrar" onclick="javascript:comboclick()" />
			</td>
		</tr>
		</cfoutput>
	</cfif>	
	
</table>
</form>

<cfset VSgrupo = url.VSgrupo>
<cfset Iid     = url.Iid>

<script type="text/javascript" language="javascript1.2">
	function change_sistema(obj){
		combo = document.filtro.SMcodigo;
		combo.length = 0;
		var cont = 0;		
	
		/*
		combo.length = cont+1;
		combo.options[cont].value = '';
		combo.options[cont].text = 'seleccionar';	
		*/

		<cfloop query="rsModulos">
		if ( obj.value == '<cfoutput>#rsModulos.SScodigo#</cfoutput>' ) {
			combo.length = cont+1;
			combo.options[cont].value = '<cfoutput>#rsModulos.SMcodigo#</cfoutput>';
			combo.options[cont].text = '<cfoutput>#rsModulos.SMdescripcion#</cfoutput>';	
			<cfif isdefined("url.SMcodigo") and trim(rsModulos.SMcodigo) eq trim(url.SMcodigo) >
				combo.options[cont].selected = true;
			</cfif>
			cont = cont + 1;
		}
		</cfloop>
	}
</script>

<cfset incluir = false >
<cfif isdefined("url.VSgrupo") and len(trim(url.VSgrupo)) and isdefined("url.VSgrupo") and len(trim(url.VSgrupo))>
	<cfif url.VSGrupo neq 103 and url.VSGrupo neq 124 >
		<cfset incluir = true >
	<cfelseif isdefined("url.SScodigo") and len(trim(url.SScodigo)) >
		<cfset incluir = true >	
		<script type="text/javascript" language="javascript1.2">
			change_sistema(document.filtro.SScodigo)		
		</script>	
	</cfif>
</cfif>
<cfif incluir>
	<br />
	<cfinclude template="Traduccion-form.cfm">
</cfif>

<cf_web_portlet_end><cf_templatefooter>


