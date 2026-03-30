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
		<cfset session.fuenteArray = ArrayNew(1)>	<!---array con el contenido a Ejecutar--->
		
		<cfloop index = "index" list = "#Form.Clonar#" delimiters = ",">
			<cfset data = ListToArray(index,',') >
			<cfquery name="rsClonar" datasource="#form.DSNO#">
				select *
				from #session.clonacion#
				where Tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#data[1]#">
			</cfquery>
			
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
				<!---pone en un arreglo 'session.fuenteArray' el fuente a ejecutar en la barra de proceso.--->
				<cfset content =  '<cfinvoke component="rh.Componentes.RH_Clonacion" method="ActualizaDatos"
						conexionO		= "#form.DSNO#"
						conexionD		= "#form.DSND#"
						Tabla   		= "#rsClonar.Tabla#"
						Fuente 			= "#rsClonar.Fuente#"
						EcodigoNuevo	= "#EcodigoX#"
						EcodigoViejo 	= "#form.EcodigoO#"
						llave 			= "#rsClonar.llave#"
						Padre 			= "#rsClonar.Padre#"
					/>'>
				
				<cfset ArrayAppend(session.fuenteArray,content)>

			</cfif>
			<cfset Avance = Avance + incremeto>
		</cfloop>
		
</cfif>

<cfoutput>
<form action="clonacion.cfm" method="post" name="sql" id="sql">
	<input type="hidden" name="Usucodigo" 		value= "#session.Usucodigo#">
	<input type="hidden" name="CEcodigoD" 		value= "#form.CEcodigoD#">
	<input type="hidden" name="CEcodigoO" 		value= "#form.CEcodigoO#">
	<input type="hidden" name="DSND" 			value= "#form.DSND#">
	<input type="hidden" name="DSNO" 			value= "#form.DSNO#">
	
	
	<cfif isdefined("form.chkSQL") and form.chkSQL eq 1 >
		<input type="hidden" name="chkSQL" 			value= "1">
		<input type="hidden" name="chkSQLZip" 			value= "1">
		<input type="hidden" name="EcodigoDE" 		value= "#form.EcodigoDE#">
	<cfelse>
		<input type="hidden" name="chkSQL" 			value= "0">
		<input type="hidden" name="chkSQLZip" 			value= "0">
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



<!---Barra de Avance--->
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Avance de insertado de datos en para DEMOS
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cargando datos en la empresa'>
			<table width="95%" cellpadding="0" cellspacing="0" align="center">
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>				
				<tr><td align="center"><strong>
					<font color="##000099" style="font-family: Tahoma; font-size:12px">Por favor, espere unos minutos mientras se cargan los datos para la empresa: &nbsp;<cfoutput></cfoutput></font></strong>
				</td></tr>
				<tr><td align="center" style="vertical-align:top"> 
					<iframe name="ifrAvance" style="vertical-align:top;" 
						width ="700"
						height="300"
						frameborder="0"						
						src="barra.cfm?func=submitFormZip&func2=submitForm&usuario=<cfoutput>#session.usuario#</cfoutput>"
					</iframe>
				</td></tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
<!------>

</form>

<script>
	function submitFormZip(){
		document.sql.submit();
	}
	function submitForm(){
		document.sql.chkSQLZip.value = 0;
		document.sql.submit();
	}
</script>

</cfoutput>


<!---<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>--->