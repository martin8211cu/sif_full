
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	<cf_templatearea name="body">
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			
			<!---  Variabla de la llave cuando viene del sql--->
			<cfif isdefined("url.PRcodigo") and len(trim(url.PRcodigo)) and not isdefined("form.PRcodigo")>
				<cfset form.PRcodigo = url.PRcodigo>	
			</cfif>
			<!--- variable de pagina cuando viene del sql--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>	
							
			<!--- variables de filtros para cuando viene de SQL --->
			<cfif isdefined("url.Filtro_Ndescripcion") and len(trim(url.Filtro_Ndescripcion))>
				<cfset form.Filtro_Ndescripcion = url.Filtro_Ndescripcion>
			</cfif>
			<cfif isdefined("url.Filtro_Gdescripcion") and len(trim(url.Filtro_Gdescripcion))>
				<cfset form.Filtro_Gdescripcion = url.Filtro_Gdescripcion>
			</cfif>
			<cfif isdefined("url.Filtro_PRdescripcion") and len(trim(url.Filtro_PRdescripcion))>
				<cfset form.Filtro_PRdescripcion = url.Filtro_PRdescripcion>
			</cfif>	
			<cfif isdefined("url.Filtro_PRano") and len(trim(url.Filtro_PRano))>
				<cfset form.Filtro_PRano = url.Filtro_PRano>
			</cfif>	
			<cfif isdefined("url.Filtro_PRactivo") and len(trim(url.Filtro_PRactivo))>
				<cfset form.Filtro_PRactivo = url.Filtro_PRactivo>
			</cfif>	
			<!--- Valores por defecto de las variables requeridas por que siempre se usan en el form para ser enviadas al SQL--->
			<cfparam name="form.Pagina" default="1">					
			<cfparam name="form.Filtro_Ndescripcion" default="">
			<cfparam name="form.Filtro_Gdescripcion" default="">
			<cfparam name="form.Filtro_PRdescripcion" default="">
			<cfparam name="form.Filtro_PRano" default="0">
			<cfparam name="form.Filtro_PRactivo" default="">
							
			<!--- Define el Modo --->
			<cfset modo = "ALTA">
			<cfif isdefined("form.PRcodigo") and len(trim(form.PRcodigo))>
				<cfset modo = "CAMBIO">	
			</cfif>
			
			<!--- Consultas  --->
			<cfif modo EQ "CAMBIO" >
				<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
					Select convert(varchar,PRcodigo) as PRcodigo,convert(varchar,Gcodigo) as Gcodigo,convert(varchar,Ncodigo) as Ncodigo,convert(varchar,PRano) as PRano,convert(varchar,PEcodigo) as PEcodigo,convert(varchar,SPEcodigo) as SPEcodigo,PRdescripcion
					from Promocion
					where PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRcodigo#">
				</cfquery>	
				<cfquery datasource="#Session.Edu.DSN#" name="rsPromo">
					Select count(*) as CantAsoc
					from Promocion a, Alumnos b
					where a.PRcodigo=#rsForm.PRcodigo#
					and a.PRcodigo=b.PRcodigo		
				</cfquery>				
			</cfif>
		
			<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
				select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				order by Norden
			</cfquery>	
			
			<cfquery datasource="#Session.Edu.DSN#" name="rsSubPerEscolar">
				select (convert(varchar,a.Ncodigo) + '|' + convert(varchar,c.SPEcodigo)) as Cod, a.PEdescripcion + ' : ' + c.SPEdescripcion as SPEdescripcion
				from PeriodoEscolar a, Nivel b, SubPeriodoEscolar c
				where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ncodigo=b.Ncodigo
				and a.PEcodigo = c.PEcodigo
				order by b.Norden, a.PEorden, c.SPEorden desc
			</cfquery>
			
			<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
				select convert(varchar, b.Ncodigo)
					   + '|' + convert(varchar, b.Gcodigo) as Codigo, 
					   b.Gdescripcion
				from Nivel a, Grado b
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ncodigo = b.Ncodigo 
				order by a.Norden, b.Gorden
			</cfquery>
			
		<!--- Scrips --->	
			<script language="JavaScript" type="text/javascript">
				gradostext = new Array();
				grados = new Array();
				niveles = new Array();
				SubPerEscolarText = new Array();
				SubPerEscolar = new Array();
				nivelesSubPer = new Array();
					
				// Esta función únicamente debe ejecutarlo una vez
				function obtenerSubPerEscolar(f) {
					for(i=0; i<f.SPEcodigo.length; i++) {
						var Per = f.SPEcodigo.options[i].value.split("|");
						// Códigos de los detalles
						nivelesSubPer[i]= Per[0];
						SubPerEscolar[i] = Per[1];
						SubPerEscolarText[i] = f.SPEcodigo.options[i].text;
					}
				}
				
				function cargarSubPerEscolar(csource, ctarget, vdefault, t){
					// Limpiar Combo
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var k = csource.value;
					var j = 0;
		
					for (var i=0; i<SubPerEscolar.length; i++) {
						if (nivelesSubPer[i] == k) {
							nuevaOpcion = new Option(SubPerEscolarText[i],SubPerEscolar[i]);
							ctarget.options[j]=nuevaOpcion;
							if (vdefault != null && SubPerEscolar[i] == vdefault) {
								ctarget.selectedIndex = j;
							}
							j++;
						}
					}
				}		
		
				function obtenerGrados(f) {
					for(i=0; i<f.Gcodigo.length; i++) {
						var s = f.Gcodigo.options[i].value.split("|");
						// Códigos de los detalles
						niveles[i]= s[0];
						grados[i] = s[1];
						gradostext[i] = f.Gcodigo.options[i].text;
					}
				}
				
				function cargarGrados(csource, ctarget, vdefault, t){
					// Limpiar Combo
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var k = csource.value;
					var j = 0;
		
					for (var i=0; i<grados.length; i++) {
						if (niveles[i] == k) {
							nuevaOpcion = new Option(gradostext[i],grados[i]);
							ctarget.options[j]=nuevaOpcion;
							if (vdefault != null && grados[i] == vdefault) {
								ctarget.selectedIndex = j;
							}
							j++;
						}
					}
				}
			</script>
			
		<!--- --------------------------------------------------------- --->	

			
			<form name="formPromociones" method="post" action="SQLPromociones.cfm">
				<input name="PRcodigo" type="hidden" value="<cfif modo EQ "CAMBIO"><cfoutput>#rsForm.PRcodigo#</cfoutput></cfif>">
				<input name="HayDependencias" type="hidden" value="<cfif modo EQ "CAMBIO"><cfoutput>#rsPromo.CantAsoc#</cfoutput><cfelse>0</cfif>">	
				<input name="Pagina" type="hidden" value="<cfoutput>#form.Pagina#</cfoutput>"/>
				<input name="Filtro_Ndescripcion" type="hidden" value="<cfoutput>#form.Filtro_Ndescripcion#</cfoutput>"/>
				<input name="Filtro_Gdescripcion" type="hidden" value="<cfoutput>#form.Filtro_Gdescripcion#</cfoutput>"/>
				<input name="Filtro_PRdescripcion" type="hidden" value="<cfoutput>#form.Filtro_PRdescripcion#</cfoutput>"/>
				<input name="Filtro_PRano" type="hidden" value="<cfoutput>#form.Filtro_PRano#</cfoutput>"/>
				<input name="Filtro_PRactivo" type="hidden" value="<cfoutput>#form.Filtro_PRactivo#</cfoutput>"/>
					
				  <table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr> 
					  <td colspan="2" nowrap class="tituloAlterno"> 
						<cfif modo EQ 'CAMBIO'>
						  Modificaci&oacute;n de Promoci&oacute;n 
						  <cfelse>
						  Ingreso de Promoci&oacute;n 
						</cfif>
					  </td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<!--- <td nowrap align="right">A&ntilde;o*:&nbsp;</td> --->
						<td width="40%" nowrap align="right">A&ntilde;o:&nbsp;</td>
						<td width="60%" nowrap> 
							<input name="PRano" type="text" id="PRano" tabindex="3" size="6" maxlength="4" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.PRano#</cfoutput></cfif>" style="text-align: right;" onBlur="javascript:fm(this,-1) "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">
						</td>
					</tr>
					
					<tr> 
					  <td nowrap align="right">Nivel:&nbsp;</td>
					  <td nowrap> 
						<select name="Ncodigo" id="Ncodigo" tabindex="5" onChange="javascript: cargarSubPerEscolar(this, this.form.SPEcodigo, '<cfif isdefined("Form.SPEcodigo")><cfoutput>#Form.SPEcodigo#</cfoutput></cfif>', true); cargarGrados(this, this.form.Gcodigo, '<cfif isdefined("Form.Gcodigo")><cfoutput>#Form.Gcodigo#</cfoutput></cfif>', true); ">
						  <cfoutput query="rsNiveles"> 
							<option value="#Ncodigo#" <cfif modo EQ "CAMBIO" and (rsForm.Ncodigo EQ rsNiveles.Ncodigo)>selected</cfif>>#Ndescripcion#</option>
						  </cfoutput> 
						</select>
					  </td>
					</tr>
					
					<tr>
					  <td nowrap align="right">Grado:&nbsp;</td>
					  <td nowrap> 
						<select name="Gcodigo" id="select2" tabindex="5">
						  <cfoutput query="rsGrado"> 
							<option value="#Codigo#">#Gdescripcion#</option>
						  </cfoutput> 
						</select>
					  </td>
					</tr>
					
					<tr> 
					  <td  nowrap align="right">Curso lectivo:&nbsp;</td>
					  <td  nowrap> 
						<select name="SPEcodigo" id="SPEcodigo">
						  <cfoutput query="rsSubPerEscolar"> 
							<option value="#Cod#">#SPEdescripcion#</option>
						  </cfoutput> 
						</select>
					  </td>
					</tr>
					<tr> 
					  <td nowrap align="right">Descripci&oacute;n:&nbsp;</td>
					  <td  nowrap> 
						<input name="PRdescripcion" type="text" id="PRdescripcion" value="<cfif modo EQ "CAMBIO"><cfoutput>#rsForm.PRdescripcion#</cfoutput></cfif>" size="80" maxlength="80">
					  </td>
					</tr>
					<tr>
						<td colspan="2" align="center" valign="top" nowrap> 
							<cf_botones modo="#modo#" include="Lista">
						  </td>
					 </tr> 
				  </table>
			</form>

<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script> 

			<cf_qforms form="formPromociones" objForm="objForm">
			<script language="JavaScript" type="text/javascript" >
			//------------------------------------------------------------------------------------------						
				//Para los tipos de cursos lectivos
				obtenerSubPerEscolar(document.formPromociones);
				cargarSubPerEscolar(document.formPromociones.Ncodigo, document.formPromociones.SPEcodigo, '<cfif modo EQ "CAMBIO"><cfoutput>#rsForm.SPEcodigo#</cfoutput></cfif>', true);	
				
				//Para los grados
				obtenerGrados(document.formPromociones);
				cargarGrados(document.formPromociones.Ncodigo, document.formPromociones.Gcodigo, '<cfif modo EQ "CAMBIO"><cfoutput>#rsForm.Gcodigo#</cfoutput></cfif>', true);
			//------------------------------------------------------------------------------------------						
				function deshabilitarValidacion() {
					objForm.PRano.required = false;
					objForm.Ncodigo.required = false;	
					objForm.Gcodigo.required = false;
					objForm.SPEcodigo.required = false;
					objForm.PRdescripcion.required = false;
				}
				
			//------------------------------------------------------------------------------------------						
				function habilitarValidacion() {
					objForm.PRano.required = true;
					objForm.Ncodigo.required = true;	
					objForm.Gcodigo.required = true;
					objForm.SPEcodigo.required = true;
					objForm.PRdescripcion.required = true;
				}
			//------------------------------------------------------------------------------------------							
				function funcAlta() {
					habilitarValidacion();
				}
				function funcCambio() {
					habilitarValidacion();
				}
				function funcBaja() {
					deshabilitarValidacion();
				}	
			//------------------------------------------------------------------------------------------							
				function __isTieneDependencias() {
					if (btnSelected("btnBorrar")) {
						// Valida que el Grado no tenga dependencias con otros.
						var msg = "";
						//alert(new Number(this.obj.form.HayHorarioGuia.value)); 
						if (new Number(this.obj.form.HayDependencias.value) > 0) {
							msg = msg + this.obj.form.HayDependencias.value + " alumno (s)"
						}
						if (msg != ""){
							this.error = "Usted no puede eliminar la promoción '" + this.obj.form.PRdescripcion.value + "' porque ésta tiene asociado (s): " + msg + ", si todavía desea borrarla, borre primero las asociaciones";
							this.obj.form.PRdescripcion.focus();
						}
					}
				}
				
				function funcLista() {
					<cfset ParamPRcodigo = "">
					<cfif isdefined("form.PRcodigo") and len(trim(form.PRcodigo))>
						<cfset ParamPRcodigo = "&PRcodigo="&form.PRcodigo>
					</cfif>
					<cfset params= "&HFiltro_Ndescripcion="&Form.Filtro_Ndescripcion&"&HFiltro_Gdescripcion="&Form.Filtro_Gdescripcion&"&HFiltro_PRdescripcion="&Form.Filtro_PRdescripcion&"&HFiltro_PRano="&Form.Filtro_PRano&"&HFiltro_PRactivo="&Form.Filtro_PRactivo>
					location.href = "promociones.cfm?PageNum_Lista=<cfoutput>#form.Pagina#</cfoutput>&Filtro_Ndescripcion=<cfoutput>#Form.Filtro_Ndescripcion#</cfoutput>&Filtro_Gdescripcion=<cfoutput>#Form.Filtro_Gdescripcion#</cfoutput>&Filtro_PRdescripcion=<cfoutput>#Form.Filtro_PRdescripcion#</cfoutput>&Filtro_PRano=<cfoutput>#Form.Filtro_PRano#</cfoutput>&Filtro_PRactivo=<cfoutput>#Form.Filtro_PRactivo##ParamPRcodigo##params#</cfoutput>";
					return false;
				}	
			//------------------------------------------------------------------------------------------						
				
				_addValidator("isTieneDependencias", __isTieneDependencias);
			
			//------------------------------------------------------------------------------------------					
				objForm.PRano.required = true;
				objForm.PRano.description = "año";
				objForm.Gcodigo.required = true;
				objForm.Gcodigo.description = "grado";	
				objForm.Ncodigo.required = true;
				objForm.Ncodigo.description = "nivel";	
				objForm.SPEcodigo.required = true;
				objForm.SPEcodigo.description = "Curso lectivo";		
				objForm.PRdescripcion.required = true;
				objForm.PRdescripcion.description = "Descripción";		
				objForm.PRcodigo.validateTieneDependencias();
				
			</script>

		</cf_web_portlet>
	</cf_templatearea>
</cf_template>