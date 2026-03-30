<cfparam name="url.Ecodigo" 	default="#session.Ecodigo#" 		type="numeric">
<cfparam name="url.CEcodigo" 	default="#session.CEcodigo#" 		type="numeric">
<cfparam name="url.Conexion" 	default="#session.dsn#" 			type="string">
<cfparam name="url.nivel" 		default="0" 						type="numeric">
<cfparam name="url.MostrarTipo" default="" 							type="string">

<cfif len(trim(url.MostrarTipo)) and not listfind('G,I',url.MostrarTipo)>
	<cfthrow message="Valores permitidos en el tag de actividades campo='MostrarTipo' valores= G: Gasto ó I: Ingreso">
</cfif>

<cfset desplegar="FPAECodigo,FPAEDescripcion">
<cfset etiquetas="Código Actividad, Descripción">
<cfset formatos="S,S">
<cfset align="left, left">
<cfset funcion="asignarActividad">
<cfset fparams="nivel, FPAECodigo, FPAEDescripcion">
<cfset keys="FPAEid">
<cfset titulo="Lista De Actividades Empresariales">

<cfif isdefined('url.codigo') and len(trim(url.codigo)) gt 0>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetActividadxCodigo" returnvariable="rsActEid">
		<cfinvokeargument name="Codigo"			value="#url.codigo#">
	</cfinvoke>
</cfif>
<cfif nivel neq 0>
	<cfset filtro="">
	<cfif isdefined('form.filtro_PCDvalor') and len(trim(form.filtro_PCDvalor))>
		<cfset filtro&="and upper(PCDvalor) like '%#Ucase(form.filtro_PCDvalor)#%'">
	</cfif>
	<cfif isdefined('form.filtro_PCDdescripcion') and len(trim(form.filtro_PCDdescripcion))>
		<cfset filtro&="and upper(PCDdescripcion) like '%#Ucase(form.filtro_PCDdescripcion)#%'">
	</cfif>
</cfif>
<cfswitch expression="#nivel#">
	<cfcase value="0">
		<cfquery datasource="#url.Conexion#" name="query">
			select 	FPAEid, FPAECodigo, FPAEDescripcion, 0 as nivel
			from FPActividadE
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
			<cfif len(trim(url.MostrarTipo))>
				and FPAETipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.MostrarTipo#">
			</cfif>
			<cfif isdefined('form.filtro_FPAECodigo') and len(trim(form.filtro_FPAECodigo))>
				and upper(FPAECodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.filtro_FPAECodigo)#%">
			</cfif>
			<cfif isdefined('form.filtro_FPAEDescripcion') and len(trim(form.filtro_FPAEDescripcion))>
				and upper(FPAEDescripcion)like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.filtro_FPAEDescripcion)#%">
			</cfif>
			order by FPAECodigo, FPAEDescripcion
		</cfquery>
	</cfcase>
	<cfcase value="1">
		<cfif isdefined('rsActEid') and rsActEid.recordcount gt 0>	
			<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetActividad" returnvariable="rsActE">
				<cfinvokeargument name="FPAEid"			value="#rsActEid.FPAEid#">
			</cfinvoke>
			<cfquery datasource="#url.Conexion#" name="rsActENiveles">
				select count(1) as niveles 
				from FPActividadD 
				where FPAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsActE.FPAEid#">
			</cfquery>
			<cfif not isdefined('url.click')>
				<cfset fnFuncion("window.parent.sbResultadoConLisActividad('#rsActE.FPAEid#','#rsActE.FPAECodigo#','#rsActE.FPAEDescripcion#','#rsActENiveles.niveles#');")>
			</cfif>	
			<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetNivel" returnvariable="rsActD">
				<cfinvokeargument name="FPAEid"			value="#rsActE.FPAEid#">
				<cfinvokeargument name="FPADNivel"		value="#nivel#">
			</cfinvoke>
			<cfset fnFuncion("window.parent.asignarCodRef('#nivel#','#rsActD.PCEcatid#');")>
			<cfquery datasource="#url.Conexion#" name="rsCatE">
				select PCEempresa 
				from PCECatalogo 
				where PCEcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsActD.PCEcatid#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CEcodigo#">
			</cfquery>
			<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetConceptos" returnvariable="query">
				<cfinvokeargument name="FPAEid"			value="#rsActE.FPAEid#">
				<cfinvokeargument name="FPADNivel"		value="#nivel#">
				<cfinvokeargument name="ActivarEcodigo" value="#rsCatE.PCEempresa#">
				<cfif isdefined('filtro') and len(trim(filtro))>
					<cfinvokeargument name="filtro" 		value="#filtro#">
				</cfif>
				<cfinvokeargument name="MostrarError" 		value="false">
			</cfinvoke>
			<cfset titulo="Lista De Cat&aacute;logos<br><strong style='font-size:15px'>Nivel #nivel# #rsActD.FPADIndetificador#-#rsActD.FPADDescripcion#</strong>">
			<cfset desplegar="PCDvalor,PCDdescripcion">
			<cfset etiquetas="Valor del Catálogo, Descripción">
			<cfset formatos="S,S">
			<cfset align="left,left">
			<cfset funcion="asignarCatalogo">
			<cfset fparams="nivel,PCDvalor,PCDdescripcion,PCEcatidref">
			<cfset keys="PCDcatid">
		<cfelseif isdefined('rsActEid')>
			<cfset fnMSG("El c&oacute;digo ingresado no existe.","window.parent.sbResultadoConLisActividad('0','#url.codigo#','',0);")>
			<cfreturn>
		<cfelse>
			<cfquery datasource="#url.Conexion#" name="query">
				select 	FPAEid, FPAECodigo, FPAEDescripcion, 0 as nivel
				from FPActividadE
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
				<cfif len(trim(url.MostrarTipo))>
				and FPAETipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.MostrarTipo#">
				</cfif>
				order by FPAECodigo, FPAEDescripcion
			</cfquery>
		</cfif>
	</cfcase>
	<cfdefaultcase>
		<cfif isdefined('url.tab')>
			<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetNivel" returnvariable="rsActD">
				<cfinvokeargument name="FPAEid"			value="#rsActEid.FPAEid#">
				<cfinvokeargument name="FPADNivel" 		value="#nivel#">
			</cfinvoke>
			<cfif isdefined('url.catalogoRef') and len(trim(url.catalogoRef))>
				<cfquery datasource="#url.Conexion#" name="rsCatE">
					select PCEempresa 
					from PCECatalogo 
					where PCEcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.catalogoRef#">
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CEcodigo#">
				</cfquery>
				<cfquery datasource="#url.Conexion#" name="rsConc">
					select PCDcatid,PCEcatid,PCDvalor,PCDdescripcion,PCEcatidref
					from PCDCatalogo 
					where <cfif rsCatE.PCEempresa>
						Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#url.Ecodigo#"> and
						  </cfif>
						PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.catalogoRef#">
						and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.codCatalogo#">
				</cfquery>
				<cfif rsConc.recordcount eq 0>
					<cfset fnMSG("Se ha presentado un error, el nivel #nivel - 1# c&oacute;digo no encontrado.","window.parent.deshabilitar(#nivel - 1#);")>
					<cfreturn>
				</cfif>
				<cfset fnFuncion("window.parent.asignarDesc(#nivel#,'#rsConc.PCDdescripcion#');")>
				<cfset fnFuncion("window.parent.listo(#nivel#);")>
				<cfif rsActD.FPADDepende EQ 'N'>
					<cfif not len(trim(rsConc.PCEcatidref))>
						<cfset fnMSG("Se ha presentado un error, el nivel #nivel# es dependiente del nivel anterior el cual no posee más cat&aacute;logos.","window.parent.deshabilitar(#nivel#);")>
						<cfset fnFuncion("window.parent.deshabilitar('#nivel#',true)")>
						<cfreturn>
					<cfelse>
						<cfset url.catalogoRef = rsConc.PCEcatidref>
					</cfif>
				<cfelseif rsActD.FPADDepende EQ 'C'>
					<cfset url.catalogoRef = rsActD.PCEcatid>
				<cfelse>
					<cfset fnMSG("Se ha presentado un error, el nivel #nivel# tipo de dependencia incorrecto.","window.parent.deshabilitar(#nivel#);")>
					<cfreturn>
				</cfif>
			<cfelse>
				<cfset fnMSG("Se ha presentado un error, el nivel #nivel# cat&aacute;logo de referencia no indicado.","window.parent.deshabilitar(#nivel#);")>
				<cfreturn>
			</cfif>
			<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetConceptos" returnvariable="query">
				<cfinvokeargument name="FPAEid"			value="#rsActEid.FPAEid#">
				<cfinvokeargument name="FPADNivel" 		value="#nivel#">
				<cfinvokeargument name="PCEcatid" 		value="#url.catalogoRef#">
				<cfinvokeargument name="ActivarEcodigo" value="#rsCatE.PCEempresa#">
				<cfif isdefined('filtro') and len(trim(filtro))>
					<cfinvokeargument name="filtro" 		value="#filtro#">
				</cfif>
				<cfinvokeargument name="MostrarError" 		value="false">
			</cfinvoke>
			<cfset fnFuncion("window.parent.asignarCodRef('#nivel#','#url.catalogoRef#');")>
			<cfset fnFuncion("window.parent.deshabilitar(#nivel#);")>
			<cfset titulo="Lista De Cat&aacute;logos<br><strong style='font-size:15px'>Nivel #nivel# #rsActD.FPADIndetificador#-#rsActD.FPADDescripcion#</strong>">
			<cfset desplegar="PCDvalor,PCDdescripcion">
			<cfset etiquetas="Valor del Catálogo, Descripción">
			<cfset formatos="S,S">
			<cfset align="left,left">
			<cfset funcion="asignarCatalogo">
			<cfset fparams="nivel,PCDvalor,PCDdescripcion,PCEcatidref">
			<cfset keys="PCDcatid">
		<cfelse>
			<cfif isdefined('url.codigo') and len(trim(url.codigo)) gt 0>
				<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetNivel" returnvariable="rsActD">
					<cfinvokeargument name="FPAEid"			value="#rsActEid.FPAEid#">
					<cfinvokeargument name="FPADNivel" 		value="#nivel#">
				</cfinvoke>
				<cfif rsActD.FPADDepende EQ 'N' and ( not isdefined('url.catalogoRef') or not len(trim(url.catalogoRef)))>
					<cfset fnMSG("Se ha presentado un error, el nivel #nivel# depende del catalogo anterior el cual no posee catalogos hijos para selecionar.")>
					<cfset fnFuncion("window.parent.deshabilitar('#nivel#',true)")>
					<cfreturn>
				<cfelseif rsActD.FPADDepende EQ 'C'>
					<cfset url.catalogoRef = rsActD.PCEcatid>
				</cfif>
				<cfif isdefined('url.catalogoRef') and len(trim(url.catalogoRef)) eq 0>
					<cfset fnMSG("Se ha presentado un error, el nivel #nivel# depende del catalogo anterior el cual no posee catalogos hijos para selecionar.")>
					<cfset fnFuncion("window.parent.deshabilitar('#nivel#',true)")>
					<cfreturn>
				</cfif>
				<cfquery datasource="#url.Conexion#" name="rsCatE">
					select PCEempresa 
					from PCECatalogo 
					where PCEcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.catalogoRef#">
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CEcodigo#">
				</cfquery>
				<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetConceptos" returnvariable="query">
					<cfinvokeargument name="FPAEid"			value="#rsActEid.FPAEid#">
					<cfinvokeargument name="FPADNivel" 		value="#nivel#">
					<cfinvokeargument name="PCEcatid" 		value="#url.catalogoRef#">
					<cfinvokeargument name="ActivarEcodigo" value="#rsCatE.PCEempresa#">
					<cfif isdefined('filtro') and len(trim(filtro))>
						<cfinvokeargument name="filtro" 		value="#filtro#">
					</cfif>
					<cfinvokeargument name="MostrarError" 		value="false">
				</cfinvoke>
				<cfset fnFuncion("window.parent.asignarCodRef('#nivel#','#url.catalogoRef#');	")>
				<cfset titulo="Lista De Cat&aacute;logos<br><strong style='font-size:15px'>Nivel #nivel# #rsActD.FPADIndetificador#-#rsActD.FPADDescripcion#</strong>">
				<cfset desplegar="PCDvalor,PCDdescripcion">
				<cfset etiquetas="Valor del Catálogo, Descripción">
				<cfset formatos="S,S">
				<cfset align="left,left">
				<cfset funcion="asignarCatalogo">
				<cfset fparams="nivel,PCDvalor,PCDdescripcion,PCEcatidref">
				<cfset keys="PCDcatid">
			</cfif>
		</cfif>
	</cfdefaultcase>
</cfswitch>

<table border="0" cellpadding="0" cellspacing="0" width="100%">	
	<tr><td align="center"><strong style="font-size:18px"><cfoutput>#titulo#</cfoutput></strong></td></tr>
	<tr>
		<td>
		<cfset navegacion="">
		<cfset navegacion&="?MostrarTipo=#url.MostrarTipo#">
		<cfif isdefined('url.nivel') and len(trim(url.nivel))>
			<cfset navegacion&="&nivel=#url.nivel#">
		</cfif>
		<cfif isdefined('url.codigo') and len(trim(url.codigo))>
			<cfset navegacion&="&codigo=#url.codigo#">
		</cfif>
		<cfif isdefined('url.codCatalogo') and len(trim(url.codCatalogo))>
			<cfset navegacion&="&codCatalogo=#url.codCatalogo#">
		</cfif>
		<cfif isdefined('url.catalogoRef') and len(trim(url.catalogoRef))>
			<cfset navegacion&="&catalogoRef=#url.catalogoRef#">
		</cfif>
		<cfif isdefined('url.habilitar') and len(trim(url.habilitar))>
			<cfset navegacion&="&habilitar=#url.habilitar#">
		</cfif>
		<cfif isdefined('url.click') and len(trim(url.click))>
			<cfset navegacion&="&click=#url.click#">
		</cfif>
		<cfif isdefined('url.tab') and len(trim(url.tab))>
			<cfset navegacion&="&tab=#url.tab#">
		</cfif>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#query#" 
				conexion="#url.Conexion#"
				desplegar="#desplegar#"
				etiquetas="#etiquetas#"
				formatos="#formatos#"
				mostrar_filtro="yes"
				align="#align#"
				checkboxes="N"
				funcion="#funcion#"
				fparams="#fparams#"
				keys="#keys#"
				irA="ConlisActividades.cfm#navegacion#">
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="javascript1.2" type="text/javascript">
	
	function asignarActividad(nivel, codigo, descripcion) {
		if (window.parent.asignarActividad)
			window.parent.asignarActividad(nivel, codigo, descripcion);
	}
	
	function asignarCatalogo(nivel, catalogoHijo,catalogoDesc, catalogoRef){
		if (window.parent.asignarCatalogo)
			window.parent.asignarCatalogo(nivel, catalogoHijo, catalogoDesc, catalogoRef, true);
	}
	// Sobre escribe la funcion
	function filtrar_Plista(){
		return true;
	}
</script>

<cffunction name="fnMSG" returntype="void" access="private" output="true">
	<cfargument name="MSG" 			required="yes" 	type="string">
	<cfargument name="funcion" 		required="no" 	type="string">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">	<tr>
		<td align="center">#Arguments.MSG#</td>
	</tr></table>
	<cfif isdefined('Arguments.funcion')>
		<cfset fnFuncion(Arguments.funcion)>
	</cfif>
</cffunction>

<cffunction name="fnFuncion" returntype="void" access="private" output="true">
	<cfargument name="funcion"			type="string"	required="yes">
	<script language="javascript1.2" 	type="text/javascript">
		#Arguments.funcion#
	</script>
</cffunction>