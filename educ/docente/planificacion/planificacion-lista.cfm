<cfif isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) and Form.Ccodigo NEQ -1>
	<script language="javascript" type="text/javascript">
		<cfoutput>
		function funcNuevo() {
			document.formEvaluaciones.CCODIGO.value = '#Form.Ccodigo#';
			document.formEvaluaciones.PECODIGO.value = '#Form.PEcodigo#';
		}
		</cfoutput>
	</script>

	<cfset navegacion = "">
	<cfset additionalCols = " #Form.Ccodigo# as Ccodigo, #Form.PEcodigo# as PEcodigo, ">

	<cfinvoke component="educ.componentes.pListas" 
			  method="pListaEdu" 
			  returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="
			CursoEvaluacion ce
			, CursoConceptoEvaluacion cce
			, ConceptoEvaluacion cev"/>
		<cfinvokeargument name="columnas" value="#additionalCols# ce.CEVcodigo
				, ce.CEcodigo
				, 'Concepto Evaluacion:&nbsp;&nbsp;' + CEnombre + ' (' + convert(varchar,CCEporcentaje) + '%)' as CEnombre
				, CEVnombre
				, CEVtipoPeso
				, CEVpeso
				, (	case CEVtipoCalificacion 
						when '1' then 'Porcentaje' 
						when '2' then 'Puntaje' 
						when 'T' then 'Tabla' 
					else '' end) as TipoCalificacion
				, convert(varchar, CEVfechaPlan, 103) as FechaPlan
				, (	case CEVestado
						when 0 then 'Inactivo'
						when 1 then 'Activo'						
						when 2 then 'Cerrado'	
					else '' end) as CEVestado"/>
		<cfinvokeargument name="desplegar" value="CEVnombre, CEVtipoPeso, CEVpeso, TipoCalificacion, FechaPlan, CEVestado"/>
		<cfinvokeargument name="etiquetas" value="Evaluaci&oacute;n, Tipo Peso, Peso, Tipo Calificaci&oacute;n, Fecha Planeada, Estado"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="
				ce.PEcodigo = #form.PEcodigo#
				and ce.Ccodigo = #form.Ccodigo#
				and Ecodigo = #session.Ecodigo#
				and ce.Ccodigo=cce.Ccodigo
				and ce.PEcodigo=cce.PEcodigo
				and ce.CEcodigo=cce.CEcodigo
				and cce.CEcodigo=cev.CEcodigo
			order by ce.CEcodigo,CEVfechaPlan"/>
		<cfinvokeargument name="align" value="left,center,right,center,center,center"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="keys" value="CEVcodigo"/>
		<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
		<cfinvokeargument name="botones" value="Nuevo"/>
		<cfinvokeargument name="Cortes" value="CEnombre"/>		
		<cfinvokeargument name="formName" value="formEvaluaciones"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="debug" value="N"/>
	</cfinvoke>			   
</cfif>