<!----Submit--->
<!----CAMBIO DE COMBO--->
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
	<cfquery datasource="asp" name="modu">
		select rtrim(SScodigo) as SScodigo, rtrim(SMcodigo) as SMcodigo,
			SMdescripcion
		from SModulos
		order by SScodigo, SMdescripcion, SMcodigo
	</cfquery>

	<form height="300" width="700" id="form1" name="form1" 
		method="post" action="opcionesmenu-sql.cfm" format="#session.parche.form_format#"
		timeout="60">

			<script type="text/javascript">
				function change_ss(ss,sm,smn)
				{					
					while (sm.length>1)		{sm.length=0;}
					while (smn.length>1)	{smn.length=0;}
					<cfoutput query="modu" group="SScodigo">					
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
					while (smn.length>1)		{smn.length=0;}
					document.getElementById("ifrSMNcodigo").src="menubuscar.cfm?Opciones=LLENAR&SS=" + ss.value + "&SM=" + sm.value
				}
				function change_smn(smn)
				{
					while (smn.value == '*' && smn.selectedIndex < smn.length)
					{
						smn.selectedIndex ++;
					}
				}		
				
				function funcCambioTipo(prn_valor){
					var lblSMNcodigo = document.getElementById("lblSMNcodigo");
					var SMNcodigo = document.getElementById("SMNcodigo");
					if (prn_valor== '3'){				
						lblSMNcodigo.style.display = 'none';
						SMNcodigo.style.display = 'none';
					}				
					else{
						lblSMNcodigo.style.display = '';
						SMNcodigo.style.display = '';
					}
				}
				
				function funBorrar(prs_SScodigo,prs_SMcodigo,prs_SMNcodigo){//prs_parche,			
					location.href = 'opcionesmenu-sql.cfm?eliminar=1&SScodigo='+prs_SScodigo+'&SMCodigo='+prs_SMcodigo+'&SMNcodigo='+prs_SMNcodigo;
				}
				
				function funcValidar(){
					var msg = 'Se presentaron los siguientes errores: \n';
					var error = 0
					if (document.form1.SScodigo.value == ''){
						error = 1
						msg = msg + '- El sistema es obligatorio \n';
					}
					if (document.form1.SMcodigo.value == ''){
						error = 1
						msg = msg + '- El módulo es obligatorio \n';
					}
					if (document.form1.SMNtipo.value != 3) {
						if (document.form1.SMNcodigo.value == ''){
							error = 1
							msg = msg + '- El menú es obligatorio \n';
						}
					}		
					if (error != 0){
						alert(msg);
						return false;
					}
					
					return true;		
				}
				
			</script>					
		<cf_web_portlet_start width="700" titulo="Seleccione los sistemas, módulos y opciones de menú que desea Documentar en el Parche">
				<table>
					<cfif isdefined("url.mensaje") and len(trim(url.mensaje))>
						<cfoutput><tr><td colspan="2" align="center" style="color:##FF0000 ">***** #XMLFormat(url.mensaje)# *****</td></tr></cfoutput>
					</cfif>
					<tr>						
						<td><label for="SMNtipo">Tipo</label></td>												
						<td>
							<select name="SMNtipo" label="Opción Menú" width="350" style="width:350px" onChange="javascript: funcCambioTipo(this.value);">
								<option value="1" <cfif isdefined("url.SMNtipo") and url.SMNtipo EQ 1>selected="selected"</cfif>>Opción de Menú Nueva</option>
								<option value="2" <cfif isdefined("url.SMNtipo") and url.SMNtipo EQ 2>selected="selected"</cfif>>Opción de Menú Modificada</option>
								<option value="3" <cfif isdefined("url.SMNtipo") and url.SMNtipo EQ 3>selected="selected"</cfif>>Otros Procesos</option>
							</select>
						</td>						
					</tr>
					<tr>
						<td><label for="SScodigo">Sistema</label></td>
						<td>
							<select name="SScodigo" label="Sistema" width="350" style="width:350px"									
									selected="#url.SScodigo#" onChange="javascript: change_ss(document.form1.SScodigo,document.form1.SMcodigo,document.form1.SMNcodigo)" queryPosition="below" required="yes">
								<option value="" >- Seleccione un sistema -</option>		
								<cfoutput query="sis">
									<option value="#SScodigo#" <cfif isdefined("url.SScodigo") and url.SScodigo EQ SScodigo>selected="selected"</cfif>>#SSdescripcion#</option>
								</cfoutput> 
							</select>
						</td>
					</tr>
					<tr>
						<td><label for="SMcodigo">Módulo</label></td>
						<td>
							<select name="SMcodigo" label="Módulo" width="350" style="width:350px" onChange="javascript: change_sm(document.form1.SScodigo,document.form1.SMcodigo,document.form1.SMNcodigo)">
								<option value="" >- Seleccione un módulo -</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<div id="lblSMNcodigo" style="display:" >
								<label for="SMNcodigo">Opción de Menú</label>
							</div>	
						</td>
						<td>
							<div id="SMNcodigo" style="display:" >
								<select name="SMNcodigo" label="Opción Menú" width="350" style="width:350px" onChange="change_smn(this);">
									<option value="" >- Seleccione una opcion de menú -</option>
								</select>
							</div>
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
							<table>
								<tr>
									<td>
										<!---<cfinput type="submit" name="Submit" value="Agregar" class="btnGuardar" />--->
										<input type="submit" name="Submit" value="Agregar" class="btnGuardar" onClick="javascript: return funcValidar();">
									</td>
									<td><input name="continuar" type="button" id="continuar" value="Continuar" class="btnSiguiente" onClick="javascript: location.href = 'sqlbuscar.cfm'"/></td>
								</tr>
							</table>
						</td>
					</tr>	
				</table>
				<cfset fnDetalle('#session.parche.guid#','1')>
				<cfset fnDetalle('#session.parche.guid#','2')>
				<cfset fnDetalle('#session.parche.guid#','3')>			
		<cf_web_portlet_end>
	</form>
<cf_templatefooter>
<iframe name="ifrSMNcodigo" id="ifrSMNcodigo" width="0" height="0" frameborder="0"> 
</iframe>

<script type="text/javascript">
	change_ss(document.form1.SScodigo,document.form1.SMcodigo,document.form1.SMNcodigo)					
	<cfif isdefined("url.SMNtipo") and url.SMNtipo EQ 3>
		<cfoutput>funcCambioTipo('#url.SMNtipo#')</cfoutput>
	</cfif>	
</script>

<cffunction name="fnDetalle" output="true">
	<cfargument name="parche"	required="yes">
	<cfargument name="tipo"		required="yes">

	<cfquery name="rsDetalle" datasource="asp">
		<cfif Arguments.Tipo EQ "3">
			select pm.parche, pm.SMNcodigo, pm.SScodigo,  pm.SMcodigo, ss.SSdescripcion, mm.SMdescripcion, 'P' as SPcodigo, 0 as SMNnivel, 'PROCESO' as Opcion, pm.detalle
			  from APOpciones pm
				inner join asp..SSistemas ss
					 on ss.SScodigo = pm.SScodigo
				inner join asp..SModulos mm
					 on mm.SScodigo = pm.SScodigo
					and mm.SMcodigo = pm.SMcodigo
			  where pm.parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Parche#">
				and pm.tipo	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">
			order by pm.SScodigo, pm.SMcodigo
		<cfelse>
		select pm.parche, mn.SMNcodigo, mn.SScodigo, mn.SMcodigo, mn.SPcodigo, mn.SMNpath, ss.SSdescripcion, mm.SMdescripcion, mn.SMNtipo, mn.SMNnivel, coalesce(pp.SPdescripcion, '** PROCESO NO DEFINIDO **') as Opcion, pm.detalle
		  from APOpciones pm
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
		select '#session.parche.guid#' as  parche, mn.SMNcodigo, mn.SScodigo, mn.SMcodigo, mn.SPcodigo, mn.SMNpath, ss.SSdescripcion, mm.SMdescripcion, mn.SMNtipo, mn.SMNnivel, coalesce(mn.SMNtitulo, '** OPCION DE MENÚ NO DEFINIDO **') as Opcion, ' ' as detalle
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
			  from APOpciones pm2
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
		<tr>
		<cfif Arguments.Tipo EQ "1">
			<td bgcolor="##FFFED6"  style="font-size:12px; font-weight:bolder;" >Nuevas Opciones de Menú</td>
		<cfelseif Arguments.Tipo EQ "2">
			<td bgcolor="##FFFED6"  style="font-size:12px; font-weight:bolder;" >Modificaciones en Opciones de Menú</td>
		<cfelse>
			<td bgcolor="##FFFED6"  style="font-size:12px; font-weight:bolder;" >Otros Procesos</td>
		</cfif>		
			<td bgcolor="##FFFED6"  style="font-size:12px; font-weight:bolder;"  colspan="2">Detalle</td>
		</tr>
	<cfoutput query="rsDetalle" group="SScodigo">
		<tr><td colspan="3" style="font-size:12px; font-weight:bolder;" bgcolor="##CCCCCC"><strong>SISTEMA: #SSdescripcion#</strong></td></tr>
		<cfoutput group="SMcodigo">
			<cfset LvarTipoLinea = "listaNon">
			<tr><td colspan="3" style="padding-left:15px" class="tituloListas"><strong>MODULO: #SMdescripcion#</strong></td></tr>
			<cfoutput>
				<cfif LvarTipoLinea NEQ "listaNon">
					<cfset LvarTipoLinea = "listaNon">
				<cfelse>
					<cfset LvarTipoLinea = "listaPar">
				</cfif>
				<cfif SPcodigo EQ "">
					<tr class="#LvarTipoLinea#"><td colspan="3" style="padding-left:#(SMNnivel+1)*15#px"><strong>#Opcion#</strong></td></tr>
				<cfelse>
					<tr class="#LvarTipoLinea#">
						<td valign="top"  width="30%" style="padding-left:#(SMNnivel+1)*15#px">#Opcion#&nbsp;</td>
						<td width="60%">#Detalle# </td>
						<td valign="top" width="5%">
							<a href="javascript: funBorrar('#rsDetalle.SScodigo#','#rsDetalle.SMcodigo#','#rsDetalle.SMNcodigo#')">
								<img src="../../../sif/imagenes/Borrar01_S.gif" border="0">
							</a>
						</td>
					</tr>
				</cfif>
			</cfoutput>
		</cfoutput>
	</cfoutput>
	</table>
</cffunction>