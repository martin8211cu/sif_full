<cffunction name="fnCicloLectivoMateria_AltaConDefaults" output="false" access="public">
		<cfargument name="Mcodigo" 				type="numeric" required="true">
		<cfargument name="CILcodigo" 			type="numeric" required="true">
		<cfargument name="MCLtipoCicloDuracion"	type="string"  required="true">

	<cftransaction>
	<cfquery name="rsCicloLectivo" datasource="#Session.DSN#">
		select TRcodigo, PEVcodigo, CILtipoCalificacion, CILpuntosMax, CILunidadMin, CILredondeo, TEcodigo, CILhorasLeccion
		  from CicloLectivo
		 where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		   and CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">
	</cfquery>
	<cfset CILhorasLeccion		= rsCicloLectivo.CILhorasLeccion>

	<cfset MCLmetodologia 		= "">
	<cfset TRcodigo 			= rsCicloLectivo.TRcodigo>
	<cfset PEVcodigo 			= rsCicloLectivo.PEVcodigo>
	<cfset MCLtipoCalificacion 	= rsCicloLectivo.CILtipoCalificacion>
	<cfset MCLpuntosMax 		= rsCicloLectivo.CILpuntosMax>
	<cfset MCLunidadMin 		= rsCicloLectivo.CILunidadMin>
	<cfset MCLredondeo 			= rsCicloLectivo.CILredondeo>
	<cfset TEcodigo 			= rsCicloLectivo.TEcodigo>
	<cfscript>
	  fnCicloLectivoMateria_Alta(
	  	Mcodigo, CILcodigo, MCLtipoCicloDuracion, MCLmetodologia, TRcodigo, PEVcodigo, 
		MCLtipoCalificacion, MCLpuntosMax, MCLunidadMin, MCLredondeo, TEcodigo, 
		CILhorasLeccion);
	</cfscript>
	</cftransaction>
</cffunction>

<cffunction name="fnCicloLectivoMateria_Alta" output="false" access="public">
		<cfargument name="Mcodigo" 				type="numeric" required="true">
		<cfargument name="CILcodigo" 			type="numeric" required="true">
		<cfargument name="MCLtipoCicloDuracion"	type="string"  required="true">
		<cfargument name="MCLmetodologia"		type="string"  required="true">
		<cfargument name="TRcodigo"				type="string"  required="true">
		<cfargument name="PEVcodigo"			type="string"  required="true">
		<cfargument name="MCLtipoCalificacion"	type="string"  required="true">
		<cfargument name="MCLpuntosMax"			type="string"  required="true">
		<cfargument name="MCLunidadMin"			type="string"  required="true">
		<cfargument name="MCLredondeo"			type="string"  required="true">
		<cfargument name="TEcodigo"				type="string"  required="true">

		<cfargument name="CILhorasLeccion"		type="string"  default="">

	<cfif MCLtipoCalificacion EQ '1'>
		<cfset MCLpuntosMax  = 100>
		<cfset MCLunidadMin  = 0.01>
		<cfset MCLredondeo   = 0>
		<cfset TEcodigo = "">
	<cfelseif MCLtipoCalificacion EQ '2'>
		<cfset TEcodigo = "">
	<cfelseif MCLtipoCalificacion EQ 'T'>
		<cfset MCLpuntosMax  = "">
		<cfset MCLunidadMin  = "">
		<cfset MCLredondeo   = "">
	</cfif>
	<cftransaction>
	<cfquery name="A_MateriaCicloLectivo" datasource="#Session.DSN#">
		set nocount on					
		insert MateriaCicloLectivo (Mcodigo, CILcodigo, MCLtipoCicloDuracion,
									MCLmetodologia, TRcodigo, PEVcodigo, 
									MCLtipoCalificacion, MCLpuntosMax, MCLunidadMin, MCLredondeo, TEcodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">
					,<cfqueryparam cfsqltype="cf_sql_char"    value="#MCLtipoCicloDuracion#">
					,<cfif MCLmetodologia NEQ "">	<cfqueryparam cfsqltype="cf_sql_varchar" value="#MCLmetodologia#"><cfelse>null</cfif>
					,<cfif TRcodigo NEQ "">			<cfqueryparam cfsqltype="cf_sql_numeric" value="#TRcodigo#"><cfelse>null</cfif>
					,<cfif PEVcodigo NEQ "">		<cfqueryparam cfsqltype="cf_sql_numeric" value="#PEVcodigo#"><cfelse>null</cfif>
					,<cfif MCLtipoCalificacion NEQ ""><cfqueryparam cfsqltype="cf_sql_char"  value="#MCLtipoCalificacion#"><cfelse>null</cfif>
					,<cfif MCLpuntosMax NEQ "">		<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#MCLpuntosMax#"><cfelse>null</cfif>
					,<cfif MCLunidadMin NEQ "">		<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#MCLunidadMin#"><cfelse>null</cfif>
					,<cfif MCLredondeo NEQ "">		<cfqueryparam cfsqltype="cf_sql_numeric" scale="3" value="#MCLredondeo#"><cfelse>null</cfif>
					,<cfif TEcodigo NEQ "">			<cfqueryparam cfsqltype="cf_sql_numeric" value="#TEcodigo#"><cfelse>null</cfif>
					)
	</cfquery>
	<cfscript>
    	fnCicloEvaluacionMateria_Genera (
			Mcodigo, CILcodigo, MCLtipoCicloDuracion, PEVcodigo, 
			CILhorasLeccion);
	</cfscript>
	</cftransaction>
</cffunction>

<cffunction name="fnCicloLectivoMateria_Cambio" output="false" access="public">
		<cfargument name="Mcodigo" 				type="numeric" required="true">
		<cfargument name="CILcodigo" 			type="numeric" required="true">
		<cfargument name="MCLtipoCicloDuracion"	type="string"  required="true">
		<cfargument name="MCLmetodologia"		type="string"  required="true">
		<cfargument name="TRcodigo"				type="string"  required="true">
		<cfargument name="PEVcodigo"			type="string"  required="true">
		<cfargument name="MCLtipoCalificacion"	type="string"  required="true">
		<cfargument name="MCLpuntosMax"			type="string"  required="true">
		<cfargument name="MCLunidadMin"			type="string"  required="true">
		<cfargument name="MCLredondeo"			type="string"  required="true">
		<cfargument name="TEcodigo"				type="string"  required="true">

		<cfargument name="cambiarMCLtipoCicloDuracion"	type="boolean" default="false">

	<cfif MCLtipoCalificacion EQ '1'>
		<cfset MCLpuntosMax  = 100>
		<cfset MCLunidadMin  = 0.01>
		<cfset MCLredondeo   = 0>
		<cfset TEcodigo = "">
	<cfelseif MCLtipoCalificacion EQ '2'>
		<cfset TEcodigo = "">
	<cfelseif MCLtipoCalificacion EQ 'T'>
		<cfset MCLpuntosMax  = "">
		<cfset MCLunidadMin  = "">
		<cfset MCLredondeo   = "">
	</cfif>

	<cftransaction>
	<cfquery name="C_MateriaCicloLectivo" datasource="#Session.DSN#">
		set nocount on					
		update MateriaCicloLectivo 
			set
				<cfif cambiarMCLtipoCicloDuracion>
				 MCLtipoCicloDuracion = <cfqueryparam cfsqltype="cf_sql_char"    value="#MCLtipoCicloDuracion#">,
				</cfif>
				 MCLmetodologia = <cfif MCLmetodologia NEQ "">	<cfqueryparam cfsqltype="cf_sql_varchar" value="#MCLmetodologia#"><cfelse>null</cfif>
				,TRcodigo = <cfif TRcodigo NEQ "">				<cfqueryparam cfsqltype="cf_sql_numeric" value="#TRcodigo#"><cfelse>null</cfif>
				,PEVcodigo = <cfif PEVcodigo NEQ "">			<cfqueryparam cfsqltype="cf_sql_numeric" value="#PEVcodigo#"><cfelse>null</cfif>
				,MCLtipoCalificacion = <cfif MCLtipoCalificacion NEQ ""><cfqueryparam cfsqltype="cf_sql_char"  value="#MCLtipoCalificacion#"><cfelse>null</cfif>
				,MCLpuntosMax = <cfif MCLpuntosMax NEQ "">		<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#MCLpuntosMax#"><cfelse>null</cfif>
				,MCLunidadMin = <cfif MCLunidadMin NEQ "">		<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#MCLunidadMin#"><cfelse>null</cfif>
				,MCLredondeo = <cfif MCLredondeo NEQ "">		<cfqueryparam cfsqltype="cf_sql_numeric" scale="3" value="#MCLredondeo#"><cfelse>null</cfif>
				,TEcodigo = <cfif TEcodigo NEQ "">				<cfqueryparam cfsqltype="cf_sql_numeric" value="#TEcodigo#"><cfelse>null</cfif>
		 where Mcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
		   and CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">
		set nocount off
	</cfquery>
	<cfif cambiarMCLtipoCicloDuracion>
		<cfscript>
			fnCicloEvaluacionMateria_Genera (
				Mcodigo, CILcodigo, MCLtipoCicloDuracion, PEVcodigo, 
				"");
		</cfscript>
	</cfif>
	</cftransaction>
</cffunction>

<cffunction name="fnCicloLectivoMateria_Baja" output="false" access="public">
		<cfargument name="Mcodigo" 				type="numeric" required="true">
		<cfargument name="CILcodigo" 			type="numeric" required="true">

  <cfquery name="B_MateriaCicloLectivo" datasource="#Session.DSN#">
		delete from MateriaCicloEvaluacion 
		 where Mcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
		   and CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">

		delete from MateriaCicloLectivo
		 where Mcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
		   and CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">
	</cfquery>
</cffunction>

<cffunction name="fnCicloEvaluacionMateria_Genera" output="false" access="public">
		<cfargument name="Mcodigo" 				type="numeric" required="true">
		<cfargument name="CILcodigo" 			type="numeric" required="true">
		<cfargument name="MCLtipoCicloDuracion"	type="string"  required="true">
		<cfargument name="PEVcodigo"			type="string"  required="true">
		<cfargument name="CILhorasLeccion"		type="string"  required="true">

  <cfif CILhorasLeccion EQ "">
	  <cfquery name="rsCicloLectivo" datasource="#Session.DSN#">
			select CILhorasLeccion
			  from CicloLectivo
			 where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			   and CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">
	  </cfquery>
	  <cfset CILhorasLeccion		= rsCicloLectivo.CILhorasLeccion>
  </cfif>

  <cfquery name="G_MateriaCicloEvaluacion" datasource="#Session.DSN#">
		delete from MateriaCicloEvaluacion 
		 where Mcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
		   and CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">

		declare @Mhoras numeric(4,2)
		select @Mhoras = isnull(MhorasTeorica,0)+isnull(MhorasPractica,0)
		  from Materia
		 where Mcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
		 
		declare @CILhorasLeccion numeric(4,2)
		select @CILhorasLeccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CILhorasLeccion#">

	<cfif MCLtipoCicloDuracion EQ "E">
		<!--- 
		  Genera un sólo Ciclo de Evaluación Ordinario Genérico (sin referencia a CicloEvaluacion)
		 --->
		declare @AvgCIEsemanas numeric(4,2)
		select @AvgCIEsemanas = avg(CIEsemanas)
		  from CicloEvaluacion cie
		 where cie.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">
		   and cie.CIEextraordinario = 0
		<!--- 
		  MCEhorasSemana  = round ( (MhorasTeoricas + MhorasPracticas)/ avg(CIEsemanas), 2 )
		  MCEleccionesSemana    = round ( MCEhorasSemana/CILhorasLeccion, 2 )
		  MCEhorasLeccion = round ( MCEhorasSemana/MCEleccionesSemana, 2 )
		 --->
		insert into MateriaCicloEvaluacion (Mcodigo, CILcodigo, 
									MCEsecuencia, CIEcodigo, 
									PEVcodigo, 
									MCEhorasSemana, MCEhorasLeccion, MCEleccionesSemana)
			values  (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">
					,0, null
					,<cfif PEVcodigo NEQ ""><cfqueryparam cfsqltype="cf_sql_numeric" value="#PEVcodigo#"><cfelse>null</cfif>
					, case when @Mhoras=0 or @AvgCIEsemanas=0 then 0 else
							round(@Mhoras/@AvgCIEsemanas,2) 
					  end
					, case when @Mhoras=0 or @AvgCIEsemanas=0 OR @CILhorasLeccion=0 then 0 else
							round ( round(@Mhoras/@AvgCIEsemanas,2) / @CILhorasLeccion, 2) 
					  end
					, case when @Mhoras=0 or @AvgCIEsemanas=0 OR @CILhorasLeccion=0 then 0 else
					  round ( 
							round(@Mhoras/@AvgCIEsemanas,2)  /  
							round ( round(@Mhoras/@AvgCIEsemanas,2) / @CILhorasLeccion, 2)
							, 0) 
					  end
					)
	<cfelse>
		<!--- 
		  Genera todos los Ciclos de Evaluación Ordinarios (referenciando cada CicloEvaluacion)
		 --->
		<!--- 
		  MCEhorasSemana  = round ( (MhorasTeoricas + MhorasPracticas)/ CIEsemanas, 2 )
		  MCEleccionesSemana    = round ( MCEhorasSemana/CILhorasLeccion, 2 )
		  MCEhorasLeccion = round ( MCEhorasSemana/MCEleccionesSemana, 2 )
		 --->
		insert MateriaCicloEvaluacion (Mcodigo, CILcodigo, 
									MCEsecuencia, CIEcodigo, 
									PEVcodigo, 
									MCEhorasSemana, MCEhorasLeccion, MCEleccionesSemana)
		select 		 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
					,CILcodigo, CIEsecuencia, CIEcodigo
					,<cfif PEVcodigo NEQ ""><cfqueryparam cfsqltype="cf_sql_numeric" value="#PEVcodigo#"><cfelse>null</cfif>
					, case when @Mhoras=0 or CIEsemanas=0 then 0 else
							round(@Mhoras/CIEsemanas,2) 
					  end
					, case when @Mhoras=0 or CIEsemanas=0 OR @CILhorasLeccion=0 then 0 else
							round ( round(@Mhoras/CIEsemanas,2) / @CILhorasLeccion, 2) 
					  end
					, case when @Mhoras=0 or CIEsemanas=0 OR @CILhorasLeccion=0 then 0 else
					  round ( 
							round(@Mhoras/CIEsemanas,2)  /  
							round ( round(@Mhoras/CIEsemanas,2) / @CILhorasLeccion, 2)
							, 0) 
					  end
		  from CicloEvaluacion cie
		 where cie.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CILcodigo#">
		   and cie.CIEextraordinario = 0
	</cfif>
	set nocount off
  </cfquery>
</cffunction>
