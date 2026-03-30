<!---<cf_dump var="#form#">--->


<cfparam name="session.listaEmpleados" default="">
<cfif isdefined('form.AddEmpleado')>
	<cfset session.listaEmpleados = listAppend(session.listaEmpleados,form.DEid,',')>
</cfif>

<cfparam name="session.listaCargas" default="">
<cfif isdefined('form.AddCarga')>
	<cfset session.listaCargas = listAppend(session.listaCargas,form.ECid,',')>
</cfif>

<cfparam name="session.listaDeducciones" default="">
<cfif isdefined('form.AddDeduccion')>
	<cfset session.listaDeducciones = listAppend(session.listaDeducciones,form.TDid,',')>
</cfif>

<cfparam name="session.listaTiposNomina" default="">
<cfif isdefined('form.AddTiposNomina')>
	<cfset session.listaTiposNomina = listAppend(session.listaTiposNomina,form.Tcodigo,',')>
</cfif>

<cfif isdefined("form.Clonar")>
	<cfset Avance = 0>
	<cfset incremeto = 100 / listlen(form.Clonar,",")>	
	<cfloop index = "index" list = "#Form.Clonar#" delimiters = ",">
		<cfset data = ListToArray(index,',') >
		<cfquery name="rsClonar" datasource="#form.DSNO#">
			select *
			from #session.clonacion#
			where Tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#data[1]#">
		</cfquery>
		
		<!---<cf_dump var="#rsClonar#">--->

		<cfif isdefined("form.chkSQL") and form.chkSQL eq 1 >
			<cfset EcodigoX	= "#form.EcodigoDE#">
		<cfelse>
			<cfset EcodigoX	= "#form.EcodigoD#">
		</cfif>
		
		<cfif isdefined('rsClonar') and rsClonar.recordCount GT 0 >
			<cfinvoke component="rh.Componentes.RH_Clonacion" method="ActualizaDatos"
					conexionO		= "#form.DSNO#"
					conexionD		= "#form.DSND#"
					Tabla   		= "#rsClonar.Tabla#"
					Fuente 			= "#rsClonar.Fuente#"
					EcodigoNuevo	= "#EcodigoX#"
					EcodigoViejo 	= "#form.EcodigoO#"
					llave 			= "#rsClonar.llave#"
					Padre 			= "#rsClonar.Padre#"
				/>
		</cfif>
		<cfset Avance = Avance + incremeto>
		<!---<script type="text/javascript" language="javascript1.2">
			funcAvance('#Avance#');
		</script>--->
	</cfloop>
</cfif>

<cfoutput>
<form action="clonacion.cfm" method="post" name="sql">
<!---	<input type="hidden" name="ACCION" 			value= "1">--->
	<input type="hidden" name="Usucodigo" 		value= "#session.Usucodigo#">
	<input type="hidden" name="CEcodigoD" 		value= "#form.CEcodigoD#">
	<input type="hidden" name="CEcodigoO" 		value= "#form.CEcodigoO#">
	<input type="hidden" name="DSND" 			value= "#form.DSND#">
	<input type="hidden" name="DSNO" 			value= "#form.DSNO#">
	
	<cfif isdefined("form.chkSQL") and form.chkSQL eq 1 >
		<input type="hidden" name="EcodigoD" 		value= "#form.EcodigoDE#">
	<cfelse>
		<input type="hidden" name="EcodigoD" 		value= "#form.EcodigoD#">
	</cfif>
	<input type="hidden" name="EcodigoO" 		value= "#form.EcodigoO#">
	<input type="hidden" name="SScodigoO" 		value= "#form.SScodigoO#">
	<cfif isdefined("form.AddEmpleado")>
		<input type="hidden" name="AddEmpleado" 	value= "#form.AddEmpleado#">
	</cfif>
	<input name="fEmpresa" type="hidden" value="<cfif isdefined("form.fEmpresa")>#form.fEmpresa#</cfif>">
	<cfif isdefined("form.accion") and form.accion eq 1 >
		<input name="Usucodigo" type="hidden" value="<cfif isdefined("Form.Usucodigo")>#Form.Usucodigo#</cfif>">
	</cfif>
	<cfif isdefined("form.rTodos") and form.rTodos eq 0 >
		<input name="rTodos" type="hidden" value="0">
	</cfif>
	<cfif isdefined("form.Cargos")>
		<input name="Cargos" type="hidden" value="1">
	</cfif>
	<cfif isdefined("form.histDeduc")>
		<input name="histDeduc" type="hidden" value="1">
	</cfif>
	<cfif isdefined("form.histNomina")>
		<input name="histNomina" type="hidden" value="1">
	</cfif>


<cfif isdefined('form.chkSQL')>
	<cfzip
		action="zip"
		source="#ExpandPath('/clonacion/scripts/')#"
		file="#ExpandPath( '/clonacion/scripts/scrip_clonacion.zip')#"
		filter="*.txt"
		overwrite="true"
	/>
	<cfheader name="Content-Disposition" value="inline; filename=scrip_clonacion.zip">
	<cfcontent type="application/x-zip-compressed" file = "#ExpandPath( '/clonacion/scripts/scrip_clonacion.zip')#"	deletefile="yes"> 
</cfif>

</form>
</cfoutput>

<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>