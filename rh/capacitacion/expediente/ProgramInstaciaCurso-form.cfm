<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset form.DEid = url.DEid>
</cfif>
<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo))>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>
<cfif isdefined("url.tab") and len(trim(url.tab))>
	<cfset form.tab = url.tab>
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Programar curso</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<cfif isdefined("url.auto")>
	<body onUnload="javascript: window.opener.document.location.href ='/cfmx/rh/capacitacion/operacion/automatricula/pantalla.cfm?<cfoutput>DEid=#form.DEid#</cfoutput>';">
<cfelse>
	<body onUnload="javascript: window.opener.document.location.href ='expediente.cfm?<cfoutput>DEid=#form.DEid#&tab=#form.tab#</cfoutput>';">
</cfif>

<cf_templatecss>

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

<script type="text/javascript">
	 var popUpWin2 = 0;
	 function popUpWindow2(URLStr, left, top, width, height){
	  if(popUpWin2){
	   if(!popUpWin2.closed) popUpWin2.close();
	  }
	  popUpWin2 = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	 }
	 
	 function doConlisRHCursos(index,parMcodigo){	 	
		popUpWindow2("conlisRHCursos.cfm?formulario=formCCursos&index="+index+"&Mcodigo="+parMcodigo,120,150,750,400);
	 }
	
	function traerCurso(RHCcodigo,index){		
		if (trim(RHCcodigo)!=''){	   		
			document.getElementById("fr").src = 'conlisRHCursos-query.cfm?formulario=formCCursos&RHCcodigo='+RHCcodigo+'&index='+index;
		}
		else{
			document.formCCursos.Mcodigo1.value = '';
			document.formCCursos.RHCid1.value = '';
			document.formCCursos.RHIAid1.value = '';
			document.formCCursos.RHCcodigo1.value = '';
			document.formCCursos.RHCnombre1.value = '';
			document.formCCursos.RHCfdesde1.value = '';
			document.formCCursos.RHCfhasta1.value = '';
		}
	}
</script>
<cf_web_portlet_start border="true" titulo="<font size='2'>Programaci&oacute;n de cursos</font>" skin="#Session.Preferences.Skin#">
<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<!----<tr><td align="center" colspan="2" bgcolor="##CCCCCC" style=" font-size:14px"><strong>Programaci&oacute;n de cursos</strong></td></tr>--->
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td valign="top">			
		<cfquery name="rsListaCP" datasource="#session.DSN#">					
				select  case when b.RHCnombre is null then '<cf_translate key="MSG_No_especificada">No especificada</cf_translate>' else  d.Mnombre end as Mnombre,
						case when e.RHACdescripcion is null then '<cf_translate key="MSG_No_especificada">No especificada</cf_translate>' else e.RHACdescripcion end as RHACdescripcion,
						case f.RHIAcodigo when null then '<cf_translate key="MSG_No_especificada">No especificada</cf_translate>' else f.RHIAcodigo end as RHIAcodigo ,
						b.RHCfdesde as fdesde,
						b.RHCfhasta	as fhasta,
						<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
							'#form.Mcodigo#' as Mcodigo,
						</cfif>
						'#form.tab#' as tab,						
						a.RHPCid,
						'#form.DEid#' as DEid
						
					from RHProgramacionCursos a
					
						left outer join RHCursos b
							on a.RHCid = b.RHCid
						
							inner join RHOfertaAcademica c
								on b.RHIAid = c.RHIAid
								and b.Mcodigo = c.Mcodigo
								
								inner join RHMateria d
									on c.Mcodigo = d.Mcodigo
									and d.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">	
									
									left outer join RHAreasCapacitacion e
										on d.RHACid = e.RHACid 
										
								
								inner join RHInstitucionesA  f
									on c.RHIAid = f.RHIAid 
									
					
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">						
						and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
						<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
							and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
						</cfif>
						and a.RHCid is not null						
					
				Order by 4 desc, 5
			</cfquery> 
			
			<cfinvoke 
			component="rh.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsListaCP#"/>
				<cfinvokeargument name="desplegar" value="Mnombre,RHIAcodigo,fdesde,fhasta"/>
				<cfinvokeargument name="etiquetas" value="Curso,Instituci&oacute;n, Desde, Hasta"/>
				<cfinvokeargument name="formatos" value="V,V,D,D"/>
				<cfinvokeargument name="align" value="left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="irA" value="ProgramInstaciaCurso-form.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="RHPCid"/>
				<cfinvokeargument name="formName" value="formCProgLista"/>
				<cfinvokeargument name="PageIndex" value="8"/>
			</cfinvoke>			
		</td>
		<td width="50%">
			<form name="formCCursos" action="ProgramInstanciaCurso-sql.cfm" method="post">
				<table width="100%" cellpadding="2" cellspacing="0">
					<input type="hidden" name="DEid" value="#form.DEid#">
					<input type="hidden" name="Mcodigo" value="#form.Mcodigo#">
					<input type="hidden" name="tab" value="#form.tab#">					
					<tr>
						<td align="right"><strong>Curso:</strong></td>
						<td>
							<cfif modoCCursos NEQ 'ALTA' and len(trim(data.Mcodigo))>
								<cfquery name="rsNombre" datasource="#session.DSN#">
									select RHCnombre, RHCcodigo
									from RHCursos a
									inner join RHMateria b
										on b.Mcodigo = a.Mcodigo
										and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">	
									where a.RHCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHCid#">
								</cfquery>
							</cfif>
							<!---Mcodigo1=Codigo de la materia  a la que pertenece el curso
								 RHCid1=Identity del curso
								 RHIAid1=Codigo de la institucion donde se imparte el curso
								 RHCcodigo1=Codigo del curso
								 RHCnombre1=nombre/descripcion del curso
								 RHCfdesde1=fecha de inicio del curso
								 RHCfhasta1=fecha de finalizacion del curso 	
							---->
							<input type="hidden" name="Mcodigo1" value="<cfif modoCCursos NEQ 'ALTA'>#data.Mcodigo#</cfif>">
							<input type="hidden" name="RHCid1" value="<cfif modoCCursos NEQ 'ALTA'>#data.RHCid#</cfif>">
							<input type="hidden" name="RHIAid1" value="<cfif modoCCursos NEQ 'ALTA'>#data.RHIAid#</cfif>">							
							<input type="text" name="RHCcodigo1" value="<cfif modoCCursos NEQ 'ALTA' and isdefined("rsNombre")>#rsNombre.RHCcodigo#</cfif>" size="10" onBlur="javascript:traerCurso(this.value,1);">								
							<input type="text" name="RHCnombre1" value="<cfif modoCCursos NEQ 'ALTA' and isdefined("rsNombre")>#rsNombre.RHCnombre#</cfif>" disabled size="40">
							<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Cursos" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisRHCursos(1,<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>#form.Mcodigo#<cfelse>0</cfif>);'></a>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Desde:&nbsp;</strong></td>
						<td>
							<table cellpadding="0" cellspacing="0">
								<tr>			
									<td>
										<input tabindex="200" class="cajasinbordeb" type="text" name="RHCfdesde1" value="<cfif modoCCursos NEQ 'ALTA'>#LSDateFormat(data.RHPCfdesde,'dd/mm/yyyy')#</cfif>">
									</td>
									<td width="1">&nbsp;</td>
									<td align="right"><strong>Hasta:&nbsp;</strong></td>
									<td>
										<input tabindex="300" class="cajasinbordeb" type="text" name="RHCfhasta1" value="<cfif modoCCursos NEQ 'ALTA'>#LSDateFormat(data.RHPCfhasta,'dd/mm/yyyy')#</cfif>">
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

<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm8 = new qForm("formCCursos");

	objForm8.RHCnombre1.required= true;
	objForm8.RHCnombre1.description="Curso";	

	function habilitarValidacion(){
		objForm8.RHCnombre1.required= true;
	}

	function deshabilitarValidacion(){
		objForm8.RHCnombre1.required= false;
	}		
</script>
</body>
</html>
