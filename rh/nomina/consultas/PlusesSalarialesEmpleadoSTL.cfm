
<cf_templateheader>
	<cf_web_portlet_start>
		<div class="row">
		    <div class="col-sm-10 col-sm-offset-1">
	 
			    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_filtros" Default="Filtros" 	returnvariable="LB_filtros"/>
				<cfinclude  template="PlusesSalarialesEmpleadoSTL-form.cfm"> 
			</div>
		</div>	
	<cf_web_portlet_end>
<cf_templatefooter>