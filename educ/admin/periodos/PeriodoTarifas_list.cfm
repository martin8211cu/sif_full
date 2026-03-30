	<cfparam name="form.PTcodigo" default="">	
	<cfquery name="qryPMsecuencia" datasource="#Session.DSN#">
		declare @PTcodigo numeric
		select @PTcodigo = isnull(max(PTcodigo),-1) 
		  from PeriodoTarifas
		 where PLcodigo <> <cfqueryparam value="#form.PLcodigo#" cfsqltype="cf_sql_numeric">
			<cfif form.PEcodigo NEQ "">
			or isnull(PEcodigo,-1) <> <cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
			</cfif>
			
		insert into PeriodoTarifas (PLcodigo, PEcodigo, TTcodigo, PTmontoFijo, PTmontoUnidad)
		select <cfqueryparam value="#form.PLcodigo#" cfsqltype="cf_sql_numeric">
		     , <cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric" null="#form.PEcodigo EQ ""#">
		     , TTcodigo, 0, null
		from TarifasTipo tt
		where not exists (select * from PeriodoTarifas
							where PLcodigo = <cfqueryparam value="#form.PLcodigo#" cfsqltype="cf_sql_numeric">
							<cfif form.PEcodigo NEQ "">
							and PEcodigo = <cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
							</cfif>
							and TTcodigo = tt.TTcodigo)
		and tt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		
		update PeriodoTarifas 
		   set PTmontoFijo = pt2.PTmontoFijo
		     , PTmontoUnidad = pt2.PTmontoUnidad
		  from PeriodoTarifas pt1, PeriodoTarifas pt2
		  where pt1.TTcodigo = pt2.TTcodigo
		  and pt1.PTcodigo <> @PTcodigo
	</cfquery>
	
	<cfif form.PTcodigo NEQ "">
		<cfinclude template="PeriodoTarifas_form.cfm">
	</cfif>	
	
	<cfinvoke 
	 component="educ.componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="PeriodoTarifas pt, TarifasTipo tt"/>
		<cfinvokeargument name="columnas" value="5 as Nivel, #form.CILcodigo# as CILcodigo, '#form.CILtipoCicloDuracion#' as CILtipoCicloDuracion, PTcodigo, PLcodigo, PEcodigo, TTnombre, TTtipo, str(PTmontoFijo,10,2) as PTmontoFijo, str(PTmontoUnidad,10,2) as PTmontoUnidad"/>
		<cfinvokeargument name="desplegar" value="TTnombre, PTmontoFijo, PTmontoUnidad"/>
		<cfinvokeargument name="etiquetas" value="Tipo Tarifa, Monto Fijo, Monto Unidad"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfif form.PEcodigo EQ "">
			<cfinvokeargument name="filtro" value=" tt.Ecodigo = #Session.Ecodigo# and pt.TTcodigo = tt.TTcodigo and PLcodigo=#form.PLcodigo#"/>
		<cfelse>
			<cfinvokeargument name="filtro" value=" tt.Ecodigo = #Session.Ecodigo# and pt.TTcodigo = tt.TTcodigo and PLcodigo=#form.PLcodigo# and PEcodigo=#form.PEcodigo#"/>
		</cfif>
		<cfinvokeargument name="align" value="left,right,right"/>
		<cfinvokeargument name="ajustar" value="N,N,N"/>
		<cfinvokeargument name="irA" value="PeriodoMatricula.cfm"/>
		<cfinvokeargument name="botones" value=""/>
		<cfinvokeargument name="keys" value="PTcodigo"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="maxRows" value="0" />
		<cfinvokeargument name="navegacion" value="" />
	</cfinvoke>
