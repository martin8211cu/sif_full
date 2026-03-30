<cfparam name="url.id_datos" default="">
<cfparam name="url.Dcodigo" default="-1">
<cfparam name="url.MIGCueid" default="-1">
<cfparam name="url.MIGProid" default="-1">
<cfparam name="url.modo" default="ALTA">
<cfparam name="url.tipo" default="D">
<cfparam name="modo" default="#url.modo#">

<cfif isdefined('url.id_datos') and len(trim(url.id_datos))>
	<cfquery datasource="#session.DSN#" name="rsDatoVariable">
		select * from F_Datos
		where id_datos = #url.id_datos#
	</cfquery>
	<cfif rsDatoVariable.RecordCount gt 0>
		<cfset url.Dcodigo =  rsDatoVariable.Dcodigo>
		<cfset url.MIGCueid =  rsDatoVariable.MIGCueid>
		<cfset url.MIGProid =  rsDatoVariable.MIGProid>
	</cfif>
</cfif>

<cfparam name="form.tipo" default="">
<cfif isdefined("form.MIGMid") and len(trim(form.MIGMid))>
	<cfquery name="rsTipo" datasource="#session.DSN#">
		select MIGMtipodetalle
		from MIGMetricas a
		where MIGMid = #form.MIGMid#
	</cfquery>
	<cfif rsTipo.recordCount GT 0>
		<cfset url.tipo = rsTipo.MIGMtipodetalle>
	</cfif>
</cfif>

<cfoutput>
<cfset idDatoSelected =  '-1'>

<cfif url.tipo EQ 'D' or not isdefined ('URL.tipo') or trim(URL.tipo) EQ "" >
	<cfif isdefined('url.MIGMid') and len(trim(url.MIGMid))>
		<cfquery datasource="#session.DSN#" name="rsDatosSelect">
			select a.MIGMdetalleid as id, b.Dcodigo, b.Deptocodigo as codigo,b.Ddescripcion as descripcion
			from MIGFiltrosmetricas a
				inner join Departamentos b
				on b.Dcodigo = a.MIGMdetalleid
				and a.Ecodigo = b.Ecodigo
			where MIGMid = #url.MIGMid#
		</cfquery>
	</cfif>
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select Dcodigo as id, Deptocodigo as codigo,Ddescripcion as descripcion from Departamentos
		where Ecodigo = #session.Ecodigo#
		<cfif isdefined('rsDatosSelect') and rsDatosSelect.recordCount GT 0>
			and Dcodigo not in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#valueList(rsDatosSelect.id)#">)
		</cfif>
	</cfquery>
	<cfset idDatoSelected =  url.Dcodigo>

<cfelseif url.tipo EQ 'C'>

	<cfif isdefined('url.MIGMid') and len(trim(url.MIGMid))>
		<cfquery datasource="#session.DSN#" name="rsDatosSelect">
			select a.MIGMdetalleid as id,b.MIGCueid, b.MIGCuecodigo as codigo,b.MIGCuedescripcion as descripcion
			from MIGFiltrosmetricas a
				inner join MIGCuentas b
				on b.MIGCueid = a.MIGMdetalleid
				and a.Ecodigo = b.Ecodigo
			where MIGMid = #url.MIGMid#
		</cfquery>
	</cfif>
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select MIGCueid as id, MIGCuecodigo as codigo,MIGCuedescripcion as descripcion from MIGCuentas
		where Ecodigo = #session.Ecodigo#
		<cfif isdefined('rsDatosSelect') and rsDatosSelect.recordCount GT 0>
			and MIGCueid not in(<cfqueryparam cfsqltype="cf_sql_numeric"  list="yes" value="#valueList(rsDatosSelect.id)#">)
		</cfif>
	</cfquery>
	<cfset idDatoSelected =  url.MIGCueid>

<cfelseif url.tipo EQ 'P'>

	<cfif isdefined('url.MIGMid') and len(trim(url.MIGMid))>
		<cfquery datasource="#session.DSN#" name="rsDatosSelect">
			select a.MIGMdetalleid as id, b.MIGProcodigo as codigo,b.MIGProid, b.MIGPronombre as descripcion
			from MIGFiltrosmetricas a
				inner join MIGProductos b
				on b.MIGProid = a.MIGMdetalleid
				and a.Ecodigo = b.Ecodigo
			where a.MIGMid = #url.MIGMid#
			and b.Ecodigo=#session.Ecodigo#
		</cfquery>
	</cfif>
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select MIGProid as id, MIGProcodigo as codigo,MIGPronombre as descripcion from MIGProductos
		where Ecodigo = #session.Ecodigo#
		<cfif isdefined('rsDatosSelect') and rsDatosSelect.recordCount GT 0>
			and MIGProid not in(<cfqueryparam cfsqltype="cf_sql_numeric"  list="yes" value="#valueList(rsDatosSelect.id)#">)
		</cfif>
	</cfquery>
	<cfset idDatoSelected =  url.MIGProid>

<cfelse>
	<center>--- No hay filtros definidos para esta metrica---</center>
	<!---<cfabort>--->
</cfif>

<table cellpadding="0" cellspacing="0" border="0" width="100%" align="left">

	<cfif isdefined("rsDatosSelect") and  rsDatosSelect.recordCount GT 0>
		<tr><td>
		 	<cfif url.tipo EQ 'C'>Cuenta:&nbsp;</cfif>
			 <cfif url.tipo EQ 'D'>Departamento:&nbsp;</cfif>
			 <cfif url.tipo EQ 'P'>Producto:&nbsp;</cfif>
			</td>
			<td>
		<cfif url.tipo EQ 'D'>
		 	<select name="Fselected" id="Fselected" <cfif url.modo EQ 'CAMBIO'> disabled="disabled" </cfif> style="width:250px"	onchange="javascript: retornarDetalleDepto(this.value)">
		 <cfelse>
			<select name="Fselected" id="Fselected" <cfif url.modo EQ 'CAMBIO'> disabled="disabled" </cfif> style="width:250px" onchange="javascript: retornarDetalleid(this.value)">
		</cfif>
			<cfif isdefined('rsDatosSelect')>
			   <option value="">--seleccione--</option>
			  <cfloop query="rsDatosSelect">
				<option value="#rsDatosSelect.id#" <cfif rsDatosSelect.id EQ idDatoSelected> selected="selected" </cfif>>#rsDatosSelect.codigo# #rsDatosSelect.descripcion#</option>
			  </cfloop>
			</cfif>
		  </select>
		  </td>
		</tr>
	<!---<cfelse>
		<tr><td width="200"></td><td width="200"></td></tr>--->
	</cfif>

	<cfif url.tipo NEQ 'D'>

		<cfif not isdefined ('URL.tipo') or not len(trim(URL.tipo)) >
			<cfset url.Dcodigo = idDatoSelected>
		</cfif>

		<tr valign="baseline">
			<td nowrap align="right">Departamento:</td>
			<td align="left">
				<cfquery datasource="#Session.DSN#" name="rsDeptos">
					select Ddescripcion,Dcodigo from
					Departamentos
					where Ecodigo=#session.Ecodigo#
					order by Ddescripcion
				</cfquery>
				<select name="Dcodigo" id="Dcodigo" <cfif url.modo EQ 'CAMBIO'> disabled="disabled" </cfif> style="width:250px" onchange="javascript: retornarDetalleDepto(this.value)">
				<option value="">--seleccione--</option>
				<cfloop query="rsDeptos">
					<option value="#rsDeptos.Dcodigo#" <cfif url.Dcodigo EQ rsDeptos.Dcodigo>selected="selected"</cfif>>#rsDeptos.Ddescripcion#</option>
				</cfloop>
				</select>
			</td>
		</tr>
	</cfif>

</table>

<script>

	//caso de alta y tipo cambio en que no se seleccione en ningun momento ningun departamento, cuenta o producto

			<cfif url.tipo NEQ 'D' and isdefined('url.modo')>
				<cfif url.modo EQ 'ALTA'>
					retornarDetalleDepto(#rsDeptos.Dcodigo#);
					retornaTipo(#url.tipo#);
				<cfelse>
					retornarDetalleDepto(#url.Dcodigo#);
				</cfif>
			</cfif>

			<cfif url.modo EQ 'ALTA'>
				<cfif listContainsNoCase('D,P,C',url.tipo,',')>
					retornarDetalleid(#rsDatosSelect.id#);
					retornaTipo(#url.tipo#);
				<cfelse>
					retornarDetalleid(#rsDeptos.Dcodigo#);
				</cfif>
			<cfelse>
				retornarDetalleid(#idDatoSelected#);
			</cfif>
			return true;


</script>
</cfoutput>