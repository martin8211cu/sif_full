<cfset modo = "">

<cfif isdefined("Form.btnMPagregar")>
	<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
		<cfquery name="rsTTcodCurso" datasource="#Session.DSN#">
			Select convert(varchar,TTcodigoCurso) as TTcodigoCurso
			from CicloLectivo
			where CILcodigo=<cfqueryparam value="#form.CILcodigo#" cfsqltype="cf_sql_numeric">			
		</cfquery>
	</cfif>
</cfif>


				
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_Version" datasource="#Session.DSN#">
			set nocount on
		<cfif isdefined('Form.modo') and Form.modo EQ "PBLcambiar">
			<cfset nombresBloques = ListToArray(form.PBLnombre,',')>
			<cfset secuenciaBloques = ListToArray(form.PBLnombre_SEC,',')>		
			
			 <cfoutput>
				<cfloop index = "LoopCount" from = "1" to = "#ArrayLen(nombresBloques)#">
					 update PlanEstudiosBloque
					   set PBLnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombresBloques[LoopCount]#">
					 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
					   and PBLsecuencia=<cfqueryparam cfsqltype="cf_sql_integer" value="#secuenciaBloques[LoopCount]#">				   
				</cfloop>
			 </cfoutput>			
 
			<cfset modo="CAMBIO">
		<cfelseif isdefined('Form.modo') and Form.modo EQ "MParriba">
			declare @PEScodigo numeric,
					@PBLsecuencia int, @PBLsecuencia_SWAP int,
					@MPsecuencia int,  @MPsecuencia_SWAP int
	
			-- Busca los valores de la materia a mover
			select  @PEScodigo    = PEScodigo,
					@PBLsecuencia = PBLsecuencia,
					@MPsecuencia  = MPsecuencia
			  from MateriaPlan 
			 where MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">
			 
			-- Busca la materia contigua para intercambiarla
			select @MPsecuencia_SWAP = max(MPsecuencia)
			  from MateriaPlan mp 
			 where PEScodigo    = @PEScodigo
			   and PBLsecuencia = @PBLsecuencia
			   and MPsecuencia  < @MPsecuencia
	
			if @MPsecuencia_SWAP is not null
			BEGIN
				-- Intercambia las Secuencias
				update MateriaPlan
				   set MPsecuencia  = @MPsecuencia
				 where PEScodigo    = @PEScodigo
				   and PBLsecuencia = @PBLsecuencia
				   and MPsecuencia  = @MPsecuencia_SWAP
				update MateriaPlan
				   set MPsecuencia  = @MPsecuencia_SWAP
				 where MPcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">
			END
			ELSE
			BEGIN
				-- Si no encontro la materia contigua, busca el bloque contiguo
				select @PBLsecuencia_SWAP = max(PBLsecuencia)
				  from PlanEstudiosBloque 
				 where PEScodigo    = @PEScodigo
				   and PBLsecuencia < @PBLsecuencia
	
				if @PBLsecuencia_SWAP is not null
				BEGIN
					-- Busca la ultima materia en dicho bloque
					select @MPsecuencia_SWAP = isnull(max(MPsecuencia),0)+1
					  from MateriaPlan
					 where PEScodigo    = @PEScodigo
					   and PBLsecuencia = @PBLsecuencia_SWAP
					-- Coloca la materia en dicho bloque
					update MateriaPlan
					   set PBLsecuencia = @PBLsecuencia_SWAP,
						   MPsecuencia  = @MPsecuencia_SWAP
					 where MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">
				END
			END

			-- Resecuencia todas las materias del Plan
			update MateriaPlan
			   set MPsecuencia = 
				(	select count(*) + 1
					  from MateriaPlan b
					 where b.PEScodigo    = a.PEScodigo
					   and b.PBLsecuencia = a.PBLsecuencia
					   and (b.MPsecuencia < a.MPsecuencia or 
							b.MPsecuencia = a.MPsecuencia and b.MPcodigo < a.MPcodigo)
				)
			  from MateriaPlan a
			 where a.PEScodigo    = @PEScodigo
			 
			 <cfset modo="CAMBIO">
		<cfelseif isdefined('Form.modo') and Form.modo EQ "MPabajo">
			declare @PEScodigo numeric,
					@PBLsecuencia int, @PBLsecuencia_SWAP int,
					@MPsecuencia int,  @MPsecuencia_SWAP int

			-- Busca los valores de la materia a mover
			select  @PEScodigo    = PEScodigo,
					@PBLsecuencia = PBLsecuencia,
					@MPsecuencia  = MPsecuencia
			  from MateriaPlan 
			 where MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">

			-- Busca la materia contigua para intercambiarla
			select @MPsecuencia_SWAP = min(MPsecuencia)
			  from MateriaPlan mp 
			 where PEScodigo    = @PEScodigo
			   and PBLsecuencia = @PBLsecuencia
			   and MPsecuencia  > @MPsecuencia

			if @MPsecuencia_SWAP is not null
			BEGIN
				-- Intercambia las Secuencias
				update MateriaPlan
				   set MPsecuencia  = @MPsecuencia
				 where PEScodigo    = @PEScodigo
				   and PBLsecuencia = @PBLsecuencia
				   and MPsecuencia  = @MPsecuencia_SWAP
				update MateriaPlan
				   set MPsecuencia  = @MPsecuencia_SWAP
				 where MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">
			END
			ELSE
			BEGIN
				-- Si no encontro la materia contigua, busca el bloque contiguo
				select @PBLsecuencia_SWAP = min(PBLsecuencia)
				  from PlanEstudiosBloque 
				 where PEScodigo    = @PEScodigo
				   and PBLsecuencia > @PBLsecuencia

				if @PBLsecuencia_SWAP is not null
				BEGIN
					-- Abre espacion para la primera materia en dicho bloque
					update MateriaPlan
					   set MPsecuencia = MPsecuencia + 1
					 where PEScodigo    = @PEScodigo
					   and PBLsecuencia = @PBLsecuencia_SWAP
					-- Coloca la materia en dicho bloque
					update MateriaPlan
					   set PBLsecuencia = @PBLsecuencia_SWAP,
						   MPsecuencia  = 1
					 where MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">
				END
			END

			-- Resecuencia todas las materias del Plan
			update MateriaPlan
			   set MPsecuencia = 
				(	select count(*) + 1
					  from MateriaPlan b
					 where b.PEScodigo    = a.PEScodigo
					   and b.PBLsecuencia = a.PBLsecuencia
					   and (b.MPsecuencia < a.MPsecuencia or 
							b.MPsecuencia = a.MPsecuencia and b.MPcodigo < a.MPcodigo)
				)
			  from MateriaPlan a
			 where a.PEScodigo    = @PEScodigo
			<cfset modo="CAMBIO">
		<cfelseif isdefined('Form.modo') and Form.modo EQ "MPborrar">
			delete from MateriaPlan
			where MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">
			  
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.btnPESCambio")>
			update PlanEstudios
			   set PESbloques = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PESbloques#">
			   , PESestado=0
			 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">

			delete from MateriaPlan
			 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
			   and PBLsecuencia > <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.PESbloques#">
			   
			delete from PlanEstudiosBloque
			 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
			   and PBLsecuencia > <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.PESbloques#">
			   
			<cfloop index="cont" from="1" to="#form.PESbloques#">
			if not exists ( select 1 from PlanEstudiosBloque
							 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
							   and PBLsecuencia=#cont# )
				insert into PlanEstudiosBloque (PEScodigo, PBLsecuencia, PBLnombre)
						values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
								,#cont#
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TipoDuracion#">+' #cont#'
								)
			</cfloop>
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.btnMPagregar") and isdefined('rsTTcodCurso') and rsTTcodCurso.recordCount GT 0>
			<cfset modo="MPcambio">
		<!---
		  Agregar la materia, y fnMateriaCicloLectivo_Alta con el Ciclo Lectivo del Plan
		  Agregar la MateriaPlan
		--->
			declare @GAcodigo numeric
			declare @CILcodigo numeric
			declare @EScodigo numeric
			declare @PESplanComun bit
			declare @PEScodigoComun numeric
			
			select @GAcodigo = pes.GAcodigo, @CILcodigo = pes.CILcodigo, 
			       @EScodigo = ca.EScodigo
			  from PlanEstudios pes, Carrera ca
			 where pes.PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
			   and ca.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
			   and ca.CARcodigo = pes.CARcodigo

			declare @NewMPsecuencia int
			select @NewMPsecuencia = isnull(max(MPsecuencia)+1,1)
			  from MateriaPlan
			 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
			   and PBLsecuencia = <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.PBLsecuencia#">

			insert Materia (
					  Ecodigo, Mtipo, Mcodificacion, Mnombre
					, EScodigo, GAcodigo, Mcreditos, Mactivo,TTcodigoCurso,MotrasCarreras,McualquierCarrera,McursoLibre)
			values (
				<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
				, <cfqueryparam value="#form.Mtipo#" cfsqltype="cf_sql_varchar">
				, <cfqueryparam value="#form.Mcodificacion#" cfsqltype="cf_sql_varchar">
				, <cfqueryparam value="#form.Mnombre#" cfsqltype="cf_sql_varchar">
				, @EScodigo
				, @GAcodigo
				, <cfqueryparam value="#form.Mcreditos#" cfsqltype="cf_sql_numeric">
				, 1
				, <cfqueryparam value="#rsTTcodCurso.TTcodigoCurso#" cfsqltype="cf_sql_numeric">
				, 0
				, 0
				, 0
			)
			
			declare @NewMcodigo numeric
			
			select @NewMcodigo = @@identity

			insert into MateriaPlan (PEScodigo, PBLsecuencia, MPsecuencia, Mcodigo)
			  values(
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
			   , <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PBLsecuencia#">
			   , @NewMPsecuencia
			   , @NewMcodigo
			  )
			declare @NewMPcodigo numeric
			select @NewMPcodigo = @@identity

			select @CILcodigo as CILcodigo, @NewMcodigo as Mcodigo, @NewMPcodigo as MPcodigo
		<cfelseif isdefined("Form.btnMPcambiar")>
			<cfset modo="MPcambio">
		<!---
		  Agregar la materia, y fnMateriaCicloLectivo_Alta con el Ciclo Lectivo del Plan
		  Agregar la MateriaPlan
		--->
			update MateriaPlan 
			   set MPcodificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MPcodificacion#">,
			       MPnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MPnombre#">
			 where MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">
		<cfelseif isdefined("Form.btnMPincluir")>
			<cfset modo="CAMBIO">
		<!---
		  Agregar la MateriaPlan
		--->
			declare @CILcodigo numeric
			
			select @CILcodigo = pes.CILcodigo
			  from PlanEstudios pes
			 where pes.PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">

			declare @NewMPsecuencia int
			select @NewMPsecuencia = isnull(max(MPsecuencia)+1,1)
			  from MateriaPlan
			 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
			   and PBLsecuencia = <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.PBLsecuencia#">

			insert into MateriaPlan (PEScodigo, PBLsecuencia, MPsecuencia, Mcodigo, MPcodificacion,MPnombre)
			  values(
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
			   , <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PBLsecuencia#">
			   , @NewMPsecuencia
			   , <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			   <cfif isdefined('form.MPcodificacion') and form.MPcodificacion NEQ ''>
				    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MPcodificacion#">			   				   
			   <cfelse>
					, null			   
			   </cfif>
			   <cfif isdefined('form.MPnombre') and form.MPnombre NEQ ''>
				   , <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MPnombre#">
			   <cfelse>
					, null			   
			   </cfif>
			  )
			declare @NewMPcodigo numeric
			select @NewMPcodigo = @@identity
			  
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#"> as Mcodigo, @NewMPcodigo as MPcodigo
		<cfelseif isdefined("Form.btnMPlimpiar")>
		<!---
		  modo = 'Alta', Mcodigo = ''
		--->
		<cfelseif isdefined("Form.btnMPIrMateria")>
		<!---
		  Ir a mantenimiento de Materia (pantalla grande)
		--->
		</cfif>
			set nocount off
		</cfquery>

		<cfif isdefined("ABC_Version.CILcodigox")>
			<cfscript>
				fnCicloLectivoMateria_AltaConDefaults(
					  ABC_Version.Mcodigo
					, ABC_Version.CILcodigo
					, form.MCLtipoCicloDuracion);
			</cfscript>		
		</cfif>
				
		<cfif (isdefined('form.btnMPincluir') or isdefined('form.btnMPagregar')) and isdefined("ABC_Version") and ABC_Version.recordCount GT 0>	
			<cfset form.Mcodigo = ABC_Version.Mcodigo>
			<cfset form.MPcodigo = ABC_Version.MPcodigo>
		</cfif>
		

<!--- <cfdump var="#form#"> --->
		
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="CarrerasPlanes.cfm" method="post" name="sql">
<cfoutput>
	<input name="nivel" type="hidden" value="2">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="T" type="hidden" value="<cfif isdefined("form.Mtipo")>#form.Mtipo#</cfif>">
	<input name="CILcodigo" type="hidden" value="<cfif isdefined("Form.CILcodigo")>#Form.CILcodigo#</cfif>">
	<input name="CARcodigo" type="hidden" value="<cfif isdefined("Form.CARcodigo")>#Form.CARcodigo#</cfif>">
	<input name="PEScodigo" type="hidden" value="<cfif isdefined("Form.PEScodigo")>#Form.PEScodigo#</cfif>">
	<input name="PBLsecuencia" type="hidden" value="<cfif isdefined("Form.PBLsecuencia")>#Form.PBLsecuencia#</cfif>">
	<cfif isdefined('form.modo') and form.modo NEQ 'MPborrar'>
		<input name="MPcodigo" type="hidden" value="<cfif isdefined("Form.MPcodigo")>#Form.MPcodigo#</cfif>">
	</cfif>
	<input name="Mcodigo" type="hidden" value="<cfif isdefined("Form.Mcodigo")>#Form.Mcodigo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	<input type="hidden" name="TabsPlan" value="3">
</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">
<!--- <cfparam name="session.xx2x" default="0">
<cfset session.xx2x = session.xx2x + 1>
alert("<cfoutput>#session.xx2x#</cfoutput>");
 --->
document.forms[0].submit();
</script>
</body>
</HTML>