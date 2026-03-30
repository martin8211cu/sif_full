<cfif isdefined('form.nivel') and len(trim(form.nivel)) and (not isdefined('url.nivel') or not len(trim(url.nivel)))>
	<cfset url.nivel = form.nivel>
</cfif>
<cfif isdefined('form.OBPid') and len(trim(form.OBPid)) and (not isdefined('url.OBPid') or not len(trim(url.OBPid)))>
	<cfset url.OBPid = form.OBPid>
</cfif>
<cfparam name="url.Ecodigo" 	default="#session.Ecodigo#" 		type="numeric">
<cfparam name="url.Conexion" 	default="#session.dsn#" 			type="string">
<cfparam name="url.nivel" 		default="0" 						type="numeric">
<cfparam name="url.sufijo" 		default="" 							type="string">
<cfparam name="url.esPorTab" 	default="false" 					type="boolean">
<cfparam name="url.formName" 	default="form1" 					type="String">
<cfparam name="url.sufijo" 		default="" 							type="string">

<cfset navegacion="?Ecodigo=#url.Ecodigo#">

<cfset listo = false>
<cfswitch expression="#url.nivel#">
	<cfcase value="0">
		<cfset desplegar="OBPcodigo,OBPdescripcion">
		<cfset etiquetas="Código Proyecto, Descripción Proyecto">
		<cfset formatos="S,S">
		<cfset align="left, left">
		<cfset funcion="fnAsignar">
		<cfset fparams="nivel,OBPid">
		<cfset keys="OBPid">
		<cfset titulo="Lista De Proyectos">
		
		<cfif isdefined('form.filtro_OBPcodigo') and len(trim(form.nivel))>
			<cfset navegacion&="&filtro_OBPcodigo=#form.filtro_OBPcodigo#">
		</cfif>
		<cfif isdefined('form.filtro_OBPdescripcion') and len(trim(form.filtro_OBPdescripcion))>
			<cfset navegacion&="&filtro_OBPdescripcion=#form.filtro_OBPdescripcion#">
		</cfif>
		
		<cfinvoke component="sif.Componentes.OB_Obras" method="GetProyecto" returnvariable="query">
				<cfinvokeargument name="Ecodigo"value="#url.Ecodigo#">
			<cfif isdefined('form.filtro_OBPcodigo') and len(trim(form.filtro_OBPcodigo)) and not url.esPorTab>
				<cfinvokeargument name="OBPcodigo"value="#form.filtro_OBPcodigo#">
			</cfif>
			<cfif isdefined('form.filtro_OBPdescripcion') and len(trim(form.filtro_OBPdescripcion)) and not url.esPorTab>
				<cfinvokeargument name="OBPdescripcion"value="#form.filtro_OBPdescripcion#">
			</cfif>
			<cfif url.esPorTab and isdefined('url.OBPcodigo') and len(trim(url.OBPcodigo))>
				<cfinvokeargument name="filtro" value="false">
				<cfinvokeargument name="OBPcodigo"value="#url.OBPcodigo#">
			</cfif>
		</cfinvoke>
	</cfcase>
	<cfcase value="1">
		<cfset desplegar="OBOcodigo,OBOdescripcion">
		<cfset etiquetas="Código Obra, Descripción Obra">
		<cfset formatos="S,S">
		<cfset align="left, left">
		<cfset funcion="fnAsignar">
		<cfset fparams="nivel,OBPid,OBOid">
		<cfset keys="OBOid">
		<cfset titulo="Lista de Obras en Construcción">
		
		<cfif isdefined('url.OBPid') and len(trim(url.OBPid))>
			<cfset navegacion&="&OBPid=#url.OBPid#">
		</cfif>
		<cfif isdefined('form.filtro_OBOcodigo') and len(trim(form.filtro_OBOcodigo))>
			<cfset navegacion&="&filtro_OBOcodigo=#form.filtro_OBOcodigo#">
		</cfif>
		<cfif isdefined('form.filtro_OBOdescripcion') and len(trim(form.filtro_OBOdescripcion))>
			<cfset navegacion&="&filtro_OBOdescripcion=#form.filtro_OBOdescripcion#">
		</cfif>
		
		<cfinvoke component="sif.Componentes.OB_Obras" method="GetObra" returnvariable="query">
				<cfinvokeargument name="Ecodigo"		value="#url.Ecodigo#">
			<cfif isdefined('url.OBPid') and len(trim(url.OBPid)) and not url.esPorTab>
				<cfinvokeargument name="OBPid"			value="#url.OBPid#">
			</cfif>
			<cfif isdefined('form.filtro_OBOcodigo') and len(trim(form.filtro_OBOcodigo)) and not url.esPorTab>
				<cfinvokeargument name="OBOcodigo"		value="#form.filtro_OBOcodigo#">
			</cfif>
			<cfif isdefined('form.filtro_OBOdescripcion') and len(trim(form.filtro_OBOdescripcion)) and not url.esPorTab>
				<cfinvokeargument name="OBOdescripcion"	value="#form.filtro_OBOdescripcion#">
			</cfif>
			<cfif url.esPorTab and isdefined('url.OBOcodigo') and len(trim(url.OBOcodigo)) and isdefined('url.OBPid') and len(trim(url.OBPid))>
				<cfinvokeargument name="filtro" 	value="false">
				<cfinvokeargument name="OBOcodigo"	value="#url.OBOcodigo#">
				<cfinvokeargument name="OBPid"		value="#url.OBPid#">
			</cfif>
		</cfinvoke>
	</cfcase>
	<cfdefaultcase>
		<cfset listo = true>
		<cfinvoke component="sif.Componentes.OB_Obras" method="GetObra" returnvariable="query">
			<cfinvokeargument name="Ecodigo"		value="#url.Ecodigo#">
			<cfinvokeargument name="OBOid"			value="#url.OBOid#">
		</cfinvoke>
	</cfdefaultcase>
</cfswitch>
<cfif url.esPorTab>
	<cfset listo = true>
</cfif>
<cfoutput>
<script language="javascript1.2" type="text/javascript">
	
	function fnAsignar#url.sufijo#(nivel, OBPid, OBOid) {
		if (window.parent.fnAsignar#url.sufijo# && OBOid)
			window.parent.fnAsignar#url.sufijo#(nivel, OBPid, OBOid);
		else if(window.parent.fnAsignar#url.sufijo#)
			window.parent.fnAsignar#url.sufijo#(nivel, OBPid);
	}
	
	function fnOk#url.sufijo#(esPorTab,OBOid, OBOcodigo, OBOdescripcion, OBPid, OBPcodigo, OBPdescripcion) {
		if(esPorTab){
			if (window.parent.asignarValores#url.sufijo#)
					window.parent.asignarValores#url.sufijo#(OBOid, OBOcodigo, OBOdescripcion, OBPid, OBPcodigo, OBPdescripcion);
		}else{
			if (window.parent.fnOk#url.sufijo#)
				window.parent.fnOk#url.sufijo#(OBOid, OBOcodigo, OBOdescripcion, OBPid, OBPcodigo, OBPdescripcion);
			else
				window.parent.close();
		}
	}
	
	function filtrar_Plista(){
		return true;
	}
	
	function funcFiltrar(){
		<cfif isdefined('url.OBPid') and len(trim(url.OBPid))>
		document.lista.OBPID.value = "#url.OBPid#";
		</cfif>
		document.lista.NIVEL.value = "#url.nivel#";
		return true;
	}	
</script>
<cfif not listo>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">	
		<tr><td align="center"><strong style="font-size:18px">#titulo#</strong></td></tr>
		<tr>
			<td>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#query#" 
					conexion="#url.Conexion#"
					desplegar="#desplegar#"
					etiquetas="#etiquetas#"
					formatos="#formatos#"
					mostrar_filtro="yes"
					navegacion="#navegacion#"
					align="#align#"
					checkboxes="N"
					funcion="#funcion#"
					fparams="#fparams#"
					keys="#keys#"
					>
				</cfinvoke>
			</td>
		</tr>
	</table>
<cfelseif url.esPorTab>
	<cfif query.recordcount eq 0 >
		<script language="javascript1.2" type="text/javascript">
			fnOk#url.sufijo#(true,"", "", "", "", "", "");
		</script>
	<cfelseif query.recordcount gt 0 and isdefined('url.OBPcodigo') and len(trim(url.OBPcodigo))>
		<script language="javascript1.2" type="text/javascript">
			fnOk#url.sufijo#(true,"", "", "", "#trim(query.OBPid)#", "#trim(query.OBPcodigo)#", "");
		</script>
	<cfelseif query.recordcount gt 0 and  isdefined('url.OBOcodigo') and len(trim(url.OBOcodigo))>
		<script language="javascript1.2" type="text/javascript">
			fnOk#url.sufijo#(true,"#trim(query.OBOid)#", "#trim(query.OBOcodigo)#", "#query.OBOdescripcion#", "#trim(query.OBPid)#", "#trim(query.OBPcodigo)#", "#query.OBPdescripcion#");
		</script>
	</cfif>
<cfelse>
	<script language="javascript1.2" type="text/javascript">
		fnOk#url.sufijo#(false,"#trim(query.OBOid)#", "#trim(query.OBOcodigo)#", "#query.OBOdescripcion#", "#trim(query.OBPid)#", "#trim(query.OBPcodigo)#", "#query.OBPdescripcion#");
	</script>
</cfif>
</cfoutput>