<cfparam name="url.mod" default="0">
<cfparam name="url.sub_MIGMid" default="">
<cfoutput>
<cfif isdefined('url.sub_MIGMid') and len(trim(url.sub_MIGMid))>
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Ecodigo
		from MIGMetricas
		where MIGMid = #url.sub_MIGMid#
	</cfquery>
</cfif>

<cfif url.tipo EQ 'D'>
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select  a.Ecodigo,a.Deptocodigo as codigo, a.Dcodigo as id, a.Ddescripcion as descripcion,(select Edescripcion from Empresas where Ecodigo = a.Ecodigo)Edescripcion
		from Departamentos a
		<cfif isdefined('rsEmpresa.Ecodigo') and len(trim(rsEmpresa.Ecodigo))>
		where a.Ecodigo = #rsEmpresa.Ecodigo#
		</cfif>
		order by a.Ecodigo,a.Deptocodigo
	</cfquery>
<cfelseif url.tipo EQ 'C'>
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select a.Ecodigo,a.MIGCuecodigo as codigo,a.MIGCueid as id,a.MIGCuedescripcion as descripcion,(select Edescripcion from Empresas where Ecodigo = a.Ecodigo)Edescripcion
		from MIGCuentas a
		<cfif isdefined('rsEmpresa.Ecodigo') and len(trim(rsEmpresa.Ecodigo))>
		where a.Ecodigo = #rsEmpresa.Ecodigo#
		</cfif>
		order by a.Ecodigo,a.MIGCuecodigo
	</cfquery>
<cfelseif url.tipo EQ 'P'>
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select a.Ecodigo,a.MIGProcodigo as codigo,a.MIGProid as id,a.MIGPronombre as descripcion,(select Edescripcion from Empresas where Ecodigo = a.Ecodigo)Edescripcion
		from MIGProductos a
		<cfif isdefined('rsEmpresa.Ecodigo') and len(trim(rsEmpresa.Ecodigo))>
		where a.Ecodigo = #rsEmpresa.Ecodigo#
		</cfif>
		order by a.Ecodigo,a.MIGProcodigo
	</cfquery>
<cfelse>
	<cfabort>
</cfif>

<form name="formInd">
<table cellpadding="0" cellspacing="0" border="0">
	<tr>
	 <td><strong>
	 <cfif url.tipo EQ 'D'>
	 	Lista Departamentos
	 <cfelseif url.tipo EQ 'C'>
	 	Lista Cuentas
	 <cfelseif url.tipo EQ 'P'>
	 	Lista Productos
	 </cfif></strong><br>
	 <select name="Flista" id="Flista" multiple="multiple"  style="height:130px; width:300px">
		<cfloop query="rsDatos">
			<option value="#rsDatos.id#" title="#rsDatos.Ecodigo#-#rsDatos.Edescripcion#">#rsDatos.codigo#-#rsDatos.descripcion#</option>
		</cfloop>
	</select></td>

	<td valign="middle" align="center">
		<input name="btnAdd" type="button" value="&gt;&gt;" class="btnNormal" onclick="Javascript: addDeptoInd()"><br>
		<input name="btnOut" type="button" value="&lt;&lt;" class="btnNormal" onclick="Javascript: delDeptoInd()">	</td>
	 <td><strong>
	 <cfif url.tipo EQ 'D'>
	 	Departamentos Agregados
	 <cfelseif url.tipo EQ 'C'>
	 	Cuentas Agregados
	 <cfelseif url.tipo EQ 'P'>
	 	Productos Agregados
	 </cfif></strong><br>
	 <select name="Fselected" id="Fselected" multiple="multiple" style="height:130px; width:250px">
      </select></td>
	</tr>

	<tr><td colspan="3" align="center"><input name="BTNSubmit" type="button" value="Guardar" class="btnGuardar" onclick="javascript: funcBTNSubmitInd(document.formInd.Flista,document.formInd.Fselected)"/></td></tr>
</table>
</form>
</cfoutput>