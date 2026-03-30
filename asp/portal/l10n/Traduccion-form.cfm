<form method="post" action="Traduccion-apply.cfm" name="form1" id="form1" >

<cfoutput>
<input type="hidden" name="Iid" value="#HTMLEditFormat(Iid)#">
<input type="hidden" name="VSgrupo" value="#HTMLEditFormat(VSgrupo)#">
<input type="hidden" name="redirIid" value="#HTMLEditFormat(Iid)#">
<input type="hidden" name="redirVSgrupo" value="#HTMLEditFormat(VSgrupo)#">
</cfoutput>


<cfif Len(VSgrupo) and Len(Iid)>
	<cfif Not FileExists(ExpandPath("QueryGrupo/g#VSgrupo#.cfm"))>
		<cfoutput>No se ha definido el conjunto de datos para el grupo #VSgrupo#</cfoutput>
	<cfelse>

		<cfinclude template="QueryGrupo/g#VSgrupo#.cfm">
		<cfparam name="grupo" type="query">
		<cfparam name="grupo.valor">
		<cfparam name="grupo.descr">
		<cfparam name="grupo.grupo">
		<cfparam name="grupo.refer">

		<!--- asumir que grupo.valor está ordenado --->


		<cfparam name="VSgrupo" type="numeric">
		<cfparam name="Iid" type="numeric">
		<cfquery datasource="sifcontrol" name="valores">
			select ltrim(rtrim(VSvalor)) as VSvalor, VSdesc
			from VSidioma
			where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Iid#">
			  and VSgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#VSgrupo#">
			order by VSvalor
		</cfquery>

		<table bgcolor="#CCCCCC" cellpadding="2" cellspacing="2" align="center" width="800" >

		<cfif grupo.recordcount gt 20>
		<tr><td colspan="3" align="center" bgcolor="#FFFFFF">
<input type="submit" value="Guardar" class="btnAplicar">
		</td></tr>
</cfif>


		<tr><td><strong>C&oacute;digo</strong></td>
		<td align="center"><strong>Valor</strong></td>
		<td><strong>Etiqueta local</strong></td></tr>
		<cfoutput query="grupo" group="grupo">
			<cfif Len(Trim(grupo.grupo))>
				<tr><td bgcolor="##ededed" colspan="3"><em>&lt;&lt;#HTMLEditFormat(grupo.grupo)#&gt;&gt;</em></td></tr>
			</cfif>
			<cfoutput>
			<cfquery dbtype="query" name="buscarValor">
				select VSdesc from valores where VSvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(grupo.valor)#">
			</cfquery>
			<cfif Len(Trim(buscarValor.VSdesc))>
				<cfset valor_input = buscarValor.VSdesc>
			<cfelse>
				<!--- <cfset valor_input = grupo.descr> --->
				<cfset valor_input = ''>
			</cfif>
			<tr><td bgcolor="##FFFFFF" align="left">#HTMLEditFormat(grupo.valor)#
					<input type="hidden" name="VSvalor" value="#HTMLEditFormat(grupo.valor)#"></td>
				<td bgcolor="##FFFFFF">#HTMLEditFormat(Trim(grupo.descr))#</td>
				<td bgcolor="##FFFFFF">
				<cfif Len(Trim(grupo.valor)) GT 40>
					<!--- validar longitud maxima --->
					La longitud m&aacute;xima de 40 caracteres en el c&oacute;digo excedida. No se puede editar la etiqueta.
				<cfelse>
					<input size="40" value="#HTMLEditFormat(valor_input)#" name="valor_#HTMLEditFormat(valor)#" type="text" style="border:1px solid ##666666;background-color:##ededed" onfocus="this.select()" onChange="this.form.changed.value='*';">
				</cfif>
				</td>
				</tr>
			</cfoutput>
		</cfoutput>
		<tr><td colspan="3" align="center" bgcolor="#FFFFFF">

	<cfif isdefined("url.SScodigo") and len(trim(url.SScodigo)) >
		<input type="hidden" name="SScodigo" value="<cfoutput>#url.SScodigo#</cfoutput>">
	</cfif>
	<cfif isdefined("url.SMcodigo") and len(trim(url.SMcodigo)) >
		<input type="hidden" name="SMcodigo" value="<cfoutput>#url.SMcodigo#</cfoutput>">
	</cfif>

<input type="submit" value="Guardar" class="btnAplicar">
		</td></tr>
		</table>
	</cfif>
</cfif>
<input type="hidden" name="changed" id="changed" value="">
</form>
