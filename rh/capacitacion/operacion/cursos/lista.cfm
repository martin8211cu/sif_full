<cfif LSIsDate(url.filtro_RHCfdesde)>
	<cftry>
		<cfset url.filtro_RHCfdesde = LSDateFormat(LSParseDateTime(url.filtro_RHCfdesde),'DD/MM/YYYY')>
	<cfcatch type="any"><cfset url.filtro_RHCfdesde = "">
		</cfcatch></cftry>
<cfelse>
	<cfset url.filtro_RHCfdesde = "">
</cfif>
<cfif LSIsDate(url.filtro_RHCfhasta)>
	<cftry>
		<cfset url.filtro_RHCfhasta = LSDateFormat(LSParseDateTime(url.filtro_RHCfhasta),'DD/MM/YYYY')>
	<cfcatch type="any"><cfset url.filtro_RHCfhasta = "">
		</cfcatch></cftry>
<cfelse>
	<cfset url.filtro_RHCfhasta = "">
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sin_Clasificar"
	Default="Sin Clasificar"
	returnvariable="LB_Sin_Clasificar"/> 


<cfquery datasource="#session.dsn#" name="cursos">
	select 	c.RHCid, c.Mcodigo, m.Mnombre, i.RHIAnombre,
	    	{fn concat('<em>&nbsp;',{fn concat(coalesce (ac.RHACdescripcion,'#LB_Sin_Clasificar#'),'</em>')})} as RHACdescripcion,
			c.RHCfdesde,
			c.RHCfhasta,
			c.RHCcupo,
			c.RHCcupo - (	select count(1) from RHEmpleadoCurso ec
							where ec.RHCid = c.RHCid) as disponible
	from RHCursos c

	join RHMateria m
		on m.Mcodigo = c.Mcodigo

	join RHInstitucionesA i
		on i.RHIAid = c.RHIAid

	left join RHAreasCapacitacion ac
		on m.RHACid = ac.RHACid

	<cfif Len(url.filtro_RHGMid) and url.filtro_RHGMid neq 'null'>
		join RHMateriasGrupo mg 
		 on m.Mcodigo = mg.Mcodigo
		 and mg.RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_RHGMid#"> 
	</cfif>

	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif Len(url.filtro_RHIAid)>
	  		and c.RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_RHIAid#">
	  	</cfif>

		<cfif url.filtro_RHGMid eq 'null'>
	  		and not exists (	select 1 from RHMateriasGrupo mg 
								where m.Mcodigo = mg.Mcodigo
			  					  and mg.RHGMid is null )
		</cfif>

		<cfif url.filtro_RHACid eq 'null'>
	  		and m.RHACid is null
		<cfelseif Len(url.filtro_RHACid)>
	  		and m.RHACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_RHACid#">
		</cfif>
	  
	  	<cfif Len(url.filtro_Mnombre)>
	  		and upper(m.Mnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_Mnombre)#%">
	  	</cfif>
		
		<cfif Len(url.filtro_RHCfdesde)>
	  		and c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(url.filtro_RHCfdesde)#">
	  	</cfif>
	  	
		<cfif Len(url.filtro_RHCfhasta)>
	  		and c.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(url.filtro_RHCfhasta)#">
	  	</cfif>
	
	order by i.RHIAnombre, coalesce (ac.RHACdescripcion,'Sin Clasificar'), m.Mnombre, c.RHCfdesde

</cfquery>

<cfquery datasource="#session.dsn#" name="inst">
	select RHIAid, RHIAnombre
	from RHInstitucionesA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by RHIAnombre
</cfquery>
<cfquery datasource="#session.dsn#" name="area">
	select RHACid, RHACdescripcion
	from RHAreasCapacitacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by RHACdescripcion
</cfquery>

<cfquery datasource="#session.dsn#" name="grupo">
	select RHGMid, Descripcion
	from RHGrupoMaterias
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by Descripcion
</cfquery>

<form style="margin:0" action="." method="get" name="listaCursos" id="listaCursos">
      
  <table width="100%" border="0" class="areaFiltro">
    <tr>
      <td width="130">Instituci&oacute;n</td>
      <td>Grupo de Cursos </td>
      <td>&Aacute;rea de Capacitaci&oacute;n </td>
    </tr>

    <tr>
      <td width="250"><select name="filtro_RHIAid" style="width:150px">
        <option value="">-Seleccione Instituci&oacute;n-</option>
        <cfoutput query="inst">
          <option value="#HTMLEditFormat(inst.RHIAid)#" <cfif inst.RHIAid eq url.filtro_RHIAid>selected</cfif>>#HTMLEditFormat(inst.RHIAnombre)#</option>
        </cfoutput>
      </select></td>
      <td><select name="filtro_RHGMid" style="width:150px">
        <option value="">-todos-</option>
        <option value="null" <cfif url.filtro_RHGMid eq 'null'>selected</cfif>>-sin clasificar-</option>
        <cfoutput query="grupo">
          <option value="#HTMLEditFormat(RHGMid)#" <cfif url.filtro_RHGMid is grupo.RHGMid>selected</cfif>>#HTMLEditFormat(Descripcion)#</option>
        </cfoutput>
      </select></td>
      <td><select name="filtro_RHACid" style="width:150px">
        <option value="">-todas-</option>
        <option value="null" <cfif url.filtro_RHACid eq 'null'>selected</cfif>>-sin clasificar-</option>
        <cfoutput query="area">
          <option value="#HTMLEditFormat(RHACid)#" <cfif url.filtro_RHACid is area.RHACid>selected</cfif>>#HTMLEditFormat(RHACdescripcion)#</option>
        </cfoutput>
      </select></td>
    </tr>

    <tr>
      <td width="130">Curso</td>
      <td>Inicio</td>
      <td>Final</td>
    </tr>
	
	<tr>
		<td><input 	type="text" size="30" style="width:150px" maxlength="30" onfocus="this.select()" id="filtro_Mnombre" name="filtro_Mnombre" value="<cfoutput>#trim(url.filtro_Mnombre)#</cfoutput>"></td>
		<td><cf_sifcalendario name="filtro_RHCfdesde" form="listaCursos" value="#url.filtro_RHCfdesde#"></td>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td><cf_sifcalendario name="filtro_RHCfhasta" form="listaCursos" value="#url.filtro_RHCfhasta#"></td>
					<td valign="middle" align="center"><input type="submit" class="btnFiltrar" value="Buscar"></td>
				</tr>
			</table>
		</td>
	</tr>
	
	


  </table>
	<table>
		<tr><td>
  <cfset navegacion="">
			<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaQuery" 
				  >
					<cfinvokeargument name="query" value="#cursos#"/>
					<cfinvokeargument name="desplegar" value="Mnombre, RHCfdesde, RHCfhasta, RHCcupo,disponible"/>
					<cfinvokeargument name="etiquetas" value="Curso,Inicia,Termina,Cupo,Disponible"/>
					<cfinvokeargument name="formatos" value="S, D, D, UI, UI"/>
					<cfinvokeargument name="align" value="left, center, center, right, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="index.cfm"/>
					<cfinvokeargument name="checkboxes" value="N">
					<cfinvokeargument name="keys" value="RHCid">
					<cfinvokeargument name="formName" value="listaCursos">
					<cfinvokeargument name="incluyeform" value="no">
					<cfinvokeargument name="cortes" value="RHIAnombre,RHACdescripcion">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="*** NO SE HAN REGISTRADO CURSOS ***">
					<cfinvokeargument name="navegacion" value="#navegacion#">
					<cfinvokeargument name="mostrar_filtro" value="false">
					<cfinvokeargument name="maxrows" value="25">
		  </cfinvoke>
		</td></tr>
	</table>		  
</form>