<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset form.DEid = url.DEid>
</cfif>
<cfif isdefined("url.tab") and len(trim(url.tab))>
	<cfset form.tab = url.tab>
</cfif> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Programar curso adicional</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body onUnload="javascript: window.opener.document.location.href ='expediente.cfm?<cfoutput>DEid=#form.DEid#&tab=#form.tab#</cfoutput>';">
<cf_templatecss>
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset form.DEid = url.DEid>
</cfif>
<cfif isdefined("url.cf") and len(trim(url.cf))>
	<cfset form.cf = url.cf>
</cfif>
<cfif isdefined("url.puesto") and len(trim(url.puesto))>
	<cfset form.puesto = url.puesto>
</cfif>
<cfset modoCCursos= "ALTA">
<cfif isdefined("form.RHPCid") and len(trim(form.RHPCid))>
	<cfset modoCCursos = "CAMBIO">
</cfif>
<cfif modoCCursos neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select 	RHPCid, RHCid, RHACid, RHIAid, Mcodigo, 
				RHPCfdesde, RHPCfhasta,ts_rversion
		from RHProgramacionCursos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCid#">
	</cfquery>
</cfif>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//-->
</script>
<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>		
<cf_web_portlet_start border="true" titulo="<font size='2'>Programaci&oacute;n de cursos adicionales</font>" skin="#Session.Preferences.Skin#">
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<!----<tr><td align="center" colspan="2" bgcolor="##CCCCCC" style=" font-size:14px"><strong>Programaci&oacute;n de cursos adicionales</strong></td></tr>---->
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td valign="top">			
				<cfquery name="rsListaCP" datasource="#session.DSN#">					
					select  b.Msiglas as Msiglas, b.Mnombre as Mnombre, a.RHPCfdesde as inicio, a.RHPCfhasta as fin, d.RHIAcodigo,
							a.RHPCid,
							a.Mcodigo,							
							'#form.DEid#' as DEid,
							'#form.tab#' as tab	,
							'#form.puesto#' as puesto,
							'#form.cf#' as cf		
							
					from RHProgramacionCursos a
					
						inner join RHMateria b
							on b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							and a.Mcodigo = b.Mcodigo
							<!----and b.Mcodigo not in (select  a.Mcodigo 
													from RHMateriasGrupo  a
													
														inner join RHGrupoMaterias b
															on a.RHGMid = b.RHGMid
															and a.Ecodigo = b.Ecodigo
													
														inner join RHGrupoMateriaCF c
															on b.RHGMid = c.RHGMid
															and b.Ecodigo = c.Ecodigo
															and c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cf#">
													
													where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
													)
							and b.Mcodigo not in(	select  a.Mcodigo 
													from RHMateriasGrupo  a
													
														inner join RHGrupoMaterias b
															on a.RHGMid = b.RHGMid
															and a.Ecodigo = b.Ecodigo
													
														inner join RHPuestos c
															on b.RHGMid = c.RHGMid
															and b.Ecodigo = c.Ecodigo
															and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.puesto#">													 
													where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
												)
							----->			
							
								left join RHInstitucionesA d
									on a.Ecodigo = d.Ecodigo
									and  a.RHIAid = d.RHIAid
					
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						and a.RHCid is null
				
					union
		
					select   b.RHCcodigo as Msiglas, b.RHCnombre as Mnombre , RHPCfdesde as inicio, RHPCfhasta as fin, d.RHIAcodigo,
							a.RHPCid,
							a.Mcodigo,							
							'#form.DEid#' as DEid,
							'#form.tab#' as tab,
							'#form.puesto#' as puesto,
							'#form.cf#' as cf		
					from RHProgramacionCursos a
					
						inner join RHCursos b
							on a.RHCid = b.RHCid
		
							inner join RHMateria e
								on e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
								and b.Mcodigo = e.Mcodigo
		
							left join RHInstitucionesA d
								on b.Ecodigo = d.Ecodigo
								and  b.RHIAid = d.RHIAid
							
					
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						and a.RHCid is not  null

					Order by 4 desc, 5
				</cfquery>
				
				<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsListaCP#"/>
					<cfinvokeargument name="desplegar" value="Mnombre,RHIAcodigo,inicio,fin"/>
					<cfinvokeargument name="etiquetas" value="Curso,Instituci&oacute;n, Desde, Hasta"/>
					<cfinvokeargument name="formatos" value="V,V,D,D"/>
					<cfinvokeargument name="align" value="left,left,left,left"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="irA" value="curProgramados-form.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="RHPCid"/>
					<cfinvokeargument name="formName" value="formCProgLista"/>
					<cfinvokeargument name="PageIndex" value="8"/>
				</cfinvoke>			
			</td>
			<td width="50%">
				<form name="formCCursos" action="curProgramados-sql.cfm" method="post">
					<table width="100%" cellpadding="2" cellspacing="0">
						<input type="hidden" name="DEid" value="#form.DEid#">
						<input type="hidden" name="tab" value="#form.tab#">	
						<input type="hidden" name="puesto" value="#form.puesto#">	
						<input type="hidden" name="cf" value="#form.cf#">				
						<tr>
							<td align="right"><strong>Curso:</strong></td>
							<td>
								<cfif modoCCursos NEQ 'ALTA'>
									<cf_materias conexion="#session.DSN#" form="formCCursos" idquery="#data.Mcodigo#">					
								<cfelse>
									<cf_materias conexion="#session.DSN#" form="formCCursos">
								</cfif>
							</td>
						</tr>
						<tr>
							<td align="right"><strong>Desde:&nbsp;</strong></td>
							<td>
								<table cellpadding="0" cellspacing="0">
									<tr>			
										<td>
											<cfif modoCCursos neq 'ALTA'>
												<cf_sifcalendario conexion="#session.DSN#" form="formCCursos" name="RHPCfdesde" value="#LSDateformat(data.RHPCfdesde,'dd/mm/yyyy')#">
											<cfelse>
												<cf_sifcalendario conexion="#session.DSN#" form="formCCursos" name="RHPCfdesde" value="">
											</cfif>
										</td>
										<td width="1">&nbsp;</td>
										<td align="right"><strong>Hasta:&nbsp;</strong></td>
										<td>
											<cfif modoCCursos neq 'ALTA'>
												<cf_sifcalendario conexion="#session.DSN#" form="formCCursos" name="RHPCfhasta" value="#LSDateFormat(data.RHPCfhasta,'dd/mm/yyyy')#">
											<cfelse>
												<cf_sifcalendario conexion="#session.DSN#" form="formCCursos" name="RHPCfhasta" value="">
											</cfif>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<!--- Botones --->
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td colspan="2" align="center">
						<cfif modoCCursos eq 'ALTA'>
							<input type="submit" name="AltaCur" value="Agregar" onClick="javascript: habilitarValidacion();">
							<input type="reset" name="Limpiar" value="Limpiar">
						<cfelse>
							<input type="submit" name="CambioCur" value="Modificar" onClick="habilitarValidacion();">
							<input type="submit" name="BajaCur" value="Eliminar" onClick="if ( confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;">
							<input type="submit" name="NuevoCur" value="Nuevo" onClick="deshabilitarValidacion();">
						</cfif>
						</td></tr>
						<tr><td colspan="2">&nbsp;</td></tr>
					</table>
					<cfif modoCCursos neq 'ALTA'>
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
							<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
						</cfinvoke>
						<input type="hidden" name="ts_rversion" value="#ts#">
						<input type="hidden" name="RHPCid" value="#data.RHPCid#">
					</cfif>
				</form>
			</td>
		</tr>
		<tr><td colspan="2" align="center"><input type="button" name="btnCerrar" value="Cerrar" onClick="javascript: window.close()"></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>
<cf_web_portlet_end>

<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm8 = new qForm("formCCursos");

	objForm8.RHPCfdesde.required = true;
	objForm8.RHPCfdesde.description="Fecha de inicio";				
	objForm8.RHPCfhasta.required= true;
	objForm8.RHPCfhasta.description="Fecha hasta";	
	objForm8.Mcodigo.required= true;
	objForm8.Mcodigo.description="Materia";	

	function habilitarValidacion(){
		objForm8.RHPCfdesde.required = true;
		objForm8.RHPCfhasta.required= true;
		objForm8.Mcodigo.required= true;
	}

	function deshabilitarValidacion(){
		objForm8.RHPCfdesde.required = false;
		objForm8.RHPCfhasta.required= false;
		objForm8.Mcodigo.required= false;
	}		
</script>
</body>
</html>