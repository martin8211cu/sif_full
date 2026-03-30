<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.Nuevo") and not isdefined("Form.btnNuevoEnfasis")>
	<cftry>	
		<cftransaction>
		<cfquery name="abc_planestudio" datasource="#session.DSN#">
			set nocount on
			declare @id numeric
			<cfif isdefined("form.ALTA")>				
				insert PlanEstudios 
				(CARcodigo, PEScodificacion, PESnombre, CILcodigo, GAcodigo, PESestado, PESdesde)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CARcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PEScodificacion#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PESnombre#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GAcodigo#">, 
					0,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PESdesde,'YYYYMMDD')#">
				)
				
				select @id = @@identity

				delete PlanSede 
				where PEScodigo = @id
				
				<cfset Scodigos = ListToArray(Form.Scodigo,',')>
				<cfloop index="i" from="1" to="#ArrayLen(Scodigos)#">
					insert PlanSede (PEScodigo, Scodigo)
					values (@id, #Scodigos[i]#)
				</cfloop>
				<cfset modo = "LISTA">					
			<cfelseif isdefined("form.CAMBIO") >
				update PlanEstudios	set 
					PESnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PESnombre#">, 
					CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">,
					GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GAcodigo#">,
					PESdesde = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PESdesde,'YYYYMMDD')#">
					<cfif isdefined('form.PEShasta') and form.PEShasta NEQ ''>
						, PEShasta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PEShasta,'YYYYMMDD')#">
					<cfelse>
						, PEShasta = null
					</cfif>					
					<cfif isdefined('form.PESmaxima') and form.PESmaxima NEQ ''>
						, PESmaxima= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PESmaxima,'YYYYMMDD')#">					
					<cfelse>
						, PESmaxima= null
					</cfif>					
				where PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)			  

				<cfif isdefined('form.PEShasta') and form.PEShasta NEQ ''>
				update PlanEstudios	
				   set PESdesde = a.PEShasta
				from PlanEstudios vp, PlanEstudios a
				where a.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
				  and vp.PEScodigo = a.PEScodigoSiguiente
				</cfif>					

				delete PlanSede 
				where PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
				
				<cfset Scodigos = ListtoArray(Form.Scodigo,',')>
				<cfloop index="i" from="1" to="#ArrayLen(Scodigos)#">
					insert PlanSede (PEScodigo, Scodigo)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">, #Scodigos[i]#)
				</cfloop>

				<cfset modo = "CAMBIO">
			<cfelseif isdefined("form.BAJA")>
				delete PlanSede 
				where PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
			
				delete PlanEstudios 
				where PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">					  

				update PlanEstudios	
				   set PEScodigoSiguiente = null
				where PEScodigoSiguiente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
			<cfelseif isdefined("Form.btnPESActivar")>
				if (select count(MPcodigo)
					  from PlanEstudiosBloque pbl, MateriaPlan mp
					 where pbl.PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
					   and mp.PEScodigo    =* pbl.PEScodigo
					   and mp.PBLsecuencia =* pbl.PBLsecuencia
					   )>0
				update PlanEstudios
				   set PESestado = 1
				 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
				<cfset modo = "CAMBIO">
			<cfelseif isdefined("Form.btnPESInactivar")>
				update PlanEstudios
				   set PESestado = 0
				 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
				<cfset modo = "CAMBIO">
			<cfelseif isdefined("Form.btnPESCerrar")>
				update PlanEstudios
				   set PESestado = 2
				 where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
				<cfset modo = "CAMBIO">
			<cfelseif isdefined("Form.btnPESNuevaVersion")>
				<!---  Copiar todo el plan	--->
				insert PlanEstudios 
					(CARcodigo, PEScodificacion, PESnombre, CILcodigo, GAcodigo, PESestado, PESdesde, PESmaxima, PESbloques)
					Select CARcodigo, PEScodificacion, PESnombre + ' < Nueva Version >', CILcodigo, GAcodigo, 0, <cfoutput>'#LSDateFormat(Form.PEShasta,'yyyymmdd')#'</cfoutput>, PESmaxima, PESbloques
					from PlanEstudios
					where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
				
				declare @newPlan numeric
				select @newPlan=@@identity
				
				insert PlanSede 
					(PEScodigo, Scodigo)
					select @newPlan, Scodigo
					from PlanSede 
					where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">

				insert PlanEstudiosBloque 
					(PEScodigo, PBLsecuencia, PBLnombre)
					select @newPlan, PBLsecuencia, PBLnombre 
					from PlanEstudiosBloque
					where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">

				insert MateriaPlan 
					(PEScodigo, PBLsecuencia, MPsecuencia, Mcodigo, MPcodificacion, MPnombre)
					select @newPlan, PBLsecuencia, MPsecuencia, Mcodigo, MPcodificacion, MPnombre 
					from MateriaPlan
					where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">

				update PlanEstudios	set 
					PEScodigoSiguiente = @newPlan,
					PESdesde = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PESdesde,'YYYYMMDD')#">,
					PEShasta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PEShasta,'YYYYMMDD')#">
					<cfif isdefined('form.PESmaxima') and form.PESmaxima NEQ ''>
						, PESmaxima= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PESmaxima,'YYYYMMDD')#">					
					</cfif>
				where PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">

				<cfset modo = "CAMBIO">
			</cfif>
			set nocount off
		</cfquery>
		</cftransaction>
		<cfcatch type="any">
			<cfinclude template="../../errorpages/BDerror.cfm">		
			<cfabort>
		</cfcatch>
	</cftry>
<cfelseif isdefined("form.Nuevo")>
	<cfset modo = "ALTA">	
</cfif>

<cfoutput>
<form action="CarrerasPlanes.cfm" method="post">
	<input type="hidden" name="modo" value="#modo#">
	<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
		<cfif isdefined("Form.btnNuevoEnfasis")>
			<input type="hidden" name="nivel" value="#Val(Form.nivel)+1#">
		<cfelse>
			<input type="hidden" name="nivel" value="#Form.nivel#">
		</cfif>
	</cfif>
	<cfif isdefined("Form.EScodigo") and Len(Trim(Form.EScodigo)) NEQ 0>
		<input type="hidden" name="EScodigo" value="#Form.EScodigo#">
	</cfif>
	<cfif isdefined("Form.CARcodigo") and Len(Trim(Form.CARcodigo)) NEQ 0>
		<input type="hidden" name="CARcodigo" value="#Form.CARcodigo#">
	</cfif>
	<cfif modo neq 'ALTA' or isdefined("Form.btnNuevoEnfasis")>
		<input type="hidden" name="PEScodigo" value="#Form.PEScodigo#">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<!--- <cfdump var="#modo#">
<cfdump var="#form#"> --->

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

