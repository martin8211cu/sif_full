<cfparam name="form.RHIAid" default="">
<cfparam name="form.filtro_Mnombre" default="">
<cfparam name="form.filtro_RHCfdesde" default="">
<cfparam name="form.filtro_RHCfhasta" default="">
<cfparam name="form.filtro_disponible" default="">

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_Curso" Default="Curso" returnvariable="MSG_Curso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_FechaDesde" Default="Fecha Desde" returnvariable="MSG_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_FechaHasta" Default="Fecha Hasta" returnvariable="MSG_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_CupoDisponible" Default="Cupo Disponible" returnvariable="MSG_CupoDisponible" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_CursosDisponiblesPara" Default="Cursos disponibles para:" returnvariable="MSG_CursosDisponiblesPara" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_SeleccioneInstitucion" Default="- Seleccione Instituci&oacute;n -" returnvariable="MSG_SeleccioneInstitucion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Filtrar" Default="Filtrar" returnvariable="MSG_Filtrar" component="sif.Componentes.Translate" method="Translate"/>

<cfif LSIsDate(form.filtro_RHCfdesde)>
	<cftry>
		<cfset form.filtro_RHCfdesde = LSDateFormat(LSParseDateTime(form.filtro_RHCfdesde),'DD/MM/YYYY')>
	<cfcatch type="any"><cfset form.filtro_RHCfdesde = "">
		</cfcatch></cftry>
<cfelse>
	<cfset form.filtro_RHCfdesde = "">
</cfif>

<cfif LSIsDate(form.filtro_RHCfhasta)>
	<cftry>
		<cfset form.filtro_RHCfhasta = LSDateFormat(LSParseDateTime(form.filtro_RHCfhasta),'DD/MM/YYYY')>
	<cfcatch type="any"><cfset form.filtro_RHCfhasta = "">
		</cfcatch></cftry>
<cfelse>
	<cfset form.filtro_RHCfhasta = "">
</cfif>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Lista Cursos</title>
</head>

<cfquery datasource="#session.dsn#" name="cursos">
	select c.RHCid, c.Mcodigo, m.Mnombre, i.RHIAnombre,
		RHCfdesde,
		RHCfhasta,
		c.RHCcupo, c.RHCid,
		c.RHCcupo - (select count(1) from RHEmpleadoCurso ec
			where ec.RHCid = c.RHCid) as disponible
	from RHCursos c
	join RHMateria m
		on m.Mcodigo = c.Mcodigo
	join RHInstitucionesA i
		on i.RHIAid = c.RHIAid
	where i.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  <cfif Len(form.RHIAid)>
	  and c.RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#">
	  </cfif>
	  <cfif Len(form.filtro_Mnombre)>
	  and upper(m.Mnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(form.filtro_Mnombre)#%">
	  </cfif>
	  <cfif Len(form.filtro_RHCfdesde)>
	  and c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(form.filtro_RHCfdesde)#">
	  </cfif>
	  <cfif Len(form.filtro_RHCfhasta)>
	  and c.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(form.filtro_RHCfhasta)#">
	  </cfif>
	  <cfif Len(form.filtro_disponible)>
		and (c.RHCcupo - (select count(1) from RHEmpleadoCurso ec	where ec.RHCid = c.RHCid) )>= <cfqueryparam cfsqltype="cf_sql_integer" value="#filtro_disponible#">
		</cfif>
	order by i.RHIAnombre, m.Mnombre, c.RHCfdesde
</cfquery>
<cfquery datasource="#session.dsn#" name="inst">
	select RHIAid, RHIAnombre
	from RHInstitucionesA
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
<!--- 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> --->
	order by RHIAnombre
</cfquery>

<body style="margin:0;background-color:white;">
<form style="margin:0" action="cursos.cfm" method="post" name="listaCursos" id="listaCursos" >
<table style="background-color:blue;color:white;width:100%">
<tr>
  <td align="left">
<cfoutput>#MSG_CursosDisponiblesPara#</cfoutput> <select name="RHIAid" style="background-color:blue;color:white;font-weight:bold " onChange="this.form.submit()">
	<option value=""><cfoutput>#MSG_SeleccioneInstitucion#</cfoutput></option>
	<cfoutput query="inst">
		<option value="#HTMLEditFormat(inst.RHIAid)#" <cfif inst.RHIAid eq form.RHIAid>selected</cfif>>#HTMLEditFormat(inst.RHIAnombre)#</option>
	</cfoutput>
	</select></td>
  <table>
  <tr>
  		<td><cfoutput>#MSG_Curso#</cfoutput></td>
		<td><cfoutput>#MSG_FechaDesde#</cfoutput></td>
		<td><cfoutput>#MSG_FechaHasta#</cfoutput></td>
		<td><cfoutput>#MSG_CupoDisponible#</cfoutput></td>
  </tr>
  <tr> 
  		<td><input type="text" name="filtro_Mnombre" size="32" maxlenght="11" value="<cfif isdefined('form.filtro_Mnombre')><cfoutput>#form.filtro_Mnombre#</cfoutput></cfif>"></td>
	  	<td> <cf_sifcalendario form="listaCursos"  name="filtro_RHCfdesde" value="#form.filtro_RHCfdesde#"></td>
	 	<td><cf_sifcalendario form="listaCursos"  name="filtro_RHCfhasta" value="#form.filtro_RHCfhasta#"></td>
	  	<td ><input type="text" name="filtro_disponible" size="10" maxlenght="11" value="<cfif isdefined('form.filtro_disponible')><cfoutput>#form.filtro_disponible#</cfoutput></cfif>"></td>
		<td ><input class="btnFiltrar" type="submit" value="<cfoutput>#MSG_Filtrar#</cfoutput>"></td>
  </tr>
  </table>
			<cfset navegacion="">
			<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
					<cfinvokeargument name="query" value="#cursos#"/>
					<cfinvokeargument name="desplegar" value="Mnombre, RHCfdesde, RHCfhasta, disponible"/>
					<cfinvokeargument name="etiquetas" value="Curso, Desde, Hasta, Disponible"/>
					<cfinvokeargument name="formatos" value="S, D, D, I"/>
					<cfinvokeargument name="align" value="left, center, center, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="funcion" value="selecciona"/>
					<cfinvokeargument name="fparams" value="RHCid,Mcodigo,Mnombre,RHIAnombre,RHCfdesde,RHCfhasta,RHCcupo,disponible"/>
					<cfinvokeargument name="checkboxes" value="N">
					<cfinvokeargument name="keys" value="RHCid">
					<cfinvokeargument name="formName" value="listaCursos">
					<cfinvokeargument name="cortes" value="RHIAnombre">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="*** NO SE HAN REGISTRADO CURSOS ***">
					<cfinvokeargument name="navegacion" value="#navegacion#">
					<cfinvokeargument name="funcion" value="Asignar"/>
					<cfinvokeargument name="MaxRows" value="12"/>
					<cfinvokeargument name="usaAjax" value="true"/>
					<cfinvokeargument name="conexion" value="#session.dsn#"/>
		  </cfinvoke>
</form>
<script type="text/javascript">
	function selecciona(RHCid,Mcodigo,Mnombre,RHIAnombre,RHCfdesde,RHCfhasta,RHCcupo,disponible){
		var w = window.parent?window.parent:window.opener;
		if (w) {
			w.seleccionar_curso(RHCid,Mcodigo,Mnombre,RHIAnombre,RHCfdesde,RHCfhasta,RHCcupo,disponible);
		}
	}
	function Asignar(RHCid,Mcodigo,Mnombre,RHIAnombre,RHCfdesde,RHCfhasta,RHCcupo,disponible) {
		if (window.opener != null) {	
			window.opener.document.form1.RHCid.value = RHCid;
			window.opener.document.form1.Mcodigo.value = Mcodigo;
			window.opener.document.form1.Mnombre.value = Mnombre;
			window.opener.document.form1.RHIAnombre.value = RHIAnombre;
			window.opener.document.form1.RHCfdesde.value = RHCfdesde;
			window.close();
		}
	}


</script>
</body>
</html>
