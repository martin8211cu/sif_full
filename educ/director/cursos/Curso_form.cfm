<cfquery name="rsProfesores" datasource="#Session.DSN#">
	select convert(varchar,a.DOpersona) as DOpersona, Pnombre + ' ' + Papellido1 + ' ' + Papellido2 as DOnombre
	from Docente a, DocenteMateria b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.DOpersona = b.DOpersona
	  and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	  and b.DOMtipo = '1'
</cfquery>
<cfoutput>
<form name="frmCurso" id="frmCurso" method="post" style="margin: 0;" action="Curso_SQL.cfm">
	<cfif isdefined("form.CILtipoCicloDuracion")>
		<input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">	
		<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="#form.CILtipoCicloDuracion#">	
		<input type="hidden" name="PLcodigo" id="PLcodigo" value="#Form.PLcodigo#">	
		<cfif form.CILtipoCicloDuracion EQ "E">
		<input type="hidden" name="PEcodigo" id="PEcodigo" value="#Form.PEcodigo#">	
		</cfif>
		<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">	
		<input type="hidden" name="CARcodigo" id="CARcodigo" value="#Form.CARcodigo#">	
		<input type="hidden" name="GAcodigo" id="GAcodigo" value="#Form.GAcodigo#">
		<input type="hidden" name="PEScodigo" id="PEScodigo" value="#Form.PEScodigo#">	
		<input type="hidden" name="txtMnombreFiltro" id="txtMnombreFiltro" value="#Form.txtMnombreFiltro#">	
		<input type="hidden" name="Scodigo" id="Scodigo" value="#Form.Scodigo#">
		<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
	</cfif>
	<input type="hidden" name="Ccodigo" id="Ccodigo" value="#form.Ccodigo#">
	<input type="hidden" name="AddProf" id="AddProf" value="">
		
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="20%" align="right" class="fileLabel"></td>
    <td width="80%"></td>
  </tr>
  <tr> 
    <td colspan="6">
		<cfinclude template="encCurso.cfm">
	</td>
  </tr>
  <tr> 
    <td align="right" class="fileLabel">Cupo:&nbsp;</td>
    <td>
		<input type="text" align="right" name="Cupo" value="#rsCurso.CmatriculaMaxima#" size="2" maxlength="2">
	</td>
  </tr>
  <tr> 
    <td align="right" class="fileLabel">Profesor:&nbsp;</td>
    <td>
		<select name="DOpersona">
			<option value="">(No asignado)</option>
		<cfloop query="rsProfesores">
			<option value="#rsProfesores.DOpersona#"<cfif rsCurso.DOpersona EQ rsProfesores.DOpersona> selected</cfif>>#rsProfesores.DOnombre#</option>
		</cfloop>
		</select>
		<img title="Agregar un nuevo Profesor a la Materia" onClick="javascript: addProf();" src="/cfmx/educ/imagenes/iconos/description.gif" width="16" height="16">
	</td>
  </tr>
  <tr>
    <td align="right" class="fileLabel">Sede:&nbsp;</td>
    <td class="fileLabel">#rsCurso.Snombre#</td>
  </tr>
  <tr> 
    <td colspan="2" align="center">
		<input name="btnCambiar" type="submit" id="btnCambiar" value="Cambiar">
		<cfif session.MoG EQ "G">
			<cfif Trim(Session.Menues.SScodigo) EQ 'RH'>
				<input name="btnActivar" type="submit" id="btnActivar" value="Activar" onClick="javascript:if (!confirm('Un Curso Activo podrá empezarse a utilizar por profesores y alumnos ¿Desea ABRIR el Curso?')) return false; else alert('Para darle mantenimiento al Curso utilice la opción \'Menu Principal -> Capacitación y Desarrollo -> Mantenimiento de Cursos\'');">
			<cfelse>
				<input name="btnActivar" type="submit" id="btnActivar" value="Activar" onClick="javascript:if (!confirm('Un Curso Activo podrá empezarse a utilizar por profesores y alumnos ¿Desea ABRIR el Curso?')) return false; else alert('Para darle mantenimiento al Curso utilice la opción \'Menu Principal -> Cursos -> Mantenimiento Cursos\'');">
			</cfif>
		<cfelse>
		<input name="btnCerrar" type="submit" id="btnCerrar" value="Cerrar" onClick="javascript:if (!confirm('Un Curso Cerrado no podrá volverse a utilizar ¿Desea CERRAR el Curso?')) return false;">
		</cfif>
		<input name="btnCursos" type="submit" id="btnCursos" value="Listar Cursos" onClick="this.form.Ccodigo.value='';this.form.action='';">
		<input name="btnMaterias" type="submit" id="btnMaterias" value="Listar Materias" onClick="this.form.Mcodigo.value='';this.form.Ccodigo.value='';this.form.action='';">
	</td>
  </tr>
</table>

</form>
</cfoutput>
<cfinclude template="CursoHorario.cfm">

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//-------------------------------------------------------------------------	
	function addProf(){
		var params ="";
		var codsQuitar = "";
		
		params = "?form=frmCurso&quitar=" + codsQuitar + "&cod=AddProf&conexion=<cfoutput>#session.DSN#</cfoutput>";
		popUpWindow("/cfmx/educ/director/cursos/conlisProf.cfm"+params,250,200,650,400);
	}
</script>
<!--- 		var codsQuitar = "<cfoutput>#ValueList(rsProfGuiaAlumno.Apersona,',')#</cfoutput>"		 --->