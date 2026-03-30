<cfinvoke 
 component="educ.componentes.pTabs2"
 method="fnTabsInclude">
	<cfinvokeargument name="pTabID" value="TabsMateria"/>
	<cfinvokeargument name="pTabs" value=
		 #"|Materia,materia_form.cfm,Trabajar con los Datos de la Materia"
		& "|Documentación,materiaDocumentacion.cfm,Definir la Documentación de la Materia"
		& "|Temas,materiaTemas.cfm,Definir los Temas contenidos en la Materia"
		& "|Parámetros,MateriaParametros_form.cfm,Parámetros de Comportamiento de la Materia"
		<!--- & "|Programa,MateriaPrograma_form.cfm,Construcción del Programa de Curso" --->
		#
	/> 
	<cfparam name="Form.PBLsecuencia" default="">
	<cfparam name="Form.PEScodigo" default="">
	<cfparam name="Form.CARcodigo" default="">	
	<cfparam name="Form.TabsPlan" default="1">		
	<cfinvokeargument name="pDatos" value="PEScodigo=#form.PEScodigo#,Mcodigo=#form.Mcodigo#,Nivel=2,Modo=#form.Modo#,T=#form.T#,TabsPlan=#form.TabsPlan#,CARcodigo=#form.CARcodigo#"/>
	<cfinvokeargument name="pNoTabs" value="#(form.Modo EQ 'ALTA' OR form.Modo EQ 'MPalta' OR form.T NEQ 'M')#"/>
	<cfinvokeargument name="pWidth" value="100%"/>
</cfinvoke>
