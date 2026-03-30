<cfquery name="rsProfGuiaAlumno" datasource="#session.DSN#">
	Select 
		PGAactivo
		, pga.Apersona
		, (Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as NombreAlumno
	from ProfesorGuiaAlumno pga
		, Alumno a
	where PGpersona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.llavePersona#">
		and pga.Apersona=a.Apersona
	order by Pnombre
</cfquery>

<form name="formProfGuiaAlumno" method="post" action="profGuiaAlumno_SQL.cfm">
 	<cfoutput>
		<cfif isdefined('form.modo') and form.modo NEQ ''>
			<input name="modo" type="hidden" value="#form.modo#">  
		</cfif>
	 
		<input type="hidden" name="PGpersona" value="<cfif isdefined("rsForm.llavePersona")>#rsForm.llavePersona#</cfif>">
		<input type="hidden" name="ApersonaAlumno" id="ApersonaAlumno" value="">	
		<input type="hidden" name="btnAgregarAl" id="btnAgregarAl" value="0">
		<input type="hidden" name="TipoPersona" id="TipoPersona" value="#TipoPersona#">
	</cfoutput>		

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3" align="center" class="tituloMantenimiento">
			Alumnos Asignados al Profesor Gu&iacute;a
		</td>
	  </tr>
	  <tr>
		<td colspan="3" align="center"><br>
			<input name="btnAgregaAlumno" type="button" id="btnAgregaAlumno" value="Agregar" onClick="javascript: doConlisProfGuiaAlumno();"
				title="Agregar un alumno al Profesor Gu&iacute;a actualmente seleccionado">		
		</td>
	  </tr>	
	  <tr>
		<td colspan="3"><hr></td>
	  </tr> 	

	  <cfif isdefined('rsProfGuiaAlumno') and rsProfGuiaAlumno.recordCount GT 0>
			<cfoutput query="rsProfGuiaAlumno">
				  <tr>
					<td align="center">&nbsp;</td>
					<td align="center">
						<a href="##">
							<cfif PGAactivo EQ 1>
								<img border="0" alt="Desactivar Alumno" onClick="javascript: DesactivarAlumno(#Apersona#);" src="/cfmx/educ/imagenes/iconos/check_del.gif">
							<cfelse>
								<img border="0" alt="Activar Alumno" onClick="javascript: ActivarAlumno(#Apersona#);" src="/cfmx/educ/imagenes/iconos/check_off.gif">
							</cfif>
						</a>
					</td>
					<td>#NombreAlumno#</td>
				  </tr>
			</cfoutput>
			<input type="hidden" name="btnActAlumno" id="btnActAlumno" value="0">					
			<input type="hidden" name="IdActAlumno" id="IdActAlumno" value="">		
			<input type="hidden" name="btnDesactAlumno" id="btnDesactAlumno" value="0">					
			<input type="hidden" name="IdDesactAlumno" id="IdDesactAlumno" value="">		
	  <cfelse>
		  <tr>
			<td width="4%">&nbsp;</td>
			<td width="14%">&nbsp;</td>
			<td width="82%">&nbsp;</td>
		  </tr> 	  
		  <tr>
			<td width="4%" colspan="3" align="center">
				<strong>!! El Profesor Gu&iacute;a no posee alumnos asociadas !!</strong>
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
	function DesactivarAlumno(cod){
		var f = document.formProfGuiaAlumno;
		
		if(confirm('Desea desactivar este Alumno ?')){
			f.btnDesactAlumno.value = 1;
			f.btnActAlumno.value = 0;
			f.btnAgregarAl.value = 0;
			f.IdDesactAlumno.value = cod;			

			f.submit()
		}
	}	
//-------------------------------------------------------------------------------------------		
	function ActivarAlumno(cod){
		var f = document.formProfGuiaAlumno;
		
		if(confirm('Desea activar este Alumno ?')){
			f.btnActAlumno.value = 1;
			f.btnDesactAlumno.value = 0;
			f.btnAgregarAl.value = 0;
			f.IdActAlumno.value = cod;			

			f.submit()
		}
	}		
//---------------------------------------------------------------------------------------	
	//Llama el conlis
	function doConlisProfGuiaAlumno() {
		var params ="";
		var codsQuitar = "<cfoutput>#ValueList(rsProfGuiaAlumno.Apersona,',')#</cfoutput>"		
		
		document.formProfGuiaAlumno.btnAgregarAl.value = 1;
		params = "?form=formProfGuiaAlumno&quitar=" + codsQuitar + "&cod=ApersonaAlumno&btn=btnAgregarAl&conexion=<cfoutput>#session.DSN#</cfoutput>";
		popUpWindow("/cfmx/educ/administrativo/personas/conlisAlumnos.cfm"+params,250,200,650,400);

	}	
//---------------------------------------------------------------------------------------	
</script>