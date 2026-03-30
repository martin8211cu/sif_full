<cfset modo = "ALTA">

<cfif isdefined("url.f_ctrofuncional") and len(trim(url.f_ctrofuncional)) and not isdefined("form.f_ctrofuncional")>
	<cfset form.f_ctrofuncional = url.f_ctrofuncional >
</cfif>
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and not isdefined("form.CFid")>
	<cfset form.CFid = url.CFid >
</cfif>

<cfquery name="rsJornadas" datasource="#Session.DSN#">
	select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	cf.CFid, 
			cf.CFdescripcion as Centro,
			(select count(1)
			from RHPlanificador pla
			
				inner join RHJornadas jo
					on pla.RHJid = jo.RHJid
			
				inner join DatosEmpleado de
					on pla.DEid = de.DEid
				
					inner join LineaTiempo lt
						on de.DEid = lt.DEid
						and pla.RHPJfinicio between lt.LTdesde  and lt.LThasta
					
						inner join RHPlazas pl
							on lt.RHPid = pl.RHPid
							and pl.CFid =cf.CFid ) as jornadas
	from RHUsuariosMarcas um, CFuncional cf
	where  um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		and um.RHUMpjornadas = 1
		and um.CFid = cf.CFid
		<cfif isdefined("form.f_ctrofuncional") and len(trim(form.f_ctrofuncional))>
			and upper(cf.CFdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.f_ctrofuncional)#%">
		</cfif>
	order by cf.CFdescripcion
</cfquery>

<cfif isdefined("form.CFid") and len(trim(form.CFid))>
	<!---Obtener las jornadas del centro funcional---->
	<cfquery name="rsJornadasCF" datasource="#session.DSN#">
		select distinct pl.CFid,
						pla.RHPJfinicio,
						pla.RHPJffinal,
						jo.RHJdescripcion,
						jo.RHJid
		from RHPlanificador pla
		
			inner join RHJornadas jo
				on pla.RHJid = jo.RHJid
		
			inner join DatosEmpleado de
				on pla.DEid = de.DEid
			
				inner join LineaTiempo lt
					on de.DEid = lt.DEid
					and pla.RHPJfinicio between lt.LTdesde  and lt.LThasta
				
					inner join RHPlazas pl
						on lt.RHPid = pl.RHPid
						and pl.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
</cfif>

<!--- =============================================================================== --->
<!--- NAVEGACION --->
<!--- =============================================================================== --->
<!--- Variables para controlar la cantidad de items a desplegar --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfif isdefined("Form.Pagina") and Len(Trim(Form["Pagina"]))>
	<cfset PageNum_lista = Form['Pagina']>
<cfelseif isdefined("Url.Pagina") and Len(Trim(Url["Pagina"]))>
	<cfset PageNum_lista = Url['Pagina']>
<cfelseif isdefined("Form.PageNum_lista") and Len(Trim(Form["PageNum_lista"]))>
	<cfset PageNum_lista = Form['PageNum_lista']>
<cfelseif isdefined("Url.PageNum_lista") and Len(Trim(Url["PageNum_lista"]))>
	<cfset PageNum_lista = Url['PageNum_lista']>
<cfelseif isdefined("Form.PageNum") and Len(Trim(Form["PageNum"]))>
	<cfset PageNum_lista = Form['PageNum']>
<cfelseif isdefined("Url.PageNum") and Len(Trim(Url["PageNum"]))>
	<cfset PageNum_lista = Url['PageNum']>
<cfelse>
	<cfset PageNum_lista = 1>
</cfif>

<!--- si esta navegando y le da filtrar, hace q' empiece en la primera pagina  --->
<cfif isdefined("form.btn_filtrar")>
	<cfset PageNum_lista = 1>
</cfif>

<cfset MaxRows_lista = 10 >
<cfset StartRow_lista = Min((PageNum_lista-1)*MaxRows_lista+1, Max(rsDatos.RecordCount,1)) >
<cfset EndRow_lista = Min(StartRow_lista+MaxRows_lista-1, rsDatos.RecordCount)>
<cfset TotalPages_lista = Ceiling(rsDatos.RecordCount/MaxRows_lista)>

<cfset QueryString_lista = ''>
<cfif isdefined("form.f_ctrofuncional") and len(trim(form.f_ctrofuncional)) >
	<cfset QueryString_lista = "&f_ctrofuncional=#form.f_ctrofuncional#" >
</cfif>


<!--- =============================================================================== --->
<!--- =============================================================================== --->

<!--- Javascript --->
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<!----=================== TRADUCCION ======================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jornada"
	Default="Jornada"	
	returnvariable="LB_Jornada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_Inicio"
	Default="Fecha Inicio"	
	returnvariable="LB_Fecha_Inicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_Vence"
	Default="Fecha Vence"	
	returnvariable="LB_Fecha_Vence"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Debe_seleccionar_un_centro_funcional_al_menos"
	Default="Debe seleccionar un centro funcional al menos"	
	returnvariable="LB_Debe_seleccionar_un_centro_funcional_al_menos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_hay_centros_funcionales_autorizados_para_este_usuario"
	Default="No hay centros funcionales autorizados para este usuario"	
	returnvariable="LB_No_hay_centros_funcionales_autorizados_para_este_usuario"/>


<cfoutput>
<form name="form1" method="post" action="PlanificaJornadas-SQL.cfm" onSubmit="return validar(this);">
<input type="hidden" name="m" value="1">
<input type="hidden" name="CFid" value="<cfif isdefined("form.CFid") and len(trim(form.CFid))>#form.CFid#</cfif>" />			<!---Id del centro funcional seleccionado para ver empleados o jornadas---->
<input type="hidden" name="opcion" value="<cfif isdefined("form.opcion") and len(trim(form.opcion))>#form.opcion#</cfif>" />	<!---Identifica la opcion: VE--> ver empleados, VJ--> Ver jornadas---->
<input type="hidden" name="fechaInicial" value=""/>				<!---Fecha inicial del planificador para eliminar jornada---->
<input type="hidden" name="fechaFinal" value=""/>				<!---Fecha final del planificador para eliminar jornada---->
<input type="hidden" name="Jornada" value="" />					<!---Llave de la jornada seleccionada---->
<input type="hidden" name="eliminar" value=""/>					<!---Campo para indicar que se va a eliminar jornadas--->
<input type="hidden" name="pagina" value="#PageNum_lista#"/>	<!---Variable para la navegacion--->

<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td colspan="2" class="tituloListas" style=" border-bottom: 1px solid black;"><cf_translate key="LB_Seleccione_los_centros_funcionales_a_los_cuales_desea_agregar_cambio_de_jornada_por_un_periodo">Seleccione los centros funcionales a los cuales desea agregar un cambio de jornada por un periodo de tiempo</cf_translate></td>
	</tr>
	<tr>
		<td valign="top" width="60%">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="3"><strong><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></strong></td>
				</tr>
				<tr>
					<td colspan="3">
						<table width="100%" cellpadding="0" cellspacing="0"><tr>
							<td width="3%">&nbsp;</td>
					  	  <td width="70%"><input type="text" name="f_ctrofuncional" value="<cfif isdefined("form.f_ctrofuncional") and len(trim(form.f_ctrofuncional))><cfoutput>#form.f_ctrofuncional#</cfoutput></cfif>" tabindex="1" size="55"/></td>
						  	<td width="27%"><input type="submit" name="btn_filtrar" value="Filtrar" onclick="javascript: document.form1.action=''; document.form1.opcion.value = 'VJ'; deshabilitarValidacion();"/></td>
						</tr></table>
					</td>
				</tr>
				</cfoutput>				
				<cfif rsDatos.RecordCount NEQ 0>
					<cfoutput query="rsDatos" startrow="#StartRow_lista#" maxrows="#MaxRows_lista#">
						<tr class="<cfif rsDatos.currentRow mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaParSel';" onmouseout="<cfif rsDatos.currentrow mod 2>this.className='listaPar';<cfelse>this.className='listaNon';</cfif>"  style="cursor:pointer;">
						  	<td width="4%"><input type="checkbox" name="chk" value="#rsDatos.CFid#"/></td>
						  	<td width="91%" onclick="javascript: funcEmpleadosCF(#rsDatos.CFid#)">#rsDatos.Centro#</td>
						  	<td width="5%">
						  		<cfif rsDatos.jornadas GT 0>
									<img src="/cfmx/rh/imagenes/iindex.gif" onclick="javascript: funcDetalles(#rsDatos.CFid#)"/>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</tr>
						<cfif isdefined("rsJornadasCF") and  isdefined("form.CFid") and len(trim(form.CFid)) and form.CFid EQ rsDatos.CFid and rsJornadasCF.RecordCount NEQ 0 and isdefined("form.opcion") and form.opcion EQ 'VJ'>
							<tr>
								<td>&nbsp;</td>
								<td colspan="2">
									<table width="100%" cellpadding="0" cellspacing="0">
										<cfloop query="rsJornadasCF">
											<tr>										
												<td width="5%">&nbsp;</td>
												<td width="40%" >#rsJornadasCF.RHJdescripcion#</td>
												<td width="20%">#LSDateFormat(rsJornadasCF.RHPJfinicio,'dd/mm/yyyy')#</td>
												<td width="20%">#LSDateFormat(rsJornadasCF.RHPJffinal,'dd/mm/yyyy')#</td>
												<td style="cursor:pointer"><img src="/cfmx/rh/imagenes/Borrar01_S.gif" onclick="javascript: funcEliminar(#rsJornadasCF.CFid#,'#rsJornadasCF.RHPJfinicio#','#rsJornadasCF.RHPJffinal#',#rsJornadasCF.RHJid#);"/></td>										
											</tr>
										</cfloop>
									</table>
								</td>
							</tr>
						</cfif>		
					</cfoutput>
					<cfoutput>
					<tr> 
						  <td colspan="5" align="center" >
							<cfif PageNum_lista GT 1>
							  <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/First.gif" border=0></a> 
							</cfif>
							<cfif PageNum_lista GT 1>
							  <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a> 
							</cfif>
							<cfif PageNum_lista LT TotalPages_lista>
							  <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a> 
							</cfif>
							<cfif PageNum_lista LT TotalPages_lista>
							  <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a> 
							</cfif> 
						</td>
						</tr>
					</cfoutput>	
				<cfelse>
					<tr><td colspan="3" align="center"><strong>----- <cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros </cf_translate>-----</strong></td></tr>
				</cfif> 
			</table>
			<!----
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="RHUsuariosMarcas um, CFuncional cf"/>
				<cfinvokeargument name="columnas" value="cf.CFid, cf.CFdescripcion as Centro"/>
				<cfinvokeargument name="desplegar" value="Centro"/>
				<cfinvokeargument name="etiquetas" value="Centro Funcional"/>
				<cfinvokeargument name="formatos" value="V"/>
				<cfinvokeargument name="filtro" value=" um.Usucodigo = #Session.Usucodigo#
														and um.RHUMpjornadas = 1
														and um.CFid = cf.CFid
														order by cf.CFdescripcion"/>
				<cfinvokeargument name="align" value="left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="irA" value="PlanificaJornadas.cfm"/>
				<cfinvokeargument name="formName" value="form1"/>
				<cfinvokeargument name="keys" value="CFid"/>
				<cfinvokeargument name="maxRows" value="0"/>
				<cfinvokeargument name="incluyeForm" value="false"/>
				<cfinvokeargument name="PageIndex" value="1"/>
			</cfinvoke>
			---->
		</td>
		<cfoutput>		
		<td width="40%" valign="top" align="left">
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td align="right" nowrap class="fileLabel">#LB_Jornada#:</td>
					<td nowrap>
						<select name="RHJid">
						<cfloop query="rsJornadas">
							<option value="#RHJid#">#Descripcion#</option>
						</cfloop>
						</select>
					</td>
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">#LB_Fecha_Inicio#:</td>
					<td nowrap>
						<cf_sifcalendario form="form1" name="RHPJfinicio">
					</td>
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">#LB_Fecha_Vence#:</td>
					<td nowrap>
						<cf_sifcalendario form="form1" name="RHPJffinal">
					</td>
				  </tr>
				  <tr>
					<td nowrap>&nbsp;</td>
					<td valign="top" nowrap>&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="2" align="center" nowrap>
						<cfinclude template="/rh/portlets/pBotones.cfm">
					</td>
				  </tr>
				</table>
		</td>
		</cfoutput>
	</tr>
	<tr>
	  <td colspan="2" valign="top">&nbsp;</td>
    </tr>
</table>
</form>

<script language="JavaScript1.2" type="text/javascript">
	var vb_validaCfuncional = true; //Variable para indicar si se valida que se haya ingresado el centro funcional

	function habilitarValidacion() {
		objForm.RHJid.required = true;
		objForm.RHPJfinicio.required = true;
		objForm.RHPJffinal.required = true;
	}
	
	function deshabilitarValidacion() {
		objForm.RHJid.required = false;
		objForm.RHPJfinicio.required = false;
		objForm.RHPJffinal.required = false;
		vb_validaCfuncional = false;
	}
	
	function validar(f) {
		<cfoutput>
		if (vb_validaCfuncional){
			if (document.form1.chk) {
				if (document.form1.chk.value) {
					if (!document.form1.chk.checked) {
						alert('#LB_Debe_seleccionar_un_centro_funcional_al_menos#');
						return false;
					}
				} else {
					for (var i=0; i<document.form1.chk.length; i++) {
						if (document.form1.chk[i].checked) {
							return true;
						}
					}
					alert('#LB_Debe_seleccionar_un_centro_funcional_al_menos#');
					return false;
				}
			} else {
				alert('#LB_No_hay_centros_funcionales_autorizados_para_este_usuario#');
				return false;
			}
		}	
		</cfoutput>
	}
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.RHJid.required = true;
		objForm.RHJid.description = "#LB_Jornada#";
		objForm.RHPJfinicio.required = true;
		objForm.RHPJfinicio.description = "#LB_Fecha_Inicio#";
		objForm.RHPJffinal.required = true;
		objForm.RHPJffinal.description = "#LB_Fecha_Vence#";
	</cfoutput>	
	function funcDetalles(prn_CFid){
		vb_validaCfuncional = false;
		document.form1.CFid.value = prn_CFid;	
		document.form1.opcion.value = 'VJ';		
		document.form1.action = '';			
		document.form1.submit();
	}
	
	//Funcion para eliminar jornadas a funcionarios del centro funcional seleccionado
	function funcEliminar(prn_CFid,prd_fechainicial, prd_fechafinal, pr_RHJid){
		document.form1.fechaInicial.value = prd_fechainicial;
		document.form1.fechaFinal.value = prd_fechafinal;
		document.form1.Jornada.value = pr_RHJid;
		document.form1.eliminar.value = 'eliminar';
		document.form1.submit();	
	}
	
	//Funcion para cargar los empleados del centro funcional seleccionado
	function funcEmpleadosCF(prn_CFid){
		document.form1.CFid.value = prn_CFid;	
		document.form1.opcion.value = 'VE';	
		document.form1.action = 'PlanificaJornadas.cfm';
		document.form1.submit();
	}
</script>

