
<cf_templateheader>
	<cf_web_portlet_start>
		<div class="row">
    <div class="col-sm-1"></div>
    <div class="col-sm-10">
	    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_filtros" Default="Filtros" 	returnvariable="LB_filtros"/>
		<cfinclude  template="PlusesSalarialesEmpleado-form.cfm">	
	</div>
    <div class="col-sm-1"></div>
  </div>	
			
			
	<cf_web_portlet_end>
<cf_templatefooter>