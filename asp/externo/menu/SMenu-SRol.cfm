<cfquery name="rsSRM" datasource="asp">
	select rtrim(r.SScodigo) as SScodigo, s.SSdescripcion, rtrim(r.SRcodigo) as SRcodigo, r.SRdescripcion, rm.id_root, rm.default_menu
	from SRoles r
		inner join SSistemas s
			on s.SScodigo = r.SScodigo
		left join SRolMenu rm
			 on rm.SScodigo = r.SScodigo
			and rm.SRcodigo = r.SRcodigo
			and rm.id_root = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_root#">
	order by r.SScodigo, r.SRdescripcion
</cfquery>
<cfquery name="rsSS" dbtype="query">
	select distinct SScodigo, SSdescripcion
	from rsSRM
	order by SScodigo 
</cfquery>
<table cellpadding="2" cellspacing="0" border="0" width="99%" >
	<tr>
		<td colspan="3" class="subTitulo">
			Grupos de Permisos Relacionados
		</td>
	</tr>
	<tr>
		<td>
			Sistema
		</td>
		<td>
			<select name="SScodigo"
				 onChange="sbCambioSistema(this.value);"
			>
			<cfoutput query="rsSS">
				<option value="#SScodigo#">#SSdescripcion#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Def.</strong>
		</td>
		<td>
			<strong>Grupo de Permiso</strong>
		</td>
	</tr>
	<tr>
		<td colspan="3">
<cfset LvarSS = "">
<cfset LvarSS1 = rsSRM.SScodigo>
<cfoutput query="rsSRM">
	<cfif LvarSS NEQ SScodigo>
		<cfif LvarSS1 EQ SScodigo>
			<div id="DIV_#SScodigo#">
		<cfelse>
			</div>
			<div id="DIV_#SScodigo#" style="display:none;">
		</cfif>
		<cfset LvarSS = SScodigo>
	</cfif>
				<input type="checkbox" id="check_#currentRow#"  
					<cfif id_root NEQ "">checked</cfif>
					onClick="return sbCambioRolMenu('C', '#SScodigo#','#SRcodigo#',this.checked,'#currentRow#')"
				>
				<input type="checkbox" id="default_#currentRow#"
					<cfif id_root EQ "">disabled</cfif>
					<cfif default_menu EQ "1">
					onClick="return false;"
					checked
					<cfelse>
					onClick="if (!this.checked) {return false;} return sbCambioRolMenu('D', '#SScodigo#','#SRcodigo#',this.checked,'#currentRow#');"
					</cfif>
				>
				&nbsp;#SRdescripcion#<BR>
</cfoutput>
			</div>
		</td>
	</tr>
</table>
<iframe id="ifrSRolMenu" width="0" height="0"></iframe>
<script language="javascript">

	var LvarSScodigoAnt = <cfoutput>'#LvarSS1#'</cfoutput>;
	function sbCambioSistema(LvarSScodigoAct)
	{
		var LvarTR = document.getElementById('DIV_' + LvarSScodigoAnt);
		if (LvarTR)
			LvarTR.style.display = "none";
		LvarTR = document.getElementById('DIV_' + LvarSScodigoAct);
		if (LvarTR)
			LvarTR.style.display = "";
		LvarSScodigoAnt = LvarSScodigoAct;
	}
	function sbCambioRolMenu(tipo, SScodigo, SRcodigo, Agregar, idx)
	{
		if (tipo == 'C')
		{
			if (Agregar)
				document.getElementById("ifrSRolMenu").src = "SMenu-apply.cfm?OP=A&SS="+SScodigo+"&SR="+SRcodigo+"&id=<cfoutput>#data.id_root#</cfoutput>"
			else
				document.getElementById("ifrSRolMenu").src = "SMenu-apply.cfm?OP=B&SS="+SScodigo+"&SR="+SRcodigo+"&id=<cfoutput>#data.id_root#</cfoutput>"
			var Default_menu = "default_" + idx;
			document.getElementById(Default_menu).checked = false;
			document.getElementById(Default_menu).disabled = !Agregar;
		}
		else
		{
			if (Agregar)
			{
				if (!confirm("Sólo puede haber un Menú Default en el Grupo, si deja este como Default sustituirá al actual\n¿Desea sustituir este Menu como el Default del Grupo?"))
				{
					return false;
				}
				var Check_menu = "check_" + idx;
				document.getElementById(Check_menu).checked = true;
				document.getElementById("ifrSRolMenu").src = "SMenu-apply.cfm?OP=AD&SS="+SScodigo+"&SR="+SRcodigo+"&id=<cfoutput>#data.id_root#</cfoutput>"
			}
			else
				document.getElementById("ifrSRolMenu").src = "SMenu-apply.cfm?OP=BD&SS="+SScodigo+"&SR="+SRcodigo+"&id=<cfoutput>#data.id_root#</cfoutput>"
		}
		return true;
	}
</script>