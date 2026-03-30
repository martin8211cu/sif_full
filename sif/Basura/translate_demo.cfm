<cfapplication sessionmanagement="yes">

<cfparam name="session.idioma" default="es_CR">

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="mmm"
	Default="tres emes"
	returnvariable="xx"/>
<cfoutput>mmm:#xx#<hr></cfoutput>

<cf_translate key="yyy" debug="no">cinco ye</cf_translate>
