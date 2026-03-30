<cf_templateheader>
	<cf_web_portlet_start>
			<div class="row">
				<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_filtros" Default="Filtros" 	returnvariable="LB_filtros"/>
				<cfinclude  template="ConsultaRepDinamicos-form.cfm">		
			</div>		
	<cf_web_portlet_end>
<cf_templatefooter>