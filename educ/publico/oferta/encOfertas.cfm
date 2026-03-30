<cfquery datasource="#Session.DSN#" name="rsParam">
	select distinct p1.PGvalor as Facultad
		, p2.PGvalor as Escuela
	from ParametrosGenerales p1
		, ParametrosGenerales p2
	where p1.PGnombre='Facultad' 
		and p2.PGnombre='Escuela' 
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsPES">	
	select  Fnombre as Fnombre, 
			ESnombre as ESnombre, 
			CARnombre as CARnombre, 
			GAnombre + ' en ' + PESnombre as PESnombre,
			p.PEScodigo as PEScodigo
	  from PlanEstudios p, Carrera c, Escuela e, Facultad f, GradoAcademico g
	 where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	   and f.Fcodigo = e.Fcodigo
	   and e.EScodigo = c.EScodigo
	   and c.CARcodigo = p.CARcodigo
	   and p.GAcodigo *= g.GAcodigo
	   and p.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#"> 
</cfquery>

<cfif isdefined('form.codMcodigo') and form.codMcodigo NEQ ''>
	<cfquery datasource="#Session.DSN#" name="rsMateria">
		Select Mnombre
		from Materia
		where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.codMcodigo#"> 
	</cfquery>
</cfif>

<cfif isdefined('rsPES') and rsPES.recordCount GT 0>
	<cfoutput>
	  <table width="427" align="center" bgcolor="##BDD2D2">
		<tr> 
		  <td width="26%"><strong><font color="##330000" size="2">#rsParam.Facultad#: </font></strong></td>
	      <td width="74%"><strong><font color="##330000" size="2">#rsPES.Fnombre#</font></strong></td>
		</tr>
		<tr> 
		  <td><strong><font color="##330000" size="2">#rsParam.Escuela#: </font></strong></td>
	      <td><strong><font color="##330000" size="2">#rsPES.ESnombre#</font></strong></td>
		</tr>
		<tr> 
		  <td><strong><font color="##330000" size="2">Carrera: </font></strong></td>
	      <td><strong><font color="##330000" size="2">#rsPES.CARnombre#</font></strong></td>
		</tr>
		<tr> 
		  <td nowrap><strong><font color="##330000" size="2">Plan de Estudios: </font></strong></td>
	      <td nowrap><strong><font color="##330000" size="2">#rsPES.PESnombre#</font></strong></td>
		</tr>
		<cfif isdefined('rsMateria') and rsMateria.recordCount GT 0>
			<tr> 
			  <td nowrap><strong><font color="##330000" size="2">Materia: </font></strong></td>
		      <td nowrap><strong><font color="##330000" size="2">#rsMateria.Mnombre#</font></strong></td>
			</tr>		
		</cfif>
	  </table>	
	</cfoutput> 
</cfif>