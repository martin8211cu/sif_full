<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
<cfelse>
	<cfset tabChoice = 1>
</cfif>

<!--- TRADUCCION --->
	<!--- Expediente --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Expediente"
		Default="Expediente"
		Idioma="#session.Idioma#"
		returnvariable="vExpediente"/>

	<!--- Datos Personales --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="DatosPersonales"
		Default="Datos Personales"
		Idioma="#session.Idioma#"
		returnvariable="vDatosPersonales"/>

	<!--- Datos Familiares --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="DatosFamiliares"
		Default="Datos Familiares"
		Idioma="#session.Idioma#"
		returnvariable="vDatosFamiliares"/>

	<!--- Datos Laborales --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="DatosLaborales"
		Default="Datos Laborales"
		Idioma="#session.Idioma#"
		returnvariable="vDatosLaborales"/>

	<!--- Cargas --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Cargas"
		Default="Cargas"
		Idioma="#session.Idioma#"
		returnvariable="vCargas"/>

	<!--- Deducciones --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Deducciones"
		Default="Deducciones"
		Idioma="#session.Idioma#"
		returnvariable="vDeducciones"/>

	<!--- Anotaciones --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Anotaciones"
		Default="Anotaciones"
		Idioma="#session.Idioma#"
		returnvariable="vAnotaciones"/>

	<!--- Perfil Benziger --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="PerfilBenziger"
		Default="Perfil Benziger"
		Idioma="#session.Idioma#"
		returnvariable="vPerfilBenziger"/>

	<!--- Comparativo Benziger --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="ComparativoBenziger"
		Default="Comparativo Benziger"
		Idioma="#session.Idioma#"
		returnvariable="vComparativoBenziger"/>

	<!--- Beneficios --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Beneficios"
		Default="Beneficios"
		Idioma="#session.Idioma#"
		returnvariable="vBeneficios"/>
		
	<!---Direccion--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="Direccion"
		Default="Dirección"
		Idioma="#session.Idioma#"
		returnvariable="vDireccion"/>
<!--- --->

<cfset tabNames = ArrayNew(1)>

<cfset tabNames[1] = vExpediente >
<cfset tabNames[2] = vDatosPersonales >
<cfset tabNames[3] = vDireccion >
<cfset tabNames[4] = vDatosFamiliares >
<cfset tabNames[5] = vDatosLaborales >
<cfset tabNames[6] = vCargas >
<cfset tabNames[7] = vDeducciones >

<cfif Session.Params.ModoDespliegue EQ 1>
	<cfset tabNames[8] = vAnotaciones >
<cfelse>
	<cfset tabNames[8] = "">
</cfif>

<!---<cfset tabNames[9] = "">
<cfset tabNames[10] = "">--->

<cfif isdefined("rsUsatest") and rsUsatest.Pvalor EQ 1>
	<cfset tabNames[11] = vPerfilBenziger >
	<cfset tabNames[12] = vComparativoBenziger >
<cfelse>
	<cfset tabNames[11] = "">
	<cfset tabNames[12] = "">
</cfif>

<cfset tabNames[13] = vBeneficios >

<!---
	9 = vacaciones
	10 = otros expedientes
--->

<cfset tabLinks = ArrayNew(1)>
<!--- Se utiliza cuando el que consulta es el administrador --->
<cfif Session.Params.ModoDespliegue EQ 1>
	<script language="JavaScript" type="text/javascript">
		function gotoTab(tab, emp) {
			document.reqEmpl.o.value = tab;
			document.reqEmpl.DEid.value = emp;
			document.reqEmpl.submit();
		}
	</script>

	<cfset tabLinks[1] = "javascript: gotoTab(1, #Form.DEid#);">
	<cfset tabLinks[2] = "javascript: gotoTab(2, #Form.DEid#);">
	<cfset tabLinks[3] = "javascript: gotoTab(3, #Form.DEid#);">
	<cfset tabLinks[4] = "javascript: gotoTab(4, #Form.DEid#);">
	<cfset tabLinks[5] = "javascript: gotoTab(5, #Form.DEid#);">
	<cfset tabLinks[6] = "javascript: gotoTab(6, #Form.DEid#);">	
	<cfset tabLinks[7] = "javascript: gotoTab(7, #Form.DEid#);">	
	<cfset tabLinks[8] = "javascript: gotoTab(8, #Form.DEid#);">
	<cfset tabLinks[9] = "javascript: gotoTab(9, #Form.DEid#);">
	<cfset tabLinks[10] = "javascript: gotoTab(10, #Form.DEid#);">
	
	<cfif isdefined("rsUsatest") and rsUsatest.Pvalor EQ 1>
		<cfset tabLinks[11] = "javascript: gotoTab(11, #Form.DEid#);">
		<cfset tabLinks[12] = "javascript: gotoTab(12, #Form.DEid#);">
	<cfelse>
		<cfset tabLinks[11] = "">
		<cfset tabLinks[12] = "">
	</cfif>	

	<cfset tabLinks[13] = "javascript: gotoTab(13, #Form.DEid#);">
	
	<!---
	validar la seguridad
	--->
	<cfset tabAccess = ArrayNew(1)>
	<cfset proceso = '/rh/expediente/consultas/expediente-globalcons.cfm'>
	<cfset tabAccess[1] = true>
	<cfset tabAccess[2] = acceso_uri(proceso & '/dp')>
	<cfset tabAccess[3] = acceso_uri(proceso & '/di')>
	<cfset tabAccess[4] = acceso_uri(proceso & '/df')>
	<cfset tabAccess[5] = acceso_uri(proceso & '/dl')>
	<cfset tabAccess[6] = acceso_uri(proceso & '/ca')>
	<cfset tabAccess[7] = acceso_uri(proceso & '/de')>
	<cfset tabAccess[8] = acceso_uri(proceso & '/an')>
	<cfset tabAccess[9] = acceso_uri(proceso & '/va')>
	<cfset tabAccess[10] = acceso_uri(proceso & '/pf')>
	
	<cfif isdefined("rsUsatest") and rsUsatest.Pvalor EQ 1>
		<cfset tabAccess[11] = acceso_uri(proceso & '/pf')>
		<cfset tabAccess[12] = acceso_uri(proceso & '/cb')>
	<cfelse>
		<cfset tabAccess[11] = false>
		<cfset tabAccess[12] = false>
	</cfif>

	<cfset tabAccess[13] = acceso_uri(proceso & '/ot')>
	
	<cfif not tabAccess[tabChoice]>
		<cfloop from="1" to="#ArrayLen(tabAccess)#" index="i">
			<cfif tabAccess[i]>
				<cfset tabChoice = i>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>

<!--- Se utiliza cuando el que consulta es el empleado --->
<cfelseif Session.Params.ModoDespliegue EQ 0>
	<cfset tabLinks[1] = "expediente-cons.cfm?o=1">
	<cfset tabLinks[2] = "expediente-cons.cfm?o=2">
	<cfset tabLinks[3] = "expediente-cons.cfm?o=3">
	<cfset tabLinks[4] = "expediente-cons.cfm?o=4">
	<cfset tabLinks[5] = "expediente-cons.cfm?o=5">
	<cfset tabLinks[6] = "expediente-cons.cfm?o=6">	
	<cfset tabLinks[7] = "expediente-cons.cfm?o=7">	
	<cfset tabLinks[8] = "expediente-cons.cfm?o=8">	
	<cfset tabLinks[9] = "expediente-cons.cfm?o=9">	
	
	<cfset vnHasta = 12>
	<cfloop from="1" to="#vnHasta#" index="i">
		<cfset tabAccess[i] = true>
	</cfloop>

	<cfif isdefined("rsUsatest") and rsUsatest.Pvalor EQ 1>
		<cfset tabLinks[10] = "expediente-cons.cfm?o=10">	
		<cfset tabLinks[11] = "expediente-cons.cfm?o=11">
		<cfset tabAccess[10] = true>
		<cfset tabAccess[11] = true>
	<cfelse>
		<cfset tabLinks[10] = "">	
		<cfset tabLinks[11] = "">
		<cfset tabAccess[10] = false>
		<cfset tabAccess[11] = false>
	</cfif>
	
	<cfset tabLinks[12] = "expediente-cons.cfm?o=12">	
	<cfset tabAccess[12] = true>
	
</cfif>
<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "">
<cfset tabStatusText[2] = "">
<cfset tabStatusText[3] = "">
<cfset tabStatusText[4] = "">
<cfset tabStatusText[5] = "">
<cfset tabStatusText[6] = "">
<cfset tabStatusText[7] = "">
<cfset tabStatusText[8] = "">
<cfset tabStatusText[9] = "">
<cfif isdefined("rsUsatest") and rsUsatest.Pvalor EQ 1>
	<cfset tabStatusText[10] = "">
	<cfset tabStatusText[11] = "">
<cfelse>
	<cfset tabStatusText[10] = "">
	<cfset tabStatusText[11] = "">
</cfif>	
<cfset tabStatusText[12] = "">

