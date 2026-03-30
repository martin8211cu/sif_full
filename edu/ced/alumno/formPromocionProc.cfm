<fieldset><legend>Promociones Sin Aplicar</legend>

<cfquery datasource="#Session.Edu.DSN#" name="rsPromoXAplicarN">
	 select 1
	 from Promocion pr
		inner join Nivel n on n.Ncodigo = pr.Ncodigo and n.CEcodigo = #Session.Edu.CEcodigo#
		inner join Grado g on g.Gcodigo = pr.Gcodigo
		inner join PeriodoEscolar pe on pe.PEcodigo = pr.PEcodigo
		inner join SubPeriodoEscolar spe on spe.SPEcodigo = pr.SPEcodigo
		left outer join Nivel sign on sign.Ncodigo = g.Gpromonivel
		left outer join PeriodoVigente pv on pv.Ncodigo = sign.Ncodigo
		left outer join Grado sigg on sigg.Gcodigo = g.Gpromogrado
		left outer join PeriodoEscolar sigpe on sigpe.PEcodigo = pv.PEcodigo
		left outer join SubPeriodoEscolar sigspe on sigspe.SPEcodigo = pv.SPEcodigo 
	where pr.PRactivo = 1 and pr.SPEcodigo not in (select SPEcodigo from PeriodoVigente)
</cfquery>

<cfset Aplicar = "">
<cfif rsPromoXAplicarN.RecordCount GT 0>
	<cfset Aplicar = "Aplicar">
</cfif>

<cfinvoke 
	 component="edu.Componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="Promocion pr
																	inner join Nivel n 
																		on n.Ncodigo = pr.Ncodigo 
																		and n.CEcodigo = #Session.Edu.CEcodigo#
																	inner join Grado g on g.Gcodigo = pr.Gcodigo
																	inner join PeriodoEscolar pe on pe.PEcodigo = pr.PEcodigo
																	inner join SubPeriodoEscolar spe on spe.SPEcodigo = pr.SPEcodigo
																	left outer join Nivel sign on sign.Ncodigo = g.Gpromonivel
																	left outer join PeriodoVigente pv on pv.Ncodigo = sign.Ncodigo
																	left outer join Grado sigg on sigg.Gcodigo = g.Gpromogrado
																	left outer join PeriodoEscolar sigpe on sigpe.PEcodigo = pv.PEcodigo
																	left outer join SubPeriodoEscolar sigspe on sigspe.SPEcodigo = pv.SPEcodigo"/>
		<cfinvokeargument name="columnas" value="pr.PRcodigo, pr.PRdescripcion as Promocion, pe.PEdescripcion+': '+spe.SPEdescripcion as Periodo,  n.Ndescripcion as Nivel, g.Gdescripcion as Grado, 
																	isnull(sign.Ndescripcion,'null') as NivelProx, isnull(sigg.Gdescripcion,'null') as GradoProx, pv.SPEcodigo, sigpe.PEdescripcion + ': ' + sigspe.SPEdescripcion as PerVigente,
																	'<img src=''/cfmx/sif/imagenes/forward.gif'' border=''0''/>' as img"/>
		<cfinvokeargument name="cortes" value="Periodo"/>
		<cfinvokeargument name="desplegar" value="Promocion, Nivel, Grado, img, NivelProx, GradoProx"/>
		<cfinvokeargument name="filtrar_por" value="pr.PRdescripcion, n.Ndescripcion, g.Gdescripcion, '', sign.Ndescripcion, sigg.Gdescripcion"/>
		<cfinvokeargument name="etiquetas" value="Promoción, Nivel, Grado, , Nivel, Grado"/>
		<cfinvokeargument name="formatos" value="S,S,S,U,S,S"/>
		<cfinvokeargument name="Filtro" value="pr.PRactivo = 1 and pr.SPEcodigo not in (select SPEcodigo from PeriodoVigente)
																	order by n.Norden, pe.PEorden, spe.SPEorden, g.Gorden"/>
		<cfinvokeargument name="align" value="left, left, left, left, left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="PromocionProc.cfm"/>
		<cfinvokeargument name="checkboxes" value="S"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="botones" value="#Aplicar#"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="keys" value="PRcodigo"/>
		<cfinvokeargument name="conexion" 	value="#Session.Edu.Dsn#"/>
		<cfinvokeargument name="mostrar_Filtro" value="true"/>
		<cfinvokeargument name="filtrar_automatico" value="true"/>
		<cfinvokeargument name="maxrows" value="15"/>
</cfinvoke>

<!--- Consultas --->
<script type="text/javascript">
	<!--
	function funcAplicar() {
		var formulario = document.lista;
		for (var i=0; i<formulario.elements.length; i++) {
			if (formulario.elements[i].type == "checkbox"
			&& formulario.elements[i].name == "chk"
			&& formulario.elements[i].checked) {
				var _confirm = confirm("Desea aplicar las Promociones marcadass?");
				if (_confirm){
					formulario.action = "SQLPromocionProc.cfm";
					return true;
				} else return false;
			}
		}
		alert("Debe seleccionar un item de la lista para realizar esta acciónn!");
		return false;
	}
	-->
</script>

</fieldset>