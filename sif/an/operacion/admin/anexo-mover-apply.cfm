<!---
	parametros:
		LvarAnexoIdActual: ID del Anexo origen de la copia
		LvarNuevoId      : ID del Anexo destino de la copia
		LvarAnexoHoja    : Nombre de la hoja origen de la copia
		LvarAnexoHojaN   : Nombre de la hoja destino de la copia.  Si no se especifica se utiliza el nombre de la hoja origen
		form.AnexoRan    : Nombre del rango a copiar ( nulo implica todos los rangos de la hoja )
		form.SoloExistan : Condición para copiar únicamente rangos que existan en el  anexo destino
--->

<cfset LvarAnexoIdActual = form.AnexoId>
<cfset LvarNuevoId 		 = form.sel_AnexoDST>
<cfset LvarAnexoHoja 	 = form.sel_Hojasrc>
<cfset LvarAnexoHojaN	 = form.sel_Hojadst>
<cfset LvarSoloExistan	 = form.SoloExistan>
<cfset LvarAnexoRango = "">

<cfset LvarAnexoIdActual =form.AnexoId>
<cfif len(trim(LvarAnexoHojaN)) EQ 0>
	<cfset LvarAnexoHojaN = LvarAnexoHoja>
</cfif>

<cfquery name="rsRangos" datasource="#session.dsn#">
	select
		AnexoCelId, 
		AnexoId, 
		AnexoHoja, 
		AnexoRan, 
		AnexoCon, 
		Ecodigo, 
		AVid, 
		AnexoES, 
		AnexoRel, 
		AnexoMes, 
		AnexoPer, 
		Ocodigo, 
		AnexoNeg, 
		BMUsucodigo, 
		AnexoFila, 
		AnexoColumna, 
		Ecodigocel, 
		GOid, 
		GEid, 
		AnexoFor
	from AnexoCel co
	where  AnexoId 	 = #LvarAnexoIdActual#
	   and AnexoHoja = '#LvarAnexoHoja#'
	<cfif isdefined("LvarAnexoRango") and len(trim(LvarAnexoRango)) GT 0>
	   and AnexoRan = '#LvarAnexoRango#'
	</cfif>
	<cfif isdefined("LvarSoloExistan") and LvarSoloExistan NEQ 0>
		and (
			select count(1)
			from AnexoCel cd
			where cd.AnexoId      = #LvarNuevoId#
			   and cd.AnexoHoja  = '#LvarAnexoHojaN#'
			   and cd.AnexoRan   = co.AnexoRan
			 ) > 0
	</cfif>
	order by AnexoRan
</cfquery>

<cfloop query="rsRangos">
	<cfset LvarAnexoHoja     = rsRangos.AnexoHoja>
	<cfset LvarAnexoRan      = rsRangos.AnexoRan>
	<cfset LvarAnexoCelIdAct = rsRangos.AnexoCelId>
	<cfset LvarFila 		 = -1>
	<cfset LvarColumna 		 = -1>
	<cfset LvarExisteRango 	 = false>
	<cfset LvarAnexoCelId 	 = -1>

	<cfquery name="rsVerificaExistenciaRango" datasource="#session.dsn#">
		select 
			AnexoCelId, 
			AnexoFila, 
			AnexoColumna
		from AnexoCel
		where  AnexoId   = #LvarNuevoId#
		   and AnexoHoja = '#LvarAnexoHojaN#'
		   and AnexoRan  = '#LvarAnexoRan#'
	</cfquery>

	<cfif rsVerificaExistenciaRango.recordcount EQ 1>
		<cfset LvarAnexoCelId 	= rsVerificaExistenciaRango.AnexoCelId>
		<cfset LvarFila 		= rsVerificaExistenciaRango.AnexoFila>
		<cfset LvarColumna 		= rsVerificaExistenciaRango.AnexoColumna>
		<cfset LvarExisteRango 	= true>
	</cfif>

	<cftransaction action="begin">
		<cfif LvarExisteRango>
			
			<cfquery datasource="#session.dsn#">
				update AnexoCel
				set 
					  AnexoCon      = <cfif len(trim(rsRangos.AnexoCon))>#rsRangos.AnexoCon#<cfelse>null</cfif> 
					, Ecodigo       = #rsRangos.Ecodigo#
					, AVid          = <cfif len(trim(rsRangos.AVid))>#rsRangos.AVid#<cfelse>null</cfif> 
					, AnexoES       = '#rsRangos.AnexoES#'
					, AnexoRel      = #rsRangos.AnexoRel#
					, AnexoMes      = #rsRangos.AnexoMes#
					, AnexoPer      = #rsRangos.AnexoPer#
					, Ocodigo       = <cfif len(trim(rsRangos.Ocodigo))>#rsRangos.Ocodigo#<cfelse>null</cfif>
			    	, AnexoNeg      = <cfif len(trim(rsRangos.AnexoNeg))>#rsRangos.AnexoNeg#<cfelse>null</cfif>
					, BMUsucodigo 	= <cfif len(trim(rsRangos.BMUsucodigo))>#rsRangos.BMUsucodigo#<cfelse>null</cfif>
					, Ecodigocel    = <cfif len(trim(rsRangos.Ecodigocel))>#rsRangos.Ecodigocel#<cfelse>null</cfif>
					, GOid		  	= <cfif len(trim(rsRangos.GOid))>#rsRangos.GOid#<cfelse>null</cfif> 
					, GEid		  	= <cfif len(trim(rsRangos.GEid))>#rsRangos.GEid#<cfelse>null</cfif> 
					, AnexoFor	  	= <cfif len(trim(rsRangos.AnexoFor))>'#rsRangos.AnexoCon#'<cfelse>null</cfif> 
				where  AnexoId      = #LvarNuevoId#
				   and AnexoHoja    = '#LvarAnexoHojaN#'
				   and AnexoRan     = '#LvarAnexoRan#'
				   and AnexoCelId   = #LvarAnexoCelId#
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				insert into AnexoCel 
					(AnexoId, 
					 AnexoHoja, 
					 AnexoRan, 
					 AnexoCon, 
					 Ecodigo, 
					 AVid, 
					 AnexoES, 
					 AnexoRel, 
					 AnexoMes, 
					 AnexoPer, 
					 Ocodigo, 
					 AnexoNeg, 
					 BMUsucodigo, 
					 AnexoFila, 
					 AnexoColumna, 
					 Ecodigocel, 
					 GOid, 
					 GEid, 
					 AnexoFor)
				select 
					 #LvarNuevoId#, 
					 '#LvarAnexoHojaN#', 
					 AnexoRan, 
					 AnexoCon, 
					 Ecodigo, 
					 AVid, 
					 AnexoES, 
					 AnexoRel, 
					 AnexoMes, 
					 AnexoPer, 
					 Ocodigo, 
					 AnexoNeg, 
					 BMUsucodigo, 
					 0, 
					 0, 
					 Ecodigocel, 
					 GOid, 
					 GEid, 
					 AnexoFor
				from AnexoCel
				where  AnexoId     = #LvarAnexoIdActual#
				   and AnexoHoja   = '#LvarAnexoHoja#'
				   and AnexoRan    = '#LvarAnexoRan#'
				   and AnexoCelId  = #LvarAnexoCelIdAct#
			</cfquery>
			<cfquery name="rsNuevoRango" datasource="#session.dsn#">
				select 
					AnexoCelId, 
					AnexoFila, 
					AnexoColumna
				from AnexoCel
				where AnexoId 	 = #LvarNuevoId#
				   and AnexoHoja = '#LvarAnexoHojaN#'
				   and AnexoRan  = '#LvarAnexoRan#'
			</cfquery>
			<cfset LvarAnexoCelId = rsNuevoRango.AnexoCelId>
		</cfif>
	
		<!--- Borrar estructuras dependientes si existen y generar las nuevas --->
		<cfquery datasource="#session.dsn#">
			delete from AnexoCelD
			where AnexoCelId = #LvarAnexoCelId#
		</cfquery>
	
		<cfquery datasource="#session.dsn#">
			delete from AnexoCelConcepto
			where AnexoCelId = #LvarAnexoCelId#
		</cfquery>
		
		<cfquery datasource="#session.dsn#">
			insert into AnexoCelD 
				(AnexoCelId, 
				 Ecodigo, 
				 AnexoCelFmt, 
				 AnexoCelMov, 
				 AnexoSigno, 
				 BMUsucodigo, 
				 Anexolk, 
				 Cmayor, 
				 PCDcatid)
			select 
				 #LvarAnexoCelId#, 
				 Ecodigo, 
				 AnexoCelFmt, 
				 AnexoCelMov, 
				 AnexoSigno, 
				 BMUsucodigo, 
				 Anexolk, 
				 Cmayor, 
				 PCDcatid
			from AnexoCelD
			where AnexoCelId = #LvarAnexoCelIdAct#
		</cfquery>
	
		<cfquery datasource="#session.dsn#">
			insert into AnexoCelConcepto 
				(AnexoCelId, 
				 Ecodigo, 
				 Cconcepto)
			select 
				 #LvarAnexoCelId#, 
				 Ecodigo, 
				 Cconcepto
			from AnexoCelConcepto
			where AnexoCelId = #LvarAnexoCelIdAct#
		</cfquery>
		
		<cftransaction action="commit"/>
	</cftransaction>
</cfloop>
<cflocation url="anexo.cfm?tab=2&AnexoId=# URLEncodedFormat(form.AnexoId) #">