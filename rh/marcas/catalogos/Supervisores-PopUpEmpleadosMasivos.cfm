<cf_templatecss>
<cfinvoke key="BTN_AgregarMasivo" default="Agregar Masivo" returnvariable="BTN_AgregarMasivo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Centro_Funcional" default="Centro Funcional" returnvariable="LB_Centro_Funcional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha_Hasta" default="Fecha Hasta" returnvariable="LB_Fecha_Hasta" component="sif.Componentes.Translate" method="Translate"/>		
	
<cfif isdefined("url.Gid") and len(trim(url.Gid)) and not isdefined("form.Gid")>
	<cfset form.Gid = url.Gid>
</cfif>
<!----================ AGREGAR MASIVO ===================--->
<cfif isdefined("btnAgregarMasivo")>
	<cfset vs_path = ''>
	<cfif isdefined("form.chkDependencias") and isdefined("form.CFid") and len(trim(form.CFid))>
		<cfquery name="rsPath" datasource="#session.DSN#">
			select CFpath
			from CFuncional 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfquery>
		<cfset vs_path = rsPath.CFpath & '%'>
	</cfif>
	<cfquery datasource="#session.DSN#">
		insert into RHCMEmpleadosGrupo (Gid, DEid, Ecodigo, BMUsucodigo, BMfechaalta)		
		select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">,
				a.DEid, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		from LineaTiempo a
			inner join RHPlazas b
				on a.RHPid = b.RHPid
				and a.Ecodigo = b.Ecodigo				
				<cfif isdefined("form.CFid") and len(trim(form.CFid)) and not isdefined("form.chkDependencias")>
					and b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
				<cfelseif isdefined("form.chkDependencias") and isdefined("form.CFid") and len(trim(form.CFid))>
					inner join CFuncional d
						on b.CFid = d.CFid				
						and  d.CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_path#">
				</cfif>
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhasta)#"> between a.LTdesde and a.LThasta
			<!---Tomar en cuenta solo los empleados que no hayan sido asignados a ningun grupo--->
			and not exists (select 1
							from RHCMEmpleadosGrupo  c
							where a.DEid = c.DEid
								and a.Ecodigo = c.Ecodigo
							)
	</cfquery>
	<script type="text/javascript" language="javascript1.2">
		window.opener.document.location.href = "Supervisores-tabs.cfm?tab=2&Gid="+<cfoutput>#form.Gid#</cfoutput>;
		window.close();
	</script>
</cfif>
<cfquery name="rsGrupo" datasource="#session.DSN#">
	select {fn concat(ltrim(rtrim(a.Gcodigo)),{fn concat(' ',a.Gdescripcion)})} as Grupo
	from  RHCMGrupos  a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
</cfquery>

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="3" align="center">
	<form name="form1" method="post" action="">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					<cf_translate key="LB_AgregarEmpleadosMasivo">Agregar Empleados (Masivo)</cf_translate>
				</strong>
			</td>
		</tr>
		<tr><td colspan="2"><hr></td></tr>
		<tr>
			<td width="15%" align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate></strong>:&nbsp;</td>
			<td width="89%"><strong>#rsGrupo.Grupo#</strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td width="26%">&nbsp;</td></tr>					
					<tr>
						<td align="right">#LB_Centro_Funcional#:&nbsp;</td>
						<td width="72%"><cf_rhcfuncional></td>						
					</tr>
					<tr>
						<td align="right"><cf_translate key="LB_IncluirDependencias">Incluir dependencias</cf_translate>:&nbsp;</td>
						<td width="72%"><input type="checkbox" name="chkDependencias"></td>
					</tr>
					<tr>
						<td align="right">#LB_Fecha_Hasta#:&nbsp;</td>
						<td width="72%"><cf_sifcalendario form="form1" value="" name="fhasta"></td>
					</tr>
				</table>
			</td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" name="btnAgregarMasivo" value="#BTN_AgregarMasivo#">
				&nbsp;&nbsp;
				<input type="button" name="btnCerrar" value="Cerrar" onclick="javascript: window.close();">
			</td>
		</tr>
	</form>
</table>
</cfoutput>
<cf_qforms form="form1">
<script type="text/javascript" language="javascript1.2">
	objForm.CFid.required = true;
	objForm.CFid.description="<cfoutput>#LB_Centro_Funcional#</cfoutput>";
	objForm.fhasta.required = true;
	objForm.fhasta.description="<cfoutput>#LB_Fecha_Hasta#</cfoutput>";	
</script>

