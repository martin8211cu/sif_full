<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PaginaNoEncontrada" Default="Página no encontrada" XmlFile="/rh/generales.xml" returnvariable="LB_PaginaNoEncontrada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PaginaNoEncontrada" Default="Página no encontrada" XmlFile="/rh/generales.xml" returnvariable="LB_PaginaNoEncontrada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_LaPaginaQueBuscasNoSeEncuentra" Default="La página que estás buscando no se pudo encontrar" XmlFile="/rh/generales.xml" returnvariable="LB_LaPaginaQueBuscasNoSeEncuentra"/>

<cf_templateheader title="#LB_PaginaNoEncontrada#">	
	<cf_web_portlet_start border="true" tituloalign="center">
    <div class="row">
      <div class="col-lg-12">
        <div class="bs-example" style="text-align:center;">
          <div class="jumbotron" style="padding-top:1em;padding-bottom:1em">
            <h1 style="font-size: 48px;"><cfoutput>#LB_PaginaNoEncontrada#</cfoutput></h1>
            <p><cfoutput>#LB_LaPaginaQueBuscasNoSeEncuentra#</cfoutput></p>
            <p><a href="javascript:history.back(-1);" class="btn btn-primary btn-lg"><i class="fa fa-mail-reply"></i> <cf_translate key="LB_Volver"  xmlFile="/rh/generales.xml">Volver</cf_translate></a>&nbsp;&nbsp;<a href="/cfmx/home/" class="btn btn-primary btn-lg"><i class="fa fa-home"></i> <cf_translate key="LB_Inicio" xmlFile="/rh/generales.xml">Inicio</cf_translate></a></p>
          </div>
        </div>
      </div>
    </div>
	<cf_web_portlet_end>
<cf_templatefooter>	