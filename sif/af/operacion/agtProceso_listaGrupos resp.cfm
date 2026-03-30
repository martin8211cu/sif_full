<!---IDtrans--->
<cfif isdefined("url.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset idtrans = url.IDtrans></cfif>
<cfif isdefined("form.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset idtrans = form.IDtrans></cfif>
<cfparam name="IDtrans" type="numeric">
<!---filtro--->
<cfset filtro = "a.Ecodigo=#session.Ecodigo# and a.IDtrans=#IDtrans# and a.AGTPestadp in (0,1,2) and a.AGTPecodigo > 0">
<!--- Estados (	1=en proceso, 
								2=programado para generar
								3=programado para aplicar
								4=aplicado) --->
<!---navegacion--->
<cfset navegacion = "&IDtrans=#IDtrans#">
<!---curentPage obtiene la pagina actual porque este fuente puede estar incluido en varios archivos.--->
<cfset currentPage = GetFileFromPath(GetTemplatePath())>
<!---botonAccion define la descripcion y la accin del boton de acuerdo con el IDtrans recibido --->
<cfset botonAccion = ArrayNew(2)>
<cfset botonAccion[4][1] = "Generar">
<cfset botonAccion[4][2] = "DEPRECIACION">
<cfset botonAccion[4][3] = "Lista de Grupos de Transacciones de Depreciaci&oacute;n">
<cfset botonAccion[4][4] = "">
<cfset botonAccion[4][5] = "programa">
<cfset botonAccion[4][6] = 0>
<cfset botonAccion[4][7] = "detalles">

<cfset botonAccion[3][1] = "Generar">
<cfset botonAccion[3][2] = "REVALUACION">
<cfset botonAccion[3][3] = "Lista de Grupos de Transacciones de Revaluaci&oacute;n">
<cfset botonAccion[3][4] = "">
<cfset botonAccion[3][5] = "programa">
<cfset botonAccion[3][6] = 0>
<cfset botonAccion[3][7] = "detalles">

<cfset botonAccion[5][1] = "Nuevo">
<cfset botonAccion[5][2] = "RETIRO">
<cfset botonAccion[5][3] = "Lista de Grupos de Transacciones de Retiro">
<cfset botonAccion[5][4] = "">
<cfset botonAccion[5][5] = "sql">
<cfset botonAccion[5][6] = 1>
<cfset botonAccion[5][7] = "genera">

<cfset botonAccion[2][1] = "Nuevo">
<cfset botonAccion[2][2] = "MEJORA">
<cfset botonAccion[2][3] = "Lista de Grupos de Transacciones de Mejora">
<cfset botonAccion[2][4] = "">
<cfset botonAccion[2][5] = "sql">
<cfset botonAccion[2][6] = 1>
<cfset botonAccion[2][7] = "genera">

<!---Elimiar se decidi hacer aqu porque para todos es igual--->
<cfif isdefined("form.btnEliminar") and isdefined("form.chk") and len(trim(Form.chk))>
	<cfloop index = "item"	list = "#Form.chk#"	delimiters = ",">
		<cfquery name="rsCheckToDelete" datasource="#session.dsn#">
			select 1
			from AGTProceso 
			where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
			and Ecodigo =  #session.Ecodigo# 
			and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
			and AGTPestadp < 4
		</cfquery>
		<cfif (rsCheckToDelete.RecordCount eq 1)>
			<cfquery name="rsDelete" datasource="#session.dsn#">
				delete 
				from ADTProceso
				where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
					and Ecodigo =  #session.Ecodigo# 
					and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
			  </cfquery>
			 <cfquery name="rsDelete" datasource="#session.dsn#"> 
				delete 
				from AGTProceso
				where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
					and Ecodigo =  #session.Ecodigo# 
					and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<!---lista--->
<cf_templateheader title="	Activos Fijos">
	  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#botonAccion[IDtrans][3]#">
			<cfinclude template="agtProceso_filtroGrupos.cfm">
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="columnas" value="a.AGTPid, a.Ecodigo, a.IDtrans, a.AGTPdescripcion, a.AGTPperiodo, b.VSdesc as AGTPmesdesc, a.AGTPfalta, 
																								case a.AGTPestadp 
																									when 0 then 'En Proceso' 
																									when 1 then 'Por Generar <b>Fecha:</B> ' + convert(varchar,a.AGTPfechaprog, 103) + ' <b>Hora:</b> ' + convert(varchar,a.AGTPfechaprog, 108)
																									when 2 then 'Por Aplicar <b>Fecha:</B> ' + convert(varchar,a.AGTPfechaprog, 103) + ' <b>Hora:</b> ' + convert(varchar,a.AGTPfechaprog, 108)
																									when 3 then 'Aplicado' 
																								end as AGTPestadodesc"/>
				<cfinvokeargument name="tabla" value="AGTProceso a
													  inner join VSidioma b on convert(int,b.VSvalor) = a.AGTPmes and b.VSgrupo=1
													  inner join Idiomas c on c.Iid = b.Iid and c.Icodigo = '#Session.Idioma#'"/>
				<cfinvokeargument name="filtro" value="#filtro# order by a.AGTPestadp, a.AGTPecodigo, a.AGTPperiodo, a.AGTPmes"/>
				<cfinvokeargument name="keys" value="AGTPid"/>
				<cfinvokeargument name="desplegar" value="AGTPdescripcion, AGTPperiodo, AGTPmesdesc, AGTPfalta, AGTPestadodesc"/>
				<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Periodo, Mes, Fecha, Estado"/>
				<cfinvokeargument name="formatos" value="V, V, V, D, V"/>
				<cfinvokeargument name="align" value="left, left, left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="agtProceso_#botonAccion[IDtrans][7]#_#botonAccion[IDtrans][2]#.cfm"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="formname" value="fagtproceso"/>
				<cfinvokeargument name="botones" value="#botonAccion[IDtrans][1]#,#botonAccion[IDtrans][4]##iif(len(trim(botonAccion[IDtrans][4])),DE(','),DE(''))#Aplicar,Eliminar"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>	
			</cfinvoke>
		<cf_web_portlet_end>
	<cf_templatefooter>
<!---funciones en javascript de los botones--->
<script language="javascript" type="text/javascript">
<!--//
	function algunoMarcado(){
		var aplica = false;
		var form = document.fagtproceso;
		if (form.chk) {
			if (form.chk.value) {
				aplica = form.chk.checked;
			} else {
				for (var i=0; i<form.chk.length; i++) {
					if (form.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (aplica);
		} else {
			alert('Debe seleccionar al menos un grupo de transacciones antes de realizar esta accin!');
			return false;
		}
	}
	<cfoutput>
	function funcEliminar(){
		if (algunoMarcado() && confirm("Est seguro de que desea eliminar los grupos de transacciones seleccionados?"))
			document.fagtproceso.action = "#CurrentPage#";
		else
			return false;
	}
	function funcAplicar(){
		if (algunoMarcado() && confirm("Est seguro de que desea aplicar los grupos de transacciones seleccionados?"))
			document.fagtproceso.action = "agtProceso_#botonAccion[IDtrans][5]#_#botonAccion[IDtrans][2]#.cfm";
		else
			return false;
	}
	function func#botonAccion[IDtrans][1]#(){
		document.fagtproceso.action = "agtProceso_genera_#botonAccion[IDtrans][2]#.cfm";
	}
	<cfif len(trim(botonAccion[IDtrans][4]))>
	function func#botonAccion[IDtrans][4]#(){
		if (algunoMarcado()){
			document.fagtproceso.action = "agtProceso_programa_#botonAccion[IDtrans][2]#.cfm";
		}
		else
			return false;
	}
	</cfif>
	</cfoutput>
//-->
</script>