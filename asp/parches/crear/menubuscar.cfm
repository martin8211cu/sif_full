<cfif isdefined("url.Opciones") and url.Opciones EQ "LLENAR">
	<cfquery name="rsMN" datasource="asp">
		select mn.SMNcodigo, mn.SMNtipo, 
				substring('                                                  ', 1, (mn.SMNnivel-1)*2) || 
				case when mn.SMNtipo = 'P' 
					then coalesce(pp.SPdescripcion	, '** PROCESO NO DEFINIDO **')
					else coalesce(mn.SMNtitulo		, '** OPCION DE MENÚ NO DEFINIDO **')
				end as Opcion
		from SMenues mn
			left join SProcesos pp
				 on pp.SScodigo = mn.SScodigo
				and pp.SMcodigo = mn.SMcodigo
				and pp.SPcodigo = mn.SPcodigo
			where mn.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SS#">
			  and mn.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SM#">
			  and mn.SMNnivel > 0
		order by mn.SScodigo, mn.SMcodigo, SMNpath, SPorden
	</cfquery>
	<input style="width=2; font-weight:bold" />
	<script type="text/javascript">
		var smn = parent.document.form1.SMNcodigo;
		<cfoutput query="rsMN">
			smn.length++;
			<cfif SMNtipo EQ "P">
				smn.options[smn.length-1].value = '# JSStringFormat(SMNcodigo) #';
				smn.options[smn.length-1].text = '# JSStringFormat(Opcion) #';
			<cfelse>
				smn.options[smn.length-1].value = '*';
				smn.options[smn.length-1].text = '# JSStringFormat(Opcion) #';
				smn.options[smn.length-1].style.color = "blue";
			</cfif>
		</cfoutput>
	</script>
	<cfabort>
</cfif>

<cf_templateheader title="Creación de Parches">
	<cfinclude template="mapa.cfm">
	<h1>Seleccionar opciones de Menú</h1>
	<p>
	Seleccione el sistema, módulo y opciones de menú que desea incluir dentro del parche.</p>
	<p>Se incluirán en el parche las opciones de menú nuevas y modificadas para documentación.  </p>
	<cfparam name="url.SScodigo" default="">
	<cfquery datasource="asp" name="sis">
		select rtrim(SScodigo) as SScodigo, SSdescripcion
		from SSistemas
		order by SSdescripcion, SScodigo
	</cfquery>
	<cfquery datasource="asp" name="mod">
		select rtrim(SScodigo) as SScodigo, rtrim(SMcodigo) as SMcodigo,
			SMdescripcion
		from SModulos
		order by SScodigo, SMdescripcion, SMcodigo
	</cfquery>
	<cfform height="300" width="700" id="form1" name="form1" 
		method="post" action="segbuscar-control.cfm" format="#session.parche.form_format#"
		timeout="60" >
		<cfif session.parche.form_format EQ 'html'>
			<cfset onchangess = "change_ss(this.form.SScodigo,this.form.SMcodigo,this.form.SMNcodigo)">
			<cfset onchangesm = "change_sm(this.form.SScodigo,this.form.SMcodigo,this.form.SMNcodigo)">
			
			<script type="text/javascript">
				function change_ss(ss,sm,smn)
				{
					while (sm.length>1)		{sm.remove(1);}
					while (smn.length>1)	{smn.remove(1);}
					<cfoutput query="mod" group="SScodigo">
					if(ss.value=='# JSStringFormat(SScodigo) #')
					{<cfoutput>
						sm.length++;
						sm.options[sm.length-1].value = '# JSStringFormat(SMcodigo) #';
						sm.options[sm.length-1].text = '# JSStringFormat(SMdescripcion) #';
					</cfoutput>}
					</cfoutput>
				}
				function change_sm(ss,sm,smn)
				{
					while (smn.length>1)		{smn.remove(1);}
					document.getElementById("ifrSMNcodigo").src="menubuscar.cfm?Opciones=LLENAR&SS=" + ss.value + "&SM=" + sm.value
				}
				function change_smn(smn)
				{
					while (smn.value == '*' && smn.selectedIndex < smn.length)
					{
						smn.selectedIndex ++;
					}
				}
			</script>
		<cfelse>
			<cfsavecontent variable="onchangess">
				while(SMcodigo.getLength()>1)	SMcodigo.removeItemAt(1);
				<cfoutput query="mod" group="SScodigo">
				if(SScodigo.value=='# JSStringFormat(SScodigo) #')
				{<cfoutput>
					SMcodigo.addItem('# JSStringFormat(SMdescripcion) #','# JSStringFormat(SMcodigo) #');
				</cfoutput>}
				</cfoutput>
			</cfsavecontent>
		</cfif>
		<cf_web_portlet_start width="700" titulo="Seleccione los sistemas, módulos y opciones de menú que desea Documentar en el Parche">
			<cfformgroup type="panel" label="Seleccione los sistemas, módulos y opciones de menú que desea Documentar en el Parche">
				<table>
					<tr>
						<td><label for="SMNcodigo">Tipo</label></td>
						<td>
							<select name="SMNtipo" label="Opción Menú" width="350" style="width:350px">
								<option value="1" >Opción de Menú Nueva</option>
								<option value="2" >Opción de Menú Modificada</option>
								<option value="3" >Otros Procesos</option>
							</select>
						</td>
					</tr>
					<tr>
						<td><label for="SScodigo">Sistema</label></td>
						<td>
							<cfselect 	name="SScodigo" label="Sistema" width="350" style="width:350px" query="sis" value="SScodigo" display="SSdescripcion"
										selected="#url.SScodigo#" onChange="#onchangess#" queryPosition="below" required="yes">
								<option value="" selected="selected">- Seleccione un sistema -</option>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td><label for="SMcodigo">Módulo</label></td>
						<td>
							<cfselect name="SMcodigo" label="Módulo" width="350" style="width:350px" onChange="#onchangesm#">
								<option value="" >- Seleccione un módulo -</option>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td><label for="SMNcodigo">Opción de Menú</label></td>
						<td>
							<cfselect name="SMNcodigo" label="Opción Menú" width="350" style="width:350px" onChange="change_smn(this);">
								<option value="" >- Seleccione una opcion de menú -</option>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td><label for="SMNcodigo">Descripción</label></td>
						<td>
							<textarea cols="60" rows="5" name="SMNdescripcion"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<cfinput type="submit" name="Submit" value="Agregar" class="btnGuardar" />
						</td>
					</tr>
				</table>
				<cfset fnDetalle('#session.parche.guid#','1')>
				<cfset fnDetalle('#session.parche.guid#','2')>
				<cfset fnDetalle('#session.parche.guid#','3')>
			</cfformgroup>
		<cf_web_portlet_end>
	</cfform>
<cf_templatefooter>
<iframe name="ifrSMNcodigo" id="ifrSMNcodigo" width="0" height="0" frameborder="0"> 
</iframe>
<cffunction name="fnDetalle" output="true">
	<cfargument name="parche"	required="yes">
	<cfargument name="tipo"		required="yes">

	<cfquery name="rsDetalle" datasource="asp">
		<cfif Arguments.Tipo EQ "3">
		select pm.SMNcodigo, pm.SScodigo, pm.SMcodigo, ss.SSdescripcion, mm.SMdescripcion, 'P' as SPcodigo, 0 as SMNnivel, 'PROCESO' as Opcion, pm.detalle
		  from APOpcionesx pm
			inner join asp..SSistemas ss
				 on ss.SScodigo = pm.SScodigo
			inner join asp..SModulos mm
				 on mm.SScodigo = pm.SScodigo
				and mm.SMcodigo = pm.SMcodigo
		  where pm.parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Parche#">
			and pm.tipo	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">
		order by pm.SScodigo, pm.SMcodigo
		<cfelse>
		select mn.SMNcodigo, mn.SScodigo, mn.SMcodigo, mn.SPcodigo, mn.SMNpath, ss.SSdescripcion, mm.SMdescripcion, mn.SMNtipo, mn.SMNnivel, coalesce(pp.SPdescripcion, '** PROCESO NO DEFINIDO **') as Opcion, pm.detalle
		  from APOpcionesx pm
			inner join SMenues mn
				 on mn.SMNcodigo = pm.SMNcodigo
			inner join asp..SSistemas ss
				 on ss.SScodigo = mn.SScodigo
			inner join asp..SModulos mm
				 on mm.SScodigo = mn.SScodigo
				and mm.SMcodigo = mn.SMcodigo
			left join asp..SProcesos pp
				 on pp.SScodigo = mn.SScodigo
				and pp.SMcodigo = mn.SMcodigo
				and pp.SPcodigo = mn.SPcodigo
		  where pm.parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Parche#">
			and pm.tipo	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">
		UNION
		select mn.SMNcodigo, mn.SScodigo, mn.SMcodigo, mn.SPcodigo, mn.SMNpath, ss.SSdescripcion, mm.SMdescripcion, mn.SMNtipo, mn.SMNnivel, coalesce(mn.SMNtitulo, '** OPCION DE MENÚ NO DEFINIDO **') as Opcion, ' ' as detalle
		from SMenues mn
			inner join asp..SSistemas ss
				 on ss.SScodigo = mn.SScodigo
			inner join asp..SModulos mm
				 on mm.SScodigo = mn.SScodigo
				and mm.SMcodigo = mn.SMcodigo
		where mn.SMNnivel > 0 
		  and mn.SPcodigo is null
		  and
			(
			select count(1)
			  from APOpcionesx pm2
				inner join SMenues mn2
					on mn2.SMNcodigo = pm2.SMNcodigo
		
				  and mn2.SScodigo = mn.SScodigo
				  and mn2.SMcodigo = mn.SMcodigo
				  and mn2.SMNpath like mn.SMNpath || '%'
			where pm2.parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Parche#">
			  and pm2.tipo	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">
			) > 0
		order by mn.SScodigo, mn.SMcodigo, mn.SMNpath
		</cfif>
	</cfquery>
	<cfif rsDetalle.recordCount EQ 0>
		<cfreturn>
	</cfif>
	<table cellpadding="0" cellspacing="0" border="0" width="95%" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr class="tituloListas">
		<cfif Arguments.Tipo EQ "1">
			<td>Nuevas Opciones de Menú</td>
		<cfelseif Arguments.Tipo EQ "2">
			<td>Modificaciones en Opciones de Menú</td>
		<cfelse>
			<td>Otros Procesos</td>
		</cfif>		
			<td>Detalle</td>
			<td width="1%"></td>
		</tr>
	<cfoutput query="rsDetalle" group="SScodigo">
		<tr><td colspan="2"><strong>SISTEMA: #SSdescripcion#</strong></td></tr>
		<cfoutput group="SMcodigo">
			<cfset LvarTipoLinea = "listaNon">
			<tr><td colspan="2" style="padding-left:15px"><strong>MODULO: #SSdescripcion#</strong></td></tr>
			<cfoutput>
				<cfif LvarTipoLinea NEQ "listaNon">
					<cfset LvarTipoLinea = "listaNon">
				<cfelse>
					<cfset LvarTipoLinea = "listaPar">
				</cfif>
				<cfif SPcodigo EQ "">
					<tr class="#LvarTipoLinea#"><td colspan="2" style="padding-left:#(SMNnivel+1)*15#px"><strong>#Opcion#</strong></td></tr>
				<cfelse>
					<tr class="#LvarTipoLinea#">
						<td valign="top" style="padding-left:#(SMNnivel+1)*15#px">#Opcion#&nbsp;</td>
						<td>#Detalle# 
						Esto es una prueba de un detalle grande para ver como se ve
						</td>
						<td valign="top"><img src="../../../sif/imagenes/Borrar01_S.gif"></td>
					</tr>
				</cfif>
			</cfoutput>
		</cfoutput>
	</cfoutput>
	</table>
</cffunction>