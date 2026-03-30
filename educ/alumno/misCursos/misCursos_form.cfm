
<cfquery name="rsCursosAl" datasource="#Session.DSN#">
	Select a.Apersona, Pnombre, Papellido1, Papellido2, ca.Ccodigo,Cnombre
	from Alumno a
		, CursoAlumno ca
		, Curso c
	where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.Ecodigo=c.Ecodigo	
		and a.Apersona=ca.Apersona
		and ca.Ccodigo=c.Ccodigo
		and Cestado <> 4
	order by Cnombre
</cfquery>

<form name="formMisCursos" method="post" action="misCursos.cfm">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3" align="center" class="tituloMantenimiento">
		  	<font size="3">
				Informaci&oacute;n General del alumno por Curso
			</font>		
		</td>
	  </tr>
	  <tr>
		<td width="25%">&nbsp;</td>
		<td width="2%">&nbsp;</td>
		<td width="73%">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="right"><strong>Curso:</strong></td>
		<td>&nbsp;</td>
		<td><select name="Ccodigo">
		  <cfoutput query="rsCursosAl">
		    <option value="#rsCursosAl.Ccodigo#" <cfif isdefined('form.Ccodigo') and form.Ccodigo EQ rsCursosAl.Ccodigo> selected</cfif>>#rsCursosAl.Cnombre#</option>
        </cfoutput>	    </select>
	    <input name="btnConsultar" type="submit" id="btnConsultar" value="Consultar"></td>
	  </tr>
	</table>
</form>	

<cfif isdefined('form.Ccodigo')>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3" align="center">
			<hr>		
		</td>
	  </tr>
	  <tr>
		<td colspan="3" align="center">
			<cfinvoke 
			 component="educ.componentes.pTabs2"
			 method="fnTabsInclude">
				<cfinvokeargument name="pTabID" value="TabsMateria"/>
				<cfinvokeargument name="pTabs" value=
					#
						 "|Programa,programa_form.cfm,Documentación y Temas del curso"
						& "|Calendario,calendario_form.cfm,Distribución de las actividades del curso"
						& "|Nota Progreso,notaProgreso_form.cfm,Especificación de las notas obtenidas en el curso"
						& "|Control Asistencia,controlAsistencia_form.cfm,Reporte de asistencia del alumno a las lecciones"
						& "|Observaciones,observaciones_form.cfm,Reporte de las observaciones dirigidas al alumno"
					#
				/> 
				<cfparam name="Form.Ccodigo" default="">
				<cfinvokeargument name="pDatos" value="Ccodigo=#form.Ccodigo#"/>
				<cfinvokeargument name="pWidth" value="100%"/>
			</cfinvoke>			
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	</table>	
</cfif>		

