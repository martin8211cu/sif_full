<cfquery name="rsDirPlanEstAlumno" datasource="#session.DSN#">
	Select pea.PEScodigo
		, GAnombre + ' en ' + PESnombre as PESnombre
		, PEScodificacion
		, PEAactivo
	from PlanEstudiosAlumno pea
		, PlanEstudios pe
		, GradoAcademico ga
	where ga.Ecodigo=#session.Ecodigo# and Apersona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.llavePersona#">
		and pea.PEScodigo=pe.PEScodigo
		and ga.GAcodigo = pe.GAcodigo
	order by GAorden, PESnombre
</cfquery>

<form name="formPlanEstAlumno" method="post" action="planEstudiosAlumno_SQL.cfm">
 	<cfoutput>
		<cfif isdefined('form.modo') and form.modo NEQ ''>
			<input name="modo" type="hidden" value="#form.modo#">  
		</cfif>
	 
		<input type="hidden" name="Apersona" value="<cfif isdefined("rsForm.llavePersona")>#rsForm.llavePersona#</cfif>">
		<input type="hidden" name="PEScodigoPlanEst" id="PEScodigoPlanEst" value="">	
		<input type="hidden" name="btnAgregarPlanEst" id="btnAgregarPlanEst" value="0">
		<input type="hidden" name="TipoPersona" id="TipoPersona" value="#TipoPersona#">
	</cfoutput>		

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3" align="center" class="tituloMantenimiento">
			Planes de Estudios asignados al Alumno
		</td>
	  </tr>
	  <tr>
		<td colspan="3" align="center"><br>
			<input name="btnAgregaEscuela" type="button" id="btnAgregaEscuela" value="Agregar" onClick="javascript: doConlisPlanEst();"
				title="Agregar un Plan de Estudios al Alumno actualmente seleccionado">		
		</td>
	  </tr>	
	  <tr>
		<td colspan="3"><hr></td>
	  </tr> 	

	  <cfif isdefined('rsDirPlanEstAlumno') and rsDirPlanEstAlumno.recordCount GT 0>
			<cfoutput query="rsDirPlanEstAlumno">
				  <tr>
					<td align="center">&nbsp;</td>
					<td align="center">
						<a href="##">
							<cfif PEAactivo EQ 1>
								<img border="0" alt="Desactivar este Plan" onClick="javascript: desactPlanEst(#PEScodigo#);" src="/cfmx/educ/imagenes/iconos/check_del.gif">
							<cfelse>
								<img border="0" alt="Activar este Plan" onClick="javascript: actPlanEst(#PEScodigo#);" src="/cfmx/educ/imagenes/iconos/check_off.gif">
							</cfif>						
						</a>
					</td>
					<td>#PESnombre#</td>
				  </tr>
			</cfoutput>
			<input type="hidden" name="btnActPlanEst" id="btnActPlanEst" value="0">					
			<input type="hidden" name="IdPlanEstAct" id="IdPlanEstAct" value="">			
			<input type="hidden" name="btnDesactPlanEst" id="btnDesactPlanEst" value="0">					
			<input type="hidden" name="IdPlanEstDesact" id="IdPlanEstDesact" value="">		
	  <cfelse>
		  <tr>
			<td width="4%">&nbsp;</td>
			<td width="14%">&nbsp;</td>
			<td width="82%">&nbsp;</td>
		  </tr> 	  
		  <tr>
			<td width="4%" colspan="3" align="center">
				<strong>!! El Alumno no posee Planes Asociados !!</strong>
			</td>
		  </tr>	  
	  </cfif>
  </table>
</form>
<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//-------------------------------------------------------------------------------------------		
	function desactPlanEst(cod){
		var f = document.formPlanEstAlumno;
		
		if(confirm('Desea desactivar este Plan de Estudios ?')){
			f.btnDesactPlanEst.value = 1;
			f.btnActPlanEst.value = 0;			
			f.btnAgregarPlanEst.value = 0;
			f.IdPlanEstDesact.value = cod;			

			f.submit()
		}
	}	
//-------------------------------------------------------------------------------------------		
	function actPlanEst(cod){
		var f = document.formPlanEstAlumno;
		
		if(confirm('Desea activar este Plan de Estudios ?')){
			f.btnActPlanEst.value = 1;
			f.btnDesactPlanEst.value = 0;
			f.btnAgregarPlanEst.value = 0;
			f.IdPlanEstAct.value = cod;			

			f.submit()
		}
	}		
//---------------------------------------------------------------------------------------	
	//Llama el conlis
	function doConlisPlanEst() {
		var params ="";
		var codsQuitar = "<cfoutput>#ValueList(rsDirPlanEstAlumno.PEScodigo,',')#</cfoutput>"		
		
		document.formPlanEstAlumno.btnAgregarPlanEst.value = 1;
		params = "?form=formPlanEstAlumno&quitar=" + codsQuitar + "&cod=PEScodigoPlanEst&btn=btnAgregarPlanEst&conexion=<cfoutput>#session.DSN#</cfoutput>";
		popUpWindow("/cfmx/educ/administrativo/personas/conlisPlanEstudios.cfm"+params,250,200,650,400);

	}	
//---------------------------------------------------------------------------------------	
</script>