<cfquery name="rsProfesores" datasource="#Session.DSN#">
	select convert(varchar,a.DOpersona) as DOpersona, 
			convert(varchar,c.DOpersona) as DOpersona2, 
			Pnombre + ' ' + Papellido1 + ' ' + Papellido2 as DOnombre
	from Docente a, DocenteMateria b, CursoDocente c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.DOpersona = b.DOpersona
	  and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	  <cfif rsCurso.DOpersona NEQ "">
	  and b.DOpersona <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCurso.DOpersona#">
	  </cfif>
	  and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
	  and c.DOpersona =* b.DOpersona
</cfquery>
<cfoutput>
<form name="frmCursoAsistente" method="post" style="margin: 0;" action="Curso_SQL.cfm">
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
  	<cfif rsProfesores.recordCount EQ 0>
	<td colspan="4" align="center">
	  No hay Asistentes registrados en la Materia
	</td>
	</cfif>
	<cfloop query="rsProfesores">
    <td align="right" class="fileLabel">
		<input name="DOpersona" type="checkbox" value="#rsProfesores.DOpersona#" <cfif rsProfesores.DOpersona2 NEQ "">checked</cfif>>
	</td>
    <td>
			#rsProfesores.DOnombre#
	</td>
  </tr>
	</cfloop>
  <tr> 
    <td colspan="2" align="center">&nbsp;
		
    </td>
  </tr>
  <tr> 
    <td colspan="2" align="center">
		<input name="btnAsistente" type="submit" id="btnAsistente" value="Cambiar">
    </td>
  </tr>
</table>

</form>
</cfoutput>


