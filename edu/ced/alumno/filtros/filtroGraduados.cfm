<!--- <cfform action="../inicioAgregaEncar.cfm" name="filtroEncar" > --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsPromocion">
		select distinct convert(varchar,pr.PRcodigo) as Codigo, substring(pr.PRdescripcion ,1,50) as PRdescripcion
		from PersonaEducativo pe, 
			Alumnos a, 
			AlumnoRetirado ar, 
			Promocion pr 
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		  and ar.ARalta = 2 
		  and a.Aretirado = 2 
		  and a.persona=pe.persona 
		  and a.CEcodigo = ar.CEcodigo 
		  and a.Ecodigo = ar.Ecodigo 
		  and ar.PRcodigo = pr.PRcodigo 
		  and pr.PRactivo = 0
	</cfquery>
	
<form action="/cfmx/edu/ced/alumno/Graduados.cfm" name="filtroEncar" method="post" >
	<input type="hidden" id="persona" name="persona" value="<cfif isdefined("form.persona")><cfoutput>#form.persona#</cfoutput></cfif>">
  <table width="100%" border="0" class="areaFiltro">
    <tr> 
      <td width="8%" class="subTitulo">Promociones</td>
      <td width="12%" class="subTitulo"><select name="FPRcodigo" id="select" tabindex="5">
          <cfoutput query="rsPromocion"> 
            <option value="#Codigo#" >#PRdescripcion#</option>
          </cfoutput> </select></td>
      <td width="6%" class="subTitulo">Nombre</td>
      <td width="31%" class="subTitulo"><input name="fnombreAL" type="text" id="fnombreAL" size="50" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fnombreAL") AND #Form.fnombreAL# NEQ "" ><cfoutput>#Form.fnombreAL#</cfoutput></cfif>"></td>
      <td width="6%" class="subTitulo">Identificaci&oacute;n</td>
      <td width="37%" class="subTitulo"><input name="fAlumnoPid" type="text"  id="fAlumnoPid" size="25" onFocus="this.select()" maxlength="60" value="<cfif isdefined("Form.fAlumnoPid") AND #Form.fAlumnoPid# NEQ "" ><cfoutput>#Form.fAlumnoPid#</cfoutput></cfif>"> 
      </td>
    </tr>
    <tr> 
      <td colspan="6" class="subTitulo"><div align="center"> 
          <input name="btnBuscarEncar" type="submit" id="btnBuscarEncar2" value="Buscar" >
        </div></td>
    </tr>
  </table>
</form>
