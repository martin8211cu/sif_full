<cfparam name="url.mod" default="0">

<cfif isdefined('url.MIGMID') and len(trim(url.MIGMID))>
	<cfquery name="rsTipo" datasource="#session.DSN#">
		select MIGMtipodetalle
		from MIGMetricas 
		where MIGMid = #url.MIGMID#
	</cfquery>
	<cfif rsTipo.RecordCount GT 0>
		<cfset tp = rsTipo.MIGMtipodetalle> 
	</cfif>
</cfif>


<cfoutput>
<cfif url.tipo EQ 'D'>
	<cfif isdefined('url.MIGMID') and len(trim(url.MIGMID)) and isdefined("tp") and tp EQ 'D'>
		<cfquery datasource="#session.DSN#" name="rsDatosSelect">
			select a.MIGMdetalleid as id, b.Deptocodigo as codigo,b.Ddescripcion as descripcion
			from MIGFiltrosmetricas a
				inner join Departamentos b
				on b.Dcodigo = a.MIGMdetalleid
				and a.Ecodigo = b.Ecodigo
			where MIGMid = #url.MIGMID#
		</cfquery>
	</cfif>
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select Dcodigo as id, Deptocodigo as codigo,Ddescripcion as descripcion from Departamentos
		where Ecodigo = #session.Ecodigo#
		<cfif isdefined('rsDatosSelect') and rsDatosSelect.recordCount GT 0>
			and Dcodigo not in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#valueList(rsDatosSelect.id)#">)
		</cfif>
		order by Deptocodigo
	</cfquery>
<cfelseif url.tipo EQ 'C'>
	<cfif isdefined('url.MIGMID') and len(trim(url.MIGMID)) and isdefined("tp") and tp EQ 'C'>
		<cfquery datasource="#session.DSN#" name="rsDatosSelect">
			select a.MIGMdetalleid as id, b.MIGCuecodigo as codigo,b.MIGCuedescripcion as descripcion
			from MIGFiltrosmetricas a
				inner join MIGCuentas b
				on b.MIGCueid = a.MIGMdetalleid
				and a.Ecodigo = b.Ecodigo
				and b.Dactiva=1
			where MIGMid = #url.MIGMID#
		</cfquery>
	</cfif>
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select MIGCueid as id, MIGCuecodigo as codigo,MIGCuedescripcion as descripcion from MIGCuentas
		where Ecodigo = #session.Ecodigo#
		and Dactiva=1
		<cfif isdefined('rsDatosSelect') and rsDatosSelect.recordCount GT 0>
			and MIGCueid not in(<cfqueryparam cfsqltype="cf_sql_numeric"  list="yes" value="#valueList(rsDatosSelect.id)#">)
		</cfif>
		order by MIGCuecodigo
	</cfquery>
<cfelseif url.tipo EQ 'P'>
	<cfif isdefined('url.MIGMID') and len(trim(url.MIGMID)) and isdefined("tp") and tp EQ 'P'>
		<cfquery datasource="#session.DSN#" name="rsDatosSelect">
			select a.MIGMdetalleid as id, b.MIGProcodigo as codigo,b.MIGPronombre as descripcion
			from MIGFiltrosmetricas a
				inner join MIGProductos b
				on b.MIGProid = a.MIGMdetalleid
				and a.Ecodigo = b.Ecodigo
				and b.Dactiva=1
			where MIGMid = #url.MIGMID#
		</cfquery>
	</cfif>
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select MIGProid as id, MIGProcodigo as codigo,MIGPronombre as descripcion from MIGProductos
		where Ecodigo = #session.Ecodigo#
		and Dactiva=1
		<cfif isdefined('rsDatosSelect') and rsDatosSelect.recordCount GT 0>
			and MIGProid not in(<cfqueryparam cfsqltype="cf_sql_numeric"  list="yes" value="#valueList(rsDatosSelect.id)#">)
		</cfif>
		order by MIGProcodigo
	</cfquery>
<cfelse>
	<cfabort>
</cfif>


<form name="formMetr">
<table cellpadding="0" cellspacing="0" border="0">
	<tr>
	<td>

	<strong>
	 <cfif url.tipo EQ 'D'>
	 	Lista Departamentos
	 <cfelseif url.tipo EQ 'C'>
	 	Lista Cuentas
	 <cfelseif url.tipo EQ 'P'>
	 	Lista Productos
	 </cfif></strong><br>
	<select name="Flista" id="Flista" multiple="multiple"  style="height:130px; width:300px">
		<cfloop query="rsDatos">
			<option value="#rsDatos.id#">#rsDatos.codigo#-#rsDatos.descripcion#</option>
		</cfloop>
	</select></td>


	<td valign="middle" align="center"><input name="btnAdd" type="button" value="&gt;&gt;" onclick="Javascript: addDepto()" <cfif url.mod GT 0>disabled="disabled"</cfif>><br>
		<input name="btnOut" type="button" value="&lt;&lt;"  onclick="Javascript: delDepto()" <cfif url.mod GT 0>disabled="disabled"</cfif>>	</td>

	<td>
	<strong>
	 <cfif url.tipo EQ 'D'>
	 	Departamentos Agregados
	 <cfelseif url.tipo EQ 'C'>
	 	Cuentas Agregadas
	 <cfelseif url.tipo EQ 'P'>
	 	Productos Agregados
	 </cfif></strong><br>
	<select name="Fselected" id="Fselected" multiple="multiple" style="height:130px; width:250px">
        <cfif isdefined('rsDatosSelect')>
          <cfloop query="rsDatosSelect">
            <option value="#rsDatosSelect.id#">#rsDatosSelect.codigo# #rsDatosSelect.descripcion#</option>
          </cfloop>
        </cfif>
      </select></td></tr>

	<tr><td colspan="3" align="center"><input name="BTNSubmit" type="button" value="Guardar" onclick="javascript: funcBTNSubmit(document.getElementById('Flista'),document.getElementById('Fselected'))"/></td></tr>
</table>
</form>
</cfoutput>