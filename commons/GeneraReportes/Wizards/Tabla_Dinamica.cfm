<div id="rootwizard" class="tabbable tabs-left">
	<ul>
	  	<li><a href="#tab1" data-toggle="tab">Tipo de Gr&aacute;fica</a></li>
		<li><a href="#tab2" data-toggle="tab">Campos</a></li>
		<li><a href="#tab3" data-toggle="tab">Finalizar</a></li>
	</ul>
	<div class="tab-content">
	    <div class="tab-pane" id="tab1">
	      	<div class="row">&nbsp;</div>
	        <div class="row cont">
		      	<div class="col col-md-3 col-sm-6">
		      		<i class="fa fa-ban fa-5x"></i>
		      		<label>
                      <input name="optionsRadios" id="optionsRadios1" value="option1" checked="" type="radio">
                      Sin Graficas
                    </label>
		      	</div>
		      	<div class="col col-md-3 col-sm-6">
		      		<i class="fa fa-bar-chart fa-5x"></i>
		      		<label>
                      <input name="optionsRadios" id="optionsRadios1" value="option1" type="radio">
                      Grafica de Barras
                    </label>
		      	</div>
		      	<div class="col col-md-3 col-sm-6">
		      		<i class="fa fa-line-chart fa-5x"></i>
		      		<label>
                      <input name="optionsRadios" id="optionsRadios1" value="option1"  type="radio">
                      Grafica de Linea
                    </label>
		      	</div>
		      	<div class="col col-md-3 col-sm-6">
		      		<i class="fa fa-pie-chart fa-5x"></i>
		      		<label>
                          <input name="optionsRadios" id="optionsRadios1" value="option1" type="radio">
                          Grafica de Pastel
                        </label>
		      	</div>
	        </div>
	    </div>
	    <div class="tab-pane" id="tab2">
	    	<div class="row">&nbsp;</div>
	        <div class="row cont">
	        	<div class="col col-md-5">
		        	<label>
	                 	Seleccionar Campos para agregar al reporte
	                </label>	      	
		      		<table class="table">
					    <thead>
					        <tr>
					            <th data-field="id">Campo</th>
					            <th data-field="name"></th>
					        </tr>
					    </thead>
					    <tbody>
					    	<tr>
					    		<td></td>
					    	</tr>
					    </tbody>
					</table>
				</div>
		      	<div class="col col-md-7">
		      		<div class="row">
		      			<div class="col col-md-6">
							<table class="table">
							    <thead>
							        <tr>
							            <th data-field="id">Campo</th>
							            <th data-field="name"></th>
							        </tr>
							    </thead>
							    <tbody>
							    	<tr>
							    		<td colspan="2">No se encontraron resultados</td>
							    	</tr>
							    </tbody>
							</table>
							<label>
			                	<i class="fa fa-table"></i>
			                 	Campos de Leyenda o Series
			                </label>
		      			</div>
		      			<div class="col col-md-6">
							<table class="table">
							    <thead>
							        <tr>
							            <th data-field="id">Campo</th>
							            <th data-field="name"></th>
							        </tr>
							    </thead>
							    <tbody>
							    	<tr>
							    		<td colspan="2">No se encontraron resultados</td>
							    	</tr>
							    </tbody>
							</table>
		      				<label>
								<i class="fa fa-table fa-rotate-270"></i>
			                 	Campos de Eje (Categorias)
			                </label>	      	
				      	</div>
		      		</div>
		      		<div class="row">
		      			<div class="col col-md-6">
							<table class="table">
							    <thead>
							        <tr>
							            <th data-field="id">Campo</th>
							            <th data-field="name"></th>
							        </tr>
							    </thead>
							    <tbody>
							    	<tr>
							    		<td colspan="2">No se encontraron resultados</td>
							    	</tr>
							    </tbody>
							</table>
							<label>
								<i class="fa fa-info"></i>
			                 	Valores (Sumatoria)
			                </label>
		      			</div>
		      			<div class="col col-md-6">
							
		      			</div>
		      		</div>
		      	</div>
	        </div>
	    </div>
		<div class="tab-pane" id="tab3">
			3
	    </div>
		<ul class="pager wizard">
			<li class="previous first" style="display:none;"><a href="#">First</a></li>
			<li class="previous"><a href="#">Anterior</a></li>
			<li class="next last" style="display:none;"><a href="#">Last</a></li>
		  	<li class="next"><a href="#">Siguiente</a></li>
		</ul>
	</div>	
</div>

<script type="text/javascript">
    $('#rootwizard').bootstrapWizard({'tabClass': 'nav nav-tabs'});
</script>