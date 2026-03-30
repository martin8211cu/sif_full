<fieldset><legend>Promociones Aplicadas</legend>

<cfquery datasource="#Session.Edu.DSN#" name="rsPromoXAplicarN">
	 select 1
	 from Promocion pr
		inner join Nivel n on n.Ncodigo = pr.Ncodigo and n.CEcodigo = #Session.Edu.CEcodigo#
		inner join Grado g on g.Gcodigo = pr.Gcodigo
		inner join PeriodoEscolar pe on pe.PEcodigo = pr.PEcodigo
		inner join SubPeriodoEscolar spe on spe.SPEcodigo = pr.SPEcodigo
	where pr.PRactivo = 1 and pr.SPEcodigo in (select SPEcodigo from PeriodoVigente)
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
																	inner join SubPeriodoEscolar spe on spe.SPEcodigo = pr.SPEcodigo"/>
		<cfinvokeargument name="columnas" value="pr.PRdescripcion as Promocion, pe.PEdescripcion+': '+spe.SPEdescripcion as Periodo,  n.Ndescripcion as Nivel, g.Gdescripcion as Grado"/>
		<cfinvokeargument name="cortes" value="Periodo"/>
		<cfinvokeargument name="desplegar" value="Promocion, Nivel, Grado"/>
		<cfinvokeargument name="filtrar_por" value="pr.PRdescripcion, n.Ndescripcion, g.Gdescripcion"/>
		<cfinvokeargument name="etiquetas" value="Promoción, Nivel, Grado"/>
		<cfinvokeargument name="formatos" value="S,S,S"/>
		<cfinvokeargument name="Filtro" value="pr.PRactivo = 1 and pr.SPEcodigo in (select SPEcodigo from PeriodoVigente)
																	order by n.Norden, pe.PEorden, spe.SPEorden, g.Gorden"/>
		<cfinvokeargument name="align" value="left, left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="PromocionProc.cfm"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="conexion" 	value="#Session.Edu.Dsn#"/>
		<cfinvokeargument name="mostrar_Filtro" value="false"/>
		<cfinvokeargument name="filtrar_automatico" value="false"/>
		<cfinvokeargument name="maxrows" value="15"/>
		<cfinvokeargument name="maxrowsquery" value="500"/>
		<cfinvokeargument name="PAgeIndex" value="2"/>
		<cfinvokeargument name="FormName" value="lista2"/>
</cfinvoke>

</fieldset>