<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DescripcionDelConcurso"
	Default="Descripci&oacute;n del Concurso"
	returnvariable="LB_DescripcionDelConcurso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CodigoDePuesto"
	Default="C&oacute;digo de Puesto"
	returnvariable="LB_CodigoDePuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"
	returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NPlazas"
	Default="N° Plazas"
	returnvariable="LB_NPlazas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaCierre"
	Default="Fecha Cierre"
	returnvariable="LB_FechaCierre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Calificacion"
	Default="Calificación"
	returnvariable="LB_Calificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte"
	Default="Reporte"
	returnvariable="LB_Reporte"/>

	
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>
<cfif isdefined("Url.RHOid") and not isdefined("Form.RHOid")>
	<cfparam name="Form.RHOid" default="#Url.RHOid#">
</cfif>

<cfif isdefined("Url.RegCon") and not isdefined("Form.RegCon")>
	<cfparam name="Form.RegCon" default="#Url.RegCon#">
</cfif>


<cfif isdefined('form.RHOid') and isdefined('form.RHPOid')> <!--- OJO con RHEOid --->
	<cfquery name="rsConcursos" datasource="#Session.DSN#">
		select RHCcodigo, RHCdescripcion, CFid,
		from RHPreparacionOferentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHPOid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPOid#"> 
		  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
	</cfquery>	

	<cfquery name="rsGradoAcadCambio" datasource="#Session.DSN#">
		select *
		from RHPreparacionOferentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHPOid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOid#">
	</cfquery>
</cfif>

<cfquery name="rsGradoAcad" datasource="#Session.DSN#">
	select GAcodigo, GAnombre, GAorden
	from GradoAcademico
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>


<cfset filtroEduc = "">
<cfset navegacionEduc = "">

<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "o=3">
<!--- FILTRO --->
<cfif isdefined("Form.fRHPOnombre") and Len(Trim(Form.fRHPOnombre)) NEQ 0>
	<cfset filtroEduc = filtroEduc & " and upper(RHPOnombre) like '%" & #UCase(Form.fRHPOnombre)# & "%'">
	<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "RHPOnombre=" & Form.fRHPOnombre>
</cfif> 
 <cfif isdefined("Form.fRHPOtitulo") and form.fRHPOtitulo GT 1>
	<cfset filtroEduc = filtroEduc & " and upper(RHPOtitulo) like '%" & #UCase (Form.fRHPOtitulo)# & "%'">
	<!--- <cfset f_tipo = "'" & Form.RHAtipoFiltro & " as RHAtipoFiltro" &  ",">		 --->
	<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "RHPOtitulo=" & Form.fRHPOtitulo>
</cfif>
 <cfif isdefined("Form.RHOid")>
	<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "RHOid=" & Form.RHOid>
</cfif> 
 <cfif isdefined("Form.sel")>
	<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	<tr>
		<td>
			<cfinclude template="/rh/portlets/pEmpleado.cfm">
		</td>
	</tr>
	<tr>
		<td>
			<table width="95%" border="0" cellspacing="0" cellpadding="0" style="margin-left: 10px; margin-right: 10px;">
				<tr> 
					<td width="10%" align="center" valign="top">
						<table width="100%" border="0" cellspacing="3" cellpadding="3">
							<tr>
								<td>
									<form style="margin: 0; " name="filtro" method="post">
										<cfoutput>
										<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
											<tr>
												<td valign="middle"><strong>#LB_Codigo#:</strong> 
													<input name="RHOid" type="hidden" value="<cfoutput>#form.RHOid#</cfoutput>">
													<input name="sel" type="hidden" value="1">
													<input type="hidden" name="o" value="4">		
													<input name="fRHCcodigo" type="text" size="6" maxlength="5" 
													align="middle" onFocus="this.select();" 
													onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"
													value="<cfif isdefined("form.fRHCcodigo")><cfoutput>#form.fRHCcodigo#</cfoutput></cfif>">
												</td>
												<td valign="middle" align="left">
													<strong>&nbsp;#LB_DescripcionDelConcurso#: &nbsp;&nbsp;</strong>
													<input name="fRHCdescripcion" type="text" size="30" maxlength="5" align="middle" onFocus="this.select();" 
													value="<cfif isdefined("form.fRHCdescripcion")><cfoutput>#form.fRHCdescripcion#</cfoutput></cfif>">
												</td>
												<td align="left" valign="middle" colspan="2">
													<strong>#LB_CodigoDePuesto	#: &nbsp;&nbsp;</strong>
													<input name="fRHPcodigo" type="text" size="10" maxlength="10" onFocus="this.select();" 
													value="<cfif isdefined("form.fRHPcodigo")><cfoutput>#form.fRHPcodigo#</cfoutput></cfif>">
												</td>
												<td colspan="4" align="center">
													<input type="submit" name="btnFiltrar" value="#BTN_Filtrar#">
													<input type="button" name="btnLimpiar" value="#BTN_Limpiar#" onClick="javascript:limpiar();">
													<input name="RHCcodigo" type="hidden" 
													value="<cfif isdefined("form.RHCcodigo")and (form.RHCcodigo GT 0)><cfoutput>#form.RHCcodigo#</cfoutput></cfif>">
													<input name="RHCconcurso" type="hidden" 
													value="<cfif isdefined("form.RHCconcurso")and (form.RHCconcurso GT 0)><cfoutput>#form.RHCconcurso#</cfoutput></cfif>">
												</td>
											</tr>
										</table>
										</cfoutput>
									</form>							
								</td>
							</tr>
							<tr>
								<td nowrap>
									<cfquery name="rsLista" datasource="#session.DSN#">
										select a.RHCPid,a.RHOid,a.RHCconcurso,b.RHCcodigo, b.RHCdescripcion , RHCfcierre, RHCcantplazas,
											   {fn concat(coalesce(c.RHPcodigoext,c.RHPcodigo),{fn concat('- ',c.RHPdescpuesto)})}  as Puesto,
											   RHCdescalifica,RHCrazondeacalifica,RHOid,DEid,RHCPpromedio as Calificacion,
											   (case when RHCdescalifica = 0 then 
											   {fn concat('<a href=''javascript: ReporteNota(',{fn concat(<cf_dbfunction name="to_char" args="a.RHCPid" >,{fn concat(',',{fn concat(<cf_dbfunction name="to_char" args="a.RHCconcurso" >,');''><img src=''/cfmx/rh/imagenes/iindex.gif'' border=''0'' title="Informe de Calificación"></a>')})})})}
												
												else 
												{fn concat('<a href=''javascript: ReporteDesc(',{fn concat(<cf_dbfunction name="to_char" args="a.RHCPid" >,{fn concat(',',{fn concat(<cf_dbfunction name="to_char" args="a.RHCconcurso" >,');''><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0'' title="Justificación de Descalificación"></a>')})})})}
												end) as Nota
												
										from RHConcursantes a  inner join RHConcursos b
											on a.Ecodigo = b.Ecodigo and 
												a.RHCconcurso = b.RHCconcurso inner join RHPuestos c
										  on a.Ecodigo = c.Ecodigo and
												b.RHPcodigo = c.RHPcodigo
										where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

										<cfif isdefined("form.fRHCcodigo") and len(trim(form.fRHCcodigo)) gt 0>

											and b.RHCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fRHCcodigo#">
										</cfif>
										<cfif isdefined("form.fRHCdescripcion") and len(trim(form.fRHCdescripcion)) gt 0>
											and upper(b.RHCdescripcion) like '%#Ucase(trim(form.fRHCdescripcion))#%'
										</cfif>
											and  RHCestado in (30,70)
										 <cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0> 
												and upper(b.RHPcodigo) like '%#Ucase(trim(form.fRHPcodigo))#%'
										</cfif> 
											and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
										order by a.RHCconcurso, RHCdescripcion
									</cfquery>
											
									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaQuery"
									 returnvariable="pListaFam">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" 
											value="RHCcodigo, RHCdescripcion, Puesto,  RHCcantplazas, RHCfcierre, Calificacion, Nota"/>
										<cfinvokeargument name="etiquetas" 
											value="#LB_Codigo#,#LB_Descripcion#, #LB_Puesto#, #LB_NPlazas# ,#LB_FechaCierre#,#LB_Calificacion#,#LB_Reporte#"/>
										<cfinvokeargument name="formatos" value="S,S,S,I,D,S,S"/>
										<cfinvokeargument name="formName" value="listaEducacion"/>	
										<cfinvokeargument name="align" value="left,left,left,center,center,right,center"/>
										<cfinvokeargument name="ajustar" value="N"/>			
										<cfinvokeargument name="keys" value="RHCconcurso"/>
										<cfinvokeargument name="irA" value=""/>		
										<cfinvokeargument name="showlink" value="false"/>
										 <cfinvokeargument name="navegacion" value="#navegacionEduc#"/>
									</cfinvoke>						
								</td>
							</tr>
						</table>
					
					<td valign="top" nowrap> 
						<form method="post" name="formPConcursos">
							<input type="hidden" name="RHOid" value="<cfoutput>#form.RHOid#</cfoutput>">
						</form>
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>
					<cfset regresa=''>
						<cfif isdefined("form.RegCon")>
							<cfset regresa ="../../Reclutamiento/catalogos/OferenteExterno.cfm?o=3&sel=1&RHOid=" & #form.RHOid# & '&TipoConcursante=E&RHCconcurso=' & #form.RHCconcurso# & "&RegCon=" & #form.RegCon#>
							
						<cfelse>
							<cfset regresa ="../../Reclutamiento/catalogos/OferenteExterno.cfm?o=3&sel=1&RHOid=" & #form.RHOid#>
						</cfif>
						<cf_botones regresar="#regresa#" exclude="Alta,Limpiar">
					</td></tr>
		<tr><td>&nbsp;</td></tr>
</table>


<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript">

function validaaingreso(year){ 
		if (year.name)
		 	p = year.value;
			
		else 
			p = year;
		p = qf(p);
			
		if (p < 1950 || p > 2080) {
			alert('El año digitado debe estar entre 1950 y 2080.');			
			eval("document.formExperienciaOferente.RHPOaingreso.value = '1950'");
			eval("document.formExperienciaOferente.RHPOaingreso.focus();");
			return false;
		}
	} 

function validaaegreso(year){ 
		if (year.name)
		 	p = year.value;
			
		else 
			p = year;
		p = qf(p);
			
		if (p < 1950 || p > 2080) {
			alert('El año digitado debe estar entre 1950 y 2080.');			
			eval("document.formExperienciaOferente.RHPOaegreso.value = '1950'");
			eval("document.formExperienciaOferente.RHPOaegreso.focus();");
			return false;
		}
	} 

//------------------------------------------------------------------------------------------
		function ReporteNota(id,concurso){
			var params ="";
				params = "?RHCPid=" + id + "&RHCconcurso=" + concurso + "&eval=true";
				popUpWindowPuestos("../Reportes/RH_infCalificaciones.cfm"+params,75,50,850,630);
			}
			
		function ReporteDesc(id,concurso){
			var params ="";
				params = "?RHCPid=" + id + "&RHCconcurso=" + concurso;
				popUpWindowPuestos("../Reportes/RH_infDescalificacion.cfm"+params,75,50,850,630);
			}
		
		var popUpWin=0;
		//Levanta el Conlis
		function popUpWindowPuestos(URLStr, left, top, width, height)
		{
			if(popUpWin)
			{
				if(!popUpWin.closed) popUpWin.close();
			}
			popUpWin = open(URLStr, 'popupWindow', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
		}

	function limpiar(){
		document.filtro.fRHCcodigo.value = '';
		document.filtro.fRHCdescripcion.value = '';
		document.filtro.fRHPcodigo.value = '';
		
	}

</script>