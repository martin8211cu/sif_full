<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Lista_Funcionarios_Cesados"
	Default="Lista de Funcionarios Cesados"
	returnvariable="vLista"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Otros_Ingresos"
	Default="Otros Ingresos"
	returnvariable="vOtrosIngresos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Provisiones"
	Default="Provisiones"
	returnvariable="vProvisiones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Deducciones"
	Default="Deducciones"
	returnvariable="vDeducciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Aprobacion"
	Default="Aprobaci&oacute;n"
	returnvariable="vAprobacion"/>

<cfscript>
	//definiciones iniciales
	Gpaso = 0;
	DLlinea = 0;
	Gmaxpasoallowed = 0;
	Gdescpasos = ArrayNew(1);
	ArrayAppend(Gdescpasos,'#vLista#');
	ArrayAppend(Gdescpasos,'#vOtrosIngresos#');
	ArrayAppend(Gdescpasos,'#vProvisiones#');
	ArrayAppend(Gdescpasos,'#vDeducciones#');
	ArrayAppend(Gdescpasos,'#vAprobacion#');
	Gmaxpasos = ArrayLen(Gdescpasos)-1;

	//analisis de parámetros por url
	if (isdefined('url.paso')) { //se hizo click sobre una opción del menú de pasos
		Gpaso = url.paso;
		//validación del Gpaso
		if (Gpaso gt 0) {
			//en el paso 1, 2, 3 y 4 se requiere la línea de liquidación
			if (not isdefined('url.DLlinea') or (isdefined('url.DLlinea') and len(trim(url.DLlinea)) eq 0)) {
				Gpaso = 0;
			}
			else {
				DLlinea = url.DLlinea;
				Gmaxpasoallowed = 4;
			}
		}
	}

	//análisis de parámetros por form
	if (isdefined('form.paso')) { //se hizo submit en uno de los forms de las pantallas 0, 1, 2, 3 o 4.
		Gpaso = form.paso;
		//validación del Gpaso cuando 
		if (Gpaso gt 0){
			// en el paso 1 podría venir el botón de nuevo o el concurso
			if (Gpaso eq 1 and (isdefined('form.btnNuevo') or isdefined('form.Nuevo'))) {
				//ok, el concurso ya está en cero, con esto se maneja bien el modo alta
				if ( isdefined("form.DLlinea") and len(trim(form.DLlinea)) ){
					DLlinea = form.DLlinea;				
				}
			}
			//en el paso 1(cuando no está definifo el botón nuevo),2 y 3 se requiere el concurso
			else{
				if (not isdefined('form.DLlinea') or (isdefined('form.DLlinea') and len(trim(form.DLlinea)) eq 0)) {
					Gpaso = 0;
				}
				else {
					DLlinea = form.DLlinea;
					Gmaxpasoallowed = 4;
				}
			}
		}
	}

</cfscript>