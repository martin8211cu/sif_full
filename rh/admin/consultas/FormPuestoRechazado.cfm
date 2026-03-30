<!--- variables de traduccion--->
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo"	returnvariable="LB_Codigo"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripi&oacute;n"	returnvariable="LB_Descripcion"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Usuario" Default="Usuario"	returnvariable="LB_Usuario"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha de Rechazo"	returnvariable="LB_Fecha"/>	
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FiltroTodos" Default="Todos"	returnvariable="LB_FiltroTodos"/>	
<!--- Fin variables de traduccion--->	
<cf_dbfunction name="date_format" args="form.Ffecha,DD/MM/YYYY" returnvariable="VFFecha">


<!---Query para filtro por usuarios--->
	<cfquery name="rsUsuarios" datasource="#session.dsn#">
		select distinct c.Usulogin as Usuario
			from RHDescripPuestoP a 
				 inner join RHPuestos b 
						on a.Ecodigo = b.Ecodigo 
						and a.RHPcodigo = b.RHPcodigo 
				 inner join Usuario c on a.BMusumod = c.Usucodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#" >
				  and a.Estado in (35,40) order by c.Usulogin
	</cfquery>
	

<form name="FormularioPuestoRechazado" action="ConsultaPuestoRechazado.cfm" method="post">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
			<tr> 
				<td width="27%" height="17" > <cfoutput>#LB_Codigo#</cfoutput></td>
				<td width="27%" ><cfoutput>#LB_Descripcion#</cfoutput></td>
				<td width="27%" ><cfoutput>#LB_Usuario#</cfoutput></td>
				<td width="27%" ><cfoutput>#LB_Fecha#</cfoutput></td>
				<td width="5%" colspan="2" rowspan="2"><input type="submit" class="btnFiltrar" value="filtrar" /> </td>
			</tr>
			<tr>
				<td>
					<input type="text" name="Fcodigo" 
						value="<cfif isdefined('form.Fcodigo') and trim(form.Fcodigo) GT 0><cfoutput>#form.Fcodigo#</cfoutput></cfif>"/>  
				</td>
				<td>
					<input type="text" name="Fdescripcion" 
						value="<cfif isdefined('form.Fdescripcion') and trim(form.Fdescripcion) GT 0><cfoutput>#form.Fdescripcion#</cfoutput></cfif>"/>  
				</td>
				<td>
					<select name="selUsuario" >
							<option  value="Todos"><cfoutput>#LB_FiltroTodos#</cfoutput></option>
						<cfoutput query="rsUsuarios">
							<option value="#Usuario#" <cfif isdefined('form.selUsuario') and  form.selUsuario EQ #Usuario#>selected</cfif> >#Usuario#</option>
						</cfoutput>
					</select>
				</td>	
				<td>
						<cfif isdefined('form.Ifecha') and trim(form.Ifecha) GT 0>
							 <cf_sifcalendario form="FormularioPuestoRechazado" name="Ifecha" value="#form.Ifecha#">
						 <cfelse>
						 	 <cf_sifcalendario form="FormularioPuestoRechazado" name="Ifecha" value="">
						  </cfif>   
				</td>
			</tr>
	</table>
</form>


<form name="FormularioPuesto" action="ReportePuestosRechazados.cfm" method="post">
<!--- Filtros para consulta--->

<cfset filtro="">
	<cfif isdefined('form.Fcodigo') and len(trim(form.Fcodigo)) GT 0>
		<cfset filtro= filtro & "and a.RHPcodigo like '%" & ucase(form.Fcodigo) & "%'">
	</cfif>
	<cfif isdefined('form.Fdescripcion') and len(trim(form.Fdescripcion)) GT 0>
		<cfset filtro=filtro &  "and upper(b.RHPdescpuesto) like '%" & ucase(form.Fdescripcion) & "%'">
	</cfif>
					 
	<cfif isdefined('form.selUsuario') and trim(form.selUsuario) NEQ #LB_FiltroTodos#>
		<cfset filtro= filtro &  "and c.Usulogin like '%" & form.selUsuario & "%'">
	</cfif>
	<cfif isdefined('form.Ifecha') and len(trim(form.Ifecha)) GT 0>
		<cf_dbfunction name="date_format" args="a.BMfechamod,DD/MM/YYYY" returnvariable="VFFecha1">
		<cf_dbfunction name="date_format" args="#form.Ifecha#,DD/MM/YYYY" returnvariable="VFFecha2">
		<cfset filtro=filtro &  "and " &  #VFFecha1#  & " = '" & #form.Ifecha#&"'">
	</cfif>
<!--- Fin Filtros para consulta--->

<cfinvoke component="rh.Componentes.pListas" method="pListaRH">
	<cfinvokeargument name="tabla" value="RHDescripPuestoP a inner join RHPuestos b 
																	 on a.Ecodigo = b.Ecodigo 
																	 and a.RHPcodigo = b.RHPcodigo 
						  										  inner join Usuario c 
																	 on a.BMusumod = c.Usucodigo"/>
									 
	<cfinvokeargument name="columnas" value="a.RHPcodigo as Codigo,
		  									 b.RHPdescpuesto as Descripcion, 
		  									 c.Usulogin as Usuario,
											 a.BMfechamod  as Fecha"/>
		   
	<cfinvokeargument name="desplegar" value="Codigo,Descripcion, Usuario,Fecha"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Usuario#,#LB_Fecha#"/>
	<cfinvokeargument name="formatos" value="S,S,S,D"/>
	<cfinvokeargument name="formName" value="FormularioPuesto"/>
	<cfinvokeargument name="filtro" value=" a.Estado in (35,40) and a.Ecodigo = #Session.Ecodigo# #filtro# order by a.BMfechamod"/>
	<cfinvokeargument name="align" value="left,left, center, center"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="ReportePuestosRechazados.cfm"/>
	<cfinvokeargument name="showEmptyListMsg" value="true">
	<cfinvokeargument name="EmptyListMsg" value="true">
</cfinvoke>
</form>
