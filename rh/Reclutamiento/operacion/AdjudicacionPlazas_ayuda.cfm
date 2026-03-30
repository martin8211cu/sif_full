<div >
	<cfif form.PASO EQ "0">
	  <strong><cf_translate key="LB_ListaDeConcursos">Lista de Concursos</cf_translate>:</strong>
		<br>
		<br>
			<cf_translate key="AYUDA_SeleccioneDeLaListaElConcursoParaElCualDeseaRealizarElProcesoDeAdjudicacionDePlazas">Seleccione de la lista el concurso para el cual desea realizar 	el proceso de adjudicación de plazas.</cf_translate>
		<br>
		<br>
	<cfelseif form.Paso EQ "1">
		<cf_translate key="AYUDA_AdjudicacionDePlazasEnEstePasoElSistemaHaAdjudicadoLasPlazasALosMejoresConcursantes"><strong>Adjudicación de plazas</strong>
		<br>
		<br>
			En este paso el sistema ha adjudicado las plazas a los mejores concursantes.  
		<br>
			Si desea cambiar la adjudicación haga clic sobre el botón "Reasignar".
		<br>
			Cuando aparezca la ventana emergente seleccione la nueva plaza.
		<br></cf_translate>
	<cfelseif form.Paso EQ "2">
		<cf_translate key="AYUDA_IngresoDeDatosDeLosConcursantesEnEstsePasoSeMuestraLaListaConLosConcursantesAsignadosAAlgunaPlaza"><strong>Ingreso de datos de los concursantes</strong>
		<br>
		<br>
			En este paso se muestra la lista con los concursantes asignados a alguna plaza.
		<br>	
			Para ingresar los datos haga clic sobre el concursante, y proceda 		
			a llenar los datos solicitados en la ventana emergente.
		<br></cf_translate>
		<br>
	</cfif>
</div>
