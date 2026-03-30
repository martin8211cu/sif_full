 <cfquery datasource="#Session.Edu.DSN#" name="rsAnio">
		select distinct(Datepart(yy,CDfecha)) as anio
		from sdc..CalendarioDia
		where Ccodigo=(
			Select Ccodigo 
			from CentroEducativo 
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">)
		union
		select datepart(yy,getdate()) as anio	
</cfquery>

<cfform action="" name="formFiltroCalendario" >
  <table width="100%" border="0" class="areaFiltro">
    <tr> 
      <td class="subTitulo">Fecha Inicio</td>
      <td> <a href="#"> 
        <input name="FechaIni" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined("Form.FechaIni")>#Form.FechaIni#</cfif></cfoutput>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formFiltroCalendario.FechaIni');"> 
        </a> </td>
      <td class="subTitulo">Fecha Final</td>
      <td> <a href="#"> 
        <input name="FechaFin" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined("Form.FechaFin")>#Form.FechaFin#</cfif></cfoutput>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar2" width="11" height="11" border="0" id="Calendar2" onClick="javascript:showCalendar('document.formFiltroCalendario.FechaFin');"> 
        </a> </td>
      <td rowspan="2" align="center" valign="middle"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" ></td>
    </tr>
    <tr> 
      <td class="subTitulo">D&iacute;as</td>
      <td><select name="dia" id="dia">
          <cfif isdefined("form.dia") and #form.dia# EQ "-1">
            <option value="-1">-- Todos --</option>
            <cfelse>
            <option value="-1" selected>-- Todos --</option>
          </cfif>
          <cfif isdefined("form.dia") and #form.dia# EQ "1">
            <option value="1" selected>Feriados</option>
            <cfelse>
            <option value="1">Feriados</option>
          </cfif>
          <cfif isdefined("form.dia") and #form.dia# EQ "0">
            <option value="0" selected>Regular</option>
            <cfelse>
            <option value="0">Regular</option>
          </cfif>
        </select></td>
    <td class="subTitulo">A&ntilde;o</td>
    <td> 
		<select name="anio" id="anio">
			<cfif isdefined("form.anio") and #form.anio# EQ "-1">
          		<option value="-1" selected>-- Todos --</option>			
			<cfelse>
          		<option value="-1">-- Todos --</option>						
			</cfif>
			<cfoutput query="rsAnio">
				<cfif isdefined("form.anio") and #form.anio# EQ #rsAnio.anio#>
					<option value="#rsAnio.anio#" selected>#rsAnio.anio#</option>
				<cfelseif not isdefined("form.anio") and #rsAnio.anio# EQ Year(Now())>
					<option value="#rsAnio.anio#" selected>#rsAnio.anio#</option>
				<cfelse>
					<option value="#rsAnio.anio#">#rsAnio.anio#</option>
				</cfif>
			</cfoutput>
        </select> 
	</td>
    </tr>
  </table>
</cfform>

<script language="JavaScript" type="text/javascript" src="../../js/calendar.js">//</script>  
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>  

