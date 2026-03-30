<div id="rootwizard" class="tabbable tabs-left">
	<ul>
	  	<li><a href="#tab1" data-toggle="tab">Tipo de Gr&aacute;fica</a></li>
		<li><a href="#tab2" data-toggle="tab">Campos</a></li>
		<li><a href="#tab3" data-toggle="tab">Finalizar</a></li>
	</ul>
	<div class="tab-content">
	    <div class="tab-pane" id="tab1">
	      1
	    </div>
	    <div class="tab-pane" id="tab2">
	      2
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