
<!-- Establecimiento del modo -->
<cfif isdefined("form.RHUMid") and form.RHUMid NEQ ''>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfparam name="Url.fNombre" default="">
<cfparam name="Url.fCFdescripcion" default="">

<cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
	<cfinvokeargument name="PackageBaseName" value="RHMARC" />
</cfinvoke>

<cfquery name="rsProcesos" datasource="#Session.DSN#">
	select ProcessId, Name, upper(Name) as upper_name, PublicationStatus
	from WfProcess
	where WfProcess.Ecodigo = #session.Ecodigo#
	  and (PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfPackage.PackageId#">
		   and PublicationStatus = 'RELEASED'
			<cfif modo NEQ 'ALTA' and IsDefined('rsForm') and Len(rsForm.Id_tramite)>
				or ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Id_tramite#">
			</cfif>)
	order by upper_name
</cfquery>
<cfif isdefined("Url.fNombre") and not isdefined("Form.fNombre")>
	<cfset Form.fNombre = Url.fNombre>
</cfif>
<cfif isdefined("Url.fCFdescripcion") and not isdefined("Form.fCFdescripcion")>
	<cfset Form.fCFdescripcion = Url.fCFdescripcion>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0 >
	<cfset filtro = filtro & "  and upper({fn concat(rtrim(c.Pnombre),{fn concat(' ',{fn concat(rtrim(c.Papellido1),{fn concat(' ',rtrim(c.Papellido2))})})})}) like '%#Ucase(form.fNombre)#%' " >
								<!----and upper(rtrim(c.Pnombre || ' ' || rtrim(c.Papellido1 || ' ' || c.Papellido2))) like '%#Ucase(form.fNombre)#%' " >----->
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fNombre=" & Form.fNombre>
</cfif>
<cfif isdefined("form.fCFdescripcion") and len(trim(form.fCFdescripcion)) gt 0 >
	<cfset filtro = filtro & " and upper(d.CFdescripcion) like '%#Ucase(form.fCFdescripcion)#%' " >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCFdescripcion=" & Form.fCFdescripcion>
</cfif>

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select 	
			um.RHUMid
			, um.Usucodigo
			,{fn concat({fn concat({fn concat({ fn concat(Pnombre, ' ') },Papellido1)}, ' ')},Papellido2) }  as NombreUsuario	
			, um.CFid
			, cf.CFdescripcion
			, um.RHUMtmarcas
			, um.RHUMgincidencias
			, um.RHUMpjornadas
			, um.RHUMjmasiva	
			, um.RHTidtramite	
			, um.ts_rversion
		
		from RHUsuariosMarcas um
			inner join Usuario u
				on u.Usucodigo=um.Usucodigo
			
			inner join DatosPersonales dp
				on dp.datos_personales = u.datos_personales	
				
			inner join CFuncional cf
				on cf.CFid=um.CFid				
		
		where um.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and um.RHUMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHUMid#">
	</cfquery>
</cfif>

<!--- Javascript --->
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function validar(f) {
		return true;
	}

	function limpiar() {
		document.filtro.fNombre.value = "";
		document.filtro.fCFdescripcion.value   = "";
	}

	var popUpWin=0; 
	
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisUsuarios() {
		var w = 650;
		var h = 500;
		var l = (screen.width-w)/2;
		var t = (screen.height-h)/2;
		popUpWindow("ConlisUsuariosAutorizacion.cfm?form=form1&usuario=Usuario&nombre=Nombre",l,t,w,h);
	}

</script>

<!----================== TRADUCCION =================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Usuario"
	Default="Usuario"	
	returnvariable="LB_Usuario"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Centro_Funcional"
	Default="Centro Funcional"	
	returnvariable="LB_Centro_Funcional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Genera_Marcas"
	Default="Genera Marcas"	
	returnvariable="LB_Genera_Marcas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Genera_Incidencias"
	Default="Genera Incidencias"	
	returnvariable="LB_Genera_Incidencias"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Planifica_Jornadas"
	Default="Planifica Jornadas"	
	returnvariable="LB_Planifica_Jornadas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Aplicacion_Masiva"
	Default="Aplicación Masiva"	
	returnvariable="LB_Aplicacion_Masiva"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_Usuarios"
	Default="Lista de Usuarios"	
	returnvariable="LB_Lista_de_Usuarios"/>


<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top" width="60%">
			<cfoutput>
			<form style="margin: 0" name="filtro" method="post" action="Autorizacion.cfm">
				<table border="0" width="100%" class="areaFiltro">				  
				  <tr> 
					<td nowrap><strong>#LB_Usuario#</strong></td>
					<td nowrap><strong>#LB_Centro_Funcional#</strong></td>
					<td>&nbsp;</td>
				  </tr>
				  <tr> 
					<td nowrap>
						<input type="text" name="fNombre" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0 >#form.fNombre#</cfif>" size="30" maxlength="50" onFocus="javascript:this.select();" >
					</td>
					<td nowrap><input type="text" name="fCFdescripcion" value="<cfif isdefined("form.fCFdescripcion") and len(trim(form.fCFdescripcion)) gt 0 >#form.fCFdescripcion#</cfif>" size="30" maxlength="50" onFocus="javascript:this.select();" ></td>
					<td nowrap>
						<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
						<input type="button" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript:limpiar();">
						
					</td>
				  </tr>
				</table>
			  </form>	
			</cfoutput>
			<!---{fn concat({fn concat({fn concat({ fn concat(rtrim(c.Pnombre), ' ') },rtrim(c.Papellido1))}, ' ')},rtrim(c.Papellido2)) } as NombreUsuario,---->
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="RHUsuariosMarcas a, Usuario b, DatosPersonales c, CFuncional d"/>
				<cfinvokeargument name="columnas" value="a.RHUMid, 														
														 {fn concat({fn concat({fn concat({ fn concat(rtrim(c.Pnombre), ' ') },rtrim(c.Papellido1))}, ' ')},rtrim(c.Papellido2)) } as NombreUsuario,
														 {fn concat(d.CFcodigo,{fn concat('-',d.CFdescripcion)})} as centro,
														 '<img border=''0'' src=''/cfmx/rh/imagenes/' + (case a.RHUMtmarcas when 0 then 'un' else null end) + 'checked.gif''>' as GenMarcas,
														 '<img border=''0'' src=''/cfmx/rh/imagenes/' + (case a.RHUMgincidencias when 0 then 'un' else null end) + 'checked.gif''>' as GenIncidencias,
														 '<img border=''0'' src=''/cfmx/rh/imagenes/' + (case a.RHUMpjornadas when 0 then 'un' else null end) + 'checked.gif''>' as Planifica,
														 '<img border=''0'' src=''/cfmx/rh/imagenes/' + (case a.RHUMjmasiva when 0 then 'un' else null end) + 'checked.gif''>' as ApruebaMasiva,
														 b.Usucodigo,
														 d.CFid,														 
														'#Form.fNombre#' as fNombre, 
														'#Form.fCFdescripcion#' as fCFdescripcion"/>
				<cfinvokeargument name="desplegar" value="NombreUsuario, GenMarcas, GenIncidencias, Planifica,ApruebaMasiva"/>
				<cfinvokeargument name="etiquetas" value="#LB_Usuario#, #LB_Genera_Marcas#, #LB_Genera_Incidencias#, #LB_Planifica_Jornadas#, #LB_Aplicacion_Masiva#"/>
				<cfinvokeargument name="formatos" value="V,IMG,IMG,IMG,IMG"/>
				<cfinvokeargument name="filtro" value="	a.Ecodigo = #Session.Ecodigo#
														and a.Usucodigo = b.Usucodigo
														and b.CEcodigo = #Session.CEcodigo#
														and b.datos_personales = c.datos_personales
														and a.Ecodigo = d.Ecodigo
														and a.CFid = d.CFid
														#filtro#
														 order by centro, NombreUsuario
														
														"/><!--- group by b.Usucodigo--->
				<cfinvokeargument name="align" value="left, center, center, center,center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="Autorizacion.cfm"/>
				<cfinvokeargument name="keys" value="RHUMid"/>
				<cfinvokeargument name="maxRows" value="10"/>
				<cfinvokeargument name="cortes" value="centro"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
			
				
		</td>
		<td width="40%" valign="top" align="left">
			<form name="form1" method="post" action="Autorizacion-SQL.cfm" onSubmit="return validar(this);">
			  <cfoutput>  
			  <cfif modo EQ "CAMBIO">
			  	<input type="hidden" name="RHUMid" value="#Form.RHUMid#">
			  </cfif>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td nowrap>&nbsp;</td>
					<td nowrap>&nbsp;</td>
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">#LB_Usuario#:&nbsp;</td>
					<td nowrap>
						<cfif modo eq 'ALTA'>
						  <input name="Nombre" type="text" value="" tabindex="-1" readonly size="50" maxlength="180">
						  <a href="##"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_Usuarios#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisUsuarios();"></a>
						  <input type="hidden" id="Usuario" name="Usuario" value="">
						<cfelse>
							<input type="text" name="Nombre" size="50" maxlength="180" value="<cfoutput>#rsForm.NombreUsuario#</cfoutput>" style="border: none;" readonly>
							<input type="hidden" id="Usuario" name="Usuario" value="<cfif isdefined("rsForm.Usucodigo") and len(trim(rsForm.Usucodigo)) neq 0><cfoutput>#rsForm.Usucodigo#</cfoutput></cfif>">
						</cfif>
					</td>
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">#LB_Centro_Funcional#:&nbsp;</td>
					<td nowrap>
						<cfif modo eq 'ALTA'>
							<cf_rhcfuncional form="form1" size="35">
						<cfelse>
							<input type="text" name="Centro" size="50" maxlength="180" value="<cfoutput>#rsForm.CFdescripcion#</cfoutput>" style="border: none;" readonly>
							<input type="hidden" id="CFid" name="CFid" value="<cfoutput>#rsForm.CFid#</cfoutput>">
						</cfif>
					</td>
				  </tr>
				  <tr>
				  
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Tramite">Tr&aacute;mite:</cf_translate>&nbsp;</td>
					<td nowrap>
						 <select name="RHTidtramite" id="RHTidtramite">
							<option value="-1">--- <cf_translate key="LB_Ninguno">Ninguno</cf_translate> ---</option>
							<cfloop query="rsProcesos">
								<option value="#rsProcesos.ProcessId#" <cfif (MODO neq "ALTA") and (trim(rsForm.RHTidtramite) eq trim(rsProcesos.ProcessId))>selected</cfif>>
									#rsProcesos.Name#
								</option>
							</cfloop>
						</select> 
					</td>
				  </tr>				  
				  <tr>
				    <td class="fileLabel" align="right" nowrap>
						<input name="RHUMtmarcas" type="checkbox" id="RHUMtmarcas" value="1" <cfif modo EQ 'CAMBIO' and rsForm.RHUMtmarcas EQ 1> checked</cfif>>
					</td>
				    <td nowrap><cf_translate key="LB_Genera_Marcas">Genera Marcas</cf_translate></td>
			      </tr>
				  <tr>
				    <td class="fileLabel" align="right" nowrap>
						<input name="RHUMgincidencias" type="checkbox" id="RHUMgincidencias" value="1" <cfif modo EQ 'CAMBIO' and rsForm.RHUMgincidencias EQ 1> checked</cfif>>
					</td>
				    <td nowrap><cf_translate key="LB_Genera_Incidencias">Genera Incidencias</cf_translate></td>
			      </tr>
				  <tr>
                    <td class="fileLabel" align="right" nowrap>
                      <input name="RHUMpjornadas" type="checkbox" id="RHUMpjornadas" value="1" <cfif modo EQ 'CAMBIO' and rsForm.RHUMpjornadas EQ 1> checked</cfif>>
                    </td>
                    <td nowrap><cf_translate key="LB_Planificador">Planificador</cf_translate></td>
			      </tr>
				  <tr>
                    <td class="fileLabel" align="right" nowrap>
                      <input name="RHUMjmasiva" type="checkbox" id="RHUMjmasiva" value="1" <cfif modo EQ 'CAMBIO' and rsForm.RHUMjmasiva EQ 1> checked</cfif>>
                    </td>
                    <td nowrap><cf_translate key="LB_Aplicacion_Masiva">Aplicación Masiva</cf_translate></td>
			      </tr>
				  
				  <cfif modo NEQ 'CAMBIO'>
				  <tr>
                    <td class="fileLabel" align="right" nowrap>
                      <input name="subcentros" type="checkbox" id="subcentros" value="1"><!---  <cfif modo EQ 'CAMBIO' and rsForm.RHUMjmasiva EQ 1> checked</cfif>> --->
                    </td>
                    <td nowrap><cf_translate key="LB_Extension_a_subcentros_funcionales">Extención a Subcentros Funcionales</cf_translate></td>
			      </tr>
				  </cfif>
				  
				  <tr>
					<td colspan="2" nowrap>&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="2" align="center" nowrap>
						<cfinclude template="/rh/portlets/pBotones.cfm">
					</td>
				  </tr>
				  <cfset ts = "">
				  <cfif modo neq "ALTA">
					<cfinvoke 
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
					  <cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
					</cfinvoke>
				  </cfif>
				  <tr>
					<td colspan="2" nowrap>
						<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">&nbsp;
					</td>
				  </tr>
				</table>
			  </cfoutput>
			</form>
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">
	<cfif modo EQ "ALTA">		
		function habilitarValidacion() {
			objForm.Nombre.required = true;
			objForm.CFcodigo.required = true;
		}
		
		function deshabilitarValidacion() {
			objForm.Nombre.required = false;
			objForm.CFcodigo.required = false;
		}
			qFormAPI.errorColor = "#FFFFCC";
			objForm = new qForm("form1");
			objForm.Nombre.required = true;
			<cfoutput>
				objForm.Nombre.description = "#LB_Usuario#";
				objForm.CFcodigo.required = true;
				objForm.CFcodigo.description = "#LB_Centro_Funcional#";
			</cfoutput>		
	</cfif>
</script>
