	<cfinvoke 
	 component="edu.Componentes.usuarios"
	 method="get_usuario_by_cod"
	 returnvariable="usr">
		<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
		<cfinvokeargument name="sistema" value="edu"/>
		<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
		<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
		<cfinvokeargument name="roles" value="edu.docente"/>
	</cfinvoke>

	<cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
		set nocount on
		select 	convert(varchar,c.Ccodigo) as codCurso, 
				(Mnombre+' '+GRnombre) as nombCurso,
				Norden, Gorden
		from Curso c, Materia m, Grupo g, PeriodoVigente v, Staff s, Nivel n, Grado k
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
			and c.Mconsecutivo = m.Mconsecutivo
			and m.Melectiva = 'R'
			and c.GRcodigo = g.GRcodigo
			and m.Ncodigo = v.Ncodigo
			and c.PEcodigo = v.PEcodigo
			and c.SPEcodigo = v.SPEcodigo
			and c.Splaza = s.Splaza
			and m.Ncodigo = n.Ncodigo
			and m.Ncodigo = k.Ncodigo
			and m.Gcodigo = k.Gcodigo
		union
		select 	convert(varchar,c.Ccodigo) as codCurso,
				Cnombre as nombCurso,
				Norden, 100000 as Gorden
		from Curso c, Materia m, PeriodoVigente v, Staff s, Nivel n
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
			and c.Mconsecutivo = m.Mconsecutivo
			and m.Melectiva = 'S'
			and m.Ncodigo = v.Ncodigo
			and c.PEcodigo = v.PEcodigo
			and c.SPEcodigo = v.SPEcodigo
			and c.Splaza = s.Splaza
			and m.Ncodigo = n.Ncodigo
		order by 3,4,2
		set nocount off
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		function Validar(curso) {
			if (curso != "" && curso != null) {
				return confirm('Va a proceder a recalendarizar los temarios y evaluaciones de '+curso+' tomando en cuenta el horario y la planeación a nivel administrativa de la materia a la cual pertenece el curso. Se perderán todos los cambios realizados en la planeación a nivel del docente. Está seguro de que desea continuar con la recalendarización?');
			} else {
				return false;
			}
		}
	</script>
	<form action="SQLRecalendarizar.cfm" method="post">
	  <table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr> 
		  <td>&nbsp;</td>
		</tr>
		<tr> 
		  <td class="tituloAlterno">Escoja el curso a recalendarizar</td>
		</tr>
		<tr valign="middle"> 
		  <td align="center">&nbsp;</td>
		</tr>
		<tr valign="middle"> 
		  <td align="center">Curso 
			<select name="Ccodigo" id="Ccodigo">
			  <cfoutput query="rsCursos"> 
				<option value="#codCurso#" <cfif isdefined("Form.Ccodigo") and Form.Ccodigo EQ rsCursos.codCurso>selected</cfif>>#nombCurso#</option>
			  </cfoutput> 
			</select>
		  </td>
		</tr>
		<tr valign="middle"> 
		  <td align="center">&nbsp;</td>
		</tr>
		<tr valign="middle">
		  <td align="center">
			<input name="btnRecalendarizar" type="submit" id="btnRecalendarizar" value="Recalendarizar" onClick="javascript: return Validar(this.form.Ccodigo.options[this.form.Ccodigo.selectedIndex].text);">
		  </td>
		</tr>
	  </table>
	</form>