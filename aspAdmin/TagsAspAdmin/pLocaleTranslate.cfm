<cfparam name="Attributes.LOCnombre"	type="string">
<cfparam name="Attributes.LOCdefault"	type="string" 	default="">
<cfparam name="Attributes.Idioma"		type="string" 	default="">
<cfparam name="Attributes.PorPagina"	type="boolean" 	default="false">
<cfparam name="Attributes.Automatico"	type="boolean" 	default="true">
<cfparam name="Attributes.Eliminar"		type="boolean" 	default="false">

<cfoutput>
<span class="lbl__#Attributes.LOCnombre#">
	<cfinvoke component="aspAdmin.Componentes.pLocales" 
			  method="fnLocaleTranslate">
		<cfinvokeargument name="LOCname"	value="#Attributes.LOCnombre#"/>
		<cfinvokeargument name="LOCdefault"	value="#Attributes.LOCdefault#"/>
		<cfinvokeargument name="Idioma" 	value="#Attributes.Idioma#"/>
		<cfinvokeargument name="PorPagina" 	value="#Attributes.PorPagina#"/>
		<cfinvokeargument name="Automatico"	value="#Attributes.Automatico#"/>
		<cfinvokeargument name="Eliminar" 	value="#Attributes.Eliminar#"/>
	</cfinvoke>
</span> 
</cfoutput>