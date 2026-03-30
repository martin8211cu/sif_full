<cfif isdefined('url.CEcodigoD') and len(trim(url.CEcodigoD))>
	<cfset form.CEcodigoD = url.CEcodigoD>
</cfif>
<cfif isdefined('url.CEcodigoO') and len(trim(url.CEcodigoO))>
	<cfset form.CEcodigoO = url.CEcodigoO>
</cfif>
<cfif isdefined('url.CHKSQL') and len(trim(url.CHKSQL))>
	<cfset form.CHKSQL = url.CHKSQL>
</cfif>
<cfif isdefined('url.DSND') and len(trim(url.DSND))>
	<cfset form.DSND = url.DSND>
</cfif>
<cfif isdefined('url.DSNO') and len(trim(url.DSNO))>
	<cfset form.DSNO = url.DSNO>
</cfif>
<cfif isdefined('url.ECODIGOD') and len(trim(url.ECODIGOD))>
	<cfset form.ECODIGOD = url.ECODIGOD>
</cfif>
<cfif isdefined('url.ECODIGODE') and len(trim(url.ECODIGODE))>
	<cfset form.ECODIGODE = url.ECODIGODE>
</cfif>
<cfif isdefined('url.ECODIGOO') and len(trim(url.ECODIGOO))>
	<cfset form.ECODIGOO = url.ECODIGOO>
</cfif>
<cfif isdefined('url.SSCODIGOO') and len(trim(url.SSCODIGOO))>
	<cfset form.SSCODIGOO = url.SSCODIGOO>
</cfif>

<cfparam name="form.CEcodigoD" default="">
<cfparam name="form.CEcodigoO" default="">
<cfparam name="form.CHKSQL" default="">
<cfparam name="form.DSND" default="">
<cfparam name="form.DSNO" default="">
<cfparam name="form.ECODIGOD" default="">
<cfparam name="form.ECODIGODE" default="">
<cfparam name="form.ECODIGOO" default="">
<cfparam name="form.SSCODIGOO" default="">


<!---<cf_dump var="#form#">--->
<cfif isdefined('form.ECODIGOD') and len(trim(form.ECODIGOD)) or isdefined('form.ECODIGODE') and len(trim(form.ECODIGODE))>
	<cfparam name="session.listaEmpleados" default="">
	<cffunction name="delEmpleado" access="public" returntype="string">
		<cfargument name="DEid" required="yes">
		<cfset session.listaEmpleados = listAppend(session.listaEmpleados,Arguments.DEid,',')>
		<cfreturn session.listaEmpleados>
	</cffunction>
	
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_EmpresasOr"
		default="Lista Empresas Origen"
		returnvariable="LB_EmpresasOR"/><br />
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_EmpresasDe"
		default="Lista Empresas Destino"
		returnvariable="LB_EmpresasDe"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Codigo"
		default="C&oacute;digo"
		returnvariable="LB_Codigo"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Nombre"
		default="Nombre"
		returnvariable="LB_Nombre"/>	
	
	<form name="formsubmit" method="post" action="clonacion-sql.cfm">
		<cfoutput>
		<input type="hidden" name="ACCION" 			value= "1">
		<input type="hidden" name="Usucodigo" 		value= "#session.Usucodigo#">
		<input type="hidden" name="CEcodigoD" 		value= "#form.CEcodigoD#">
		<input type="hidden" name="CEcodigoO" 		value= "#form.CEcodigoO#">
		
		<input type="hidden" name="EcodigoDE" 		value= "<cfif isdefined('form.EcodigoDE') and len(trim(form.EcodigoDE))>#form.EcodigoDE#</cfif>">
	
		<input type="hidden" name="DSNO" 			value= "#form.DSNO#">
		<input type="hidden" name="DSND" 			value= "<cfif isdefined('form.DSND') and len(trim(form.DSND))>#form.DSND#<cfelse>#form.DSNO#</cfif>">
		
		<input type="hidden" name="EcodigoD" 		value= "<cfif isdefined('form.EcodigoD') and len(trim(form.EcodigoD))>#form.EcodigoD#</cfif>">
		<input type="hidden" name="EcodigoO" 		value= "<cfif isdefined('form.EcodigoO') and len(trim(form.EcodigoO))>#form.EcodigoO#</cfif>">
		<input type="hidden" name="SScodigoO" 		value= "<cfif isdefined('form.SScodigoO') and len(trim(form.SScodigoO))>#form.SScodigoO#</cfif>">
		<cfif isdefined("form.chkSQL")>
			<input type="hidden" name="chkSQL" 	value= "#form.chkSQL#">
		</cfif>
		</cfoutput>
	<cfoutput>
	
	<cffunction name="reg" returntype="query">
		<cfargument name="tabla" 	type="string" required="true">	
		<cfargument name="DB" 		type="string" required="true">	
		<cfargument name="Eco" 		type="numeric" required="true">	
		
		<cfquery name="rs" datasource="#DB#">
			select count(1) as total from #tabla# where Ecodigo=#Eco#
		</cfquery>
		<cfreturn #rs#>
	</cffunction>
	
	
	<cf_dbtemp name="clonacion" returnvariable="session.clonacion" datasource="#form.DSNO#">
		<cf_dbtempcol name="Empresa"	type="numeric" 		mandatory="no">
		<cf_dbtempcol name="Sistema"	type="varchar(10)" 	mandatory="no">
		<cf_dbtempcol name="Orden" 		type="numeric" 		mandatory="no">  
		<cf_dbtempcol name="Grupo"	 	type="varchar(50)" 	mandatory="no">
		<cf_dbtempcol name="subGrupo"	type="varchar(50)" 	mandatory="no">
		<cf_dbtempcol name="Proceso" 	type="varchar(50)" 	mandatory="no">
		<cf_dbtempcol name="Tabla" 		type="varchar(50)" 	mandatory="no">
		<cf_dbtempcol name="Padre"	 	type="varchar(50)" 	mandatory="no">
		<cf_dbtempcol name="Hijo"	 	type="varchar(50)" 	mandatory="no">
		<cf_dbtempcol name="Lista" 		type="varchar(10)" 	mandatory="no">
		<cf_dbtempcol name="Nivel" 		type="integer" 		mandatory="no">
		<cf_dbtempcol name="Fuente"	 	type="varchar(50)" 	mandatory="no">
		<cf_dbtempcol name="Llave"	 	type="varchar(50)" 	mandatory="no">
	</cf_dbtemp>
	
	<!---ljimenez Lee la informacion del XML--->
	<!--- Directorio actual --->
	<cfset session.LvarFiles = ','>
	<cfset rootdir = expandpath('')>
	<cfset directorio = "#rootdir#/clonacion/rh/">
	<cfset directorio = replace(directorio, '\', '/', 'all') >
	<cfset xmlfile="#directorio#RHdefinicion.xml">
	<cfset arreglodatos  = XmlSearch(xmlfile, "//tabla")>
	
	<!--- Leer archivo XML --->
	<cffile action="read" file="#xmlfile#" variable="definicion">
	
	<!--- Analizarlo --->
	<cfset mydoc=XMLParse(definicion)>
	
	
	<!--- Muestra datos --->
	
	<cfloop from="1" to="#arraylen(arreglodatos)#" index="i">
		
		<cfset id	 		= arreglodatos[i].xmlAttributes.id />
		<cfset lista 		= arreglodatos[i].xmlAttributes.lista />
		<cfset nivel 		= arreglodatos[i].xmlAttributes.nivel />
		<cfset Ssistema		= arreglodatos[i].Sistema.xmlText>
		<cfset grupo		= arreglodatos[i].Grupo.xmlText>
		<cfset subgrupo		= arreglodatos[i].subGrupo.xmlText>
		<cfset NombreProceso= arreglodatos[i].NombreProceso.xmlText>
		<cfset tabla 		= arreglodatos[i].NombreTabla.xmlText>
		<cfset padre		= arreglodatos[i].Padre.xmlText>
		<cfset hijo			= arreglodatos[i].Hijo.xmlText>
		<cfset llave		= arreglodatos[i].Llave.xmlText>
		<cfset fuente		= arreglodatos[i].Fuente.xmlText>
		
		<cfset empresa		= 1>
	
		<cfquery datasource="#form.DSNO#">
			insert into #Session.clonacion#(Sistema,Orden,Grupo,subGrupo,Tabla,Proceso,Padre,Hijo,Lista,Nivel,Llave,Fuente)
				values ('#Ssistema#',#id#,'#grupo#','#subgrupo#','#tabla#','#NombreProceso#','#padre#','#hijo#','#lista#',#nivel#,'#llave#','#Fuente#')
		</cfquery>
	</cfloop>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr><td>
		<cfif isdefined("form.SScodigoO") and len((form.SScodigoO)) gt 0 >
		<!---</cfif>and isdefined("form.EcodigoD") and len((form.EcodigoD)) gt 0>--->
			<cfswitch expression="#rtrim(form.SScodigoO)#">
				<cfcase value="RH"> <cfinclude template="clonacion_rh.cfm">  </cfcase>
				<cfdefaultcase> </cfdefaultcase>
			</cfswitch>
		</cfif>
	<tr>
		<td colspan="2" align="center">
		<input name="BClonar" value="Clonar" type="submit"/></td>
		</tr>
	</table>
	
	
	</cfoutput>
		<!--- Para saber que borrar --->
		<input type="hidden" name="procesos_borrar" value="">
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
	</form>
	
	<cf_qforms form="form1">
		<cf_qformsRequiredField name="EcodigoDE" description="El valor de Ecodigo Destino es requerido">
	</cf_qforms>
</cfif>